set(SDK_PATH "C:/Users/sucut/SimplicityStudio/SDKs/simplicity_sdk")
set(COPIED_SDK_PATH "simplicity_sdk_2025.6.2")
set(PKG_PATH "C:/Users/sucut/.silabs/slt/installs")

add_library(slc_blink_kernel_freertos OBJECT
    "${SDK_PATH}/app/common/util/app_log/app_log.c"
    "${SDK_PATH}/hardware/board/src/sl_board_control_gpio.c"
    "${SDK_PATH}/hardware/board/src/sl_board_init.c"
    "${SDK_PATH}/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/src/sl_mx25_flash_shutdown_eusart/sl_mx25_flash_shutdown.c"
    "${SDK_PATH}/platform/CMSIS/RTOS2/Source/os_systick.c"
    "${SDK_PATH}/platform/common/src/sl_assert.c"
    "${SDK_PATH}/platform/common/src/sl_cmsis_os2_common.c"
    "${SDK_PATH}/platform/common/src/sl_core_cortexm.c"
    "${SDK_PATH}/platform/common/src/sl_slist.c"
    "${SDK_PATH}/platform/common/src/sl_string.c"
    "${SDK_PATH}/platform/common/src/sl_syscalls.c"
    "${SDK_PATH}/platform/common/src/sli_cmsis_os2_ext_task_register.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "${SDK_PATH}/platform/driver/button/src/sl_button.c"
    "${SDK_PATH}/platform/driver/button/src/sl_simple_button.c"
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
    "${SDK_PATH}/platform/peripheral/src/sl_hal_eusart.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_gpio.c"
    "${SDK_PATH}/platform/peripheral/src/sl_hal_prs.c"
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
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_eusart.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_retarget_stdio.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_stdlib_config.c"
    "${SDK_PATH}/platform/service/iostream/src/sl_iostream_uart.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_pool.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_pool_common.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_region.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sl_memory_manager_retarget.c"
    "${SDK_PATH}/platform/service/memory_manager/src/sli_memory_manager_common.c"
    "${SDK_PATH}/platform/service/sl_main/src/rtos/main_retarget.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_init_memory.c"
    "${SDK_PATH}/platform/service/sl_main/src/sl_main_kernel.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer_hal_burtc.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer_hal_sysrtc.c"
    "${SDK_PATH}/platform/service/sleeptimer/src/sl_sleeptimer_hal_timer.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "${SDK_PATH}/util/third_party/freertos/cmsis/Source/cmsis_os2.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/croutine.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/event_groups.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/list.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/mpu_wrappers_v2_asm.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/portable/MemMang/heap_3.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/queue.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/stream_buffer.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/tasks.c"
    "${SDK_PATH}/util/third_party/freertos/kernel/timers.c"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_iostream_handles.c"
    "../autogen/sl_iostream_init_eusart_instances.c"
    "../autogen/sl_simple_button_instances.c"
    "../autogen/sl_simple_led_instances.c"
    "../autogen/sl_uartdrv_init.c"
    "../blink.c"
    "../main.c"
    "../zmy_led.c"
    "../zmy_queue/my_queue.c"
)

target_include_directories(slc_blink_kernel_freertos PUBLIC
   "../config"
   "../autogen"
   "../."
    "${SDK_PATH}/platform/Device/SiliconLabs/EFR32MG24/Include"
    "${SDK_PATH}/app/common/util/app_log"
    "${SDK_PATH}/platform/common/inc"
    "${SDK_PATH}/hardware/board/inc"
    "${SDK_PATH}/platform/driver/button/inc"
    "${SDK_PATH}/platform/service/clock_manager/inc"
    "${SDK_PATH}/platform/service/clock_manager/src"
    "${SDK_PATH}/platform/CMSIS/Core/Include"
    "${SDK_PATH}/platform/CMSIS/RTOS2/Include"
    "${SDK_PATH}/hardware/driver/configuration_over_swo/inc"
    "${SDK_PATH}/platform/driver/debug/inc"
    "${SDK_PATH}/platform/service/device_manager/inc"
    "${SDK_PATH}/platform/service/device_init/inc"
    "${SDK_PATH}/platform/emdrv/dmadrv/inc"
    "${SDK_PATH}/platform/emdrv/dmadrv/inc/s2_signals"
    "${SDK_PATH}/platform/emdrv/common/inc"
    "${SDK_PATH}/platform/emlib/inc"
    "${SDK_PATH}/util/third_party/freertos/kernel/include"
    "${SDK_PATH}/util/third_party/freertos/cmsis/Include"
    "${SDK_PATH}/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure"
    "${SDK_PATH}/platform/driver/gpio/inc"
    "${SDK_PATH}/platform/peripheral/inc"
    "${SDK_PATH}/platform/service/interrupt_manager/inc"
    "${SDK_PATH}/platform/service/interrupt_manager/src"
    "${SDK_PATH}/platform/service/interrupt_manager/inc/arm"
    "${SDK_PATH}/platform/service/iostream/inc"
    "${SDK_PATH}/platform/driver/leddrv/inc"
    "${SDK_PATH}/platform/service/memory_manager/inc"
    "${SDK_PATH}/platform/service/memory_manager/src"
    "${SDK_PATH}/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform/service/sl_main/inc"
    "${SDK_PATH}/platform/service/sl_main/src"
    "${SDK_PATH}/platform/service/sleeptimer/inc"
    "${SDK_PATH}/platform/emdrv/uartdrv/inc"
    "${SDK_PATH}/platform/service/udelay/inc"
)

target_compile_definitions(slc_blink_kernel_freertos PUBLIC
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
    "configNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2"
    "SL_COMPONENT_CATALOG_PRESENT=1"
    "SL_CODE_COMPONENT_DEVICE_PERIPHERAL=device_peripheral"
    "SL_CODE_COMPONENT_DMADRV=dmadrv"
    "SL_CODE_COMPONENT_FREERTOS_KERNEL=freertos_kernel"
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

target_link_libraries(slc_blink_kernel_freertos PUBLIC
    "-Wl,--start-group"
    "gcc"
    "c"
    "m"
    "nosys"
    "-Wl,--end-group"
)
target_compile_options(slc_blink_kernel_freertos PUBLIC
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
set_property(TARGET slc_blink_kernel_freertos PROPERTY C_STANDARD 17)
set_property(TARGET slc_blink_kernel_freertos PROPERTY CXX_STANDARD 17)
set_property(TARGET slc_blink_kernel_freertos PROPERTY CXX_EXTENSIONS OFF)

target_link_options(slc_blink_kernel_freertos INTERFACE
    -mcpu=cortex-m33
    -mthumb
    -mfpu=fpv5-sp-d16
    -mfloat-abi=hard
    -T${CMAKE_CURRENT_LIST_DIR}/../autogen/linkerfile.ld
    --specs=nano.specs
    "SHELL:-Xlinker -Map=$<TARGET_FILE_DIR:blink_kernel_freertos>/blink_kernel_freertos.map"
    "SHELL:-Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r"
    -Wl,--wrap=main
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
