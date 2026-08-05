"""
Unit tests for BLE Connection module.

Uses mock BleakClient to test connection lifecycle, GATT operations,
notification handling, and frame parsing integration.
"""

from __future__ import annotations

import asyncio
from unittest.mock import AsyncMock, MagicMock, PropertyMock, patch

import pytest

from core.connection import BleConnection, GattServiceInfo, GattCharacteristicInfo
from core.protocol import FrameBuilder, Opcode, ParsedFrame, TelemetryPayload


# ---------------------------------------------------------------------------
# Mock helpers
# ---------------------------------------------------------------------------

def _make_mock_characteristic(
    uuid: str = "00002a19-0000-1000-8000-00805f9b34fb",
    handle: int = 10,
    properties: list[str] | None = None,
    description: str = "",
):
    char = MagicMock()
    char.uuid = uuid
    char.handle = handle
    char.properties = properties or ["read", "notify"]
    char.description = description
    return char


def _make_mock_service(
    uuid: str = "0000180f-0000-1000-8000-00805f9b34fb",
    handle: int = 1,
    description: str = "Battery Service",
    characteristics: list | None = None,
):
    svc = MagicMock()
    svc.uuid = uuid
    svc.handle = handle
    svc.description = description
    svc.characteristics = characteristics or []
    return svc


# ===========================================================================
# Tests
# ===========================================================================

class TestBleConnection:
    def setup_method(self):
        self.conn = BleConnection()

    def test_initial_state(self):
        assert self.conn.is_connected is False
        assert self.conn.connected_address is None

    @pytest.mark.asyncio
    async def test_connect_success(self):
        """Verify successful connection emits signal_connected."""
        connected_addresses = []
        self.conn.signal_connected.connect(
            lambda addr: connected_addresses.append(addr)
        )

        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            type(client_instance).is_connected = PropertyMock(return_value=True)
            MockClient.return_value = client_instance

            await self.conn.connect("AA:BB:CC:DD:EE:FF")

        assert len(connected_addresses) == 1
        assert connected_addresses[0] == "AA:BB:CC:DD:EE:FF"

    @pytest.mark.asyncio
    async def test_connect_failure(self):
        """Verify connection failure emits signal_error."""
        errors = []
        self.conn.signal_error.connect(lambda msg: errors.append(msg))

        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            client_instance.connect.side_effect = Exception("Connection refused")
            MockClient.return_value = client_instance

            await self.conn.connect("AA:BB:CC:DD:EE:FF")

        assert len(errors) == 1
        assert "Connection refused" in errors[0]
        assert self.conn.is_connected is False

    @pytest.mark.asyncio
    async def test_disconnect(self):
        """Verify disconnect clears state."""
        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            type(client_instance).is_connected = PropertyMock(return_value=True)
            MockClient.return_value = client_instance

            await self.conn.connect("AA:BB:CC:DD:EE:FF")
            await self.conn.disconnect()

        assert self.conn.connected_address is None

    @pytest.mark.asyncio
    async def test_discover_services(self):
        """Verify service discovery emits signal_services_discovered."""
        discovered = []
        self.conn.signal_services_discovered.connect(
            lambda svcs: discovered.extend(svcs)
        )

        mock_char = _make_mock_characteristic()
        mock_service = _make_mock_service(characteristics=[mock_char])

        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            type(client_instance).is_connected = PropertyMock(return_value=True)
            type(client_instance).services = PropertyMock(
                return_value=[mock_service]
            )
            MockClient.return_value = client_instance

            await self.conn.connect("AA:BB:CC:DD:EE:FF")
            services = await self.conn.discover_services()

        assert len(services) == 1
        assert len(discovered) == 1
        assert isinstance(discovered[0], GattServiceInfo)
        assert len(discovered[0].characteristics) == 1

    @pytest.mark.asyncio
    async def test_write(self):
        """Verify write_gatt_char is called with correct data."""
        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            type(client_instance).is_connected = PropertyMock(return_value=True)
            MockClient.return_value = client_instance

            await self.conn.connect("AA:BB:CC:DD:EE:FF")
            await self.conn.write("uuid-1234", b"\x01\x02\x03")

        client_instance.write_gatt_char.assert_called_once_with(
            "uuid-1234", b"\x01\x02\x03", response=True
        )

    @pytest.mark.asyncio
    async def test_read(self):
        """Verify read returns data from BleakClient."""
        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            type(client_instance).is_connected = PropertyMock(return_value=True)
            client_instance.read_gatt_char.return_value = bytearray(b"\xAA\xBB")
            MockClient.return_value = client_instance

            await self.conn.connect("AA:BB:CC:DD:EE:FF")
            data = await self.conn.read("uuid-1234")

        assert data == b"\xAA\xBB"

    @pytest.mark.asyncio
    async def test_subscribe_notification(self):
        """Verify notification subscription and frame parsing."""
        frames_received = []
        self.conn.signal_frame_received.connect(
            lambda f: frames_received.append(f)
        )

        # Build a valid telemetry frame to simulate notification
        builder = FrameBuilder()
        import struct
        telemetry_payload = struct.pack("<IhhB", 1000, 100, -200, 0x01)
        frame_bytes = builder.build_raw(Opcode.TELEMETRY, telemetry_payload)

        with patch("core.connection.BleakClient") as MockClient:
            client_instance = AsyncMock()
            type(client_instance).is_connected = PropertyMock(return_value=True)
            MockClient.return_value = client_instance

            # Capture the notification callback
            notification_callback = None

            async def mock_start_notify(uuid, callback):
                nonlocal notification_callback
                notification_callback = callback

            client_instance.start_notify.side_effect = mock_start_notify

            await self.conn.connect("AA:BB:CC:DD:EE:FF")
            await self.conn.subscribe("uuid-notify")

            # Simulate a notification
            assert notification_callback is not None
            mock_char = MagicMock()
            mock_char.uuid = "uuid-notify"
            notification_callback(mock_char, bytearray(frame_bytes))

        assert len(frames_received) == 1
        assert isinstance(frames_received[0], ParsedFrame)
        assert frames_received[0].opcode == Opcode.TELEMETRY
        assert isinstance(frames_received[0].payload, TelemetryPayload)
        assert frames_received[0].payload.sensor_a == 100

    @pytest.mark.asyncio
    async def test_operations_when_disconnected(self):
        """Verify operations emit errors when not connected."""
        errors = []
        self.conn.signal_error.connect(lambda msg: errors.append(msg))

        await self.conn.write("uuid", b"\x01")
        assert any("Not connected" in e for e in errors)

        errors.clear()
        data = await self.conn.read("uuid")
        assert data == b""
        assert any("Not connected" in e for e in errors)
