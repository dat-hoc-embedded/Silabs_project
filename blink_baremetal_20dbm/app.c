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

#include "app.h"
#include "stdio.h"
/***************************************************************************//**
 * Initialize application.
 ******************************************************************************/
void app_init(void)
{
	blink_init();
	// LED0_1_Init();	/// Initialize LED0 & LED1

	my_usart_get_handle();
	my_uartdrv_transmit();
	my_uartdrv_receive();
}

/***************************************************************************//**
 * App ticking function.
 ******************************************************************************/

void app_process_action(void)
{
  	blink_process_action();
	//LED0_Blink_bare_metal();
	//LED1_Blink_em_lib();
	//LED0_sl_led(&my_simple_led);
	//LED0_sl_simple_led(&my_simple_led_context);
	
}
