#!/usr/bin/env python3
"""Emit SessionStart hook JSON with AGENTS.md from the plugin install directory."""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path


def plugin_root() -> Path:
    for key in ("CLAUDE_PLUGIN_ROOT", "COPILOT_PLUGIN_ROOT", "PLUGIN_ROOT"):
        value = os.environ.get(key)
        if value:
            return Path(value)
    return Path(__file__).resolve().parent.parent


def main() -> None:
    agents = plugin_root() / "AGENTS.md"
    if not agents.is_file():
        sys.exit(0)

    content = agents.read_text(encoding="utf-8")
    payload = {
        "additionalContext": content,
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": content,
        },
    }
    print(json.dumps(payload))


if __name__ == "__main__":
    main()
