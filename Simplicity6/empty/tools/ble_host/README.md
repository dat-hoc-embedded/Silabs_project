# BLE Host Application

A PyQt6 desktop application for scanning, connecting, and exchanging data with BLE devices — targeting the Silicon Labs **BRD4187C** (EFR32MG24).

## Features

- **BLE Scanner** — Discover nearby BLE devices with name filtering, RSSI color coding
- **GATT Explorer** — Browse services & characteristics, read/write/subscribe
- **Live Telemetry** — Real-time charts (pyqtgraph) for sensor data
- **Data Logger** — Log parsed frames to CSV or JSONL files
- **Custom Frame Protocol** — Binary frame parser with CRC-8 validation

## Architecture

```
tools/ble_host/
├── main.py              # Entry point (qasync event loop)
├── core/                # Deep Module: BLE engine
│   ├── protocol.py      # Frame parser/builder + CRC-8
│   ├── scanner.py       # BLE device scanner
│   ├── connection.py    # GATT connection manager
│   └── logger.py        # CSV/JSON data logger
├── gui/                 # Deep Module: PyQt6 UI
│   ├── main_window.py   # Main window orchestrator
│   ├── scan_panel.py    # Device scanner tab
│   ├── device_panel.py  # GATT explorer tab
│   ├── live_panel.py    # Real-time charts tab
│   ├── log_panel.py     # Data logger tab
│   └── styles.py        # Dark theme QSS
└── tests/               # Automated test suite
    ├── test_protocol.py
    ├── test_scanner.py
    └── test_connection.py
```

## Setup

```bash
cd tools/ble_host
pip install -r requirements.txt
```

## Run

```bash
python main.py
```

## Test

```bash
pytest tests/ -v
```

## Frame Protocol

Binary frame format (Little-Endian):

```
┌──────────┬────────┬───────────┬─────────┬──────────────┬──────────┐
│ SYNC (2) │ VER(1) │ OPCODE(1) │ LEN (1) │ PAYLOAD(0-N) │ CRC8 (1) │
└──────────┴────────┴───────────┴─────────┴──────────────┴──────────┘
```

| Opcode | Name | Payload Size |
|--------|------|-------------|
| 0x01 | Telemetry | 9 bytes |
| 0x02 | Status | 5 bytes |
| 0x03 | Command | 5 bytes |
| 0x04 | Ack | 2 bytes |

## Requirements

- Python 3.11+
- Windows/macOS/Linux with Bluetooth adapter
- PyQt6, Bleak, qasync, pyqtgraph
