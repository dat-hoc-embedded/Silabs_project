/**
 * @file gpio.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief Driver for GPIO initialization. sets up GPIO pins for input/output as needed.
 * @version 0.1
 * @date 2025-11-23
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#include "embeddat_gpio.h" // Include own header
#include "registerAddress.h"
#include "em_device.h" // Include emlib device header
#include "em_gpio.h" // Include emlib GPIO header 
#include "em_cmu.h" // Include emlib Clock Management Unit header

/**
 * @brief Initialize GPIO pins for LED0 & LED1 control.
 * 
 */
void embeddat_gpio_init()
{
  CMU->CLKEN0_SET = CMU_CLKEN0_GPIO; // Enable clock for GPIO module
  GPIO->P[1].MODEL &= ~_GPIO_P_MODEL_MODE2_MASK;  // Clear MODEL MODE2
  GPIO->P[1].MODEL |= GPIO_P_MODEL_MODE2_PUSHPULL; // Set Push Pull Output for LED0 (PB2)

  GPIO->P[1].MODEL &= ~_GPIO_P_MODEL_MODE4_MASK; // Clear MODEL MODE4
  GPIO->P[1].MODEL |= GPIO_P_MODEL_MODE4_PUSHPULL; // Set Push Pull Output for LED1 (PB4)
}

/**
 * @brief  Control GPIO pin B
 * 
 * @param pin  : Pin number
 * @param mode : GPIO_State (HIGH, LOW, TOGGLE)
 */
void embeddat_gpioB_blink(uint8_t pin, GPIO_State mode)
{
    // GPIO is pointer to GPIO peripheral base address. 
    uint32_t *reg = &GPIO -> P[1].DOUT;
    if (mode == GPIO_STATE_HIGH) {
        *reg |= 1UL << pin;
    } else if (mode == GPIO_STATE_LOW) {
        GPIO->P[1].DOUT &= ~(1UL << pin);
    }
    else if (mode == GPIO_STATE_TOGGLE) {
        *reg ^= 1UL << pin;
    }
}

/**
 * @brief  Use emlib functions to control GPIO pin B
 * 
 * @param pin : Pin number
 * @param mode : GPIO_State (HIGH, LOW, TOGGLE)
 */
void embeddat_gpioB_emlib(uint8_t pin, GPIO_State mode){
    if (mode == GPIO_STATE_HIGH){
        GPIO_PinOutSet(gpioPortB, pin);
    }
    else if(mode == GPIO_STATE_LOW){
        GPIO_PinOutClear(gpioPortB, pin);
    }else if(mode == GPIO_STATE_TOGGLE){
        GPIO_PinOutToggle(gpioPortB, pin);
    }
}

/**
 * @brief Using sl_simple_led to toggle LED 
 * 
 * @param led_context : struct of sl_simple_led_context_t {port, pin, polarity}
 */
void embeddat_gpioB_simple_led(sl_simple_led_context_t led_context){
    
    sl_simple_led_toggle(&led_context);

}

/**
 * @brief  Using sl_led_t to toggle LED
 * 
 * @param led_handle : Pointer to instance of struct sl_led_t to toggle
 * @note sl_led_t contains function pointers () and context for the LED
 */
void embeddat_gpioB_sl_led(sl_led_t* led_handle)
{
    sl_simple_led_context_t *led_context = led_handle->context;
    // led_handle->init(led_context);
    led_handle->toggle(led_context);
}
