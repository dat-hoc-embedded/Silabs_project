/**
 * @file blink.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief LED blink module — public API for LED control and BLE integration.
 * @version 0.2
 * @date 2026-08-05
 *
 * @copyright Copyright (c) 2026
 *
 */
#ifndef BLINK_H
#define BLINK_H

#include <stdint.h>
#include <stdbool.h>

/** Initialize blink timer and LED. */
void blink_init(void);

/** Process blink timer events (call from app_process_action). */
void blink_process(void);

/* ── BLE control API ──────────────────────────────────────────── */

/**
 * @brief Get the current LED state.
 * @return 1 if LED is ON, 0 if OFF.
 */
uint8_t blink_get_led_state(void);

/**
 * @brief Set the LED state directly.
 * @param on  true = turn ON, false = turn OFF.
 */
void blink_set_led_state(bool on);

/**
 * @brief Toggle the LED state.
 */
void blink_toggle_led(void);

/**
 * @brief Get the current blink interval in milliseconds.
 * @return Interval in ms.
 */
uint16_t blink_get_interval_ms(void);

/**
 * @brief Set a new blink interval. Restarts the timer.
 * @param interval_ms  New interval in milliseconds (50–10000).
 */
void blink_set_interval_ms(uint16_t interval_ms);

#endif /* BLINK_H */

