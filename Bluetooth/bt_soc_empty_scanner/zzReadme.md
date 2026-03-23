## This is the process of client 

### Scanning 

```Cpp
case sl_bt_evt_system_boot_id: 
    start_scanning();

static void start_scanning(void)
{
sc = sl_bt_scanner_set_parameters(sl_bt_scanner_scan_mode_passive, 16, 16);

sc = sl_bt_scanner_start(sl_bt_scanner_scan_phy_1m, sl_bt_scanner_discover_generic);

app_state = STATE_SCANNING;
}
```

### advertisement report
```Cpp
case sl_bt_evt_scanner_legacy_advertisement_report_id:
    sc = sl_bt_scanner_stop();
    sc = sl_bt_connection_open(r->address, r->address_type, sl_bt_gap_phy_1m, &conn_handle);

```
### Parameters of advertiser (Peripheral)
- This event help print some parameters (handle, address, role)
```Cpp
case sl_bt_evt_connection_opened_id:

```
### Paramerter of connection
```Cpp
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
```

### Found Service

```Cpp
sc = sl_bt_gatt_discover_primary_services_by_uuid(conn_handle,
                                                    sizeof(led_service_uuid),
                                                    led_service_uuid);
```

### Found Characteristics
```Cpp
sc = sl_bt_gatt_discover_characteristics_by_uuid(conn_handle, service_handle,
															 sizeof(led_char_uuid), led_char_uuid);
```

