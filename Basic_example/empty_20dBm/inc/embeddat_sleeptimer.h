/**
 * @file embeddat_sleeptimer.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief : Header file for sleeptimer functions
 * @version 0.1
 * @date 2025-11-23
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#pragma once
#include <stdint.h>
#include <stdbool.h>
#include "sl_status.h"
#include "sl_sleeptimer.h"

extern volatile bool toogle_timeout; 
void embeddat_sleeptimer_init();
sl_status_t sl_sleeptimer_start(uint32_t timeout_ms);
static void sleeptimer_callback(sl_sleeptimer_timer_handle_t *handle, void *data);
static void sleeptimer_callback2(sl_sleeptimer_timer_handle_t *handle, void *data);