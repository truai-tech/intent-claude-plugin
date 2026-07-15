# Intent

Pick up work from Intent changesets rather than ad-hoc tasks. MCP server: `intent-mcp-server`.

## Intent changeset patterns

Do not use hardcoded repo lists — users split repos across workspaces.

### Resolve changeset ID

Use the first available source:

1. **User-provided** — UUID or short ID
2. **Current branch** — extract ID prefix per Branch naming below
3. **MCP** — `list_projects`, then `list_changesets` with filters; ask the user to pick one

### Branch naming

Intent branches follow `intent/<changeset-id>-<slugified-name>` (e.g. `intent/c6d75b30-conversation-context-summarization`).

Extract the changeset ID prefix from the branch name: the segment after `intent/` starts with the changeset ID (first 8 characters of the UUID), then `-` and the slug (→ `c6d75b30`). Pass that ID to `get_changeset`. The same prefix matches files under `.intent/changesets/`.

### Repo discovery

`get_changeset` returns `repositoryIds` only. Call `list_repositories` to resolve names and URLs, then match those URLs to git roots in the current workspace.

Only operate on repos that are both linked to the changeset and present locally. Silently skip all others.

### Branch checkout

For each matched local repo, find and check out the intent branch:

```bash
git fetch origin
git branch -r | grep "intent/<first-8-chars-of-changesetId>"
git checkout <branch>
git pull
```

Skip repos with no matching branch.

### Reading `.intent/` locally

All repos carry the same `.intent/` content. Read from **one repo only** — typically the first matched local repo with a checked-out intent branch.

1. **Changeset first** — `.intent/changesets/<first-8-chars>*` (Summary, Acceptance Criteria, Testing Notes, spec links)
2. **Linked specs** — follow relative links in the changeset's `## Specs` section (e.g. `../specs/f7154808.md`). Do not read unlinked specs.

Prefer local `.intent/` files over MCP when on an intent branch — **read only**.

### Do not edit `.intent/` files

When users refine a changeset in Intent, updates to changesets and specs are synced **from Intent to the repo on a ~5 minute interval**. Intent is the source of truth.

**Never create, edit, or delete files under `.intent/changesets/` or `.intent/specs/` locally.** Doing so causes conflicts with the next sync and diverges from what the team sees in Intent.

To update changesets or specs, ask the user first, then use the write tools listed in Intent workflow below. Only implement code changes in source files locally.

## Intent workflow

### Local git vs MCP

| Need | Prefer |
| --- | --- |
| Changeset + specs on checked-out intent branch | Local `.intent/` files — read only |
| Changeset metadata, todos, comments (read) | `get_changeset` |
| List or filter changesets | `list_changesets` |
| Specs when not on branch | `list_artifacts` → `get_artifact` |
| Update specs or changeset description | Ask the user, then `refine_changeset` — never edit `.intent/` locally |
| Update status or todos | Ask the user, then `update_changeset` (todos are full replacement) |
| Post a comment | Ask the user, then `add_comment` |
| List PRs for a changeset | `list_pull_requests` |
| AI readiness check before closing | `preflight_check` |
| Link a repo to a changeset | Ask the user, then `link_repository` |
| Read a specific source file | Local workspace search/read. Use `read_file` only when the file is not in the workspace |
| Natural-language codebase question | `explore` (or local search if repos are checked out) |
| Resolve `projectId` | `list_projects` |
| Map repo IDs to names/URLs | `list_repositories` (requires `projectId`; filter by `repositoryIds` from `get_changeset`) |

When files are available locally, prefer local search and read over MCP. Use MCP for remote context, metadata, and questions across the indexed codebase.

### Skills

| Task | Skill |
| --- | --- |
| Pick up a changeset, checkout branches, outline implementation | **start-changeset** |
| Verify implementation against acceptance criteria and specs | **verify-changeset** |
| Quick changeset summary: todos, PRs, local workspace | **status-changeset** |
| Sync changeset/specs from local code | **refine-changeset** |

Invoke skills by name in your prompt (e.g. "use the start-changeset skill") or when the agent decides they are relevant.
