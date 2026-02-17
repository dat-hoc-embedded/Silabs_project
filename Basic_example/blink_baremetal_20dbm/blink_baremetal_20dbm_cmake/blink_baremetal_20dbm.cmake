set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_blink_baremetal_20dbm OBJECT
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
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_retarget_stdio.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_stdlib_config.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_uart.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_usart.c"
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
    "../autogen/sl_iostream_handles.c"
    "../autogen/sl_iostream_init_usart_instances.c"
    "../autogen/sl_simple_led_instances.c"
    "../autogen/sl_uartdrv_init.c"
    "../blink.c"
    "../main.c"
)

target_include_directories(slc_blink_baremetal_20dbm PUBLIC
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
    "${SDK_PATH}/platform/driver/leddrv/inc"
    "${SDK_PATH}/platform/service/memory_manager/inc"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform/service/sl_main/inc"
    "${SDK_PATH}/platform/service/sl_main/src"
    "${SDK_PATH}/platform/service/sleeptimer/inc"
    "${SDK_PATH}/platform/emdrv/uartdrv/inc"
    "${SDK_PATH}/platform/service/udelay/inc"
)

target_compile_definitions(slc_blink_baremetal_20dbm PUBLIC
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

target_link_libraries(slc_blink_baremetal_20dbm PUBLIC
    "-Wl,--start-group"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc_blink_baremetal_20dbm PUBLIC
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
set_property(TARGET slc_blink_baremetal_20dbm PROPERTY C_STANDARD 17)
set_property(TARGET slc_blink_baremetal_20dbm PROPERTY CXX_STANDARD 17)
set_property(TARGET slc_blink_baremetal_20dbm PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc_blink_baremetal_20dbm INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    -T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld
    --specs=nano.specs
    "SHELL:-Xlinker -Map=$<TARGET_FILE_DIR:blink_baremetal_20dbm>/blink_baremetal_20dbm.map"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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=END_SIMPLICITY_STUDIO_METADATA
