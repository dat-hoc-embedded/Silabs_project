#ifndef DAC_OUT_H
#define DAC_OUT_H

/***************************************************************************//**
 * @file dac_out.h
 * @brief Dual-channel VDAC output module for EFR32MG24
 *
 * - Channel 0: Outputs on PC06 via ABUS (CDEVEN0) -> ACMP0 NEGSEL
 * - Channel 1: Outputs on PA07 via ABUS (AODD1)   -> ACMP0 POSSEL
 * Reference: 1.25V internal bandgap, 12-bit resolution (0.305 mV/step).
 ******************************************************************************/

#include <stdint.h>

/* ── Configuration ───────────────────────────────────────────────────────── */
#define DAC_OUT_CH0_PIN_PORT          vdacChPortC /**< Port C */
#define DAC_OUT_CH0_PIN_NUM           6           /**< PC06 (ACMP0 NEG) */
#define DAC_OUT_CH0_DEFAULT_MV        100      /**< Default CH0: 200 mV (0.2V) */

#define DAC_OUT_CH1_PIN_PORT          vdacChPortA /**< Port A */
#define DAC_OUT_CH1_PIN_NUM           7           /**< PA07 (ACMP0 POS) */
#define DAC_OUT_CH1_DEFAULT_MV        500         /**< Default CH1: 200 mV (0.2V) */

#define DAC_OUT_VREF_MV               1250        /**< 1.25V internal ref */
#define DAC_OUT_RESOLUTION            4095        /**< 12-bit max value */
#define DAC_OUT_CLK_FREQ              1000000     /**< Target 1 MHz DAC clock */

/* ── Public API ──────────────────────────────────────────────────────────── */

/***************************************************************************//**
 * @brief Initialize VDAC0 with both Channel 0 (PC06) and Channel 1 (PA07).
 ******************************************************************************/
void dac_out_init(void);

/***************************************************************************//**
 * @brief Set VDAC0 Channel 0 (PC06 / ACMP NEG) output voltage (in Volts).
 * @param[in] voltage_v  Desired voltage (0.0 to 1.25). Clamped to range.
 ******************************************************************************/
void dac_out_set_voltage_ch0(float voltage_v);

/***************************************************************************//**
 * @brief Set VDAC0 Channel 0 (PC06 / ACMP NEG) output raw 12-bit DAC code.
 * @param[in] raw_value  DAC code (0 to 4095). Clamped if out of range.
 ******************************************************************************/
void dac_out_set_raw_ch0(uint32_t raw_value);

/***************************************************************************//**
 * @brief Set VDAC0 Channel 1 (PA07 / ACMP POS) output voltage (in Volts).
 * @param[in] voltage_v  Desired voltage (0.0 to 1.25). Clamped to range.
 ******************************************************************************/
void dac_out_set_voltage_ch1(float voltage_v);

/***************************************************************************//**
 * @brief Set VDAC0 Channel 1 (PA07 / ACMP POS) output raw 12-bit DAC code.
 * @param[in] raw_value  DAC code (0 to 4095). Clamped if out of range.
 ******************************************************************************/
void dac_out_set_raw_ch1(uint32_t raw_value);

/***************************************************************************//**
 * @brief Get current configured VDAC0 Channel 0 voltage in millivolts.
 ******************************************************************************/
uint32_t dac_out_get_voltage_ch0_mv(void);

/***************************************************************************//**
 * @brief Get current configured VDAC0 Channel 1 voltage in millivolts.
 ******************************************************************************/
uint32_t dac_out_get_voltage_ch1_mv(void);

/* Legacy aliases mapping to Channel 1 (PA07) */
#define dac_out_set_voltage(v)  dac_out_set_voltage_ch1(v)
#define dac_out_set_raw(r)      dac_out_set_raw_ch1(r)

#endif /* DAC_OUT_H */
