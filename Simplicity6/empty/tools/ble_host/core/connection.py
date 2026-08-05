"""
BLE Connection Manager — GATT operations with Qt signal integration.

Wraps Bleak's BleakClient for connect/disconnect, GATT service discovery,
characteristic read/write, and notification subscription. Integrates the
FrameParser to auto-parse incoming binary frames.

Public API:
    signal_connected(address)
    signal_disconnected(address)
    signal_data_received(char_uuid, raw_bytes)
    signal_frame_received(ParsedFrame)
    signal_services_discovered(list[GattServiceInfo])
    signal_error(error_message)
    connect(address) -> None
    disconnect() -> None
    discover_services() -> list[GattServiceInfo]
    subscribe(char_uuid) -> None
    unsubscribe(char_uuid) -> None
    write(char_uuid, data) -> None
    read(char_uuid) -> bytes
    is_connected -> bool
    connected_address -> str | None
"""

from __future__ import annotations

import asyncio
import logging
from dataclasses import dataclass, field
from typing import Any

from bleak import BleakClient
from bleak.backends.characteristic import BleakGATTCharacteristic
from PyQt6.QtCore import QObject, pyqtSignal

from .protocol import FrameParser, ParsedFrame

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# GATT info data-classes
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class GattCharacteristicInfo:
    """Describes a single GATT characteristic."""
    uuid: str
    handle: int
    properties: list[str]
    description: str


@dataclass(frozen=True)
class GattServiceInfo:
    """Describes a GATT service and its characteristics."""
    uuid: str
    handle: int
    description: str
    characteristics: list[GattCharacteristicInfo] = field(default_factory=list)


# ---------------------------------------------------------------------------
# BleConnection — PUBLIC API
# ---------------------------------------------------------------------------

class BleConnection(QObject):
    """
    Async BLE connection manager with GATT operations.

    Integrates FrameParser to automatically parse incoming notification
    data into ParsedFrame objects.
    """

    # Signals
    signal_connected = pyqtSignal(str)           # address
    signal_disconnected = pyqtSignal(str)        # address
    signal_data_received = pyqtSignal(str, bytes)  # char_uuid, raw_bytes
    signal_frame_received = pyqtSignal(object)   # ParsedFrame
    signal_services_discovered = pyqtSignal(list)  # list[GattServiceInfo]
    signal_rssi_updated = pyqtSignal(int)        # rssi value
    signal_error = pyqtSignal(str)               # error message

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._client: BleakClient | None = None
        self._address: str | None = None
        self._parser = FrameParser()
        self._subscribed_chars: set[str] = set()

    @property
    def is_connected(self) -> bool:
        """Whether a device is currently connected."""
        return self._client is not None and self._client.is_connected

    @property
    def connected_address(self) -> str | None:
        """The address of the currently connected device, or None."""
        return self._address if self.is_connected else None

    def _on_disconnect(self, client: BleakClient) -> None:
        """Internal disconnect callback from Bleak."""
        address = self._address or "unknown"
        logger.info("Disconnected from %s", address)
        self._parser.reset()
        self._subscribed_chars.clear()
        self.signal_disconnected.emit(address)
        self._client = None
        self._address = None

    async def connect(self, address: str) -> None:
        """
        Connect to a BLE device by address (MAC or UUID).

        Args:
            address: Device address string.
        """
        if self.is_connected:
            await self.disconnect()

        try:
            self._address = address
            self._parser.reset()
            self._client = BleakClient(
                address,
                disconnected_callback=self._on_disconnect,
            )
            await self._client.connect()
            logger.info("Connected to %s", address)
            self.signal_connected.emit(address)
        except Exception as exc:
            error_msg = f"Connection failed ({address}): {exc}"
            logger.error(error_msg)
            self._client = None
            self._address = None
            self.signal_error.emit(error_msg)

    async def disconnect(self) -> None:
        """Disconnect from the current device."""
        if self._client is not None:
            try:
                if self._client.is_connected:
                    await self._client.disconnect()
            except Exception as exc:
                logger.warning("Error during disconnect: %s", exc)
            finally:
                self._client = None
                self._address = None
                self._parser.reset()
                self._subscribed_chars.clear()

    async def discover_services(self) -> list[GattServiceInfo]:
        """
        Discover all GATT services and characteristics on the connected device.

        Returns:
            List of GattServiceInfo describing the device's GATT table.
        """
        if not self.is_connected or self._client is None:
            self.signal_error.emit("Not connected — cannot discover services")
            return []

        services_info: list[GattServiceInfo] = []

        try:
            for service in self._client.services:
                chars: list[GattCharacteristicInfo] = []
                for char in service.characteristics:
                    chars.append(GattCharacteristicInfo(
                        uuid=char.uuid,
                        handle=char.handle,
                        properties=char.properties,
                        description=char.description or "",
                    ))
                services_info.append(GattServiceInfo(
                    uuid=service.uuid,
                    handle=service.handle,
                    description=service.description or "",
                    characteristics=chars,
                ))

            self.signal_services_discovered.emit(services_info)
            logger.info("Discovered %d services", len(services_info))
        except Exception as exc:
            error_msg = f"Service discovery failed: {exc}"
            logger.error(error_msg)
            self.signal_error.emit(error_msg)

        return services_info

    async def subscribe(self, char_uuid: str) -> None:
        """
        Subscribe to notifications from a characteristic.

        Incoming data is automatically fed through the FrameParser.

        Args:
            char_uuid: UUID of the characteristic to subscribe to.
        """
        if not self.is_connected or self._client is None:
            self.signal_error.emit("Not connected — cannot subscribe")
            return

        if char_uuid in self._subscribed_chars:
            logger.warning("Already subscribed to %s", char_uuid)
            return

        def _notification_handler(
            characteristic: BleakGATTCharacteristic, data: bytearray
        ) -> None:
            """Handle incoming BLE notification."""
            raw = bytes(data)
            self.signal_data_received.emit(char_uuid, raw)

            # Try to parse as protocol frame
            frames = self._parser.feed(raw)
            for frame in frames:
                self.signal_frame_received.emit(frame)

        try:
            await self._client.start_notify(char_uuid, _notification_handler)
            self._subscribed_chars.add(char_uuid)
            logger.info("Subscribed to notifications on %s", char_uuid)
        except Exception as exc:
            error_msg = f"Subscribe failed ({char_uuid}): {exc}"
            logger.error(error_msg)
            self.signal_error.emit(error_msg)

    async def unsubscribe(self, char_uuid: str) -> None:
        """Stop receiving notifications from a characteristic."""
        if not self.is_connected or self._client is None:
            return

        if char_uuid not in self._subscribed_chars:
            return

        try:
            await self._client.stop_notify(char_uuid)
            self._subscribed_chars.discard(char_uuid)
            logger.info("Unsubscribed from %s", char_uuid)
        except Exception as exc:
            logger.warning("Unsubscribe error (%s): %s", char_uuid, exc)

    async def write(self, char_uuid: str, data: bytes) -> None:
        """
        Write data to a characteristic.

        Args:
            char_uuid: UUID of the target characteristic.
            data: Bytes to write.
        """
        if not self.is_connected or self._client is None:
            self.signal_error.emit("Not connected — cannot write")
            return

        try:
            await self._client.write_gatt_char(char_uuid, data, response=True)
            logger.debug("Wrote %d bytes to %s", len(data), char_uuid)
        except Exception as exc:
            error_msg = f"Write failed ({char_uuid}): {exc}"
            logger.error(error_msg)
            self.signal_error.emit(error_msg)

    async def read(self, char_uuid: str) -> bytes:
        """
        Read data from a characteristic.

        Args:
            char_uuid: UUID of the target characteristic.

        Returns:
            Raw bytes read from the characteristic.
        """
        if not self.is_connected or self._client is None:
            self.signal_error.emit("Not connected — cannot read")
            return b""

        try:
            data = await self._client.read_gatt_char(char_uuid)
            logger.debug("Read %d bytes from %s", len(data), char_uuid)
            return bytes(data)
        except Exception as exc:
            error_msg = f"Read failed ({char_uuid}): {exc}"
            logger.error(error_msg)
            self.signal_error.emit(error_msg)
            return b""
