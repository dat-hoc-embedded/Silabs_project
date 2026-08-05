"""
BLE Binary Frame Protocol — Parser and Builder.

Frame format (Little-Endian):
┌──────────┬────────┬───────────┬─────────┬──────────────┬──────────┐
│ SYNC (2) │ VER(1) │ OPCODE(1) │ LEN (1) │ PAYLOAD(0-N) │ CRC8 (1) │
└──────────┴────────┴───────────┴─────────┴──────────────┴──────────┘

SYNC:    0xAA 0x55
VER:     Protocol version (currently 0x01)
OPCODE:  Message type identifier
LEN:     Payload length in bytes
PAYLOAD: Opcode-specific binary data
CRC8:    CRC-8/MAXIM over VER+OPCODE+LEN+PAYLOAD
"""

from __future__ import annotations

import struct
from dataclasses import dataclass, field
from enum import IntEnum
from typing import Any


# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

SYNC_BYTES = bytes([0xAA, 0x55])
HEADER_SIZE = 5  # SYNC(2) + VER(1) + OPCODE(1) + LEN(1)
CRC_SIZE = 1
MIN_FRAME_SIZE = HEADER_SIZE + CRC_SIZE  # 6 bytes minimum (empty payload)
PROTOCOL_VERSION = 0x01
MAX_PAYLOAD_LEN = 244  # BLE 5.x MTU limit


class Opcode(IntEnum):
    """Known frame opcodes."""
    TELEMETRY = 0x01
    STATUS = 0x02
    COMMAND = 0x03
    ACK = 0x04


class CommandId(IntEnum):
    """Known command IDs for COMMAND opcode."""
    LED_TOGGLE = 0x01
    SET_RATE = 0x02
    RESET = 0x03


# ---------------------------------------------------------------------------
# CRC-8/MAXIM (Dow/Dallas)
# ---------------------------------------------------------------------------

def _build_crc8_table() -> list[int]:
    """Pre-compute CRC-8/MAXIM lookup table (polynomial 0x31, init 0x00)."""
    table = []
    for i in range(256):
        crc = i
        for _ in range(8):
            if crc & 0x80:
                crc = ((crc << 1) ^ 0x31) & 0xFF
            else:
                crc = (crc << 1) & 0xFF
        table.append(crc)
    return table


_CRC8_TABLE = _build_crc8_table()


def crc8_maxim(data: bytes | bytearray) -> int:
    """Calculate CRC-8/MAXIM checksum over *data*."""
    crc = 0x00
    for byte in data:
        crc = _CRC8_TABLE[crc ^ byte]
    return crc


# ---------------------------------------------------------------------------
# Parsed frame data-classes
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class TelemetryPayload:
    """Parsed telemetry data (opcode 0x01)."""
    timestamp_ms: int
    sensor_a: int
    sensor_b: int
    flags: int

    @property
    def led_state(self) -> bool:
        return bool(self.flags & 0x01)

    @property
    def alarm(self) -> bool:
        return bool(self.flags & 0x02)


@dataclass(frozen=True)
class StatusPayload:
    """Parsed status data (opcode 0x02)."""
    battery_pct: int
    fw_major: int
    fw_minor: int
    error_code: int

    @property
    def fw_version_str(self) -> str:
        return f"{self.fw_major}.{self.fw_minor}"


@dataclass(frozen=True)
class CommandPayload:
    """Parsed command data (opcode 0x03)."""
    cmd_id: int
    params: bytes


@dataclass(frozen=True)
class AckPayload:
    """Parsed acknowledgement (opcode 0x04)."""
    acked_opcode: int
    status_code: int


@dataclass(frozen=True)
class ParsedFrame:
    """A fully validated and parsed BLE frame."""
    version: int
    opcode: Opcode
    raw_payload: bytes
    payload: TelemetryPayload | StatusPayload | CommandPayload | AckPayload | None = None

    def to_dict(self) -> dict[str, Any]:
        """Serialize to a flat dictionary for logging."""
        result: dict[str, Any] = {
            "version": self.version,
            "opcode": self.opcode.name,
            "raw_hex": self.raw_payload.hex(),
        }
        if isinstance(self.payload, TelemetryPayload):
            result.update({
                "timestamp_ms": self.payload.timestamp_ms,
                "sensor_a": self.payload.sensor_a,
                "sensor_b": self.payload.sensor_b,
                "flags": self.payload.flags,
                "led_state": self.payload.led_state,
                "alarm": self.payload.alarm,
            })
        elif isinstance(self.payload, StatusPayload):
            result.update({
                "battery_pct": self.payload.battery_pct,
                "fw_version": self.payload.fw_version_str,
                "error_code": self.payload.error_code,
            })
        elif isinstance(self.payload, CommandPayload):
            result.update({
                "cmd_id": self.payload.cmd_id,
                "params_hex": self.payload.params.hex(),
            })
        elif isinstance(self.payload, AckPayload):
            result.update({
                "acked_opcode": self.payload.acked_opcode,
                "status_code": self.payload.status_code,
            })
        return result


# ---------------------------------------------------------------------------
# Payload parsers (private)
# ---------------------------------------------------------------------------

def _parse_telemetry(data: bytes) -> TelemetryPayload | None:
    """Parse 9-byte telemetry payload: uint32 + int16 + int16 + uint8."""
    if len(data) < 9:
        return None
    ts, sa, sb, flags = struct.unpack_from("<IhhB", data)
    return TelemetryPayload(
        timestamp_ms=ts, sensor_a=sa, sensor_b=sb, flags=flags
    )


def _parse_status(data: bytes) -> StatusPayload | None:
    """Parse 5-byte status payload: uint8 × 3 + uint16."""
    if len(data) < 5:
        return None
    batt, fwmaj, fwmin, err = struct.unpack_from("<BBBH", data)
    return StatusPayload(
        battery_pct=batt, fw_major=fwmaj, fw_minor=fwmin, error_code=err
    )


def _parse_command(data: bytes) -> CommandPayload | None:
    """Parse 5-byte command payload: uint8 + 4 bytes params."""
    if len(data) < 5:
        return None
    cmd_id = data[0]
    params = data[1:5]
    return CommandPayload(cmd_id=cmd_id, params=params)


def _parse_ack(data: bytes) -> AckPayload | None:
    """Parse 2-byte ack payload: uint8 + uint8."""
    if len(data) < 2:
        return None
    return AckPayload(acked_opcode=data[0], status_code=data[1])


_PAYLOAD_PARSERS = {
    Opcode.TELEMETRY: _parse_telemetry,
    Opcode.STATUS: _parse_status,
    Opcode.COMMAND: _parse_command,
    Opcode.ACK: _parse_ack,
}


# ---------------------------------------------------------------------------
# FrameParser — PUBLIC API
# ---------------------------------------------------------------------------

class FrameParser:
    """
    Stateful binary frame parser with accumulator buffer.

    Handles partial/fragmented BLE packets by buffering incoming bytes
    and extracting complete frames as they arrive.

    Public API:
        feed(data) -> list[ParsedFrame]   # Feed raw bytes, get parsed frames
        parse(data) -> ParsedFrame | None  # Parse a single complete frame
        reset()                            # Clear the internal buffer
    """

    def __init__(self) -> None:
        self._buffer = bytearray()

    def reset(self) -> None:
        """Clear the accumulator buffer."""
        self._buffer.clear()

    def feed(self, data: bytes | bytearray) -> list[ParsedFrame]:
        """
        Feed raw bytes from a BLE notification into the parser.

        Returns a list of zero or more parsed frames extracted from
        the accumulated buffer. Handles fragmentation and multiple
        frames in a single notification.
        """
        self._buffer.extend(data)
        frames: list[ParsedFrame] = []

        while len(self._buffer) >= MIN_FRAME_SIZE:
            # Search for SYNC bytes
            sync_pos = self._find_sync()
            if sync_pos < 0:
                # No sync found — discard everything except the last byte
                # (which might be the start of a partial SYNC)
                self._buffer = self._buffer[-1:]
                break

            # Discard any garbage before SYNC
            if sync_pos > 0:
                del self._buffer[:sync_pos]

            # Check if we have enough bytes for the header
            if len(self._buffer) < HEADER_SIZE:
                break

            # Extract length field
            payload_len = self._buffer[4]
            frame_total = HEADER_SIZE + payload_len + CRC_SIZE

            # Check if we have the complete frame
            if len(self._buffer) < frame_total:
                break

            # Extract the complete frame
            raw_frame = bytes(self._buffer[:frame_total])
            del self._buffer[:frame_total]

            # Parse it
            parsed = self.parse(raw_frame)
            if parsed is not None:
                frames.append(parsed)

        return frames

    def parse(self, data: bytes | bytearray) -> ParsedFrame | None:
        """
        Parse a single, complete frame from raw bytes.

        Returns ParsedFrame on success, None if the frame is invalid
        (bad sync, bad CRC, unknown version, etc.).
        """
        if len(data) < MIN_FRAME_SIZE:
            return None

        # Validate SYNC
        if data[0] != 0xAA or data[1] != 0x55:
            return None

        version = data[2]
        opcode_byte = data[3]
        payload_len = data[4]

        expected_total = HEADER_SIZE + payload_len + CRC_SIZE
        if len(data) < expected_total:
            return None

        payload = data[HEADER_SIZE : HEADER_SIZE + payload_len]
        received_crc = data[HEADER_SIZE + payload_len]

        # CRC is computed over VER + OPCODE + LEN + PAYLOAD
        crc_data = data[2 : HEADER_SIZE + payload_len]
        computed_crc = crc8_maxim(crc_data)

        if received_crc != computed_crc:
            return None

        # Map opcode
        try:
            opcode = Opcode(opcode_byte)
        except ValueError:
            # Unknown opcode — still return a frame with no parsed payload
            opcode = Opcode(opcode_byte) if opcode_byte in Opcode.__members__.values() else None  # type: ignore
            if opcode is None:
                return ParsedFrame(
                    version=version,
                    opcode=opcode_byte,  # type: ignore
                    raw_payload=bytes(payload),
                    payload=None,
                )

        # Parse payload using the registered parser
        parser_fn = _PAYLOAD_PARSERS.get(opcode)
        parsed_payload = parser_fn(payload) if parser_fn else None

        return ParsedFrame(
            version=version,
            opcode=opcode,
            raw_payload=bytes(payload),
            payload=parsed_payload,
        )

    def _find_sync(self) -> int:
        """Find the position of SYNC_BYTES in the buffer. Returns -1 if not found."""
        try:
            return self._buffer.index(0xAA)
        except ValueError:
            return -1


# ---------------------------------------------------------------------------
# FrameBuilder — PUBLIC API
# ---------------------------------------------------------------------------

class FrameBuilder:
    """
    Build binary frames for transmission to the BLE device.

    Public API:
        build_command(cmd_id, params) -> bytes
        build_raw(opcode, payload) -> bytes
    """

    def __init__(self, version: int = PROTOCOL_VERSION) -> None:
        self._version = version

    def build_command(self, cmd_id: int, params: bytes = b"\x00\x00\x00\x00") -> bytes:
        """
        Build a COMMAND frame (opcode 0x03).

        Args:
            cmd_id: Command identifier (see CommandId enum).
            params: 4 bytes of command parameters (padded with zeros if shorter).

        Returns:
            Complete frame bytes ready for BLE write.
        """
        # Pad or truncate params to exactly 4 bytes
        padded = (params + b"\x00\x00\x00\x00")[:4]
        payload = bytes([cmd_id]) + padded
        return self.build_raw(Opcode.COMMAND, payload)

    def build_raw(self, opcode: int, payload: bytes = b"") -> bytes:
        """
        Build a raw frame with arbitrary opcode and payload.

        Args:
            opcode: Frame opcode byte.
            payload: Payload bytes.

        Returns:
            Complete frame bytes including SYNC, header, and CRC.
        """
        if len(payload) > MAX_PAYLOAD_LEN:
            raise ValueError(
                f"Payload too large: {len(payload)} > {MAX_PAYLOAD_LEN}"
            )

        # Header: SYNC + VER + OPCODE + LEN
        header = SYNC_BYTES + bytes([self._version, opcode, len(payload)])

        # CRC over VER + OPCODE + LEN + PAYLOAD
        crc_data = bytes([self._version, opcode, len(payload)]) + payload
        crc = crc8_maxim(crc_data)

        return header + payload + bytes([crc])
