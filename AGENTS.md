# Agent Instructions

This repository is a markdown knowledge vault shared by Hermes, Obsidian, and LLM agents.

Before editing, read:

1. `VAULT_RULES.md`
2. `wiki/VAULT_MEMORY.md`
3. `wiki/INDEX.md`
4. Matching files in `templates/` when creating notes or outputs

Use the Hermes vault skills as the source of truth for operational workflows:

- `projects/second-brain/config/skills/vault-ingest.md`
- `projects/second-brain/config/skills/vault-ingest-claude.md`
- `projects/second-brain/config/skills/vault-query.md`
- `projects/second-brain/config/skills/vault-lint.md`

At runtime, never silently fallback to `~/knowledge`. Use the user-provided `VAULT_DIR`,
or infer the vault root from the current working directory only when the expected vault
structure is present. If the vault root is unclear, ask before editing.

When writing or updating vault documents, never record machine-specific absolute paths.
Prefer relative paths rooted at the vault, such as `wiki/INDEX.md` or `raw/file.md`.
If a path must appear in user-facing guidance, use `$VAULT_DIR`, `${VAULT_DIR}`, or
`~/knowledge` instead of resolved paths like `/Users/.../knowledge`.

Do not edit file contents in `raw/`. Save durable answers under `outputs/` unless a task is clearly project-scoped.
Use templates before inventing new note structures.

`wiki/VAULT_MEMORY.md` is loaded on every vault operation and is capped at 8 KB (`wc -c`) — the budget
is bytes, not lines. Never append a per-run narrative to it: replace the single `Last Ingest:` line,
append execution detail to `docs/vault-ingest-log.md`, and leave project status in
`projects/<name>/README.md`. See `VAULT_RULES.md` § Core Rules.

When Obsidian is running and an Obsidian CLI skill is available, prefer it for vault search, backlinks, link analysis, and frontmatter edits. Use direct file tools for bulk edits.
