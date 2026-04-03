set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_empty_example_code_ADC OBJECT
    "${SDK_PATH}/hardware/board/src/sl_board_control_gpio.c"
    "${SDK_PATH}/hardware/board/src/sl_board_init.c"
    "${SDK_PATH}/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/src/sl_mx25_flash_shutdown_eusart/sl_mx25_flash_shutdown.c"
    "${SDK_PATH}/platform/common/src/sl_assert.c"
    "${SDK_PATH}/platform/common/src/sl_core_cortexm.c"
    "${SDK_PATH}/platform/common/src/sl_syscalls.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "${SDK_PATH}/platform/driver/debug/src/sl_debug_swo.c"
    "${SDK_PATH}/platform/driver/gpio/src/sl_gpio.c"
    "${SDK_PATH}/platform/emlib/src/em_cmu.c"
    "${SDK_PATH}/platform/emlib/src/em_emu.c"
    "${SDK_PATH}/platform/emlib/src/em_eusart.c"
    "${SDK_PATH}/platform/emlib/src/em_gpio.c"
    "${SDK_PATH}/platform/emlib/src/em_msc.c"
    "${SDK_PATH}/platform/emlib/src/em_system.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_gpio.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager_hal_s2.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager_init.c"
    "${SDK_PATH}/platform/service/clock_manager/src/sl_clock_manager_init_hal_s2.c"
    "${SDK_PATH}/platform/service/device_init/src/sl_device_init_dcdc_s2.c"
    "${SDK_PATH}/platform/service/device_init/src/sl_device_init_emu_s2.c"
    "${SDK_PATH}/platform/service/device_manager/clocks/sl_device_clock_efr32xg24.c"
    "${SDK_PATH}/platform/service/device_manager/src/sl_device_clock.c"
    "${SDK_PATH}/platform/service/device_manager/src/sl_device_gpio.c"
    "${SDK_PATH}/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init_memory.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_process_action.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_event_handler.c"
    "../main.c"
)

target_include_directories(slc_empty_example_code_ADC PUBLIC
   "../config"
   "../autogen"
   "../."
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Include"
    "${SDK_PATH}/hardware/board/inc"
    "${SDK_PATH}/platform/service/clock_manager/inc"
    "${SDK_PATH}/platform/service/clock_manager/src"
    "${SDK_PATH}/platform/CMSIS/Core/Include"
    "${SDK_PATH}/platform/common/inc"
    "${SDK_PATH}/hardware/driver/configuration_over_swo/inc"
    "${SDK_PATH}/platform/driver/debug/inc"
    "${SDK_PATH}/platform/service/device_manager/inc"
    "${SDK_PATH}/platform/service/device_init/inc"
    "${SDK_PATH}/platform/emlib/inc"
    "${SDK_PATH}/platform/driver/gpio/inc"
    "${SDK_PATH}/platform/peripheral/inc"
    "${SDK_PATH}/platform/service/interrupt_manager/inc"
    "${SDK_PATH}/platform/service/interrupt_manager/src"
    "${SDK_PATH}/platform/service/interrupt_manager/inc/arm"
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
