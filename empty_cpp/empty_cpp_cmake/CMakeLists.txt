# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
	empty_cpp
	VERSION 1.0
	LANGUAGES C CXX ASM
)

# Include the definition of the slc_empty_cpp target,
# which contains the content of the SLC project
include(empty_cpp.cmake)

add_executable(empty_cpp
    # Add additional sources here
)

target_include_directories(empty_cpp PUBLIC
    # Add additional include paths here
)

target_compile_definitions(empty_cpp PUBLIC
    # Add additional macros here
)

target_compile_options(empty_cpp PUBLIC
    # Set additional compiler flags here
)

target_link_options(empty_cpp PUBLIC
    # Set additional linker flags here
)

# Link with the content defined in the SLC project
target_link_libraries(empty_cpp PRIVATE
    slc_empty_cpp
)

# Include managed project content if available
include(empty_cpp_project.cmake OPTIONAL RESULT_VARIABLE managed_project)
if(managed_project)
    message(STATUS "Using managed project content from ${managed_project}")
endif()

# Force the gcc linker command
set_target_properties(empty_cpp PROPERTIES LINKER_LANGUAGE C)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET empty_cpp
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_SREC_CMD} "$<TARGET_FILE:empty_cpp>" "$<TARGET_FILE_DIR:empty_cpp>/$<TARGET_FILE_BASE_NAME:empty_cpp>.s37"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_IHEX_CMD} "$<TARGET_FILE:empty_cpp>" "$<TARGET_FILE_DIR:empty_cpp>/$<TARGET_FILE_BASE_NAME:empty_cpp>.hex"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_BIN_CMD}  "$<TARGET_FILE:empty_cpp>" "$<TARGET_FILE_DIR:empty_cpp>/$<TARGET_FILE_BASE_NAME:empty_cpp>.bin" 
)

# Run post-build pipeline to perform additional post-processing
if(post_build_command)
add_custom_command(TARGET empty_cpp
    POST_BUILD
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/..
    COMMAND ${post_build_command}
)
endif()