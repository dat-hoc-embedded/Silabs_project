# EFR32MG24 ACMP (Analog Comparator) Implementation Guide

This document details the architecture, configuration parameters, input routing, interrupt handling, and step-by-step implementation of the **AC****MP (Analog Comp****arator)** module on the Silicon Labs EFR32MG24.

---

## 1. ACMP Hardware Architecture Overview

The Analog Comparator (ACMP0) compares two analog voltages ($V_{POS}$ and $V_{NEG}$) and produces a digital output indicating which voltage is higher:

$$
\text{ACMP Output} = \begin{cases} \mathbf{1}\text{ (HIGH)} & \text{if } V_{POS} > V_{NEG} \\ \mathbf{0}\text{ (LOW)} & \text{if } V_{NEG} > V_{POS} \end{cases}
$$

```text
                  ┌────────────────────────────────────────────────────────┐
                  │ EFR32MG24 Silicon                                      │
                  │                                                        │
                  │  ┌──────────────┐     Analog Bus (AODD1)               │
                  │  │  VDAC0 CH1   ├──────────────────────┐               │
                  │  │ (POS Voltage)├──► [PA07] (EXP 13)   │               │
                  │  └──────────────┘                      ▼               │
                  │                                  ┌───────────┐         │
                  │                                  │  POS (+)  │         │
                  │                                  │           ├──► OUT ─┼─► Interrupt -> Log
                  │                                  │  NEG (-)  │    (1/0)│
                  │  ┌──────────────┐                │           │         │
                  │  │  VDAC0 CH0   ├──────────────────────▲               │
                  │  │ (NEG Voltage)├──► [PC06] (WSTK_P33) │               │
                  │  └──────────────┘     Analog Bus (CDEVEN0)             │
                  │                                  ACMP0                 │
                  └────────────────────────────────────────────────────────┘
```

---

## 2. Configuration Parameters & Detailed Meaning

ACMP is configured using the Silicon Labs HAL structure `sl_hal_acmp_init_t`:

```c
typedef struct {
  uint32_t                        bias_prog;
  uint32_t                        vref_div;
  sl_hal_acmp_input_range_t       input_range;
  sl_hal_acmp_accuracy_t          accuracy;
  sl_hal_acmp_hysteresis_t        hysteresis_rise;
  sl_hal_acmp_hysteresis_t        hysteresis_fall;
  bool                            inactive_value;
} sl_hal_acmp_init_t;
```

---

### 2.1. Parameter Breakdown & When to Use

| Parameter | Selected Value | What It Does & Technical Behavior | When to Use This Setting |
|:---|:---|:---|:---|
| **`accuracy`** | `SL_HAL_ACMP_ACCURACY_HIGH` | Trims internal comparator offset voltage down to $<5\text{ mV}$. | **Use HIGH** for precision threshold detection. |
| **`hysteresis_rise`**<br>**`hysteresis_fall`** | `SL_HAL_ACMP_HYSTERESIS_DISABLED` | Controls hysteresis window ($0\text{ mV}$, $10\text{ mV}$, $20\text{ mV}$, $30\text{ mV}$). | **Use DISABLED** for immediate zero-delay switching. |
| **`bias_prog`** | `4` (Default Bias) | Controls internal bias current ($0\text{ to }7$). | **Use 4** for sub-microsecond response time with moderate power consumption. |
| **`input_range`** | `SL_HAL_ACMP_INPUT_RANGE_FULL` | Sets allowable common-mode voltage range ($0\text{ V}$ to $V_{DD}$). | **Use FULL** to compare signals across the entire $0\text{–}3.3\text{ V}$ range. |
| **`vref_div`** | `0` | Divides internal VREF ladder. | Not used when comparing against external/ABUS signals. |
| **`inactive_value`** | `false` | Digital output level during the power-up warm-up period. | Set to `false` (0) to prevent false triggers during startup. |

---

## 3. Channel Routing Matrix & Analog Bus Parity

```c
sl_hal_acmp_set_input(ACMP0, negative_input, positive_input);
```

### 3.1. Input Source Selection

* **Positive Input (`positive_input`)**: `SL_HAL_ACMP_INPUT_PA7`
  * Connects to **PA07** (Expansion Header Pin 13 / WSTK_P10) driven by VDAC0 CH1 via ABUS.
* **Negative Input (`negative_input`)**: `SL_HAL_ACMP_INPUT_PC6`
To avoid bus contention inside the chip, `positive_input` and `negative_input` must not share the same parity bus:

* **PA07**: Odd bus (ABUS1 / Pin 7)
* **PC06**: Even bus (ABUS0 / Pin 6)
* $\implies$ **Valid non-conflicting routing!**

---

## 4. Interrupt & Event Processing Architecture

To adhere to real-time embedded safety rules:

1. **ISR (`ACMP0_IRQHandler`)**: Runs on hardware edge trigger (`RISE` / `FALL`), clears flags, captures state into atomic variables, and exits immediately.
2. **Process Action (`acmp_comp_process`)**: Called non-blockingly in the main loop (`app_process_action`) to safely format and log the event over RTT/UART without stalling interrupts.

---

## 5. Complete Implementation Code

### 5.1. Header: `acmp_comp.h`

```c
#ifndef ACMP_COMP_H
#define ACMP_COMP_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

void acmp_comp_init(void);
void acmp_comp_process(void);
bool acmp_comp_get_output(void);

#ifdef __cplusplus
}
#endif

#endif /* ACMP_COMP_H */
```

### 5.2. Source: `acmp_comp.c`

```c
#include "acmp_comp.h"
#include "sl_hal_acmp.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "sl_core.h"
#include "app_log.h"

static volatile bool _event_pending     = false;
static volatile bool _last_output_state = false;

void acmp_comp_init(void)
{
  /* 1. Clocks */
  CMU_ClockEnable(cmuClock_ACMP0, true);
  CMU_ClockEnable(cmuClock_GPIO, true);

  /* 2. Disable digital buffer on PC06 (pure analog mode) */
  GPIO_PinModeSet(gpioPortC, 6, gpioModeDisabled, 0);

  /* 3. Configure ACMP0 */
  sl_hal_acmp_init_t init = {
    .bias_prog       = 4,
    .vref_div        = 0,
    .input_range     = SL_HAL_ACMP_INPUT_RANGE_FULL,
    .accuracy        = SL_HAL_ACMP_ACCURACY_HIGH,
#if defined(_ACMP_CFG_HYSTRISE_MASK)
    .hysteresis_rise = SL_HAL_ACMP_HYSTERESIS_DISABLED,
    .hysteresis_fall = SL_HAL_ACMP_HYSTERESIS_DISABLED,
#else
    .hysteresis      = SL_HAL_ACMP_HYSTERESIS_DISABLED,
#endif
    .inactive_value  = false,
  };

  sl_hal_acmp_init(ACMP0, &init);
  sl_hal_acmp_enable(ACMP0);

  /* 4. Set inputs: NEG = PC06, POS = VDAC0OUT1 (Internal) */
  sl_hal_acmp_set_input(ACMP0, SL_HAL_ACMP_INPUT_PC6, SL_HAL_ACMP_INPUT_VDAC0OUT1);
  sl_hal_acmp_wait_ready(ACMP0);

  _last_output_state = (ACMP0->STATUS & ACMP_STATUS_ACMPOUT) != 0;

  /* 5. Enable Interrupts */
  NVIC_ClearPendingIRQ(ACMP0_IRQn);
  sl_hal_acmp_clear_interrupts(ACMP0, ACMP_IF_RISE | ACMP_IF_FALL);
  NVIC_EnableIRQ(ACMP0_IRQn);
  sl_hal_acmp_enable_interrupts(ACMP0, ACMP_IEN_RISE | ACMP_IEN_FALL);

  app_log_info("ACMP0: init OK (POS=VDAC0OUT1, NEG=PC06)\n");
}

void acmp_comp_process(void)
{
  bool has_event = false;
  bool current_state = false;

  CORE_DECLARE_IRQ_STATE;
  CORE_ENTER_ATOMIC();
  if (_event_pending) {
    has_event = true;
    _event_pending = false;
    current_state = _last_output_state;
  }
  CORE_EXIT_ATOMIC();

  if (has_event) {
    if (current_state) {
      app_log_info("[ACMP EVENT] Threshold Crossed: V_POS (DAC) > V_NEG (PC06) | Output: HIGH (1)\n");
    } else {
      app_log_info("[ACMP EVENT] Threshold Crossed: V_NEG (PC06) > V_POS (DAC) | Output: LOW  (0)\n");
    }
  }
}

bool acmp_comp_get_output(void)
{
  return (ACMP0->STATUS & ACMP_STATUS_ACMPOUT) != 0;
}

void ACMP0_IRQHandler(void)
{
  uint32_t flags = sl_hal_acmp_get_enabled_pending_interrupts(ACMP0);
  sl_hal_acmp_clear_interrupts(ACMP0, flags);
  _last_output_state = (ACMP0->STATUS & ACMP_STATUS_ACMPOUT) != 0;
  _event_pending     = true;
}
```

---

## 6. Verification & Test Procedure

1. **DAC Output**: Configured to **`800 mV`**.
2. **Apply External Test Voltages to `PC06` (Expansion Header Pin 13)**:
   * **Test A (Lower than DAC)**: Connect PC06 to $0.5\text{V}$ (or GND):
     $$
     \text{Log: } [ACMP\text{ EVENT}] \text{ Threshold Crossed: } V_{POS} (\text{DAC}) > V_{NEG} (\text{PC06}) \implies \text{Output: HIGH (1)}
     $$
   * **Test B (Higher than DAC)**: Connect PC06 to $1.2\text{V}$ (or $3.3\text{V}$):
     $$
     \text{Log: } [ACMP\text{ EVENT}] \text{ Threshold Crossed: } V_{NEG} (\text{PC06}) > V_{POS} (\text{DAC}) \implies \text{Output: LOW (0)}
     $$
