/**
 * @file app_udp_led.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2025-12-25
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#pragma once // Use once to avoid multiple inclusions
#ifndef APP_UDP_LED_H
#define APP_UDP_LED_H

#include "sl_led.h"
#include "sl_simple_led.h"
#include "sl_simple_led_instances.h"

#include "app.h"

#include "openthread/udp.h" // UDP API: otUdpSocket, otUdpOpen, otUdpBind, otUdpSend, otUdpNewMessage
#include "openthread/message.h" // otMessage, otMessageRead
#include "openthread/platform/logging.h" // otLogInfo
#include "openthread/ip6.h"
#include "openthread/instance.h"

#include "stdio.h"
#include "string.h"

// sl_simple_led_context_t sl_simple_led_led0_context;
// sl_led_t sl_led_led0;

extern void led_init(void);
extern void udp_led_toggle(void);

void Udp_led_init(otInstance *aInstance, uint16_t localport);
void HandleUdpReceive(void *aContext, otMessage *aMessage, const otMessageInfo *aMessageInfo);


#endif // APP_UDP_LED_H