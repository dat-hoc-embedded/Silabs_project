/**
 * @file queue.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2026-01-09
 * 
 * @copyright Copyright (c) 2026
 * 
 */
#include "FreeRTOS.h"
#include "queue.h"
#include "task.h"
#include "app_log.h"

QueueHandle_t myQueue;

void my_queue_init(void)
{
    myQueue = xQueueCreate(5, sizeof(uint32_t));
    if (myQueue == NULL) {
        app_log_error("Failed to create queue\n");
    } else {
        app_log_info("Queue created successfully\n");
    }
}


