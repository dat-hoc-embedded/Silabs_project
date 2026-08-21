# Quality Gates & Verification Standards

All code delivered by AI agents must pass the following verification gates before completion.

---

## 1. Quality Gates Checklist

- [ ] **Firmware Build:** Clean compilation with ARM GCC via CMake/Ninja without errors or unhandled warnings.
- [ ] **Static Analysis:** `cppcheck` passes with zero critical warnings (no null pointer dereferences, buffer overflows, or uninitialized variables).
- [ ] **Autogen Protection:** Zero modifications to `autogen/`, `simplicity_sdk_*/`, or `.slps` files.
- [ ] **Interface Footprint:** Public headers adhere to Deep Module standards (<= 7 public functions).
- [ ] **Host Test Suite:** All Python tests in `tools/ble_host/tests/` pass with `pytest`.
- [ ] **Documentation:** `walkthrough.md` generated with build logs, test proofs, or hardware verification logs.

---

## 2. Standard Build & Test Commands

### Firmware Compilation (CMake + Ninja)
```powershell
# From project root:
cmake --build cmake_gcc/build --config base
```

### Static Analysis (Cppcheck)
```powershell
# Analyze custom modules in src/
cppcheck --enable=warning,performance,portability --inconclusive --error-exitcode=1 src/
```

### Hardware Flashing & Diagnostics (Simplicity Commander)
```powershell
# Check connected EFR32 device
commander device info

# Flash compiled binary
commander flash cmake_gcc/build/empty.hex --device EFR32MG24

# Reset target
commander device reset
```

### Host Application Unit Testing (Pytest)
```powershell
# Run all host tests
pytest tools/ble_host/tests/ -v
```
