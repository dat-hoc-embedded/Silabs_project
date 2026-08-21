# EFR32MG24 Embedded UART CLI Implementation Guide

This document provides a comprehensive, step-by-step guide to the **interactive Command-Line Interface (CLI)** module implemented for the Silicon Labs EFR32MG24. The CLI operates over the Virtual COM port (EUSART0 on PA08 TX, PA09 RX at 115200 baud) without blocking the BLE stack or main event loop.

---

## 1. CLI Architecture & Principles

```text
                  ┌────────────────────────────────────────────────────────┐
                  │ EFR32MG24 Silicon                                      │
                  │                                                        │
                  │  ┌──────────────┐     EUSART0 (115200 8N1)             │
                  │  │  sl_iostream ├──────────────────────┐               │
                  │  │  (VCOM)      │                      ▼               │
                  │  └──────┬───────┘               ┌─────────────┐        │
 [PC / Terminal] ◄──────────┴──────────────────────►│  cli.c      │        │
 (PA08 TX / PA09 RX)                                │  (Parser)   │        │
                                                    └──────┬──────┘        │
                                                           │               │
                                     ┌─────────────────────┴────────────┐  │
                                     ▼                                  ▼  │
                              ┌──────────────┐                  ┌──────────┴───┐
                              │  dac_out     │                  │  acmp_comp   │
                              │  (CH0 / CH1) │                  │  (POS / NEG) │
                              └──────────────┘                  └──────────────┘
```

### Key Technical Characteristics:

* **Zero Blocking**: Does not use blocking `while(!char)` loops. `cli_process()` reads whatever characters are available in the EUSART FIFO and returns immediately.
* **Stream Reuse**: Reuses the default `sl_iostream` instance used by `app_log`.
* **Standard Terminal Support**: Supports backspace character erasure (`\b \b`), local character echo, and handles both `\r` (CR) and `\n` (LF) line terminators.

---

## 2. Supported Command Reference

| Command                        | Arguments                      | Description                                                                    | Example             |
| :----------------------------- | :----------------------------- | :----------------------------------------------------------------------------- | :------------------ |
| **`help`**             | None                           | Displays all available commands and syntax.                                    | `help`            |
| **`dac get`**          | None                           | Reads and prints current output voltages for CH0 and CH1.                      | `dac get`         |
| **`dac set ch0 <mv>`** | `<mv>`: $0\text{ to }1250$ | Sets VDAC0 Channel 0 (PC06 / ACMP NEG) voltage in millivolts.                  | `dac set ch0 300` |
| **`dac set ch1 <mv>`** | `<mv>`: $0\text{ to }1250$ | Sets VDAC0 Channel 1 (PA07 / ACMP POS) voltage in millivolts.                  | `dac set ch1 600` |
| **`acmp get`**         | None                           | Reads ACMP0 hardware status and prints comparator state (`HIGH` or `LOW`). | `acmp get`        |

---

## 3. Step-by-Step Implementation Guide

### Step 1: Create the Public Header (`src/module/cli/include/cli.h`)

Expose only the minimal lifecycle APIs conforming to the **Deep Module pattern**:

```c
#ifndef CLI_H
#define CLI_H

#ifdef __cplusplus
extern "C" {
#endif

void cli_init(void);
void cli_process(void);

#ifdef __cplusplus
}
#endif

#endif /* CLI_H */
```

---

### Step 2: Implement the Parser & Dispatcher (`src/module/cli/source/cli.c`)

The parser maintains a line buffer and processes characters non-blockingly:

```c
#include "cli.h"
#include "dac_out.h"
#include "acmp_comp.h"
#include "sl_iostream.h"
#include "sl_iostream_handles.h"
#include "app_log.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>

#define CLI_BUFFER_SIZE       64
#define CLI_MAX_ARGS          8
#define CLI_PROMPT            "silabs> "

static char _line_buffer[CLI_BUFFER_SIZE];
static uint8_t _line_len = 0;

static sl_iostream_t *_get_stream(void)
{
  sl_iostream_t *stream = sl_iostream_get_handle("vcom");
  if (stream == NULL) {
    stream = sl_iostream_get_default();
  }
  return stream;
}

static void _print_prompt(void)
{
  app_log(CLI_PROMPT);
}

static void _cmd_help(void)
{
  app_log("\nAvailable Commands:\n");
  app_log("  help               - Print this help menu\n");
  app_log("  dac get            - Show current VDAC0 CH0 and CH1 output voltages\n");
  app_log("  dac set ch0 <mv>   - Set VDAC0 CH0 (PC06, NEG) voltage in mV (0..1250)\n");
  app_log("  dac set ch1 <mv>   - Set VDAC0 CH1 (PA07, POS) voltage in mV (0..1250)\n");
  app_log("  acmp get           - Read and print ACMP0 comparator output state\n\n");
}

static void _cmd_dac(int argc, char *argv[])
{
  if (argc < 2) {
    app_log("Error: Missing subcommand for 'dac'. Type 'help' for usage.\n");
    return;
  }

  if (strcmp(argv[1], "get") == 0) {
    uint32_t mv0 = dac_out_get_voltage_ch0_mv();
    uint32_t mv1 = dac_out_get_voltage_ch1_mv();
    app_log("VDAC0 Status:\n");
    app_log("  CH0 (NEG): PC06 (WSTK_P33) -> %lu mV (%.3f V)\n",
            (unsigned long)mv0, (float)mv0 / 1000.0f);
    app_log("  CH1 (POS): PA07 (EXP 13)   -> %lu mV (%.3f V)\n",
            (unsigned long)mv1, (float)mv1 / 1000.0f);
    app_log("  STATUS: 0x%08lx\n", (unsigned long)VDAC0->STATUS);
    return;
  }

  if (strcmp(argv[1], "set") == 0) {
    if (argc < 4) {
      app_log("Error: Usage: dac set <ch0|ch1> <mv>\n");
      return;
    }

    char *channel_str = argv[2];
    int mv = atoi(argv[3]);

    if (mv < 0 || mv > DAC_OUT_VREF_MV) {
      app_log("Error: Voltage %d mV out of range (0..%u mV)\n", mv, DAC_OUT_VREF_MV);
      return;
    }

    float voltage_v = (float)mv / 1000.0f;

    if (strcmp(channel_str, "ch0") == 0 || strcmp(channel_str, "0") == 0) {
      dac_out_set_voltage_ch0(voltage_v);
      app_log("[OK] VDAC0 CH0 (PC06 / NEG) set to %d mV (%.3f V)\n", mv, voltage_v);
    } else if (strcmp(channel_str, "ch1") == 0 || strcmp(channel_str, "1") == 0) {
      dac_out_set_voltage_ch1(voltage_v);
      app_log("[OK] VDAC0 CH1 (PA07 / POS) set to %d mV (%.3f V)\n", mv, voltage_v);
    } else {
      app_log("Error: Invalid channel '%s'. Use 'ch0' or 'ch1'.\n", channel_str);
    }
    return;
  }

  app_log("Error: Unknown subcommand 'dac %s'. Type 'help' for usage.\n", argv[1]);
}

static void _cmd_acmp(int argc, char *argv[])
{
  if (argc < 2 || strcmp(argv[1], "get") == 0) {
    bool output = acmp_comp_get_output();
    app_log("ACMP0 Comparator State:\n");
    app_log("  Output: %u (%s)\n", (unsigned int)output, output ? "HIGH" : "LOW");
    app_log("  Status: %s\n",
            output ? "V_POS (PA07) > V_NEG (PC06)" : "V_NEG (PC06) > V_POS (PA07)");
    app_log("  STATUS reg: 0x%08lx\n", (unsigned long)ACMP0->STATUS);
    return;
  }

  app_log("Error: Unknown subcommand 'acmp %s'. Type 'help' for usage.\n", argv[1]);
}

static void _execute_line(char *line)
{
  while (isspace((unsigned char)*line)) {
    line++;
  }
  if (*line == '\0') {
    return;
  }

  char *argv[CLI_MAX_ARGS];
  int argc = 0;
  char *token = strtok(line, " \t\r\n");
  while (token != NULL && argc < CLI_MAX_ARGS) {
    argv[argc++] = token;
    token = strtok(NULL, " \t\r\n");
  }

  if (argc == 0) {
    return;
  }

  if (strcmp(argv[0], "help") == 0 || strcmp(argv[0], "?") == 0) {
    _cmd_help();
  } else if (strcmp(argv[0], "dac") == 0) {
    _cmd_dac(argc, argv);
  } else if (strcmp(argv[0], "acmp") == 0) {
    _cmd_acmp(argc, argv);
  } else {
    app_log("Error: Unknown command '%s'. Type 'help' for available commands.\n", argv[0]);
  }
}

void cli_init(void)
{
  _line_len = 0;
  _line_buffer[0] = '\0';
  app_log("\n========================================\n");
  app_log(" Silicon Labs EFR32MG24 Interactive CLI \n");
  app_log(" Type 'help' to view available commands \n");
  app_log("========================================\n");
  _print_prompt();
}

void cli_process(void)
{
  sl_iostream_t *stream = _get_stream();
  if (stream == NULL) {
    return;
  }

  char c = '\0';
  while (sl_iostream_getchar(stream, &c) == SL_STATUS_OK) {
    if (c == '\r' || c == '\n') {
      sl_iostream_putchar(stream, '\r');
      sl_iostream_putchar(stream, '\n');

      _line_buffer[_line_len] = '\0';
      _execute_line(_line_buffer);

      _line_len = 0;
      _line_buffer[0] = '\0';
      _print_prompt();
    } else if (c == '\b' || c == 0x7F) {
      if (_line_len > 0) {
        _line_len--;
        _line_buffer[_line_len] = '\0';
        sl_iostream_putchar(stream, '\b');
        sl_iostream_putchar(stream, ' ');
        sl_iostream_putchar(stream, '\b');
      }
    } else if (isprint((unsigned char)c)) {
      if (_line_len < (CLI_BUFFER_SIZE - 1)) {
        _line_buffer[_line_len++] = c;
        _line_buffer[_line_len] = '\0';
        sl_iostream_putchar(stream, c);
      }
    }
  }
}
```

---

### Step 3: Register in Build System (`cmake_gcc/CMakeLists.txt`)

Add the source file and header path:

```cmake
file(GLOB MODULE_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/../src/module/source/*.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../src/module/cli/source/*.c"
)

target_include_directories(slc PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/../src/module/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../src/module/cli/include
)
```

---

### Step 4: Integrate in Application Loop (`app.c`)

```c
#include "cli.h"

void app_init(void) {
  dac_out_init();
  acmp_comp_init();
  cli_init();       /* Initialize CLI and display banner */
}

void app_process_action(void) {
  acmp_comp_process();
  cli_process();    /* Non-blocking character polling & command execution */
}
```

---

## 4. Verification & Testing Procedure

### 1. Terminal Connection Parameters

* **Port:** J-Link Virtual COM Port (Silicon Labs CDC)
* **Baud Rate:** `115200`
* **Data Bits:** `8`
* **Parity:** `None`
* **Stop Bits:** `1`
* **Flow Control:** `None`

---

### 2. Interactive Test Session

```text
========================================
 Silicon Labs EFR32MG24 Interactive CLI 
 Type 'help' to view available commands 
========================================
silabs> help

Available Commands:
  help               - Print this help menu
  dac get            - Show current VDAC0 CH0 and CH1 output voltages
  dac set ch0 <mv>   - Set VDAC0 CH0 (PC06, NEG) voltage in mV (0..1250)
  dac set ch1 <mv>   - Set VDAC0 CH1 (PA07, POS) voltage in mV (0..1250)
  acmp get           - Read and print ACMP0 comparator output state

silabs> dac get
VDAC0 Status:
  CH0 (NEG): PC06 (WSTK_P33) -> 100 mV (0.100 V)
  CH1 (POS): PA07 (EXP 13)   -> 500 mV (0.500 V)
  STATUS: 0x00000003

silabs> acmp get
ACMP0 Comparator State:
  Output: 1 (HIGH)
  Status: V_POS (PA07) > V_NEG (PC06)
  STATUS reg: 0x00000005

silabs> dac set ch1 50
[OK] VDAC0 CH1 (PA07 / POS) set to 50 mV (0.050 V)
[ACMP EVENT] Threshold Crossed: V_NEG (PC06) > V_POS (DAC) | Output: LOW  (0)

silabs> acmp get
ACMP0 Comparator State:
  Output: 0 (LOW)
  Status: V_NEG (PC06) > V_POS (PA07)
  STATUS reg: 0x00000004
```
