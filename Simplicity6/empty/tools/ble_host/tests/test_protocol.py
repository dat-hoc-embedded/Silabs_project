"""
Unit tests for the BLE frame protocol parser and builder.

Tests cover:
- CRC-8/MAXIM calculation
- Valid frame parsing for all opcodes
- Invalid CRC detection
- Truncated/malformed frame handling
- Frame builder construction
- Round-trip (build → parse) consistency
- Stateful parser feed with fragmentation
"""

import struct

import pytest

from core.protocol import (
    HEADER_SIZE,
    MAX_PAYLOAD_LEN,
    MIN_FRAME_SIZE,
    PROTOCOL_VERSION,
    SYNC_BYTES,
    AckPayload,
    CommandId,
    CommandPayload,
    FrameBuilder,
    FrameParser,
    Opcode,
    StatusPayload,
    TelemetryPayload,
    crc8_maxim,
)


# ---------------------------------------------------------------------------
# Helper to build raw frame bytes
# ---------------------------------------------------------------------------

def _make_frame(opcode: int, payload: bytes, version: int = PROTOCOL_VERSION) -> bytes:
    """Build a raw frame with correct CRC for testing."""
    header = SYNC_BYTES + bytes([version, opcode, len(payload)])
    crc_data = bytes([version, opcode, len(payload)]) + payload
    crc = crc8_maxim(crc_data)
    return header + payload + bytes([crc])


def _make_telemetry_payload(
    ts: int = 1000, sa: int = 123, sb: int = -456, flags: int = 0x03
) -> bytes:
    return struct.pack("<IhhB", ts, sa, sb, flags)


def _make_status_payload(
    batt: int = 85, fwmaj: int = 1, fwmin: int = 2, err: int = 0
) -> bytes:
    return struct.pack("<BBBH", batt, fwmaj, fwmin, err)


def _make_command_payload(cmd_id: int = 0x01, params: bytes = b"\x00\x00\x00\x00") -> bytes:
    return bytes([cmd_id]) + params[:4]


def _make_ack_payload(acked_opcode: int = 0x01, status_code: int = 0x00) -> bytes:
    return bytes([acked_opcode, status_code])


# ===========================================================================
# CRC-8 Tests
# ===========================================================================

class TestCRC8:
    def test_empty(self):
        assert crc8_maxim(b"") == 0x00

    def test_known_values(self):
        # CRC-8/MAXIM of single byte
        result = crc8_maxim(b"\x01")
        assert isinstance(result, int)
        assert 0 <= result <= 255

    def test_deterministic(self):
        data = b"\x01\x02\x03\x04\x05"
        assert crc8_maxim(data) == crc8_maxim(data)

    def test_different_data_different_crc(self):
        assert crc8_maxim(b"\x01\x02") != crc8_maxim(b"\x01\x03")


# ===========================================================================
# FrameParser.parse() Tests — Single Frame
# ===========================================================================

class TestFrameParserSingle:
    def setup_method(self):
        self.parser = FrameParser()

    def test_parse_telemetry(self):
        payload = _make_telemetry_payload(ts=5000, sa=100, sb=-200, flags=0x01)
        raw = _make_frame(Opcode.TELEMETRY, payload)
        frame = self.parser.parse(raw)

        assert frame is not None
        assert frame.opcode == Opcode.TELEMETRY
        assert frame.version == PROTOCOL_VERSION
        assert isinstance(frame.payload, TelemetryPayload)
        assert frame.payload.timestamp_ms == 5000
        assert frame.payload.sensor_a == 100
        assert frame.payload.sensor_b == -200
        assert frame.payload.flags == 0x01
        assert frame.payload.led_state is True
        assert frame.payload.alarm is False

    def test_parse_status(self):
        payload = _make_status_payload(batt=95, fwmaj=2, fwmin=3, err=42)
        raw = _make_frame(Opcode.STATUS, payload)
        frame = self.parser.parse(raw)

        assert frame is not None
        assert frame.opcode == Opcode.STATUS
        assert isinstance(frame.payload, StatusPayload)
        assert frame.payload.battery_pct == 95
        assert frame.payload.fw_major == 2
        assert frame.payload.fw_minor == 3
        assert frame.payload.fw_version_str == "2.3"
        assert frame.payload.error_code == 42

    def test_parse_command(self):
        payload = _make_command_payload(cmd_id=CommandId.LED_TOGGLE, params=b"\xFF\x00\x00\x00")
        raw = _make_frame(Opcode.COMMAND, payload)
        frame = self.parser.parse(raw)

        assert frame is not None
        assert frame.opcode == Opcode.COMMAND
        assert isinstance(frame.payload, CommandPayload)
        assert frame.payload.cmd_id == CommandId.LED_TOGGLE
        assert frame.payload.params == b"\xFF\x00\x00\x00"

    def test_parse_ack(self):
        payload = _make_ack_payload(acked_opcode=0x03, status_code=0x00)
        raw = _make_frame(Opcode.ACK, payload)
        frame = self.parser.parse(raw)

        assert frame is not None
        assert frame.opcode == Opcode.ACK
        assert isinstance(frame.payload, AckPayload)
        assert frame.payload.acked_opcode == 0x03
        assert frame.payload.status_code == 0x00

    def test_reject_bad_sync(self):
        payload = _make_telemetry_payload()
        raw = bytearray(_make_frame(Opcode.TELEMETRY, payload))
        raw[0] = 0xBB  # Corrupt SYNC
        assert self.parser.parse(bytes(raw)) is None

    def test_reject_bad_crc(self):
        payload = _make_telemetry_payload()
        raw = bytearray(_make_frame(Opcode.TELEMETRY, payload))
        raw[-1] ^= 0xFF  # Corrupt CRC
        assert self.parser.parse(bytes(raw)) is None

    def test_reject_truncated(self):
        payload = _make_telemetry_payload()
        raw = _make_frame(Opcode.TELEMETRY, payload)
        assert self.parser.parse(raw[:5]) is None  # Missing payload + CRC
        assert self.parser.parse(raw[:3]) is None  # Missing most of header

    def test_reject_too_short(self):
        assert self.parser.parse(b"") is None
        assert self.parser.parse(b"\xAA") is None
        assert self.parser.parse(b"\xAA\x55") is None

    def test_empty_payload(self):
        raw = _make_frame(Opcode.TELEMETRY, b"")
        frame = self.parser.parse(raw)
        assert frame is not None
        assert frame.payload is None  # Can't parse 0 bytes as telemetry

    def test_to_dict_telemetry(self):
        payload = _make_telemetry_payload(ts=1000, sa=50, sb=-50, flags=0x03)
        raw = _make_frame(Opcode.TELEMETRY, payload)
        frame = self.parser.parse(raw)
        assert frame is not None

        d = frame.to_dict()
        assert d["opcode"] == "TELEMETRY"
        assert d["timestamp_ms"] == 1000
        assert d["sensor_a"] == 50
        assert d["sensor_b"] == -50
        assert d["led_state"] is True
        assert d["alarm"] is True


# ===========================================================================
# FrameParser.feed() Tests — Stateful / Fragmentation
# ===========================================================================

class TestFrameParserFeed:
    def setup_method(self):
        self.parser = FrameParser()

    def test_feed_complete_frame(self):
        payload = _make_telemetry_payload()
        raw = _make_frame(Opcode.TELEMETRY, payload)

        frames = self.parser.feed(raw)
        assert len(frames) == 1
        assert frames[0].opcode == Opcode.TELEMETRY

    def test_feed_two_frames_at_once(self):
        p1 = _make_telemetry_payload(ts=100)
        p2 = _make_status_payload(batt=50)
        raw = _make_frame(Opcode.TELEMETRY, p1) + _make_frame(Opcode.STATUS, p2)

        frames = self.parser.feed(raw)
        assert len(frames) == 2
        assert frames[0].opcode == Opcode.TELEMETRY
        assert frames[1].opcode == Opcode.STATUS

    def test_feed_fragmented(self):
        payload = _make_telemetry_payload()
        raw = _make_frame(Opcode.TELEMETRY, payload)

        # Split frame in half
        mid = len(raw) // 2
        frames1 = self.parser.feed(raw[:mid])
        assert len(frames1) == 0  # Not enough data yet

        frames2 = self.parser.feed(raw[mid:])
        assert len(frames2) == 1
        assert frames2[0].opcode == Opcode.TELEMETRY

    def test_feed_with_garbage_prefix(self):
        payload = _make_telemetry_payload()
        raw = b"\xDE\xAD\xBE\xEF" + _make_frame(Opcode.TELEMETRY, payload)

        frames = self.parser.feed(raw)
        assert len(frames) == 1

    def test_feed_reset(self):
        payload = _make_telemetry_payload()
        raw = _make_frame(Opcode.TELEMETRY, payload)

        # Feed half, then reset
        self.parser.feed(raw[:5])
        self.parser.reset()

        # Feed complete frame
        frames = self.parser.feed(raw)
        assert len(frames) == 1


# ===========================================================================
# FrameBuilder Tests
# ===========================================================================

class TestFrameBuilder:
    def setup_method(self):
        self.builder = FrameBuilder()
        self.parser = FrameParser()

    def test_build_command(self):
        frame = self.builder.build_command(
            CommandId.LED_TOGGLE, b"\x01\x00\x00\x00"
        )
        assert frame[:2] == SYNC_BYTES
        assert frame[2] == PROTOCOL_VERSION
        assert frame[3] == Opcode.COMMAND
        assert frame[4] == 5  # payload length

    def test_build_command_pads_params(self):
        frame = self.builder.build_command(CommandId.RESET, b"\x01")
        # Params should be padded to 4 bytes
        assert frame[4] == 5  # 1 (cmd_id) + 4 (params)

    def test_build_raw(self):
        frame = self.builder.build_raw(0xFF, b"\x01\x02\x03")
        assert frame[:2] == SYNC_BYTES
        assert len(frame) == HEADER_SIZE + 3 + 1  # header + payload + CRC

    def test_build_raw_rejects_oversized_payload(self):
        with pytest.raises(ValueError):
            self.builder.build_raw(0x01, b"\x00" * (MAX_PAYLOAD_LEN + 1))

    def test_roundtrip_command(self):
        """Build a command frame, then parse it — should succeed."""
        built = self.builder.build_command(CommandId.SET_RATE, b"\x0A\x00\x00\x00")
        parsed = self.parser.parse(built)

        assert parsed is not None
        assert parsed.opcode == Opcode.COMMAND
        assert isinstance(parsed.payload, CommandPayload)
        assert parsed.payload.cmd_id == CommandId.SET_RATE

    def test_roundtrip_raw_telemetry(self):
        """Build a raw telemetry frame, parse it back."""
        payload = _make_telemetry_payload(ts=9999, sa=32767, sb=-32768, flags=0xFF)
        built = self.builder.build_raw(Opcode.TELEMETRY, payload)
        parsed = self.parser.parse(built)

        assert parsed is not None
        assert parsed.opcode == Opcode.TELEMETRY
        assert isinstance(parsed.payload, TelemetryPayload)
        assert parsed.payload.timestamp_ms == 9999
        assert parsed.payload.sensor_a == 32767
        assert parsed.payload.sensor_b == -32768
