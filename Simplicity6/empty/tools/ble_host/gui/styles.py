"""
GUI Stylesheet — Dark theme with glassmorphism-inspired aesthetics.

Provides QSS stylesheets, color constants, and font configuration
for a premium, modern look.

Public API:
    DARK_THEME_QSS: str
    COLORS: dict
    apply_theme(app) -> None
"""

from __future__ import annotations

from PyQt6.QtGui import QFont, QFontDatabase
from PyQt6.QtWidgets import QApplication


# ---------------------------------------------------------------------------
# Color Palette
# ---------------------------------------------------------------------------

COLORS = {
    # Backgrounds
    "bg_primary": "#0D1117",       # Deep dark background
    "bg_secondary": "#161B22",     # Card/panel background
    "bg_tertiary": "#21262D",      # Elevated surfaces
    "bg_input": "#0D1117",         # Input field background
    "bg_hover": "#30363D",         # Hover state

    # Borders
    "border": "#30363D",           # Default border
    "border_focus": "#58A6FF",     # Focused input border
    "border_subtle": "#21262D",    # Subtle dividers

    # Text
    "text_primary": "#E6EDF3",     # Primary text
    "text_secondary": "#8B949E",   # Secondary/muted text
    "text_disabled": "#484F58",    # Disabled text

    # Accent Colors
    "accent_blue": "#58A6FF",      # Primary accent
    "accent_green": "#3FB950",     # Success / connected
    "accent_orange": "#D29922",    # Warning
    "accent_red": "#F85149",       # Error / disconnected
    "accent_purple": "#BC8CFF",    # Info / BLE

    # Charts
    "chart_line_a": "#58A6FF",     # Sensor A line color
    "chart_line_b": "#3FB950",     # Sensor B line color
    "chart_grid": "#21262D",       # Chart grid lines
    "chart_bg": "#0D1117",         # Chart background

    # Status
    "status_connected": "#3FB950",
    "status_disconnected": "#F85149",
    "status_scanning": "#D29922",
}


# ---------------------------------------------------------------------------
# QSS Stylesheet
# ---------------------------------------------------------------------------

DARK_THEME_QSS = f"""
/* ===== Global ===== */
QWidget {{
    background-color: {COLORS['bg_primary']};
    color: {COLORS['text_primary']};
    font-size: 13px;
    selection-background-color: {COLORS['accent_blue']};
    selection-color: #FFFFFF;
}}

/* ===== Main Window ===== */
QMainWindow {{
    background-color: {COLORS['bg_primary']};
}}

QMainWindow::separator {{
    background-color: {COLORS['border']};
    width: 1px;
    height: 1px;
}}

/* ===== Tab Widget ===== */
QTabWidget::pane {{
    border: 1px solid {COLORS['border']};
    border-radius: 8px;
    background-color: {COLORS['bg_secondary']};
    padding: 8px;
}}

QTabBar::tab {{
    background-color: {COLORS['bg_tertiary']};
    color: {COLORS['text_secondary']};
    border: 1px solid {COLORS['border']};
    border-bottom: none;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
    padding: 8px 20px;
    margin-right: 2px;
    min-width: 100px;
}}

QTabBar::tab:selected {{
    background-color: {COLORS['bg_secondary']};
    color: {COLORS['accent_blue']};
    border-bottom: 2px solid {COLORS['accent_blue']};
}}

QTabBar::tab:hover:!selected {{
    background-color: {COLORS['bg_hover']};
    color: {COLORS['text_primary']};
}}

/* ===== Buttons ===== */
QPushButton {{
    background-color: {COLORS['bg_tertiary']};
    color: {COLORS['text_primary']};
    border: 1px solid {COLORS['border']};
    border-radius: 6px;
    padding: 8px 16px;
    font-weight: 600;
    min-height: 20px;
}}

QPushButton:hover {{
    background-color: {COLORS['bg_hover']};
    border-color: {COLORS['accent_blue']};
}}

QPushButton:pressed {{
    background-color: {COLORS['accent_blue']};
    color: #FFFFFF;
}}

QPushButton:disabled {{
    background-color: {COLORS['bg_tertiary']};
    color: {COLORS['text_disabled']};
    border-color: {COLORS['border_subtle']};
}}

QPushButton#btn_primary {{
    background-color: {COLORS['accent_blue']};
    color: #FFFFFF;
    border: none;
}}

QPushButton#btn_primary:hover {{
    background-color: #79C0FF;
}}

QPushButton#btn_danger {{
    background-color: {COLORS['accent_red']};
    color: #FFFFFF;
    border: none;
}}

QPushButton#btn_danger:hover {{
    background-color: #FF7B72;
}}

QPushButton#btn_success {{
    background-color: {COLORS['accent_green']};
    color: #FFFFFF;
    border: none;
}}

/* ===== Tables ===== */
QTableWidget, QTableView {{
    background-color: {COLORS['bg_secondary']};
    alternate-background-color: {COLORS['bg_tertiary']};
    border: 1px solid {COLORS['border']};
    border-radius: 6px;
    gridline-color: {COLORS['border_subtle']};
    outline: none;
}}

QTableWidget::item {{
    padding: 6px 12px;
    border: none;
}}

QTableWidget::item:selected {{
    background-color: {COLORS['accent_blue']};
    color: #FFFFFF;
}}

QTableWidget::item:hover {{
    background-color: {COLORS['bg_hover']};
}}

QHeaderView::section {{
    background-color: {COLORS['bg_tertiary']};
    color: {COLORS['text_secondary']};
    border: none;
    border-bottom: 1px solid {COLORS['border']};
    padding: 8px 12px;
    font-weight: 600;
    font-size: 12px;
    text-transform: uppercase;
}}

/* ===== Tree Widget ===== */
QTreeWidget {{
    background-color: {COLORS['bg_secondary']};
    border: 1px solid {COLORS['border']};
    border-radius: 6px;
    outline: none;
}}

QTreeWidget::item {{
    padding: 4px 8px;
    border: none;
}}

QTreeWidget::item:selected {{
    background-color: {COLORS['accent_blue']};
    color: #FFFFFF;
}}

QTreeWidget::item:hover {{
    background-color: {COLORS['bg_hover']};
}}

QTreeWidget::branch {{
    background-color: transparent;
}}

/* ===== Input Fields ===== */
QLineEdit, QComboBox, QSpinBox {{
    background-color: {COLORS['bg_input']};
    color: {COLORS['text_primary']};
    border: 1px solid {COLORS['border']};
    border-radius: 6px;
    padding: 8px 12px;
    min-height: 18px;
}}

QLineEdit:focus, QComboBox:focus, QSpinBox:focus {{
    border-color: {COLORS['border_focus']};
}}

QComboBox::drop-down {{
    border: none;
    padding-right: 8px;
}}

QComboBox QAbstractItemView {{
    background-color: {COLORS['bg_secondary']};
    color: {COLORS['text_primary']};
    border: 1px solid {COLORS['border']};
    selection-background-color: {COLORS['accent_blue']};
}}

/* ===== Scrollbars ===== */
QScrollBar:vertical {{
    background-color: {COLORS['bg_primary']};
    width: 10px;
    border: none;
    border-radius: 5px;
}}

QScrollBar::handle:vertical {{
    background-color: {COLORS['border']};
    border-radius: 5px;
    min-height: 30px;
}}

QScrollBar::handle:vertical:hover {{
    background-color: {COLORS['text_disabled']};
}}

QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical {{
    height: 0px;
}}

QScrollBar:horizontal {{
    background-color: {COLORS['bg_primary']};
    height: 10px;
    border: none;
    border-radius: 5px;
}}

QScrollBar::handle:horizontal {{
    background-color: {COLORS['border']};
    border-radius: 5px;
    min-width: 30px;
}}

QScrollBar::handle:horizontal:hover {{
    background-color: {COLORS['text_disabled']};
}}

QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal {{
    width: 0px;
}}

/* ===== Labels ===== */
QLabel {{
    background-color: transparent;
    color: {COLORS['text_primary']};
}}

QLabel#label_section {{
    font-size: 16px;
    font-weight: 700;
    color: {COLORS['text_primary']};
    padding: 4px 0px;
}}

QLabel#label_muted {{
    color: {COLORS['text_secondary']};
    font-size: 12px;
}}

QLabel#label_status_connected {{
    color: {COLORS['status_connected']};
    font-weight: 600;
}}

QLabel#label_status_disconnected {{
    color: {COLORS['status_disconnected']};
    font-weight: 600;
}}

QLabel#label_status_scanning {{
    color: {COLORS['status_scanning']};
    font-weight: 600;
}}

/* ===== Group Box ===== */
QGroupBox {{
    background-color: {COLORS['bg_secondary']};
    border: 1px solid {COLORS['border']};
    border-radius: 8px;
    margin-top: 12px;
    padding-top: 20px;
    font-weight: 600;
}}

QGroupBox::title {{
    subcontrol-origin: margin;
    left: 16px;
    padding: 0 8px;
    color: {COLORS['accent_blue']};
}}

/* ===== Status Bar ===== */
QStatusBar {{
    background-color: {COLORS['bg_tertiary']};
    color: {COLORS['text_secondary']};
    border-top: 1px solid {COLORS['border']};
    padding: 4px 12px;
    font-size: 12px;
}}

QStatusBar::item {{
    border: none;
}}

/* ===== Menu Bar ===== */
QMenuBar {{
    background-color: {COLORS['bg_secondary']};
    color: {COLORS['text_primary']};
    border-bottom: 1px solid {COLORS['border']};
    padding: 2px;
}}

QMenuBar::item {{
    padding: 6px 12px;
    border-radius: 4px;
}}

QMenuBar::item:selected {{
    background-color: {COLORS['bg_hover']};
}}

QMenu {{
    background-color: {COLORS['bg_secondary']};
    color: {COLORS['text_primary']};
    border: 1px solid {COLORS['border']};
    border-radius: 6px;
    padding: 4px;
}}

QMenu::item {{
    padding: 8px 24px;
    border-radius: 4px;
}}

QMenu::item:selected {{
    background-color: {COLORS['accent_blue']};
    color: #FFFFFF;
}}

QMenu::separator {{
    height: 1px;
    background-color: {COLORS['border']};
    margin: 4px 8px;
}}

/* ===== Splitter ===== */
QSplitter::handle {{
    background-color: {COLORS['border']};
}}

QSplitter::handle:horizontal {{
    width: 2px;
}}

QSplitter::handle:vertical {{
    height: 2px;
}}

/* ===== Progress Bar ===== */
QProgressBar {{
    background-color: {COLORS['bg_tertiary']};
    border: 1px solid {COLORS['border']};
    border-radius: 4px;
    text-align: center;
    color: {COLORS['text_secondary']};
    height: 8px;
}}

QProgressBar::chunk {{
    background-color: {COLORS['accent_blue']};
    border-radius: 3px;
}}

/* ===== ToolTip ===== */
QToolTip {{
    background-color: {COLORS['bg_tertiary']};
    color: {COLORS['text_primary']};
    border: 1px solid {COLORS['border']};
    border-radius: 4px;
    padding: 6px 10px;
    font-size: 12px;
}}
"""


# ---------------------------------------------------------------------------
# Theme Application
# ---------------------------------------------------------------------------

def apply_theme(app: QApplication) -> None:
    """
    Apply the dark theme to the entire application.

    Sets the QSS stylesheet and configures the default font.

    Args:
        app: The QApplication instance.
    """
    app.setStyleSheet(DARK_THEME_QSS)

    # Try to use Inter or Segoe UI (common on Windows), fallback to system default
    preferred_fonts = ["Inter", "Segoe UI", "Roboto", "SF Pro Display"]
    font_family = None

    for name in preferred_fonts:
        font_id = QFontDatabase.families()
        if name in font_id:
            font_family = name
            break

    if font_family is None:
        font_family = "Segoe UI"  # Windows default

    font = QFont(font_family, 10)
    font.setHintingPreference(QFont.HintingPreference.PreferNoHinting)
    app.setFont(font)
