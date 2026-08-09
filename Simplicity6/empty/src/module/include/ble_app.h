/**
 * @file ble_app.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief BLE application — public API for Bluetooth initialization.
 *
 * Provides a single init function. The BLE event handler
 * (sl_bt_on_event) is implemented internally in ble_app.c.
 *
 * @version 0.1
 * @date 2026-08-05
 *
 * @copyright Copyright (c) 2026
 *
 */
#ifndef BLE_APP_H
#define BLE_APP_H

/**
 * @brief Initialize BLE advertising configuration.
 *
 * Must be called from app_init() after blink_init().
 * Actual advertising starts when sl_bt_evt_system_boot_id fires.
 */
void ble_app_init(void);

/**
 * @brief Check for LED state changes and send BLE notifications.
 *
 * Must be called from app_process_action() so that LED changes
 * from the blink timer trigger BLE notifications to the client.
 */
void ble_app_process(void);

#endif /* BLE_APP_H */
