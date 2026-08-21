/***************************************************************************//**
 * @file dac_out.c
 * @brief Dual-channel VDAC output module implementation for EFR32MG24
 *
 * - Channel 0: Outputs on PC06 via ABUS (CDEVEN0) -> ACMP0 NEGSEL
 * - Channel 1: Outputs on PA07 via ABUS (AODD1)   -> ACMP0 POSSEL
 * Clock: HFRCOEM23 → prescaled to 1 MHz.
 * Reference: 1.25V internal bandgap. Resolution: 12-bit (0.305 mV/step).
 ******************************************************************************/

#include "dac_out.h"
#include "em_vdac.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "app_log.h"

/* ── Private state ───────────────────────────────────────────────────────── */

static uint32_t _ch0_mv = DAC_OUT_CH0_DEFAULT_MV;
static uint32_t _ch1_mv = DAC_OUT_CH1_DEFAULT_MV;

/* ── Private helpers ─────────────────────────────────────────────────────── */

/**
 * @brief Convert millivolts to 12-bit DAC code.
 * @param[in] mv  Voltage in millivolts.
 * @return 12-bit DAC value (0–4095).
 */
static uint32_t _mv_to_dac_value(uint32_t mv)
{
  if (mv > DAC_OUT_VREF_MV) {
    mv = DAC_OUT_VREF_MV;
  }
  return (uint32_t)(((uint64_t)mv * DAC_OUT_RESOLUTION) / DAC_OUT_VREF_MV);
}

/**
 * @brief Helper to convert volts float to 12-bit DAC code.
 */
static uint32_t _volts_to_dac_value(float voltage_v)
{
  if (voltage_v < 0.0f) {
    voltage_v = 0.0f;
  }
  float vref = (float)DAC_OUT_VREF_MV / 1000.0f;
  if (voltage_v > vref) {
    voltage_v = vref;
  }
  return (uint32_t)((voltage_v * (float)DAC_OUT_RESOLUTION) / vref);
}

/* ── Public API ──────────────────────────────────────────────────────────── */

void dac_out_init(void)
{
  VDAC_Init_TypeDef init = VDAC_INIT_DEFAULT;

  /* 1. Disable digital buffers on PA07 and PC06 for pure analog mode */
  CMU_ClockEnable(cmuClock_GPIO, true);
  GPIO_PinModeSet(gpioPortA, 7, gpioModeDisabled, 0);
  GPIO_PinModeSet(gpioPortC, 6, gpioModeDisabled, 0);

  /*
   * 2. Allocate GPIO Analog Bus (ABUS):
   *    - VDAC0 CH1 on Port A Odd Pin 7 (PA07) -> AODD1
   *    - VDAC0 CH0 on Port C Even Pin 6 (PC06) -> CDEVEN0
   */
  GPIO->ABUSALLOC  |= GPIO_ABUSALLOC_AODD1_VDAC0CH1;
  GPIO->CDBUSALLOC |= GPIO_CDBUSALLOC_CDEVEN0_VDAC0CH0;

  /* 3. Clock VDAC0 from HFRCOEM23 */
  CMU_ClockSelectSet(cmuClock_VDAC0, cmuSelect_HFRCOEM23);
  CMU_ClockEnable(cmuClock_HFRCOEM23, true);
  CMU_ClockEnable(cmuClock_VDAC0, true);

  /* 4. Global VDAC0 Init */
  init.prescaler   = VDAC_PrescaleCalc(VDAC0, DAC_OUT_CLK_FREQ);
  init.onDemandClk = false;
  init.reference   = vdacRef1V25;
  VDAC_Init(VDAC0, &init);

  /* 5. Configure Channel 0 -> PC06 via ABUS */
  VDAC_InitChannel_TypeDef ch0_init = VDAC_INITCHANNEL_DEFAULT;
  ch0_init.mainOutEnable     = false;
  ch0_init.auxOutEnable      = true;
  ch0_init.port              = DAC_OUT_CH0_PIN_PORT;
  ch0_init.pin               = DAC_OUT_CH0_PIN_NUM;
  ch0_init.shortOutput       = false;
  ch0_init.highCapLoadEnable = false;
  ch0_init.powerMode         = vdacPowerModeLowPower;
  ch0_init.trigMode          = vdacTrigModeSw;
  ch0_init.sampleOffMode     = false;
  VDAC_InitChannel(VDAC0, &ch0_init, 0);
  VDAC_Enable(VDAC0, 0, true);

  /* 6. Configure Channel 1 -> PA07 via ABUS */
  VDAC_InitChannel_TypeDef ch1_init = VDAC_INITCHANNEL_DEFAULT;
  ch1_init.mainOutEnable     = false;
  ch1_init.auxOutEnable      = true;
  ch1_init.port              = DAC_OUT_CH1_PIN_PORT;
  ch1_init.pin               = DAC_OUT_CH1_PIN_NUM;
  ch1_init.shortOutput       = false;
  ch1_init.highCapLoadEnable = false;
  ch1_init.powerMode         = vdacPowerModeLowPower;
  ch1_init.trigMode          = vdacTrigModeSw;
  ch1_init.sampleOffMode     = false;
  VDAC_InitChannel(VDAC0, &ch1_init, 1);
  VDAC_Enable(VDAC0, 1, true);

  /* 7. Set default output voltages */
  _ch0_mv = DAC_OUT_CH0_DEFAULT_MV;
  _ch1_mv = DAC_OUT_CH1_DEFAULT_MV;
  uint32_t dac_val_ch0 = _mv_to_dac_value(_ch0_mv);
  uint32_t dac_val_ch1 = _mv_to_dac_value(_ch1_mv);
  VDAC_ChannelOutputSet(VDAC0, 0, dac_val_ch0);
  VDAC_ChannelOutputSet(VDAC0, 1, dac_val_ch1);

  /* 8. Log configuration summary */
  app_log_info("DAC_OUT: Dual-channel init OK\n");
  app_log_info("  CH0 (NEG): PC06 -> %lu mV (code %lu)\n",
               (unsigned long)_ch0_mv, (unsigned long)dac_val_ch0);
  app_log_info("  CH1 (POS): PA07 -> %lu mV (code %lu)\n",
               (unsigned long)_ch1_mv, (unsigned long)dac_val_ch1);
  app_log_info("  Vref: %u mV, Prescaler: %lu\n",
               DAC_OUT_VREF_MV, (unsigned long)init.prescaler);
}

void dac_out_set_voltage_ch0(float voltage_v)
{
  if (voltage_v < 0.0f) {
    voltage_v = 0.0f;
  }
  _ch0_mv = (uint32_t)(voltage_v * 1000.0f);
  if (_ch0_mv > DAC_OUT_VREF_MV) {
    _ch0_mv = DAC_OUT_VREF_MV;
  }
  uint32_t dac_value = _volts_to_dac_value(voltage_v);
  VDAC_ChannelOutputSet(VDAC0, 0, dac_value);
}

void dac_out_set_raw_ch0(uint32_t raw_value)
{
  if (raw_value > DAC_OUT_RESOLUTION) {
    raw_value = DAC_OUT_RESOLUTION;
  }
  _ch0_mv = (uint32_t)(((uint64_t)raw_value * DAC_OUT_VREF_MV) / DAC_OUT_RESOLUTION);
  VDAC_ChannelOutputSet(VDAC0, 0, raw_value);
}

void dac_out_set_voltage_ch1(float voltage_v)
{
  if (voltage_v < 0.0f) {
    voltage_v = 0.0f;
  }
  _ch1_mv = (uint32_t)(voltage_v * 1000.0f);
  if (_ch1_mv > DAC_OUT_VREF_MV) {
    _ch1_mv = DAC_OUT_VREF_MV;
  }
  uint32_t dac_value = _volts_to_dac_value(voltage_v);
  VDAC_ChannelOutputSet(VDAC0, 1, dac_value);
}

void dac_out_set_raw_ch1(uint32_t raw_value)
{
  if (raw_value > DAC_OUT_RESOLUTION) {
    raw_value = DAC_OUT_RESOLUTION;
  }
  _ch1_mv = (uint32_t)(((uint64_t)raw_value * DAC_OUT_VREF_MV) / DAC_OUT_RESOLUTION);
  VDAC_ChannelOutputSet(VDAC0, 1, raw_value);
}

uint32_t dac_out_get_voltage_ch0_mv(void)
{
  return _ch0_mv;
}

uint32_t dac_out_get_voltage_ch1_mv(void)
{
  return _ch1_mv;
}
