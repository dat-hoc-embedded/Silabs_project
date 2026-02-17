set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_empty_cpp OBJECT
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
    "${SDK_PATH}/platform/driver/leddrv/src/sl_led.c"
    "${SDK_PATH}/platform/driver/leddrv/src/sl_simple_led.c"
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
    "../app.cpp"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_simple_led_instances.c"
    "../main.c"
)

target_include_directories(slc_empty_cpp PUBLIC
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
    "${SDK_PATH}/platform/driver/leddrv/inc"
    "${SDK_PATH}/platform/service/memory_manager/inc"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform/service/sl_main/inc"
    "${SDK_PATH}/platform/service/sl_main/src"
    "${SDK_PATH}/platform/service/udelay/inc"
)

target_compile_definitions(slc_empty_cpp PUBLIC
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

target_link_libraries(slc_empty_cpp PUBLIC
    "-Wl,--start-group"
    "stdc++"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc_empty_cpp PUBLIC
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
set_property(TARGET slc_empty_cpp PROPERTY C_STANDARD 17)
set_property(TARGET slc_empty_cpp PROPERTY CXX_STANDARD 17)
set_property(TARGET slc_empty_cpp PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc_empty_cpp INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    -T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld
    --specs=nano.specs
    "SHELL:-Xlinker -Map=$<TARGET_FILE_DIR:empty_cpp>/empty_cpp.map"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
