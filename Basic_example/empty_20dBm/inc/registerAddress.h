// /**
//  * @file registerAddress.h
//  * @author Embeddat (embeddat.dev@gmail.com)
//  * @brief 
//  * @version 0.1
//  * @date 2025-11-23
//  * 
//  * @copyright Copyright (c) 2025
//  * 
//  */
// #pragma once
// #include <stdint.h>

// /** < Peripheral Base Address */
// #define EMU_NS 0x50004000UL
// #define CMU_NS 0x50008000UL // Clock Management Unit
// #define GPIO_NS 0x5003C000UL // General Purpose Input/Output
// #define LDMA_NS 0x50040000UL // Linked Direct Memory Access
// #define TIMER0_NS 0x50048000UL  // Timer 0
// #define TIMER1_NS 0x5004C000UL // Timer 1
// #define TIMER2_NS 0x50050000UL // Timer 2
// #define TIMER3_NS 0x50054000UL // Timer 3
// #define TIMER4_NS 0x50058000UL  // Timer 4
// #define USART0_NS 0x5005C000UL // Universal Synchronous/Asynchronous Receiver/Transmitter 0
// #define I2C0_NS 0x5B000000UL   // Inter-Integrated Circuit 0
// #define I2C1_NS 0x50068000UL  // Inter-Integrated Circuit 1
// #define EUSART0_NS 0x5B010000UL  // Enhanced Universal Synchronous/Asynchronous Receiver/Transmitter 0
// #define EUSART1_NS 0x500A0000UL // Enhanced Universal Synchronous/Asynchronous Receiver/Transmitter 1
// #define LETIMER0_NS 0x59000000UL // Low Energy Timer 0 

// /** 
//  * GPIO Register Offsets 
//  */
// #define GPIO_PORTA_MODEL (volatile uint32_t *)(GPIO_NS + 0x034UL)
// #define GPIO_PORTA_MODEH (volatile uint32_t *)(GPIO_NS + 0x03CUL)
// #define GPIO_PORTA_DOUT (volatile uint32_t *)(GPIO_NS + 0x040UL)
// #define GPIO_PORTA_DIN (volatile uint32_t *)(GPIO_NS + 0x044UL)

// #define GPIO_PORTB_MODEL (volatile uint32_t *)(GPIO_NS + 0x064UL)
// #define GPIO_PORTB_DOUT (volatile uint32_t *)(GPIO_NS + 0x070UL)
// #define GPIO_PORTB_DIN (volatile uint32_t *)(GPIO_NS + 0x074UL)

// #define GPIO_IF (volatile uint32_t *)(GPIO_NS + 0x420UL)
// #define GPIO_IEN (volatile uint32_t *)(GPIO_NS + 0x424UL)

// #define GPIO_EUSART0_ROUTEEN (volatile uint32_t *)(GPIO_NS + 0x494UL)
// #define GPIO_EUSART0_RXROUTE (volatile uint32_t *)(GPIO_NS + 0x4A4UL)
// #define GPIO_EUSART0_TXROUTE (volatile uint32_t *)(GPIO_NS + 0x4ACUL)


