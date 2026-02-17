/**
 * @file my_led.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2025-11-07
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#ifndef MY_LED
#define MY_LED

#include "stdio.h"
#include "em_device.h" // chứa định nghĩa thanh ghi EFR32MG24
#include "em_gpio.h"     // hàm tiện ích GPIO
#include "em_cmu.h"      // clock enable cho GPIO, EUSART
#include "app_log.h"
#include "sl_simple_led.h" // included "sl_led.h"

#ifdef __cplusplus
extern "C" {
#endif
    void delay_ms(uint32_t ms); 
    /** If you want to code bare-metal -> call LED0_1_Init() & LED0_Blink_bare_metal() */
    void LED0_1_Init();
    void LED0_Blink_bare_metal();

    /** If you want use em_lib -> call LED1_Blink_em_lib()*/
    void LED1_Blink_em_lib();

    /** If you want use platform/driver/leddrv/sl_led | sl_simple_led -> call LED0_sl_led() | LED0_sl_simple_led()*/
    extern const sl_led_t my_simple_led;
    void LED0_sl_led(const sl_led_t *my_LED);

    extern sl_simple_led_context_t my_simple_led_context;
    void LED0_sl_simple_led(sl_simple_led_context_t *led_context);

#ifdef __cplusplus
}
#endif

#endif
