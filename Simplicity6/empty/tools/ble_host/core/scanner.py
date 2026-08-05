"""
BLE Scanner — Async BLE device discovery with Qt signal integration.

Wraps Bleak's BleakScanner with PyQt6 signals for UI integration.
Supports name/address filtering and continuous scanning.

Public API:
    signal_device_found(name, address, rssi, adv_data_dict)
    signal_scan_finished()
    signal_error(error_message)
    start_scan(timeout, name_filter) -> None
    stop_scan() -> None
    is_scanning -> bool
"""

from __future__ import annotations

import asyncio
import logging
from typing import Any

from bleak import BleakScanner as _BleakScanner
from bleak.backends.device import BLEDevice
from bleak.backends.scanner import AdvertisementData
from PyQt6.QtCore import QObject, pyqtSignal

logger = logging.getLogger(__name__)


class BleScanner(QObject):
    """
    Async BLE device scanner with PyQt6 signal integration.

    Emits signals for each discovered device and when scanning completes.
    Uses Bleak's detection callback for real-time device discovery.
    """

    # Signals
    signal_device_found = pyqtSignal(str, str, int, dict)  # name, address, rssi, adv_data
    signal_scan_finished = pyqtSignal()
    signal_error = pyqtSignal(str)

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._scanner: _BleakScanner | None = None
        self._is_scanning = False
        self._scan_task: asyncio.Task | None = None
        self._seen_addresses: set[str] = set()

    @property
    def is_scanning(self) -> bool:
        """Whether a scan is currently in progress."""
        return self._is_scanning

    async def start_scan(
        self,
        timeout: float = 5.0,
        name_filter: str = "",
    ) -> None:
        """
        Start scanning for BLE devices.

        Args:
            timeout: Scan duration in seconds.
            name_filter: If non-empty, only emit devices whose name
                         contains this substring (case-insensitive).
        """
        if self._is_scanning:
            logger.warning("Scan already in progress, ignoring start_scan()")
            return

        self._is_scanning = True
        self._seen_addresses.clear()
        name_filter_lower = name_filter.lower()

        def _detection_callback(
            device: BLEDevice, adv_data: AdvertisementData
        ) -> None:
            """Called by Bleak for each advertisement received."""
            address = device.address
            if address in self._seen_addresses:
                return
            self._seen_addresses.add(address)

            name = device.name or adv_data.local_name or "Unknown"

            # Apply name filter
            if name_filter_lower and name_filter_lower not in name.lower():
                return

            rssi = adv_data.rssi if adv_data.rssi is not None else -999

            # Build advertisement data dict
            adv_dict: dict[str, Any] = {
                "local_name": adv_data.local_name,
                "manufacturer_data": {
                    str(k): v.hex() for k, v in adv_data.manufacturer_data.items()
                },
                "service_uuids": adv_data.service_uuids,
                "tx_power": adv_data.tx_power,
            }

            logger.debug("Found device: %s (%s) RSSI=%d", name, address, rssi)
            self.signal_device_found.emit(name, address, rssi, adv_dict)

        try:
            self._scanner = _BleakScanner(detection_callback=_detection_callback)
            await self._scanner.start()
            await asyncio.sleep(timeout)
            await self._scanner.stop()
        except Exception as exc:
            error_msg = f"BLE scan error: {exc}"
            logger.error(error_msg)
            self.signal_error.emit(error_msg)
        finally:
            self._is_scanning = False
            self._scanner = None
            self.signal_scan_finished.emit()

    async def stop_scan(self) -> None:
        """Stop an ongoing scan."""
        if self._scanner is not None and self._is_scanning:
            try:
                await self._scanner.stop()
            except Exception as exc:
                logger.warning("Error stopping scan: %s", exc)
            finally:
                self._is_scanning = False
                self._scanner = None
                self.signal_scan_finished.emit()
