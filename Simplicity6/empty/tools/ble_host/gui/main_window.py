"""
Main Window — Top-level application container.

Manages the tab layout (Scan, Device, Live, Log), status bar,
and menu bar. Wires all core modules to GUI panels.
"""

from __future__ import annotations

import logging

from PyQt6.QtCore import Qt
from PyQt6.QtGui import QAction
from PyQt6.QtWidgets import (
    QLabel,
    QMainWindow,
    QMenuBar,
    QStatusBar,
    QTabWidget,
    QWidget,
)
from qasync import asyncSlot

from core.connection import BleConnection
from core.logger import DataLogger
from core.protocol import FrameBuilder, ParsedFrame
from core.scanner import BleScanner
from .device_panel import DevicePanel
from .live_panel import LivePanel
from .log_panel import LogPanel
from .scan_panel import ScanPanel
from .styles import COLORS

logger = logging.getLogger(__name__)


class MainWindow(QMainWindow):
    """
    Main application window.

    Orchestrates the BLE core modules and GUI panels through
    signal/slot connections. This is the single public entry
    point for the GUI module.
    """

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)

        # Core modules
        self._scanner = BleScanner(self)
        self._connection = BleConnection(self)
        self._logger = DataLogger(self)
        self._frame_builder = FrameBuilder()

        self._setup_window()
        self._setup_menu()
        self._setup_tabs()
        self._setup_status_bar()
        self._connect_signals()

    def _setup_window(self) -> None:
        """Configure the main window properties."""
        self.setWindowTitle("BLE Host — Silicon Labs EFR32 Tool")
        self.setMinimumSize(1100, 750)
        self.resize(1280, 850)

    def _setup_menu(self) -> None:
        """Create the menu bar."""
        menu_bar = self.menuBar()
        assert menu_bar is not None

        # File menu
        file_menu = menu_bar.addMenu("&File")
        assert file_menu is not None

        export_action = QAction("📤  Export Log...", self)
        export_action.setShortcut("Ctrl+E")
        file_menu.addAction(export_action)

        file_menu.addSeparator()

        quit_action = QAction("❌  Quit", self)
        quit_action.setShortcut("Ctrl+Q")
        quit_action.triggered.connect(self.close)
        file_menu.addAction(quit_action)

        # BLE menu
        ble_menu = menu_bar.addMenu("&BLE")
        assert ble_menu is not None

        scan_action = QAction("🔍  Scan Devices", self)
        scan_action.setShortcut("Ctrl+S")
        scan_action.triggered.connect(self._on_scan_start)
        ble_menu.addAction(scan_action)

        disconnect_action = QAction("🔌  Disconnect", self)
        disconnect_action.setShortcut("Ctrl+D")
        disconnect_action.triggered.connect(self._on_disconnect)
        ble_menu.addAction(disconnect_action)

        # Help menu
        help_menu = menu_bar.addMenu("&Help")
        assert help_menu is not None

        about_action = QAction("ℹ️  About", self)
        about_action.triggered.connect(self._show_about)
        help_menu.addAction(about_action)

    def _setup_tabs(self) -> None:
        """Create the tab widget with all panels."""
        self._tabs = QTabWidget()
        self._tabs.setDocumentMode(True)

        self._scan_panel = ScanPanel()
        self._device_panel = DevicePanel()
        self._live_panel = LivePanel()
        self._log_panel = LogPanel()

        self._tabs.addTab(self._scan_panel, "🔍  Scan")
        self._tabs.addTab(self._device_panel, "📡  Device")
        self._tabs.addTab(self._live_panel, "📊  Live")
        self._tabs.addTab(self._log_panel, "💾  Log")

        self.setCentralWidget(self._tabs)

    def _setup_status_bar(self) -> None:
        """Create the status bar with connection info."""
        status_bar = self.statusBar()
        assert status_bar is not None

        self._status_connection = QLabel("⚫  Disconnected")
        self._status_connection.setStyleSheet(
            f"color: {COLORS['status_disconnected']}; font-weight: 600;"
        )
        status_bar.addWidget(self._status_connection)

        self._status_rssi = QLabel("")
        self._status_rssi.setObjectName("label_muted")
        status_bar.addWidget(self._status_rssi)

        # Right-aligned info
        self._status_info = QLabel("BLE Host v1.0")
        self._status_info.setObjectName("label_muted")
        status_bar.addPermanentWidget(self._status_info)

    def _connect_signals(self) -> None:
        """Wire up all signal/slot connections between core and GUI."""

        # --- Scanner signals ---
        self._scanner.signal_device_found.connect(self._scan_panel.add_device)
        self._scanner.signal_scan_finished.connect(self._on_scan_finished)
        self._scanner.signal_error.connect(self._scan_panel.set_error)

        # --- Scanner UI controls ---
        self._scan_panel.scan_button.clicked.connect(self._on_scan_start)
        self._scan_panel.stop_button.clicked.connect(self._on_scan_stop)
        self._scan_panel.signal_connect_requested.connect(self._on_connect)

        # --- Connection signals ---
        self._connection.signal_connected.connect(self._on_connected)
        self._connection.signal_disconnected.connect(self._on_disconnected)
        self._connection.signal_data_received.connect(
            self._device_panel.append_raw_data
        )
        self._connection.signal_frame_received.connect(self._on_frame_received)
        self._connection.signal_services_discovered.connect(
            self._device_panel.populate_services
        )
        self._connection.signal_error.connect(self._on_error)

        # --- Device panel controls ---
        self._device_panel.discover_button.clicked.connect(
            self._on_discover_services
        )
        self._device_panel.signal_subscribe_requested.connect(
            self._on_subscribe
        )
        self._device_panel.signal_unsubscribe_requested.connect(
            self._on_unsubscribe
        )
        self._device_panel.signal_read_requested.connect(self._on_read)
        self._device_panel.signal_write_requested.connect(self._on_write)

        # --- Logger controls ---
        self._log_panel.start_button.clicked.connect(self._on_log_start)
        self._log_panel.stop_button.clicked.connect(self._on_log_stop)
        self._logger.signal_log_started.connect(
            lambda p: self._log_panel.set_logging(True)
        )
        self._logger.signal_log_stopped.connect(
            lambda: self._log_panel.set_logging(False)
        )

    # =====================================================================
    # Async Slot Handlers
    # =====================================================================

    @asyncSlot()
    async def _on_scan_start(self) -> None:
        """Start BLE scanning."""
        self._scan_panel.clear_devices()
        self._scan_panel.set_scanning(True)
        name_filter = self._scan_panel.name_filter
        await self._scanner.start_scan(timeout=8.0, name_filter=name_filter)

    @asyncSlot()
    async def _on_scan_stop(self) -> None:
        """Stop BLE scanning."""
        await self._scanner.stop_scan()

    def _on_scan_finished(self) -> None:
        """Handle scan completion."""
        self._scan_panel.set_scanning(False)

    @asyncSlot(str)
    async def _on_connect(self, address: str) -> None:
        """Connect to a BLE device."""
        self._status_connection.setText(f"🟡  Connecting to {address}...")
        self._status_connection.setStyleSheet(
            f"color: {COLORS['status_scanning']}; font-weight: 600;"
        )
        await self._connection.connect(address)

    def _on_connected(self, address: str) -> None:
        """Handle successful connection."""
        self._status_connection.setText(f"🟢  Connected: {address}")
        self._status_connection.setStyleSheet(
            f"color: {COLORS['status_connected']}; font-weight: 600;"
        )
        self._device_panel.set_connected(address)
        self._tabs.setCurrentIndex(1)  # Switch to Device tab

    @asyncSlot()
    async def _on_disconnect(self) -> None:
        """Disconnect from the current device."""
        await self._connection.disconnect()

    def _on_disconnected(self, address: str) -> None:
        """Handle disconnection."""
        self._status_connection.setText("⚫  Disconnected")
        self._status_connection.setStyleSheet(
            f"color: {COLORS['status_disconnected']}; font-weight: 600;"
        )
        self._device_panel.set_disconnected()

    @asyncSlot()
    async def _on_discover_services(self) -> None:
        """Discover GATT services on the connected device."""
        await self._connection.discover_services()

    @asyncSlot(str)
    async def _on_subscribe(self, char_uuid: str) -> None:
        """Subscribe to a characteristic."""
        await self._connection.subscribe(char_uuid)

    @asyncSlot(str)
    async def _on_unsubscribe(self, char_uuid: str) -> None:
        """Unsubscribe from a characteristic."""
        await self._connection.unsubscribe(char_uuid)

    @asyncSlot(str)
    async def _on_read(self, char_uuid: str) -> None:
        """Read a characteristic value."""
        data = await self._connection.read(char_uuid)
        if data:
            self._device_panel.append_raw_data(char_uuid, data)

    @asyncSlot(str, bytes)
    async def _on_write(self, char_uuid: str, data: bytes) -> None:
        """Write data to a characteristic."""
        await self._connection.write(char_uuid, data)

    def _on_frame_received(self, frame: ParsedFrame) -> None:
        """Handle a parsed frame from the connection manager."""
        # Forward to live panel
        self._live_panel.add_frame(frame)

        # Forward to logger
        if self._logger.is_logging:
            self._logger.log(frame)
            self._log_panel.update_entry_count(self._logger.entry_count)

            # Add to log preview
            frame_dict = frame.to_dict()
            preview_str = (
                f"[{frame_dict.get('opcode', '?')}] "
                f"{frame_dict.get('raw_hex', '')}"
            )
            self._log_panel.append_preview(preview_str)

    def _on_log_start(self) -> None:
        """Start data logging."""
        filepath = self._log_panel.filepath
        fmt = self._log_panel.log_format
        if filepath:
            self._logger.start(filepath, fmt)

    def _on_log_stop(self) -> None:
        """Stop data logging."""
        self._logger.stop()

    def _on_error(self, message: str) -> None:
        """Handle errors from core modules."""
        logger.error("Core error: %s", message)
        status_bar = self.statusBar()
        if status_bar:
            status_bar.showMessage(f"Error: {message}", 5000)

    def _show_about(self) -> None:
        """Show about dialog (simple status bar message)."""
        status_bar = self.statusBar()
        if status_bar:
            status_bar.showMessage(
                "BLE Host v1.0 — Silicon Labs EFR32MG24 BLE Tool | "
                "Built with Bleak + PyQt6",
                5000,
            )

    def closeEvent(self, event) -> None:
        """Clean up on window close."""
        self._logger.stop()
        # Connection cleanup happens asynchronously via disconnect callback
        super().closeEvent(event)
