---
trigger: always_on
---

# Workflow Guardrails: 6-Phase AI Development Pipeline

This workspace strictly adheres to the 6-phase AI development workflow defined in `AI_Coding.mmd`.
All AI agents operating in this repository must align with these phases based on the task scope.

```
Phase 1: Guardrails & Initial Rules
  └── Phase 2: Requirement Alignment (/grill-me)
        └── Phase 3: Decomposition (/write-a-prd, /prd-to-issues)
              └── Phase 4: Isolated Execution & TDD (/embedded-tdd, /silabs-build-verify)
                    └── Phase 5: Architecture Refactoring (/improve-codebase-architecture)
                          └── Phase 6: Verification & Delivery (/audit-reviewer)
```

---

## 1. Adaptive Workflow Enforcement

### For New Features & Architectural Refactoring (Full 6-Phase Pipeline)
1. **Phase 2 (Alignment)**: Execute `/grill-me` structured interview. Never generate implementation code without resolving hardware constraints, peripheral mapping, and protocol requirements.
2. **Phase 3 (Decomposition)**: Execute `/write-a-prd` to generate `PRD-<feature>.md`, followed by `/prd-to-issues` to establish vertical tracer bullets and a Directed Acyclic Graph (DAG) of tasks.
3. **Phase 4 (Execution & TDD)**: Implement module by module in isolation following Red-Green-Refactor (`/embedded-tdd`). Verify builds with CMake/GCC and static analysis (`cppcheck`).
4. **Phase 5 (Refactoring)**: Execute `/improve-codebase-architecture` to audit module depth, encapsulate private functions with `static`, and reduce public header footprint.
5. **Phase 6 (Verification)**: Clean-context review via `/audit-reviewer`, flash/test verification via Simplicity Commander, and output `walkthrough.md`.

### For Small Bug Fixes & Minor Tweaks (Lightweight 3-Step Loop)
1. **Hypothesis & Root Cause**: State the root cause hypothesis and proposed fix explicitly before modifying files.
2. **Implementation & Build**: Apply the fix adhering to Deep Module principles and run build check immediately.
3. **Verification**: Verify against regression and confirm fix with log or test.

---

## 2. Hard Boundaries & Forbidden Actions

- **NEVER** edit files inside `autogen/` or `simplicity_sdk_*/`. These are managed by Simplicity Studio components (`.slcp`).
- **NEVER** introduce dynamic memory allocation (`malloc`, `calloc`, `free`, `strdup`) in embedded C code. Static allocation only.
- **NEVER** block in event loop handlers (`app_process_action()`). All operations must be non-blocking state machines or timer-driven.
- **NEVER** leave public C header files cluttered with private structs, internal helper functions, or raw hardware registers.
