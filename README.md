# Intent Claude Code Plugin

Claude Code plugin for [Intent](https://onintent.build) — pick up changesets, work on intent branches, verify against specs, and refine requirements from code.

For teams using Intent and Claude Code. Requires an Intent account, indexed repositories, and an API token.

---

## What this plugin does

Install once — no files to copy into your repositories. The plugin bundles:

- **MCP integration** — read changesets, specs, repos, and PRs; write updates through Intent's API (with confirmation)
- **Skills** — four agent workflows: start, status, verify, and refine
- **Always-on rules** — `AGENTS.md` injected at session start via a plugin hook (branch naming, repo discovery, never edit `.intent/` locally)

Unlike the Cursor plugin, Claude Code does not support custom slash commands. Invoke skills by name in your prompt (e.g. *"use the start-changeset skill"*) or let the agent pick them up contextually.

---

## Prerequisites

- An [Intent](https://onintent.build) account with at least one project and indexed repositories
- Claude Code with MCP support
- Python 3 (for the session-start hook that loads rules)
- An Intent API token

---

## Installation

### From marketplace (once published)

```
/plugin install intent@claude-plugins-official
```

### Local development

```bash
claude --plugin-dir /path/to/intent-claude-plugin
```

Or install from a local path:

```bash
claude plugin install /path/to/intent-claude-plugin
```

Set your Intent API token:

```bash
export INTENT_API_TOKEN="your-token-here"
```

Create an API token in the Intent app under **Settings**.

---

## Quick start

1. Install the plugin and set `INTENT_API_TOKEN`
2. Open Claude Code in a workspace with your Intent-linked repos
3. Say *"use the start-changeset skill for changeset `<id>`"* — or ask to pick up in-progress work
4. Run **verify-changeset** before merge; **refine-changeset** if specs need to catch up

---

## Skills

| Skill | When to use | What it does |
| --- | --- | --- |
| `start-changeset` | Pick up / start / implement a changeset | Checks out intent branches, reads specs, presents an implementation outline |
| `status-changeset` | "Where am I?" / intent status | Read-only snapshot of todos, PRs, and local branch state |
| `verify-changeset` | Ready to merge? / am I done? | Full audit against acceptance criteria and specs |
| `refine-changeset` | Spec diverged / update Intent | Drafts spec deviations and sends to Intent after confirmation |

---

## Repository layout

```text
intent-claude-plugin/
├── .claude-plugin/
│   └── plugin.json              # Claude Code plugin manifest
├── hooks/
│   └── hooks.json               # SessionStart → inject AGENTS.md
├── AGENTS.md                    # Always-on Intent rules (plugin-internal)
├── .mcp.json                    # Intent MCP server configuration
├── scripts/
│   └── inject-agents-context.py
├── skills/
│   ├── start-changeset/SKILL.md
│   ├── status-changeset/SKILL.md
│   ├── verify-changeset/SKILL.md
│   └── refine-changeset/SKILL.md
└── README.md
```

---

## Manual setup (without plugin)

If you cannot install the plugin, use the **Connect IDE** pane in Intent's command menu for copy-paste snippets.

---

## Related plugins

- [Intent Cursor plugin](https://github.com/truai-tech/intent-cursor-plugin)
- [Intent Copilot plugin](https://github.com/intent-io/intent-copilot-plugin)

---

## License

MIT — see [LICENSE](LICENSE).
