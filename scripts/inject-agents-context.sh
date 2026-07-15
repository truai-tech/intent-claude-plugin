#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="${CLAUDE_PLUGIN_ROOT:-${COPILOT_PLUGIN_ROOT:-${PLUGIN_ROOT:-$(dirname "$script_dir")}}}"
agents="$root/AGENTS.md"

if [[ ! -f "$agents" ]]; then
  exit 0
fi

content="$(
  awk 'BEGIN { ORS="" }
    {
      gsub(/\\/, "\\\\")
      gsub(/"/, "\\\"")
      gsub(/\t/, "\\t")
      gsub(/\r/, "")
      if (NR > 1) printf "\\n"
      printf "%s", $0
    }' "$agents"
)"

printf '{"additionalContext":"%s","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}' \
  "$content" "$content"
