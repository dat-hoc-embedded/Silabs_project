/**
 * @file z_LCD_onboard.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2026-03-13
 * 
 * @copyright Copyright (c) 2026
 * 
 */


#include "z_LCD_onboard.h"



/** ------------ State -------------- */
static GLIB_Context_t glib_ctx;
static bt_device_t device_list[MAX_DEVICES];
static uint8_t device_count = 0 ;
bool display_dirty = false ; 
/**
 * @brief 
 * 
 */
void display_init(void){
    sl_status_t sc;
    sc = sl_board_enable_display();
    app_assert_status(sc);

    sc = DMD_init(0);
    app_assert_status(sc);

    sc = GLIB_contextInit(&glib_ctx);
    app_assert_status(sc);

    glib_ctx.backgroundColor = White;
    glib_ctx.backgroundColor = Black;

    GLIB_setFont(&glib_ctx, (GLIB_Font_t *)&GLIB_FontNarrow6x8);
    GLIB_clear(&glib_ctx);

    GLIB_drawStringOnLine(&glib_ctx, "=== BT Scanner ===", LCD_TITLE_LINE, GLIB_ALIGN_LEFT, 0, 0, true);
    GLIB_drawStringOnLine(&glib_ctx, "    Scanning ... ", LCD_DEVICE_FIRST, GLIB_ALIGN_LEFT, 0, 0, true);

    DMD_updateDisplay();

}

/**
 * @brief Return the index of addr in device_list, or - 1 if not found. 
 * 
 * @param addr : addr of device that scanner can scan 
 * @retval int 
 */
int check_device(const bd_addr *addr){
    for (int i = 0; i < device_count; i++){
        // Compare the address bytes, do not memcpy (which always returns dest).
        if (memcmp(device_list[i].address.addr, addr->addr, 6) == 0) {
            return i;
        }
    }
    return -1;  
}

/**
 * @brief 
 * 
 * @param report : 
 */
void add_device(sl_bt_evt_scanner_legacy_advertisement_report_t *report , device_name_parse_t parser){
    char name[DEVICE_NAME_LEN + 1] = {0};   // add 1 byte '\0'
    bool has_name = parser(report -> data.data, report->data.len, name, sizeof(name));

    int idx = check_device(&(report->address)); // 
    
    if (idx < 0) { // if dont't have in list & device_count < 12 
        if (device_count < MAX_DEVICES) {
            idx = device_count ++;    // device 
            device_list[idx].address = report -> address;
            device_list[idx].rssi = report -> rssi; 
            device_list[idx].has_name = (name[0] != '\0');
            device_list[idx].valid = true;
            strncpy(device_list[idx].name, name, DEVICE_NAME_LEN);
            device_list[idx].name[DEVICE_NAME_LEN] = '\0';

            display_dirty = true;  // set flag to update display in main loop
            app_proceed();

            app_log_info("New device [%d]: \"%s\" RSSI = %d dBm addr = %02X:%02X:%02X:%02X:%02X:%02X \n",
                        idx, device_list[idx].has_name ? device_list[idx].name : "(no name)", 
                        device_list[idx].rssi,
                        device_list[idx].address.addr[5], device_list[idx].address.addr[4],
                        device_list[idx].address.addr[3], device_list[idx].address.addr[2],
                        device_list[idx].address.addr[1], device_list[idx].address.addr[0]);
            
        }
    } else {
        bool changed = false;
        if (abs((int) report -> rssi - (int)device_list[idx].rssi) >= RSSI_UPDATE_THRESHOLD) {
            device_list[idx].rssi = report -> rssi;
            changed = true;
        }
        if (!device_list[idx].has_name && name[0] != '\0') {
            strncpy(device_list[idx].name, name, DEVICE_NAME_LEN);
            device_list[idx].name[DEVICE_NAME_LEN] = '\0';
            device_list[idx].has_name = true;
            changed = true;
        }
        if (changed) {
            display_dirty = true; 
            app_proceed();
        }
    }
}

void refresh_display(void){
    GLIB_clear(&glib_ctx);
    GLIB_drawStringOnLine(&glib_ctx, "=== BT Scanner ===", LCD_TITLE_LINE, GLIB_ALIGN_LEFT, 0, 0, true);

    uint8_t rows = (device_count < MAX_DEVICES) ? device_count : MAX_DEVICES; // max row = 12, min row = device_count
    char line_bufs[LCD_MAX_LINES][32] = {{0}};

    for (uint8_t i = 0; i < rows; i ++) {  // max i = 11, max line = 12
        uint8_t display_line = (uint8_t)(LCD_DEVICE_FIRST + i);   // display_line starts from 1, not 0, because line 0 is title line.
        if(display_line >= LCD_MAX_LINES) {
            device_count = 0; // reset device count to start from first line after reaching max lines
            break; // stop displaying more devices if we exceed the max lines
        }

        char *line_buf = line_bufs[i];
        bt_device_t device_i = device_list[i];  // Get the device info from the list

        if (device_list[i].has_name) {
            // snprintf will always null-terminate, so we are safe to pass to GLIB_drawStringOnLine.
            // snprintf(line_buf, sizeof(line_bufs[i]), "%-15.15s %02X:%02X:%02X", device_i.name,
            //          device_i.address.addr[2], device_i.address.addr[1], device_i.address.addr[0]);
            snprintf(line_buf, sizeof(line_bufs[i]), "%-15.15s %4d", device_i.name, device_i.rssi);
        } else {
            // "AB:CD:EF -65" (Last 3 bytes of address + RSSI)
            snprintf(line_buf, sizeof(line_bufs[i]), "%02X:%02X:%02X   %4d", device_i.address.addr[2], device_i.address.addr[1], device_i.address.addr[0], (int)device_i.rssi);
        }

        GLIB_drawStringOnLine(&glib_ctx, line_buf, display_line, GLIB_ALIGN_LEFT, 0, 0, true);

        if (device_count == MAX_DEVICES) {
            device_count = 0; // reset device count to start from first line after reaching max devices
            break; // stop displaying more devices if we reach max devices
        }
    }

    DMD_updateDisplay();
    display_dirty = false;
}