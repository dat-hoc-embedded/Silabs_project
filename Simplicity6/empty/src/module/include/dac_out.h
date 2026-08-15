/***************************************************************************//**
 * @file dac_out.h
 * @brief Hardware Voltage DAC (VDAC0) Analog Output Generator Interface.
 *******************************************************************************
 * # License
 * <b>Copyright 2026 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************/

#ifndef DAC_OUT_H
#define DAC_OUT_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/** Number of VDAC output channels. */
#define DAC_OUT_NUM_CHANNELS   2U

/** Channel 0 (PA5) default output target (0.917 V = 917 mV). */
#define DAC_OUT_CH0_PA5_DEFAULT_MV   917U

/** Channel 1 (PA6) default output target (0.937 V = 937 mV). */
#define DAC_OUT_CH1_PA6_DEFAULT_MV   937U

/***************************************************************************//**
 * @brief Initialize VDAC0 hardware peripheral and start dual analog outputs.
 *
 * Configures VDAC0 with AVDD (3.3V) reference:
 *   - Channel 0: Pin PA5 -> Outputs 0.917 V (917 mV) by default. Wire to PA3.
 *   - Channel 1: Pin PA6 -> Outputs 0.937 V (937 mV) by default. Wire to PA4.
 ******************************************************************************/
void dac_out_init(void);

/***************************************************************************//**
 * @brief Dynamically set the analog output voltage for a VDAC channel.
 *
 * @param channel Channel number (0 for PA5, 1 for PA6).
 * @param mv Target output voltage in millivolts (0 to 3300 mV).
 ******************************************************************************/
void dac_out_set_mv(uint8_t channel, uint16_t mv);

#ifdef __cplusplus
}
#endif

#endif /* DAC_OUT_H */
