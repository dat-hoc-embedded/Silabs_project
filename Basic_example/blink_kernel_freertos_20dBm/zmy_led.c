/**
 * @file zmy_led.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2026-01-08
 * 
 * @copyright Copyright (c) 2026
 * 
 */

#include "sl_simple_led.h"
#include "sl_gpio.h"

sl_simple_led_context_t embeddat_led1_context = {
  .port = SL_GPIO_PORT_B,
  .pin = 4,
  .polarity = SL_SIMPLE_LED_POLARITY_ACTIVE_HIGH,
};
const sl_led_t embeddat_led1 = {
  .context = &embeddat_led1_context,
  .init = sl_simple_led_init,
  .turn_on = sl_simple_led_turn_on,
  .turn_off = sl_simple_led_turn_off,
  .toggle = sl_simple_led_toggle,
  .get_state = sl_simple_led_get_state,
};

void sl_embeddat_led1_init(void)
{
  sl_led_init(&embeddat_led1);
}

