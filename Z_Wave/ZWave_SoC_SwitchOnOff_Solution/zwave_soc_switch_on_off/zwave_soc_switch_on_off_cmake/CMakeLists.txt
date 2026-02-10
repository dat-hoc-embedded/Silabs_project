# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
	zwave_soc_switch_on_off
	VERSION 1.0
	LANGUAGES C CXX ASM
)

# Include the definition of the slc_zwave_soc_switch_on_off target,
# which contains the content of the SLC project
include(zwave_soc_switch_on_off.cmake)

add_executable(zwave_soc_switch_on_off
    # Add additional sources here
)

target_include_directories(zwave_soc_switch_on_off PUBLIC
    # Add additional include paths here
)

target_compile_definitions(zwave_soc_switch_on_off PUBLIC
    # Add additional macros here
)

target_compile_options(zwave_soc_switch_on_off PUBLIC
    # Set additional compiler flags here
)

target_link_options(zwave_soc_switch_on_off PUBLIC
    # Set additional linker flags here
)

# Link with the content defined in the SLC project
target_link_libraries(zwave_soc_switch_on_off PRIVATE
    slc_zwave_soc_switch_on_off
)

# Include managed project content if available
include(zwave_soc_switch_on_off_project.cmake OPTIONAL RESULT_VARIABLE managed_project)
if(managed_project)
    message(STATUS "Using managed project content from ${managed_project}")
endif()

# Force the gcc linker command
set_target_properties(zwave_soc_switch_on_off PROPERTIES LINKER_LANGUAGE C)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET zwave_soc_switch_on_off
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_SREC_CMD} "$<TARGET_FILE:zwave_soc_switch_on_off>" "$<TARGET_FILE_DIR:zwave_soc_switch_on_off>/$<TARGET_FILE_BASE_NAME:zwave_soc_switch_on_off>.s37"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_IHEX_CMD} "$<TARGET_FILE:zwave_soc_switch_on_off>" "$<TARGET_FILE_DIR:zwave_soc_switch_on_off>/$<TARGET_FILE_BASE_NAME:zwave_soc_switch_on_off>.hex"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_BIN_CMD}  "$<TARGET_FILE:zwave_soc_switch_on_off>" "$<TARGET_FILE_DIR:zwave_soc_switch_on_off>/$<TARGET_FILE_BASE_NAME:zwave_soc_switch_on_off>.bin" 
)

# Run post-build pipeline to perform additional post-processing
if(post_build_command)
add_custom_command(TARGET zwave_soc_switch_on_off
    POST_BUILD
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/..
    COMMAND ${post_build_command}
)
endif()