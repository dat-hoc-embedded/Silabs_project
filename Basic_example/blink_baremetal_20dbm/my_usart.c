/**
 * @file my_usart.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief Code USART for EFR32MG24
 * @version 0.1
 * @date 2025-11-07
 * 
 * @copyright Copyright (c) 2025
 * 
 */

#include "my_usart.h"


static  UARTDRV_Handle_t    my_eusart0 = NULL; 

// Hoặc dùng Handle đã có sẵn: extern    UARTDRV_Handle_t   sl_uartdrv_eusart_exp_handle;
// extern UARTDRV_Handle_t sl_uartdrv_eusart_exp_handle; 

/**
 * @brief Get handle is setup in .slcp, EUART0: TX - PA5 , RX - PA6
 * 
 * @note EUART0 is init & set_default in sl_uartdrv_init_instances() in sl_event_handler.c
 * @retval UARTDRV_Handle_t : struct pointer -> UARTDRV_HandleData_t (declaration in uartdrv.h)
 */
UARTDRV_Handle_t my_usart_get_handle(void)
{
	if (my_eusart0 == NULL) {
		my_eusart0 = sl_uartdrv_get_default();
	}
	return my_eusart0;
}

#define RxBuf_SIZE 50
volatile  uint8_t rxBuf[RxBuf_SIZE]; /** buffer for transmit & receive */
static uint8_t rx_index = 0; 
static uint8_t rx_temp;

static void tx_callback(Uartdrv_handle_ptr handle, Ecode_t status, \
						uint8_t *data, UARTDRV_Count_t)
{
    // Do some tasks 
}
static void rx_callback(Uartdrv_handle_ptr handle, Ecode_t status, \
						uint8_t *data, UARTDRV_Count_t len)
{
    if (rx_index < RxBuf_SIZE) // because rxBuf[50] = '\0'
        rxBuf[rx_index ++] = *data;

    if (*data == '\n' || *data == '\r')
    {
        rxBuf[rx_index - 1] = '\0';  // rx_index - 1: don't get character '\n'  & '\r'
        /** Funtion TODO:  */ 
        ToDO_task();

        // Echo (transmit byte that MCU received)
        UARTDRV_Transmit(handle, rxBuf, rx_index, tx_callback);

        rx_index = 0; // reset buffer 
        
    }

    UARTDRV_Receive(handle, &rx_temp, 1, rx_callback);
}
/**
 * @brief
 * 
 */
void my_uartdrv_transmit(void)
{
    uint8_t txBuffer[128] = "Hello from UARTDRV, embeddat transmit data to EFR32MG24! \r\n";
    UARTDRV_Transmit(my_eusart0, &txBuffer, strlen(txBuffer), tx_callback);
}

void my_uartdrv_receive(void)
{
    UARTDRV_Receive(my_eusart0, &rx_temp , 1, rx_callback);
}
static void ToDO_task()
{
    if (!strcmp(rxBuf,"fan_on")) 
    {
        printf("\r\nRxBuf = fan_on");
        sl_led_turn_on(&my_simple_led);
    }
    else if (!strcmp(rxBuf,"fan_off"))
    {
        printf("\r\nRxBuf = fan_off");
        sl_led_turn_off(&my_simple_led);
    }else {
        printf("\r\nSyntax Error ");
    }
}

