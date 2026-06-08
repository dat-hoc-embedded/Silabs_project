set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_empty_example_code_ADC OBJECT
    "${SDK_PATH}/app/common/util/app_log/app_log.c"
    "${SDK_PATH}/hardware/board/src/sl_board_control_gpio.c"
    "${SDK_PATH}/hardware/board/src/sl_board_init.c"
    "${SDK_PATH}/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/src/sl_mx25_flash_shutdown_eusart/sl_mx25_flash_shutdown.c"
    "${SDK_PATH}/platform/common/src/sl_assert.c"
    "${SDK_PATH}/platform/common/src/sl_core_cortexm.c"
    "${SDK_PATH}/platform/common/src/sl_slist.c"
    "${SDK_PATH}/platform/common/src/sl_string.c"
    "${SDK_PATH}/platform/common/src/sl_syscalls.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "${SDK_PATH}/platform/driver/debug/src/sl_debug_swo.c"
    "${SDK_PATH}/platform/driver/gpio/src/sl_gpio.c"
    "${SDK_PATH}/platform/emdrv/dmadrv/src/dmadrv.c"
    "${SDK_PATH}/platform/emlib/src/em_cmu.c"
    "${SDK_PATH}/platform/emlib/src/em_emu.c"
    "${SDK_PATH}/platform/emlib/src/em_eusart.c"
    "${SDK_PATH}/platform/emlib/src/em_gpio.c"
    "${SDK_PATH}/platform/emlib/src/em_iadc.c"
    "${SDK_PATH}/platform/emlib/src/em_ldma.c"
    "${SDK_PATH}/platform/emlib/src/em_msc.c"
    "${SDK_PATH}/platform/emlib/src/em_system.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_eusart.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_gpio.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_prs.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager_hal_s2.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager_init.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager_init_hal_s2.c"
    "${SDK_PATH}/platform/service/device_init/src/sl_device_init_dcdc_s2.c"
    "${SDK_PATH}/platform/service/device_init/src/sl_device_init_emu_s2.c"
    "${SDK_PATH}/platform/service/device_manager/clocks/sl_device_clock_efr32xg24.c"
    "${SDK_PATH}/platform/service/device_manager/devices/sl_device_peripheral_hal_efr32xg24.c"
    "${SDK_PATH}/platform/service/device_manager/src/sl_device_clock.c"
    "${SDK_PATH}/platform/service/device_manager/src/sl_device_gpio.c"
    "${SDK_PATH}/platform/service/device_manager/src/sl_device_peripheral.c"
    "${SDK_PATH}/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_eusart.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_retarget_stdio.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_stdlib_config.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_uart.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init_memory.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_process_action.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_iostream_handles.c"
    "../autogen/sl_iostream_init_eusart_instances.c"
    "../main.c"
    "../zIADC.c"
)

target_include_directories(slc_empty_example_code_ADC PUBLIC
   "../config"
   "../autogen"
   "../."
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Include"
    "${SDK_PATH}/app/common/util/app_log"
    "${SDK_PATH}/platform/common/inc"
    "${SDK_PATH}/hardware/board/inc"
    "${SDK_PATH}/platform/service/clock_manager/inc"
    "${SDK_PATH}/platform/service/clock_manager/src"
    "${SDK_PATH}/platform/CMSIS/Core/Include"
    "${SDK_PATH}/hardware/driver/configuration_over_swo/inc"
    "${SDK_PATH}/platform/driver/debug/inc"
    "${SDK_PATH}/platform/service/device_manager/inc"
    "${SDK_PATH}/platform/service/device_init/inc"
    "${SDK_PATH}/platform/emdrv/dmadrv/inc"
    "${SDK_PATH}/platform/emdrv/dmadrv/inc/s2_signals"
    "${SDK_PATH}/platform/emdrv/common/inc"
    "${SDK_PATH}/platform/emlib/inc"
    "${SDK_PATH}/platform/driver/gpio/inc"
    "${SDK_PATH}/platform/peripheral/inc"
    "${SDK_PATH}/platform/service/interrupt_manager/inc"
    "${SDK_PATH}/platform/service/interrupt_manager/src"
    "${SDK_PATH}/platform/service/interrupt_manager/inc/arm"
    "${SDK_PATH}/platform/service/iostream/inc"
    "${SDK_PATH}/platform/service/memory_manager/inc"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform/service/sl_main/inc"
    "${SDK_PATH}/platform/service/sl_main/src"
    "${SDK_PATH}/platform/service/udelay/inc"
)

target_compile_definitions(slc_empty_example_code_ADC PUBLIC
    "DEBUG_EFM=1"
    "EFR32MG24B220F1536IM48=1"
    "SL_CODE_COMPONENT_SYSTEM=system"
    "SL_BOARD_NAME=\"BRD4187C\""
    "SL_BOARD_REV=\"A01\""
    "HARDWARE_BOARD_DEFAULT_RF_BAND_2400=1"
    "HARDWARE_BOARD_SUPPORTS_1_RF_BAND=1"
    "HARDWARE_BOARD_SUPPORTS_RF_BAND_2400=1"
    "HFXO_FREQ=39000000"
    "SL_CODE_COMPONENT_CLOCK_MANAGER=clock_manager"
    "SL_COMPONENT_CATALOG_PRESENT=1"
    "SL_CODE_COMPONENT_DEVICE_PERIPHERAL=device_peripheral"
    "SL_CODE_COMPONENT_DMADRV=dmadrv"
    "SL_CODE_COMPONENT_GPIO=gpio"
    "SL_CODE_COMPONENT_HAL_COMMON=hal_common"
    "SL_CODE_COMPONENT_HAL_GPIO=hal_gpio"
    "SL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager"
    "CMSIS_NVIC_VIRTUAL=1"
    "CMSIS_NVIC_VIRTUAL_HEADER_FILE=\"cmsis_nvic_virtual.h\""
    "SL_CODE_COMPONENT_CORE=core"
)

target_link_libraries(slc_empty_example_code_ADC PUBLIC
    "-Wl,--start-group"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc_empty_example_code_ADC PUBLIC
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
    $<$<COMPILE_LANGUAGE:CXX>:-fno-lto>
    $<$<COMPILE_LANGUAGE:CXX>:--specs=nano.specs>
    $<$<COMPILE_LANGUAGE:ASM>:-mcpu=cortex-m33>
    $<$<COMPILE_LANGUAGE:ASM>:-mthumb>
    $<$<COMPILE_LANGUAGE:ASM>:-mfpu=fpv5-sp-d16>
    $<$<COMPILE_LANGUAGE:ASM>:-mfloat-abi=hard>
    "$<$<COMPILE_LANGUAGE:ASM>:SHELL:-x assembler-with-cpp>"
)

set(post_build_command )
set_property(TARGET slc_empty_example_code_ADC PROPERTY C_STANDARD 17)
set_property(TARGET slc_empty_example_code_ADC PROPERTY CXX_STANDARD 17)
set_property(TARGET slc_empty_example_code_ADC PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc_empty_example_code_ADC INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    -T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld
    --specs=nano.specs
    "SHELL:-Xlinker -Map=$<TARGET_FILE_DIR:empty_example_code_ADC>/empty_example_code_ADC.map"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
