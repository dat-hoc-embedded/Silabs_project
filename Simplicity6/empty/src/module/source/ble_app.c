/**
 * @file ble_app.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief BLE application — advertising, GATT server, event handling.
 *
 * Implements sl_bt_on_event() to handle all Bluetooth stack events.
 * Manages advertising as "Embeddat_BLE" and serves a custom GATT
 * service with LED State (read/write/notify) and Blink Interval
 * (read/write) characteristics.
 *
 * @version 0.1
 * @date 2026-08-05
 *
 * @copyright Copyright (c) 2026
 *
 */

#include "ble_app.h"
#include "blink.h"
#include "app_log.h"

/* Silicon Labs BLE stack headers */
#include "sl_bluetooth.h"
#include "sl_bt_api.h"
#include "gatt_db.h"

/* --------------------------------------------------------------------------
 * Private constants
 * -------------------------------------------------------------------------- */

/** Device name shown during advertising scan. */
#define BLE_DEVICE_NAME           "Embeddat_BLE"

/** Advertising interval range (in units of 0.625 ms).
 *  160 = 100 ms, good for development. */
#define BLE_ADV_INTERVAL_MIN      160
#define BLE_ADV_INTERVAL_MAX      160

/** LED write command values. */
#define LED_CMD_OFF    0x00
#define LED_CMD_ON     0x01
#define LED_CMD_TOGGLE 0x02

/* --------------------------------------------------------------------------
 * Private state
 * -------------------------------------------------------------------------- */

/** Advertising set handle (allocated by the stack). */
static uint8_t _adv_handle = 0xFF;

/** Connection handle for the active connection (0xFF = none). */
static uint8_t _conn_handle = 0xFF;

/** Whether the client has enabled notifications for LED State. */
static bool _led_notify_enabled = false;

/** Tracks the last LED state that was sent as a notification,
 *  so we only notify on actual changes. */
static uint8_t _last_notified_led_state = 0xFF;

/* --------------------------------------------------------------------------
 * Private helpers
 * -------------------------------------------------------------------------- */

/**
 * @brief Start advertising with the configured device name.
 */
static void _start_advertising(void)
{
  sl_status_t sc;

  /* Create an advertising set (first time) or reuse existing handle. */
  sc = sl_bt_advertiser_create_set(&_adv_handle);
  if (sc != SL_STATUS_OK && sc != SL_STATUS_ALREADY_EXISTS) {
    app_log_info("BLE: adv set create failed: 0x%04lx\n", (unsigned long)sc);
    return;
  }

  /* Set advertising interval. */
  sc = sl_bt_advertiser_set_timing(
      _adv_handle,
      BLE_ADV_INTERVAL_MIN,
      BLE_ADV_INTERVAL_MAX,
      0,   /* duration: 0 = advertise indefinitely */
      0);  /* max events: 0 = no limit */
  if (sc != SL_STATUS_OK) {
    app_log_info("BLE: adv timing failed: 0x%04lx\n", (unsigned long)sc);
  }

  /* Start advertising (connectable, undirected). */
  sc = sl_bt_legacy_advertiser_generate_data(
      _adv_handle,
      sl_bt_advertiser_general_discoverable);
  if (sc != SL_STATUS_OK) {
    app_log_info("BLE: adv data gen failed: 0x%04lx\n", (unsigned long)sc);
  }

  sc = sl_bt_legacy_advertiser_start(
      _adv_handle,
      sl_bt_advertiser_connectable_scannable);
  if (sc != SL_STATUS_OK) {
    app_log_info("BLE: adv start failed: 0x%04lx\n", (unsigned long)sc);
  } else {
    app_log_info("BLE: Advertising as \"%s\"\n", BLE_DEVICE_NAME);
  }
}

/**
 * @brief Send an LED state notification to the connected client.
 *
 * Only sends if notifications are enabled and state has actually changed.
 */
static void _notify_led_state(void)
{
  if (!_led_notify_enabled || _conn_handle == 0xFF) {
    return;
  }

  uint8_t state = blink_get_led_state();
  if (state == _last_notified_led_state) {
    return;  /* No change — skip. */
  }
  _last_notified_led_state = state;

  sl_status_t sc = sl_bt_gatt_server_notify_all(
      gattdb_led_state,
      1,       /* data length */
      &state);
  if (sc != SL_STATUS_OK) {
    app_log_info("BLE: notify failed: 0x%04lx\n", (unsigned long)sc);
  }
}

/* --------------------------------------------------------------------------
 * Public API
 * -------------------------------------------------------------------------- */

void ble_app_init(void)
{
  /* Nothing to do here — advertising starts on sl_bt_evt_system_boot_id. */
  app_log_info("BLE: ble_app_init() — waiting for stack boot event\n");
}

/* --------------------------------------------------------------------------
 * BLE Event Handler — called by the Bluetooth stack
 * -------------------------------------------------------------------------- */

void sl_bt_on_event(sl_bt_msg_t *evt)
{
  sl_status_t sc;

  switch (SL_BT_MSG_ID(evt->header)) {

    /* ── System boot ────────────────────────────────────────────── */
    case sl_bt_evt_system_boot_id:
      app_log_info("BLE: Stack booted (v%d.%d.%d)\n",
                   evt->data.evt_system_boot.major,
                   evt->data.evt_system_boot.minor,
                   evt->data.evt_system_boot.patch);

      /* Set the device name in the GATT database. */
      sc = sl_bt_gatt_server_write_attribute_value(
          gattdb_device_name,
          0,
          sizeof(BLE_DEVICE_NAME) - 1,
          (const uint8_t *)BLE_DEVICE_NAME);
      if (sc != SL_STATUS_OK) {
        app_log_info("BLE: set device name failed: 0x%04lx\n",
                     (unsigned long)sc);
      }

      _start_advertising();
      break;

    /* ── Connection opened ──────────────────────────────────────── */
    case sl_bt_evt_connection_opened_id:
      _conn_handle = evt->data.evt_connection_opened.connection;
      _led_notify_enabled = false;
      _last_notified_led_state = 0xFF;
      app_log_info("BLE: Connected (handle=%d)\n", _conn_handle);
      break;

    /* ── Connection closed ──────────────────────────────────────── */
    case sl_bt_evt_connection_closed_id:
      app_log_info("BLE: Disconnected (reason=0x%04x)\n",
                   evt->data.evt_connection_closed.reason);
      _conn_handle = 0xFF;
      _led_notify_enabled = false;

      /* Restart advertising so the device is discoverable again. */
      _start_advertising();
      break;

    /* ── GATT server: client changed characteristic status ──────── */
    case sl_bt_evt_gatt_server_characteristic_status_id: {
      sl_bt_evt_gatt_server_characteristic_status_t *status =
          &evt->data.evt_gatt_server_characteristic_status;

      /* Check if this is the LED State characteristic notifications. */
      if (status->characteristic == gattdb_led_state) {
        if (status->status_flags == sl_bt_gatt_server_client_config) {
          /* Client config changed (CCC descriptor written). */
          _led_notify_enabled =
              (status->client_config_flags & sl_bt_gatt_notification) != 0;
          app_log_info("BLE: LED notify %s\n",
                       _led_notify_enabled ? "ENABLED" : "DISABLED");

          /* Send initial state immediately if notifications were enabled. */
          if (_led_notify_enabled) {
            _last_notified_led_state = 0xFF;  /* Force send. */
            _notify_led_state();
          }
        }
      }
      break;
    }

    /* ── GATT server: user read request ─────────────────────────── */
    case sl_bt_evt_gatt_server_user_read_request_id: {
      sl_bt_evt_gatt_server_user_read_request_t *req =
          &evt->data.evt_gatt_server_user_read_request;

      if (req->characteristic == gattdb_led_state) {
        /* Read LED state: 0 = OFF, 1 = ON. */
        uint8_t state = blink_get_led_state();
        sl_bt_gatt_server_send_user_read_response(
            req->connection,
            req->characteristic,
            0,       /* att_error: 0 = success */
            1,       /* data_len */
            &state,
            NULL);
      } else if (req->characteristic == gattdb_blink_interval) {
        /* Read blink interval as little-endian uint16. */
        uint16_t interval = blink_get_interval_ms();
        sl_bt_gatt_server_send_user_read_response(
            req->connection,
            req->characteristic,
            0,
            2,
            (const uint8_t *)&interval,
            NULL);
      } else {
        /* Unknown characteristic — return error. */
        sl_bt_gatt_server_send_user_read_response(
            req->connection,
            req->characteristic,
            0x05,  /* ATT_ERR_INSUFFICIENT_AUTHENTICATION (or use 0x06) */
            0,
            NULL,
            NULL);
      }
      break;
    }

    /* ── GATT server: user write request ────────────────────────── */
    case sl_bt_evt_gatt_server_user_write_request_id: {
      sl_bt_evt_gatt_server_user_write_request_t *req =
          &evt->data.evt_gatt_server_user_write_request;

      uint8_t att_error = 0;

      if (req->characteristic == gattdb_led_state) {
        if (req->value.len == 1) {
          uint8_t cmd = req->value.data[0];
          switch (cmd) {
            case LED_CMD_OFF:
              blink_set_led_state(false);
              app_log_info("BLE: LED → OFF\n");
              break;
            case LED_CMD_ON:
              blink_set_led_state(true);
              app_log_info("BLE: LED → ON\n");
              break;
            case LED_CMD_TOGGLE:
              blink_toggle_led();
              app_log_info("BLE: LED → TOGGLE\n");
              break;
            default:
              att_error = 0x80;  /* Application error. */
              app_log_info("BLE: Unknown LED cmd: 0x%02x\n", cmd);
              break;
          }
        } else {
          att_error = 0x0D;  /* ATT_ERR_INVALID_ATTRIBUTE_VALUE_LENGTH */
        }

      } else if (req->characteristic == gattdb_blink_interval) {
        if (req->value.len == 2) {
          uint16_t new_interval =
              (uint16_t)req->value.data[0] |
              ((uint16_t)req->value.data[1] << 8);

          /* Sanity check: minimum 50 ms, maximum 10 000 ms. */
          if (new_interval >= 50 && new_interval <= 10000) {
            blink_set_interval_ms(new_interval);
            app_log_info("BLE: Blink interval → %u ms\n", new_interval);
          } else {
            att_error = 0x80;  /* Application error: out of range. */
            app_log_info("BLE: Interval out of range: %u\n", new_interval);
          }
        } else {
          att_error = 0x0D;
        }

      } else {
        att_error = 0x06;  /* ATT_ERR_REQUEST_NOT_SUPPORTED */
      }

      /* Send write response. */
      sl_bt_gatt_server_send_user_write_response(
          req->connection,
          req->characteristic,
          att_error);

      /* If LED state was changed, send notification. */
      if (att_error == 0 && req->characteristic == gattdb_led_state) {
        _notify_led_state();
      }
      break;
    }

    /* ── Default: ignore unhandled events ───────────────────────── */
    default:
      break;
  }
}

/* --------------------------------------------------------------------------
 * Periodic check — call from app_process_action()
 * -------------------------------------------------------------------------- */

/**
 * @brief Check if LED state changed and send notification.
 *
 * Call this from app_process_action() to catch LED changes
 * that happen outside of BLE writes (e.g., from the blink timer).
 */
void ble_app_process(void)
{
  _notify_led_state();
}
