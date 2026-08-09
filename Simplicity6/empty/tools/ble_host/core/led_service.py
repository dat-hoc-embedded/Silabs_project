"""
LED Service — High-level API for controlling the Embeddat_BLE LED.

Wraps BleConnection with domain-specific methods for the custom
LED Control GATT service. Handles UUID mapping, byte encoding,
and notification subscription.

Public API:
    LED_SERVICE_UUID
    LED_STATE_UUID
    BLINK_INTERVAL_UUID
    LedState (enum)
    LedService
        read_led_state() -> bool
        write_led_state(on: bool) -> None
        toggle_led() -> None
        read_blink_interval() -> int
        write_blink_interval(ms: int) -> None
        subscribe_led_state(callback) -> None
        unsubscribe_led_state() -> None
"""

from __future__ import annotations

import asyncio
import logging
import struct
from enum import IntEnum
from typing import Callable

from PyQt6.QtCore import QObject, pyqtSignal

from .connection import BleConnection

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Custom GATT UUIDs (must match the GATT Configurator in firmware)
# ---------------------------------------------------------------------------

LED_SERVICE_UUID = "e1bedda7-0001-4000-8000-000000000000"
LED_STATE_UUID = "e1bedda7-0002-4000-8000-000000000000"
BLINK_INTERVAL_UUID = "e1bedda7-0003-4000-8000-000000000000"

# Device name to search for when scanning.
DEVICE_NAME = "Embeddat_BLE"


class LedState(IntEnum):
    """LED command values matching the firmware protocol."""

    OFF = 0x00
    ON = 0x01
    TOGGLE = 0x02


# ---------------------------------------------------------------------------
# LedService — PUBLIC API
# ---------------------------------------------------------------------------


class LedService(QObject):
    """
    High-level BLE LED control service.

    Provides async methods to read/write the LED state and blink
    interval on the connected Embeddat_BLE device. Supports
    notification subscription for real-time LED state changes.

    Args:
        connection: An active BleConnection instance.
        parent: Optional Qt parent.
    """

    signal_led_state_changed = pyqtSignal(bool)  # True = ON, False = OFF

    def __init__(
        self,
        connection: BleConnection,
        parent: QObject | None = None,
    ) -> None:
        super().__init__(parent)
        self._conn = connection
        self._subscribed = False

    # ── LED State ─────────────────────────────────────────────────

    async def read_led_state(self) -> bool:
        """
        Read the current LED state from the device.

        Returns:
            True if LED is ON, False if OFF.
        """
        data = await self._conn.read(LED_STATE_UUID)
        if len(data) >= 1:
            state = bool(data[0])
            logger.debug("LED state read: %s", "ON" if state else "OFF")
            return state
        logger.warning("LED state read returned empty data")
        return False

    async def write_led_state(self, on: bool) -> None:
        """
        Set the LED to ON or OFF.

        Args:
            on: True to turn ON, False to turn OFF.
        """
        cmd = LedState.ON if on else LedState.OFF
        await self._conn.write(LED_STATE_UUID, bytes([cmd]))
        logger.info("LED state written: %s", "ON" if on else "OFF")

    async def toggle_led(self) -> None:
        """Toggle the LED between ON and OFF."""
        await self._conn.write(LED_STATE_UUID, bytes([LedState.TOGGLE]))
        logger.info("LED toggle sent")

    # ── Blink Interval ────────────────────────────────────────────

    async def read_blink_interval(self) -> int:
        """
        Read the current blink interval from the device.

        Returns:
            Blink interval in milliseconds.
        """
        data = await self._conn.read(BLINK_INTERVAL_UUID)
        if len(data) >= 2:
            interval = struct.unpack("<H", data[:2])[0]
            logger.debug("Blink interval read: %d ms", interval)
            return interval
        logger.warning("Blink interval read returned insufficient data")
        return 500  # Fallback to default

    async def write_blink_interval(self, ms: int) -> None:
        """
        Set a new blink interval.

        Args:
            ms: Interval in milliseconds (50–10000).

        Raises:
            ValueError: If ms is out of the valid range.
        """
        if not 50 <= ms <= 10000:
            raise ValueError(
                f"Blink interval must be 50–10000 ms, got {ms}"
            )
        payload = struct.pack("<H", ms)
        await self._conn.write(BLINK_INTERVAL_UUID, payload)
        logger.info("Blink interval written: %d ms", ms)

    # ── Notifications ─────────────────────────────────────────────

    async def subscribe_led_state(
        self,
        callback: Callable[[bool], None] | None = None,
    ) -> None:
        """
        Subscribe to LED state change notifications.

        When the LED state changes on the device, the
        signal_led_state_changed signal is emitted with the new state.

        Args:
            callback: Optional additional callback(on: bool).
        """
        if self._subscribed:
            logger.warning("Already subscribed to LED state notifications")
            return

        def _on_data(char_uuid: str, raw: bytes) -> None:
            if char_uuid.lower() == LED_STATE_UUID.lower() and len(raw) >= 1:
                state = bool(raw[0])
                self.signal_led_state_changed.emit(state)
                if callback is not None:
                    callback(state)

        self._conn.signal_data_received.connect(_on_data)
        await self._conn.subscribe(LED_STATE_UUID)
        self._subscribed = True
        logger.info("Subscribed to LED state notifications")

    async def unsubscribe_led_state(self) -> None:
        """Stop receiving LED state notifications."""
        if not self._subscribed:
            return
        await self._conn.unsubscribe(LED_STATE_UUID)
        self._subscribed = False
        logger.info("Unsubscribed from LED state notifications")
