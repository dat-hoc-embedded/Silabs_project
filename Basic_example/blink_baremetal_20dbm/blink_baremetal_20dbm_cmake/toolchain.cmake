set(CMAKE_SYSTEM_NAME                   Generic)
set(CMAKE_SYSTEM_PROCESSOR              arm)
set(CMAKE_TRY_COMPILE_TARGET_TYPE       STATIC_LIBRARY)

if(WIN32)
  set(EXE_SUFFIX ".exe")
else()
  set(EXE_SUFFIX "")
endif()

## Determine Arm GCC toolchain directory
# Priority:
# 1) CMake cache var ARM_GCC_DIR (set via -DARM_GCC_DIR=C:/path/to/toolchain)
# 2) Environment var ARM_GCC_DIR
# 3) Auto-discover via find_program from common install roots

# Normalize override via cache variable first
if(DEFINED ARM_GCC_DIR AND EXISTS "${ARM_GCC_DIR}")
  set(TOOLCHAIN_DIR "${ARM_GCC_DIR}/bin/")
elseif(DEFINED ENV{ARM_GCC_DIR} AND EXISTS "$ENV{ARM_GCC_DIR}")
  set(TOOLCHAIN_DIR "$ENV{ARM_GCC_DIR}/bin/")
else()
  # Try to locate arm-none-eabi-gcc on PATH or common install roots
  if(WIN32)
    # Hint common Windows locations (Simplicity Studio and standalone installs)
    set(_ARM_GCC_HINTS
      "C:/ArmGCC"
      "C:/Program Files/Arm GNU Toolchain arm-none-eabi"
      "C:/Program Files (x86)/GNU Arm Embedded Toolchain"
      "E:/Application/SiliconLabs/SimplicityStudio/v5/developer/toolchains/gnu_arm"
    )
  elseif(APPLE)
    set(_ARM_GCC_HINTS "/usr/local" "/opt/homebrew" "/opt/local")
  else()
    set(_ARM_GCC_HINTS "/usr" "/usr/local" "/opt")
  endif()

  find_program(ARM_GCC_EXE
    NAMES arm-none-eabi-gcc${EXE_SUFFIX}
    HINTS ${_ARM_GCC_HINTS}
    PATH_SUFFIXES bin 12.2.rel1/bin 12.3.rel1/bin 12.2/bin 10.3-2021.10/bin
  )

  if(ARM_GCC_EXE)
    get_filename_component(TOOLCHAIN_DIR "${ARM_GCC_EXE}" DIRECTORY)
    set(TOOLCHAIN_DIR "${TOOLCHAIN_DIR}/")
  else()
    message(FATAL_ERROR
      "Arm GCC (arm-none-eabi-gcc) not found. Set ARM_GCC_DIR to the toolchain root (without /bin),\n"
      "or add the toolchain's bin directory to PATH.\n"
      "Examples:\n"
      "  -DARM_GCC_DIR=E:/Application/SiliconLabs/SimplicityStudio/v5/developer/toolchains/gnu_arm/12.2.rel1\n"
      "  -DARM_GCC_DIR=C:/Program Files/Arm GNU Toolchain arm-none-eabi/12.3.rel1"
    )
  endif()
endif()

if(DEFINED ENV{POST_BUILD_EXE})
  set(POST_BUILD_EXE "$ENV{POST_BUILD_EXE}")
elseif(WIN32)
  set(POST_BUILD_EXE "E:/Application/SiliconLabs/SimplicityStudio/v5/developer/adapter_packs/commander/commander.exe")
elseif(APPLE)
  set(POST_BUILD_EXE "")
else()
  set(POST_BUILD_EXE "")
endif()

if(DEFINED ENV{NINJA_EXE_PATH})
  set(CMAKE_MAKE_PROGRAM "$ENV{NINJA_EXE_PATH}" CACHE FILEPATH "" FORCE)
elseif(WIN32)
  set(NINJA_RUNTIME_PATH "E:/Application/SiliconLabs/SimplicityStudio/v5/developer/adapter_packs/ninja/ninja.exe")
elseif(APPLE)
  set(NINJA_RUNTIME_PATH "")
else()
  set(NINJA_RUNTIME_PATH "")
endif()
# Use default lookup mechanisms if the OS specific values are not set above
if (NINJA_RUNTIME_PATH)
	set(CMAKE_MAKE_PROGRAM ${NINJA_RUNTIME_PATH} CACHE FILEPATH "" FORCE)
endif()

set(TARGET_TRIPLET "arm-none-eabi-")
set(CMAKE_C_COMPILER    ${TOOLCHAIN_DIR}${TARGET_TRIPLET}gcc${EXE_SUFFIX})
set(CMAKE_CXX_COMPILER  ${TOOLCHAIN_DIR}${TARGET_TRIPLET}g++${EXE_SUFFIX})
set(CMAKE_ASM_COMPILER  ${TOOLCHAIN_DIR}${TARGET_TRIPLET}gcc${EXE_SUFFIX})
set(CMAKE_LINKER        ${TOOLCHAIN_DIR}${TARGET_TRIPLET}gcc${EXE_SUFFIX})
set(CMAKE_AR            ${TOOLCHAIN_DIR}${TARGET_TRIPLET}ar${EXE_SUFFIX})
set(CMAKE_SIZE_UTIL     ${TOOLCHAIN_DIR}${TARGET_TRIPLET}size${EXE_SUFFIX})
set(CMAKE_STRIP         ${TOOLCHAIN_DIR}${TARGET_TRIPLET}strip${EXE_SUFFIX})
set(CMAKE_OBJCOPY       ${TOOLCHAIN_DIR}${TARGET_TRIPLET}objcopy${EXE_SUFFIX})
set(CMAKE_OBJDUMP       ${TOOLCHAIN_DIR}${TARGET_TRIPLET}objdump${EXE_SUFFIX})
set(CMAKE_NM_UTIL       ${TOOLCHAIN_DIR}${TARGET_TRIPLET}gcc-nm${EXE_SUFFIX})
set(CMAKE_RANLIB        ${TOOLCHAIN_DIR}${TARGET_TRIPLET}gcc-ranlib${EXE_SUFFIX})
set(CMAKE_GCOV          ${TOOLCHAIN_DIR}${TARGET_TRIPLET}gcov${EXE_SUFFIX})

# Validate discovered toolchain binaries early for a clearer error
foreach(_tool IN ITEMS CMAKE_C_COMPILER CMAKE_CXX_COMPILER CMAKE_ASM_COMPILER)
  if(NOT EXISTS "${${_tool}}")
    message(FATAL_ERROR
      "${_tool} points to a non-existent path: '${${_tool}}'.\n"
      "Please set ARM_GCC_DIR to your Arm GCC installation root (without /bin).")
  endif()
endforeach()

set(OBJCOPY_SREC_CMD    "-O;srec")
set(OBJCOPY_IHEX_CMD    "-O;ihex")
set(OBJCOPY_BIN_CMD     "-O;binary")

set(CMAKE_C_STANDARD_REQUIRED   OFF)
set(CMAKE_CXX_STANDARD_REQUIRED OFF)
set(CMAKE_C_EXTENSIONS          OFF)

set(CMAKE_C_FLAGS_RELEASE               "" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE             "" CACHE STRING "")

# Response file support
SET(CMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS   1)
SET(CMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS 1)
SET(CMAKE_C_RESPONSE_FILE_LINK_FLAG         "@")
SET(CMAKE_CXX_RESPONSE_FILE_LINK_FLAG       "@")
SET(CMAKE_NINJA_FORCE_RESPONSE_FILE         1 CACHE INTERNAL "")


set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM   NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY   ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE   ONLY)

set(CMAKE_EXECUTABLE_SUFFIX     .out)
set(CMAKE_EXECUTABLE_SUFFIX_C   .out)
set(CMAKE_EXECUTABLE_SUFFIX_CXX .out)
