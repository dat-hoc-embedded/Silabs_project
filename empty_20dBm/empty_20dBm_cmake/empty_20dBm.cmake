set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_empty_20dBm OBJECT
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
    "${SDK_PATH}/platform/emdrv/dmadrv/src/dmadrv.c"
    "${SDK_PATH}/platform/emdrv/uartdrv/src/uartdrv.c"
    "${SDK_PATH}/platform/emlib/src/em_burtc.c"
    "${SDK_PATH}/platform/emlib/src/em_cmu.c"
    "${SDK_PATH}/platform/emlib/src/em_emu.c"
    "${SDK_PATH}/platform/emlib/src/em_eusart.c"
    "${SDK_PATH}/platform/emlib/src/em_gpio.c"
    "${SDK_PATH}/platform/emlib/src/em_ldma.c"
    "${SDK_PATH}/platform/emlib/src/em_msc.c"
    "${SDK_PATH}/platform/emlib/src/em_prs.c"
    "${SDK_PATH}/platform/emlib/src/em_system.c"
    "${SDK_PATH}/platform/emlib/src/em_timer.c"
    "${SDK_PATH}/platform/emlib/src/em_usart.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_gpio.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_sysrtc.c"
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
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init_memory.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_process_action.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer_hal_burtc.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer_hal_sysrtc.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer_hal_timer.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_simple_led_instances.c"
    "../autogen/sl_uartdrv_init.c"
    "../main.c"
    "../src"
    "../src/embeddat_gpio.c"
    "../src/embeddat_sleeptimer.c"
)

target_include_directories(slc_empty_20dBm PUBLIC
   "../config"
   "../autogen"
   "../."
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Include"
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
    "${SDK_PATH}/platform/driver/leddrv/inc"
    "${SDK_PATH}/platform/service/memory_manager/inc"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform/service/sl_main/inc"
    "${SDK_PATH}/platform/service/sl_main/src"
    "${SDK_PATH}/platform/service/sleeptimer/inc"
    "${SDK_PATH}/platform/emdrv/uartdrv/inc"
    "${SDK_PATH}/platform/service/udelay/inc"
    "../inc"
)

target_compile_definitions(slc_empty_20dBm PUBLIC
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
    "SL_CODE_COMPONENT_HAL_SYSRTC=hal_sysrtc"
    "SL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager"
    "CMSIS_NVIC_VIRTUAL=1"
    "CMSIS_NVIC_VIRTUAL_HEADER_FILE=\"cmsis_nvic_virtual.h\""
    "SL_CODE_COMPONENT_CORE=core"
    "SL_CODE_COMPONENT_SLEEPTIMER=sleeptimer"
    "SL_CODE_COMPONENT_UARTDRV=uartdrv"
)

target_link_libraries(slc_empty_20dBm PUBLIC
    "-Wl,--start-group"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc_empty_20dBm PUBLIC
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
set_property(TARGET slc_empty_20dBm PROPERTY C_STANDARD 17)
set_property(TARGET slc_empty_20dBm PROPERTY CXX_STANDARD 17)
set_property(TARGET slc_empty_20dBm PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc_empty_20dBm INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    -T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld
    --specs=nano.specs
    "SHELL:-Xlinker -Map=$<TARGET_FILE_DIR:empty_20dBm>/empty_20dBm.map"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
