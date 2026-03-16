/***************************************************************************/ /**
* @file
* @brief Core application logic.
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
#include "sl_bt_api.h"
#include "sl_main_init.h"
#include "app_assert.h"
#include "app.h"

#include "app_log.h"

// The advertising set handle allocated from Bluetooth stack.
static uint8_t advertising_set_handle = 0xff;
static sl_sleeptimer_timer_handle_t pa_timer;
static uint32_t pa_counter = 0;

#define PA_UPDATE_TIMER_HANDLE 1

// PACKSTRUCT để không có padding bytes - quan trọng khi truyền qua mạng 
PACKSTRUCT( typedef struct
{
    uint8_t type;    // loại packet tự định nghĩa
    uint8_t counter;
    int16_t temperature_x10;
}) pa_payload_t;

static void update_periodic_data(sl_sleeptimer_timer_handle_t *h, void *data)
{
    app_log_info("Haha");
    (void)h;
    (void)data;
    pa_counter++;
    pa_payload_t payload = {
        .type = 0xAB,
        .counter = pa_counter,
        .temperature_x10 = 256,  // giả lập 25.6 độ C
    };
    sl_status_t sc = sl_bt_periodic_advertiser_set_data(advertising_set_handle, sizeof(payload), (uint8_t)&payload);
    app_assert_status(sc);

    if (sc == SL_STATUS_OK) {
        app_log_info("[PA] TX packet #%lu temp=%.1f C \n", pa_counter, payload.temperature_x10 / 10.0f);
    }

}

// Application Init.
void app_init(void)
{
    /////////////////////////////////////////////////////////////////////////////
    // Put your additional application init code here!                         //
    // This is called once during start-up.                                    //
    /////////////////////////////////////////////////////////////////////////////

    app_log_info("========= bt_soc_empty ========== \n");
}

// Application Process Action.
void app_process_action(void)
{
    if (app_is_process_required())
    {
        /////////////////////////////////////////////////////////////////////////////
        // Put your additional application code here!                              //
        // This is will run each time app_proceed() is called.                     //
        // Do not call blocking functions from here!                               //
        /////////////////////////////////////////////////////////////////////////////
    }
}

/**************************************************************************/ /**
* Bluetooth stack event handler.
* This overrides the default weak implementation.
*
* @param[in] evt Event coming from the Bluetooth stack.
*****************************************************************************/

typedef enum {
    ADV_LEGACY = 0,
    ADV_PERIODIC 
} adv_type_t ; 

adv_type_t type = ADV_LEGACY;  // Biến chọn type advertise 

void sl_bt_on_event(sl_bt_msg_t *evt)
{
    sl_status_t sc;

    switch (SL_BT_MSG_ID(evt->header))
    {
    // -------------------------------
    // This event indicates the device has started and the radio is ready.
    // Do not call any stack command before receiving this boot event!
    case sl_bt_evt_system_boot_id:     /** [BOOT]  */
        bd_addr address;
        uint8_t address_type; 
        sl_bt_system_get_identity_address(&address, &address_type);
        app_log_info("[BOARD1 - Advertiser] MY BT address: %02X:%02X:%02X:%02X:%02X:%02X \n",
                        address.addr[5],
                        address.addr[4],
                        address.addr[3],
                        address.addr[2],
                        address.addr[1],
                        address.addr[0]);


        app_log_info("BT stack booted (v%d.%d.%d build %d) \n",
                     evt->data.evt_system_boot.major,
                     evt->data.evt_system_boot.minor,
                     evt->data.evt_system_boot.minor,
                     evt->data.evt_system_boot.build);

        // Create an advertising set.
        sc = sl_bt_advertiser_create_set(&advertising_set_handle);
        app_assert_status(sc);

        if (type == ADV_LEGACY) {
            // Generate data for advertising
            sc = sl_bt_legacy_advertiser_generate_data(advertising_set_handle,
                                                    sl_bt_advertiser_general_discoverable);
            app_assert_status(sc);

            // Set advertising interval to 100ms.
            sc = sl_bt_advertiser_set_timing(
                advertising_set_handle,
                160, // min. adv. interval (milliseconds * 1.6)
                160, // max. adv. interval (milliseconds * 1.6)
                0,   // adv. duration
                0);  // max. num. adv. events
            app_assert_status(sc);

            // Start advertising and enable connections.
            sc = sl_bt_legacy_advertiser_start(advertising_set_handle,
                                            sl_bt_legacy_advertiser_connectable);
            app_assert_status(sc);
            app_log_info("Advertising started (handle = %d)\n", advertising_set_handle);

        } else {

            // 2. Set data ban đầu cho periodic advertising
            pa_payload_t init_payload = {.type = 0xAB,
                                        .counter = pa_counter,
                                        .temperature_x10 = 256,  // giả lập 25.6 độ C 
            };
            sc = sl_bt_periodic_advertiser_set_data(advertising_set_handle, sizeof(init_payload), (uint8_t *)&init_payload);
            app_assert_status(sc);
            // 3. Bật periodic advertising 
            //      interval: 80 * 1.25ms = 100ms
            //      flag AUTO_START: tự bật extended advertising làm carrier
            sc = sl_bt_periodic_advertiser_start(advertising_set_handle, 80, 80, SL_BT_PERIODIC_ADVERTISER_AUTO_START_EXTENDED_ADVERTISING); 
            app_assert_status(sc);


            // 4. Timer cập nhập data mỗi 1 giây
            // sl_sleeptimer_start_periodic_timer_ms(&pa_timer, 1000, update_periodic_data, NULL, 0, 0);

            // Bật BT soft timer: 1 giây, lặp lại (single_shot = 0) 
            // time đơn vị: 1/32768 s -> 32768 = 1 giây
            sc = sl_bt_system_set_lazy_soft_timer(32768, 0, PA_UPDATE_TIMER_HANDLE, 0);
            app_assert_status(sc);

            app_log_info("[PA] Started. interval = 100ms. Soft timer 1s set. \n");

        }

        break;

    case sl_bt_evt_system_soft_timer_id:   /** [SOFT_Timer is used to change pa_payload ] */
        if (evt->data.evt_system_soft_timer.handle != PA_UPDATE_TIMER_HANDLE) break;

        pa_counter ++;
        pa_payload_t payload = {
            .type = 0xAB,
            .counter = pa_counter,
            .temperature_x10 = 256,
        };
        // Gọi trong main context - không còn lỗi ISR
        sc = sl_bt_periodic_advertiser_set_data(advertising_set_handle, sizeof(payload), (const uint8_t *)&payload);
        if (sc == SL_STATUS_OK) {
            app_log_info("[PA] TX #%lu  temp = %.1f C \n ", pa_counter, payload.temperature_x10 / 10.0f);

        } else {
            app_log_error("[PA] set_data failed: 0x%04x \n", sc);
        }

        break;
    // -------------------------------
    // This event indicates that a new connection was opened.
    case sl_bt_evt_connection_opened_id:   
        app_log_info("Connection opened (handle=0x%02x, addr=%02x:%02x:%02x:%02x:%02x:%02x)\n",
                     evt->data.evt_connection_opened.connection,
                     evt->data.evt_connection_opened.address.addr[5],
                     evt->data.evt_connection_opened.address.addr[4],
                     evt->data.evt_connection_opened.address.addr[3],
                     evt->data.evt_connection_opened.address.addr[2],
                     evt->data.evt_connection_opened.address.addr[1],
                     evt->data.evt_connection_opened.address.addr[0]);
        break;

    // -------------------------------
    // This event indicates that a connection was closed.
    case sl_bt_evt_connection_closed_id:
        app_log_info("Connection closed (handle=0x%02x, reason=0x%04x) \n",
                     evt->data.evt_connection_closed.connection,
                     evt->data.evt_connection_closed.reason);
        // Generate data for advertising
        sc = sl_bt_legacy_advertiser_generate_data(advertising_set_handle,
                                                   sl_bt_advertiser_general_discoverable);
        app_assert_status(sc);

        // Restart advertising after client has disconnected.
        sc = sl_bt_legacy_advertiser_start(advertising_set_handle,
                                           sl_bt_legacy_advertiser_connectable);
        app_assert_status(sc);
        app_log_info("Advertising restarted\n");
        break;

    case sl_bt_evt_advertiser_scan_request_id: 
        bd_addr scanner_addr = evt->data.evt_advertiser_scan_request.address;
        printf("Scan request from %02x:%02x:%02x:%02x:%02x:%02x \n", 
                scanner_addr.addr[5],
                scanner_addr.addr[4],
                scanner_addr.addr[3],
                scanner_addr.addr[2],
                scanner_addr.addr[1],
                scanner_addr.addr[0]
            );
    case sl_bt_evt_gatt_mtu_exchanged_id:
		printf("MTU exchanged: %d \n", evt->data.evt_gatt_mtu_exchanged.mtu);
    ///////////////////////////////////////////////////////////////////////////
    // Add additional event handlers here as your application requires!      //
    ///////////////////////////////////////////////////////////////////////////

    // -------------------------------
    // Default event handler.
    default:
        break;
    }
}
