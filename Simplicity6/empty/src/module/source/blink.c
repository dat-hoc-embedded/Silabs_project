/**
 * @file blink.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief
 * @version 0.1
 * @date 2026-07-22
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


sl_sleeptimer_timer_handle_t timer;
static void on_time(sl_sleeptimer_timer_handle_t *handle, void *data);
volatile bool toggle_timeout = false;

#define TOGGLE_BLINK 500

void blink_init() {
  sl_status_t sc = sl_sleeptimer_start_periodic_timer_ms(
      &timer, TOGGLE_BLINK, on_time, NULL, 1,
      SL_SLEEPTIMER_NO_HIGH_PRECISION_HF_CLOCKS_REQUIRED_FLAG);

  if (sc != SL_STATUS_OK) {
    app_log_info("Initialize sleeptimer failed! \n");
  }
}

void blink_process() {
  if (toggle_timeout == true) {
    sl_led_toggle(&sl_led_led0);
    toggle_timeout = false;
    app_log_info("Status of LED = %d", sl_led_get_state(&sl_led_led0));
  }
}

void on_time(sl_sleeptimer_timer_handle_t *handle, void *data) {
  (void)&handle;
  (void)&data;
  toggle_timeout = true;
}