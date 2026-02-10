/**
 * @file app_tcp_led.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief  
 * @version 0.1
 * @date 2025-12-29
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#pragma once
#ifndef APP_TCP_LED_H
#define APP_TCP_LED_H

#include <string.h>
#include <stdio.h>
#include <stdbool.h>

#include "openthread/instance.h"
#include "openthread/ip6.h"
#include "openthread/platform/logging.h"
#include "openthread/tcp.h"

#include "sl_led.h"
#include "sl_simple_led_instances.h"

#define APP_TCP_PORT 2602

void tcp_led_init(otInstance *aInstance);



#endif /* APP_TCP_LED_H */
