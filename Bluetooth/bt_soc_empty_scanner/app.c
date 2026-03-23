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

 
// The variable for button state
static volatile bool btn0_pressed = false;
static volatile bool btn1_pressed = false;
static uint8_t led_state = 0;

// The advertising set handle allocated from Bluetooth stack.
static uint8_t advertising_set_handle = 0xff;
#define TARGET_DEVICE_NAME "Empty Example"

// MAC của board 1
static const bd_addr TARGET_ADDR = {{0x77, 0x8B, 0x5B, 0xB1, 0x5C, 0x6C}};
static uint16_t sync_handle = 0xFFFF;
static uint8_t conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;
static uint32_t service_handle = 0;
static uint16_t char_handle = 0;

static bool sync_opened = false;

/**
 * @brief This enum declare 2 type of advertiser:  LEGACY | PERIODIC 
 * 
 */
typedef enum
{
	ADV_LEGACY = 0,
	ADV_PERIODIC
} adv_type_t;
adv_type_t ad_type = ADV_LEGACY;  

/**
 * @brief This enum declare state to show the process of Bluetooth scanner
 * 
 */
typedef enum
{
	STATE_SCANNING,
	STATE_CONNECTING,
	STATE_CONNECTED,
	STATE_DISCOVERING_SERVICE,
	STATE_DISCOVERING_CHAR,
	STATE_SUBSCRIBING,  
	STATE_READY,
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

//UUID characteristic: 023ec5dc-d5ce-404a-bcfd-96145800d535 (little-endian)
static const uint8_t led_char_uuid[] = {
    0x35, 0xd5, 0x00, 0x58,
    0x14, 0x96,
    0xfd, 0xbc,
    0x4a, 0x40,
    0xce, 0xd5, 0xdc, 0xc5, 0x3e, 0x02
};

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
		app_log_info(" Hello, I am scanner. Periodic Sync Observer \n");
	}
	else
	{
		app_log_info(" ===== Central demo: Scan & Connect ===== \n");
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

		if (btn0_pressed && app_state <= STATE_READY)
		{
			btn0_pressed = false;
			led_state = !led_state;
			sl_bt_gatt_write_characteristic_value(conn_handle, char_handle, sizeof(led_state), &led_state);
			app_log_info("Client: Write LED = %d \n", led_state);

		}
		if (btn1_pressed && app_state <= STATE_READY)
		{
			btn1_pressed = false;
			sl_bt_gatt_read_characteristic_value(conn_handle, char_handle);
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
	app_log_info("[SCAN] Started scanning for \"%s\"...\n ", TARGET_DEVICE_NAME);
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
			app_log_info("[SCAN] Found: \"%s\" addr = %02X:%02X:%02X:%02X:%02X:%02X  RSSI=%d \n", name,
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
		app_log_info("[SCAN] Target found! Connecting ... \n");


		sc = sl_bt_scanner_stop();
		app_assert_status(sc);

		sc = sl_bt_connection_open(r->address, r->address_type, sl_bt_gap_phy_1m, &conn_handle);

		if (sc != SL_STATUS_OK)
		{
			app_log_error("[CONN] connection_open failed: 0x%04x \n", sc);
			start_scanning();
			break;
		}

		app_state = STATE_CONNECTING;
		app_log_info("[CONN] Connection request sent (handle=%d) \n", conn_handle);
		break;
	}

	/* ========  Nhận thông số connection sau khi mở ========= */
	case sl_bt_evt_connection_parameters_id: /* [LEGACY] - */
	{
		app_log_info("\n\n ===================  evt_connection_parameters_id ============== \n ");
		sl_bt_evt_connection_parameters_t *p = &evt->data.evt_connection_parameters;
		app_log_info("[CONN] Parameters: \n");
		app_log_info(" 		 Interval: %d * 1.25ms = %d ms \n", p->interval, (p->interval * 5) / 4);

		app_log_info("		 Latency : %d \n", p->latency);
		app_log_info("		 Timeout : %d ms \n", p->timeout * 10);
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

		// Change to Discovering service ... \n
		app_state = STATE_DISCOVERING_SERVICE;
		app_log_info("Client: Discovering characteristic ... \n");
		sc = sl_bt_gatt_discover_primary_services_by_uuid(conn_handle,
														  sizeof(led_service_uuid),
														  led_service_uuid);
		app_assert_status(sc);

		break;
		// -------------------------------
		// This event indicates that a connection was closed.

	case sl_bt_evt_gatt_service_id: 
		if (app_state == STATE_DISCOVERING_SERVICE)
		{	
			service_handle = evt->data.evt_gatt_service.service;
			app_log_info("Client: Service found (handle=%lu)\n", service_handle);
		}
		break;

	case sl_bt_evt_gatt_characteristic_id:
		if (app_state == STATE_DISCOVERING_CHAR)
		{
			char_handle = evt->data.evt_gatt_characteristic.characteristic;
			app_log_info("Client: Characteristic found (handle = %lu)\n", char_handle);
		}
		break;

	case sl_bt_evt_gatt_procedure_completed_id:
		uint16_t result = evt->data.evt_gatt_procedure_completed.result;
		if (result != SL_STATUS_OK) {
			app_log_error("GATT procedure failed: 0x%04x \n", result);
			break;
		}

		if (app_state == STATE_DISCOVERING_SERVICE) 
		{
			app_state = STATE_DISCOVERING_CHAR;
			app_log_info("Client: Discovering characteristic ... \n");

			sc = sl_bt_gatt_discover_characteristics_by_uuid(conn_handle, service_handle,
															 sizeof(led_char_uuid), led_char_uuid);
			app_assert_status(sc);

		}else if (app_state == STATE_DISCOVERING_CHAR)
		{
			app_state = STATE_SUBSCRIBING;     

			//Subscribe to Notify của characteristic vừa tìm được (char_handle) để nhận giá trị khi server gửi Notify
			sl_bt_gatt_set_characteristic_notification(conn_handle,
													   char_handle,
													   sl_bt_gatt_notification);   // hoặc sl_bt_gatt_indication
			
			app_log_info("Client: Subscribing to Notify ... \n");
		} else if (app_state == STATE_SUBSCRIBING) {

			app_state = STATE_READY;
			app_log_info("Client: Subcribed -> READY - PB0 to toggle Server LED \n");

		}
		break;

	// This evt is raise by API: 		sl_bt_gatt_read_characteristic_value(conn_handle, char_handle);	
	case sl_bt_evt_gatt_characteristic_value_id: // [LEGACY] - Event when the client receive value after read or notification/indication  
	{
		app_log_info("Client: Read value ");
		sl_bt_evt_gatt_characteristic_value_t *val = &evt->data.evt_gatt_characteristic_value;

		if (val->characteristic != char_handle) break;

		uint8_t received = val->value.data[0];

		if (val->att_opcode == sl_bt_gatt_handle_value_notification || //27
			val->att_opcode == sl_bt_gatt_read_response ||   //11
			val->att_opcode == sl_bt_gatt_handle_value_indication)  // 29
		{
			// -- Notify: stack khong tu gui ACK, firmware không cần làm gì thêm
			app_log_info("Client: Notification received (att_type = %d, %d bytes), LED = %d \n", val->att_opcode, val->value.len, received);
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
		break;
	}
	
	case sl_bt_evt_connection_closed_id: /* [LEGACY] - Close connection */
		app_log_info("\n\n ===================  evt_connection_closed_id ============== \n ");
		app_log_info("Connection closed (handle=0x%02X, reason=0x%04X) \n",
					 evt->data.evt_connection_closed.connection,
					 evt->data.evt_connection_closed.reason);

		conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;
		service_handle = 0;
		char_handle = 0;
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
