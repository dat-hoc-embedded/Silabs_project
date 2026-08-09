# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
    empty # name project (not create target )
    VERSION 1.0
    LANGUAGES C CXX ASM # Use C/C++/ASM
)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Include the definition of the slc_empty target,
# which contains the content of the SLC project
include(empty.cmake) # Copy entirely content of empty.cmake 

file(GLOB MODULE_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/../src/module/source/*.c"
)

message(STATUS "Current source dir: ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "Module sources: ${MODULE_SOURCES}")
message(STATUS "SDK Path: ${COPIED_SDK_PATH}")

add_executable(empty
    # Add additional sources here
)

target_include_directories(empty PUBLIC
    # Add additional include paths here

)
target_include_directories(slc PUBLIC
    # Add additional include paths here
    ${CMAKE_CURRENT_SOURCE_DIR}/../src/module/include
)
target_sources(slc PRIVATE
    ${MODULE_SOURCES}
)

target_compile_definitions(empty PUBLIC
    # Add additional macros here
)

target_compile_options(empty PUBLIC
    # Set additional compiler flags here
)

target_link_options(empty PUBLIC
    # Set additional linker flags here
)

# Link with the content defined in the SLC project
target_link_libraries(empty PRIVATE
    slc
)

# Include managed project content if available
include(empty_project.cmake OPTIONAL RESULT_VARIABLE managed_project) # managed_project = empty_project.cmake
if(managed_project)
    message(STATUS "Using managed project content from ${managed_project}")
endif()

# Force the gcc linker command
set_target_properties(empty PROPERTIES LINKER_LANGUAGE C)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET empty
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_SREC_CMD} "$<TARGET_FILE:empty>" "$<TARGET_FILE_DIR:empty>/$<TARGET_FILE_BASE_NAME:empty>.s37"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_IHEX_CMD} "$<TARGET_FILE:empty>" "$<TARGET_FILE_DIR:empty>/$<TARGET_FILE_BASE_NAME:empty>.hex"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_BIN_CMD} "$<TARGET_FILE:empty>" "$<TARGET_FILE_DIR:empty>/$<TARGET_FILE_BASE_NAME:empty>.bin"
)

# Run post-build pipeline to perform additional post-processing
if(post_build_command)
    add_custom_command(TARGET empty
        POST_BUILD
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/..
        COMMAND ${post_build_command}
    )
endif()