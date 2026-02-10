/*******************************************************************************
 * @file
 * @brief Application interface provided to main().
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * SPDX-License-Identifier: Zlib
 *
 * The licensor of this software is Silicon Laboratories Inc.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 ******************************************************************************/

#ifndef APP_H
#define APP_H

#if defined(SL_COMPONENT_CATALOG_PRESENT)
#include "sl_component_catalog.h"
#endif

// OpenThread core types used in function prototypes below.
#include <openthread/error.h>
#include <openthread/instance.h>
#include <openthread/ip6.h>

/******************************************************************************
 * Application Init.
 *****************************************************************************/
void app_init(void);

/******************************************************************************
 * Application Exit.
 *****************************************************************************/
void app_exit(void);

/******************************************************************************
 * Application Process Action.
 *****************************************************************************/
void app_process_action(void);

extern void set_active_dataset(void);
void udp_socket_init(otInstance *aInstance, uint16_t localPort);
otError udp_send_message(otInstance *aInstance, const otIp6Address *destAddr, uint16_t destPort, const uint8_t *data, uint16_t dataLen);

// SRP Client functions
void srp_client_enable(otInstance *aInstance);
void srp_client_disable(otInstance *aInstance);
otError srp_client_register_service(otInstance *aInstance, 
                                     const char *aServiceName,
                                     const char *aInstanceName,
                                     uint16_t aPort,
                                     const char *aHostName);

#endif 
