/***************************************************************************//**
 * @file dac_out.c
 * @brief Hardware Voltage DAC (VDAC0) Analog Output Generator Implementation.
 *******************************************************************************
 * # License
 * <b>Copyright 2026 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************/

#include "dac_out.h"
#include "em_vdac.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "app_log.h"

/* --------------------------------------------------------------------------
 * Private Constants
 * -------------------------------------------------------------------------- */

#define VDAC_REF_MV        3300UL
#define VDAC_MAX_VAL       4095UL

/* --------------------------------------------------------------------------
 * Private State
 * -------------------------------------------------------------------------- */

static uint16_t _current_mv[DAC_OUT_NUM_CHANNELS] = {
  DAC_OUT_CH0_PA5_DEFAULT_MV,
  DAC_OUT_CH1_PA6_DEFAULT_MV
};

/* --------------------------------------------------------------------------
 * Helper Functions
 * -------------------------------------------------------------------------- */

static uint32_t _mv_to_dac(uint16_t mv)
{
  uint32_t dac_val = ((uint32_t)mv * VDAC_MAX_VAL) / VDAC_REF_MV;
  if (dac_val > VDAC_MAX_VAL) {
    dac_val = VDAC_MAX_VAL;
  }
  return dac_val;
}

/* --------------------------------------------------------------------------
 * Public API
 * -------------------------------------------------------------------------- */

void dac_out_init(void)
{
  /* ── 1. Enable peripheral clocks ─────────────────────────────── */
  CMU_ClockEnable(cmuClock_VDAC0, true);
  CMU_ClockEnable(cmuClock_GPIO, true);

  /* ── 2. Configure output GPIO pins in disabled/analog mode ───── */
  /* PA5 for Channel 0 output, PA6 for Channel 1 output */
  GPIO_PinModeSet(gpioPortA, 5, gpioModeDisabled, 0);
  GPIO_PinModeSet(gpioPortA, 6, gpioModeDisabled, 0);

  /* ── 3. Allocate Port A Analog Bus (ABUSALLOC) for VDAC0 ────── */
  GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AODD0_VDAC0CH0; /* Route VDAC0 CH0 to PA5 */
  GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AEVEN1_VDAC0CH1; /* Route VDAC0 CH1 to PA6 */

  /* ── 4. Initialize VDAC0 global config ───────────────────────── */
  VDAC_Init_TypeDef init = VDAC_INIT_DEFAULT;
  init.reference = vdacRefAvdd;                      /* Use 3.3 V AVDD reference */
  init.prescaler = VDAC_PrescaleCalc(VDAC0, 1000000); /* Prescale clock to <= 1 MHz (VDAC max) */

  VDAC_Init(VDAC0, &init);

  /* ── 5. Initialize Channel 0 (PA5) ───────────────────────────── */
  VDAC_InitChannel_TypeDef ch0_init = VDAC_INITCHANNEL_DEFAULT;
  ch0_init.enable        = true;
  ch0_init.mainOutEnable = true;
  ch0_init.port          = vdacChPortA;
  ch0_init.pin           = 5;

  VDAC_InitChannel(VDAC0, &ch0_init, 0);

  /* ── 6. Initialize Channel 1 (PA6) ───────────────────────────── */
  VDAC_InitChannel_TypeDef ch1_init = VDAC_INITCHANNEL_DEFAULT;
  ch1_init.enable        = true;
  ch1_init.mainOutEnable = true;
  ch1_init.port          = vdacChPortA;
  ch1_init.pin           = 6;

  VDAC_InitChannel(VDAC0, &ch1_init, 1);

  /* ── 7. Enable channels explicitly ───────────────────────────── */
  VDAC_Enable(VDAC0, 0, true);
  VDAC_Enable(VDAC0, 1, true);

  /* ── 8. Set initial default target voltages ──────────────────── */
  dac_out_set_mv(0, DAC_OUT_CH0_PA5_DEFAULT_MV);
  dac_out_set_mv(1, DAC_OUT_CH1_PA6_DEFAULT_MV);

  app_log_info("VDAC0: Init OK — PA5=917 mV (Ch0), PA6=937 mV (Ch1)\n");
}

void dac_out_set_mv(uint8_t channel, uint16_t mv)
{
  if (channel >= DAC_OUT_NUM_CHANNELS) {
    return;
  }

  _current_mv[channel] = mv;
  uint32_t dac_val = _mv_to_dac(mv);

  VDAC_ChannelOutputSet(VDAC0, channel, dac_val);
}
