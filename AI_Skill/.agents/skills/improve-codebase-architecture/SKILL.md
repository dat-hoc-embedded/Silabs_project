---
name: improve-codebase-architecture
description: >-
  Audits codebase for shallow modules, leaky abstractions, and oversized interfaces,
  refactoring them into robust Deep Modules.
---

# Codebase Architecture Refactoring (`/improve-codebase-architecture`)

Use this skill during Phase 5 (Architecture Refactoring) to eliminate technical debt, minimize public header interfaces, and lower AI context consumption.

---

## 1. Deep Module Audit Checklist

Audit every module in `src/module/` and `tools/ble_host/` against these criteria:

| Check | Target Standard | Violation Trigger |
| :--- | :--- | :--- |
| **Public API Surface** | 3-7 functions max per `.h` file | > 10 function declarations |
| **Encapsulation** | All helpers declared `static` in `.c` | Helper functions exposed globally in header |
| **State Storage** | File-scoped static struct in `.c` | Global non-static variables / arrays |
| **Context Cost** | Agent understands interface reading <= 2 files | Agent must read 3+ headers to call module |
| **Type Leaks** | Opaque typedefs / config structs | Raw peripheral register addresses in `.h` |

---

## 2. Refactoring Procedure

### Step 1: Interface Thinning
1. Review `src/module/<module>/include/<module>.h`.
2. Move any function prototype not meant to be called by external modules (e.g., `app.c`) into `source/<module>.c` and mark it `static`.
3. Move internal typedefs, macros, and buffer sizes into `source/<module>.c`.

### Step 2: State Consolidation
1. Group scattered static variables into a single static context structure:
   ```c
   // Inside source/<module>.c
   typedef struct {
     bool initialized;
     uint8_t tx_buffer[TX_BUF_LEN];
     uint16_t sequence_num;
   } ModuleContext_t;

   static ModuleContext_t s_ctx = {0};
   ```

### Step 3: Verification
1. Recompile with CMake: `cmake --build cmake_gcc/build --config base`
2. Run `cppcheck` to ensure no unused static functions or scope leaks exist.
