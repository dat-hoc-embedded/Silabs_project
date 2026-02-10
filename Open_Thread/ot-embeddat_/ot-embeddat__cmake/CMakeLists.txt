# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
	ot-embeddat_
	VERSION 1.0
	LANGUAGES C CXX ASM
)

# Include the definition of the slc_ot-embeddat_ target,
# which contains the content of the SLC project
include(ot-embeddat_.cmake)

add_executable(ot-embeddat_
    # Add additional sources here
)

target_include_directories(ot-embeddat_ PUBLIC
    # Add additional include paths here
)

target_compile_definitions(ot-embeddat_ PUBLIC
    # Add additional macros here
)

target_compile_options(ot-embeddat_ PUBLIC
    # Set additional compiler flags here
)

target_link_options(ot-embeddat_ PUBLIC
    # Set additional linker flags here
)

# Link with the content defined in the SLC project
target_link_libraries(ot-embeddat_ PRIVATE
    slc_ot-embeddat_
)

# Include managed project content if available
include(ot-embeddat__project.cmake OPTIONAL RESULT_VARIABLE managed_project)
if(managed_project)
    message(STATUS "Using managed project content from ${managed_project}")
endif()

# Force the gcc linker command
set_target_properties(ot-embeddat_ PROPERTIES LINKER_LANGUAGE C)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET ot-embeddat_
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_SREC_CMD} "$<TARGET_FILE:ot-embeddat_>" "$<TARGET_FILE_DIR:ot-embeddat_>/$<TARGET_FILE_BASE_NAME:ot-embeddat_>.s37"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_IHEX_CMD} "$<TARGET_FILE:ot-embeddat_>" "$<TARGET_FILE_DIR:ot-embeddat_>/$<TARGET_FILE_BASE_NAME:ot-embeddat_>.hex"
    COMMAND ${CMAKE_OBJCOPY} ${OBJCOPY_BIN_CMD}  "$<TARGET_FILE:ot-embeddat_>" "$<TARGET_FILE_DIR:ot-embeddat_>/$<TARGET_FILE_BASE_NAME:ot-embeddat_>.bin" 
)

# Run post-build pipeline to perform additional post-processing
if(post_build_command)
add_custom_command(TARGET ot-embeddat_
    POST_BUILD
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/..
    COMMAND ${post_build_command}
)
endif()