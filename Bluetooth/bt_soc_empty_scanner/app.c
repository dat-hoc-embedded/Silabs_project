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

// The advertising set handle allocated from Bluetooth stack.
static uint8_t advertising_set_handle = 0xff;
#define TARGET_DEVICE_NAME "Empty Example"

// MAC của board 1
static const bd_addr TARGET_ADDR = {{0x77, 0x8B, 0x5B, 0xB1, 0x5C, 0x6C}};
static uint16_t sync_handle = 0xFFFF;
static bool sync_opened = false;

typedef enum
{
	ADV_LEGACY = 0,
	ADV_PERIODIC
} adv_type_t;
adv_type_t type = ADV_LEGACY;    // Change the type of advertiser: LEGACY | PERIODIC 

typedef enum
{
	STATE_SCANNING,
	STATE_CONNECTING,
	STATE_CONNECTED,
} app_state_t;

static app_state_t app_state = STATE_SCANNING;
static uint8_t conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;

typedef struct
{
	uint8_t type;
	uint8_t counter;
	int16_t temperature_x10;
} pa_payload_t;

// Application Init.
void app_init(void)
{
	/////////////////////////////////////////////////////////////////////////////
	// Put your additional application init code here!                         //
	// This is called once during start-up.                                    //
	/////////////////////////////////////////////////////////////////////////////

	display_init();

	if (type == ADV_PERIODIC)
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
		if (type == ADV_PERIODIC)
		{
			sc = sl_bt_scanner_start(sl_bt_gap_phy_1m, sl_bt_scanner_discover_observation);
			app_assert_status(sc);

			app_log_info("[] Scanning for periodic advertiser ... \n");
		}
		else
		{
			app_log_info("[EVT] SYSTEM BOOT ID");
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
	}

	case sl_bt_evt_scanner_legacy_advertisement_report_id: // [LEGACY]
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
		if (!has_name || strcmp(name, TARGET_DEVICE_NAME) != 0 || memcmp(r->address.addr, TARGET_ADDR.addr, 6) != 0)
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

		break;

		// -------------------------------
		// This event indicates that a connection was closed.

	case sl_bt_evt_connection_closed_id: /* [LEGACY] - Close connection */
		app_log_info("\n\n ===================  evt_connection_closed_id ============== \n ");
		app_log_info("Connection closed (handle=0x%02X, reason=0x%04X) \n",
					 evt->data.evt_connection_closed.connection,
					 evt->data.evt_connection_closed.reason);

		conn_handle = SL_BT_INVALID_CONNECTION_HANDLE;

		start_scanning();
		break;

	case sl_bt_evt_gatt_mtu_exchanged_id: // [MTU exchange]
		// app_log_info("MTU exchanged: %d \n", evt->data.evt_gatt_mtu_exchanged.mtu);

	///////////////////////////////////////////////////////////////////////////
	// Add additional event handlers here as your application requires!      //
	///////////////////////////////////////////////////////////////////////////

	// -------------------------------
	default: /* Default event handler. */
		break;
	}
}
