################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_board_default_init.c \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_event_handler.c \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_iostream_handles.c \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_simple_led_instances.c 

OBJS += \
./autogen/sl_board_default_init.o \
./autogen/sl_event_handler.o \
./autogen/sl_iostream_handles.o \
./autogen/sl_simple_led_instances.o 

C_DEPS += \
./autogen/sl_board_default_init.d \
./autogen/sl_event_handler.d \
./autogen/sl_iostream_handles.d \
./autogen/sl_simple_led_instances.d 


# Each subdirectory must supply rules for building sources it contributes
autogen/sl_board_default_init.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_board_default_init.c autogen/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"autogen/sl_board_default_init.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

autogen/sl_event_handler.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_event_handler.c autogen/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"autogen/sl_event_handler.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

autogen/sl_iostream_handles.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_iostream_handles.c autogen/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"autogen/sl_iostream_handles.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

autogen/sl_simple_led_instances.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/autogen/sl_simple_led_instances.c autogen/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"autogen/sl_simple_led_instances.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


