# Vault Rules

This vault is an AI Second Brain operated through Hermes and Obsidian.

These rules are model-neutral. Use them with GPT, Claude, Codex, or any other LLM that can read and edit this vault.

## Session Start

Before any vault operation, read:

1. `wiki/VAULT_MEMORY.md`
2. `wiki/INDEX.md`
3. The relevant Hermes skill in `projects/second-brain/config/skills/`
4. Any matching template in `templates/`

If a task is project-specific, also read the matching `projects/<name>/README.md`.

## Vault Root Resolution

At runtime, never silently fallback to `~/knowledge`. That path is only a setup example.
Use the user-provided `VAULT_DIR` when present. Otherwise, treat the current working
directory as the vault root only when it contains the expected vault structure such as
`VAULT_RULES.md`, `wiki/`, `raw/`, `Clippings/`, and `templates/`. If the vault root is
unclear, ask before reading or writing files.

When delegating ingest work to another agent such as Claude CLI, resolve `VAULT_DIR` to an
absolute path first and pass that path explicitly in both the working directory and the
delegated prompt. The delegated agent must only read or write under that resolved path.

## Obsidian CLI

When an Obsidian CLI is available and Obsidian is running, prefer it for vault operations such as search, link analysis, and frontmatter edits. Otherwise use the Hermes `obsidian` skill's filesystem-first workflow with concrete absolute paths. For bulk operations across many files, direct file tools (Read/Edit/Write) remain appropriate.

## Automation Priority

Ingest and lint automation should prefer Claude Code when the `claude` CLI is installed and authenticated. This is the preferred path for future cron/event-based operation.

If Claude Code is unavailable, blocked, or unauthenticated, do not fail silently. Report the reason and run the Hermes-native fallback workflow:

- ingest fallback → `vault-ingest`
- lint fallback → `vault-lint`

Before delegating to Claude Code, resolve `VAULT_DIR` to an absolute path and pass that path explicitly in the working directory and prompt. Delegated agents must only read or write under the resolved vault root.

## Directory Contract

| Directory | Role |
| --- | --- |
| `Clippings/` | New source inbox |
| `raw/` | Processed source originals. Append-only |
| `wiki/` | Concept articles, one concept per file |
| `wiki/topics/` | Topic index pages |
| `outputs/` | Query answers, analysis reports, lint results |
| `templates/` | Obsidian and LLM output templates |
| `projects/` | Project execution context and project-scoped outputs |
| `projects/<name>/config/` | Project-local skills, prompts, scripts, and tool configuration source files |
| `areas/` | Ongoing responsibility areas: `daily/` notes and `ideas/` notes |
| `archive/` | Completed projects, superseded config, expired material. Append-only |
| `docs/` | System specs, setup notes, and configuration docs |

## Core Rules

- Do not edit file contents in `raw/`.
- Preserve source provenance.
- Prefer updating existing wiki notes over creating duplicate notes.
- Use matching files in `templates/` before inventing a new note or output structure.
- Use English kebab-case filenames for wiki notes.
- Write new wiki article body prose in Korean; keep frontmatter keys/values, section headings, code identifiers, commands, and proper nouns (tool/model/product names) in English. See "Language Convention" below.
- Use `[[wikilinks]]` for related wiki concepts.
- Do not use wikilinks for raw source files unless a corresponding wiki source note exists.
- Use Obsidian aliases as `[[note-slug|Alias]]`; do not escape the pipe character.
- Save durable answers under `outputs/` or `projects/<name>/outputs/`.
- Query-style answers that should be retained must not finish as chat-only output.
- If `outputs/` does not exist when saving a retained answer, create it.
- Keep project execution context in `projects/`; move reusable concepts to `wiki/`.
- Project-specific skills, prompts, scripts, generated tools, cron wrapper prompts, and automation config belong under `projects/<name>/config/`; treat those files as the source of truth and update runtime settings from them, not the other way around.
- Execution-generated runtime state, caches, manifests, ledgers, lock files, and other intermediate files are not source-of-truth artifacts. Keep them untracked and add project-specific ignore rules for them when they must live under `projects/<name>/outputs/`.
- Mark unsupported claims as inference or `needs-update`.
- Personal experiment data stays local-only; this is a shared team vault.
- Do not edit file contents in `archive/` (same contract as `raw/`).
- Keep `wiki/VAULT_MEMORY.md` under 8 KB (`wc -c`); it is loaded every session, so the budget is
  bytes, not lines. A line count is not a load budget — one 3 KB bullet passes "200 lines" and still
  costs a full load. Verify with `wc -c wiki/VAULT_MEMORY.md` before committing.
- `wiki/VAULT_MEMORY.md` holds durable policy plus current state and pointers — never an execution log:
  - `## Current State`: the `Last Ingest:` line is **replaced** each run, never appended, max 200 bytes
    (`- Last Ingest: <YYYY-MM-DD> (<author-slug>) — N clippings → X new / Y updated wiki notes (PR #<n>)`).
  - Per-run narrative is appended to `docs/vault-ingest-log.md`, which is append-only and is **not**
    loaded at session start. Full detail also stays in the commit and PR body.
  - Project status/goal/next_action is never restated here; `projects/<name>/README.md` frontmatter is
    the source of truth (index: `projects/README.md`).
  - `## Open Threads`: max 5 live vault-level actions, deleted when closed.
- One daily note per day at `areas/daily/YYYY-MM-DD.md`; ideas that recur get promoted to `areas/ideas/<slug>.md`.
- Project truth lives in `projects/<name>/README.md` frontmatter (`status`, `goal`, `due`, `milestones`, `next_action`).

## Work Layer Frontmatter

Daily note (`areas/daily/YYYY-MM-DD.md`):

```yaml
date: 2026-07-06
type: daily
projects-touched: []   # ["[[projects/<name>/README|<name>]]"]
mood:                  # optional
energy:                # optional
tags: [journal]
```

Idea note (`areas/ideas/<slug>.md`):

```yaml
type: idea
status: seed | growing | ready | adopted | dropped
first-seen: 2026-07-06
related: []            # ["[[wiki/<concept>]]"]
```

Project (`projects/<name>/README.md`):

```yaml
type: project
status: active | paused | done
goal: "one sentence"
due: 2026-08-31        # optional
milestones:
  - name: "milestone"
    due: 2026-07-15
    done: false
next_action: "one concrete next step"
```

`status: done` → move the project folder to `archive/projects/` and update `projects/README.md`.

## GitHub-Linked Projects

External GitHub repositories are tracked as lightweight project notes. The vault holds status,
goal, and next action — it never becomes a mirror of the repo.

### Identity and paths

- Note location: `projects/@<org>/<folder>/README.md`, created from `templates/project-readme-github.md`.
- Repo identity lives in frontmatter `repo: <org>/<repo>`, not in the folder name.
- Local clone: `$GITHUB_DIR/<org>/<folder>`. `GITHUB_DIR` uses the environment variable when set,
  otherwise `~/Documents`. Do not create a missing `GITHUB_DIR` silently; ask first.
- The vault note folder name and the local clone folder name must match. Usually this is the repo
  name; for a version-line clone it is the qualified name such as `lemon-core-v42`.
- Never record machine-dependent absolute paths in notes or indexes. Write `$GITHUB_DIR/...`.

### Scope and branch

- `scope: team` for team-org repos, `scope: personal` for personal accounts. Both share the same structure.
- Set `branch:` only when the tracked main line differs from the repo default branch. Do not track
  temporary working branches.

### Index layers

- `projects/@<org>/README.md` — repo table (`repo | status | goal`).
- `projects/README.md` — one row per org (`| [@<org>](@<org>/) | N repos | ... |`).

### Sync contract

- External repos are read-only. `git fetch` on a local clone is allowed; no other writes.
- Agents propose `status`, `goal`, and `next_action` changes; the user approves before they are written.
- `last_synced` is updated only together with a reported detection result. No empty syncs.
- Access failures (missing or unauthenticated `gh`, no repo permission) are reported explicitly,
  never skipped silently. Sync coverage is bounded by each runner's GitHub permissions.
- Sync report files are one-off artifacts and are not committed.
- `status: done` → move the folder to `archive/projects/@<org>/<folder>/` and update both index layers.

### Promoting knowledge to wiki

- Project execution context (scope decisions, milestones, deliverables) stays in the project note.
- Reusable concepts are promoted to `wiki/`.
- A wiki note compiled from a linked repo records provenance in `sources` as `"<org>/<repo>:<path>"`
  strings — not a `raw/` path, and not a wikilink — and links back to the project note.

Skills: `github-project-link` (registration), `github-project-sync` (status sync).

## Language Convention

Wiki article body prose is written in Korean. Keep the following in English inside the body:

- Headings, frontmatter keys and values, code, and proper nouns stay English.
- Filenames stay English kebab-case (see § Core Rules).
- Section headings (`## Summary`, `## Details`, `## Use Cases`, ...) — part of the shared template contract.
- Frontmatter keys and values (`type: tool`, `status: draft`, `sources: [...]`, ...).
- Proper nouns and product/tool/model names (Claude Code, Claude Octopus, ultrathink, `/effort ultracode`).
- Inline code, commands, file paths, and CLI flags.

Example:

```text
## Summary

Claude Octopus는 Claude Code 플러그인으로, `/octo:*` 명령을 통해 Claude·Codex·Gemini를
동시에 호출하고 [[consensus-gate|consensus gate]]로 결과를 검증한다.
```

## Wiki Frontmatter

Every normal `wiki/` article should include:

```yaml
---
type: concept
topics:
  - knowledge-management
status: draft
sources:
  - "raw/source-file-name.md"
---
```

Use `sources` for direct provenance. If the source is a processed raw clipping, store the
`raw/...` path as a string. If the source is a GitHub-linked project repo, store
`"<org>/<repo>:<path>"` (see § GitHub-Linked Projects). Use `[[wikilinks]]` only when the source
is an actual wiki note.

### type values

- `concept` — abstract idea, pattern, or architecture
- `tool` — specific software or CLI tool
- `model` — AI model family or variant
- `framework` — structured methodology or platform
- `pattern` — repeatable workflow or technique
- `protocol` — technical specification
- `topic` — reserved for wiki/topics/ pages only

### status values

- `stub` — under 350 words; needs expansion
- `draft` — substantial content but not fully reviewed
- `complete` — reviewed and comprehensive
- `needs-update` — new source has materially changed the topic

## Topic Pages (wiki/topics/)

Frontmatter:

```yaml
---
type: topic
up: "[[topics/parent-topic]]"   # omit for root topics
---
```

Body: one-line list of related wiki articles with [[wikilinks]].  
10+ linked articles → consider splitting into sub-topics.  
Full topic list → `wiki/TOPIC_MAP.md`.

## Templates

Use these templates when present:

| Output | Template |
| --- | --- |
| wiki concept | `templates/wiki-concept.md` |
| wiki tool | `templates/wiki-tool.md` |
| wiki model | `templates/wiki-model.md` |
| wiki framework | `templates/wiki-framework.md` |
| topic page | `templates/topic-page.md` |
| query answer | `templates/query-output.md` |
| lint report | `templates/lint-report.md` |
| project README | `templates/project-readme.md` |
| GitHub-linked project README | `templates/project-readme-github.md` |
| daily note, optional | `templates/daily-note.md` |
| idea note | `templates/idea.md` |
| contact note, optional | `templates/contact.md` |

Templates are shared contracts for Obsidian users and LLM agents. If a template exists,
preserve its frontmatter fields and section headings unless the user explicitly asks for a
different structure.

---

## Workflows

Ingest runs as one daily batch, not per-clipping. Daily brief/close are Hermes-native; only knowledge compilation is delegated to Claude.

Use the Hermes skills as the source of truth:

- `vault-ingest-claude`: preferred ingest path when Claude Code is available; Hermes handles trigger, lock, fallback, verification, and reporting.
- `vault-ingest`: Hermes-native ingest fallback; process `Clippings/` into `raw/`, `wiki/`, topics, index, and memory with the current Hermes model.
- `vault-query`: answer from existing wiki knowledge and save retained answers to `outputs/`.
- `vault-lint`: Claude-first lint orchestration with Hermes-native fallback; inspect vault quality and update `wiki/VAULT_MEMORY.md`.
- Planned: `vault-daily-brief`, `vault-daily-close`, `vault-project-review`, and `vault-retro` are operating-loop skills that should be added before relying on those workflows in automation.
