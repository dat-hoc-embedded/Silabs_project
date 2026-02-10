/**
 * @file zmy_led.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2026-01-08
 * 
 * @copyright Copyright (c) 2026
 * 
 */
#ifndef ZMY_LED_H
#define ZMY_LED_H

#include "sl_simple_led.h"

/*******************************************************************************
 *******************************   DEFINES   ***********************************
 ******************************************************************************/
extern const sl_led_t embeddat_led1;

void sl_embeddat_led1_init(void);

#endif // ZMY_LED_H

