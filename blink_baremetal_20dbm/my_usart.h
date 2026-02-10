/**
 * @file my_usart.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief Header USART for EFR32MG24
 * @version 0.1
 * @date 2025-11-07
 * 
 * @copyright Copyright (c) 2025
 * 
 */

#ifndef MY_USART_H
#define MY_USART_H
 
#include "uartdrv.h" /** Include some API for UARTDRV: _Transmit, _Receive */
#include "em_device.h" /** Manage register of MCU EFR32MG24 */
#include "em_usart.h" /** USE: code bare-metal, emlib */

#include "sl_uartdrv_instances.h" /** Include API: set, get_instance  */
#include "string.h"

#include "my_led.h"
typedef UARTDRV_Handle_t Uartdrv_handle_ptr; /** definite other name */

UARTDRV_Handle_t my_usart_get_handle(void);
static void tx_callback(Uartdrv_handle_ptr handle, Ecode_t status, \
						uint8_t *data, UARTDRV_Count_t);

static void rx_callback(Uartdrv_handle_ptr handle, Ecode_t status, \
						uint8_t *data, UARTDRV_Count_t len);

void my_uartdrv_transmit(void);
void my_uartdrv_receive(void);
static void ToDO_task();


#endif /** MY_USART_H */


 





