---
name: grill-me
description: >-
  Runs a structured recursive interview to resolve ambiguities and lock requirements
  for Silicon Labs embedded IoT features before writing any code.
---

# Silicon Labs Requirements Alignment Interview (`/grill-me`)

Use this skill when receiving a new feature request, architecture change, or complex IoT service definition.
You must conduct a multi-stage interview using the `ask_question` tool, walking down each branch of the design tree one question at a time.

---

## 5-Stage Embedded IoT Interview Tree

### Stage 1: Hardware & Peripherals Context
- **Target Chip/Board:** EFR32MG24 (BRD4187C) or custom board pinout.
- **Peripherals Involved:** GPIO, EUSART, I2C, SPI, ADC, Timers (`sl_sleeptimer` vs hardware TIMER/LETIMER).
- **Power Constraints:** Active EM0 vs Deep Sleep EM2/EM3 requirement, battery operated vs mains powered.
- **Memory Budget:** Target flash and RAM limits for the new module.

### Stage 2: Wireless Stack & Protocol
- **Stack:** BLE (Bluetooth LE), Matter, Zigbee 3.0, OpenThread, or Proprietary 2.4GHz / Sub-GHz.
- **BLE Service Schema:** GATT Service UUIDs (16-bit vs 128-bit custom), Characteristics (Read, Write, Notify, Indicate), MTU requirements.
- **Mesh/Clusters:** ZCL / Matter cluster IDs, attributes, command handlers.
- **Binary Frame Format:** Frame delimiter/SYNC, Version, Opcode, Length, Payload, CRC checksum.

### Stage 3: Concurrency & Lifecycle Architecture
- **Architecture Type:** Bare-Metal non-blocking FSM (`app_init` + `app_process_action`) vs FreeRTOS / Micrium OS tasks.
- **Task & Stack Allocation:** Task priority, stack depth (words), queue sizes, mutex ownership.
- **Interrupts:** ISR context requirements, atomic section protection (`CORE_ENTER_ATOMIC()`).

### Stage 4: Public Interface & Module Encapsulation
- **Public API Surface:** Target maximum of 3-7 public functions in `include/<module>.h`.
- **Error Handling:** `sl_status_t` return codes for all operations.
- **Host Integration:** Python BLE host app interface requirements (`tools/ble_host/`).

### Stage 5: Verification & Failure Modes
- **Edge Cases:** Disconnection during transmission, buffer overflow, invalid CRC, timeout recovery.
- **Verification Strategy:** Host pytest simulation, CMake build check, Simplicity Commander flashing, RTT log validation.

---

## Interview Rules

1. **Ask One Question at a Time:** Use `ask_question` with structured multiple-choice options and clear recommendations.
2. **Explore Codebase First:** If an answer is already determined in `empty.slcp`, `config/`, or existing headers, read the code instead of asking trivial questions.
3. **Transition to PRD:** Once all ambiguities are resolved, summarize the locked requirements and transition to `/write-a-prd`.
