/***************************************************************************//**
 * @file acmp_comp.h
 * @brief Analog Comparator (ACMP) module — minimal public API for EFR32MG24
 *
 * Compares internal VDAC0 CH0 voltage (POS input) against external pin PC06
 * (NEG input) with immediate switching and interrupt-driven event dispatch.
 ******************************************************************************/

#ifndef ACMP_COMP_H
#define ACMP_COMP_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ── Public API ──────────────────────────────────────────────────────────── */

/***************************************************************************//**
 * @brief Initialize ACMP0 peripheral:
 *        - POS Input: Internal VDAC0 Channel 0 (SL_HAL_ACMP_INPUT_VDACOUT0)
 *        - NEG Input: External Pin PC06 (SL_HAL_ACMP_INPUT_PC6)
 *        - Mode: High Accuracy, Hysteresis Disabled (instant switching)
 *        - Interrupts: RISE and FALL edge events enabled
 ******************************************************************************/
void acmp_comp_init(void);

/***************************************************************************//**
 * @brief Process ACMP event queue (non-blocking).
 *        Must be called periodically in the main loop (app_process_action).
 *        Logs state transition when ACMP output toggles between HIGH and LOW.
 ******************************************************************************/
void acmp_comp_process(void);

/***************************************************************************//**
 * @brief Get the current digital output state of ACMP0.
 * @return true if V_POS (DAC) > V_NEG (PC06) [Output = 1 / HIGH]
 *         false if V_NEG (PC06) > V_POS (DAC) [Output = 0 / LOW]
 ******************************************************************************/
bool acmp_comp_get_output(void);

#ifdef __cplusplus
}
#endif

#endif /* ACMP_COMP_H */
