################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/Zniffer.c \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/comm_interface.c \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/main.c \
E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/zniffer_handler.c 

OBJS += \
./Zniffer.o \
./comm_interface.o \
./main.o \
./zniffer_handler.o 

C_DEPS += \
./Zniffer.d \
./comm_interface.d \
./main.d \
./zniffer_handler.d 


# Each subdirectory must supply rules for building sources it contributes
Zniffer.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/Zniffer.c subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"Zniffer.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

comm_interface.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/comm_interface.c subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"comm_interface.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

main.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/main.c subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"main.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

zniffer_handler.o: E:/CODE/Silicon_Labs/Z_Wave/ZWave_NCP_Zniffer_Solution/zwave_ncp_zniffer/zniffer_handler.c subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c99 -O2 -Wall -ffunction-sections -fdata-sections -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -c -fmessage-length=0 -MMD -MP -MF"zniffer_handler.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


