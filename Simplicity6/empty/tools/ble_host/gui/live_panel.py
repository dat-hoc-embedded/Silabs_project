"""
Live Panel — Real-time data visualization.

Displays parsed telemetry data as live-updating charts (pyqtgraph)
and a scrolling data table. Shows data rate statistics.
"""

from __future__ import annotations

import time
from collections import deque

import pyqtgraph as pg
from PyQt6.QtCore import Qt, QTimer
from PyQt6.QtWidgets import (
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QPushButton,
    QSplitter,
    QTableWidget,
    QTableWidgetItem,
    QVBoxLayout,
    QWidget,
)

from core.protocol import ParsedFrame, TelemetryPayload
from .styles import COLORS


# Configure pyqtgraph for dark theme
pg.setConfigOptions(
    background=COLORS["chart_bg"],
    foreground=COLORS["text_primary"],
    antialias=True,
)


class LivePanel(QWidget):
    """Real-time telemetry visualization with charts and data table."""

    MAX_DATA_POINTS = 500
    MAX_TABLE_ROWS = 200

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._timestamps: deque[float] = deque(maxlen=self.MAX_DATA_POINTS)
        self._sensor_a_data: deque[float] = deque(maxlen=self.MAX_DATA_POINTS)
        self._sensor_b_data: deque[float] = deque(maxlen=self.MAX_DATA_POINTS)

        # Frame rate tracking
        self._frame_times: deque[float] = deque(maxlen=100)
        self._total_frames: int = 0

        self._setup_ui()
        self._setup_chart_timer()

    def _setup_ui(self) -> None:
        layout = QVBoxLayout(self)
        layout.setContentsMargins(16, 16, 16, 16)
        layout.setSpacing(12)

        # --- Header ---
        header_row = QHBoxLayout()

        header = QLabel("📊  Live Telemetry")
        header.setObjectName("label_section")
        header_row.addWidget(header)

        header_row.addStretch()

        self._fps_label = QLabel("0 frames/sec")
        self._fps_label.setObjectName("label_muted")
        header_row.addWidget(self._fps_label)

        self._total_label = QLabel("Total: 0")
        self._total_label.setObjectName("label_muted")
        header_row.addWidget(self._total_label)

        self._clear_btn = QPushButton("🗑  Clear")
        self._clear_btn.clicked.connect(self.clear_data)
        self._clear_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        header_row.addWidget(self._clear_btn)

        layout.addLayout(header_row)

        # --- Splitter: Charts + Table ---
        splitter = QSplitter(Qt.Orientation.Vertical)

        # Charts container
        charts_widget = QWidget()
        charts_layout = QVBoxLayout(charts_widget)
        charts_layout.setContentsMargins(0, 0, 0, 0)
        charts_layout.setSpacing(8)

        # Sensor A chart
        self._chart_a = pg.PlotWidget(title="Sensor A")
        self._chart_a.setLabel("left", "Value")
        self._chart_a.setLabel("bottom", "Time (s)")
        self._chart_a.showGrid(x=True, y=True, alpha=0.3)
        self._chart_a.setMinimumHeight(150)
        self._curve_a = self._chart_a.plot(
            pen=pg.mkPen(color=COLORS["chart_line_a"], width=2),
            name="Sensor A",
        )
        charts_layout.addWidget(self._chart_a)

        # Sensor B chart
        self._chart_b = pg.PlotWidget(title="Sensor B")
        self._chart_b.setLabel("left", "Value")
        self._chart_b.setLabel("bottom", "Time (s)")
        self._chart_b.showGrid(x=True, y=True, alpha=0.3)
        self._chart_b.setMinimumHeight(150)
        self._curve_b = self._chart_b.plot(
            pen=pg.mkPen(color=COLORS["chart_line_b"], width=2),
            name="Sensor B",
        )
        charts_layout.addWidget(self._chart_b)

        # Link X axes for synchronized panning/zooming
        self._chart_b.setXLink(self._chart_a)

        splitter.addWidget(charts_widget)

        # Data table
        table_widget = QWidget()
        table_layout = QVBoxLayout(table_widget)
        table_layout.setContentsMargins(0, 8, 0, 0)

        table_header = QLabel("Recent Frames")
        table_header.setObjectName("label_muted")
        table_layout.addWidget(table_header)

        self._table = QTableWidget()
        self._table.setColumnCount(7)
        self._table.setHorizontalHeaderLabels(
            ["#", "Device Time (ms)", "Sensor A", "Sensor B",
             "Flags", "LED", "Alarm"]
        )
        self._table.horizontalHeader().setSectionResizeMode(
            QHeaderView.ResizeMode.Stretch
        )
        self._table.setAlternatingRowColors(True)
        self._table.verticalHeader().setVisible(False)
        self._table.setEditTriggers(QTableWidget.EditTrigger.NoEditTriggers)
        self._table.setSelectionBehavior(
            QTableWidget.SelectionBehavior.SelectRows
        )
        table_layout.addWidget(self._table)

        splitter.addWidget(table_widget)
        splitter.setSizes([400, 250])

        layout.addWidget(splitter)

    def _setup_chart_timer(self) -> None:
        """Timer to update chart curves at a fixed interval (30 FPS)."""
        self._chart_timer = QTimer(self)
        self._chart_timer.timeout.connect(self._update_charts)
        self._chart_timer.start(33)  # ~30 FPS

    # ----- Public API -----

    def add_frame(self, frame: ParsedFrame) -> None:
        """
        Add a parsed frame to the live display.

        Only TELEMETRY frames are plotted on charts.
        All frames are added to the data table.
        """
        now = time.time()
        self._frame_times.append(now)
        self._total_frames += 1
        self._total_label.setText(f"Total: {self._total_frames}")

        # Update FPS display
        if len(self._frame_times) >= 2:
            dt = self._frame_times[-1] - self._frame_times[0]
            if dt > 0:
                fps = len(self._frame_times) / dt
                self._fps_label.setText(f"{fps:.1f} frames/sec")

        if isinstance(frame.payload, TelemetryPayload):
            payload = frame.payload
            self._timestamps.append(payload.timestamp_ms / 1000.0)
            self._sensor_a_data.append(payload.sensor_a)
            self._sensor_b_data.append(payload.sensor_b)

            self._add_telemetry_row(payload)

    def clear_data(self) -> None:
        """Clear all chart data and table rows."""
        self._timestamps.clear()
        self._sensor_a_data.clear()
        self._sensor_b_data.clear()
        self._frame_times.clear()
        self._total_frames = 0
        self._table.setRowCount(0)
        self._curve_a.setData([], [])
        self._curve_b.setData([], [])
        self._fps_label.setText("0 frames/sec")
        self._total_label.setText("Total: 0")

    # ----- Private -----

    def _update_charts(self) -> None:
        """Update chart curves with current data (called by timer)."""
        if self._timestamps:
            ts = list(self._timestamps)
            self._curve_a.setData(ts, list(self._sensor_a_data))
            self._curve_b.setData(ts, list(self._sensor_b_data))

    def _add_telemetry_row(self, payload: TelemetryPayload) -> None:
        """Add a telemetry entry to the data table."""
        # Limit table size
        if self._table.rowCount() >= self.MAX_TABLE_ROWS:
            self._table.removeRow(0)

        row = self._table.rowCount()
        self._table.insertRow(row)

        items = [
            str(self._total_frames),
            str(payload.timestamp_ms),
            str(payload.sensor_a),
            str(payload.sensor_b),
            f"0x{payload.flags:02X}",
            "ON" if payload.led_state else "OFF",
            "⚠️ YES" if payload.alarm else "No",
        ]

        for col, text in enumerate(items):
            item = QTableWidgetItem(text)
            item.setTextAlignment(
                Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignVCenter
            )
            self._table.setItem(row, col, item)

        # Auto-scroll to latest
        self._table.scrollToBottom()
