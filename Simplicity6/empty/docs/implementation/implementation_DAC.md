# EFR32MG24 VDAC Implementation Guide

This document details the architecture, configuration parameters, board considerations, and step-by-step implementation of the **VDAC (Voltage Digital-to-Analog Converter)** module on the Silicon Labs EFR32MG24 (BRD4187C Radio Board on BRD4001A WSTK).

---

## 1. VDAC Hardware Architecture Overview

The EFR32MG24 contains a 12-bit Voltage Digital-to-Analog Converter (VDAC0) capable of continuous or duty-cycled analog output with up to 1 Msps conversion rate.

```text
                               ┌───────────────────► [mainOutEnable] ──► Dedicated Pin (PB00/PB01)
                               │
 [12-bit DAC Core] ──► [Buffer]┤
                               │
                               └───────────────────► [auxOutEnable]  ──► Internal Analog Bus (ABUS)
                                                                            │
                                                                            ├──► GPIO Pin (Port A/B/C/D)
                                                                            └──► Internal ACMP / ADC
```

---

## 2. Configuration Parameters & Detailed Meaning

The VDAC initialization consists of two structures: **Global Config (`VDAC_Init_TypeDef`)** and **Channel Config (`VDAC_InitChannel_TypeDef`)**.

### 2.1. Global Configuration (`VDAC_Init_TypeDef`)

```c
VDAC_Init_TypeDef init = VDAC_INIT_DEFAULT;
```

| Field | Typical Value | Meaning & Behavior | When to Use |
|:---|:---|:---|:---|
| **`prescaler`** | `VDAC_PrescaleCalc(VDAC0, 1000000)` | Divides the peripheral clock down to the DAC clock frequency ($\le 1\text{ MHz}$). | Always calculate with `VDAC_PrescaleCalc()` to ensure DAC clock does not exceed $1\text{ MHz}$. |
| **`reference`** | `vdacRef1V25` | Selects DAC voltage reference source:<br>• `vdacRef1V25`: Internal 1.25V bandgap ($0.305\text{ mV/LSB}$)<br>• `vdacRef2V5`: Internal 2.5V reference<br>• `vdacRefAvdd`: $V_{DD}$ supply rail ($3.3\text{V}$)<br>• `vdacRefExt`: External reference pin | Use `vdacRef1V25` for high-precision, supply-independent voltage outputs $<1.25\text{V}$. |
| **`onDemandClk`** | `false` | When `true`, clocks are requested only during active conversions. When `false`, clock runs continuously. | Use `false` for steady DC voltage output. |
| **`ch0ResetRef`** | `false` | Resets reference between channel 0 conversions. | Keep `false` for continuous DC. |

---

### 2.2. Channel Configuration (`VDAC_InitChannel_TypeDef`)

```c
VDAC_InitChannel_TypeDef initChannel = VDAC_INITCHANNEL_DEFAULT;
```

| Field | Value | Meaning & Behavior | Critical Engineering Reason |
|:---|:---|:---|:---|
| **`highCapLoadEnable`** | `false` | Enables internal compensation capacitor for driving heavy capacitive loads ($>100\text{ pF}$). | **MUST be `false`** for normal DC outputs. If enabled with no heavy load, the internal op-amp buffer oscillates or saturates to the rail ($\approx 1.2\text{V}$). |
| **`powerMode`** | `vdacPowerModeLowPower` | Sets output buffer bias current:<br>• `vdacPowerModeLowPower`: Low bias, ultra-stable for DC voltage output.<br>• `vdacPowerModeHighPower`: High bias, faster settling time ($<1\text{ }\mu\text{s}$). | Use `LowPower` for steady DC bias / reference generation. |
| **`trigMode`** | `vdacTrigModeSw` | Conversion trigger source:<br>• `vdacTrigModeSw`: Triggered immediately on writing to `DATA` register.<br>• `vdacTrigModePrs`: Triggered by PRS hardware event. | Use `Sw` for direct software control. |
| **`sampleOffMode`** | `false` | Duty-cycled sampling mode where the output buffer powers down between samples. | Use `false` (continuous mode) to hold the output voltage constantly. |
| **`mainOutEnable`** | `true` or `false` | Connects buffer output directly to the dedicated physical bond pad (**PB00** for CH0, **PB01** for CH1). | Set `true` when measuring on PB00/PB01. |
| **`auxOutEnable`** | `true` or `false` | Connects buffer output to the internal Analog Bus (ABUS) / auxiliary multiplexer. | Set `true` to route to other GPIOs (e.g. PA06) or internal peripherals (**ACMP**). |
| **`port`** | `vdacChPortNone` / `vdacChPortA` | Selects which GPIO port receives the ABUS signal. | Set to `vdacChPortA` when outputting to Port A. |
| **`pin`** | `0..15` | Selects GPIO pin number on the chosen port. | Must match ABUS parity rule. |
| **`shortOutput`** | `false` | Shorts output buffer internally. | Always `false`. |

---

## 3. Output Routing & Board Considerations (BRD4187C)

### 3.1. Analog Bus (ABUS) & Dual-Channel Setup
On EFR32 Series 2 microcontrollers:
* **VDAC0 Channel 0 (Even pins / ABUS0)**: Configured to output on **`PC06`** (Expansion Header / WSTK_P33) $\implies$ Connects to **ACMP0 Negative input (NEG)**.
* **VDAC0 Channel 1 (Odd pins / ABUS1)**: Configured to output on **`PA07`** (Expansion Header Pin 13) $\implies$ Connects to **ACMP0 Positive input (POS)**.

### 3.2. GPIO Analog Bus Allocation Registers (`xBUSALLOC`)
To connect the internal VDAC channels to external pins via the analog bus, the GPIO bus allocation registers must be set:
* `GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AODD1_VDAC0CH1;` (Routes VDAC0 CH1 to Port A Odd pins)
* `GPIO->CDBUSALLOC |= GPIO_CDBUSALLOC_CDEVEN0_VDAC0CH0;` (Routes VDAC0 CH0 to Port C Even pins)

---

## 4. Complete Implementation Code

### 4.1. Header: `dac_out.h`
```c
#ifndef DAC_OUT_H
#define DAC_OUT_H

#include <stdint.h>

#define DAC_OUT_CH0_PIN_PORT          vdacChPortC /**< Port C */
#define DAC_OUT_CH0_PIN_NUM           6           /**< PC06 (ACMP0 NEG) */
#define DAC_OUT_CH0_DEFAULT_MV        200         /**< Default CH0: 200 mV (0.2V) */

#define DAC_OUT_CH1_PIN_PORT          vdacChPortA /**< Port A */
#define DAC_OUT_CH1_PIN_NUM           7           /**< PA07 (ACMP0 POS) */
#define DAC_OUT_CH1_DEFAULT_MV        200         /**< Default CH1: 200 mV (0.2V) */

#define DAC_OUT_VREF_MV               1250        /**< 1.25V internal ref */
#define DAC_OUT_RESOLUTION            4095        /**< 12-bit max value */
#define DAC_OUT_CLK_FREQ              1000000     /**< Target 1 MHz DAC clock */

void dac_out_init(void);
void dac_out_set_voltage_ch0(float voltage_v);
void dac_out_set_raw_ch0(uint32_t raw_value);
void dac_out_set_voltage_ch1(float voltage_v);
void dac_out_set_raw_ch1(uint32_t raw_value);

#endif /* DAC_OUT_H */
```

### 4.2. Source: `dac_out.c`
```c
#include "dac_out.h"
#include "em_vdac.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "app_log.h"

static uint32_t _mv_to_dac_value(uint32_t mv)
{
  if (mv > DAC_OUT_VREF_MV) {
    mv = DAC_OUT_VREF_MV;
  }
  return (uint32_t)(((uint64_t)mv * DAC_OUT_RESOLUTION) / DAC_OUT_VREF_MV);
}

static uint32_t _volts_to_dac_value(float voltage_v)
{
  if (voltage_v < 0.0f) {
    voltage_v = 0.0f;
  }
  float vref = (float)DAC_OUT_VREF_MV / 1000.0f;
  if (voltage_v > vref) {
    voltage_v = vref;
  }
  return (uint32_t)((voltage_v * (float)DAC_OUT_RESOLUTION) / vref);
}

void dac_out_init(void)
{
  VDAC_Init_TypeDef init = VDAC_INIT_DEFAULT;

  /* 1. Disable digital buffers on PA07 and PC06 for pure analog mode */
  CMU_ClockEnable(cmuClock_GPIO, true);
  GPIO_PinModeSet(gpioPortA, 7, gpioModeDisabled, 0);
  GPIO_PinModeSet(gpioPortC, 6, gpioModeDisabled, 0);

  /* 2. Allocate GPIO Analog Bus (ABUS) */
  GPIO->ABUSALLOC  |= GPIO_ABUSALLOC_AODD1_VDAC0CH1;
  GPIO->CDBUSALLOC |= GPIO_CDBUSALLOC_CDEVEN0_VDAC0CH0;

  /* 3. Clock VDAC0 from HFRCOEM23 */
  CMU_ClockSelectSet(cmuClock_VDAC0, cmuSelect_HFRCOEM23);
  CMU_ClockEnable(cmuClock_HFRCOEM23, true);
  CMU_ClockEnable(cmuClock_VDAC0, true);

  /* 4. Global VDAC0 Init */
  init.prescaler   = VDAC_PrescaleCalc(VDAC0, DAC_OUT_CLK_FREQ);
  init.onDemandClk = false;
  init.reference   = vdacRef1V25;
  VDAC_Init(VDAC0, &init);

  /* 5. Configure Channel 0 -> PC06 via ABUS */
  VDAC_InitChannel_TypeDef ch0_init = VDAC_INITCHANNEL_DEFAULT;
  ch0_init.mainOutEnable     = false;
  ch0_init.auxOutEnable      = true;
  ch0_init.port              = DAC_OUT_CH0_PIN_PORT;
  ch0_init.pin               = DAC_OUT_CH0_PIN_NUM;
  ch0_init.powerMode         = vdacPowerModeLowPower;
  ch0_init.trigMode          = vdacTrigModeSw;
  VDAC_InitChannel(VDAC0, &ch0_init, 0);
  VDAC_Enable(VDAC0, 0, true);

  /* 6. Configure Channel 1 -> PA07 via ABUS */
  VDAC_InitChannel_TypeDef ch1_init = VDAC_INITCHANNEL_DEFAULT;
  ch1_init.mainOutEnable     = false;
  ch1_init.auxOutEnable      = true;
  ch1_init.port              = DAC_OUT_CH1_PIN_PORT;
  ch1_init.pin               = DAC_OUT_CH1_PIN_NUM;
  ch1_init.powerMode         = vdacPowerModeLowPower;
  ch1_init.trigMode          = vdacTrigModeSw;
  VDAC_InitChannel(VDAC0, &ch1_init, 1);
  VDAC_Enable(VDAC0, 1, true);

  /* 7. Set default output voltages */
  VDAC_ChannelOutputSet(VDAC0, 0, _mv_to_dac_value(DAC_OUT_CH0_DEFAULT_MV));
  VDAC_ChannelOutputSet(VDAC0, 1, _mv_to_dac_value(DAC_OUT_CH1_DEFAULT_MV));
}

void dac_out_set_voltage_ch0(float voltage_v)
{
  VDAC_ChannelOutputSet(VDAC0, 0, _volts_to_dac_value(voltage_v));
}

void dac_out_set_voltage_ch1(float voltage_v)
{
  VDAC_ChannelOutputSet(VDAC0, 1, _volts_to_dac_value(voltage_v));
}
```
