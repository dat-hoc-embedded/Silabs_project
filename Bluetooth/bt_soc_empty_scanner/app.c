/***************************************************************************//**
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

/**
 * @file app.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief GATT Client with GATT Caching support
 * 	Chức năng: 
 * 		- Scan -> Kết nối tới Server 
 * 		- Đọc Database Hash (0x2B2A) -> so sánh với cache
 * 		- Ghi Robust Caching bit vào Client Supported Features (0x2B29)
 * 		- Khi nhận Service Changed indication -> indication cache -> re-discover 
 * 
 * @version 0.1
 * @date 2026-03-25
 * 
 * @copyright Copyright (c) 2026
 * 
 */
#include "sl_bt_api.h"
#include "sl_main_init.h"
#include "app_assert.h"
#include "app.h"
#include "app_log.h"
#include <string.h>

#include "z_LCD_onboard.h"

#include "sl_simple_button_instances.h"
#include "sl_button.h" // Declare function: void sl_button_on_change(const sl_button_t *handle) 
#include "sl_simple_led_instances.h"

/** ========  Button  ==========*/
static volatile bool btn0_pressed = false;   // state of btn0
static volatile bool btn1_pressed = false;	 // state of btn1
static uint8_t led_state = 0;    			 // sate variable to control LED

/// Information of TARGET Board
#define TARGET_DEVICE_NAME "Empty Example"
static const bd_addr TARGET_ADDR = {{0x77, 0x8B, 0x5B, 0xB1, 0x5C, 0x6C}};

/** ======== Handle ========= */
static uint16_t sync_handle = 0xFFFF; 		///  Handle for Periodic 
static uint8_t conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;    /// được set in function sl_bt_connection_open()
static uint32_t service_handle = 0;     	/// 
static uint16_t custome_char_handle = 0;
static bool sync_opened = false;

/**
 * @brief This enum declare 2 type of advertiser:  LEGACY | PERIODIC 
 */
typedef enum
{
	ADV_LEGACY = 0,
	ADV_PERIODIC
} adv_type_t;
adv_type_t ad_type = ADV_LEGACY;  

/**
 * @brief This enum declare state to show the process of Bluetooth scanner
 */
typedef enum
{
	STATE_SCANNING,
	STATE_CONNECTING,
	STATE_CONNECTED,
	STATE_DISCOVERING_SERVICE,
	STATE_DISCOVERING_CHAR,
	STATE_SUBSCRIBING_NOTIFY,
	STATE_SUBSCRIBING_INDICATION,  
	STATE_READY,
	STATE_DISC_DB_HASH_CH, // đang discover Database Hash char (0x2B2A)
	STATE_READ_DB_HASH,    // đang dọc Database Hash value
	STATE_DISC_CSF_CH, 	   // đang discover Client Supported Features char (0x2B29)
	STATE_DISC_WRITE_CSF,  // đang ghi Robust Caching bit vào CSF
	STATE_APP_SVC, 		   // Đang discover application services (LED, Advanced ...) 
	STATE_DISC_DONE,  
} app_state_t;
static app_state_t app_state = STATE_SCANNING;

/**
 * @brief Payload for Periodic advertiser
 * @param type
 * 
 */
typedef struct
{
	uint8_t type;
	uint8_t counter;
	int16_t temperature_x10;
} pa_payload_t;

// UUID service: 6933b573-66e5-476c-8ff3-cc3d0c4c1302 (little-endian)
static const uint8_t led_service_uuid[] = {
    0x02, 0x13, 0x4c, 0x0c,
    0x3d, 0xcc,
    0xf3, 0x8f,
    0x6c, 0x47,
    0xe5, 0x66, 0x73, 0xb5, 0x33, 0x69
};

// UUID characteristic: 023ec5dc-d5ce-404a-bcfd-96145800d535 (little-endian)
static const uint8_t led_char_uuid[] = {
    0x35, 0xd5, 0x00, 0x58,
    0x14, 0x96,
    0xfd, 0xbc,
    0x4a, 0x40,
    0xce, 0xd5, 0xdc, 0xc5, 0x3e, 0x02
};

// ===================  DATABASE HASH  ======================
#define DB_HASH_LEN 16
static uint8_t cached_db_hash[DB_HASH_LEN]; 	// Hash từ lần kết nối trước (tồn tại xuyên suốt các connection)
static bool has_cached_hash = false;       		// False lần đầu, True sau khi đọc được hash đầu tiên
static uint8_t new_db_hash[DB_HASH_LEN]; 		// Hash vừa đọc được từ server
static bool cache_valid 	= false;			// true = hash giống -> skip discovery 

static uint16_t db_hash_char_handle  	= 0; 	// Database Hash char
static uint16_t csf_char_handle  	 	= 0; 	// Client Supported Features char

void print_hash(const char *label, const uint8_t *hash)
{
	app_log_info("%s", label);
	for (int i = 0; i < DB_HASH_LEN; i++)
	{
		app_log_append("%02X", hash[i]);
	}
	app_log_append("\n");
}

/**
 * @brief 
 * 
 * @param handle 
 */
void sl_button_on_change(const sl_button_t *handle) {
	if (handle == &sl_button_btn0 && sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED) {
		btn0_pressed = true;
		app_proceed();
	} 
	if (handle == &sl_button_btn1 && sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED) {
		btn1_pressed = true;
		app_proceed();
	}
	
}

// Application Init.
void app_init(void)
{
	/////////////////////////////////////////////////////////////////////////////
	// Put your additional application init code here!                         //
	// This is called once during start-up.                                    //
	/////////////////////////////////////////////////////////////////////////////

	display_init();

	if (ad_type == ADV_PERIODIC)
	{
		app_log_info("[App_Init] Hello, I am scanner. Periodic Sync Observer \n");
	}
	else
	{
		app_log_info("[App_Init] ===== Central demo: Scan & Connect ===== \n");
	}
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
		if (display_dirty == true)
			refresh_display();

		if (btn0_pressed && app_state <= STATE_DISC_DONE)
		{
			btn0_pressed = false;
			led_state = !led_state;
			sl_bt_gatt_write_characteristic_value(conn_handle, custome_char_handle, sizeof(led_state), &led_state);
			app_log_info("[App Process - BTN0] Write LED = %d \n", led_state);

		}
		if (btn1_pressed && app_state <= STATE_DISC_DONE)
		{
			app_log_info("[App Process - BTN1] Read Characteristic value ! \n");
			btn1_pressed = false;
			sl_bt_gatt_read_characteristic_value(conn_handle, custome_char_handle);
		}
	}
}
/**
 * @brief 
 * 
 * @param data 
 * @param len 
 * @param name_out 
 * @param name_max 
 * @retval true 
 * @retval false 
 */

static bool parse_device_name(const uint8_t *data, uint8_t len, char *name_out, uint8_t name_max)
{
	const uint8_t *p = data;
	const uint8_t *end = data + len;

	while (p < end)
	{
		uint8_t ad_len = p[0];
		if (ad_len == 0 || p + 1 + ad_len > end)
			break;

		uint8_t ad_type = p[1];

		if (ad_type == 0x08 || ad_type == 0x09)
		{
			uint8_t name_len = ad_len - 1;
			if (name_len >= name_max)
				name_len = name_max - 1;
			memcpy(name_out, p + 2, name_len);
			name_out[name_len] = '\0';
			return true;
		}

		p += 1 + ad_len;
	}
	return false;
}

static void start_scanning(void)
{
	app_log_info("[Start_scanning] Started scanning for \"%s\"...\n ", TARGET_DEVICE_NAME);
	sl_status_t sc;

	// Passive scan - không gửi SCAN_REQ, tiết kiệm pin
	// interval = 16 (10ms), window = 16 (10ms) => duty cycle 100%
	sc = sl_bt_scanner_set_parameters(sl_bt_scanner_scan_mode_passive, 16, 16);
	app_assert_status(sc);

	sc = sl_bt_scanner_start(sl_bt_scanner_scan_phy_1m, sl_bt_scanner_discover_generic);
	app_assert_status(sc);

	app_state = STATE_SCANNING;
}

/**************************************************************************//**
 * Bluetooth stack event handler.
 * This overrides the default weak implementation.
 *
 * @param[in] evt Event coming from the Bluetooth stack.
 *****************************************************************************/
void sl_bt_on_event(sl_bt_msg_t *evt)
{
	sl_status_t sc;

	switch (SL_BT_MSG_ID(evt->header))
	{
	// -------------------------------
	// This event indicates the device has started and the radio is ready.
	// Do not call any stack command before receiving this boot event!
	case sl_bt_evt_system_boot_id:
	{

		// Bắt đầu scan extended advertising để tìm SyncInfo
		if (ad_type == ADV_PERIODIC)
		{
			sc = sl_bt_scanner_start(sl_bt_gap_phy_1m, sl_bt_scanner_discover_observation);
			app_assert_status(sc);

			app_log_info("[] Scanning for periodic advertiser ... \n");
		}
		else
		{
			app_log_info("[EVT] SYSTEM BOOT ID \n");
			start_scanning();
		}

		break;
	}
	case sl_bt_evt_scanner_extended_advertisement_report_id: // [Periodic] Event when the scanner reveice extended_advertisement
	{
		if (sync_opened)
			break;
		sl_bt_evt_scanner_extended_advertisement_report_t *r = &evt->data.evt_scanner_extended_advertisement_report;

		// Chỉ sync với device có địa chỉ khớp
		if (memcmp(r->address.addr, TARGET_ADDR.addr, 6) != 0)
			break;
		if (r->periodic_interval == 0)
			break; // không có SyncInfo

		app_log_info("[] Found target! addr = %02X:%02X:%02X:%02X:%02X:%02X , periodic_interval = %.1f ms \n",
					 r->address.addr[5], r->address.addr[4],
					 r->address.addr[3], r->address.addr[2],
					 r->address.addr[1], r->address.addr[0],
					 r->periodic_interval * 1.25f);

		// Mở sync với periodic advertising train
		sc = sl_bt_sync_scanner_open(r->address, r->address_type, r->adv_sid, &sync_handle);
		app_assert_status(sc);

		app_log_info("Syncing ... (handle = %d) \n", sync_handle);
		sync_opened = true;

		break;
	}

	case sl_bt_evt_periodic_sync_opened_id: // [Periodic] Event when sync is set up successfully
	{
		sl_bt_evt_periodic_sync_opened_t *s = &evt->data.evt_periodic_sync_opened;
		app_log_info("Sync ESTABLISHED! \n");
		app_log_info(" 		interval = %.1fms, PHY = %d \n", s->adv_interval * 1.25f, s->adv_phy);

		// Dừng scan để tiết kiệm pin
		sl_bt_scanner_stop();
		break;
	}

	case sl_bt_evt_periodic_sync_report_id: // [Periodic] Event inform that scanner receive periodic advertising packet
	{
		sl_bt_evt_periodic_sync_report_t *r = &evt->data.evt_periodic_sync_report;
		if (r->data.len < sizeof(pa_payload_t))
			break;
		pa_payload_t *p = (pa_payload_t *)r->data.data;

		app_log_info("RX #%lu 	temp=%.1f C 	RSSI=%d dBm \n",
					 p->counter,
					 p->temperature_x10 / 10.0f,
					 r->rssi);
		break;
	}

	case sl_bt_evt_sync_closed_id: //
	{
		app_log_info(" Sync LOST (reason=0x%04x) \n", evt->data.evt_sync_closed.reason);
		sync_opened = false;

		// Scan lại để tìm và re-sync
		sl_bt_scanner_start(sl_bt_gap_phy_1m, sl_bt_scanner_discover_observation);
		break;
	}

	case sl_bt_evt_scanner_legacy_advertisement_report_id: // [LEGACY] Event when scanner catch advertisement_report 
	{
		app_log_info(" \n\n ===================  evt_legacy_advertisement_report ============== \n ");
		if (app_state != STATE_SCANNING)
			break;

		sl_bt_evt_scanner_legacy_advertisement_report_t *r = &evt->data.evt_scanner_legacy_advertisement_report;

		// Chỉ xét packet connectable (bit 0 của event_flags)
		if (!(r->event_flags & SL_BT_SCANNER_EVENT_FLAG_CONNECTABLE))
			break;

		// Parse tên device từ AD data
		char name[32] = {0};
		bool has_name = parse_device_name(r->data.data, r->data.len, name, sizeof(name));

		if (has_name)
		{
			app_log_info("[Advertisement_report] Found: \"%s\" addr = %02X:%02X:%02X:%02X:%02X:%02X  RSSI=%d \n", name,
						 r->address.addr[5], r->address.addr[4],
						 r->address.addr[3], r->address.addr[2],
						 r->address.addr[1], r->address.addr[0],
						 r->rssi);
		}

		// Add device to device_list that is printed on the LCD 128x128
		add_device(r, parse_device_name);

		// So khớp tên với target
		if (!has_name || memcmp(r->address.addr, TARGET_ADDR.addr, 6) != 0)     // bỏ strcmp(name, TARGET_DEVICE_NAME) != 0
			break;

		// Tìm thấy target -> dừng scan và connect
		app_log_info("[Advertisement_report] Target found! Connecting ... \n");


		sc = sl_bt_scanner_stop();
		app_assert_status(sc);

		sc = sl_bt_connection_open(r->address, r->address_type, sl_bt_gap_phy_1m, &conn_handle);

		if (sc != SL_STATUS_OK)
		{
			app_log_error("[Advertisement_report] Connection_open failed: 0x%04x \n", sc);
			start_scanning();
			break;
		}

		app_state = STATE_CONNECTING;
		app_log_info("[Advertisement_report] Connection request sent (handle=%d) \n", conn_handle);
		break;
	}

	/* ========  Nhận thông số connection sau khi mở ========= */
	case sl_bt_evt_connection_parameters_id: /* [LEGACY] - */
	{
		app_log_info("\n\n ===================  evt_connection_parameters_id ============== \n ");
		sl_bt_evt_connection_parameters_t *p = &evt->data.evt_connection_parameters;
		app_log_info("[Connection_parameters] Parameters: \n");
		app_log_info(" 		                  Interval: %d * 1.25ms = %d ms \n", p->interval, (p->interval * 5) / 4);
		app_log_info("		          	      Latency : %d \n", p->latency);
		app_log_info("		              	  Timeout : %d ms \n", p->timeout * 10);

		break;
	}
	// --------------- Note: Xảy ra trước event connection_parameters_id 
	case sl_bt_evt_connection_opened_id: /* [LEGACY] This event indicates that a new connection was opened. */
		app_log_info("\n\n ===================  evt_connection_opened_id ============== \n ");
		sl_bt_evt_connection_opened_t *c = &evt->data.evt_connection_opened;
		conn_handle = c->connection;
		app_state = STATE_CONNECTED;

		app_log_info("Connection opened (handle=0x%02x, addr=%02X:%02X:%02X:%02X:%02X:%02X)\n",
					 conn_handle,
					 c->address.addr[5], c->address.addr[4],
					 c->address.addr[3], c->address.addr[2],
					 c->address.addr[1], c->address.addr[0]);

		app_log_info(" 		Role	: %s \n", c->role == 0 ? "Peripheral" : "Central");

		// Discovering service ... \n
		app_state = STATE_DISCOVERING_SERVICE;
		app_log_info("[connection_opened] Discovering service ... \n");
		sc = sl_bt_gatt_discover_primary_services_by_uuid(conn_handle,
														  sizeof(led_service_uuid),
														  led_service_uuid);
		app_assert_status(sc);

		// 

		break;
		// -------------------------------
		// This event indicates that a connection was closed.

	case sl_bt_evt_gatt_service_id: 
		if (app_state == STATE_DISCOVERING_SERVICE)
		{	
			service_handle = evt->data.evt_gatt_service.service;
			app_log_info("[service_id] Service found (handle=%lu)\n", service_handle);
		}
		break;
	
	/// ==== Discover characteristic result ====
	case sl_bt_evt_gatt_characteristic_id:  
		sl_bt_evt_gatt_characteristic_t *ch = &evt->data.evt_gatt_characteristic;
		
		if (app_state == STATE_DISCOVERING_CHAR)
		{
			custome_char_handle = ch->characteristic;
			app_log_info("[Characteristic_id] Custome Characteristic found (handle = %lu)\n", custome_char_handle);
		} else if (app_state == STATE_DISC_DB_HASH_CH) 
		{
			db_hash_char_handle = ch->characteristic;
			app_log_info("[Characteristic_id] Database Hash char found (handle = 0x%04x) \n", db_hash_char_handle);

		} else if (app_state == STATE_DISC_CSF_CH) 
		{
			csf_char_handle = ch->characteristic;
			app_log_info("[Characteristic_id] Client Supported Features char found (handle = 0x%04x) \n", csf_char_handle);
		}
		break;

	case sl_bt_evt_gatt_procedure_completed_id:
	{
		uint16_t result = evt->data.evt_gatt_procedure_completed.result;
		if (result != SL_STATUS_OK)
		{
			app_log_error("[Procedure_complete] GATT procedure failed: 0x%04x \n", result);
			break;
		}

		switch (app_state)
		{
		/// === Bước 1 xong: Discover Service -> Discover Characteristic LED
		case STATE_DISCOVERING_SERVICE:
			app_state = STATE_DISCOVERING_CHAR;
			app_log_info("[Procedure_complete] Discovering characteristic ... \n");

			sc = sl_bt_gatt_discover_characteristics_by_uuid(conn_handle, service_handle,
															 sizeof(led_char_uuid), led_char_uuid);
			app_assert_status(sc);
			break;
		
		/// === Bước 2 xong: Discover Characteristic LED -> Subscribe notify for characteristic
		case STATE_DISCOVERING_CHAR:
			app_state = STATE_SUBSCRIBING_INDICATION;
			// Subscribe to Notification của characteristic vừa tìm được (custome_char_handle) để nhận giá trị khi server gửi Notify
			sl_bt_gatt_set_characteristic_notification(conn_handle,
													   custome_char_handle,
													   sl_bt_gatt_indication); // hoặc sl_bt_gatt_indication

			app_log_info("[Procedure_complete] Subscribing to Indication ... \n");
			break;

		/// === Bước 2 xong: Discover Characteristic LED -> Subscribe indicate for characteristic
		case STATE_SUBSCRIBING_INDICATION:
			app_state = STATE_READY;
			app_log_info("[Procedure_complete] Indicated -> READY - PB0 to toggle Server LED ... \n");
			break;

		/// === Bước 3 xong: Subscribe -> Báo trạng thái Ready 
		case STATE_SUBSCRIBING_NOTIFY:
			app_state = STATE_READY;
			app_log_info("[Procedure_complete] Subcribed -> READY - PB0 to toggle Server LED ... \n");
			break;

		/// === Bước 4 xong: Ready -> Discover DB Hash Characteristic
		case STATE_READY:
			uint8_t dbh_uuid[] = {0x2A, 0x2B};
			db_hash_char_handle = 0;
			app_state = STATE_DISC_DB_HASH_CH;
			sl_bt_gatt_discover_characteristics_by_uuid(conn_handle, service_handle, sizeof(dbh_uuid), dbh_uuid);
			app_log_info("[Procedure_complete] Discovering Database Hash char (0x2B2A) ... \n");

			break;

		/// === Bước 5 xong: Discover Hash char -> đọc Hash Value 
		case STATE_DISC_DB_HASH_CH:
			if (db_hash_char_handle == 0)
			{
				app_log_warning("[Procedure_complete] Database Hash char not found -> server không hỗ trợ GATT Caching \n" );
				app_state = STATE_DISC_DONE;
				break;
			}
			app_state = STATE_READ_DB_HASH;
			sl_bt_gatt_read_characteristic_value(conn_handle, db_hash_char_handle);
			app_log_info("[Procedure_complete] Reading Database Hash ... \n");
			break;

		case STATE_READ_DB_HASH:
			print_hash("[Procedure_complete] Server hash: ", new_db_hash);
			if (has_cached_hash) {
				print_hash("[Procedure_complete] Cached hash: ", cached_db_hash);
				if (memcmp(cached_db_hash, new_db_hash, DB_HASH_LEN) == 0)
				{
					app_log_info("[Procedure_complete] Hash MATCH -> Skip full discovery!");
					cache_valid = true; // Hash giống -, skip discovery
				}
				else
				{
					app_log_info("[Procedure_complete] Hash MISMATCH -> need re-discovery \n");
					cache_valid = false;
				}
			}
			else
			{
				app_log_info("[Procedure_complete] First connection -> no cache yet \n");
				cache_valid = false;
			}

			// Luôn cập nhập cache
			memcpy(cached_db_hash, new_db_hash, DB_HASH_LEN);
			has_cached_hash = true;
			// Tiếp: Discover Client Supported Features (UUID 0x2B29)
			{
				uint8_t uuid[] = {0x29, 0x2B};
				csf_char_handle = 0;
				app_state = STATE_DISC_CSF_CH;
				sl_bt_gatt_discover_characteristics_by_uuid(conn_handle, service_handle, sizeof(uuid), uuid);
				app_log_info("[Procedure_complete] Discovering Client Supported Features char (0x2B29) ... \n");
			}
			break;
		case STATE_DISC_CSF_CH:
			if(csf_char_handle == 0 )
			{
				app_log_warning("[Procedure_complete] CSF char not found \n");
				app_state = STATE_DISC_DONE;
				break;
			}
			{
				uint8_t val = 0x01;
				app_state = STATE_DISC_WRITE_CSF;
				sl_bt_gatt_write_characteristic_value(conn_handle, csf_char_handle, sizeof(val), val);
				app_log_info("[Procedure_complete] Writing Robust Caching bit to CSF ... \n");
			}
			break;
		case STATE_DISC_WRITE_CSF:
			app_log_info("=== GATT Caching setup complete === \n");
			app_log_info(" Service change: subscribed  \n");
			app_log_info(" Database Hash: read & cached \n");
			app_log_info(" Robust Caching: enabled \n");
			if (cache_valid)
			{	
				app_log_info("[Procedure_complete] Using cached service handle - ZERO discovery overhead! \n");
				app_state = STATE_DISC_DONE;
			} else {
				// Hash khác hoặc lần đầu -> discover app services
				app_state = STATE_APP_SVC;
				sl_bt_gatt_discover_primary_services(conn_handle);
				app_log_info("[Procedure_complete] Discovering Application Services ... \n");
			}
			break;
		case STATE_APP_SVC:
			app_state = STATE_DISC_DONE;
			app_log_info("[Procedure_complete] Application service discovery complete \n");
			break;
		default:
			break;
		}
	}
	// This evt is raise by API: 		sl_bt_gatt_read_characteristic_value(conn_handle, custome_char_handle);	
	case sl_bt_evt_gatt_characteristic_value_id: // [LEGACY] - Event when the client receive value after read or notification/indication  
	{
		sl_bt_evt_gatt_characteristic_value_t *val = &evt->data.evt_gatt_characteristic_value;

		if (val->characteristic != custome_char_handle) break;

		uint8_t received = val->value.data[0];

		/// Handle event from read_characteristic_value & value_notification
		if (val->att_opcode == sl_bt_gatt_handle_value_notification || // 27
			val->att_opcode == sl_bt_gatt_read_response				   // 11
		)
		{
			// -- Notify: stack khong tu gui ACK, firmware không cần làm gì thêm
			app_log_info("[Characteristic_value] Notification received (att_type = %d, %d bytes), LED = %d \n", val->att_opcode, val->value.len, received);
			led_state = received;
			if (received)
			{
				sl_led_turn_on(&sl_led_led0);
			}
			else
			{
				sl_led_turn_off(&sl_led_led0);
			}
		}
		else if (val->att_opcode == sl_bt_gatt_handle_value_indication) // 29
		{
			sl_bt_gatt_send_characteristic_confirmation(val->connection);
			app_log_info("[Characteristic_value] Indication received, LED = %d \n", received);
			if (received)
			{
				sl_led_turn_on(&sl_led_led0);
			}
			else
			{
				sl_led_turn_off(&sl_led_led0);
			}
		}

		/// Lưu Database Hash khi đọc được
		if (db_hash_char_handle != 0 
			&& val->characteristic == db_hash_char_handle
			&& val->att_opcode == sl_bt_gatt_read_response
			&& val->value.len == DB_HASH_LEN) 
		{
			memcpy(new_db_hash, val->value.data, DB_HASH_LEN);
		}

		/// Service Changed indication -> invalidate cache

		break;
	}
	
	case sl_bt_evt_connection_closed_id: /* [LEGACY] - Close connection */
		app_log_info("\n\n ===================  evt_connection_closed_id ============== \n ");
		app_log_info("Connection closed (handle=0x%02X, reason=0x%04X) \n",
					 evt->data.evt_connection_closed.connection,
					 evt->data.evt_connection_closed.reason);

		conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;
		service_handle = 0;
		custome_char_handle = 0;
		app_state = STATE_SCANNING;

		start_scanning();
		break;

	case sl_bt_evt_gatt_mtu_exchanged_id: // [MTU exchange]
		// app_log_info("MTU exchanged: %d \n", evt->data.evt_gatt_mtu_exchanged.mtu);

	///////////////////////////////////////////////////////////////////////////
	// Add additional event handlers here as your application requires!      //
	///////////////////////////////////////////////////////////////////////////

		break;
	// -------------------------------
	default: /* Default event handler. */
		break;
	}
}
