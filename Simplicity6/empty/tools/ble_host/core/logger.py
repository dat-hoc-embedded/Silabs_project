"""
Data Logger — CSV and JSON logging for parsed BLE frames.

Thread-safe file writer that appends parsed frame data to CSV or JSONL files.

Public API:
    signal_log_started(filepath)
    signal_log_stopped()
    signal_error(error_message)
    start(filepath, fmt) -> None
    log(frame) -> None
    stop() -> None
    is_logging -> bool
"""

from __future__ import annotations

import csv
import json
import logging
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import IO, Any

from PyQt6.QtCore import QObject, pyqtSignal

from .protocol import ParsedFrame

logger = logging.getLogger(__name__)


class DataLogger(QObject):
    """
    Logs parsed BLE frames to CSV or JSONL files.

    Each logged entry includes a host-side timestamp in addition
    to any device timestamp in the frame payload.
    """

    # Signals
    signal_log_started = pyqtSignal(str)   # filepath
    signal_log_stopped = pyqtSignal()
    signal_error = pyqtSignal(str)

    # CSV columns
    _CSV_COLUMNS = [
        "host_timestamp",
        "version",
        "opcode",
        "raw_hex",
        "timestamp_ms",
        "sensor_a",
        "sensor_b",
        "flags",
        "led_state",
        "alarm",
        "battery_pct",
        "fw_version",
        "error_code",
        "cmd_id",
        "params_hex",
        "acked_opcode",
        "status_code",
    ]

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._file: IO[str] | None = None
        self._writer: csv.DictWriter | None = None
        self._fmt: str = "csv"
        self._filepath: str = ""
        self._entry_count: int = 0

    @property
    def is_logging(self) -> bool:
        """Whether logging is currently active."""
        return self._file is not None

    @property
    def entry_count(self) -> int:
        """Number of entries logged in the current session."""
        return self._entry_count

    def start(self, filepath: str, fmt: str = "csv") -> None:
        """
        Start logging to a file.

        Args:
            filepath: Path to the output file.
            fmt: Format — 'csv' or 'json' (JSONL).
        """
        if self.is_logging:
            self.stop()

        fmt = fmt.lower()
        if fmt not in ("csv", "json"):
            self.signal_error.emit(f"Unsupported format: {fmt}")
            return

        try:
            # Ensure parent directory exists
            Path(filepath).parent.mkdir(parents=True, exist_ok=True)

            self._fmt = fmt
            self._filepath = filepath
            self._entry_count = 0
            self._file = open(filepath, "a", newline="", encoding="utf-8")

            if fmt == "csv":
                # Write header if the file is empty
                needs_header = os.path.getsize(filepath) == 0 or self._file.tell() == 0
                self._writer = csv.DictWriter(
                    self._file,
                    fieldnames=self._CSV_COLUMNS,
                    extrasaction="ignore",
                )
                if needs_header:
                    self._writer.writeheader()
                    self._file.flush()

            logger.info("Logging started: %s (%s)", filepath, fmt)
            self.signal_log_started.emit(filepath)

        except Exception as exc:
            error_msg = f"Failed to start logging: {exc}"
            logger.error(error_msg)
            self.signal_error.emit(error_msg)
            self._file = None

    def log(self, frame: ParsedFrame) -> None:
        """
        Log a single parsed frame.

        Args:
            frame: The ParsedFrame to log.
        """
        if not self.is_logging or self._file is None:
            return

        try:
            entry = frame.to_dict()
            entry["host_timestamp"] = datetime.now(timezone.utc).isoformat()

            if self._fmt == "csv" and self._writer is not None:
                self._writer.writerow(entry)
            elif self._fmt == "json":
                self._file.write(json.dumps(entry, default=str) + "\n")

            self._file.flush()
            self._entry_count += 1

        except Exception as exc:
            logger.error("Logging error: %s", exc)

    def stop(self) -> None:
        """Stop logging and close the file."""
        if self._file is not None:
            try:
                self._file.flush()
                self._file.close()
                logger.info(
                    "Logging stopped: %s (%d entries)",
                    self._filepath,
                    self._entry_count,
                )
            except Exception as exc:
                logger.warning("Error closing log file: %s", exc)
            finally:
                self._file = None
                self._writer = None
                self._entry_count = 0
                self.signal_log_stopped.emit()
