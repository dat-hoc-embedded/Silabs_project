---
name: audit-reviewer
description: >-
  Acts as an independent code reviewer with clean context to perform quality gate audits,
  verify security/memory standards, and generate the walkthrough.md report.
---

# Clean-Context Reviewer & Verification Audit (`/audit-reviewer`)

Use this skill during Phase 6 (Verification & Delivery) before finalizing changes or opening a PR.

---

## 1. Reviewer Audit Criteria

The reviewer agent must audit the changeset against 5 strict criteria:

### A. Memory & Pointer Safety
- [ ] No `malloc`, `calloc`, `free`, or `realloc` anywhere in firmware code.
- [ ] Array indexing bounded by compile-time constant bounds.
- [ ] Pointers validated against `NULL` before dereferencing.

### B. Concurrency & Interrupt Safety
- [ ] Shared state modified in ISRs or across FreeRTOS tasks protected by atomic blocks / mutexes.
- [ ] No blocking delays (`sl_udelay_wait` / `while(1)`) in main event loop handlers.

### C. SDK & Autogen Integrity
- [ ] No files in `autogen/`, `simplicity_sdk_*/`, or `.slps` modified directly.
- [ ] Silicon Labs SDK API return codes (`sl_status_t`) checked.

### D. Deep Module Architecture
- [ ] Public headers contain only essential interface functions (<= 7 functions).
- [ ] Private implementation functions declared `static`.

### E. Test & Build Proof
- [ ] Firmware compiles cleanly with CMake + ARM GCC.
- [ ] Python host tests pass with pytest.

---

## 2. Verification Report (`walkthrough.md`)

Generate or update `walkthrough.md` with the following structure:

```markdown
# Verification Walkthrough: [Feature / Change Title]

## Summary of Changes
- Summary of modules modified and features implemented.

## Verification Evidence
### 1. Build Verification
```powershell
cmake --build cmake_gcc/build --config base
# Output: [100%] Built target empty
```

### 2. Test Execution
```powershell
pytest tools/ble_host/tests/ -v
# Output: 5 passed in 0.45s
```

### 3. Static Analysis (Cppcheck)
```powershell
cppcheck src/
# Output: 0 errors, 0 warnings
```

## Reviewer Conclusion
- **Status:** PASS / FAIL
- **Sign-off:** Code adheres to Silicon Labs Deep Module & Quality Gate standards.
```
