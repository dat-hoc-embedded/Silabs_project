"""
BLE Host Application — Entry Point.

Initializes QApplication with qasync event loop, applies the dark
theme, and launches the main window.

Usage:
    python main.py
"""

from __future__ import annotations

import asyncio
import logging
import sys

from PyQt6.QtWidgets import QApplication
from qasync import QEventLoop

from gui import MainWindow
from gui.styles import apply_theme


def setup_logging() -> None:
    """Configure application-wide logging."""
    logging.basicConfig(
        level=logging.DEBUG,
        format="%(asctime)s [%(levelname)-7s] %(name)-20s: %(message)s",
        datefmt="%H:%M:%S",
        handlers=[
            logging.StreamHandler(sys.stdout),
        ],
    )
    # Reduce noise from Bleak internals
    logging.getLogger("bleak").setLevel(logging.WARNING)


def main() -> None:
    """Application entry point."""
    setup_logging()
    logger = logging.getLogger(__name__)
    logger.info("Starting BLE Host Application...")

    # Create Qt application
    app = QApplication(sys.argv)
    app.setApplicationName("BLE Host")
    app.setApplicationVersion("1.0.0")
    app.setOrganizationName("SiLabs-BLE-Tools")

    # Apply dark theme
    apply_theme(app)

    # Install qasync event loop (bridges asyncio + Qt)
    loop = QEventLoop(app)
    asyncio.set_event_loop(loop)

    # Create and show main window
    window = MainWindow()
    window.show()

    logger.info("Application ready.")

    # Run the event loop
    with loop:
        loop.run_forever()

    logger.info("Application closed.")


if __name__ == "__main__":
    main()
