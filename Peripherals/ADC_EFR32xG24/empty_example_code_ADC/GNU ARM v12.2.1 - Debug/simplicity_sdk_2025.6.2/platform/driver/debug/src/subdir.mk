################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk/platform/driver/debug/src/sl_debug_swo.c 

OBJS += \
./simplicity_sdk_2025.6.2/platform/driver/debug/src/sl_debug_swo.o 

C_DEPS += \
./simplicity_sdk_2025.6.2/platform/driver/debug/src/sl_debug_swo.d 


# Each subdirectory must supply rules for building sources it contributes
simplicity_sdk_2025.6.2/platform/driver/debug/src/sl_debug_swo.o: C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk/platform/driver/debug/src/sl_debug_swo.c simplicity_sdk_2025.6.2/platform/driver/debug/src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c18 '-DDEBUG=1' '-DDEBUG_EFM=1' '-DEFR32MG24B220F1536IM48=1' '-DSL_CODE_COMPONENT_SYSTEM=system' '-DSL_BOARD_NAME="BRD4187C"' '-DSL_BOARD_REV="A01"' '-DHARDWARE_BOARD_DEFAULT_RF_BAND_2400=1' '-DHARDWARE_BOARD_SUPPORTS_1_RF_BAND=1' '-DHARDWARE_BOARD_SUPPORTS_RF_BAND_2400=1' '-DHFXO_FREQ=39000000' '-DSL_CODE_COMPONENT_CLOCK_MANAGER=clock_manager' '-DSL_COMPONENT_CATALOG_PRESENT=1' '-DSL_CODE_COMPONENT_DEVICE_PERIPHERAL=device_peripheral' '-DSL_CODE_COMPONENT_DMADRV=dmadrv' '-DSL_CODE_COMPONENT_GPIO=gpio' '-DSL_CODE_COMPONENT_HAL_COMMON=hal_common' '-DSL_CODE_COMPONENT_HAL_GPIO=hal_gpio' '-DSL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager' '-DCMSIS_NVIC_VIRTUAL=1' '-DCMSIS_NVIC_VIRTUAL_HEADER_FILE="cmsis_nvic_virtual.h"' '-DSL_CODE_COMPONENT_CORE=core' -I"E:\CODE\Silicon_Labs\Peripherals\ADC_EFR32xG24\empty_example_code_ADC\config" -I"E:\CODE\Silicon_Labs\Peripherals\ADC_EFR32xG24\empty_example_code_ADC\autogen" -I"E:\CODE\Silicon_Labs\Peripherals\ADC_EFR32xG24\empty_example_code_ADC" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/Device/SiliconLabs/EFR32MG24/Include" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//app/common/util/app_log" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/common/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//hardware/board/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/clock_manager/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/clock_manager/src" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/CMSIS/Core/Include" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//hardware/driver/configuration_over_swo/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/driver/debug/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/device_manager/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/device_init/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/emdrv/dmadrv/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/emdrv/dmadrv/inc/s2_signals" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/emdrv/common/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/emlib/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/driver/gpio/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/peripheral/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/interrupt_manager/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/interrupt_manager/src" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/interrupt_manager/inc/arm" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/iostream/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/memory_manager/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/sl_main/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/sl_main/src" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/udelay/inc" -Os -Wall -Wextra -mno-sched-prolog -fno-builtin -ffunction-sections -fdata-sections -mcmse -mfpu=fpv5-sp-d16 -mfloat-abi=hard -fno-lto --specs=nano.specs -c -fmessage-length=0 -MMD -MP -MF"simplicity_sdk_2025.6.2/platform/driver/debug/src/sl_debug_swo.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


