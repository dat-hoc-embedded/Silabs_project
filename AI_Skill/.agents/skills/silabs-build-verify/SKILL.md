---
name: silabs-build-verify
description: >-
  Builds, flashes, and verifies Silicon Labs firmware using CMake, ARM GCC,
  Simplicity Commander CLI, and static analysis tools.
---

# Silicon Labs Build & Verification Guide (`/silabs-build-verify`)

Use this skill to compile firmware, run static analysis, and verify flashing on target Silicon Labs hardware.

---

## 1. Automated Build Pipeline

### Configure & Build with CMake Presets
```powershell
# From project root directory:
# Step 1: Configure project preset (if build directory not yet generated)
cmake --preset project -B cmake_gcc/build

# Step 2: Compile target binary (empty.out / empty.hex)
cmake --build cmake_gcc/build --config base
```

### Static Analysis
```powershell
# Run cppcheck on custom source directory
cppcheck --enable=warning,style,performance,portability --inline-suppr --error-exitcode=1 src/
```

---

## 2. Hardware Flashing & Diagnostics (Simplicity Commander)

Simplicity Commander is typically installed in Simplicity Studio directory:
`C:\SiliconLabs\SimplicityStudio\v6\developer\adapter_packs\commander\commander.exe` (or in system PATH).

### Common Commander Commands
```powershell
# 1. Inspect connected target board (BRD4187C / EFR32MG24)
commander device info

# 2. Flash binary (.hex or .s37)
commander flash cmake_gcc/build/empty.hex --device EFR32MG24

# 3. Soft reset MCU to start firmware execution
commander device reset

# 4. Read real-time RTT / SWO logs (if enabled)
commander rtt read
```

---

## 3. Troubleshooting Build Failures

- **Undefined Reference to Autogen Functions:** Check if the required SDK component was installed in `empty.slcp`. Never edit `autogen/` files manually.
- **Section RAM/Flash Overflow:** Check map file (`cmake_gcc/build/empty.map`). Inspect statically allocated arrays and reduce buffer sizes.
- **Missing Header Path:** Ensure `src/module/<module_name>/include` is included in CMake include directories.
