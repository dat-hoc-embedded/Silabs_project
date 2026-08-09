/**
 * @file iadc_adc.h
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief IADC scan module — public API for analog voltage readings.
 *
 * Provides 2-channel single-ended ADC readings (PA3, PA4) at 1 kHz
 * using the IADC local timer trigger. Results are in millivolts.
 *
 * @version 0.1
 * @date 2026-08-07
 *
 * @copyright Copyright (c) 2026
 *
 */
#ifndef IADC_ADC_H
#define IADC_ADC_H

#include <stdint.h>

/** Number of IADC scan channels. */
#define IADC_ADC_NUM_CHANNELS  2

/** Channel index definitions. */
#define IADC_ADC_CH_PA3  0
#define IADC_ADC_CH_PA4  1

/** Initialize IADC in scan mode with local timer trigger at 1 kHz. */
void iadc_adc_init(void);

/** Process IADC results (call from app_process_action). */
void iadc_adc_process(void);

/**
 * @brief Get the latest reading for a channel in millivolts.
 * @param channel  0 = PA3, 1 = PA4. Use IADC_ADC_CH_PA3 / IADC_ADC_CH_PA4.
 * @return Voltage in millivolts (0–3300), or 0 if channel is invalid.
 */
uint16_t iadc_adc_get_mv(uint8_t channel);

#endif /* IADC_ADC_H */
