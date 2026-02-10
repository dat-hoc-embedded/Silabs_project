#include "my_led.h"

void LED0_1_Init()
{
	/// 1. Turn on Clock for GPIO
	// CMU->CLKEN0_SET = CMU_CLKEN0_GPIO;

	/// 2. Config LED0 - PB2
	GPIO->P[1].MODEL &= ~_GPIO_P_MODEL_MODE2_MASK;	 // Clear MODEL MODE2
	GPIO->P[1].MODEL |= GPIO_P_MODEL_MODE2_PUSHPULL; // Set Push Pull Output

	/// 3. Config LED1 - PB4
	GPIO->P[1].MODEL &= ~_GPIO_P_MODEL_MODE4_MASK;	 // Clear MODEL MODE4
	GPIO->P[1].MODEL |= GPIO_P_MODEL_MODE4_PUSHPULL; // Set Push Pull Output

	// printf("\n*** LED0_1 have been initialized \r\n");
}

void LED1_Blink_em_lib()
{
	// GPIO_PinOutSet(gpioPortB, 2);
	// GPIO_PinOutClear(gpioPortB, 2);
	GPIO_PinOutSet(gpioPortB, 2);

	// printf("*** LED1_Blink_em_lib has been called %d \r\n",cnt);
}
void LED0_Blink_sl_led()
{
	sl_led_turn_on(&sl_led_led0);
	// sl_led_toggle(&sl_led_led0);
}
