---
name: embedded-tdd
description: >-
  Executes the Test-Driven Development (TDD) Red-Green-Refactor loop for Silicon Labs
  embedded C modules and Python BLE host applications.
---

# Embedded TDD Workflow (`/embedded-tdd`)

Use this skill during Phase 4 (Isolated Execution) to implement features with high reliability and zero regressions.

---

## 1. The Red-Green-Refactor Cycle for Embedded Systems

```
┌────────────────────────────────────────────────────────┐
│ 1. RED: Write failing test first                       │
│    - Host: Pytest for protocol roundtrip / serialization│
│    - Firmware: Test harness for FSM / ring buffer logic │
└─────────────────────────┬──────────────────────────────┘
                          ▼
┌────────────────────────────────────────────────────────┐
│ 2. GREEN: Implement minimal working code               │
│    - Implement functions in src/module/source/*.c       │
│    - Compile with CMake / GCC loop                      │
└─────────────────────────┬──────────────────────────────┘
                          ▼
┌────────────────────────────────────────────────────────┐
│ 3. REFACTOR: Harden architecture & optimize            │
│    - Encapsulate private functions with static          │
│    - Check buffer boundaries & static allocations       │
│    - Run static analysis (cppcheck)                     │
└────────────────────────────────────────────────────────┘
```

---

## 2. Testing Strategies by Layer

### Layer 1: Protocol & Serialization (Python Host Test)
- Always write roundtrip tests first in `tools/ble_host/tests/test_protocol.py`:
  - `build_frame()` -> `parse_frame()`
  - Verify CRC calculation, payload length validation, malformed frame rejection.

### Layer 2: Firmware Logic & State Machines
- Test state transitions, timer timeouts, and boundary checks.
- Keep hardware register accesses abstracted behind private HAL helper functions so the logic can be verified cleanly.

---

## 3. Fast Local Feedback Loop Commands

1. **Run Pytest:**
   ```powershell
   pytest tools/ble_host/tests/ -v
   ```

2. **Trigger Quick Build Check:**
   ```powershell
   cmake --build cmake_gcc/build --config base
   ```

3. **Run Cppcheck on touched module:**
   ```powershell
   cppcheck --enable=warning,performance,portability src/module/
   ```
