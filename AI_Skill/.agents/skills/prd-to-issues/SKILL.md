---
name: prd-to-issues
description: >-
  Decomposes an approved Embedded PRD into Vertical Tracer Bullet tasks and builds a
  Directed Acyclic Graph (DAG) task plan.
---

# PRD Decomposition & DAG Builder (`/prd-to-issues`)

Use this skill after a PRD is approved to break down implementation into small, testable, vertical tracer bullets.

---

## 1. Vertical Tracer Bullet Philosophy

Avoid horizontal layering where you build all drivers first, then all protocols, then all UI without testing end-to-end.
Instead, create **thin vertical slices**:

```
Tracer Bullet 1: Minimal Frame Round-Trip
[Host Frame Pack] ──BLE──> [Firmware Parser] ──ACK──> [Host Unpack]

Tracer Bullet 2: Driver & State Integration
[Hardware Sensor Read] ──FSM──> [Frame Pack] ──Notify──> [Host GUI Display]

Tracer Bullet 3: Robustness & Error Recovery
[Disconnection / CRC error] ──Recovery FSM──> [Safe State Restored]
```

---

## 2. DAG Task Graph Template

Output the task breakdown with explicit dependencies in your task plan:

```mermaid
flowchart TD
    T1["Task 1: Protocol Schema & Host Unit Test (tools/ble_host/)"] --> T2["Task 2: Firmware Header Interface (src/module/include/)"]
    T2 --> T3["Task 3: Firmware Core Logic & Static State (src/module/source/)"]
    T1 --> T4["Task 4: Host GUI / CLI Integration"]
    T3 --> T5["Task 5: App Integration (app.c / app_process_action)"]
    T4 --> T6["Task 6: End-to-End Build & Hardware Verification"]
    T5 --> T6
```

---

## 3. Issue Specification Format

For each task in the plan:
1. **Task ID & Name**: e.g., `Task 1: Protocol framing & pytest`
2. **Inputs / Dependencies**: Which previous tasks must be complete.
3. **Files to touch**: Exact list of files (following Deep Module pattern).
4. **Verification Step**: Immediate automated command to verify completion.
