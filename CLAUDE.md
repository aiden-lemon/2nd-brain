# Claude Instructions

Before vault work, read:

1. `VAULT_RULES.md`
2. `wiki/VAULT_MEMORY.md`
3. `wiki/INDEX.md`
4. Matching files in `templates/` when creating notes or outputs

Vault root rules:

- Use the user-provided `VAULT_DIR` when present.
- Otherwise infer the vault root from the current working directory only when it contains `VAULT_RULES.md`, `wiki/`, `raw/`, `Clippings/`, `outputs/`, and `templates/`.
- Never silently fall back to `~/knowledge`; that path is only a setup example.
- Resolve `VAULT_DIR` to an absolute path before delegated or automated work.
- Only read or write under the resolved vault root.
- Never leave machine-specific absolute paths in vault documents.
- Prefer relative vault paths such as `wiki/INDEX.md`, `wiki/VAULT_MEMORY.md`, `raw/<file>.md`, and `outputs/<file>.md`.
- If a path must be shown in user-facing documentation or agent instructions, prefer `$VAULT_DIR`, `${VAULT_DIR}`, or `~/knowledge` over resolved paths like `/Users/.../knowledge`.

Safety rules:

- Do not edit file contents in `raw/` or `archive/`; both are append-only.
- Never commit personal experiment data to this shared team vault: per-item labels over
  personal media, personal photo/file content descriptions, or local sample folder
  names/paths. Keep aggregate metrics only in retained docs; gitignore such data files
  (track only synthetic `*.example.*`). See `VAULT_RULES.md` § Core Rules.
- Use templates before inventing new note structures.
- `wiki/VAULT_MEMORY.md` is loaded every session and capped at 8 KB (`wc -c`), measured in bytes not
  lines. Never append per-run narrative to it: replace the single `Last Ingest:` line, append execution
  detail to `docs/vault-ingest-log.md` (append-only, not loaded at session start), and keep project
  status in `projects/<name>/README.md`. See `VAULT_RULES.md` § Core Rules.
- Preserve raw source provenance as `"raw/<source-file-name>.md"`, not raw-file wikilinks.
- Use Obsidian aliases as `[[note-slug|Alias]]`, not escaped-pipe links.

Workflow priority:

- Ingest and lint automation should prefer Claude Code when available.
- If the `claude` CLI is missing, unavailable, or unauthenticated, report that and let Hermes run the Hermes-native fallback workflow.
- For delegated ingest, follow `projects/second-brain/config/skills/vault-ingest-claude.md`.
- For fallback ingest/query/lint, follow the relevant Hermes skill:
  - `vault-ingest`
  - `vault-query`
  - `vault-lint`
