# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
	bt_soc_empty_scanner
	VERSION 1.0
	LANGUAGES C CXX ASM
)

# Include the definition of the slc_bt_soc_empty_scanner target,
# which contains the content of the SLC project
include(bt_soc_empty_scanner.cmake)

add_executable(bt_soc_empty_scanner
    # Add additional sources here
)

target_include_directories(bt_soc_empty_scanner PUBLIC
    # Add additional include paths here
)

target_compile_definitions(bt_soc_empty_scanner PUBLIC
    # Add additional macros here
)

target_compile_options(bt_soc_empty_scanner PUBLIC
    # Set additional compiler flags here
)

target_link_options(bt_soc_empty_scanner PUBLIC
    # Set additional linker flags here
    -u _printf_float
)

# Link with the content defined in the SLC project
target_link_libraries(bt_soc_empty_scanner PRIVATE
    slc_bt_soc_empty_scanner
)

# Include managed project content if available
include(bt_soc_empty_scanner_project.cmake OPTIONAL RESULT_VARIABLE managed_project)
if(managed_project)
    message(STATUS "Using managed project content from ${managed_project}")
endif()

# Force the gcc linker command
set_target_properties(bt_soc_empty_scanner PROPERTIES LINKER_LANGUAGE C)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET bt_soc_empty_scanner
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_SREC_CMD} "$<TARGET_FILE:bt_soc_empty_scanner>" "$<TARGET_FILE_DIR:bt_soc_empty_scanner>/$<TARGET_FILE_BASE_NAME:bt_soc_empty_scanner>.s37"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_IHEX_CMD} "$<TARGET_FILE:bt_soc_empty_scanner>" "$<TARGET_FILE_DIR:bt_soc_empty_scanner>/$<TARGET_FILE_BASE_NAME:bt_soc_empty_scanner>.hex"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_BIN_CMD}  "$<TARGET_FILE:bt_soc_empty_scanner>" "$<TARGET_FILE_DIR:bt_soc_empty_scanner>/$<TARGET_FILE_BASE_NAME:bt_soc_empty_scanner>.bin" 
)

# Run post-build pipeline to perform additional post-processing
if(post_build_command)
add_custom_command(TARGET bt_soc_empty_scanner
    POST_BUILD
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/..
    COMMAND ${post_build_command}
)
endif()