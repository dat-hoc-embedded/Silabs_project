/***************************************************************************//**
 * @file cli.c
 * @brief Interactive UART Command-Line Interface Implementation
 *
 * Implements non-blocking interactive CLI over VCOM (EUSART0 on PA08/PA09).
 * Parses user input lines, executes commands, and outputs formatted responses.
 ******************************************************************************/

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

/* ── Configuration & Constants ───────────────────────────────────────────── */

#define CLI_BUFFER_SIZE       64
#define CLI_MAX_ARGS          8
#define CLI_PROMPT            "silabs> "

/* ── Private State ───────────────────────────────────────────────────────── */

static char _line_buffer[CLI_BUFFER_SIZE];
static uint8_t _line_len = 0;

/* ── Private Helpers ─────────────────────────────────────────────────────── */

/**
 * @brief Get the active stream handle (vcom or default).
 */
static sl_iostream_t *_get_stream(void)
{
  sl_iostream_t *stream = sl_iostream_get_handle("vcom");
  if (stream == NULL) {
    stream = sl_iostream_get_default();
  }
  return stream;
}

/**
 * @brief Print prompt to console.
 */
static void _print_prompt(void)
{
  app_log(CLI_PROMPT);
}

/**
 * @brief Handle 'help' command.
 */
static void _cmd_help(void)
{
  app_log("\nAvailable Commands:\n");
  app_log("  help               - Print this help menu\n");
  app_log("  dac get            - Show current VDAC0 CH0 and CH1 output voltages\n");
  app_log("  dac set ch0 <mv>   - Set VDAC0 CH0 (PC06, NEG) voltage in mV (0..1250)\n");
  app_log("  dac set ch1 <mv>   - Set VDAC0 CH1 (PA07, POS) voltage in mV (0..1250)\n");
  app_log("  acmp get           - Read and print ACMP0 comparator output state\n");
  app_log("\n");
}

/**
 * @brief Handle 'dac' command group:
 *   - dac get
 *   - dac set ch0 <mv>
 *   - dac set ch1 <mv>
 */
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

/**
 * @brief Handle 'acmp' command group:
 *   - acmp get
 */
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

/**
 * @brief Parse and execute a completed command line.
 */
static void _execute_line(char *line)
{
  /* Trim leading spaces */
  while (isspace((unsigned char)*line)) {
    line++;
  }

  if (*line == '\0') {
    return; /* Empty line */
  }

  /* Tokenize arguments */
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

  /* Dispatch command */
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

/* ── Public API ──────────────────────────────────────────────────────────── */

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
    /* Handle Enter (Carriage Return or Line Feed) */
    if (c == '\r' || c == '\n') {
      sl_iostream_putchar(stream, '\r');
      sl_iostream_putchar(stream, '\n');

      _line_buffer[_line_len] = '\0';
      _execute_line(_line_buffer);

      _line_len = 0;
      _line_buffer[0] = '\0';
      _print_prompt();
    }
    /* Handle Backspace or Delete */
    else if (c == '\b' || c == 0x7F) {
      if (_line_len > 0) {
        _line_len--;
        _line_buffer[_line_len] = '\0';
        /* Erase character on terminal */
        sl_iostream_putchar(stream, '\b');
        sl_iostream_putchar(stream, ' ');
        sl_iostream_putchar(stream, '\b');
      }
    }
    /* Printable characters */
    else if (isprint((unsigned char)c)) {
      if (_line_len < (CLI_BUFFER_SIZE - 1)) {
        _line_buffer[_line_len++] = c;
        _line_buffer[_line_len] = '\0';
        sl_iostream_putchar(stream, c); /* Local echo */
      }
    }
  }
}
