/**
 * @file blink.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief LED blink module — timer-based toggling with BLE control API.
 *
 * Uses sl_sleeptimer for periodic LED toggling. The blink interval
 * and LED state can be changed at runtime via the BLE GATT interface
 * (see ble_app.c).
 *
 * @version 0.2
 * @date 2026-08-05
 *
 * @copyright Copyright (c) 2026
 *
 */

#include "blink.h"
#include "app_log.h"
#include "sl_led.h"
#include "sl_simple_led_instances.h"
#include "sl_sleeptimer.h"
#include "sl_status.h"

/* --------------------------------------------------------------------------
 * Private state
 * -------------------------------------------------------------------------- */

/** Default blink interval in milliseconds. */
#define BLINK_DEFAULT_INTERVAL_MS  500

/** Current blink interval (modifiable via BLE). */
static uint16_t _blink_interval_ms = BLINK_DEFAULT_INTERVAL_MS;

/** Sleeptimer handle for the blink timer. */
static sl_sleeptimer_timer_handle_t _timer;

/** Flag set by ISR when the timer fires. */
static volatile bool _toggle_timeout = false;

/* --------------------------------------------------------------------------
 * Timer callback (ISR context — keep minimal)
 * -------------------------------------------------------------------------- */

static void _on_timer(sl_sleeptimer_timer_handle_t *handle, void *data)
{
  (void)handle;
  (void)data;
  _toggle_timeout = true;
}

/**
 * @brief (Re)start the blink timer with the current interval.
 */
static void _restart_timer(void)
{
  /* Stop any existing timer first. */
  sl_sleeptimer_stop_timer(&_timer);

  sl_status_t sc = sl_sleeptimer_start_periodic_timer_ms(
      &_timer,
      _blink_interval_ms,
      _on_timer,
      NULL,
      1,
      SL_SLEEPTIMER_NO_HIGH_PRECISION_HF_CLOCKS_REQUIRED_FLAG);

  if (sc != SL_STATUS_OK) {
    app_log_info("Blink: timer start failed (0x%04lx)\n", (unsigned long)sc);
  }
}

/* --------------------------------------------------------------------------
 * Public API — Init / Process
 * -------------------------------------------------------------------------- */

void blink_init(void)
{
  _restart_timer();
}

void blink_process(void)
{
  if (_toggle_timeout) {
    _toggle_timeout = false;
    sl_led_toggle(&sl_led_led0);
  }
}

/* --------------------------------------------------------------------------
 * Public API — BLE control functions
 * -------------------------------------------------------------------------- */

uint8_t blink_get_led_state(void)
{
  return (uint8_t)sl_led_get_state(&sl_led_led0);
}

void blink_set_led_state(bool on)
{
  if (on) {
    sl_led_turn_on(&sl_led_led0);
  } else {
    sl_led_turn_off(&sl_led_led0);
  }
}

void blink_toggle_led(void)
{
  sl_led_toggle(&sl_led_led0);
}

uint16_t blink_get_interval_ms(void)
{
  return _blink_interval_ms;
}

void blink_set_interval_ms(uint16_t interval_ms)
{
  _blink_interval_ms = interval_ms;
  _restart_timer();
  app_log_info("Blink: interval changed to %u ms\n", interval_ms);
}