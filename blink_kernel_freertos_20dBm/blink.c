/***************************************************************************/ /**
* @file
* @brief Blink examples functions
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

#include "sl_simple_led.h"
#include "sl_simple_led_instances.h"
#include "FreeRTOS.h"
#include "task.h"

#include "stdio.h"
#include "app_log.h"
#include "queue.h"
#include "semphr.h"
#include "uartdrv.h"   // UARTDRV driver definition
#include "sl_uartdrv_instances.h" // UARTDRV instance declarations

#include "zmy_led.h"
#include "zmy_queue/my_queue.h"
#include "sl_simple_button.h"
#include "sl_simple_button_instances.h"

/*******************************************************************************
 *******************************   DEFINES   ***********************************
 ******************************************************************************/

#ifndef LED_INSTANCE
#define LED_INSTANCE sl_led_led0
#endif

#ifndef TOOGLE_DELAY_MS
#define TOOGLE_DELAY_MS 1000
#endif

#ifndef BLINK_TASK_STACK_SIZE
#define BLINK_TASK_STACK_SIZE configMINIMAL_STACK_SIZE
#endif

#ifndef BLINK_TASK_PRIO
#define BLINK_TASK_PRIO 20
#endif

#ifndef EXAMPLE_USE_STATIC_ALLOCATION
#define EXAMPLE_USE_STATIC_ALLOCATION 1
#endif

/*******************************************************************************
 ***************************  LOCAL VARIABLES   ********************************
 ******************************************************************************/

/*******************************************************************************
 *********************   LOCAL FUNCTION PROTOTYPES   ***************************
 ******************************************************************************/

static void blink_task(void *arg);
static void embeddat_task_producer(void *arg);
static void embeddat_task_consumer(void *arg);
static void embeddat_semaphore_consumer(void *arg);
static void uartdrv_send_locked(const uint8_t *data, UARTDRV_Count_t len);
void uartdrv_receive_locked(uint8_t *data, UARTDRV_Count_t len);

/*******************************************************************************
 **************************   GLOBAL FUNCTIONS   *******************************
 ******************************************************************************/

/* Semaphore used by embeddat_semaphore_consumer. */
static SemaphoreHandle_t blink_semaphore;  
static SemaphoreHandle_t uart_mutex;  

void blink_init(void)
{
	// Initialize My LED instance
	sl_embeddat_led1_init();
	my_queue_init();

	blink_semaphore = xSemaphoreCreateBinary(); // must be assigned in function, not in file scope
	EFM_ASSERT(blink_semaphore != NULL);

	uart_mutex = xSemaphoreCreateMutex();
	EFM_ASSERT(uart_mutex != NULL);

	TaskHandle_t xHandle = NULL;
	TaskHandle_t xHandle2 = NULL;
	TaskHandle_t xHandle3 = NULL;

#if (EXAMPLE_USE_STATIC_ALLOCATION == 1)

	static StaticTask_t xTaskBuffer;
	static StackType_t xStack[BLINK_TASK_STACK_SIZE];

	static StaticTask_t xTaskBuffer2;
	static StackType_t xStack2[BLINK_TASK_STACK_SIZE];

	static StaticTask_t xTaskBuffer3;
	static StackType_t xStack3[BLINK_TASK_STACK_SIZE];

	// Create Blink Task without using any dynamic memory allocation
	xHandle = xTaskCreateStatic(blink_task,
								"blink task",
								BLINK_TASK_STACK_SIZE,
								(void *)NULL, // No parameters
								tskIDLE_PRIORITY + 1,
								xStack,
								&xTaskBuffer);

	xHandle2 = xTaskCreateStatic(embeddat_task_producer,
								 "embeddat_task_producer",
								 BLINK_TASK_STACK_SIZE,
								 (void *)NULL, // No parameters
								 tskIDLE_PRIORITY + 2,
								 xStack2,
								 &xTaskBuffer2);

	xHandle3 = xTaskCreateStatic(embeddat_semaphore_consumer,
								 "embeddat_semaphore_consumer",
								 BLINK_TASK_STACK_SIZE,
								 (void *)NULL, // No parameters
								 tskIDLE_PRIORITY + 2,
								 xStack3,
								 &xTaskBuffer3);

	BaseType_t xReturned = pdFAIL;
	xReturned = xTaskCreate(embeddat_task_consumer,
							"embeddat_task_consumer",
							BLINK_TASK_STACK_SIZE,
							(void *)NULL,
							tskIDLE_PRIORITY + 3,
							&xHandle3);

	// Since puxStackBuffer and pxTaskBuffer parameters are not NULL,
	// it is impossible for xHandle to be null. This check is for
	// rigorous example demonstration.
	EFM_ASSERT(xHandle != NULL);

#else

	BaseType_t xReturned = pdFAIL;

	// Create Blink Task using dynamic memory allocation
	xReturned = xTaskCreate(blink_task,
							"blink task",
							BLINK_TASK_STACK_SIZE,
							(void *)NULL,
							tskIDLE_PRIORITY + 1,
							&xHandle);

	// Unlike task creation using static allocation, dynamic task creation can very likely
	// fail due to lack of memory. Checking the return value is relevant.
	EFM_ASSERT(xReturned == pdPASS);

#endif
}

/*******************************************************************************
 * Blink task.
 ******************************************************************************/
static void blink_task(void *arg)
{
	(void)&arg;

	// Use the provided calculation macro to convert milliseconds to OS ticks
	const TickType_t xDelay = pdMS_TO_TICKS(TOOGLE_DELAY_MS);
	;

	while (1)
	{
		// Toggle led
		sl_led_toggle(&LED_INSTANCE);

		// printf("Blink!\n");
		// app_log_info("Blink app_log!\n");

		// Wait for specified delay
		vTaskDelay(xDelay);
	}
}

static void embeddat_task_producer(void *arg)
{
	(void)&arg;

	// Use the provided calculation macro to convert milliseconds to OS ticks
	const TickType_t xDelay = pdMS_TO_TICKS(1000);

	uint32_t counter = 0;

	while (1)
	{
		counter++;

		xQueueSend(myQueue, &counter, portMAX_DELAY);
		app_log_info("Embeddat Increase Counter \n");
		{
			char msg[64];
			int len = snprintf(msg, sizeof(msg), "UARTDRV counter=%lu\r\n", counter);
			if (len > 0) {
				uartdrv_send_locked((const uint8_t *)msg, (UARTDRV_Count_t)len);
			}
		}

		// Wait for specified delay
		vTaskDelay(xDelay);
	}
}

static void embeddat_task_consumer(void *arg)
{
	(void)&arg;

	uint32_t receivedValue = 0;

	// Use the provided calculation macro to convert milliseconds to OS ticks
	const TickType_t xDelay = pdMS_TO_TICKS(1000);
	;

	while (1)
	{
		xQueueReceive(myQueue, &receivedValue, portMAX_DELAY);

		app_log_info("Embeddat Received Value: %lu\n", receivedValue);

		// Wait for specified delay
		//vTaskDelay(xDelay);
	}
}

static void embeddat_semaphore_consumer(void *arg)
{
	(void)&arg;

	// Use the provided calculation macro to convert milliseconds to OS ticks
	const TickType_t xDelay = pdMS_TO_TICKS(1500);
	;

	while (1)
	{
		xSemaphoreTake(blink_semaphore, portMAX_DELAY);
		app_log_info("Semaphore taken by consumer\n");
		sl_led_toggle(&embeddat_led1);
	}
}

static void uartdrv_send_locked(const uint8_t *data, UARTDRV_Count_t len)
{
	if (uart_mutex == NULL) {
		return;
	}

	if (xSemaphoreTake(uart_mutex, portMAX_DELAY) == pdTRUE) {
		(void)UARTDRV_TransmitB(sl_uartdrv_eusart_exp_handle, (uint8_t *)data, len);
		xSemaphoreGive(uart_mutex);
	}
}

void uartdrv_receive_locked(uint8_t *data, UARTDRV_Count_t len)
{
	if (uart_mutex == NULL) {
		return;
	}

	if (xSemaphoreTake(uart_mutex, portMAX_DELAY) == pdTRUE) {
		(void)UARTDRV_ReceiveB(sl_uartdrv_eusart_exp_handle, data, len);
		xSemaphoreGive(uart_mutex);
	}
}

void sl_button_on_change(const sl_button_t *handle)
{
	BaseType_t xHigherPriorityTaskWoken = pdFALSE;

	if ((handle == &sl_button_btn1) && (blink_semaphore != NULL))
	{
		if (sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED)
		{
			xSemaphoreGiveFromISR(blink_semaphore, &xHigherPriorityTaskWoken);
			portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
		}
	}
}

// bool sl_main_start_task_should_continue(void)
// {
//   printf("Hello from weak function!\n");
//   return false;
// }
