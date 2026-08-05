"""
Device Panel — GATT service explorer and characteristic interaction.

Displays a tree view of all GATT services and characteristics.
Provides read, write, and subscribe controls for each characteristic.
"""

from __future__ import annotations

from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtWidgets import (
    QComboBox,
    QGroupBox,
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QLineEdit,
    QPushButton,
    QSplitter,
    QTextEdit,
    QTreeWidget,
    QTreeWidgetItem,
    QVBoxLayout,
    QWidget,
)

from .styles import COLORS


class DevicePanel(QWidget):
    """GATT service/characteristic explorer panel."""

    signal_subscribe_requested = pyqtSignal(str)       # char_uuid
    signal_unsubscribe_requested = pyqtSignal(str)     # char_uuid
    signal_read_requested = pyqtSignal(str)            # char_uuid
    signal_write_requested = pyqtSignal(str, bytes)    # char_uuid, data

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._subscribed_uuids: set[str] = set()
        self._setup_ui()

    def _setup_ui(self) -> None:
        layout = QVBoxLayout(self)
        layout.setContentsMargins(16, 16, 16, 16)
        layout.setSpacing(12)

        # --- Header ---
        header_row = QHBoxLayout()
        header = QLabel("📡  GATT Explorer")
        header.setObjectName("label_section")
        header_row.addWidget(header)

        header_row.addStretch()

        self._connection_label = QLabel("Not connected")
        self._connection_label.setObjectName("label_status_disconnected")
        header_row.addWidget(self._connection_label)

        layout.addLayout(header_row)

        # --- Splitter: Tree + Detail ---
        splitter = QSplitter(Qt.Orientation.Horizontal)

        # GATT Tree
        tree_container = QWidget()
        tree_layout = QVBoxLayout(tree_container)
        tree_layout.setContentsMargins(0, 0, 0, 0)

        self._discover_btn = QPushButton("🔄  Discover Services")
        self._discover_btn.setObjectName("btn_primary")
        self._discover_btn.setEnabled(False)
        tree_layout.addWidget(self._discover_btn)

        self._tree = QTreeWidget()
        self._tree.setHeaderLabels(["UUID", "Properties", "Description"])
        self._tree.header().setSectionResizeMode(
            0, QHeaderView.ResizeMode.Stretch
        )
        self._tree.header().setSectionResizeMode(
            1, QHeaderView.ResizeMode.ResizeToContents
        )
        self._tree.header().setSectionResizeMode(
            2, QHeaderView.ResizeMode.ResizeToContents
        )
        self._tree.itemClicked.connect(self._on_item_clicked)
        tree_layout.addWidget(self._tree)

        splitter.addWidget(tree_container)

        # Detail / Interaction Panel
        detail_container = QWidget()
        detail_layout = QVBoxLayout(detail_container)
        detail_layout.setContentsMargins(8, 0, 0, 0)

        # Selected characteristic info
        char_group = QGroupBox("Characteristic")
        char_layout = QVBoxLayout(char_group)

        self._char_uuid_label = QLabel("Select a characteristic")
        self._char_uuid_label.setObjectName("label_muted")
        self._char_uuid_label.setTextInteractionFlags(
            Qt.TextInteractionFlag.TextSelectableByMouse
        )
        char_layout.addWidget(self._char_uuid_label)

        self._char_props_label = QLabel("")
        self._char_props_label.setObjectName("label_muted")
        char_layout.addWidget(self._char_props_label)

        # Action buttons
        btn_row = QHBoxLayout()

        self._read_btn = QPushButton("📖  Read")
        self._read_btn.setEnabled(False)
        self._read_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        btn_row.addWidget(self._read_btn)

        self._subscribe_btn = QPushButton("🔔  Subscribe")
        self._subscribe_btn.setObjectName("btn_success")
        self._subscribe_btn.setEnabled(False)
        self._subscribe_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        btn_row.addWidget(self._subscribe_btn)

        char_layout.addLayout(btn_row)

        detail_layout.addWidget(char_group)

        # Write section
        write_group = QGroupBox("Write Data")
        write_layout = QVBoxLayout(write_group)

        format_row = QHBoxLayout()
        format_row.addWidget(QLabel("Format:"))
        self._write_format = QComboBox()
        self._write_format.addItems(["Hex", "ASCII", "Decimal"])
        format_row.addWidget(self._write_format)
        format_row.addStretch()
        write_layout.addLayout(format_row)

        self._write_input = QLineEdit()
        self._write_input.setPlaceholderText("e.g. AA55010301050000000012")
        write_layout.addWidget(self._write_input)

        self._write_btn = QPushButton("✏️  Write")
        self._write_btn.setEnabled(False)
        self._write_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        write_layout.addWidget(self._write_btn)

        detail_layout.addWidget(write_group)

        # Raw data display
        raw_group = QGroupBox("Raw Data")
        raw_layout = QVBoxLayout(raw_group)

        self._raw_display = QTextEdit()
        self._raw_display.setReadOnly(True)
        self._raw_display.setMaximumHeight(200)
        self._raw_display.setStyleSheet(
            f"font-family: 'Cascadia Code', 'Consolas', monospace; "
            f"font-size: 12px; background-color: {COLORS['bg_primary']};"
        )
        raw_layout.addWidget(self._raw_display)

        detail_layout.addWidget(raw_group)
        detail_layout.addStretch()

        splitter.addWidget(detail_container)
        splitter.setSizes([400, 350])

        layout.addWidget(splitter)

        # --- Connect internal signals ---
        self._read_btn.clicked.connect(self._on_read_clicked)
        self._subscribe_btn.clicked.connect(self._on_subscribe_clicked)
        self._write_btn.clicked.connect(self._on_write_clicked)

    # ----- Public API -----

    @property
    def discover_button(self) -> QPushButton:
        return self._discover_btn

    def set_connected(self, address: str) -> None:
        """Update UI to reflect a connected state."""
        self._connection_label.setText(f"Connected: {address}")
        self._connection_label.setObjectName("label_status_connected")
        self._connection_label.setStyleSheet(self._connection_label.styleSheet())
        self._discover_btn.setEnabled(True)

    def set_disconnected(self) -> None:
        """Update UI to reflect a disconnected state."""
        self._connection_label.setText("Not connected")
        self._connection_label.setObjectName("label_status_disconnected")
        self._connection_label.setStyleSheet(self._connection_label.styleSheet())
        self._discover_btn.setEnabled(False)
        self._tree.clear()
        self._reset_detail()
        self._subscribed_uuids.clear()

    def populate_services(self, services: list) -> None:
        """Populate the GATT tree with discovered services."""
        self._tree.clear()
        self._reset_detail()

        for svc in services:
            svc_item = QTreeWidgetItem(self._tree)
            svc_item.setText(0, svc.uuid)
            svc_item.setText(1, "Service")
            svc_item.setText(2, svc.description)
            svc_item.setExpanded(True)

            for char in svc.characteristics:
                char_item = QTreeWidgetItem(svc_item)
                char_item.setText(0, char.uuid)
                char_item.setText(1, ", ".join(char.properties))
                char_item.setText(2, char.description)
                char_item.setData(0, Qt.ItemDataRole.UserRole, char)

    def append_raw_data(self, char_uuid: str, data: bytes) -> None:
        """Append raw notification data to the display."""
        hex_str = data.hex(" ")
        self._raw_display.append(f"[{char_uuid[-8:]}] {hex_str}")

        # Auto-scroll
        scrollbar = self._raw_display.verticalScrollBar()
        if scrollbar:
            scrollbar.setValue(scrollbar.maximum())

    # ----- Private -----

    def _reset_detail(self) -> None:
        """Reset the detail panel."""
        self._char_uuid_label.setText("Select a characteristic")
        self._char_props_label.setText("")
        self._read_btn.setEnabled(False)
        self._subscribe_btn.setEnabled(False)
        self._subscribe_btn.setText("🔔  Subscribe")
        self._write_btn.setEnabled(False)
        self._raw_display.clear()

    def _on_item_clicked(self, item: QTreeWidgetItem, column: int) -> None:
        """Handle tree item selection."""
        char_info = item.data(0, Qt.ItemDataRole.UserRole)
        if char_info is None:
            # It's a service node
            self._reset_detail()
            return

        self._char_uuid_label.setText(f"UUID: {char_info.uuid}")
        self._char_props_label.setText(
            f"Properties: {', '.join(char_info.properties)}"
        )

        props = char_info.properties
        self._read_btn.setEnabled("read" in props)
        self._subscribe_btn.setEnabled("notify" in props or "indicate" in props)
        self._write_btn.setEnabled(
            "write" in props or "write-without-response" in props
        )

        # Update subscribe button text
        if char_info.uuid in self._subscribed_uuids:
            self._subscribe_btn.setText("🔕  Unsubscribe")
        else:
            self._subscribe_btn.setText("🔔  Subscribe")

    def _get_selected_char_uuid(self) -> str | None:
        """Get the UUID of the currently selected characteristic."""
        item = self._tree.currentItem()
        if item is None:
            return None
        char_info = item.data(0, Qt.ItemDataRole.UserRole)
        return char_info.uuid if char_info else None

    def _on_read_clicked(self) -> None:
        uuid = self._get_selected_char_uuid()
        if uuid:
            self.signal_read_requested.emit(uuid)

    def _on_subscribe_clicked(self) -> None:
        uuid = self._get_selected_char_uuid()
        if uuid is None:
            return

        if uuid in self._subscribed_uuids:
            self._subscribed_uuids.discard(uuid)
            self._subscribe_btn.setText("🔔  Subscribe")
            self.signal_unsubscribe_requested.emit(uuid)
        else:
            self._subscribed_uuids.add(uuid)
            self._subscribe_btn.setText("🔕  Unsubscribe")
            self.signal_subscribe_requested.emit(uuid)

    def _on_write_clicked(self) -> None:
        uuid = self._get_selected_char_uuid()
        if uuid is None:
            return

        raw_text = self._write_input.text().strip()
        if not raw_text:
            return

        fmt = self._write_format.currentText()
        try:
            if fmt == "Hex":
                data = bytes.fromhex(raw_text.replace(" ", ""))
            elif fmt == "ASCII":
                data = raw_text.encode("utf-8")
            elif fmt == "Decimal":
                values = [int(v.strip()) for v in raw_text.split(",")]
                data = bytes(values)
            else:
                data = bytes.fromhex(raw_text)

            self.signal_write_requested.emit(uuid, data)
        except (ValueError, OverflowError) as exc:
            self._raw_display.append(f"⚠️ Invalid input: {exc}")
