#pragma once

#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#include <iostream>
}
#endif
#include "sl_simple_led.h"

// GPIO pin modes
#define GPIO_BASE_ADDR  GPIO_NS // Input mode

// GPIO pin states
typedef enum {
    GPIO_STATE_LOW = 0,
    GPIO_STATE_HIGH = 1,
    GPIO_STATE_TOGGLE = 2,
} GPIO_State;

// Function prototypes
void embeddat_gpio_init();
void embeddat_gpioB_blink(uint8_t pin, GPIO_State mode);
void embeddat_gpioB_emlib(uint8_t pin, GPIO_State mode);
void embeddat_gpioB_simple_led(sl_simple_led_context_t led_context);
void embeddat_gpioB_sl_led(sl_led_t* led_handle);

