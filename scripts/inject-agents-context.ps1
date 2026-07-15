$ErrorActionPreference = "Stop"

$root = if ($env:CLAUDE_PLUGIN_ROOT) { $env:CLAUDE_PLUGIN_ROOT }
elseif ($env:COPILOT_PLUGIN_ROOT) { $env:COPILOT_PLUGIN_ROOT }
elseif ($env:PLUGIN_ROOT) { $env:PLUGIN_ROOT }
else { (Resolve-Path (Join-Path $PSScriptRoot "..")).Path }

$agents = Join-Path $root "AGENTS.md"
if (-not (Test-Path $agents)) { exit 0 }

$content = Get-Content -Raw -Path $agents
$payload = [ordered]@{
  additionalContext = $content
  hookSpecificOutput  = [ordered]@{
    hookEventName     = "SessionStart"
    additionalContext = $content
  }
}

$payload | ConvertTo-Json -Compress -Depth 3
