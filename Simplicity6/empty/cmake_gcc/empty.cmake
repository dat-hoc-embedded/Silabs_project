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
    "../${COPIED_SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_assert.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_core_cortexm.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/src/sl_syscalls.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/debug/src/sl_debug_swo.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/gpio/src/sl_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_cmu.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_emu.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_eusart.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_msc.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/src/em_system.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_eusart.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_gpio.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_prs.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_syscfg.c"
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
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_init.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_init_memory.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src/sl_main_process_action.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay.c"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_event_handler.c"
    "../main.c"
)

target_include_directories(slc PUBLIC
   "../config"
   "../autogen"
   "../."
    "../${COPIED_SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Include"
    "../${COPIED_SDK_PATH}/boards/hardware/board/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/clock_manager/src"
    "../${COPIED_SDK_PATH}/cmsis/Core/Include"
    "../${COPIED_SDK_PATH}/cmsis/Core/Include/m-profile"
    "../${COPIED_SDK_PATH}/cmsis/Core/Include/a-profile"
    "../${COPIED_SDK_PATH}/platform_core/platform/common/inc"
    "../${COPIED_SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/debug/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/device_init/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/emlib/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/driver/gpio/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/peripheral/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/src"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/interrupt_manager/inc/arm"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/memory_manager/inc"
    "../${COPIED_SDK_PATH}/boards/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/inc"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/sl_main/src"
    "../${COPIED_SDK_PATH}/platform_core/platform/service/udelay/inc"
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
    "SL_CODE_COMPONENT_GPIO=gpio"
    "SL_CODE_COMPONENT_HAL_COMMON=hal_common"
    "SL_CODE_COMPONENT_HAL_GPIO=hal_gpio"
    "SL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager"
    "CMSIS_NVIC_VIRTUAL=1"
    "CMSIS_NVIC_VIRTUAL_HEADER_FILE=\"cmsis_nvic_virtual.h\""
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
    -Wl,-Map=$<TARGET_FILE_DIR:empty>/empty.map
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA