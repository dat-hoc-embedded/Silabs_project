"""Hello Antigravity SDK Example.

Fixes applied:
1. Loads .env file using `python-dotenv` for API key and config.
2. Reconfigures stdout/stderr to UTF-8 to prevent Windows UnicodeEncodeError.
3. Fixes streaming response token consumption (`async for token in response:`).
4. Adds robust error handling and diagnostic messages.
"""

from __future__ import annotations

import asyncio
import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Ensure UTF-8 output encoding on Windows consoles
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# Load environment variables from .env
env_file = Path(__file__).resolve().parent / ".env"
load_dotenv(dotenv_path=env_file)

try:
    from google.antigravity import Agent, CapabilitiesConfig, LocalAgentConfig
except ImportError:
    print(
        "[ERROR] Thư viện 'google-antigravity' hoặc 'python-dotenv' chưa được cài đặt.\n"
        "Vui lòng cài đặt bằng lệnh: pip install google-antigravity python-dotenv",
        file=sys.stderr,
    )
    sys.exit(1)


async def main() -> None:
    api_key = os.getenv("GEMINI_API_KEY", "")
    system_instructions = os.getenv(
        "ANTIGRAVITY_SYSTEM_INSTRUCTIONS",
        "Bạn là kỹ sư AI hỗ trợ rà soát và tối ưu mã nguồn cho hệ thống nhúng.",
    )

    if not api_key or api_key == "your_gemini_api_key_here":
        print(
            "[CẢNH BÁO] Chưa cấu hình GEMINI_API_KEY hợp lệ trong file .env!\n"
            "Vui lòng mở file .env và cập nhật API key của bạn.\n"
        )

    # Cấu hình LocalAgentConfig
    config = LocalAgentConfig(
        system_instructions=system_instructions,
        capabilities=None,  # Để None cho chế độ read-only an toàn
    )

    prompt = "Liệt kê các tệp tin trong thư mục hiện tại và phân tích kiến trúc dự án."
    print(f"[PROMPT]: {prompt}\n")
    print("[AGENT PHẢN HỒI]:")
    print("-" * 50)

    try:
        async with Agent(config) as agent:
            # Gửi yêu cầu phân tích
            response = await agent.chat(prompt)

            # Stream từng token phản hồi trực tiếp ra màn hình
            async for token in response:
                sys.stdout.write(token)
                sys.stdout.flush()

            print("\n" + "-" * 50)
            print("[HOÀN THÀNH] Phản hồi thành công.")

    except Exception as exc:
        print(f"\n[LỖI THỰC THI AGENT]: {exc}", file=sys.stderr)


if __name__ == "__main__":
    asyncio.run(main())