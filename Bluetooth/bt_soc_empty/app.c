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
#include "gatt_db.h"
#include "sl_simple_led_instances.h"
#include "sl_button.h"
#include "sl_simple_button_instances.h"

#define PA_UPDATE_TIMER_HANDLE 1


// The advertising set handle allocated from Bluetooth stack.
static uint8_t advertising_set_handle = 0xff;
static sl_sleeptimer_timer_handle_t pa_timer;
static uint32_t pa_counter = 0;

// Variable for notify & indicate
static uint8_t notify_connection = SL_BT_INVALID_CONNECTION_HANDLE;
static bool notify_enabled = false;
static bool indicate_enabled = false;
static bool indication_in_flight = false; // Dùng flag để chờ ACK tránh gửi indication liên tục mà không chờ ACK 

static uint8_t ble_conn_handle = SL_BT_INVALID_CONNECTION_HANDLE; // Connection handle for the current BLE connection 
static volatile bool btn0_pressed = false;
static volatile bool btn1_pressed = false;

static void log_local_database_hash(void) ;

#define DB_HASH_LEN 16


// PACKSTRUCT để không có padding bytes - quan trọng khi truyền qua mạng 
PACKSTRUCT( typedef struct
{
    uint8_t type;    // loại packet tự định nghĩa
    uint8_t counter;
    int16_t temperature_x10;
}) pa_payload_t;

static bool flags = false;  // true = custome, false = info 

static gattdb_cap_t caps;

// Interrupt function for button 
void sl_button_on_change(const sl_button_t *handle){
    if (handle == &sl_button_btn0 && sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED)
    {
        btn0_pressed = true; 
        app_proceed(); 
    }
    if (handle == &sl_button_btn1 && sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED) {
		btn1_pressed = true;
		app_proceed();
	}
}

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


static void toggle_gatt_mode(void) 
{
    sl_status_t sc;
    flags = !flags;
    if (flags == false) {  
        // Bật cap_info
        caps = info;
        sc = sl_bt_gatt_server_set_capabilities(caps, 0);
        app_assert_status(sc);
        app_log_info("[PolyGATT] Mode -> INFO: Custome hidden, "
                     "Info visible \n");
    } else {
        caps = custome;
        // Bật cap_custome, tắt capp_info - về trạng thái mặc định
        sc = sl_bt_gatt_server_set_capabilities(caps, 0);
        app_assert_status(sc);
        app_log_info("[PolyGATT] Mode -> CUSTOME: Custome visible, "
                     "Info hidden \n");
    }

    // Hash thay đổi vì GATT structure đã thay đổi
    log_local_database_hash();

}
// --------- GATT Caching: Server helpers 
/**
 * @brief Đọc Database Hash (UUID 0x2B2A) từ Local GATT database. 
 * Stack tự tính hash bằng AES-CMAC mỗi khi GATT structure thay đổi. 
 * Hash = 16 bytes, thay đổi khi toggle capabilities. 
 * 
 */
static void log_local_database_hash(void) 
{
    uint8_t hash[DB_HASH_LEN];
    size_t hash_len = 0;
    sl_status_t sc = sl_bt_gatt_server_read_attribute_value(gattdb_database_hash, 0, sizeof(hash), &hash_len, hash);
    
    if (sc == SL_STATUS_OK && hash_len == DB_HASH_LEN) 
    {
        app_log_info("[DB_HASH] Database Hash: ");
        for (int i = 0; i < DB_HASH_LEN; i++) {
            app_log_append("%02X", hash[i]);
        }
        app_log_append("\n");
    } else {
        app_log_warning("[DB_HASH] Failed to read Database Hash: 0x%04x \n", sc);
    }
}

/**
 * @brief Kiểm tra client đã ghi Robust Caching bit (bit 0) vào Client Supported Features (UUID 0x2B29) chưa.
 * Nếu Yes: stack sẽ gửi Service Changed indication khi DB thay đổi. 
 * Nếu No: Stack sẽ trả ATT error 0x110A (Database Out Of Sync) khi client dùng stale cached handle. 
 * 
 * @param connection 
 */
static void check_client_caching_support(uint8_t connection)
{
    uint8_t client_feature = 0;
    sl_status_t sc = sl_bt_gatt_server_read_client_supported_features(connection, &client_feature);

    if (sc == SL_STATUS_OK) 
    {
        bool robust_caching = (client_feature & 0x01) != 0 ;
        app_log_info("[Connection_opened][Check_caching] Client features = 0x%02X -> Robust Caching: %s \n", client_feature, robust_caching ? "YES" : "NO");
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
        if  (btn0_pressed) {
            btn0_pressed = false;
            sl_led_toggle(&sl_led_led0);

            uint8_t state = (uint8_t)sl_led_get_state(&sl_led_led0);
            sl_bt_gatt_server_write_attribute_value(gattdb_Led_Control, 0, sizeof(state), &state);  // sync Database 
            app_log_info("[App_process] BTN0: LED toggled -> %d \n", state);

            if (ble_conn_handle != SL_BT_INVALID_CONNECTION_HANDLE)
            {
                if (notify_enabled) {
                    sl_bt_gatt_server_send_notification(ble_conn_handle,
                                                        gattdb_Led_Control,
                                                        sizeof(state), &state);
                    app_log_info("[App_process] BTN0: Notify sent -> %d \n", state);
                }
                else if (indicate_enabled && !indication_in_flight)
                {
                    sl_bt_gatt_server_send_indication(ble_conn_handle,
                                                      gattdb_Led_Control,
                                                      sizeof(state), &state);
                    app_log_info("[App_process] BTN0: Indicate sent -> %d (waiting ACK) \n", state);

                    indication_in_flight = true;
                }
            }
        }
        if (btn1_pressed) {
            btn1_pressed = false;
            toggle_gatt_mode();
        }

        
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
        app_log_info("[SYSTEM_BOOT] MY BT address: %02X:%02X:%02X:%02X:%02X:%02X \n",
                        address.addr[5],
                        address.addr[4],
                        address.addr[3],
                        address.addr[2],
                        address.addr[1],
                        address.addr[0]);


        app_log_info("[SYSTEM_BOOT] BT stack booted (v%d.%d.%d build %d) \n",
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
            app_log_info("[SYSTEM_BOOT] Advertising started (handle = %d)\n", advertising_set_handle);

        } else {   // Periodic Advertising

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

        log_local_database_hash();
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
        ble_conn_handle = evt->data.evt_connection_opened.connection;
        notify_enabled = false;
        indicate_enabled = false;
        indication_in_flight = false;

        app_log_info("Connection opened (handle=0x%02x, addr=%02x:%02x:%02x:%02x:%02x:%02x)\n",
                     evt->data.evt_connection_opened.connection,
                     evt->data.evt_connection_opened.address.addr[5],
                     evt->data.evt_connection_opened.address.addr[4],
                     evt->data.evt_connection_opened.address.addr[3],
                     evt->data.evt_connection_opened.address.addr[2],
                     evt->data.evt_connection_opened.address.addr[1],
                     evt->data.evt_connection_opened.address.addr[0]);

        check_client_caching_support(ble_conn_handle);
        break;

    // -------------------------------
    // This event indicates that a connection was closed.
    case sl_bt_evt_connection_closed_id:

        ble_conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;
        notify_enabled = false;
        indicate_enabled = false;
        indication_in_flight = false;

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
        app_log_info("[connection_closed] Advertising restarted\n");
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
        break;
    case sl_bt_evt_gatt_mtu_exchanged_id:
		//printf("MTU exchanged: %d \n", evt->data.evt_gatt_mtu_exchanged.mtu);
        break;
    ///////////////////////////////////////////////////////////////////////////
    // Add additional event handlers here as your application requires!      //
    ///////////////////////////////////////////////////////////////////////////

    // This event is used when client send read request
    // case sl_bt_evt_gatt_server_user_read_request_id: 
    // {
    //     sl_bt_evt_gatt_server_user_read_request_t *req = &evt->data.evt_gatt_server_user_read_request;
    //     if (req->characteristic == gattdb_Led_Control) {
    //         uint8_t led_value = (uint8_t)sl_led_get_state(&sl_led_led0);
    //         sl_bt_gatt_server_send_user_read_response(
    //             req->connection,
    //             req->characteristic,
    //             SL_STATUS_OK, 
    //             sizeof(led_value),
    //             &led_value,
    //             NULL);
    //     }
    //     break;
    // }

    // case sl_bt_evt_gatt_server_user_write_request_id:
    // {
    //     sl_bt_evt_gatt_server_user_write_request_t *req = &evt->data.evt_gatt_server_user_write_request;
    //     if (req->characteristic == gattdb_Led_Control) {
    //         uint8_t value = req->value.data[0];
    //         if (value) {
    //             sl_led_turn_on(&sl_led_led0);
    //         } else {
    //             sl_led_turn_off(&sl_led_led0);
    //         }
    //         sl_bt_gatt_server_send_user_write_response(
    //             req->connection,
    //             req->characteristic,
    //             SL_STATUS_OK
    //         );

    //         app_log_info("LED set to: %d \n", value);
    //     }
    //     break;
    // }

    // This event is riss when client write value to server with type value = hex

    case sl_bt_evt_gatt_server_indication_timeout_id:
        indication_in_flight = false;   // reset để có thể gửi lại
        app_log_warning("[Indicate Timeout] Indication timeout (conn=0x%02x) - client did not ACK \n",
                        evt->data.evt_gatt_server_indication_timeout.connection);
        break;

    // When the client use API sl_bt_gatt_write_characteristic_value(conn_handle, char_handle, sizeof(led_state), &led_state);
	case sl_bt_evt_gatt_server_attribute_value_id: 
	{
		sl_bt_evt_gatt_server_attribute_value_t *att = &evt->data.evt_gatt_server_attribute_value;
		if (att->attribute == gattdb_Led_Control)
		{
			uint8_t value = att->value.data[0];
			if (value)
			{
				sl_led_turn_on(&sl_led_led0);
			}
			else
			{
				sl_led_turn_off(&sl_led_led0);
			}
			app_log_info("[Server_attribute_value] LED set to: %d  via BLE write from client \n", value);
        }
		break;
	}

	// Client Characteristic Configuration (CCC) được viết bởi client (mobile app) để enable/disable notify/indicate
	case sl_bt_evt_gatt_server_characteristic_status_id: 
    {
        sl_bt_evt_gatt_server_characteristic_status_t *cs = &evt->data.evt_gatt_server_characteristic_status;

        // ___ CCCD write: client subscribe/unsubsribe
        if (cs->characteristic == gattdb_Led_Control && cs->status_flags == sl_bt_gatt_server_client_config)
        {
            notify_enabled = (cs->client_config_flags & sl_bt_gatt_notification) != 0; // Kiểm tra notify có được bật hay không bằng cách kiểm tra bit sl_bt_gatt_notification trong client_config_flags
            indicate_enabled = (cs->client_config_flags & sl_bt_gatt_indication) != 0; // 
            app_log_info("[Server_characteristic_status] CCCD Led_control: Notify = %s Indicate = %s \n",
                         notify_enabled ? "ON" : "OFF",
                         indicate_enabled ? "ON" : "OFF"); // 
        }
        
        // ____ Confirmation: client đã ACK indication
        if (cs ->status_flags == sl_bt_gatt_server_confirmation && cs->characteristic == gattdb_Led_Control)
        {
            indication_in_flight = false;
            app_log_info("[Server_characteristic_status] Indication ACK received \n");
        }

        break;
    }
    // -------------------------------
    // Default event handler.
    default:
        break;
    }
}
