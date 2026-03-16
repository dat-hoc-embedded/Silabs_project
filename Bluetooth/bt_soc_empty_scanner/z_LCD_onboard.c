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
static bool display_dirty = false;

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
        if (memcpy(device_list[i].address.addr, addr -> addr, 6)  == 0) {
            return i;
        }
    }
    return -1;  
}

void add_device(sl_bt_evt_scanner_legacy_advertisement_report_t *report){
    char name[DEVICE_NAME_LEN + 1];   // add 1 byte '\0'
    




}