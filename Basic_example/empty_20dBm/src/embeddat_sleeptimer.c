/**
 * @file embeddat_sleeptimer.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief : Source file for sleeptimer functions
 * @note Sleeptimer is bassed on Low Energy Timer (LETIMER) peripheral of the EFR32MG24. 
 * It is used to create timers that have callbacks when they expire. This is useful for
 * low-power applications where the device can sleep and be woken up by the timer interrupt.
 * @note Usage: 
 * 1. Call embeddat_sleeptimer_init() to initialize the sleeptimer module.
 * 2. Use sl_sleeptimer_start_timer() to start a timer with a
 * @version 0.1
 * @date 2025-11-23
 * 
 * @copyright Copyright (c) 2025
 * 
 */

#include "embeddat_sleeptimer.h"
#include "sl_sleeptimer.h"
#include "em_core.h"
#include <stdint.h>
/**
 * @brief Initialize the sleeptimer module
 * 
 */
sl_sleeptimer_timer_handle_t sleeptimer_embeddat_handle;
sl_sleeptimer_timer_handle_t sleeptimer_embeddat_handle2;

void embeddat_sleeptimer_init()
{
    sl_status_t status;

    // Initialize the sleeptimer module
    status = sl_sleeptimer_init();
    if (status != SL_STATUS_OK) {
        // Handle error
        while(1);
    }
}
/**
 * @brief  Start a periodic sleeptimer
 * 
 * @param timeout_ms : Timeout in milliseconds
 * @retval sl_status_t : Status of the operation
 */
sl_status_t sl_sleeptimer_start(uint32_t timeout_ms)
{
    sl_status_t status;
    
    // Start a periodic timer
    status = sl_sleeptimer_start_periodic_timer_ms(&sleeptimer_embeddat_handle,
                                       timeout_ms,
                                       sleeptimer_callback,
                                       NULL,
                                       0,
                                    SL_SLEEPTIMER_NO_HIGH_PRECISION_HF_CLOCKS_REQUIRED_FLAG);

    // Start another periodic timer with half the timeout for demonstration
    sl_sleeptimer_start_periodic_timer_ms(&sleeptimer_embeddat_handle2,
                                       timeout_ms/2,
                                       sleeptimer_callback,
                                       NULL,
                                       0,
                                    SL_SLEEPTIMER_NO_HIGH_PRECISION_HF_CLOCKS_REQUIRED_FLAG);
    return status;
}
// Global variable to indicate timer expiration
volatile bool toogle_timeout = 0;

/**
 * @brief  Callback function when the timer expires
 * 
 * @param handle : Pointer to the timer handle
 * @param data : User data passed to the callback
 */
static void sleeptimer_callback(sl_sleeptimer_timer_handle_t *handle, void *data)
{
    // User-defined callback function when the timer expires
    (void)handle; // Unused parameter
    (void)data; //  Unused parameter

    // Set the flag to indicate timer expiration
    toogle_timeout = true;
}