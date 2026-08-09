####################################################################
# Automatically-generated file. Do not edit!                       #
####################################################################

set(SDK_PATH "C:/Users/sucut/.silabs/slt/installs/conan/p/simpl508ee6c1a6569/p")
set(COPIED_SDK_PATH "simplicity_sdk_2026.6.0")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc OBJECT
    "${SDK_PATH}/boards/hardware/board/src/sl_board_control_gpio.c"
    "${SDK_PATH}/boards/hardware/board/src/sl_board_init.c"
    "${SDK_PATH}/boards/hardware/driver/mx25_flash_shutdown/src/sl_mx25_flash_shutdown_eusart/sl_mx25_flash_shutdown.c"
    "${SDK_PATH}/platform_core/app/common/util/app_log/app_log.c"
    "${SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_assert.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_core_cortexm.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_slist.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_string.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_syscalls.c"
    "${SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "${SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "${SDK_PATH}/platform_core/platform/driver/debug/src/sl_debug_swo.c"
    "${SDK_PATH}/platform_core/platform/driver/dma_channel/src/sl_dma_channel.c"
    "${SDK_PATH}/platform_core/platform/driver/dma_channel/src/sl_dma_descriptor_allocator.c"
    "${SDK_PATH}/platform_core/platform/driver/gpio/src/sl_gpio.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_cmu.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_emu.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_eusart.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_gpio.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_msc.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_system.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_eusart.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_gpio.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_ldma.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_prs.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_syscfg.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_system.c"
    "${SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager.c"
    "${SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager_hal_s2.c"
    "${SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager_init.c"
    "${SDK_PATH}/platform_core/platform/service/clock_manager/src/sl_clock_manager_init_hal_s2.c"
    "${SDK_PATH}/platform_core/platform/service/device_init/src/sl_device_init_dcdc_s2.c"
    "${SDK_PATH}/platform_core/platform/service/device_init/src/sl_device_init_emu_s2.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/clocks/sl_device_clock_efr32xg24.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/devices/sl_device_peripheral_hal_efr32xg24.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/dma/sl_device_dma_s2.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_clock.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_dma.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_gpio.c"
    "${SDK_PATH}/platform_core/platform/service/device_manager/src/sl_device_peripheral.c"
    "${SDK_PATH}/platform_core/platform/service/dma_manager/src/sl_dma_manager.c"
    "${SDK_PATH}/platform_core/platform/service/dma_manager/src/sl_dma_manager_hal_ldma.c"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c"
    "${SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream.c"
    "${SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_dmadrv.c"
    "${SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_eusart.c"
    "${SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_retarget_stdio.c"
    "${SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_stdlib_config.c"
    "${SDK_PATH}/platform_core/platform/service/iostream/src/sl_iostream_uart.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_pool.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_pool_common.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_retarget.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sli_memory_manager_common.c"
    "${SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_init.c"
    "${SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_init_memory.c"
    "${SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_process_action.c"
    "${SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_dma_manager_instances.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_iostream_handles.c"
    "../autogen/sl_iostream_init_eusart_instances.c"
    "../main.c"
)

target_include_directories(slc PUBLIC
   "../config"
   "../autogen"
   "../."
    "${SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Include"
    "${SDK_PATH}/platform_core/app/common/util/app_log"
    "${SDK_PATH}/platform_core/platform/common/inc"
    "${SDK_PATH}/boards/hardware/board/inc"
    "${SDK_PATH}/platform_core/platform/service/clock_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/clock_manager/src"
    "${SDK_PATH}/cmsis/Core/Include"
    "${SDK_PATH}/cmsis/Core/Include/m-profile"
    "${SDK_PATH}/cmsis/Core/Include/a-profile"
    "${SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/inc"
    "${SDK_PATH}/platform_core/platform/driver/debug/inc"
    "${SDK_PATH}/platform_core/platform/service/device_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/device_init/inc"
    "${SDK_PATH}/platform_core/platform/driver/dma_channel/inc"
    "${SDK_PATH}/platform_core/platform/service/dma_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/dma_manager/src"
    "${SDK_PATH}/platform_core/platform/emlib/inc"
    "${SDK_PATH}/platform_core/platform/common/errno_error_codes/inc"
    "${SDK_PATH}/platform_core/platform/driver/gpio/inc"
    "${SDK_PATH}/platform_core/platform/peripheral/inc"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/src"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/inc/arm"
    "${SDK_PATH}/platform_core/platform/service/iostream/inc"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src"
    "${SDK_PATH}/boards/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform_core/platform/service/sl_main/inc"
    "${SDK_PATH}/platform_core/platform/service/sl_main/src"
    "${SDK_PATH}/platform_core/platform/service/udelay/inc"
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
    "SL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager"
    "CMSIS_NVIC_VIRTUAL=1"
    "CMSIS_NVIC_VIRTUAL_HEADER_FILE=\"cmsis_nvic_virtual.h\""
    "SL_CODE_COMPONENT_MEMORY_MANAGER=memory_manager"
    "SL_CODE_COMPONENT_CORE=core"
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
    -Wl,-Map=$<TARGET_FILE_DIR:empty_2>/empty_2.map
    "SHELL:-Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA