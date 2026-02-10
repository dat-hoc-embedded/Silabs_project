#!/usr/bin/env python3
"""
UART test tool for SerialAPI FUNC_ID_ZW_SET_LEARN_MODE (0x50).

Examples:
  python3 tools/test_set_learn_mode.py --port /dev/ttyUSB0 --mode classic --func-id 0x44
  python3 tools/test_set_learn_mode.py --port /dev/ttyUSB0 --mode disable --func-id 0
  python3 tools/test_set_learn_mode.py --port /dev/ttyUSB0 --mode inclusion --func-id 0x44
"""

from __future__ import annotations

import argparse
import sys
import time
from typing import Optional

try:
    import serial
except ImportError as exc:
    print("Missing dependency: pyserial. Install with `pip install pyserial`.", file=sys.stderr)
    raise SystemExit(2) from exc

if not hasattr(serial, "Serial"):
    serial_file = getattr(serial, "__file__", "<unknown>")
    print(
        "Imported module 'serial' does not provide 'Serial'.\n"
        f"Current module path: {serial_file}\n"
        "This usually means wrong package is installed (e.g. 'serial' instead of 'pyserial').\n"
        "Fix:\n"
        "  python -m pip uninstall -y serial\n"
        "  python -m pip uninstall -y pyserial\n"
        "  python -m pip install pyserial\n",
        file=sys.stderr,
    )
    raise SystemExit(2)


SOF = 0x01
ACK = 0x06
NAK = 0x15
CAN = 0x18

REQUEST = 0x00
RESPONSE = 0x01

FUNC_ID_ZW_SET_LEARN_MODE = 0x50

MODE_BY_NAME = {
    "disable": 0x00,
    "classic": 0x01,
    "nwi": 0x02,
    "nwe": 0x03,
    # Learn Plus / Network Management extension:
    "nm-disable": 0x80,
    "inclusion": 0x81,
    "exclusion": 0x82,
    "exclusion-nwe": 0x83,
    "smartstart": 0x84,
}

CTRL_NAMES = {
    ACK: "ACK",
    NAK: "NAK",
    CAN: "CAN",
}


def xor_ff(data: bytes) -> int:
    value = 0xFF
    for byte in data:
        value ^= byte
    return value & 0xFF


def parse_u8(text: str) -> int:
    value = int(text, 0)
    if not 0 <= value <= 0xFF:
        raise argparse.ArgumentTypeError(f"value out of range [0..255]: {text}")
    return value


def parse_mode(text: str) -> int:
    key = text.strip().lower()
    if key in MODE_BY_NAME:
        return MODE_BY_NAME[key]
    return parse_u8(text)


def build_request(cmd: int, payload: bytes) -> bytes:
    length = len(payload) + 3
    body = bytes([length, REQUEST, cmd]) + payload
    checksum = xor_ff(body)
    return bytes([SOF]) + body + bytes([checksum])


def read_exact(ser: serial.Serial, total: int, deadline: float) -> Optional[bytes]:
    if total == 0:
        return b""
    data = bytearray()
    while len(data) < total:
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            return None
        ser.timeout = min(0.2, remaining)
        chunk = ser.read(total - len(data))
        if chunk:
            data.extend(chunk)
    return bytes(data)


def read_packet(ser: serial.Serial, deadline: float) -> Optional[dict]:
    start = read_exact(ser, 1, deadline)
    if not start:
        return None
    first = start[0]
    if first != SOF:
        return {"kind": "ctrl", "value": first}

    length_raw = read_exact(ser, 1, deadline)
    if not length_raw:
        return None
    length = length_raw[0]

    rest = read_exact(ser, length, deadline)
    if not rest:
        return None

    frame = bytes([SOF, length]) + rest
    body = frame[1:-1]  # LEN|TYPE|CMD|PAYLOAD
    checksum = frame[-1]
    valid = xor_ff(body) == checksum

    frame_type = frame[2]
    cmd = frame[3]
    payload = frame[4:-1]

    return {
        "kind": "frame",
        "valid": valid,
        "type": frame_type,
        "cmd": cmd,
        "payload": payload,
        "raw": frame,
    }


def send_frame_ack(ser: serial.Serial, valid: bool) -> None:
    ser.write(bytes([ACK if valid else NAK]))
    ser.flush()


def format_bytes(data: bytes) -> str:
    return " ".join(f"{b:02X}" for b in data)


def parse_learn_mode_callback(payload: bytes) -> str:
    if len(payload) == 4:
        func_id, status, node_id, extra_len = payload
        return (
            f"funcID=0x{func_id:02X}, status=0x{status:02X}, "
            f"node_id={node_id}, cmd_len={extra_len}"
        )
    if len(payload) >= 5:
        func_id = payload[0]
        status = payload[1]
        node_id = (payload[2] << 8) | payload[3]
        extra_len = payload[4]
        return (
            f"funcID=0x{func_id:02X}, status=0x{status:02X}, "
            f"node_id={node_id}, cmd_len={extra_len}"
        )
    return "unknown payload format"


def wait_for_response(
    ser: serial.Serial,
    timeout_s: float,
) -> tuple[Optional[int], bool]:
    deadline = time.monotonic() + timeout_s
    got_ack = False
    ret_val = None

    while time.monotonic() < deadline and ret_val is None:
        packet = read_packet(ser, deadline)
        if packet is None:
            break

        if packet["kind"] == "ctrl":
            ctrl = packet["value"]
            if ctrl == ACK:
                got_ack = True
            else:
                print(f"RX ctrl: {CTRL_NAMES.get(ctrl, f'0x{ctrl:02X}')}")
            continue

        valid = bool(packet["valid"])
        send_frame_ack(ser, valid)
        if not valid:
            print(f"RX frame checksum error: {format_bytes(packet['raw'])}")
            continue

        frame_type = packet["type"]
        cmd = packet["cmd"]
        payload = packet["payload"]
        print(
            f"RX frame type=0x{frame_type:02X} cmd=0x{cmd:02X} "
            f"payload=[{format_bytes(payload)}]"
        )

        if frame_type == RESPONSE and cmd == FUNC_ID_ZW_SET_LEARN_MODE and payload:
            ret_val = payload[0]
            break

    return ret_val, got_ack


def wait_for_callback(
    ser: serial.Serial,
    func_id: int,
    timeout_s: float,
) -> Optional[bytes]:
    deadline = time.monotonic() + timeout_s

    while time.monotonic() < deadline:
        packet = read_packet(ser, deadline)
        if packet is None:
            break

        if packet["kind"] == "ctrl":
            ctrl = packet["value"]
            print(f"RX ctrl: {CTRL_NAMES.get(ctrl, f'0x{ctrl:02X}')}")
            continue

        valid = bool(packet["valid"])
        send_frame_ack(ser, valid)
        if not valid:
            print(f"RX frame checksum error: {format_bytes(packet['raw'])}")
            continue

        frame_type = packet["type"]
        cmd = packet["cmd"]
        payload = packet["payload"]
        print(
            f"RX frame type=0x{frame_type:02X} cmd=0x{cmd:02X} "
            f"payload=[{format_bytes(payload)}]"
        )

        if (
            frame_type == REQUEST
            and cmd == FUNC_ID_ZW_SET_LEARN_MODE
            and len(payload) >= 1
            and payload[0] == func_id
        ):
            return payload

    return None


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Test SerialAPI FUNC_ID_ZW_SET_LEARN_MODE over UART."
    )
    parser.add_argument("--port", required=True, help="Serial port, e.g. /dev/ttyUSB0 or COM7")
    parser.add_argument("--baud", type=int, default=115200, help="Baud rate (default: 115200)")
    parser.add_argument(
        "--mode",
        type=parse_mode,
        default=MODE_BY_NAME["classic"],
        help=(
            "Learn mode name or byte value. Names: "
            + ", ".join(sorted(MODE_BY_NAME.keys()))
            + " (default: classic)"
        ),
    )
    parser.add_argument(
        "--func-id",
        type=parse_u8,
        default=0x44,
        help="Callback funcID byte in request payload (0 disables callback, default: 0x44)",
    )
    parser.add_argument(
        "--response-timeout",
        type=float,
        default=3.0,
        help="Timeout waiting for immediate RESPONSE frame in seconds (default: 3.0)",
    )
    parser.add_argument(
        "--callback-timeout",
        type=float,
        default=30.0,
        help="Timeout waiting for callback REQUEST frame in seconds (default: 30.0)",
    )
    args = parser.parse_args()

    payload = bytes([args.mode, args.func_id])
    frame = build_request(FUNC_ID_ZW_SET_LEARN_MODE, payload)

    print(f"Port: {args.port} @ {args.baud}")
    print(f"TX FUNC_ID_ZW_SET_LEARN_MODE mode=0x{args.mode:02X} funcID=0x{args.func_id:02X}")
    print(f"TX frame: {format_bytes(frame)}")

    with serial.Serial(args.port, args.baud, timeout=0.2) as ser:
        ser.reset_input_buffer()
        ser.reset_output_buffer()

        ser.write(frame)
        ser.flush()

        ret_val, got_ack = wait_for_response(
            ser=ser,
            timeout_s=args.response_timeout,
        )

        if not got_ack:
            print("Warning: no immediate ACK byte received from NCP for host request")

        if ret_val is None:
            print("Error: timeout waiting for RESPONSE frame for FUNC_ID_ZW_SET_LEARN_MODE")
            return 1

        print(f"Immediate response retVal=0x{ret_val:02X}")

        if args.func_id == 0:
            print("Callback disabled because funcID=0")
            return 0

        print(f"Waiting callback up to {args.callback_timeout:.1f}s...")
        callback_payload = wait_for_callback(
            ser=ser,
            func_id=args.func_id,
            timeout_s=args.callback_timeout,
        )
        if callback_payload is None:
            print("Error: callback timeout")
            return 2

        print(f"Learn mode callback payload: [{format_bytes(callback_payload)}]")
        print(parse_learn_mode_callback(callback_payload))
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
