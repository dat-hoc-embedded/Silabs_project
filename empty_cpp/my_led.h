#ifndef MY_LED
#define MY_LED

#ifdef __cplusplus
extern "C" {
#endif
  #include "em_gpio.h"
  #include "em_device.h"

  void LED1_Blink_em_lib();
  void LED0_1_Init();

  #include "sl_simple_led_instances.h"
  void LED0_Blink_sl_led();

#ifdef __cplusplus
}
#endif

#endif
