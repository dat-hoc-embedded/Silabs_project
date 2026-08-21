# build_check.ps1 - Fast CMake + ARM GCC Build Verification for Silicon Labs EFR32
param (
    [string]$Preset = "default_config",
    [string]$Config = "base"
)

$ErrorActionPreference = "Continue"

Write-Host "=== Starting Silicon Labs Firmware Build Verification ===" -ForegroundColor Cyan

# Check if build directory exists
if (-not (Test-Path "cmake_gcc/build")) {
    Write-Host "Configuring CMake build directory..." -ForegroundColor Yellow
    cmake --preset project -B cmake_gcc/build
}

# Run build
Write-Host "Compiling firmware target with CMake..." -ForegroundColor Yellow
cmake --build cmake_gcc/build --config $Config

if ($LASTEXITCODE -eq 0) {
    Write-Host "=== Build Successful! Binary ready in cmake_gcc/build/ ===" -ForegroundColor Green
    exit 0
} else {
    Write-Host "=== Build FAILED with exit code $LASTEXITCODE ===" -ForegroundColor Red
    exit 1
}
