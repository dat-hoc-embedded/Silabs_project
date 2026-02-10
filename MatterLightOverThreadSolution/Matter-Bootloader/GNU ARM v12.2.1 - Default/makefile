################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/platform/ext/target/siliconlabs/hse/subdir.mk
-include simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/subdir.mk
-include simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/subdir.mk
-include simplicity_sdk_2025.6.2/platform/service/udelay/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/service/memory_manager/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/security/sl_component/sl_mbedtls_support/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/emlib/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/common/src/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/storage/spiflash/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/storage/bootloadinfo/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/storage/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/security/sha/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/security/ecc/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/security/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/parser/gbl/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/parser/compression/lzma/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/parser/compression/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/driver/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/debug/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/core/flash/subdir.mk
-include simplicity_sdk_2025.6.2/platform/bootloader/core/subdir.mk
-include simplicity_sdk_2025.6.2/platform/Device/SiliconLabs/EFR32MG24/Source/subdir.mk
-include matter_2.7.0/third_party/matter_sdk/examples/platform/silabs/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(CCM_DEPS)),)
-include $(CCM_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(CXXM_DEPS)),)
-include $(CXXM_DEPS)
endif
ifneq ($(strip $(C++M_DEPS)),)
-include $(C++M_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := Matter-Bootloader
BUILD_ARTIFACT_EXTENSION := axf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all:
	+@$(MAKE) --no-print-directory main-build && $(MAKE) --no-print-directory post-build

# Main-build Target
main-build: Matter-Bootloader.axf

# Tool invocations
Matter-Bootloader.axf: $(OBJS) $(USER_OBJS) makefile objects.mk $(OPTIONAL_TOOL_DEPS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU ARM C++ Linker'
	arm-none-eabi-g++ -g -gdwarf-2 -mcpu=cortex-m33 -mthumb -T "E:\CODE\Silicon_Labs\MatterLightOverThreadSolution\Matter-Bootloader\autogen\linkerfile.ld" -Wl,--no-warn-rwx-segment -Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r -fno-lto -Wl,--no-warn-rwx-segments --specs=nosys.specs -Xlinker --gc-sections -Xlinker -Map="Matter-Bootloader.map" -mfpu=fpv5-sp-d16 -mfloat-abi=hard --specs=nano.specs -o Matter-Bootloader.axf -Wl,--start-group "./matter_2.7.0/third_party/matter_sdk/examples/platform/silabs/syscalls_stubs.o" "./simplicity_sdk_2025.6.2/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.o" "./simplicity_sdk_2025.6.2/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.o" "./simplicity_sdk_2025.6.2/platform/bootloader/core/btl_bootload.o" "./simplicity_sdk_2025.6.2/platform/bootloader/core/btl_core.o" "./simplicity_sdk_2025.6.2/platform/bootloader/core/btl_main.o" "./simplicity_sdk_2025.6.2/platform/bootloader/core/btl_parse.o" "./simplicity_sdk_2025.6.2/platform/bootloader/core/btl_reset.o" "./simplicity_sdk_2025.6.2/platform/bootloader/core/flash/btl_internal_flash.o" "./simplicity_sdk_2025.6.2/platform/bootloader/debug/btl_debug.o" "./simplicity_sdk_2025.6.2/platform/bootloader/debug/btl_debug_swo.o" "./simplicity_sdk_2025.6.2/platform/bootloader/driver/btl_driver_delay.o" "./simplicity_sdk_2025.6.2/platform/bootloader/driver/btl_driver_spi_controller_usart.o" "./simplicity_sdk_2025.6.2/platform/bootloader/driver/btl_driver_util.o" "./simplicity_sdk_2025.6.2/platform/bootloader/parser/compression/btl_decompress_lz4.o" "./simplicity_sdk_2025.6.2/platform/bootloader/parser/compression/btl_decompress_lzma.o" "./simplicity_sdk_2025.6.2/platform/bootloader/parser/compression/lzma/LzmaDec.o" "./simplicity_sdk_2025.6.2/platform/bootloader/parser/gbl/btl_gbl_custom_tags.o" "./simplicity_sdk_2025.6.2/platform/bootloader/parser/gbl/btl_gbl_format.o" "./simplicity_sdk_2025.6.2/platform/bootloader/parser/gbl/btl_gbl_parser.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/btl_crc16.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/btl_crc32.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/btl_security_aes.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/btl_security_ecdsa.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/btl_security_sha256.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/btl_security_tokens.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/ecc/ecc.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/sha/btl_sha256.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/sha/crypto_sha.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/sha/cryptoacc_sha.o" "./simplicity_sdk_2025.6.2/platform/bootloader/security/sha/se_sha.o" "./simplicity_sdk_2025.6.2/platform/bootloader/storage/bootloadinfo/btl_storage_bootloadinfo_single.o" "./simplicity_sdk_2025.6.2/platform/bootloader/storage/btl_callbacks_stub.o" "./simplicity_sdk_2025.6.2/platform/bootloader/storage/btl_storage.o" "./simplicity_sdk_2025.6.2/platform/bootloader/storage/btl_storage_library.o" "./simplicity_sdk_2025.6.2/platform/bootloader/storage/spiflash/btl_storage_spiflash.o" "./simplicity_sdk_2025.6.2/platform/common/src/sl_assert.o" "./simplicity_sdk_2025.6.2/platform/common/src/sl_core_cortexm.o" "./simplicity_sdk_2025.6.2/platform/common/src/sl_syscalls.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_acmp.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_burtc.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_cmu.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_dbg.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_emu.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_eusart.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_gpcrc.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_gpio.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_i2c.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_iadc.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_ldma.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_letimer.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_msc.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_opamp.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_pcnt.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_prs.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_rmu.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_system.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_timer.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_usart.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_vdac.o" "./simplicity_sdk_2025.6.2/platform/emlib/src/em_wdog.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_hash.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_signature.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sl_se_manager_util.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_mbedtls_support/src/se_aes.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.o" "./simplicity_sdk_2025.6.2/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sl_memory_manager.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sl_memory_manager_pool.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sl_memory_manager_pool_common.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sl_memory_manager_region.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sl_memory_manager_retarget.o" "./simplicity_sdk_2025.6.2/platform/service/memory_manager/src/sli_memory_manager_common.o" "./simplicity_sdk_2025.6.2/platform/service/udelay/src/sl_udelay.o" "./simplicity_sdk_2025.6.2/platform/service/udelay/src/sl_udelay_armv6m_gcc.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/aes.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/constant_time.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/platform.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/platform_util.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/psa_crypto_client.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/psa_util.o" "./simplicity_sdk_2025.6.2/util/third_party/mbedtls/library/threading.o" "./simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/lib/fih/src/fih.o" "./simplicity_sdk_2025.6.2/util/third_party/trusted-firmware-m/platform/ext/target/siliconlabs/hse/sli_se.o" -lgcc -lc -lm -lnosys -Wl,--end-group -Wl,--start-group -lgcc -lc -lnosys -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

	@echo 'Building out file: Matter-Bootloader.out'
	arm-none-eabi-objcopy "Matter-Bootloader.axf" "Matter-Bootloader.out"
	@echo ' '

	@echo 'Building hex file: Matter-Bootloader.hex'
	arm-none-eabi-objcopy -O ihex "Matter-Bootloader.axf" "Matter-Bootloader.hex"
	@echo ' '

	@echo 'Building bin file: Matter-Bootloader.bin'
	arm-none-eabi-objcopy -O binary "Matter-Bootloader.axf" "Matter-Bootloader.bin"
	@echo ' '

	@echo 'Building s37 file: Matter-Bootloader.s37'
	arm-none-eabi-objcopy -O srec "Matter-Bootloader.axf" "Matter-Bootloader.s37"
	@echo ' '

	@echo 'Running size tool'
	arm-none-eabi-size "Matter-Bootloader.axf" -A
	@echo ' '

# Other Targets
clean:
	-@$(foreach FILE, $(CC_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(C++_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(CCM_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(EXECUTABLES), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(OBJS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(C_UPPER_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(CXX_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(CXXM_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(C++M_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(C_DEPS), $(shell $(RM) $(FILE)) )
	-@$(foreach FILE, $(CPP_DEPS), $(shell $(RM) $(FILE)) )
	-$(RM) Matter-Bootloader.axf
	-@echo ' '

post-build:
	-"E:\Application\SiliconLabs\SimplicityStudio\v5\developer\adapter_packs\commander\commander.exe" postbuild "E:\CODE\Silicon_Labs\MatterLightOverThreadSolution\Matter-Bootloader/Matter-Bootloader.slpb" --parameter build_dir:"E:\CODE\Silicon_Labs\MatterLightOverThreadSolution\Matter-Bootloader\GNU ARM v12.2.1 - Default" && "E:\Application\SiliconLabs\SimplicityStudio\v5\developer\adapter_packs\commander\commander.exe" postbuild "E:\CODE\Silicon_Labs\MatterLightOverThreadSolution\Matter-Bootloader/../MatterLightOverThread/MatterLightOverThreadSolution.slpb"
	-@echo ' '

.PHONY: all clean dependents main-build post-build

-include ../makefile.targets
