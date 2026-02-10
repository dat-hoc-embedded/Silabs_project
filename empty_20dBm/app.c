/***************************************************************************//**
 * @file
 * @brief Top level application functions
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

/***************************************************************************//**
 * Initialize application.
 ******************************************************************************/

#include "embeddat_gpio.h"
#include "embeddat_sleeptimer.h"  
#include <stdint.h> 

sl_simple_led_context_t led0 = {
    .port = gpioPortB,
    .pin = 2,
    .polarity = SL_SIMPLE_LED_POLARITY_ACTIVE_HIGH,
};

const sl_led_t sl_led0 = {
    .context = &led0,
    .init = sl_simple_led_init,
    .turn_on = sl_simple_led_turn_on,
    .turn_off = sl_simple_led_turn_off,
    .toggle = sl_simple_led_toggle,
    .get_state = sl_simple_led_get_state,
};

void app_init(void)
{
    embeddat_gpio_init();
    sl_simple_led_init(&led0);
    sl_sleeptimer_start(1000); // Start sleeptimer with 500ms timeout
}

/***************************************************************************//**
 * App ticking function.
 ******************************************************************************/
void app_process_action(void)
{
    static uint32_t cnt = 0;
    if (toogle_timeout == true){
        cnt++;
        if(cnt % 2 == 1){
            //embeddat_gpioB_blink(2, GPIO_STATE_TOGGLE);
            //embeddat_gpioB_simple_led(led0);
            embeddat_gpioB_sl_led((sl_led_t*)&sl_led0);
        }else
            embeddat_gpioB_blink(4, GPIO_STATE_TOGGLE);   
       
        toogle_timeout = false;
    }

}
