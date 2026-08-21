/***************************************************************************//**
 * @file
 * @brief Top level application functions
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

/***************************************************************************//**
 * Initialize application.
 ******************************************************************************/
#include "blink.h"
#include "sound_pin.h"
#include "ble_app.h"
#include "app_log.h"
#include "dac_out.h"
#include "acmp_comp.h"
#include "cli.h"

void app_init(void) {
  // blink_init();
  // init_pin_sound();
  ble_app_init();
  dac_out_init();
  acmp_comp_init();
  cli_init();
}

/***************************************************************************//**
 * App ticking function.
 ******************************************************************************/
void app_process_action(void) {
  // blink_process(); // Có thể tạm ngắt blink tự động để nháy theo âm thanh
  // sound_pin_process();
  // ble_app_process();
  acmp_comp_process();
  cli_process();
}

