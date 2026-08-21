### Silicon Labs EFR32MG24 Architecture Overview

The **EFR32MG24** (Mighty Gecko Series 2) is a multi-protocol wireless SoC designed for 2.4 GHz mesh and point-to-point networking (Matter, OpenThread, Zigbee, and Bluetooth Low Energy 5.3/5.4).

```
+-----------------------------------------------------------------------+
|                            EFR32MG24 SoC                              |
|                                                                       |
|  +------------------------+  +-------------------------------------+  |
|  |     Main Processor     |  |       AI/ML & Hardware Accel        |  |
|  |  ARM Cortex-M33 @78MHz |  |  Matrix Vector Processor (MVP)      |  |
|  |   DSP & FPU Extensions |  |  Secure Vault High (Crypto/PUF/DPA) |  |
|  +------------------------+  +-------------------------------------+  |
|                                                                       |
|  +------------------------+  +-------------------------------------+  |
|  |         Memory         |  |         2.4 GHz Transceiver         |  |
|  |   Flash: Up to 1536 KB |  |  TX: Up to +10 dBm / +19.5 dBm      |  |
|  |    RAM: Up to 256 KB   |  |  RX: -105.7 dBm (125k BLE), -97 dBm |  |
|  |  (Configurable blocks) |  |  Dedicated Radio Controller/Sequencer|  |
|  +------------------------+  +-------------------------------------+  |
|                                                                       |
|  +-----------------------------------------------------------------+  |
|  |              Autonomous Peripherals & Power Domain              |  |
|  |   PRS (Peripheral Reflex System)  |  LESENSE (Low Energy Sensor)|  |
|  |   EUSART / LEUART / I2C / LETIMER |  Integrated DC-DC Converter |  |
|  |   16-bit ADC / 12-bit DAC / ACMP  |  EM0 (Active) -> EM4 (Shut) |  |
|  +-----------------------------------------------------------------+  |
+-----------------------------------------------------------------------+
```

#### Core Components
1. **Compute & AI/ML Acceleration:**
   - **ARM Cortex-M33 Core:** Runs up to 78 MHz with TrustZone security, DSP instructions, and a single-precision FPU.
   - **Matrix Vector Processor (MVP):** Dedicated hardware accelerator for neural network inference, accelerating matrix computations up to 8x with up to 6x lower energy compared to software execution.
2. **RF Subsystem:**
   - High-performance 2.4 GHz radio with integrated Power Amplifier (PA options for +10 dBm or +19.5 dBm).
   - Dedicated radio CPU/Sequencer to offload packet handling, CRC, and timing from the main application core.
3. **Memory Architecture:**
   - Up to **1536 KB Flash** and up to **256 KB RAM** organized in power-gated retention banks.
4. **Power & Energy Modes:**
   - Integrated **DC-DC Buck Converter** providing low operating currents (~4.4 mA TX @ 0 dBm, ~5.1 mA RX, ~1.3 µA EM2 with 16 KB RAM retention).
   - Five power states: **EM0** (Active), **EM1** (Sleep), **EM2** (Deep Sleep — Bluetooth stack sleep), **EM3** (Stop), and **EM4** (Shutoff/Hibernate).
5. **Peripheral Reflex System (PRS) & LESENSE:**
   - PRS allows on-chip peripherals to communicate and trigger actions autonomously without waking the Cortex-M33 core.
   - LESENSE monitors external analog sensors (capacitive, inductive, resistive) in EM2.

---

### 3 Tips for BLE Power Optimization on EFR32

#### 1. Maximize EM2 Deep Sleep & Leverage PRS / LESENSE
- **Keep the CPU in EM2:** Ensure your BLE application uses the Gecko SDK **Power Manager** component (`sl_power_manager`), allowing the device to drop to EM2 during idle periods between advertising or connection intervals.
- **Autonomous Sensor Interfacing:** Instead of waking the M33 core periodically with a timer to sample sensors, use **LESENSE** or trigger ADC conversions via **PRS** channels connected to a low-frequency timer (`LETIMER`). Only wake the CPU when a threshold interrupt is hit.

#### 2. Tune BLE Advertising & Connection Parameters
- **Optimize Connection Timing:**
  - Increase the **Connection Interval** (e.g., 500 ms to 1000 ms for low-throughput sensor nodes).
  - Increase **Slave Latency** (connection event skipping) so the peripheral only wakes up when it has data to send or when the supervision timeout is approaching.
- **Calibrate TX Output Power:**
  - Reduce the radio TX power via `sl_bt_system_set_max_tx_power()` to match the required link budget (e.g., 0 dBm instead of +10 dBm or +19.5 dBm).
- **Use Non-Connectable or Extended Advertising:** If only broadcasting data (beacons), use non-connectable advertising without scan responses to halve the RF event duration.

#### 3. Optimize DC-DC Conversion and RAM Retention in EM2
- **Enable the Integrated DC-DC Buck Converter:**
  - Configure the internal DC-DC converter in buck mode instead of bypass/LDO mode to step down battery voltages (e.g., 3.0V CR2032 or 3.6V LiSOCl2) to the internal core rail, cutting active and sleep currents significantly.
- **Power Down Unused RAM Blocks in EM2:**
  - The EFR32MG24 allows selective RAM retention. Configure `sl_power_manager` or EMU registers (`EMU_RAM0RETCURLO` / `EMU_RAM0CTRL`) to power-gate unused memory blocks, reducing EM2 leakage current down towards the ~1.3 µA minimum.