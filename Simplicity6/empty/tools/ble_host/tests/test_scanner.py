"""
Unit tests for BLE Scanner module.

Uses mock BleakScanner to test signal emission, filtering, and deduplication
without requiring actual BLE hardware.
"""

from __future__ import annotations

import asyncio
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
import pytest_asyncio

from core.scanner import BleScanner


# ---------------------------------------------------------------------------
# Mock helpers
# ---------------------------------------------------------------------------

def _make_mock_device(name: str, address: str):
    """Create a mock BLEDevice."""
    device = MagicMock()
    device.name = name
    device.address = address
    return device


def _make_mock_adv_data(
    rssi: int = -60,
    local_name: str | None = None,
    service_uuids: list[str] | None = None,
    manufacturer_data: dict | None = None,
    tx_power: int | None = None,
):
    """Create a mock AdvertisementData."""
    adv = MagicMock()
    adv.rssi = rssi
    adv.local_name = local_name
    adv.service_uuids = service_uuids or []
    adv.manufacturer_data = manufacturer_data or {}
    adv.tx_power = tx_power
    return adv


# ===========================================================================
# Tests
# ===========================================================================

class TestBleScanner:
    def setup_method(self):
        self.scanner = BleScanner()

    def test_initial_state(self):
        assert self.scanner.is_scanning is False

    @pytest.mark.asyncio
    async def test_scan_emits_devices(self):
        """Verify that discovered devices trigger signal_device_found."""
        received_devices = []

        def on_device_found(name, address, rssi, adv_data):
            received_devices.append((name, address, rssi))

        self.scanner.signal_device_found.connect(on_device_found)

        mock_device = _make_mock_device("TestDevice", "AA:BB:CC:DD:EE:FF")
        mock_adv = _make_mock_adv_data(rssi=-55)

        with patch("core.scanner._BleakScanner") as MockScanner:
            scanner_instance = AsyncMock()
            MockScanner.return_value = scanner_instance

            # Capture the detection callback
            def capture_callback(**kwargs):
                callback = kwargs.get("detection_callback")
                if callback:
                    # Simulate device discovery
                    callback(mock_device, mock_adv)

            MockScanner.side_effect = lambda **kwargs: (
                capture_callback(**kwargs) or scanner_instance
            )

            # Run scan with very short timeout
            await self.scanner.start_scan(timeout=0.1)

        assert len(received_devices) >= 1
        assert received_devices[0][0] == "TestDevice"
        assert received_devices[0][1] == "AA:BB:CC:DD:EE:FF"
        assert received_devices[0][2] == -55

    @pytest.mark.asyncio
    async def test_scan_finished_signal(self):
        """Verify signal_scan_finished is emitted after scan completes."""
        finished = []

        self.scanner.signal_scan_finished.connect(lambda: finished.append(True))

        with patch("core.scanner._BleakScanner") as MockScanner:
            scanner_instance = AsyncMock()
            MockScanner.return_value = scanner_instance

            await self.scanner.start_scan(timeout=0.1)

        assert len(finished) == 1
        assert self.scanner.is_scanning is False

    @pytest.mark.asyncio
    async def test_deduplication(self):
        """Verify that the same device address is only emitted once."""
        received = []

        self.scanner.signal_device_found.connect(
            lambda name, addr, rssi, adv: received.append(addr)
        )

        mock_device = _make_mock_device("DupDevice", "11:22:33:44:55:66")
        mock_adv = _make_mock_adv_data(rssi=-70)

        with patch("core.scanner._BleakScanner") as MockScanner:
            scanner_instance = AsyncMock()

            def init_scanner(**kwargs):
                cb = kwargs.get("detection_callback")
                if cb:
                    # Simulate same device discovered twice
                    cb(mock_device, mock_adv)
                    cb(mock_device, mock_adv)
                return scanner_instance

            MockScanner.side_effect = init_scanner

            await self.scanner.start_scan(timeout=0.1)

        # Should only have one entry due to deduplication
        assert received.count("11:22:33:44:55:66") == 1

    @pytest.mark.asyncio
    async def test_name_filter(self):
        """Verify name filtering works."""
        received = []

        self.scanner.signal_device_found.connect(
            lambda name, addr, rssi, adv: received.append(name)
        )

        device_a = _make_mock_device("SiLabs_BLE", "AA:00:00:00:00:01")
        device_b = _make_mock_device("OtherDevice", "AA:00:00:00:00:02")
        adv = _make_mock_adv_data(rssi=-60)

        with patch("core.scanner._BleakScanner") as MockScanner:
            scanner_instance = AsyncMock()

            def init_scanner(**kwargs):
                cb = kwargs.get("detection_callback")
                if cb:
                    cb(device_a, adv)
                    cb(device_b, adv)
                return scanner_instance

            MockScanner.side_effect = init_scanner

            await self.scanner.start_scan(timeout=0.1, name_filter="SiLabs")

        assert "SiLabs_BLE" in received
        assert "OtherDevice" not in received

    @pytest.mark.asyncio
    async def test_error_handling(self):
        """Verify error signal on scan failure."""
        errors = []
        self.scanner.signal_error.connect(lambda msg: errors.append(msg))

        with patch("core.scanner._BleakScanner") as MockScanner:
            scanner_instance = AsyncMock()
            scanner_instance.start.side_effect = Exception("Bluetooth adapter not found")
            MockScanner.return_value = scanner_instance

            await self.scanner.start_scan(timeout=0.1)

        assert len(errors) == 1
        assert "Bluetooth adapter not found" in errors[0]
        assert self.scanner.is_scanning is False
