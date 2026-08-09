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
    "${SDK_PATH}/platform_core/platform/driver/leddrv/src/sl_led.c"
    "${SDK_PATH}/platform_core/platform/driver/leddrv/src/sl_simple_led.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_burtc.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_cmu.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_emu.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_eusart.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_gpio.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_msc.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_prs.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_system.c"
    "${SDK_PATH}/platform_core/platform/emlib/src/em_timer.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_eusart.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_gpio.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_ldma.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_prs.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_syscfg.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_sysrtc.c"
    "${SDK_PATH}/platform_core/platform/peripheral/src/sl_hal_sysrtc_subsystem.c"
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
    "${SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer.c"
    "${SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer_hal_burtc.c"
    "${SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer_hal_sysrtc.c"
    "${SDK_PATH}/platform_core/platform/service/sleeptimer/src/sl_sleeptimer_hal_timer.c"
    "${SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay.c"
    "${SDK_PATH}/platform_core/platform/service/udelay/src/sl_udelay_armv6m_gcc.S"
    "../app.c"
    "../autogen/sl_board_default_init.c"
    "../autogen/sl_dma_manager_instances.c"
    "../autogen/sl_event_handler.c"
    "../autogen/sl_iostream_handles.c"
    "../autogen/sl_iostream_init_eusart_instances.c"
    "../autogen/sl_simple_led_instances.c"
    "../blink.c"
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
    "${SDK_PATH}/platform_core/platform/driver/leddrv/inc"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src"
    "${SDK_PATH}/boards/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_eusart"
    "${SDK_PATH}/platform_core/platform/service/sl_main/inc"
    "${SDK_PATH}/platform_core/platform/service/sl_main/src"
    "${SDK_PATH}/platform_core/platform/service/sleeptimer/inc"
    "${SDK_PATH}/platform_core/platform/service/sleeptimer/src"
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
    -Wl,-Map=$<TARGET_FILE_DIR:blink_baremetal>/blink_baremetal.map
    "SHELL:-Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r"
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=eJztfQtz3DiS5l9xKCYudm+tqlJJKkled0+obblbd5alleSZnVhvMFgkqopjvpYPWZqJ+e8HgOADJMgCSACk5np27bYoMvP7Eq/EK/PvBw/XN3efrz9cP/7FeHj8+vH61rj7ePNw8O7g/R+fPffbtzdPIIqdwP/p28HRbPHtAD4BvhXYjr+Fj74+fjo8/3bwx5+/ffsWwT/++zAK/gqsBL7mmx6Ar6TWzAvs1AWzGCRpOEutD4G/cbaztev43421GQEPJKY721oWFg8lhCBKXh4s+F8oIJd4UCiBL8H/f78JXBtEpSYLy228l7/tuKB8N3YNyw2s74Zn+uYWREYQW47rmkkQGZmc2Q6j2QIfRGYCbPhREqUAP0TI8ZON6cbw0byXyiQCQKGy2PFCFxgusNGfhUpNLgBh4nhApe3WgRnZSH4SBa5CPTZYp1sj/hEo1fHkWMBwfCcxbMu2NKkCXqpQkwe8IHopancEtrDbUKnveXlqbFwz3hnxLk3s4IdvgDQ2o0RlCw4ilW22ZkN1ipwght2P6eUWe7ICT5U6MwwNN9hKEP9+nvX59ceOb7mpDe7MZAd/TCMHkUxS2wnezcnwMc9Hh1Lm+/x3xZM36ga9RwB7Y8hX/rBnpkkArck37l3+evXl8eHw4fPlLzPPxorXqeMmjl8th2bhiPXSNtiYqZvgXmdmSdZy/3hlfAi8MPCBn8SkOkklYeXSDcuERRRsVSixPbNo544fJ6ZvgVi6sVoVKWAEnpDJdqZvuyBSr0CBqYpeMdOhxEoNHSp54GFfaaHTqshoorQ+79GogGPFk1bKjKlHNh88xkbo2cwdMAAMGYqLEWuUsZi8cANHXxt27yMPyPDFGdHkgPj/x/IoRtsH/KP04sCtyrGc5MWI7e/GcrFczVYIeUvx1D5HXtsmiDzs+rd8tOfTzq9avv2I520cX7Z8/+BAzoH/2VzH3EJaRF19uj9e3vy6PBEU1IYsSCMBZiyJdMeZwAEgDQ2wiY6X3nZ5QrrmWl03re/QBULTANOfh3NcK04X5wCsrCNzdbq6gA+psi5+mmdlMa+YdF7YZJ7RmTNRsDvkPhxf4gR4Y1NkgOjDsKWr6lWZrrPuTV5tKtitl8vF5uj0eOV4J+dkFNZkb0Jq3o5FWsUqVBim5YUj0ywwqKBXuFLjscsgKCC3TiPTG5teAUINwcSaAMEMhAKClpeOTY9AUEAOLXGPzS7HoIIeROJvgtEZljBUkPRMqCG2IidMgmh0rg00KiiHrjs6UYJBAT0wfpcDlHU52bLQ6PwKFAoobuLIGr3TKUAoILgNrWj0caMAoYSgM3oB5hgU0TPCYPxmSAFRQHS3mUBLLEAoIfg8AX7Pqug5y9G7GQJBBTlzfOc7x6CCnmVaOzA6wQKFAorfwUtsmf7YHCswFJB0oUs/NsMcgyJ6z2tz9IlTFYdCmugEiOOPv+TGwqOCNsCnH0dnW8JQQXIKXo6r0MtxJ+DluOq8HM903HXwPDbDCgwVJENzt57AYngVhwqa8eg+HYGggtzT6BtRBIICcqHljz4fzjGooBeNPuYTCGrIGbGz9U13CiSrUBSQja3ITKxdaNpjc6WRqKAKJjI2UkBUEB1/yT9WtuQfw+npZjs6vwKFGooT2AcvUSigOImJlMppVDqJeVSqciI1ib03lVtvT7Y5eivMMSig98MORu9Hcwzy6HnkLuRIzKrq1Z0LHYUbC4W2g6GCH3G/zv9i8x665wVtx/85vnd8S/jIdv0qiZkEniO/j8qozSHCOaVErLQZ1wYd+eMFjZVoGArUCmxgWK4Zx87GsczECeTvy9DAWzQOJOLoZ9KqcmiZAD+Vv95HF0KuYihUSB0ocI1qzbJQMry2I7nKK3iuRALc0HEVTB8agAs1wyFH8h2SOtyoh9PBuJ2YRI4v3y+kwZZKBsN1nVh1Syt0DLetmaTyFxXrts2V8MIV9a3qngyIIj8w4N84qo4NBl9FE3eNmBZv4FJl+YYiXBZM9YJVSJHX22L3OJLgkmbDkuyba8TSEOGcUiKjZ0Z/JeDZUwy6rkpST60WdKlkMFx0rsh1Y9WAK2rkDC6K8eY6pPfW/ae2sHENu5ZMRUAbOhqI90qtjZ0KzFYJWyOvcInp5pSqogdg6u+1hsKY6TWEGztT/s2WLoJdIKSwbJFvxMuxC7ICQwHTEdkpq6FjV06F9XL8Ktm3NvZbm1Xkv7N7TD11Jp9VM/WraOHj0ZLGyBmREkP3pKdaJGDn5FwkggsbU1kHRpPPe7C6ajmtjEhFZ/5HoUMUSyWDb/ONwibXLJVOCCIn3IEIDsijkKL1v+4Bk2pEqjrgmjXJoFJXLb39jkJnwGWh7vY7Cpsh94Dbo04ruFjJxWbAdUqezmgUTrR+RdSM5CVUsBwuSLBEMUafi/sp0a0Knm43OyHzvFUQv63FwBmVeh9M4xjDxLDvlGtfFBBG4cS6Zlaobc7SPYopMQjJ1bXSFNGCgfZ6S0ixO4cGotcwn0MrBBPZ/WQkoFDd4SNF9SG6qluu10FyXYxFqldUIzmdgfTpfpmiRH3viu1JT8Dq6pXUkxGpldqn3YeVKQQmtCBVglJXfKWOovhotZLWR+kkDQmIfJXTjAardgCSWlxFOhq+XaWrbp2FRul/5Us6laqoo67kYx2tdtI9F67KURomsvqv/qVXzxLAFReeszJYXuzEhg9LzHhyoiRV2Hk0LIqrhYmOrzBBaI8Q3sgXUges2TRtEF61f+iMatZ80JJgV+5ao+ws4D6a3VCm3fuSVD3TcRpzROpKkSgoCq+iUFLNpFP3aWdS0SuZUAQSM9qCxIgTW+E+Ziuxpn7JBKFc11nniRC182uol0wvHaU6pmoqI/Ry7ehJP51S7+uenBQdnzK3ILdg7mRVFEqalevm4Mgn0ei2dRfHwCDo3L2pdl4N9Sp6U+2sUpll5YzDhqFWNh3SS+snVCqetOdPJ7Kejv9P41I2utNq8jG+qVxOl1HLGm6/wF85FnRnEZzsmv2YRNsASWqTjZzp+Dq5VsIdIJSUcD5RGbdYqyiUlKWy7pWrEOUN6TW7hUGg7jwrV8nlCJTRG6UV7gGiqCVuR+9eSwyve8Y4TuMnDrCmtk/KakxuFQxqRmA4LgAfDfJobpREgbq9KCZdPjyT9p5RmZkOfwixNjHy3GaIRu21aKKk6OKqCiW1xFwkqR/aqVT0ymp4ddGqGhpNia1YYimFUWCBODZMS+nkhVVQTdWvfFAtGpLqupEPNlWFilqubipaarlOUk3VEx8PAQhxUObpDIklJoX9U66ijAlTVSppFCmFKg290GDD0iynedFy84DlYxRTTb8Selle8tHYFeqVkBuvhdHqX7cXUOk3NDTvIjpiVan0zkofk7rWSY+VqQ1c82U642SGR1kLzsTnrbdUJqczyuQZZuQ9rTxja1mzB408anpfdxdEikZVoyX2I11PqWwabbV/xD07cp4E3F7G9cN1up1Ob4DhGPEP+af7MkPNsYLyqlVF2+tuPiUV2S2IMlxxnbGibRpNqK1+e6Zh7UzfB+6EankJSlk9L1VULzlVtMq7uWWD2IqcMAkiw3TdwDLhvzTzaoPwyht1pcRUNeuKPSv3typa5dUTIlRVnh0uRgOz7LRczdReSA21iluz3rJqgzDpkQZFSJrOEKMk0hspNSQ773z7xXWbWkerJK5W1VqkcveLoqW5IrvAtqOn6VRliEdVTc6o5nWZKJK0TonQAH3gaX2vuzkiEopaIzEaaY9EkfQS1wKe1jeNLqX/QgbwXGfdfx1jcAYS4CnaKMHEcCutqhiUYQIKsrxULVKiYChOoBonkIRTzWVZGmrPi7FNtEq8OwprT7+ugdSLFbcoomAozjCSn1+GwkkUDMWZ5VJVC7XUMRStmt1ZCqzwDuzwkDGyRhrZXkJmF5xBrKJCxkijFKnVKx4eCyc6zR+a8o+y1eFW9AzOs6rcwrSSoVZWlKGUsrCkBKW4EciPVVxrZX3CEDfrrppEqnS9lZNHFUqKTG+T+or7r4qSoXjh1ClWcYKSwltRMrw2KEj6WqsLEnK+EjnGFvggUpBMvIG4qknGvEQp4H5RXtvmJWqh9ozA0IZWyzDcUCVlTqUUcs/VX+acSilQokACTi1VgdYjYyaoFC5RIGEmaG3kxzWhoJY6JM1bVaMlOuSg1TOyNXXJmXUrBS181lXDCnKZAqD/MvLgyX3skkPv8juRkl++A1DRNDRjMU6aoMbXYOOW5HQQaUoGbzZwKaM4keWqyE7Fhp2rkgEbjmAG8FNPVx2n9EkioA+6LNCKBnw2bkkjfyktSpQ5g60MaJ0SicTpWpFD08mFUiuPjlYSg6FXMv3ogc9UKJeCppbRpVdSddLaJuS2BJUefxeFPq7/4BvTQ49L0F6c7B2+irnI8SZamTSXUQ9wKZvpVT9OD+yeWVBaPS49qGVstNNOkB7cpTIljoo2Eg21Eh0VnSQkQtdqf0Gry1yY4XmlkecmDDlGomYSVryb2X+hJ02cwRfCIHTDDURvTzLrChElq5ZAcfPMQnNEdE7EzytqJJx5zaVJcpb2gZZ2UFcTblrTqzmf26cR78zI/mFGoE9LHnqDOQuwnkY4brARQFnoYup0ri9YgTTPJzdzfh6cTT0fD4ji130VAJGQ1E45rUfmZ0TxP0ez7f5lvfTWAbRUd8ZoqT0A1jfi0X9Y2hjCwAiWmdnKaoZ/zhsjrWCoX5lJI+FKB85kOWDXFb2ao7Z1Bv27EraVSF/R0CGnfIeFZeRALBqG8RXEM/Gel6fGxjXjnRHv0sQOfowYJpcRtrcJjyxryUv2yVYjr4MgwydDRxEptZVly297T0h6eSsjuziTqhXSupeOWpFHFhWuFX1nfBpqxURdN5xjV8xz+xD089qufctNbZ5PWwR4h2EU4Eo6aIzP0gpvLcsYsPOEhcyRKeaE17yAN69pGDS4o5Bt557hhQOOH3eCpRUo89Qa91gyI9kgjIBlJsA2TNcxYzBg9saguU8RN11WFUJ7ofDxgJNzDMRN0YMwDr7K0Aqxx/2FGsLkb9gFBs8DnFYGPFrsIOuhQInyLUek9kWGLjZY3vGxXGRVqfuRKRqk2h43lpGJc+o6/ndgw0cb040ByxxR8FdgJXPySZ1YTfAayRMVXXy0RziCsBNHzSgOJmpB0cVHe4RHwLQ9MPNsMfGVz/YouPz16svjQ64An2xAnTTqHqIUMLXukYgC0pNC7CcOPOM2Yd+Zye7nAt/7OfW89o2TtSP0q1ajMFR1fRbb39v28j7imGTzB8d1YEP/bK7j+dWn++Plza/Lk6JJD1bXtk8hjweRjvz9HkLbFyzkIczDwVpuYH2nEgOp1oGmxj10MPp2OVJKj1GOPHOIvN4L9fJKrRHmVH6FyEIPKq51RAla2lNkoVrMPgUUoAbFRqpo6Nkw996Skd6tgijyAwP+HaAEojaI1ZRvEa9OnuTa6Uf55enA+UEUpWGiuN409citPd184NReha5qLmnptakSskw+dEZ+P+VKeha41OVS+SSrSaDUSVfTWGr5OJQqUMOgkpyAIdwzrSj4CDZoSIcOUDkz+nj1y9dfjatPNyIfFROLX5bLxaej0+PV9c3JuYiEh8/Gh9uPV/Cvm7vbL3A6ZTz85eHx6gbPxp5MN8VLgvggoqDYX24v7z8aXy5vrihZ/+t/0iD591/uP54sFkeX2U+9JN9f/Ykh+HKxFJf5G5T358v7KyL549Wny6+fH437T8Yvl18+GksIdYC4h693d7f3jw/GUS5RhrDe4D79563x6f7qPyjjHV8s8P9kl/HR+dkHBWV81EtmraJ/+Hz74f8aN5dfLn+9uqfUUJM9YSWF/MvHy8+3vxp391cP8OdhYD9e/en6w5Vxd3V/fffb1f3lZwowmSdUL00PUnZzaXz47fLLl6uammr+haEKWIavuPLDFPx6d31LSc4Ceg8R+dslLtyb2y+UYHRQOz+/PFR8A3V+32S46M/Q5A3R6E7IcNFwwLh//NAQnh28Hyb++svj1f3917tHZm1pONYiyj7cPFw/GF9gqzL+dH3/+BW1qCFfG79dXX68ujc+XX9mdYbZ7oIPm6nx5ERJijIgyujEbq5ubu//wjQP7esO7Ctv72lWFt5oHuRnfL66unu8vqmhrqb/bIiH0/HIjF4+UWvKW4tVy5ivcr/IcnaYL/oBrOeMl5MgcG9DYgP0wzVe5y6ezlJrhn6C3SnK/Q1fCvDzrtdmVpjWCyEBz4fe8bEuBJsagk34dHoYh9rUu4GZGObaqfU2EWsvgwdBvpfbDaDY8Y2BlaK9uMAGFIJs/6IXArzjsUd/9g75zwPOpkGp/0OxKZUmwRb48+xNtIA7czWZBsX3w0u60Ebov7EsAwnisM3EHBuDb/qBYRmww5CGAIXR9NZ7IRSvqcAgUFUVaBcsg8BzEmMTwV7aCAPsKYxVGQIDPFsgHLVCBkaUJM4YFUEFezH9IzHP97dvzBC7DOOUvGXEienbeISseg5HrFUiFfqfn1sQ/Nu/HZ3pwfDDjHzH38Yz03VHKoYCAnhOInNsECGwTT9xLNqVazlxobRAoDOF98DisaCgNzznb3g3mp6HOH/T0EmoUC/qMOH0ny54AnTjsMHGTN2EG4RnfgfY4zQjb4aO0SVmtAVJHUXLa425zaEHn/zUY4YzEEeyS711DQl5pgdAfYp16MEnP5GJ1qF9tNIGhDnZgnDQ80P4/CehiVdDTTlG7EVUvto2oB3Gif2TyKjWoQMFMeAGhA4vto1xGSihgU4yLJb7c7jxg8Ps6WigWnxCDK36O711K3fZjLZ5PuyUPIGRSaLdNEITsVg+kht11+rwz/iJfkOpR9TLPk2/7/DP5NmINlKKSsROrX7Q4a2UXkDUQqrxiNimfUXrcIN+d1j+Tr+htIITsVr3euThJv/9qNYbBaRQu+xeRTvcoBcO8QuHxQsjNNdxYAq14pZp1uF2lGarFI2IXdpWig/hbAdY8U/o9zP8zzHspAMde7mg5bX2TaBhez8DUWE7TchKhbuc/Wx4Zlhzc9y3hzdm+NMf/uX26+Pd10fj4/X9v87/8C9397f/5+rDIzrS9K8z/BUn4OyE4MyxwYzsxtWxkkM6QUh7FGATHS+97fJkvVwuNugMn+Mxz/ANM5QTt4U4wII/O3FSCKesdPgjgnaCvSsABvz2TfWhB13qwGo8ttiPI5A/b7nF2IEETQzdhHEQho/D1uoaQuelaQWNvgvi5PVaXZw47BxnseOa6xjX9Ng5Xmadpp3MsoMm9jp1XBvv2c+2fjormuTaJLcSK/apiCvfnWUvwN5r45rbtgAIU7Cf6loLv0ZTtcPoxzOsvlsP+ImU6tujFOFYKFCO5O28JH8vRzXlSPX9rvvkvc5uSKH5/5MYBGJRNgbUHUc51m/lLKOadLjqUwbL8N7HhttnQCwIcQ2J1FYl7EwR5VmQ7EDkQnISye/9sjWuV5c2D8QxtMKhC/xtsvuJdcNA0/glZPbq+78bvrXPaz2W1q9hPsMfCpGHP5xkd4gbvYpu5dVAV+dzi4qznMhKXTOyQQh8G/jWS/+TLNNh5cM5nN1YuxA7gzLEo5ZApfTOBYvofR4ApXjy5v0fnz0XfZLFkIIfHc0WWAiUFtiOv4WPvj5+Ojz/dvDHUlC+6FEG5bdmXmCnsMnFIEnD2Qd8SeYue+0O2vwXTAIHuzHWZgQ8kJjuDJ/mh1KgvBBEycuDBf8LxRWLKvUCCaEobI+HBIQ/Q0LUzyMQHU5xrh4kOd3zAJIEn8SaIsbUIqYcXkka2R6yxdK2br7++ix28bmTpDu8YS3Y0cyKUFIuFO8E/RMjRjUTWrxoit9YgZBaBnvOuFwaq3ro+LgTGlB7Dt4ekDVX4/729vHg3cHfvx3cX32+fLz+05VR/dW3g3fQprNvB/+A3zxc39x9vv5w/fgX4+Hx68frW+Pm9uPXz1cPUMB/QQnEzldZWCjYtb/7r/9+i0JmecETsOGPuH9/W7z4EKSRVb6XscQacyu8u7nBD99AU/rxO/L0J8jhYJck4bv5/MePH3nHDfvweRzP8/oL8HUp+GZZ/t9IYaOHjo1/FrEu+iy0PUrOz9ik/htyhR2VdPwmNJMERJnC2f9Gf8/Je0U9yZn9/O2gNAjkjuT+4+0/iTEFhp/fbSto238qq+ZJSPKQankPvsO6yO8a0fRbXqJukhtBbDmuayY45g/H+wladmt7EweFZP8u292NfwTtLxRxpQzbsi2e94CXtr2WR50hIU2MJ1ir2t6lb6VyvhWBLTol0fZya3CVti9w5E1guMBGfxatrxV3UStvTKbVpdaHDNTrbm35vnUWzPHw4fPlLzji5NvyV/ePVwbsv8PARyvnpJha9rsrvykaKXF2i4wd9DtWLtmwTGi+YFtTgNpBGZcACkFnfSH8piT2aw1p4Akp25m+TZZgu37d+LpobNkbDBiNN9plZC07aysdxPa8v0d+x4uVhtihnvnWtJriI/BQJCDwT9IY4Z8Zcd4d9LvJWJqouIG2RccLJ2luKnAuv+0rH70tAim/LYITv63EQH5biSz8toyq+5aKCfwW3SKCtdKxnOTFiO3vxnKxXM1Ws4VgApxhgvK8NMJSOrMWDZNWGQh4pShKiSEHwZBULR0IuELg9/meRFnv82kltL3g59Uo6mKftiVk6CulloNCTMy+tAli0uiA/B3fCucklSZLBi46fSe3uF5ZBmVLpzNAcksXC0henEI0TMsLhWj0VrS3vsrRs4YW3dfOpGlK9nVscjRZ3r4OSI4etDigRxF83d8EenTBaRp01fAR6mDfGCZJZejuc6XkKAKaKkbmVmhRtYEdoJ6KsQ2tSE91x26sLkVGGGgqqt1GV1HtNs96FDlLPTXCMTX1tI5lWjugRdV38BJb5j5fXY4uFMtSm6Lntaln3MiVoSVMx9fkMLkAr3nr0aWtx3B19Rie6bjr4FmPrtDcrXW5t16sp4fynvRMQELL1zMshpGehgv1GLGz9U1Xjz7oQpuJtQtNW486oLNpxZo86RiOkRuxZYkBqnRNUPWNIKm+IUTfnOfJNvWU0w9bcEmspyLqcqtKhR45tKBQR5YOwyi4KVCVbQzN4wRWuDSsqJK/ApirqpPqpakzu1XjaT/DVRITomXdOAZ9G2VNUhJ4Ts9WR0ta793x4hKDbGRYLmTobOCsLdm/7cEpFv0kSRLPNhCnrKhnm6XlAD/t6Q3TcmJ0yUeKoMRMUilVPU4ix+/ZW1OSHOlVi+xRkMY4pOsodjvw8TYU/dGTIS8rThmCskKQIQktjrhuz12dRorL6rm/fmVJiSQgS5GDUNbSTJKzUuTRMLSdogc5A90ayh0EA99sNnvvJbTqcZRYKS/ZimhZZVsRzTTPED1FKsvYHbB8XhVG0HIcKekWVkmLCMXBnwZBo6WVR99kCCWMkTQJhPN+rITYS2iZZRX6n0PcOUrQgL3YmpyeYzclpfd+bV0K9rlMGQYa4gbWBPX13BpiDHwXqq8TTonrvRFKSxkw5WcIkld6/XtASkzvJd26FHnMei+WUlIi00PBEyVIGrI+VxcEZ9jSBElsKwMW6yg5fGfz9kpCjs/wPhONTsU4MGBgInIQmuFSgBwpWa80XFB/14cSg3qR4VJQwx8uhbSy4YKyRtFLTi1FevnjoBX4fVIHdcE14dCtQzkcezs/bHFDRlO2xP7DIFte/1MEbHm9B7NWcXiBS6rQIQNcq0RZtZySqKCGE8Fxuh4yPLfKViJx2MhfkUwmcJWmObS7q0jsP7aw5eGmKVFe7+GGLY60IrkSe7suXRIrlV2u7N4S4ZQfb1BRt5+LjYHqw35Vnl8+z22lHkocdSzy9XJKvsRSYMnPCnypXA3HNS05SpQRcpqGk1/4dSU5o2GaKnf/y/0FOmyAUgW9F3BY8ovdjFrcg6FlvkcHipkgSUVe5Lio44qirOzxvv1z7337FmXZj1VtlVkHdhvUqPXMikq0myDZiHR1wxaUUtfY8nvPKbik958CcYnvff6dS3pZnbQoMZKXsO+xkxZVdKvPqpLMqkrL7+0Dc0nv77Jzia8U9jAlZZiN6oasFOeqKruymynFseqWPXCS067EqcUlQSEPhrY3LCVKw4QqCBOdccBXk334lvHkREmqRhOKMVL/hWw9pIgavxh2LGWfPkc6MRKLpbAb+VmN1EFrfHuFZ4FaDSpck2wdqWz4jhqTl2JR+7ajJ1XSJRokb1K5PYa1oBapuTnUCB+yULZXeASy3Luoog8diluV0I1IjY50sI3oCHBFjBXq6bBayaOBRJ5ToMhpakqAn5Awdxyhd8SU5hFiaPvJLCGmBsN+8U0P+gIRQJ9lB03Vaw1R2FQ9avJzNOq1kaqoQ1Gek126qnqtV1DHGw1LRgEhI5lOGeoJ/lvCUnGbVMJAvvAwCiwQx4Zp9T/xXZef16HCJFIMXZeam0S68JpJJMp3pBdoHo20vKOQP5Es2VEhujiJX0geaOx2yeTwQu/tM24dQ/bouJWoMJZTUzKslFMbuOZLXi2zn6RIJAYhEgeZgCXRQPHcVh6OR/cwoSiXRUjaB/zjFINcvrog5TwZL16LUctArWVminkj3cRkTN+dyEOb0f/74O2BFYQOsD85LohJpogi/QZ57W2RpuLOTHbYcqLx3IPI2Tq+6RYC8FNyOhY+OHqLZaL5HvxpeXG6OD47O1niWjEATjNcvBiQo4vV6vhidbE8FkfCDJUujOBkcX50sVyc9TAFHhXaQrqLoThcLo5PluenZyfnPYokqMflF1R+dn50drw8XR2J6+5ISSAG4uzo7Oj0eHG6EMfAEblf0CBHq7Oj1cnx2cmZOJruRAeCQC5Ol2ero+Nlj5JpycggCGB1vDxbnJ6fnwwzRCOTg2iBnF0slhd9KihvpgZBQMfnq4uLo+Upt106cg6Iqb44Wy5g3Ty/ENUcd+QmEINwvFwdLU8uTk9FITCzKgj2ExcnpxewcfahX+mw66H/BYet87Pl2cni9Fi4+NtQ9KqEpyewXVwccbeKtlD7Pdrj0cXFxQp2kKuG7tyFbCgvossL2np1enIGm/+KX1U1aL2YshXs6U7h7K5p0i5a/QoPdh4r6IM1G1E3rZ795+nZ8fHZUbPVtCmjo/oLttHVMXSozhlttE0bnYhAUNvpyfJisWh6kG3KKrkLBKsirPCw3Z+vhjspQzylk9UStvuTHiD2Z00SHAguTs9ha1kKDwRxW+aaPsVyeHRxtFicnPcYkFpx9GplJ0fQHuews+oBg5WCR3Amgzz444vzPkZoyd8jBuB8uTo5PT9ZclfM/SmGRCvC4uJ8sTo6X/QZl7szCAn2FCcXS+ghnveqkVypkkQtA12Fk9NTONGTD6iXgRaLI/jn+ELYeWkm3xKe3MGuYnm+vBCd0zCz84k6jqenq5PF8liYdteqW4/py2q5PD49OudebeBIXibcaaPZ/gq22MG9ZT8THB2fQMdydYIX6ZrJXe/ub++u7h+vcX7XvxPvq1xHxBr+jlYEY/MJ2A9JYH3/kxk55hr2XujxO/QXegH97wC3Ftf9HGSRr/LH7/J/oPr8bv7h3fxrDAHP49RKkzlZEYWE0XUFLCCem5G1c57A/Gl1iLKSHz6tZsvZ4hBW6PlDsU3xkKS2Exyu5nESQ8zotL5vz3Nlb/N/hN+315lcbDQ2qDkXrIbsF2BGDYlo56SJAnYnt2HTJuxIjo3P7cCKx7UrRNBAla36PtjfW6G1bCo1JBGEEP64LEscudp/ZH+hZvYxW1P4vVX83ip+bxVZq/hHJc/4w+3X+w94JMF50etZ0dk50aMyH3pX2vkIb1plGdnzrOmZd1D89k2WJz7/Ld+u0ps0cn7KrXgFDXn78SoP6GrgiK6lbVbz2vA4F9rAmnPirG03qUFYU9KOrX3/Rxawdg0dqFjbYtIAsYS3Y2nbHZIFp01+OyLWrogsNCzZXUha94nkAWpVwYeL3rZRAYvW0I5q3x6fLGz79HQg5NlokgaTR1lHr0rvGEvrR2mx3KWpvBh5MO1ZG5WFbI+aFnzNpQcpeJpic/3v55lDwXYvyEyc8i+oF8rViso7NU6NZYxhlHgWSirWpfnVoNU3aeUgq0vdN27W92nloGgV3wKnuWcrB0dTbld/xVhykmYOpvSOAbJt40IaoFYNoqBkWqlVQzuoxp6GNDANybwgZBZTQzLH4FLZX5GGgyVcAIpMk7CEc0Bp7rjIR9TUwQuMtQOjCB9LVW+Y6szIUsU1T1ZjwzYFgpBk2qtNQQuk2qaWHBg1oS2q64eB5OiuS+XzK9sW/1r9TOoCRs3VZL5IvdN4K8taVHun8VYlqVHj1cbLRdYjxqtNyfi8PfPNeh1mpWmiio5n3ROyMP15OMd2P12cA7CyjszV6eoCPmy53NI7idScgxUjI9R0SDHAsTg1phatxU2ye/GUd3tWs/Htsz/zGkfRl/nhTMsLJ0qswCZGiDG2TIVPfVTioLNOSfbXKRIqwIlSyoIHT5RSBk6IEgllP0VCBJoQnTz24xT55NjECEEd/iaYLKcSnhgtKg/TZNk1UIqRDF13stQINiFCYLqdBejRWZQBwSbJqEAnRGoTk5zDU+RUgBOitA2taLK9egFOkJIz2ULKsQkTMsJgus2JAihEbbeZcIsqwAlSep4wo2dxQiQW8BT5EGhidMzpurE5NjFClmntwGQpFeiESH0HKE+uP1VWFXhCtPJMQ1PklGMTJvS8Nic7zaji60UM7dE7/nSXj1g4xYiCIuDXJPmV8MRoTdmzcHt5Fu6EPQu3j2fhmY67Dp6nyqkCT4xWaO7WE16greITIxZP1nMi0MToPE12k4NAE6ITWv5kZ4g5NjFC0WRHXQJNlI4RO1vfdKdMqwpRiF5sRWZi7ULTnio7GqEYOTDxsYoCKEZtugvPcY+F5zKv6SQZFehESU14d7REJ0Rq0tOOfpOOdNKzjrTftGPSOzn9NnKebHOyrSnHJkToh804kD8RQjk2HkIeuZk2MS5VWH3O0E2KDQud0CG6ll8wH7Mf1m9Ko1QN+458Or7FPOpJnyo2k8Bz9LXtDHoeAr1U3rRn436Ro69PpVESzfshWoGNchuacexsnOyC/0iQW5DspeBMh0MrlP3lAPxU31oSbfhc9X6QkBbQ6CbUGl6hnKdW48QwY1XkXDkX0NBh3drSBrVQzwM20jdo14FGLQNz48pJEjm+Pj+Jhlkq5wDqOvFYbanQzWNPM0n1LWbV7ZkrrwNt809ofwJEkR8Y8G8cBgWnYth3kYTtgtR92Lpc3fZpAMAWY8JiFLGAb9e8OxRxuWhZZ63rXgmxCskAUyrn69OMStrXEeDWIXD3cePALZVzAEUnKKDasaBW1PN2yCMhzXVz9XM8Ey6SHGnfjIuKybS/d2S3fkazokI9MSMrqDJsnhWKglC0NSYu5sy4MctofJpn1xqdVhc4Dm4tXxvxcqqFVoEnzG+CnHrWwalWv941b7qVrqu+ta+h9fAs2X3UuKWcz8GYuMTb3/TIcPJwJkiEgUmyw0/CyEl3EYhcDF97k6dJ5W2+DomnbpNv0LnaSZEggAQo4Hsrk+KQIxIgEYLICXcgMt1pUaFxqR9EqKqsu6OqWYJ0uXVIgq1rUiQ6jtF3ta5Jcei6p9YWrVTjNSEuDh2Xg/Z3EJNiQuPqRchIXkKNS5GCtEp0/Xs/3HewFnG7O8BsH/x5qzHSTYtxMgL13pDG1988sFcSsQ26nj/CdKtmEohizsI0wAxYlFA1qVRTNNWbTH0hVNgNqoFUjeePZnqS9k0YwbLH6q4QgPpgUsUkMiqSCNtTo9Ia04G3IQlO5coA6OP1KtgWtOtdh9WjZCdIqEQlu9WXAWglTvZLofoNWeouDEnD4Vr7oQPzonT1Y7iQDS7twLjqeeVbNJy4o6xjdBYQhUvDxLlSNcYs3bw/p+FIbuu4ukRpmPC3+HY70qHrGzFAmQa3vNiJDR+yN56cKElHaFING2DTm2iLlglOOBYlXb8a6iZCuA2acu/BmaRJ8s6V0yYc5az9lMk+ct0QZfc0JLC1PJcil6jfnkRxYcYKEK6aQacmmQz+Ch4hGhFIzGgLEiNO7BF2EFrpNHEJ0YJfuc66yGsyFVYNWEKk0klVuLRPdYMekR09TYdEiUe9c1p0NdoHyJx97ipUgHDNnqaC3BGF3ugep2L6PQEuOfu1ybBpwBLv1ybDJeUvF2daHBhwxEiQ3nA6NEpAkj1aOvedPL+Wlqt9nKPV56NdExRP86ylB7Rf4K/gZDoCSFl2OW6K9NqAcrWERkpEfBlsEjQ7wPUozdy9nga3LnQ9yk17B8ZVYLzDYs0WYRDoPw3FVUo5sp6kJtW69gDs1cK2k+0iS2zqZz3TaprE2ZPSMokVp8iogq3PuAf7X+AnJKkzShs+DZJ8OGVfmXRRmMlm8Iv+LiKUNs6lKqK86BSqQLjqf/4BKYfJEKjg4avu9Q91V2+aCBsQd4mEUWCBODZMaxSnnFUoTUgaBpqiOo9VmnlXXAXSq11NhYCE2jgFKk1I0scIAEIckE7eMFHKHKFF56rLG85VMFx9bPnJKFcdGxxYiHgqNf1VHkpxSkVSw9WDVJY9b3KcClg9KE2v5dCw1I+HlTY7YuMrYtZUwQh2IOPjr6ORPH6kNnDNF3ljRyZPe+3P1OY1vwTB03yztw0z8p5WnrG1rNnDBNDX8KhvtMRouis84U4aawliWD3niXRiR84Tw21qXGZYp1uZt5ehOCP+oe+8S0ZzjhWXB8IrKHRcKs3V6apdFOniikMFhYLD79bO9H3gyj38ToRqry2l6urR6goa3lPiZR5XA4IKLBNldJ0GmzZoeg6L57bU3SQqtqicFa+g4S1Z8onuqMxcPPbEZGZe0phMgTTgDGpro9PphCa5H0Z30+V1wFojWxD7IZ15J9Uex0J2h6Q1ykCVKaki7TEFBlUHF9h29CSvQkB5uutDRiGvEQQA16oE0gXGh0zjUF+VkSLNNZkQJnWZABAso1Eh0zjUT72A5zrrfTMvjoixwNO8gIiB45pdVb0nRih81fLScTASxfsRgrEQAm6Eeq+90CA7rrjUcWr1GiiUHf5CDSNKiTgKRKJ4P0KURW8UhETxfoRZrpRxQJa69+PUux9BwWzdc+C9Zsw/AugaPzN+OGp6RTXfCDAKRqs1mkcTITp3GJr6jjHUgVb0c+RvGc2qtPL9ltWc/4SyKnf6E1yd9UUBq7WjtgBf9TqqN0ELXT9587PAdyPT26T+SL1SRfl+pHAyEOs8LUMhrSjnKXuNaWRqJc+VRYa8aWyBDyKNicYaWKsI+Dz/UaC2x5lie/7jgOy4LcnGOeog2oDAOV8ZBWzHqh9jvjIKxNbc8QyEoxY8rZ9vfjUK0Nb06Iz5lc5szRTIrlzMLfPAsXAS3bw4xx2dmhh456+jwG09ddV75bMMwyknp2l2WFFfUy7x52vHFQT7cyXh0KN6R3M2Yu5hnbyvdZBkQ+YcLcnbrs7Y52zAOQQ+wHBcwClFx67LFA5u6OOD5oereWBlI+YeYcv3o0S7i9WKncYiRCFO15pdhk4WFBwRIpOAzwG6Evl6XOBMIKLgR24BXXi4K88k6r5ojR/Dd+4C3+VEy0zJWvGWdO0hVWiTQyQ0CAGXbVzInBuyVX9pXMAd8ZJb/J5x8fJt1tIux7iISxA9nYbR4TfgCDkNU4AvBHoSNm+xNO8yBOtRLe52GNbGgnoKHbz7tW/RIk0cjgsQUJnhBqxbNbVSIC+qtj9UMyd5lRGBOVE7r6jfe5ovf1exa7APKufBw5HR0giknzfcX913ZmT/MKN6muteN8Sy0JNphOO9GQH8Al0ykpgTO1A+yubmyE+HsimViefbBl3ZGW0D5esqnMzz7K+BWCKy3hW2+YC24DqAuOlMVb1qOJYj4SAutA0WpSi6UEa3LCz8c14dacX7x/XsfRK2SdEsgQNwHYCyI3J1jfKbFJstaTMN3bwlpCagDgfWtgA6im8ae8/LU2PjmvHOiHdpYgc/BoX+aoQSa4onU2qehCtsAeobDumWGbqLqE+tvFp+2+rOtY5eg4c1LWWhvKl0lEUe80i4LNr8VcGyUDbQ4lw+XePsh2DfGHvtW25q119qNv/DMApQye3rz7P0QlvLMhSsomLhc0RqTnDPC2DzmuY9HTkKYHHuGV6o4HhZJ0xaMfe4WjtdnJG1QRgBy0yAbZiuY8Yq8uQyyOwD0CDVrCBoXR4+VHBygoG3qZIDobKjp60AO86bUviSv2GHBTwrcEAY4Gh1HJZDQWH0WY1o68aFjp1a3vGxHlxVbfOhnX79x9qyTsPJuYKkbj9ezR8c14HIjc+IzwOC7lhO8rKar13H/26s4ZjpAUhwToTMWQrwu8NVFGKYShCAern0YrHrZDFYRSGGqSQCpu2BmWcPVVMRxFR0+evVl8cHCYoqgpiKUIzI4WWfSylUUIsYua6PYGOmLnQw38D2B1zqCfb0PuCNXGcN1SYvqEwj+2SxODLfLWbo/y4Xyzfo0dH5mVU8OoIfh9C9q3/rWekMDsMznGZ65qE80/if6F/r5XKxOTo9XjneyTn8PgkC19pBDnUhcDghvcUsjmebCPL4EUTfZ3Cc/yuw4GwfHcv3g0f4/Qf0fYYKSozt712y7O8z2O9Y8G8H/vvdcrFczVbwU+Po7PT4ZHF0ena0PD47OVmeXlysKt7Ye/CMux/7zkx2Pxdl+35OPS/ezkNewDL4+f28+lPe7VDlhJ++nxNy+KeDf/w/OjUd7Q===END_SIMPLICITY_STUDIO_METADATA