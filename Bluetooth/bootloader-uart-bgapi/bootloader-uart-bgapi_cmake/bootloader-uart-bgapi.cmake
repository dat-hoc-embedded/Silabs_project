set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_bootloader-uart-bgapi OBJECT
    "${SDK_PATH}/platform/bootloader/communication/bgapi-uart-dfu/btl_comm_bgapi.c"
    "${SDK_PATH}/platform/bootloader/communication/bgapi-uart-dfu/btl_comm_bgapi_common.c"
    "${SDK_PATH}/platform/bootloader/core/btl_bootload.c"
    "${SDK_PATH}/platform/bootloader/core/btl_core.c"
    "${SDK_PATH}/platform/bootloader/core/btl_main.c"
    "${SDK_PATH}/platform/bootloader/core/btl_parse.c"
    "${SDK_PATH}/platform/bootloader/core/btl_reset.c"
    "${SDK_PATH}/platform/bootloader/core/flash/btl_internal_flash.c"
    "${SDK_PATH}/platform/bootloader/debug/btl_debug.c"
    "${SDK_PATH}/platform/bootloader/debug/btl_debug_swo.c"
    "${SDK_PATH}/platform/bootloader/driver/btl_driver_delay.c"
    "${SDK_PATH}/platform/bootloader/driver/btl_driver_uart.c"
    "${SDK_PATH}/platform/bootloader/driver/btl_driver_util.c"
    "${SDK_PATH}/platform/bootloader/gpio/gpio-activation/btl_gpio_activation_s2.c"
    "${SDK_PATH}/platform/bootloader/parser/gbl/btl_gbl_custom_tags.c"
    "${SDK_PATH}/platform/bootloader/parser/gbl/btl_gbl_format.c"
    "${SDK_PATH}/platform/bootloader/parser/gbl/btl_gbl_parser.c"
    "${SDK_PATH}/platform/bootloader/security/btl_crc16.c"
    "${SDK_PATH}/platform/bootloader/security/btl_crc32.c"
    "${SDK_PATH}/platform/bootloader/security/btl_security_aes.c"
    "${SDK_PATH}/platform/bootloader/security/btl_security_ecdsa.c"
    "${SDK_PATH}/platform/bootloader/security/btl_security_sha256.c"
    "${SDK_PATH}/platform/bootloader/security/btl_security_tokens.c"
    "${SDK_PATH}/platform/bootloader/security/ecc/ecc.c"
    "${SDK_PATH}/platform/bootloader/security/sha/btl_sha256.c"
    "${SDK_PATH}/platform/bootloader/security/sha/crypto_sha.c"
    "${SDK_PATH}/platform/bootloader/security/sha/cryptoacc_sha.c"
    "${SDK_PATH}/platform/bootloader/security/sha/se_sha.c"
    "${SDK_PATH}/platform/common/src/sl_assert.c"
    "${SDK_PATH}/platform/common/src/sl_core_cortexm.c"
    "${SDK_PATH}/platform/common/src/sl_syscalls.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "${SDK_PATH}/platform/emlib/src/em_acmp.c"
    "${SDK_PATH}/platform/emlib/src/em_burtc.c"
    "${SDK_PATH}/platform/emlib/src/em_cmu.c"
    "${SDK_PATH}/platform/emlib/src/em_dbg.c"
    "${SDK_PATH}/platform/emlib/src/em_emu.c"
    "${SDK_PATH}/platform/emlib/src/em_eusart.c"
    "${SDK_PATH}/platform/emlib/src/em_gpcrc.c"
    "${SDK_PATH}/platform/emlib/src/em_gpio.c"
    "${SDK_PATH}/platform/emlib/src/em_i2c.c"
    "${SDK_PATH}/platform/emlib/src/em_iadc.c"
    "${SDK_PATH}/platform/emlib/src/em_ldma.c"
    "${SDK_PATH}/platform/emlib/src/em_letimer.c"
    "${SDK_PATH}/platform/emlib/src/em_msc.c"
    "${SDK_PATH}/platform/emlib/src/em_opamp.c"
    "${SDK_PATH}/platform/emlib/src/em_pcnt.c"
    "${SDK_PATH}/platform/emlib/src/em_prs.c"
    "${SDK_PATH}/platform/emlib/src/em_rmu.c"
    "${SDK_PATH}/platform/emlib/src/em_system.c"
    "${SDK_PATH}/platform/emlib/src/em_timer.c"
    "${SDK_PATH}/platform/emlib/src/em_usart.c"
    "${SDK_PATH}/platform/emlib/src/em_vdac.c"
    "${SDK_PATH}/platform/emlib/src/em_wdog.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sl_se_manager_util.c"
    "${SDK_PATH}/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.c"
    "${SDK_PATH}/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c"
    "${SDK_PATH}/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_pool.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_pool_common.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_retarget.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sli_memory_manager_common.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "${SDK_PATH}/util/third_party/mbedtls/library/aes.c"
    "${SDK_PATH}/util/third_party/mbedtls/library/constant_time.c"
    "${SDK_PATH}/util/third_party/mbedtls/library/platform.c"
    "${SDK_PATH}/util/third_party/mbedtls/library/platform_util.c"
    "${SDK_PATH}/util/third_party/mbedtls/library/psa_crypto_client.c"
    "${SDK_PATH}/util/third_party/mbedtls/library/psa_util.c"
    "${SDK_PATH}/util/third_party/mbedtls/library/threading.c"
    "${SDK_PATH}/util/third_party/trusted-firmware-m/lib/fih/src/fih.c"
    "${SDK_PATH}/util/third_party/trusted-firmware-m/platform/ext/target/siliconlabs/hse/sli_se.c"
)

target_include_directories(slc_bootloader-uart-bgapi PUBLIC
   "../config"
   "../autogen"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Include"
    "${SDK_PATH}/platform/common/inc"
    "${SDK_PATH}/platform/bootloader"
    "${SDK_PATH}/platform/bootloader/communication"
    "${SDK_PATH}/platform/bootloader/debug"
    "${SDK_PATH}/platform/bootloader/gpio/gpio-activation"
    "${SDK_PATH}/platform/bootloader/parser"
    "${SDK_PATH}/platform/bootloader/api"
    "${SDK_PATH}/platform/bootloader/security"
    "${SDK_PATH}/platform/bootloader/driver"
    "${SDK_PATH}/platform/CMSIS/Core/Include"
    "${SDK_PATH}/platform/emlib/inc"
    "${SDK_PATH}/platform/security/sl_component/sl_mbedtls_support/config"
    "${SDK_PATH}/platform/security/sl_component/sl_mbedtls_support/config/preset"
    "${SDK_PATH}/platform/security/sl_component/sl_mbedtls_support/inc"
    "${SDK_PATH}/util/third_party/mbedtls/include"
    "${SDK_PATH}/util/third_party/mbedtls/library"
    "${SDK_PATH}/platform/service/memory_manager/inc"
    "${SDK_PATH}/platform/service/memory_manager/src"
    "${SDK_PATH}/platform/security/sl_component/sl_psa_driver/inc"
    "${SDK_PATH}/platform/security/sl_component/se_manager/inc"
    "${SDK_PATH}/util/third_party/trusted-firmware-m/lib/fih/inc"
    "${SDK_PATH}/util/third_party/trusted-firmware-m/platform/include"
    "${SDK_PATH}/platform/security/sl_component/sli_psec_osal/inc"
    "${SDK_PATH}/platform/service/udelay/inc"
)

target_compile_definitions(slc_bootloader-uart-bgapi PUBLIC
    "EFR32MG24B220F1536IM48=1"
    "SL_CODE_COMPONENT_SYSTEM=system"
    "SE_MANAGER_CONFIG_FILE=\"btl_aes_ctr_stream_block_cfg.h\""
    "BOOTLOADER_SUPPORT_COMMUNICATION=1"
    "BOOTLOADER_ENABLE=1"
    "BOOTLOADER_SECOND_STAGE=1"
    "SL_RAMFUNC_DISABLE=1"
    "__START=main"
    "__STARTUP_CLEAR_BSS=1"
    "SYSTEM_NO_STATIC_MEMORY=1"
    "BTL_GPIO_ACTIVATION=1"
    "BTL_UART_ENABLE=1"
    "SL_BOARD_NAME=\"BRD4187C\""
    "SL_BOARD_REV=\"A01\""
    "HARDWARE_BOARD_DEFAULT_RF_BAND_2400=1"
    "HARDWARE_BOARD_SUPPORTS_1_RF_BAND=1"
    "HARDWARE_BOARD_SUPPORTS_RF_BAND_2400=1"
    "HFXO_FREQ=39000000"
    "SL_COMPONENT_CATALOG_PRESENT=1"
    "MBEDTLS_CONFIG_FILE=<sl_mbedtls_trustzone_config.h>"
    "MBEDTLS_PSA_CRYPTO_CLIENT=1"
    "MBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>"
    "SL_CODE_COMPONENT_SE_MANAGER=se_manager"
    "SL_CODE_COMPONENT_CORE=core"
    "SL_CODE_COMPONENT_PSEC_OSAL=psec_osal"
    "SL_TRUSTZONE_SECURE=1"
)

target_link_libraries(slc_bootloader-uart-bgapi PUBLIC
    "-Wl,--start-group"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc_bootloader-uart-bgapi PUBLIC
    $<$<COMPILE_LANGUAGE:C>:-mcpu=cortex-m33>
    $<$<COMPILE_LANGUAGE:C>:-mthumb>
    $<$<COMPILE_LANGUAGE:C>:-mfpu=fpv5-sp-d16>
    $<$<COMPILE_LANGUAGE:C>:-mfloat-abi=hard>
    $<$<COMPILE_LANGUAGE:C>:-mcmse>
    $<$<COMPILE_LANGUAGE:C>:-Wall>
    $<$<COMPILE_LANGUAGE:C>:-Wextra>
    $<$<COMPILE_LANGUAGE:C>:-Os>
    $<$<COMPILE_LANGUAGE:C>:-fdata-sections>
    $<$<COMPILE_LANGUAGE:C>:-ffunction-sections>
    $<$<COMPILE_LANGUAGE:C>:-fomit-frame-pointer>
    $<$<COMPILE_LANGUAGE:C>:-g>
    $<$<COMPILE_LANGUAGE:C>:-Wno-ignored-qualifiers>
    $<$<COMPILE_LANGUAGE:C>:-Wno-sign-compare>
    $<$<COMPILE_LANGUAGE:C>:-fno-lto>
    $<$<COMPILE_LANGUAGE:C>:--specs=nano.specs>
    $<$<COMPILE_LANGUAGE:CXX>:-mcpu=cortex-m33>
    $<$<COMPILE_LANGUAGE:CXX>:-mthumb>
    $<$<COMPILE_LANGUAGE:CXX>:-mfpu=fpv5-sp-d16>
    $<$<COMPILE_LANGUAGE:CXX>:-mfloat-abi=hard>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    $<$<COMPILE_LANGUAGE:CXX>:-mcmse>
    $<$<COMPILE_LANGUAGE:CXX>:-Wall>
    $<$<COMPILE_LANGUAGE:CXX>:-Wextra>
    $<$<COMPILE_LANGUAGE:CXX>:-Os>
    $<$<COMPILE_LANGUAGE:CXX>:-fdata-sections>
    $<$<COMPILE_LANGUAGE:CXX>:-ffunction-sections>
    $<$<COMPILE_LANGUAGE:CXX>:-fomit-frame-pointer>
    $<$<COMPILE_LANGUAGE:CXX>:-g>
    $<$<COMPILE_LANGUAGE:CXX>:-Wno-ignored-qualifiers>
    $<$<COMPILE_LANGUAGE:CXX>:-Wno-sign-compare>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-lto>
    $<$<COMPILE_LANGUAGE:CXX>:--specs=nano.specs>
    $<$<COMPILE_LANGUAGE:ASM>:-mcpu=cortex-m33>
    $<$<COMPILE_LANGUAGE:ASM>:-mthumb>
    $<$<COMPILE_LANGUAGE:ASM>:-mfpu=fpv5-sp-d16>
    $<$<COMPILE_LANGUAGE:ASM>:-mfloat-abi=hard>
    "$<$<COMPILE_LANGUAGE:ASM>:SHELL:-x assembler-with-cpp>"
)

set(post_build_command ${POST_BUILD_EXE} postbuild "./bootloader-uart-bgapi.slpb" --parameter build_dir:"$<TARGET_FILE_DIR:bootloader-uart-bgapi>")
set_property(TARGET slc_bootloader-uart-bgapi PROPERTY C_STANDARD 17)
set_property(TARGET slc_bootloader-uart-bgapi PROPERTY CXX_STANDARD 17)
set_property(TARGET slc_bootloader-uart-bgapi PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc_bootloader-uart-bgapi INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    -T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld
    --specs=nano.specs
    "SHELL:-Xlinker -Map=$<TARGET_FILE_DIR:bootloader-uart-bgapi>/bootloader-uart-bgapi.map"
    "SHELL:-Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
