# Deep Module Architecture & Context Cost Optimization

> **Core Principle:** Maximize internal module depth; minimize public interface surface.  
> An AI agent or human developer should only need to read **at most 2 files** to fully understand how to interact with any module.

---

## 1. Embedded C Deep Modules (`src/module/`)

### Directory Layout
```
src/module/<module_name>/
├── include/
│   └── <module_name>.h       # PUBLIC: Minimal API interface (Max 3-7 functions)
└── source/
    └── <module_name>.c       # PRIVATE: Full implementation, static functions, static state
```

### Public Header (`include/<module_name>.h`) Rules
- **Include Guard:** Standard `#ifndef <MODULE_NAME>_H` / `#define <MODULE_NAME>_H`.
- **Public Functions:** Only expose lifecycle and essential operations:
  - `sl_status_t <module_name>_init(const <ModuleConfig>_t *config);`
  - `void <module_name>_process(void);`
  - `sl_status_t <module_name>_deinit(void);`
  - Minimal getters/setters or event triggers.
- **Opaque Types / Minimal Structs:** Do not expose internal buffers, hardware register pointers, or private state in public headers.
- **Doxygen Documentation:** Every public function must document parameters, return status codes (`sl_status_t`), and reentrancy/ISR safety.

### Private Source (`source/<module_name>.c`) Rules
- **Static Encapsulation:** Every internal function **MUST** be declared `static`.
- **Static Module State:** Module state is kept in a single file-scoped static struct:
  ```c
  static struct {
    bool is_initialized;
    uint32_t state_flags;
    uint8_t buffer[MODULE_BUFFER_SIZE];
  } s_module_ctx = {0};
  ```
- **No Global Variables:** Never expose non-static global variables.

---

## 2. Python Deep Modules (`tools/ble_host/`)

### Directory Layout
```
tools/ble_host/<module_name>/
├── __init__.py               # PUBLIC: Explicit __all__ exporting 3-5 top-level classes/functions
├── core_logic.py             # PRIVATE: Core business logic and async handlers
└── helpers.py                # PRIVATE: Protocol parsers, CRC calculations, utilities
```

### Rules
- **Public Exports:** Use `__all__` in `__init__.py` to strictly control public symbols.
- **Type Annotations:** Require full Python type hints (`from __future__ import annotations`).
- **Internal Naming:** All private classes, functions, and attributes must be prefixed with `_`.
- **Docstrings:** Google-style docstrings for all public interfaces.

---

## 3. Anti-Patterns (Shallow Modules) to Refactor
- ❌ Modules with 20+ public function prototypes in `.h` file where 15 are internal helpers.
- ❌ Direct access to global arrays or peripheral registers from outside the owning module.
- ❌ Leaking hardware-specific register masks into high-level business logic.
- ❌ Splitting simple logic across 5+ tiny files requiring jumping through deep call graphs.
