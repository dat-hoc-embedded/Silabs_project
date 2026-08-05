"""
Scan Panel — BLE device scanner UI.

Displays a table of discovered BLE devices with scan controls
and name filtering. Double-click a row to request connection.

Signals:
    signal_connect_requested(address: str)
"""

from __future__ import annotations

from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtGui import QColor, QIcon
from PyQt6.QtWidgets import (
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QLineEdit,
    QPushButton,
    QTableWidget,
    QTableWidgetItem,
    QVBoxLayout,
    QWidget,
)

from .styles import COLORS


class ScanPanel(QWidget):
    """BLE device scanner panel with table, filter, and scan controls."""

    signal_connect_requested = pyqtSignal(str)  # device address

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._setup_ui()

    def _setup_ui(self) -> None:
        layout = QVBoxLayout(self)
        layout.setContentsMargins(16, 16, 16, 16)
        layout.setSpacing(12)

        # --- Header ---
        header = QLabel("🔍  BLE Device Scanner")
        header.setObjectName("label_section")
        layout.addWidget(header)

        # --- Controls Row ---
        controls = QHBoxLayout()
        controls.setSpacing(8)

        self._filter_input = QLineEdit()
        self._filter_input.setPlaceholderText("Filter by device name...")
        self._filter_input.setClearButtonEnabled(True)
        self._filter_input.setMinimumWidth(250)
        controls.addWidget(self._filter_input)

        self._scan_btn = QPushButton("⚡  Start Scan")
        self._scan_btn.setObjectName("btn_primary")
        self._scan_btn.setMinimumWidth(140)
        self._scan_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        controls.addWidget(self._scan_btn)

        self._stop_btn = QPushButton("⏹  Stop")
        self._stop_btn.setObjectName("btn_danger")
        self._stop_btn.setEnabled(False)
        self._stop_btn.setMinimumWidth(100)
        self._stop_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        controls.addWidget(self._stop_btn)

        controls.addStretch()

        self._status_label = QLabel("Ready")
        self._status_label.setObjectName("label_muted")
        controls.addWidget(self._status_label)

        layout.addLayout(controls)

        # --- Device Table ---
        self._table = QTableWidget()
        self._table.setColumnCount(5)
        self._table.setHorizontalHeaderLabels(
            ["Name", "Address", "RSSI (dBm)", "Type", "Service UUIDs"]
        )
        self._table.horizontalHeader().setSectionResizeMode(
            0, QHeaderView.ResizeMode.Stretch
        )
        self._table.horizontalHeader().setSectionResizeMode(
            1, QHeaderView.ResizeMode.ResizeToContents
        )
        self._table.horizontalHeader().setSectionResizeMode(
            2, QHeaderView.ResizeMode.ResizeToContents
        )
        self._table.horizontalHeader().setSectionResizeMode(
            3, QHeaderView.ResizeMode.ResizeToContents
        )
        self._table.horizontalHeader().setSectionResizeMode(
            4, QHeaderView.ResizeMode.Stretch
        )
        self._table.setAlternatingRowColors(True)
        self._table.setSelectionBehavior(
            QTableWidget.SelectionBehavior.SelectRows
        )
        self._table.setSelectionMode(
            QTableWidget.SelectionMode.SingleSelection
        )
        self._table.verticalHeader().setVisible(False)
        self._table.setEditTriggers(QTableWidget.EditTrigger.NoEditTriggers)
        self._table.setSortingEnabled(True)
        self._table.doubleClicked.connect(self._on_double_click)

        layout.addWidget(self._table)

        # --- Footer info ---
        self._device_count_label = QLabel("0 devices found")
        self._device_count_label.setObjectName("label_muted")
        layout.addWidget(self._device_count_label)

    # ----- Public API -----

    @property
    def scan_button(self) -> QPushButton:
        return self._scan_btn

    @property
    def stop_button(self) -> QPushButton:
        return self._stop_btn

    @property
    def name_filter(self) -> str:
        return self._filter_input.text().strip()

    def clear_devices(self) -> None:
        """Clear all rows from the device table."""
        self._table.setRowCount(0)
        self._device_count_label.setText("0 devices found")

    def add_device(
        self, name: str, address: str, rssi: int, adv_data: dict
    ) -> None:
        """Add a discovered device to the table."""
        row = self._table.rowCount()
        self._table.insertRow(row)

        # Name
        name_item = QTableWidgetItem(name)
        name_item.setToolTip(name)
        self._table.setItem(row, 0, name_item)

        # Address
        addr_item = QTableWidgetItem(address)
        addr_item.setToolTip(address)
        self._table.setItem(row, 1, addr_item)

        # RSSI with color coding
        rssi_item = QTableWidgetItem(str(rssi))
        rssi_item.setTextAlignment(
            Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignVCenter
        )
        if rssi >= -60:
            rssi_item.setForeground(QColor(COLORS["accent_green"]))
        elif rssi >= -80:
            rssi_item.setForeground(QColor(COLORS["accent_orange"]))
        else:
            rssi_item.setForeground(QColor(COLORS["accent_red"]))
        self._table.setItem(row, 2, rssi_item)

        # Type
        dev_type = "BLE"
        if adv_data.get("service_uuids"):
            dev_type = "BLE (GATT)"
        type_item = QTableWidgetItem(dev_type)
        type_item.setTextAlignment(
            Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignVCenter
        )
        self._table.setItem(row, 3, type_item)

        # Service UUIDs
        uuids = adv_data.get("service_uuids", [])
        uuid_str = ", ".join(uuids[:3])
        if len(uuids) > 3:
            uuid_str += f" (+{len(uuids) - 3} more)"
        uuid_item = QTableWidgetItem(uuid_str)
        uuid_item.setToolTip("\n".join(uuids))
        self._table.setItem(row, 4, uuid_item)

        # Update counter
        count = self._table.rowCount()
        self._device_count_label.setText(f"{count} device{'s' if count != 1 else ''} found")

    def set_scanning(self, scanning: bool) -> None:
        """Update UI state based on scanning status."""
        self._scan_btn.setEnabled(not scanning)
        self._stop_btn.setEnabled(scanning)
        self._filter_input.setEnabled(not scanning)

        if scanning:
            self._status_label.setText("Scanning...")
            self._status_label.setObjectName("label_status_scanning")
        else:
            self._status_label.setText("Ready")
            self._status_label.setObjectName("label_muted")

        # Force style refresh
        self._status_label.setStyleSheet(self._status_label.styleSheet())

    def set_error(self, message: str) -> None:
        """Display an error message."""
        self._status_label.setText(f"Error: {message}")
        self._status_label.setObjectName("label_status_disconnected")
        self._status_label.setStyleSheet(self._status_label.styleSheet())

    # ----- Private -----

    def _on_double_click(self) -> None:
        """Handle double-click on a table row."""
        row = self._table.currentRow()
        if row >= 0:
            address_item = self._table.item(row, 1)
            if address_item:
                self.signal_connect_requested.emit(address_item.text())
