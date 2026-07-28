####################################################################
# Automatically-generated file. Do not edit!                       #
####################################################################

set(SDK_PATH "C:/Users/sucut/.silabs/slt/installs/conan/p/simpl508ee6c1a6569/p")
set(COPIED_SDK_PATH "simplicity_sdk_2026.6.0")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc OBJECT
    "../${COPIED_SDK_PATH}/boards/hardware/board/src/sl_board_control_gpio.c"
    "../${COPIED_SDK_PATH}/boards/hardware/board/src/sl_board_init.c"
    "../${COPIED_SDK_PATH}/boards/hardware/driver/mx25_flash_shutdown/src/sl_mx25_flash_shutdown_eusart/sl_mx25_flash_shutdown.c"
    "../${COPIED_SDK_PATH}/platform_core/app/common/util/app_log/app_log.c"
    "../${COPIED_SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_assert.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_core_cortexm.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_slist.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_string.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_syscalls.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/debug/src/sl_debug_swo.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/dma_channel/src/sl_dma_channel.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/dma_channel/src/sl_dma_descriptor_allocator.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/gpio/src/sl_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/leddrv/src/sl_led.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/leddrv/src/sl_simple_led.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_burtc.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_cmu.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_emu.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_eusart.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_msc.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_prs.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_system.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_timer.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_acmp.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_eusart.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_ldma.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_prs.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_syscfg.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_sysrtc.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_sysrtc_subsystem.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_system.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager_hal_s2.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager_init.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager_init_hal_s2.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_init/src/sl_device_init_dcdc_s2.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_init/src/sl_device_init_emu_s2.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/clocks/sl_device_clock_efr32xg24.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/devices/sl_device_peripheral_hal_efr32xg24.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/dma/sl_device_dma_s2.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_clock.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_dma.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_peripheral.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/dma_manager/src/sl_dma_manager.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/dma_manager/src/sl_dma_manager_hal_ldma.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_dmadrv.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_eusart.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_retarget_stdio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_stdlib_config.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_uart.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_pool.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_pool_common.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_retarget.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sli_memory_manager_common.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_init.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_init_memory.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_process_action.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer_hal_burtc.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer_hal_sysrtc.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer_hal_timer.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_dma_manager_instances.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_iostream_handles.c"
    "../autogen/sl_iostream_init_eusart_instances.c"
    "../autogen/sl_simple_led_instances.c"
    "../main.c"
)

target_include_directories(slc PUBLIC
   "../config"
   "../autogen"
   "../."
    "../${COPIED_SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Include"
    "../${COPIED_SDK_PATH}/platform_core/app/common/util/app_log"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/inc"
    "../${COPIED_SDK_PATH}/boards/hardware/board/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/src"
    "../${COPIED_SDK_PATH}/cmsis/Core/Include"
    "../${COPIED_SDK_PATH}/cmsis/Core/Include/m-profile"
    "../${COPIED_SDK_PATH}/cmsis/Core/Include/a-profile"
    "../${COPIED_SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/debug/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_init/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/dma_channel/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/dma_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/dma_manager/src"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/errno_error_codes/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/gpio/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/src"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/inc/arm"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/iostream/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/leddrv/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src"
    "../${COPIED_SDK_PATH}/boards/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sleeptimer/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sleeptimer/src"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/udelay/inc"
    "../**/include"
)

target_compile_definitions(slc PUBLIC
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
    "SL_CODE_COMPONENT_DMA_CHANNEL=dma_channel"
    "SL_CODE_COMPONENT_DMA_MANAGER=dma_manager"
    "SL_CODE_COMPONENT_GPIO=gpio"
    "SL_CODE_COMPONENT_HAL_COMMON=hal_common"
    "SL_CODE_COMPONENT_HAL_GPIO=hal_gpio"
    "SL_CODE_COMPONENT_HAL_LDMA=hal_ldma"
    "SL_CODE_COMPONENT_HAL_SYSRTC=hal_sysrtc"
    "SL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager"
    "CMSIS_NVIC_VIRTUAL=1"
    "CMSIS_NVIC_VIRTUAL_HEADER_FILE=\"cmsis_nvic_virtual.h\""
    "SL_CODE_COMPONENT_MEMORY_MANAGER=memory_manager"
    "SL_CODE_COMPONENT_CORE=core"
    "SL_CODE_COMPONENT_SLEEPTIMER=sleeptimer"
)

target_link_libraries(slc PUBLIC
    "-Wl,--start-group"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc PUBLIC
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
    $<$<COMPILE_LANGUAGE:C>:--specs=nano.specs>
    $<$<COMPILE_LANGUAGE:C>:-fno-lto>
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
    $<$<COMPILE_LANGUAGE:CXX>:--specs=nano.specs>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-lto>
    $<$<COMPILE_LANGUAGE:ASM>:-mcpu=cortex-m33>
    $<$<COMPILE_LANGUAGE:ASM>:-mthumb>
    $<$<COMPILE_LANGUAGE:ASM>:-mfpu=fpv5-sp-d16>
    $<$<COMPILE_LANGUAGE:ASM>:-mfloat-abi=hard>
    "$<$<COMPILE_LANGUAGE:ASM>:SHELL:-x assembler-with-cpp>"
)

set(post_build_command )
set_property(TARGET slc PROPERTY C_STANDARD 17)
set_property(TARGET slc PROPERTY CXX_STANDARD 17)
set_property(TARGET slc PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    "-T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld"
    --specs=nano.specs
    -Wl,-Map=$<TARGET_FILE_DIR:empty>/empty.map
    "SHELL:-Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA