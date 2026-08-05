"""
Log Panel — Data logging controls and log viewer.

Provides start/stop logging, file path selection, format toggle,
and a live preview of the last N log entries.
"""

from __future__ import annotations

from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import (
    QComboBox,
    QFileDialog,
    QGroupBox,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QPushButton,
    QTextEdit,
    QVBoxLayout,
    QWidget,
)

from .styles import COLORS


class LogPanel(QWidget):
    """Data logging controls and live log preview."""

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._is_logging = False
        self._preview_count = 0
        self._setup_ui()

    def _setup_ui(self) -> None:
        layout = QVBoxLayout(self)
        layout.setContentsMargins(16, 16, 16, 16)
        layout.setSpacing(12)

        # --- Header ---
        header = QLabel("💾  Data Logger")
        header.setObjectName("label_section")
        layout.addWidget(header)

        # --- Controls Group ---
        controls_group = QGroupBox("Log Configuration")
        controls_layout = QVBoxLayout(controls_group)

        # File path row
        path_row = QHBoxLayout()
        path_row.addWidget(QLabel("Output File:"))

        self._path_input = QLineEdit()
        self._path_input.setPlaceholderText("Select output file path...")
        self._path_input.setText("ble_log.csv")
        path_row.addWidget(self._path_input)

        self._browse_btn = QPushButton("📂  Browse")
        self._browse_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        self._browse_btn.clicked.connect(self._on_browse)
        path_row.addWidget(self._browse_btn)

        controls_layout.addLayout(path_row)

        # Format row
        format_row = QHBoxLayout()
        format_row.addWidget(QLabel("Format:"))

        self._format_combo = QComboBox()
        self._format_combo.addItems(["CSV", "JSON (JSONL)"])
        self._format_combo.currentIndexChanged.connect(self._on_format_changed)
        format_row.addWidget(self._format_combo)

        format_row.addStretch()

        self._entry_count_label = QLabel("0 entries logged")
        self._entry_count_label.setObjectName("label_muted")
        format_row.addWidget(self._entry_count_label)

        controls_layout.addLayout(format_row)

        # Start/Stop buttons
        btn_row = QHBoxLayout()

        self._start_btn = QPushButton("▶  Start Logging")
        self._start_btn.setObjectName("btn_success")
        self._start_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        self._start_btn.setMinimumWidth(160)
        btn_row.addWidget(self._start_btn)

        self._stop_btn = QPushButton("⏹  Stop Logging")
        self._stop_btn.setObjectName("btn_danger")
        self._stop_btn.setEnabled(False)
        self._stop_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        self._stop_btn.setMinimumWidth(160)
        btn_row.addWidget(self._stop_btn)

        btn_row.addStretch()

        controls_layout.addLayout(btn_row)
        layout.addWidget(controls_group)

        # --- Log Preview ---
        preview_group = QGroupBox("Log Preview (last 100 entries)")
        preview_layout = QVBoxLayout(preview_group)

        self._preview = QTextEdit()
        self._preview.setReadOnly(True)
        self._preview.setStyleSheet(
            f"font-family: 'Cascadia Code', 'Consolas', monospace; "
            f"font-size: 12px; background-color: {COLORS['bg_primary']};"
        )
        preview_layout.addWidget(self._preview)

        # Preview controls
        preview_btn_row = QHBoxLayout()
        self._clear_preview_btn = QPushButton("🗑  Clear Preview")
        self._clear_preview_btn.clicked.connect(self._preview.clear)
        self._clear_preview_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        preview_btn_row.addWidget(self._clear_preview_btn)
        preview_btn_row.addStretch()
        preview_layout.addLayout(preview_btn_row)

        layout.addWidget(preview_group)

    # ----- Public API -----

    @property
    def start_button(self) -> QPushButton:
        return self._start_btn

    @property
    def stop_button(self) -> QPushButton:
        return self._stop_btn

    @property
    def filepath(self) -> str:
        return self._path_input.text().strip()

    @property
    def log_format(self) -> str:
        """Returns 'csv' or 'json'."""
        return "json" if self._format_combo.currentIndex() == 1 else "csv"

    def set_logging(self, active: bool) -> None:
        """Update UI state based on logging status."""
        self._is_logging = active
        self._start_btn.setEnabled(not active)
        self._stop_btn.setEnabled(active)
        self._path_input.setEnabled(not active)
        self._browse_btn.setEnabled(not active)
        self._format_combo.setEnabled(not active)

        if not active:
            self._preview_count = 0

    def update_entry_count(self, count: int) -> None:
        """Update the entry count display."""
        self._entry_count_label.setText(f"{count} entries logged")

    def append_preview(self, text: str) -> None:
        """Add a line to the log preview."""
        self._preview_count += 1

        # Keep only last 100 entries in preview
        if self._preview_count > 100:
            cursor = self._preview.textCursor()
            cursor.movePosition(cursor.MoveOperation.Start)
            cursor.movePosition(
                cursor.MoveOperation.Down, cursor.MoveMode.KeepAnchor
            )
            cursor.removeSelectedText()
            cursor.deleteChar()  # Remove the newline

        self._preview.append(text)

        # Auto-scroll
        scrollbar = self._preview.verticalScrollBar()
        if scrollbar:
            scrollbar.setValue(scrollbar.maximum())

    # ----- Private -----

    def _on_browse(self) -> None:
        """Open file dialog to select output path."""
        fmt = self.log_format
        if fmt == "csv":
            filter_str = "CSV Files (*.csv);;All Files (*)"
            default_name = "ble_log.csv"
        else:
            filter_str = "JSON Files (*.jsonl *.json);;All Files (*)"
            default_name = "ble_log.jsonl"

        filepath, _ = QFileDialog.getSaveFileName(
            self, "Select Log File", default_name, filter_str
        )
        if filepath:
            self._path_input.setText(filepath)

    def _on_format_changed(self, index: int) -> None:
        """Update file extension when format changes."""
        current = self._path_input.text().strip()
        if current:
            if index == 0 and current.endswith((".jsonl", ".json")):
                self._path_input.setText(
                    current.rsplit(".", 1)[0] + ".csv"
                )
            elif index == 1 and current.endswith(".csv"):
                self._path_input.setText(
                    current.rsplit(".", 1)[0] + ".jsonl"
                )
