# Silicon Labs Embedded C & IoT Standards

> **Hardware Target:** Silicon Labs EFR32MG24 (BRD4187C)  
> **SDK:** Simplicity SDK (2026.6.0+) / Gecko SDK  
> **Toolchain:** ARM GCC (`arm-none-eabi-gcc`) + CMake / Ninja  

---

## 1. Application Lifecycle & Architecture

### A. Bare-Metal Event-Driven Architecture
- **Entry Points:** Respect Silicon Labs event handler structure in `app.c`:
  - `app_init(void)`: Initialize custom modules, hardware peripherals, and application timers.
  - `app_process_action(void)`: Non-blocking state machine loop.
- **Rule:** Never insert `while(1)`, blocking delays (`sl_udelay_wait`), or infinite busy-waits inside `app_process_action()`.
- **Timers:** Use `sl_sleeptimer` (`sl_sleeptimer_start_periodic_timer_ms()`) or hardware timers (`sl_simple_timer`) instead of blocking loops.

### B. RTOS Multi-Tasking Architecture (FreeRTOS / Micrium OS)
- **Task Isolation:** Each IoT service / peripheral manager runs in its own task with a dedicated static stack.
- **Inter-Task Communication:** Use Queues (`osMessageQueueId_t`), Event Flags (`osEventFlagsId_t`), or Direct-to-Task Notifications.
- **Synchronization:** Protect shared resources with Mutexes (`osMutexId_t`) or Semaphores. Never access shared hardware registers or buffers across tasks without mutual exclusion.
- **Task Stacks:** Monitor stack high-water marks (`uxTaskGetStackHighWaterMark()`) during development to prevent overflows.

---

## 2. Wireless Stacks & IoT Protocols

### A. Bluetooth Low Energy (BLE)
- **Stack Callbacks:** Handle BLE stack events in `sl_bt_on_event(sl_bt_msg_t *evt)`.
- **Custom GATT Services:** Define standard or 128-bit UUID services with clear Characteristic properties (Read, Write, Notify, Indicate).
- **Packet Serialization:** Pack data explicitly in **Little-Endian** byte order matching ARM Cortex-M architecture.
- **Connection Dynamics:** Gracefully handle connection open, MTU exchange, parameters update, and unexpected disconnection events.

### B. Multi-Protocol & Mesh (Zigbee / Matter / OpenThread / Proprietary)
- Maintain clear layer boundaries between stack event callbacks and application business logic.
- Keep cluster/command handlers lightweight, queuing events to the main application task or event loop.

---

## 3. Power Management & Sleep Modes

- Support Silicon Labs Energy Modes:
  - **EM0 (Active)**: Fast processing.
  - **EM1 (Sleep)**: Peripheral DMA active.
  - **EM2 (Deep Sleep)**: Low frequency oscillators (LFXO/LFRCO), `sl_sleeptimer` running, RAM retained.
  - **EM3/EM4**: Deep powerdown modes when required.
- Do not keep high-frequency clocks or power-hungry peripherals enabled when idle.
- Register power requirements using `sl_power_manager_add_em_requirement(SL_POWER_MANAGER_EM1/EM2)`.

---

## 4. Interrupt Safety & Memory Standards

- **Atomic Blocks:** Protect shared variables updated in ISRs using:
  ```c
  CORE_DECLARE_IRQ_STATE;
  CORE_ENTER_ATOMIC();
  // Critical section code
  CORE_EXIT_ATOMIC();
  ```
- **ISR Execution:** Keep ISR handlers minimal: set a volatile flag / post to an OS queue, and return immediately.
- **Zero Dynamic Allocation:** No `malloc()`, `free()`, or heap-dependent containers. Use statically allocated structs and ring buffers with compile-time bounded sizes.
- **Error Propagation:** Always return and check `sl_status_t` (`SL_STATUS_OK`, `SL_STATUS_INVALID_PARAMETER`, etc.).
- **Asserts:** Use `EFM_ASSERT()` or `sl_assert()` for invariant verification during development.
