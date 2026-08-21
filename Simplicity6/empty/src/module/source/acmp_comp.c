/***************************************************************************//**
 * @file acmp_comp.c
 * @brief Analog Comparator (ACMP) module implementation for EFR32MG24
 *
 * Compares internal VDAC0 CH0 output (POS) against PC06 (NEG).
 * - POS: SL_HAL_ACMP_INPUT_VDACOUT0 (Internal interconnect, no wire needed)
 * - NEG: SL_HAL_ACMP_INPUT_PC6 (Expansion Header Pin 13 / WSTK_P33)
 * - Accuracy: High Accuracy (low input offset)
 * - Hysteresis: Disabled (instant switching when V_NEG > V_POS)
 * - Interrupts: Enabled on RISE and FALL edges
 ******************************************************************************/

#include "acmp_comp.h"
#include "sl_hal_acmp.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "sl_core.h"
#include "app_log.h"

/* ── Private state ───────────────────────────────────────────────────────── */

static volatile bool _event_pending     = false;
static volatile bool _last_output_state = false;

/* ── Public API ──────────────────────────────────────────────────────────── */

void acmp_comp_init(void)
{
  /* 1. Enable clocks for ACMP0 and GPIO */
  CMU_ClockEnable(cmuClock_ACMP0, true);
  CMU_ClockEnable(cmuClock_GPIO, true);

  /* 2. Disable digital input/output buffer on PA07 and PC06 (pure analog input mode) */
  GPIO_PinModeSet(gpioPortA, 7, gpioModeDisabled, 0);
  GPIO_PinModeSet(gpioPortC, 6, gpioModeDisabled, 0);

  /*
   * CRITICAL: Allocate GPIO Analog Bus channels for ACMP0 inputs.
   *
   * On EFR32 Series 2, analog peripherals (ACMP, ADC, VDAC) cannot
   * read/drive GPIO pins through the ABUS unless the bus is explicitly
   * allocated to the peripheral in the GPIO->xBUSALLOC registers.
   * Without this step, the ACMP inputs are floating/disconnected and
   * the comparator output will be stuck LOW or undefined.
   *
   * Bus allocation rules:
   *   Port A Even pins → GPIO->ABUSALLOC  (AEVEN0/AEVEN1)
   *   Port A Odd  pins → GPIO->ABUSALLOC  (AODD0/AODD1)
   *   Port B Even pins → GPIO->BBUSALLOC  (BEVEN0/BEVEN1)
   *   Port B Odd  pins → GPIO->BBUSALLOC  (BODD0/BODD1)
   *   Port C/D Even    → GPIO->CDBUSALLOC (CDEVEN0/CDEVEN1)
   *   Port C/D Odd     → GPIO->CDBUSALLOC (CDODD0/CDODD1)
   *
   * For PA07 (POS, odd pin):  ABUSALLOC.AODD0   = ACMP0 (VDAC0CH1 uses AODD1)
   * For PC06 (NEG, even pin): CDBUSALLOC.CDEVEN1 = ACMP0 (VDAC0CH0 uses CDEVEN0)
   */
  GPIO->ABUSALLOC   |= GPIO_ABUSALLOC_AODD0_ACMP0;
  GPIO->CDBUSALLOC  |= GPIO_CDBUSALLOC_CDEVEN1_ACMP0;

  /* 
   * 3. Initialize ACMP0 with high-accuracy, zero hysteresis configuration:
   *    - bias_prog = 4: standard fast bias for low propagation delay (<1 µs)
   *    - input_range = FULL: 0 to VDD (3.3V) common mode range
   *    - accuracy = HIGH: trimmed low offset voltage (<5 mV)
   *    - hysteresis_rise / fall = DISABLED: zero deadband instant switching
   *    - inactive_value = false: output LOW during startup warmup
   */
  sl_hal_acmp_init_t init = {
    .bias_prog       = 4,
    .vref_div        = 0,
    .input_range     = SL_HAL_ACMP_INPUT_RANGE_FULL,
    .accuracy        = SL_HAL_ACMP_ACCURACY_HIGH,
#if defined(_ACMP_CFG_HYSTRISE_MASK)
    .hysteresis_rise = SL_HAL_ACMP_HYSTERESIS_DISABLED,
    .hysteresis_fall = SL_HAL_ACMP_HYSTERESIS_DISABLED,
#else
    .hysteresis      = SL_HAL_ACMP_HYSTERESIS_DISABLED,
#endif
    .inactive_value  = false,
  };

  sl_hal_acmp_init(ACMP0, &init);

  /* 4. Enable the ACMP module */
  sl_hal_acmp_enable(ACMP0);

  /* 
   * 5. Set input channels:
   *    - Negative input: PC06 (external analog voltage on WSTK_P33)
   *    - Positive input: PA07 (DAC voltage routed on EXP Header Pin 13)
   */
  sl_hal_acmp_set_input(ACMP0, SL_HAL_ACMP_INPUT_PC6, SL_HAL_ACMP_INPUT_PA7);

  /* 6. Wait for warm-up synchronization */
  sl_hal_acmp_wait_ready(ACMP0);

  /* 7. Read initial comparator output state */
  _last_output_state = (ACMP0->STATUS & ACMP_STATUS_ACMPOUT) != 0;

  /* 8. Clear pending interrupts and enable ACMP0 interrupt vector */
  NVIC_ClearPendingIRQ(ACMP0_IRQn);
  sl_hal_acmp_clear_interrupts(ACMP0, ACMP_IF_RISE | ACMP_IF_FALL);
  NVIC_EnableIRQ(ACMP0_IRQn);
  sl_hal_acmp_enable_interrupts(ACMP0, ACMP_IEN_RISE | ACMP_IEN_FALL);

  /* 9. Log configuration & initial status */
  app_log_info("ACMP0: init OK\n");
  app_log_info("  POS Input: PA07 (EXP Header Pin 13 via ABUS)\n");
  app_log_info("  NEG Input: PC06 (WSTK_P33)\n");
  app_log_info("  Accuracy:  HIGH, Hysteresis: DISABLED\n");
  app_log_info("  Initial Output: %u (%s) -> %s\n",
               (unsigned int)_last_output_state,
               _last_output_state ? "HIGH" : "LOW",
               _last_output_state ? "V_POS (PA07) > V_NEG (PC06)" : "V_NEG (PC06) > V_POS (PA07)");
}

void acmp_comp_process(void)
{
  bool has_event = false;
  bool current_state = false;

  /* Safely copy event flag from ISR context */
  CORE_DECLARE_IRQ_STATE;
  CORE_ENTER_ATOMIC();
  if (_event_pending) {
    has_event = true;
    _event_pending = false;
    current_state = _last_output_state;
  }
  CORE_EXIT_ATOMIC();

  /* Log event outside atomic section */
  if (has_event) {
    if (current_state) {
      app_log_info("[ACMP EVENT] Threshold Crossed: V_POS (DAC) > V_NEG (PC06) | Output: HIGH (1)\n");
    } else {
      app_log_info("[ACMP EVENT] ThresholdCrossed: V_NEG (PC06) > V_POS (DAC) | Output: LOW  (0)\n");
    }
  }
}

bool acmp_comp_get_output(void)
{
  return (ACMP0->STATUS & ACMP_STATUS_ACMPOUT) != 0;
}

/* ── Interrupt Service Routine ────────────────────────────────────────────── */

/***************************************************************************//**
 * @brief ACMP0 Interrupt Handler
 ******************************************************************************/
void ACMP0_IRQHandler(void)
{
  uint32_t flags = sl_hal_acmp_get_enabled_pending_interrupts(ACMP0);

  /* Clear active interrupt flags */
  sl_hal_acmp_clear_interrupts(ACMP0, flags);

  /* Update current state and notify processing task */
  _last_output_state = (ACMP0->STATUS & ACMP_STATUS_ACMPOUT) != 0;
  _event_pending     = true;
}
