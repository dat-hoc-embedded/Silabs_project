# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
	empty_20dBm
	VERSION 1.0
	LANGUAGES C CXX ASM
)

# Include the definition of the slc_empty_20dBm target,
# which contains the content of the SLC project
include(empty_20dBm.cmake)

add_executable(empty_20dBm
    # Add additional sources here
)

target_include_directories(empty_20dBm PUBLIC
    # Add additional include paths here
    
)

target_compile_definitions(empty_20dBm PUBLIC
    # Add additional macros here
)

target_compile_options(empty_20dBm PUBLIC
    # Set additional compiler flags here
)

target_link_options(empty_20dBm PUBLIC
    # Set additional linker flags here
)

# Link with the content defined in the SLC project
target_link_libraries(empty_20dBm PRIVATE
    slc_empty_20dBm
)

# Include managed project content if available
include(empty_20dBm_project.cmake OPTIONAL RESULT_VARIABLE managed_project)
if(managed_project)
    message(STATUS "Using managed project content from ${managed_project}")
endif()

# Force the gcc linker command
set_target_properties(empty_20dBm PROPERTIES LINKER_LANGUAGE C)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET empty_20dBm
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_SREC_CMD} "$<TARGET_FILE:empty_20dBm>" "$<TARGET_FILE_DIR:empty_20dBm>/$<TARGET_FILE_BASE_NAME:empty_20dBm>.s37"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_IHEX_CMD} "$<TARGET_FILE:empty_20dBm>" "$<TARGET_FILE_DIR:empty_20dBm>/$<TARGET_FILE_BASE_NAME:empty_20dBm>.hex"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_BIN_CMD}  "$<TARGET_FILE:empty_20dBm>" "$<TARGET_FILE_DIR:empty_20dBm>/$<TARGET_FILE_BASE_NAME:empty_20dBm>.bin" 
)

# Run post-build pipeline to perform additional post-processing
if(post_build_command)
add_custom_command(TARGET empty_20dBm
    POST_BUILD
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/..
    COMMAND ${post_build_command}
)
endif()