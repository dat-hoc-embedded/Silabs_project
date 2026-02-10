/**
 * @file my_led.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2025-11-07
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#include "my_led.h"

/**
 * @brief 
 * 
 * @param ms: Time for delay (ms)
 * @retval void
 * @see 
 */
volatile int cnt = 0 ;
volatile int cnt1 = 0 , cnt2 = 0 , cnt3 = 0;
void delay_ms(uint32_t ms)
{	
	/// Assume HFRCO = 19 MHz
	volatile uint32_t count;
	while(ms--){
		count = 19000;
		while (count--) __NOP();
	}
}

/** ------------------------------------------------------------------------------- */
/**
 * @brief Initialize for LED 0 & LED 1. PB2 <-> LED0 , PB4 <-> LED1
 * 
 */
void LED0_1_Init()
{
  /// 1. Turn on Clock for GPIO
  //CMU->CLKEN0_SET = CMU_CLKEN0_GPIO;

  /// 2. Config LED0 - PB2
  GPIO->P[1].MODEL &= ~_GPIO_P_MODEL_MODE2_MASK;  // Clear MODEL MODE2
  GPIO->P[1].MODEL |= GPIO_P_MODEL_MODE2_PUSHPULL; // Set Push Pull Output

  /// 3. Config LED1 - PB4
  GPIO->P[1].MODEL &= ~_GPIO_P_MODEL_MODE4_MASK; // Clear MODEL MODE4
  GPIO->P[1].MODEL |= GPIO_P_MODEL_MODE4_PUSHPULL; // Set Push Pull Output

  printf("\n*** LED0_1 have been initialized \r\n");
}

/** ------------------------------------------------------------------------------- */
void LED0_Blink_bare_metal()
{
	GPIO->P[1].DOUT |= (0b1 << 2 );
	delay_ms(100);
	GPIO->P[1].DOUT &= ~(0b1 << 2);
	delay_ms(100);
	cnt ++;

	printf("*** LED0_Blink_bare_metal has been called %d\r\n",cnt);
}
/** ------------------------------------------------------------------------------- */
/**
 * @brief Blink LED0 with T = 1s
 * 
 */
void LED1_Blink_em_lib()
{
	//GPIO_PinOutSet(gpioPortB, 4);
	//GPIO_PinOutClear(gpioPortB, 4);
	GPIO_PinOutToggle(gpioPortB, 4);
	delay_ms(100);
	cnt1 ++;

	printf("*** LED1_Blink_em_lib has been called %d \r\n",cnt1);
}

/** ------------------------------------------------------------------------------- */
/**
 * @brief Struct to create context for LED0
 *
 */
sl_simple_led_context_t my_simple_led_context = {
    .port = gpioPortB,
    .pin = 2, //LED 0
    .polarity = 1
};
/**
 * @brief Struct sl_led_t include : context + funtions
 * @note Need include : sl_simple_led.h 
 */
const sl_led_t my_simple_led = {
    .context = &my_simple_led_context,
    .init = sl_simple_led_init,
    .turn_on = sl_simple_led_turn_on,
    .turn_off = sl_simple_led_turn_off,
    .toggle = sl_simple_led_toggle,
    .get_state = sl_simple_led_get_state
};

/**
 * @brief Use some API in sl_led.h 
 * 
 * @param my_LED 
 */
void LED0_sl_led(const sl_led_t *my_LED)
{
	sl_simple_led_context_t *context = my_LED -> context;
	my_LED->init(context);
	my_LED->turn_on(context);
	delay_ms(200);
	my_LED->turn_off(context);
	delay_ms(200);

	printf("*** LED0_sl_led has been called %d \r\n",cnt2);
}

/**
 * @brief 
 * 
 * @param led_context 
 */
void LED0_sl_simple_led(sl_simple_led_context_t *led_context)
{

	sl_simple_led_toggle(led_context);
	delay_ms(200);
	cnt3 ++;
	//printf("*** LED0_sl_simple_led has been called %d \r\n",cnt3);
	
}
