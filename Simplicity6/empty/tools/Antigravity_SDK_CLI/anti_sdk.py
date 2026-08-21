"""Antigravity Python SDK Test Script with .env Configuration.

This script demonstrates how to configure, spawn, and interact with an
Antigravity AI Agent using environment variables loaded from a `.env` file.
"""

from __future__ import annotations

import asyncio
import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Ensure UTF-8 output on Windows consoles
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# Load environment variables from .env file
env_path = Path(__file__).resolve().parent / ".env"
load_dotenv(dotenv_path=env_path)

try:
    from google.antigravity import Agent, CapabilitiesConfig, LocalAgentConfig
except ImportError:
    print(
        "[ERROR] 'google-antigravity' or 'python-dotenv' is not installed.\n"
        "Please install via: pip install google-antigravity python-dotenv"
    )
    sys.exit(1)


async def run_agent_test(prompt: str) -> None:
    """Spawns an Antigravity Agent and streams the response to stdout.

    Args:
        prompt: The user prompt to send to the agent.
    """
    api_key = os.getenv("GEMINI_API_KEY", "")
    system_instructions = os.getenv(
        "ANTIGRAVITY_SYSTEM_INSTRUCTIONS",
        "You are an expert AI assistant specializing in software and embedded systems.",
    )
    enable_write = os.getenv("ENABLE_WRITE_TOOLS", "false").lower() in ("true", "1", "yes")

    print("=" * 65)
    print("[INIT] Initializing Antigravity Agent with .env configuration...")
    print(f"[CONFIG] System Instructions: {system_instructions}")
    print(f"[CONFIG] Write Capabilities:  {enable_write}")
    print(f"[CONFIG] API Key Configured:  {'Yes (Set)' if api_key and api_key != 'your_gemini_api_key_here' else 'No (Placeholder detected)'}")
    print("=" * 65)

    if not api_key or api_key == "your_gemini_api_key_here":
        print(
            "\n[NOTE] Please open `.env` and set your `GEMINI_API_KEY` to your valid API key.\n"
            "       Example: GEMINI_API_KEY=AIzaSy...\n"
        )

    capabilities = CapabilitiesConfig() if enable_write else None

    config = LocalAgentConfig(
        system_instructions=system_instructions,
        capabilities=capabilities,
    )

    try:
        async with Agent(config) as agent:
            print(f"[PROMPT] {prompt}\n")
            print("[AGENT RESPONSE STREAM]")
            print("-" * 50)

            # Send the chat prompt (returns streaming response)
            response = await agent.chat(prompt)

            # Stream response tokens in real-time
            async for token in response:
                sys.stdout.write(token)
                sys.stdout.flush()

            print("\n" + "-" * 50)
            print("[DONE] Response completed successfully.")

    except Exception as exc:
        print(f"\n[AGENT EXECUTION ERROR]: {exc}", file=sys.stderr)


async def main() -> None:
    """Main entrypoint for the SDK test."""
    test_prompt = (
        "Explain the Silicon Labs EFR32MG24 architecture and suggest 3 tips for BLE power optimization."
    )
    await run_agent_test(test_prompt)


if __name__ == "__main__":
    asyncio.run(main())