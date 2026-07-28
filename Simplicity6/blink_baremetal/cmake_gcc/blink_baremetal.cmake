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
    "${SDK_PATH}/platform_core/hardware/driver/configuration_over_swo/src/sl_cos.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_assert.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_core_cortexm.c"
    "${SDK_PATH}/platform_core/platform/common/src/sl_syscalls.c"
    "${SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c"
    "${SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c"
    "${SDK_PATH}/platform_core/platform/driver/debug/src/sl_debug_swo.c"
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
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/src/sl_memory_manager_region.c"
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
    "../autogen/sl_event_handler.c"
    "../autogen/sl_simple_led_instances.c"
    "../blink.c"
    "../main.c"
)

target_include_directories(slc PUBLIC
   "../config"
   "../autogen"
   "../."
    "${SDK_PATH}/platform_core/platform/Device/SiliconLabs/EFR32MG24/Include"
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
    "${SDK_PATH}/platform_core/platform/emlib/inc"
    "${SDK_PATH}/platform_core/platform/driver/gpio/inc"
    "${SDK_PATH}/platform_core/platform/peripheral/inc"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/inc"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/src"
    "${SDK_PATH}/platform_core/platform/service/interrupt_manager/inc/arm"
    "${SDK_PATH}/platform_core/platform/driver/leddrv/inc"
    "${SDK_PATH}/platform_core/platform/service/memory_manager/inc"
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
    "SL_CODE_COMPONENT_GPIO=gpio"
    "SL_CODE_COMPONENT_HAL_COMMON=hal_common"
    "SL_CODE_COMPONENT_HAL_GPIO=hal_gpio"
    "SL_CODE_COMPONENT_HAL_SYSRTC=hal_sysrtc"
    "SL_CODE_COMPONENT_INTERRUPT_MANAGER=interrupt_manager"
    "CMSIS_NVIC_VIRTUAL=1"
    "CMSIS_NVIC_VIRTUAL_HEADER_FILE=\"cmsis_nvic_virtual.h\""
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
    -fno-lto
    -Wl,--gc-sections
)

# BEGIN_SIMPLICITY_STUDIO_METADATA=eJztfQtz2ziW7l9JuaZu7d61HpZs2c4mPeW2lR7fa8dey+nZqc0WiyIhiRNS5PLh2NPV//0CIPgACVIECRDM3J7dpCOKOuf7Dg4OHgTP+e1odXv/eHd7ffv8N231/OXm9kF7vLlfHb0/+vDnV8f++vXdC/ADy91//Hp0Mp5+PYJXwN5wTWu/hZe+PH8aXXw9+vNPX79+9eGf/QfPd/8OjBDettcdAG+JjLHjmpENxgEII28cGdfufmNtx2vb2n/T1roPHBDq9nhrGFg8lOABP3xbGfC/UEAi8ShVAm+C//9h49om8DNNBpZbui+527JBdm9ga4btGt80R9/rW+BrbmBYtq2Hrq/FcsY7jGYL9sDXQ2DCH4V+BPBFhBxf2eh2AC9NWqkMfQAkKgtsALzQcoBMRoHleDbQbGCiP1OZtnN9mdZau7pvIvmh79oS9TjAcf231Ad8sIWdS6I+E7xYBtCsvRVqpmEaUlWto60WfHd7ogOcSGZDvc7OtI2tBzst2EWh6X7fayAKdD8UoPTDJA5excvW3rAjEzzq4Q5+jHwLYQkj03LfT0gcnCRhLpP5IfkuvfJOXvR+BrDHQ77i47cehS60ZrMAfvXL8vPzarS6u/p57JhY8Tqy7NDa59uh3Dh88cAEGz2yQ+xvY0OwlqfnpXbtOp67B/swIO4klISRSNcMHTaRu5WhBLwgBTt9b9rAl69AdCvQg5i1D0J9b4CgNz2iDYZDj4+uje0O/aJLhEo7spIQRW64h0HJhF6vOE7BG8dEkwWC/x/bIw1CK/xReHPgXmUZVvimBeY3bTadLcYLhLyieQo/R4PZxvUdPMGs+NGBn9b+quK3N3gi0+CXFb9fWZCzu7/T10FjIRWilp+e5rP7X2annIKqkLmRz8GMJZEOnCGcc0WeBjb+fOZsZ6ckNBd8XTe+wRk1mh3p+4k3wV5xNr0AYGGc6IuzxSW8SLV1+mkSt8UkZ9JJapNJTGfCRMEOyG04vgUhcFRTZIBow7AiVLVypts4vInzppTdejabbk7O5gvLOb0go3BP9iakJtVYhDlWqkLTDcdTTDPFIINeOpVSxy6GIIHcOvJ1RzW9FIQcgqExAIIxCAkEDSdSTY9AkEAO7SupZpdgkEEPItlvXOUMMxgySDo61BAYvuWFrq+cawmNDMqebSsnSjBIoAfUhxwgLeTEO7HK+aUoJFDcBL6hPOikICQQ3HqGr3zcSEFIIWgpb8AEgyR6mueq74YUEAlEd5sB9MQUhBSCrwPg9yqLnjVTHmYIBBnkdPWT7wSDDHqGbuyAcoIpCgkUv4G3wND3qjnmYEggacMpvWqGCQZJ9F7XuvKFUx6HRJrowbi1V7/lxsIjgzbA56iUs81gyCA5hFmOLXGWYw9glmPLm+U4umWv3VfVDHMwZJD09N16AJvheRwyaAbK53QEggxyL8ofRBEIEsh5xl75ejjBIIOer3zMJxDkkNMCa7vX7SGQzEORQDYwfD00dp5uquZKI5FBFQxkbKSAyCCqfss/kLblH8Dl6WarnF+KQg7FATwHz1BIoDiIhZTMZVQ0iHVUJHMhNYhnbzIfvb2YuvJemGCQQO+76SqPowkGcfQc8nKQImZ59fLOhSrhxkLR28FQzh81vr35jeX3TB3HrTr+3+D31t7gPrJdfJVED13HEh+jYmoTiHBCKeFrbdaLSCbQDFsPAmtjGXpoueIfd9DYKzR2JGL1z6RSZdc2AftI/DYa3QiJiq5QIXUgYcZR8PZUSXdvR3KlO3iiRABcz7IlzMpLgFM13SH74sf5Ily/xVjOeOkv1MNI/H4SDTZT0hQu77BaeuvKFzCIxT1O9LsuxDQQ4YRSIsLp0F8heHUkgy6q6uyE6NG+bQeSYefVCHfE9hM26ADdXraj8nZ0fd2Ov+dUOiSVTiT3jrq49iWmm1CqUi9l6m+1MmBMtErCtZ0u/rx2HcE6EEJYVsjXgpnqhszBkMBUITtpHqraOSX6pXqXbOuN7XYcui/YOSJ2Pz6TTGqZ+mX0cHW0hDGyFFJi6Jbq+V2XAyQv0+CmSAQXNqa0AEaTTyJYUbWYXkakopOsSugQxULJ4HdUlLBJNAul4wHf8nbAhwOyElK0/h97wKQ6kawAXLAmGVSKqoX3XyV0OhyBr++/Sth0ebutOrmghNeFGrHp8JJQk2CkhBOtXxI1LXzzJLyMwEkwQ6Ei5uI4xZsLqknYjZ/7vm4lZCWqMHBMpRiDaRwqTAxjp1j7ojQHEhfWBbNCbROWbiWmxCAEu2uuK6INg979lpBiB4cSoh9hPYd2CLou5oRPBtNcxrIDPlJUHKLzusXOOkhKY1WkWuXqEBMMhC/3s2zX8qMrtie9ACuql+InCqll2gcdw6x9CHw/8kJR21LtI1kxg2yjnKENXcNwAivQ9rB5tBfLDyOJM/2SRXEg0dFzYCaI3rNHFvtMCXDPpqmC8ENHWUupWZOnXwLs2thrpJ36OESzHsqgoy9d6GI4TwSYBTikNSytLWnVSgw/9mYtm5as0FAwLQm3lRgG3VkQcN1qfqZcfi+BaOSeKCJK0i6RVygmjKciiVP0TiWnV9AD6ZJoWZ2LpsRWLLCVPN81QBBouhHKjMashiqr/sGDcNqRZPtGEnHzCiX13L6p9OLlfZIqqx74eJjUrhvOkJhhkhifEhXpiWpKqaBRJFcZUOapxRIblmYx3YuWm7zBrqKZCvql0IsT1Stjl6qXQk5dD6PV/9izgFzc6KF7J28hUUqFB6v+mBS1DnqsjExg62/DGSdjPNJ6cCw+6b2ZMjHBKJan6b7zsnC0rWGMVz3yKOj9sUMQaRpZnZbYj4SeTNkw+mr7l9VM33rhmPYyntyvo6oi2I2FiHwiS4oCCw8IsaEmWEH2lDKn7cfuPhkV0T2IMlx6EiCnbRhdqMLC6MjncNxbytF10kBIduLY7Q6qD82npRwUzluLeHO7Y8E9O7INTNN/GY4rQzyyPDmmmvgyUSRo9ZjWVO4HPK3vx+6OiISk3kiMRvojUSS8xXsBT+sbRkhpP70Ejm2t288uO6f9AI6k7StMDPfSvIpOiTOgIFQ0USpSoqArTiAbJxCEM07bKBdqqqMrWimzOwpry3ldCSnK1i4VKFHQFSdK3i0VJ1HQFWec8lAu1ExHV7Ry9swpsNz74t1P74oaaUTPEmK7oNlBXoWIkUYq0lb1f5k4cSo3XfwBgyLcnJ7OeRulW5hW0tXKkjIeUhYWlPAQdwLxL18Welmb9yrLvisnMSPtt2LyMkJJvu5sor3k+JVT0hUvXDoFMs61UHhzSrp7g4QkkgVfEJBDksjRtmAPfAk5f0uI85pErEukAm732lrVukQu1JYp66vQ9jIMl1QJWVNJhdxy95e5ppIKtFWJLSbOXlyB1iNiJSgVbqs6UcyVoIyyMxTUtkVlKtetstESHWLQ9jOylXWJWXVLBc19AqmHHeQsp4HaEgjxUUTxQSTjlzwByGnqmogZZ4GQM9dg4xY06SDSpAzebOBCRnEiC1XTQ7UI+nIWSp8gAv1BFwVa0sjJxi1oCM2k+aG0WVUlA1qnQCJBtJY0M6jlQqkVR6dXEp2h53IA9QOfqVAshZ56Rp1eQe7Ua58Q2xNkTp3rKLSZQw+h3EhuOiT6UVnOXOScEK1M2NyrH+BCnkrnJhT9oBbx6JeeTfSDO1MmZcTvjURJrcARv08SAqH3an9Oq4vcKmhySzGk73Tf/K77TcryCH9JAtp9Y20jHxfT01woC519H85ZXMMVFjQTMyeHG9nUs8JTbWLowM61IhKCJkQNrZfWjJOf/re3blv/ZbH11i60VH0+V6ERAOtTeI4VtjaG0DFJTmy2zM3w56Qz0gq6DkmxNIgm9N2us8kGsIuKfphzY0UG7UMJ20okVpR0iGnfbplfGiDmzfTyA7wy6bzOzrSNrQc7LdhFoel+V5iJi5EZrAyPLC3FJRFlqxEXIMjwydCRJmOqZFnxbet3iHqoQl7RmMISyKr1CmHhpcYrkuRF3F7RZ9rZf46pG87dyzdzu3bbzdpu94YdmR0qsTojz3exk3Ya4+N0xVvD0Drs/mIhE2SKCeE1SeFNCho6De4oK8SFozleh7N0tWBpBdJmauX6ethIJvB8YOghMDXdtvSgSyUXBs1DihrTZblQ99rpDMRl0Z0wdj6XWwmxxWHcAsLwH3gKDF47TFoZ8GixnayHcrGItxyR2hYZLg/uzOdikeWlHkYmaZCqulwIiZ5HJqe2tf8GTHhpo9sB6LzrE+j4bV8of4L+kPrm4BVfnqyRNm0N5y4OCHV7QmAUjVUAi381BLgpkAOAEa2dergERiPrDgBuCuQAYB/opgPGjqkecg7KAdBXvyw/P68S0PgJMBpIUQj3I8BkckAiyktKOkU7ceAVxy3zUQ93P6X4Pkyo64XfWHGsQ1+VDe27fwdGOGGoqvtZYH6relRzg4umTFaWbcHWu9PXwWT56Wk+u/9ldpqGXXHqSGOjpVMLodV7P+IQVpc8lq0D7TK00MEYJsVIySbfYuTpXeS1fuYhrtVKSanEOwSjjKM0JWmVLXEasoPhwq2e5k4SJ7lwgEi8odkFd/rQ0zKUtOKDaisJb+5cfhvxPBhlOQQMRp12CsWTzKdYlyddjqMVst1KVSCHQS71J0O4oxu+ewM2KATDASubcN4sf/7yi7b8dM/zo3S+9vNsNv10cjZf3N6fXvBIWN1p1w83S/jX/ePDZzhL1VZ/Wz0v7/Ek90W3I7wbho/vcIr9+eHq6Ub7fHW/pGT9r/+J3PDff366OZ1OT67iT60kPy1/ZQi+ms74Zf4Fyvvr1dOSSL5Zfrr6cvesPX3Sfr76fKPNINQO4lZfHh8fnp5X2kkiUYSw1uA+/eeD9ulp+R+U8eaXU/w/0W18cnF+LaGNT1rJLDj69d3D9f/V7q8+w9XZE6WGmpxzK0nlXz1f3T38oj0+LVfwczewN8tfb6+X2uPy6fbxL8unqzsKcKmgbzdlvzzePlDy47SmXUT+5Qqb5v7hMyUYHQ6MF4bdxZdQJ4eFu4uGMfHp+bokPD6R2U387efn5dPTl8dnpicyqoQ2V3Z9v7pdaZ+h42i/3j49f0FO0+XX2l+WVzfLJ+3T7R2rv7OqbArppw9PtDoDP9/rNMbdLZePz7f3BWvnC7uUxMP1ja/7b5+obaKtwWp+5q2Nb2QNtMwb9y50QMbNoevaDx6xAfpwi7eu0qvjyBijT8YOV3WDN7n4et1tY8OLio0QgteRM5/3hWBTQLDxXs5GgdebetvVQ01fW4Uw4LO2J5sgSB6h1QNIH7QFwIjQIxDXBBSCeEuyFQK8iXlAf3wP+c/KgANMSKn/U7IxqUehuwX7SXwn2uwZ2z2ZBuUIwts/0Ebov4EoA3HiMPVQV41hr+9dzdBgwBCGAKXictYHIaS3ycDA4aoStHO2getYobbxYZTWPBcP4aqcwdXAqwE8pQ7pan4YWiocQQZ7Pv2KmCePrO51D08Z1LS8oQWhvjfxCJmfOZywdihk6H99rUDwb/92ct4Phu+6v7f222Cs27aiZkghgNfQ11WD8ICp70PLoKdyFQ9RpTYInEzBtZXrB6qgoDsc6x/4yRW9DrH+0UOQkKGed8KEC7vY4AXQncMEGz2yw8YgHP0bwDNO3XfG6PRSqPtbEBZRVNxWWtuMHHjlY4sVTkcc4S5y1gUk5Fo/AIpLrJEDr3wkC62RebLoDQhzsQXhoOsjeP0j18KrpCYbIw4iym6tGtBGQWh+5BnVanR4HgcgdL6raoyLQXENdIJhsaY/o83eHcVXlYGqmBNiaPnv+vWtZMqmVa3zYVByOEYmgXbrERqPxZKRXCtOrUZ/xVf6N5R8RK3sU573jf5Krim0kVRUPHaqnAeNHoREAV4LycbDY5vqHa3RBn03yr7r31C9guOxWv1+5GiTfK/UekpAcvXL+l200QbdMMI3jNIbFHRXNTC5enHFMmu0VdJtpaLhsUvVTvEIrnaAEXxE34/xP1XYqQ907O2CituqHwJ1e/bTERW204CslE6X48+ao3uFaY59PLrXvY9/+peHL8+PX561m9unf5386V8enx7+z/L6GR2n+dcx/lVDwPHptLFlgjF5GlfESg6IuB49owAbfz5ztrPT9Ww23aDzY5bDPD/G6ewlU1lB1bvlWPSdFYSpeGpBZoes4xuTDI/YJhWL8+AvkSeMtkbdENuNqm2/OHXBcVDtUgDLiJfDgzsMP/pPAuPrO+HuBNtjHFi2vg5wfAms+Szu6mY4js8kmevIsk18UmK83Ufj3DC21slLYznb5AQW7o5vGiPjjd1wB3wbku3TjJU5O+q0OSAIoBVGNthvw91H1hHKPoyO9rd4zJ6//w/DdzM8Gfgbmh2/iElMvrH1bVV2C3kjDvw12oYZ+d9fYazYOmAfKosVHLajLGeb/1y2K81QKk/dtBtcXuGHVOTouxXuRniElTEo/jDQ5TksrzjD8o3I1n0TeGBvgr3x1v5B/XBY7d0gNEtLM75H7F1CsgAqWXjnbKIPySvb6ZV3H/786tjoJ3FmEvijk/EUC4HSXNPab+GlL8+fRnAJ9udMULKmSw/+RsbYcc0IdrkAhJE3vsYn6B/j2x6hzX/GJArv04/xYWUoBcrzgB++rQz4XyguXTMWG8SDorA9ViHwfoKEqM8KiHanOJEPkhxeWIEwxAdNhogxMogpuztJMQkW2QuqCvPF28eBjR+rh/VJswrpGcaGj8otoFe/0T8xYuSZ0OJpV/zKSt1QMeg3zPbSo6t71h4HoQ7ec3R8RLaUtKeHh+ej90e/fT16Wt5dPd/+utTyX309eg9tOv569Dv8zer2/vHu9vr2+W/a6vnLze2Ddv9w8+VuuYIC/us3lCHEcV+ACX+DA/nx1yNi+WWc2gIG+/f/9d/Z5ZUb+UZ8NcltXU7EStpy9/XoOH8T9SaW5gaGZdt66PrN7g99ACrvxPmE2N/FO9TBd7f6hvQ9es00TKPJfQCXjGbeRr+VrPlgi57LVN1c+Spx1S9wThag2cBEf6aVt6Vvv+TuQO0Y+yX2kcRv39/f44vvoPPvg/fk6kfodUe7MPTeTybfv39Phlo46k6CYJJEHIDf34F3Zj32K+me6KJl4s/liHUdg2J1CPQ7z3QoQT/hXrB/R17oRZ0zeOfpYQj8WOP4f6O/J+S+tGsn1H7C5iEQIXkk9/fjrv6f7JTHGWFGq7urn3HamuPsq6fnpQZHdM/do7UFaaaKHfbcN2mXIuNPmpqZvsdIJGuGDs3nbgsK4C3gBX290/cm2TSs+7r065y3WXt0NAlyLwth3jUsf3sGDnq5G/yTeBz8MyaDhoW+G4yliYp7aFv01P4HMTeVdKrK9rlbjtO0cMdpCrPjXPa141yusOMs/9QxlZHrGB3OhV5pGVb4pgXmN202nS3Gi/GUM513N0FJlm1uKbU52LtJy0W7plIkJfgVg6BL4ukaBI0Serb5PckZ2eanuUSdnD/P54Tk+2lVetm2UgoZdfnEHEoCyyeNTi9a81sBxURES6cLvTSWzpfTLn3qremG43HRaK3oYEOK0bOGFj3kgMI0hYd6vBhNhnOoZ4rRgxZy/SiCt+83bj+6HB3qC/CRHfdQcBek0rMPzTHEKAI9OUZWpVq6qg0MgP04xtYz/H7cPamV3YsizXN7aqrdpq+m2m1e+1FkzfrxCEvvKdJahm7sQC+qvoG3wNAPTWLF6LJhVO9N0StcifeqDG1gWfueJkw2wDue/ejqLWLYfUUMR7fstfvajy5P3637mt46QT8RynnpZwHiGft+hkVU57gnPVpgbfe63Y8+OIXWQ2Pn6WY/6kCfXSvoaSZNikn3pKqvBWp/I0jU3xDS35rnxdT7aafvptuL71EvU8hU6JAHzBJ1xKl/tZSbBFXxE5NJEEKHi7ycKvE7gImqIqlWmnIFLQJbQwcU23aYgqTQdayWPYKWhF7U1wwbQrM2cCkUHt5kbygWfRIkqclDh4ay/JYdgZYD9lHLKSYtB51pilrOTShJlvB2JLvsxGW7OH+6X48P06B8OY4IeWieoNt2y4cApWod+SM97QxHiSQgM5FdUKbVLQK7w05ZXhiB1+Cxar2wXCEGKA5+6gSNlpYd/xAhlDBG0gQQTnwwg9hKaFYRBQ41XUYHSlCHxy4FOS1DEyWl9aOZohQ8EugiDNRlcCoIajuelMRo+Bxq2zGdEtf6mQctpcPsniFIXOu1j4CUmNa7N0Up4pi13hehpPi6g/JyCJDUZSleFAQn08IECewrHdbllJxm51MOSkIzue4xE41O6TjQYWAichCa7lKAGClxVOouqP3UhxKDokh3Kajjd5dCell3QXGnaCWnUDUt+9hps+2Q1E4huCAcTutQ3Y7Wkx+2uC6jKVti+2GQLa/14FMpDi+ThQrtMiBVShTllZRECR5JBAfRustwWilbisRuI3VOMllw5bpS1/CUk9h+LGDLax3O2eKI14uV2HpqUCcx55xiZbeWWF2vt/gmWDsXbS6/yYn4FkoseSySjTtKvsBWYMmPG3wmXU2DVwHEKJFGyCobTnzjF5UkjLppKpYYZrwtKVVB6w0Slvx0p7fwumfXNj+gA70qKkhF0uS4qYOcorjt8SOw19aPwCqUxR/z2nKzejzMy1Hr6DmV6OSzYCPS7oYtKMTX2PJbH/JrJL39EqOR+NZHSRtJz9ypFyVa+Oa1PY9YoYru9bEriXRVWj5yJXnS20+xG4nPNXYnJdU1zFmVK8VrgoxKX4jWQyxX+qLbw9lD+izRxBhl2qvSJAhVlLx0yVTUyXT5muzk3wIWDVVSCQPxwj3fhQN7oOlG+0MIrELylEmEGLooNTGJcOEFkwiUbwlv0CTBR/oYPr0iWLIlQ3TyYD6T3NHY1ZLJNnHrjZTGOrrs1jRWIsNYVkFJt1aOTGDrb4lbxp+ESCQGIRI7mYAlUUNvjy8c/Pb7akA5NdIsLyv88cdIqcHOojEYm3Jk2fvDtpy2/cOqMqzaJBPhj2LULJFRljFwUkoDOBjT1ydY/FGMPhhz1mVD7M2Y/310fGS4ngVMVFQ5IOkQ0xyT5LbjNBfjox7usN148xm6vrW19rqdCsBXyTEkeOHkGMsM4fgOP80uz6bz8/PTGW7tDnDK6RL5gJxcLhbzy8XlbM6PhJl8kBvB6fTi5HI2PW9hiuy4LyNJIh+K0Ww6P51dnJ2fXrRoEreYl5JT+fnFyfl8drY44dddk5KTD8T5yfnJ2Xx6NuXH0CAXJqdBThbnJ4vT+fnpOT+a+kSfnEAuz2bni5P5rEXLVGQk5QSwmM/Op2cXF6fdDFHKZMrbIOeX09llGwdtmvuUE9D8YnF5eTI7a2yXJlORFnaZns7OL84vTs94cTCyifLpvjyfTWEfubjk1VyXdZQPwny2OJmdXp5xk2fmS+WMV5enZ5cwSLShX5VQlXfshNFhcbq4aBykDmRk5ZxDnJ/OF4vFrLv2Nk1/Pl+cTGcX88bDdrN0s5wtcHEOrTA9m3NHgZp0tvxB4OwUhsfLk8bBsToxMPcweTGHyqeX3B2wmFm2hW7o/pcLOEQvSrqTNUtJeZpMlbOZF2en53AAWjRXlc/RyqdsAcfas+mMMdTV0WrnN3D4WsBVQLn16mm1HMHPzufz85NyvKxSRiex5QwPizmc0l8wonOVNjrvLqe2s9PZ5XRaXsNUKcul6uV0RejwMORcLKZ4aVnOu//49PC4fHq+xan3fyMtlq1+sYbf0Do20OECfxXCxdyvum/pa7g6RZffo7/QDeh/Rzgw2fadG79BnFx+n/wDxY73k+v3ky8BBDwJIiMKJ2QVD2McOm2FBQQT3Td21guYvCxGqGDM6GUxno2no9nFbLJK99ZXuCjlaDEJwgBiRoeN9uYkUXac/MP7tr2N5WKjsUFNGsEqyX4Dul+SiLb7yyjgFPLBK9ukokBm8eemawRq7QoRlFDFexUr81sltIonISVJBCGEr5ZlhiNR+3v8F+pmN/EM9I9e8Uev+KNXxL3i91wJmNXDl6drPJLgkjXFgjXscjV+VqqmriKQj7da42I5SUGbeC2cfvsuLuGTfNtsL/Rd5FsfEysuoSEfbpZJahcN53bJbLOYFIbHCde266QhzsImqRyEBSXV2JjbpqIwMYXXYKncQRUGqFJDTevR+6nC2osWW62/ak9VFJAq+dWIDu2wikJ2SE81wppdV1HgalTU4SrvwooDVJbdzEL0dqwMA9EaajyryfasMPdqoizBmlVyYw1VuZJ1KTPqBrpIHbmnwL+0AdyNaJMt5lxL0PwK0Irbw2KQFaUeioHFHWIxKCrFV8Ap7xaLwVGWWzcmMbaMhZmDKb0aTGnzWBiQkuSmIEQ6R0lyowkMtZUsDEuVAk5IItuoSkEFpMIusxgYBaEVqou7zGJ0F6U2GzCqVoiVAwh1tLQwhjBvpO4p3RUnuSzcU7orlwOzdGvp5jRJJuPWsmR8RIh5Z9GHWVk9qaZrsjiGLPT9xJtgu59NLwBYGCf64mxxCS9WHNttnXN00oAVI4HocEgxwLE4leYMlc1NksE2ae/qJLjq7XM4UW+Dpi8XjxogsRQbHyHG2DIUPsVRqQGdtBbWEAml4HgpxQltBkopBsdFiaRDGyIhAo2LTpLfYIh8Emx8hLJiZYPklMHjo1WqizZIdiWUfCRJJbZBUiPYuAiB4QYL0CJYZInjBskoRcdFKi1hN0ROKTguSmmtvCFSSsFxUrIG20gJNm5CafG/obJKAXJRSysNDpFWCo6T0uuAGb3yEyL5bobIh0Djo6MPdxqbYOMjlFaCHCSlFB0XqVzNySGyysHjopWUtxwipwQbN6GkjOZQSSX4WhHLl+wcMsE8Tj6iWZnQQfLL4PHRGvLMwm41s7AHPLOw28wscnUgh8gpB4+PVq6a6yB55fDxEQsGO3Mi0PjovAz2IQeBxkUnqYM7RD4JNj5C/mBHXQKNl06+rO9AaeUhctGjqwgPkR2NkI8cGPhYRQHkozbcjeegxcZzVmtjkIxSdLykBvx0NEPHRWrQy452i45o0KuOqN2yY9BPcto9yEnqcg+RUYKNi1BS/3uIhBJsTQjly34PiEseVpszdINiw0LHdYiu4gvmZfbF4ut0KPvkoSOf1t5gHvWkTxVnFcZ7MXhVefOyPcsH5ZmFrxWgrkBykEJl8e7+OVRCOdwOSU10BYZPVB8GmdVYVuHVqfImXp2UKFbiyInyRkA9i/VWSG9QU/VNwPr9jYhFoH7FqFd6nyPUw6i/nQ0aZqa8CLRqsCq89eA3GlzintDXiXhCkWTlzpQ3cxgtVxdDAdwihAYOhB6pQuWKAOfVN3KiJlMbkmD90NyGekX+8AstbG899Ho/8+VEWbZtUdOOOQctTTkq67opp1UHrgG3+iJ8ytnVw+PmN0BOLX1wqO7X2vOG63R1/la9Wm2yjGwUO9W2cm1xVv7+NzwyDXkwKscqJ8LA1NhDm01Q6TJy4qYIxSp9vZqyWeHAJr5NFwMcDgkCiINCUnFwOBwSRBwk6LqGw6FC45I/iBTLqaq0REWFV87eNSgSNQdW63rXoDjUvRFSlRqpxwP5jTjUHMM/HCAGxYTG1YpQVlF3iLQydO2jX1xwmzsA0qWxVRqnScXw9uaBUYnHNlkxb5UmqSow3sEMcaV0HlPUlVJXahyuou9yZv5opXd42s85MUlzBKoKVwhAcTDJY+IZFUk6v6FRqXx7umlH4lzKZXkf1UUVbAt66l2E1aJlB0goQyW415eqjnfp+3RGyFIGLqb52YXje7U9b1V77kxQtLcxC70PgHAVNOkRxRqkSZLd7oY2adDOvT8pPUSuHqLgSEPnMha3s8jMkdy7iWkUaXX7Kmzyt4TYqvvuVgWzkDBTiU2wyyFVulU+8dfe16A0Nc+3ifLUsfJAmgSj9AfE+IMhkMPT6KFM6Yd9uzRNhA2ocYt4vgsXfIGmG6GKqMVqlDKkHoJV6s6qWjOJTHkgrfrVUAgI8MYhUClDEj5GJBU6xA0TmUwFPTpRnZ43o8A0irG5qiUqTp2UOLAQNXFq+lfJ+2NDapICrhak4pShg+OUwmpBaXg9h4YlfzzM9VmFnS8580yB4Qwg6vEX0QgePyIT2PqbuLEjlte798dqE8/PQDTpvvHdmu47LwtH2xrGeDUA9AU88jstMVrfDk+4k86agejm500OnZu+9cKYNpWeK62jrciDZKTIU29dJKY5wYqzvfkcij7O9yTq+vIuinT6tCmHQnAYRcdTxDlJr4fbiKmQzsQ9qo+yifaMXg8a5ZkSn6g+VtTJHWxgmv6LOIeA8vr2h5hC4hEEQKPZcFpPSC1kGod8V0aKevZkQpj4MgHA2UZKIdM45A/5wLGt9aERv8FLjsDpeeGKgWPPzqs+8LIgvBUVsFCCkSg+jBCoQggaI4yTp6gBmeo+jLPXWQOFsma+UMCI8g8qgUgUH0aIUtYpQUgUH0YYJyZRAzLTfRhnv/tgFMzKva6mp4qajwB9jZ8xPzRu5lU3GwGUYKysncRAiBM96P09PisCzelvkM9FmVVp5Yct23M+FMqqjdOhYHfu70WAQj+qOuNf9NF+E7bQ/tk0Xwu819edTbRXFJVyyg8jhYuBoM+ntBTSnPImbd9jWplCyzfKKkPu1LZgD/wes3qVsOYRNJv5K4FafdScPfNXA7ImZSMbp9JBtASh4XpFCdiaXT/GekUJxMpE7QyEShue1t9sfaUEaGUucsb6qs/UyBTIusTHFetAVTiJ7qY41Y5OZQxN169K4FY+7W+985m9iScmgWh8SKa/rpzhT/aOcwgOJ03Dbx/2O5qzETce1sn9vQ6SbMgNR0tyN6qNgDJ2qnYNCkdj6OpBN4fb8zjFRtx4wMru98PeZyyV2GksXBSCaN3zCFzLgoLDQ2QQ8BuAzr1LrhY4EwgveMU9oA5PY+cZhO/zeryKqWgd+Lo5qcikvLnJR1+PZHK0yZkMGgTHDEgt5IbPN3ODuFq8zR4l0iO4WsQZiJZjsHL4JThcY/AQ4HOBHoTNKyzddJHMukSH1p3um991v5iYutVBYsh8Y20jHxdd0Fz4C3QWVWAWa1d62EnMkRzmYlPKUptXRSHROWhd6eu2hszTagB8qcNaO2z5Am3BtQtx07mlWnk4liPg3By0DRYl6SX0mG7WWPhz4o604sOBLr4f6gt9V9YspAHgIgBpJ1qKGsV3KTZb0mdKupu2kJz3rhtgrXrPWvILKc7r7Ezb2Hqw04JdFJru904ZIkoZJ8riyZS9SToktgD5HYeEZYbuNDlAJa+KbyvPu3PW++IY1nppC+ldpaYtklfjuduCN21V3wMtzrRVN85eu4fGWFJ37mD3H3m+i1ruUDyPk39tDUOTsEuDhU8QqbReXgpsUtB8IJCj9xwvHM3xJJwGqYVJK248rhYOA8ZkTeD5wNBDYGq6bemBjMy2DDKHAJRIlR1EXoUvBt6yygYIpZ0UqwRYczyMwhf+A09YwKuECQgDHK2ugeXQu8P9WY1oq8eFy10583k/uPLaJl2DfvEjFcQ8rzTJWUJSDzfLySouM6rdIT4rBN0yrPBtMVnb1v6btoZjpgMgwQkRMmEpwPd2V5GKYSpBAIrt0orFrpZFZxWpGKYSH+imA8aO2VVNThBT0dUvy8/PKwGKcoKYilAqoe5tn0hJVVCbGImuG7DRIxtOMN/B/gds6gqe6V3jB0XWGqoN31Cb+ubpdHqiv5+O0f9dTWfv0KWTi3MjvXQCf+zB6V3xt44RjeEwPMaJoce4ym5ab3c9m003J2fzheWcXsDfh65rGzvIoSgEDickWoyDYLzxIY/vrv9tDMf5vwMDrvbRKdq9+wx/f41+H6OCEgPzW50s89sYxh0D/m3Bf7+fTWeL8QL+VDs5P5ufTk/Ozk9m8/PT09nZ5eUiNxv7AF5x+DEf9XD3U9q2HybU9fRuEwSGb3moDX76MMl/SsIO1U746ocJIYc/Hf3+/wBKw4t+=END_SIMPLICITY_STUDIO_METADATA