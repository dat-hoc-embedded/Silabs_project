################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk/util/third_party/trusted-firmware-m/lib/fih/src/fih.c 

OBJS += \
./simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/fih.o 

C_DEPS += \
./simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/fih.d 


# Each subdirectory must supply rules for building sources it contributes
simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/fih.o: C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk/util/third_party/trusted-firmware-m/lib/fih/src/fih.c simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -std=c18 '-DEFR32MG24B220F1536IM48=1' '-DSL_CODE_COMPONENT_SYSTEM=system' '-DSE_MANAGER_CONFIG_FILE="btl_aes_ctr_stream_block_cfg.h"' '-DBOOTLOADER_SUPPORT_COMMUNICATION=1' '-DBOOTLOADER_ENABLE=1' '-DBOOTLOADER_SECOND_STAGE=1' '-DSL_RAMFUNC_DISABLE=1' '-D__START=main' '-D__STARTUP_CLEAR_BSS=1' '-DSYSTEM_NO_STATIC_MEMORY=1' '-DBTL_GPIO_ACTIVATION=1' '-DBTL_UART_ENABLE=1' '-DSL_BOARD_NAME="BRD4187C"' '-DSL_BOARD_REV="A01"' '-DHARDWARE_BOARD_DEFAULT_RF_BAND_2400=1' '-DHARDWARE_BOARD_SUPPORTS_1_RF_BAND=1' '-DHARDWARE_BOARD_SUPPORTS_RF_BAND_2400=1' '-DHFXO_FREQ=39000000' '-DSL_COMPONENT_CATALOG_PRESENT=1' '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_trustzone_config.h>' '-DMBEDTLS_PSA_CRYPTO_CLIENT=1' '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' '-DSL_CODE_COMPONENT_SE_MANAGER=se_manager' '-DSL_CODE_COMPONENT_CORE=core' '-DSL_CODE_COMPONENT_PSEC_OSAL=psec_osal' '-DSL_TRUSTZONE_SECURE=1' -I"E:\CODE\Silicon_Labs\Bluetooth\bootloader-uart-bgapi\config" -I"E:\CODE\Silicon_Labs\Bluetooth\bootloader-uart-bgapi\autogen" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/Device/SiliconLabs/EFR32MG24/Include" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/common/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/communication" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/debug" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/gpio/gpio-activation" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/parser" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/api" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/security" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/bootloader/driver" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/CMSIS/Core/Include" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/emlib/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/security/sl_component/sl_mbedtls_support/config" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/security/sl_component/sl_mbedtls_support/config/preset" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/security/sl_component/sl_mbedtls_support/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//util/third_party/mbedtls/include" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//util/third_party/mbedtls/library" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/memory_manager/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/memory_manager/src" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/security/sl_component/sl_psa_driver/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/security/sl_component/se_manager/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//util/third_party/trusted-firmware-m/lib/fih/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//util/third_party/trusted-firmware-m/platform/include" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/security/sl_component/sli_psec_osal/inc" -I"C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk//platform/service/udelay/inc" -Os -Wall -Wextra -ffunction-sections -fdata-sections -mcmse -mfpu=fpv5-sp-d16 -mfloat-abi=hard -Wno-ignored-qualifiers -Wno-sign-compare -fno-lto --specs=nano.specs -c -fmessage-length=0 -MMD -MP -MF"simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/fih.d" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


