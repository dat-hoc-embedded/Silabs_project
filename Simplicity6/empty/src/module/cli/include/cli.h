#ifndef CLI_H
#define CLI_H

/***************************************************************************//**
 * @file cli.h
 * @brief Interactive UART Command-Line Interface for EFR32MG24
 *
 * Provides non-blocking command-line parsing over VCOM (EUSART0 on PA08/PA09).
 * Allows interactive runtime control of VDAC voltages and ACMP comparator state.
 *
 * Public commands:
 *   - help               : Print command list and usage
 *   - dac set ch0 <mv>   : Set VDAC0 CH0 (PC06, NEG) voltage in mV (0..1250)
 *   - dac set ch1 <mv>   : Set VDAC0 CH1 (PA07, POS) voltage in mV (0..1250)
 *   - dac get            : Display current VDAC0 CH0 and CH1 output voltages
 *   - acmp get           : Read and print current ACMP0 comparison result
 ******************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

/***************************************************************************//**
 * @brief Initialize the CLI module, line buffer, and print welcome banner.
 ******************************************************************************/
void cli_init(void);

/***************************************************************************//**
 * @brief Non-blocking CLI processing function.
 *        Must be called periodically in the application main loop (app_process_action).
 *        Reads incoming characters from sl_iostream, handles backspace/echo,
 *        and executes commands on newline (CR/LF).
 ******************************************************************************/
void cli_process(void);

#ifdef __cplusplus
}
#endif

#endif /* CLI_H */
