/**
 * @file iadc_adc.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief IADC scan module — timer-triggered 2-channel ADC with serial logging.
 *
 * Configures IADC0 in scan mode with the local timer triggering at 1 kHz.
 * Two single-ended channels (PA3, PA4 vs GND) are sampled each scan cycle.
 * Results are converted to millivolts and logged at 10 Hz via app_log.
 *
 * Hardware:
 *   - PA3 → IADC scan entry 0 (Port A, odd pin  → ABUSALLOC AODD0)
 *   - PA4 → IADC scan entry 1 (Port A, even pin → ABUSALLOC AEVEN0)
 *   - Reference: AVDD (3.3 V on BRD4187C)
 *   - Resolution: 12-bit, no oversampling
 *
 * @version 0.1
 * @date 2026-08-07
 *
 * @copyright Copyright (c) 2026
 *
 */

#include "iadc_adc.h"
#include "em_iadc.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "app_log.h"
#include "sl_power_manager.h"

/* --------------------------------------------------------------------------
 * Private constants
 * -------------------------------------------------------------------------- */

/** Target CLK_SRC_ADC frequency (40 MHz max for Series 2). */
#define CLK_SRC_ADC_FREQ    40000000UL

/** Target CLK_ADC frequency (10 MHz max in normal mode). */
#define CLK_ADC_FREQ        10000000UL

/** Desired scan trigger frequency in Hz. */
#define IADC_TRIGGER_FREQ   1000UL

/** Log decimation factor — print every Nth scan (100 = 10 Hz). */
#define LOG_DECIMATION      100U

/** AVDD reference voltage in millivolts. */
#define VREF_MV             3300UL

/** Maximum 12-bit ADC count. */
#define ADC_MAX_COUNT       4095UL

/* --------------------------------------------------------------------------
 * Private state
 * -------------------------------------------------------------------------- */

/** Flag set by ISR when a complete scan table is done. */
static volatile bool _scan_complete = false;

/** Latest converted readings in millivolts [0]=PA3, [1]=PA4. */
static uint16_t _latest_mv[IADC_ADC_NUM_CHANNELS] = {0};

/** Scan counter for log decimation. */
static uint32_t _scan_count = 0;

/* --------------------------------------------------------------------------
 * Private helpers
 * -------------------------------------------------------------------------- */

/**
 * @brief Convert a 12-bit raw ADC value to millivolts (Vref = AVDD 3.3V, Gain = 1x).
 *
 * Full Scale Range (FSR) = 3300 mV.
 * Formula: mV = (raw_data * 3300) / 4095
 *
 * @param raw_data  12-bit right-aligned ADC result (0–4095).
 * @return Voltage in millivolts (0–3300).
 */
static uint16_t _raw_to_mv(uint32_t raw_data)
{
  return (uint16_t)((raw_data * VREF_MV) / ADC_MAX_COUNT);
}

/* --------------------------------------------------------------------------
 * ISR — keep minimal (set flag, return)
 * -------------------------------------------------------------------------- */

/**
 * @brief IADC interrupt handler.
 *
 * Fires on scan table completion (all 2 channels sampled).
 * Only sets a flag — actual FIFO reading is done in iadc_adc_process().
 */
void IADC_IRQHandler(void)
{
  /* Clear the scan-table-done interrupt flag. */
  IADC_clearInt(IADC0, IADC_IF_SCANTABLEDONE);

  _scan_complete = true;
}

/* --------------------------------------------------------------------------
 * Public API — Init
 * -------------------------------------------------------------------------- */

void iadc_adc_init(void)
{
  /* ── 1. Enable IADC0 peripheral clock ────────────────────────── */
  CMU_ClockEnable(cmuClock_IADC0, true);

  /* Reset IADC to known state. */
  IADC_reset(IADC0);

  /* ── 2. Calculate clock prescalers ───────────────────────────── */

  /*
   * Get the IADC clock source frequency (fed from EM01GRPACLK by default,
   * which is typically HFXO = 39 MHz on BRD4187C).
   */
  uint32_t iadc_clk_freq = CMU_ClockFreqGet(cmuClock_IADCCLK);

  /* IADC_Init_t — global configuration. */
  IADC_Init_t init = IADC_INIT_DEFAULT;
  init.warmup = iadcWarmupKeepWarm; /* Keep reference & ADC powered up continuously for stability */

  /*
   * Prescale the source clock to ≤ 40 MHz.
   * IADC_calcSrcClkPrescale returns the smallest prescale such that
   * CLK_SRC_ADC ≤ CLK_SRC_ADC_FREQ.
   * Pass 0 for srcClkFreq to let the function read CMU internally.
   */
  init.srcClkPrescale = IADC_calcSrcClkPrescale(IADC0, CLK_SRC_ADC_FREQ, 0);

  /*
   * Configure the local timer for 1 kHz trigger.
   * timerCycles counts in CLK_SRC_ADC ticks.
   * Actual CLK_SRC_ADC = iadc_clk_freq / (srcClkPrescale + 1).
   */
  uint32_t src_clk_actual = iadc_clk_freq / (init.srcClkPrescale + 1);
  init.timerCycles = src_clk_actual / IADC_TRIGGER_FREQ;

  /* ── 3. ADC configuration (reference, resolution, prescaler) ── */

  IADC_AllConfigs_t all_configs = IADC_ALLCONFIGS_DEFAULT;

  /* Use AVDD (3.3V) reference with 1x gain (0–3.3V range). */
  all_configs.configs[0].reference  = iadcCfgReferenceVddx;
  all_configs.configs[0].vRef       = 3300;                    /* Explicitly set Vref magnitude to 3300 mV */
  all_configs.configs[0].adcMode    = iadcCfgModeNormal;
  all_configs.configs[0].osrHighSpeed = iadcCfgOsrHighSpeed16x; /* 16x hardware oversampling */
  all_configs.configs[0].analogGain = iadcCfgAnalogGain1x;
  all_configs.configs[0].digAvg     = iadcDigitalAverage8;     /* 8x hardware digital averaging */

  /* Prescale CLK_ADC to ≤ 10 MHz (max for normal mode). */
  all_configs.configs[0].adcClkPrescale = IADC_calcAdcClkPrescale(
      IADC0,
      CLK_ADC_FREQ,
      0,                        /* 0 = read CMU internally */
      iadcCfgModeNormal,
      init.srcClkPrescale);

  /* ── 4. Scan mode configuration ──────────────────────────────── */

  IADC_InitScan_t init_scan = IADC_INITSCAN_DEFAULT;
  init_scan.triggerSelect  = iadcTriggerSelTimer;       /* Local timer trigger */
  init_scan.triggerAction = iadcTriggerActionOnce;      /* Trigger once per timer event */
  init_scan.dataValidLevel = iadcFifoCfgDvl2;           /* IRQ when 2 results ready */
  init_scan.fifoDmaWakeup  = false;                     /* No DMA */
  init_scan.showId         = true;                      /* Include scan table ID in result */
  init_scan.start          = true;                      /* Enable scan queue to accept timer triggers */

  /* ── 5. Scan table — 2 single-ended channels ─────────────────── */

  IADC_ScanTable_t scan_table = IADC_SCANTABLE_DEFAULT;

  /* Entry 0: PA3 (positive) vs GND (negative). */
  scan_table.entries[0].posInput      = iadcPosInputPortAPin3;
  scan_table.entries[0].negInput      = iadcNegInputGnd;
  scan_table.entries[0].includeInScan = true;

  /* Entry 1: PA4 (positive) vs GND (negative). */
  scan_table.entries[1].posInput      = iadcPosInputPortAPin4;
  scan_table.entries[1].negInput      = iadcNegInputGnd;
  scan_table.entries[1].includeInScan = true;

  /* ── 6. Initialize IADC hardware ─────────────────────────────── */

  IADC_init(IADC0, &init, &all_configs);
  IADC_initScan(IADC0, &init_scan, &scan_table);

  /* ── 7. Enable GPIO clock, configure pins & allocate ABUS ────── */

  CMU_ClockEnable(cmuClock_GPIO, true);

  /* Configure PA3 and PA4 as disabled (high-impedance analog inputs) */
  GPIO_PinModeSet(gpioPortA, 3, gpioModeDisabled, 0);
  GPIO_PinModeSet(gpioPortA, 4, gpioModeDisabled, 0);

  /*
   * Port A pins require ABUSALLOC:
   *   PA3 = odd  pin → AODD0_ADC0
   *   PA4 = even pin → AEVEN0_ADC0
   */
  GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AODD0_ADC0;
  GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AEVEN0_ADC0;

  /* ── 8. Enable interrupt & Power Manager EM1 Requirement ─────── */

  /* Keep HF clock active so IADC local timer runs continuously in sleep */
  sl_power_manager_add_em_requirement(SL_POWER_MANAGER_EM1);

  IADC_clearInt(IADC0, _IADC_IF_MASK);
  IADC_enableInt(IADC0, IADC_IF_SCANTABLEDONE);
  NVIC_ClearPendingIRQ(IADC_IRQn);
  NVIC_EnableIRQ(IADC_IRQn);

  /* ── 9. Start scan queue & local timer → conversions begin ────── */

  IADC_command(IADC0, iadcCmdStartScan | iadcCmdEnableTimer);

  app_log_info("IADC: Init OK — PA3+PA4, 1 kHz, AVDD Ref 3.3V, 1x Gain\n");
}

/* --------------------------------------------------------------------------
 * Public API — Process (call from app_process_action)
 * -------------------------------------------------------------------------- */

void iadc_adc_process(void)
{
  if (!_scan_complete) {
    return;
  }
  _scan_complete = false;

  IADC_Result_t result0 = IADC_pullScanFifoResult(IADC0);
  IADC_Result_t result1 = IADC_pullScanFifoResult(IADC0);

  if (result0.id == IADC_ADC_CH_PA3) {
    _latest_mv[IADC_ADC_CH_PA3] = _raw_to_mv(result0.data);
    _latest_mv[IADC_ADC_CH_PA4] = _raw_to_mv(result1.data);
  } else {
    _latest_mv[result0.id] = _raw_to_mv(result0.data);
    _latest_mv[result1.id] = _raw_to_mv(result1.data);
  }

  _scan_count++;
  if (_scan_count >= LOG_DECIMATION) {
    _scan_count = 0;
    app_log_info("IADC: PA3=%u mV (raw=%u), PA4=%u mV (raw=%u)\n",
                 _latest_mv[IADC_ADC_CH_PA3], (unsigned int)result0.data,
                 _latest_mv[IADC_ADC_CH_PA4], (unsigned int)result1.data);
  }
}

/* --------------------------------------------------------------------------
 * Public API — Getter
 * -------------------------------------------------------------------------- */

uint16_t iadc_adc_get_mv(uint8_t channel)
{
  if (channel >= IADC_ADC_NUM_CHANNELS) {
    return 0;
  }
  return _latest_mv[channel];
}
