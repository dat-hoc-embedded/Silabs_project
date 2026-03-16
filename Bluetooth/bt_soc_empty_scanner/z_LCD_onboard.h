#ifndef z_LCD_onboard.h
#define z_LCD_onboard.h

#include "glib.h"
#include "dmd.h"
#include "sl_board_control.h"
#include "app_assert.h"
#include "sl_bgapi.h"
#include "sl_bt_api.h"


/** ------------ Display configuration --------- */
#define LCD_LINE_HEIGHT 9
#define LCD_MAX_LINES 13
#define LCD_TITLE_LINE 0
#define LCD_DEVICE_FIRST 1

#define MAX_DEVICES 12
#define DEVICE_NAME_LEN 20
#define RSSI_UPDATE_THRESHOLD 3  // only redraw if RSSI changed by >= 3 dBm

typedef struct {
    bd_addr address;
    int8_t rssi;
    char name[DEVICE_NAME_LEN + 1];
    bool has_name;
    bool valid; 
}bt_device_t;

void display_init(void);

int check_device(const bd_addr * );

void add_device(sl_bt_evt_scanner_legacy_advertisement_report_t *report);

#endif
