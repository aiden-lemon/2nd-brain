#!/usr/bin/env python3
# origin: lemoncloud-io/knowledge@01f358b:projects/second-brain/config/scripts/vault_ingest_once.py
"""Run one Claude-first vault ingest pass.

This script is intentionally thin: it resolves/locks the vault, checks whether Claude Code
is available, runs the delegated ingest job when possible, and emits JSON for Hermes/cron.
If Claude is missing or unauthenticated, it exits 42 so Hermes can run the native fallback
workflow from projects/second-brain/config/skills/vault-ingest.md.
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

EXPECTED_DIRS = ["wiki", "raw", "Clippings", "templates"]
EXPECTED_FILES = ["VAULT_RULES.md", "wiki/VAULT_MEMORY.md", "wiki/INDEX.md"]


def emit(payload: dict, code: int = 0) -> int:
    print(json.dumps(payload, ensure_ascii=False, indent=2))
    return code


def resolve_vault() -> Path | None:
    candidate = Path(os.environ.get("VAULT_DIR") or os.getcwd()).expanduser().resolve()
    if not (candidate / "VAULT_RULES.md").exists():
        return None
    if not all((candidate / d).is_dir() for d in EXPECTED_DIRS):
        return None
    return candidate


def find_claude() -> str | None:
    path = shutil.which("claude")
    if path:
        return path
    hermes_node = Path.home() / ".hermes" / "node" / "bin" / "claude"
    if hermes_node.exists() and os.access(hermes_node, os.X_OK):
        return str(hermes_node)
    return None


def run(cmd: list[str], cwd: Path | None = None, timeout: int = 60) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, cwd=cwd, text=True, capture_output=True, timeout=timeout, check=False)


def acquire_lock(vault: Path) -> Path | None:
    lock_dir = vault / ".locks"
    lock_dir.mkdir(exist_ok=True)
    lock = lock_dir / "vault-ingest.lock"
    try:
        fd = os.open(lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
    except FileExistsError:
        return None
    with os.fdopen(fd, "w", encoding="utf-8") as f:
        f.write(json.dumps({"pid": os.getpid(), "created": int(time.time())}, ensure_ascii=False))
    return lock


def build_job_spec(vault: Path) -> str:
    return f"""You are processing an Obsidian markdown knowledge vault.

ABSOLUTE_VAULT_DIR: {vault}

Before editing:
- Confirm that the current working directory is ABSOLUTE_VAULT_DIR.
- If the current working directory is not ABSOLUTE_VAULT_DIR, stop and report the mismatch.
- Only read or write files under ABSOLUTE_VAULT_DIR.
- Do not use ~/knowledge unless ABSOLUTE_VAULT_DIR is exactly the resolved ~/knowledge path.

Read first:
- VAULT_RULES.md
- CLAUDE.md, if present
- wiki/VAULT_MEMORY.md
- wiki/INDEX.md
- templates/
- projects/second-brain/config/skills/vault-ingest.md

Task:
Process every markdown file in Clippings/.
Move processed originals to raw/ without changing their content.
Create or update wiki notes using matching templates in templates/.
Prefer updating existing wiki notes over creating duplicate notes.
Update wiki/topics/, wiki/INDEX.md, and wiki/TOPIC_MAP.md.
Append this run's narrative to docs/vault-ingest-log.md under "## Ingest Runs" (append-only; never
edit or delete existing entries; you do not need to read the whole file to append).
In wiki/VAULT_MEMORY.md, REPLACE the single existing "- Last Ingest:" line — never add a second one:
  - Last Ingest: <YYYY-MM-DD> (<author-slug>) — N clippings -> X new / Y updated wiki notes
Keep that line under 200 bytes, refresh the "Volume to date" and "Verification queue" counts, and keep
the whole file under 8 KB (wc -c).

Rules:
- Do not edit raw file contents.
- Record raw source provenance as \"raw/<source-file-name>.md\", not as a raw-file wikilink.
- Use Obsidian aliases as [[note-slug|Alias]], not [[note-slug\\|Alias]].
- Mark unsupported or time-sensitive claims as needs-update or TODO.
- Never append a per-run narrative to wiki/VAULT_MEMORY.md: it is loaded every session and capped at
  8 KB. Narrative goes to docs/vault-ingest-log.md. Do not restate project status in memory either —
  projects/<name>/README.md frontmatter is the source of truth.
- Do not run git push, git reset, git clean, rm -rf, or destructive commands.

Final response:
Report the current working directory, ABSOLUTE_VAULT_DIR, processed clipping files,
created wiki notes, updated wiki notes, new stubs, topic/index/memory updates,
the docs/vault-ingest-log.md append, the resulting wc -c of wiki/VAULT_MEMORY.md,
and any unresolved issues.
"""


def main() -> int:
    vault = resolve_vault()
    if vault is None:
        return emit({"status": "error", "reason": "vault_root_unclear", "fallback": False}, 2)

    missing = [rel for rel in EXPECTED_FILES if not (vault / rel).exists()]
    if missing:
        return emit({"status": "error", "reason": "missing_required_files", "missing": missing, "fallback": False}, 2)

    clippings = sorted(str(p.relative_to(vault)) for p in (vault / "Clippings").glob("*.md"))
    if not clippings:
        return emit({"status": "no_work", "vault": str(vault), "message": "처리할 클리핑 없음"}, 0)

    lock = acquire_lock(vault)
    if lock is None:
        return emit({"status": "locked", "vault": str(vault), "lock": str(vault / ".locks" / "vault-ingest.lock"), "fallback": False}, 3)

    try:
        claude = find_claude()
        if not claude:
            return emit({"status": "fallback_required", "reason": "claude_missing", "vault": str(vault), "clippings": clippings}, 42)

        version = run([claude, "--version"], cwd=vault, timeout=30)
        if version.returncode != 0:
            return emit({"status": "fallback_required", "reason": "claude_version_failed", "stderr": version.stderr[-2000:], "vault": str(vault), "clippings": clippings}, 42)

        auth = run([claude, "auth", "status", "--text"], cwd=vault, timeout=30)
        if auth.returncode != 0:
            return emit({"status": "fallback_required", "reason": "claude_auth_failed", "stderr": auth.stderr[-2000:], "vault": str(vault), "clippings": clippings}, 42)

        job = build_job_spec(vault)
        cmd = [
            claude,
            "-p",
            job,
            "--permission-mode",
            "acceptEdits",
            "--allowedTools",
            "Read,Write,Edit,Bash",
            "--max-turns",
            "20",
            "--output-format",
            "json",
        ]
        result = run(cmd, cwd=vault, timeout=1800)
        if result.returncode != 0:
            return emit({
                "status": "claude_failed_after_start",
                "vault": str(vault),
                "clippings_before": clippings,
                "exit_code": result.returncode,
                "stdout_tail": result.stdout[-4000:],
                "stderr_tail": result.stderr[-4000:],
                "fallback": "manual_review_before_fallback",
            }, result.returncode or 1)

        remaining = sorted(str(p.relative_to(vault)) for p in (vault / "Clippings").glob("*.md"))
        raw_files = sorted(str(p.relative_to(vault)) for p in (vault / "raw").glob("*.md"))
        wiki_files = sorted(str(p.relative_to(vault)) for p in (vault / "wiki").rglob("*.md"))
        return emit({
            "status": "claude_success",
            "vault": str(vault),
            "clippings_before": clippings,
            "clippings_remaining": remaining,
            "raw_files": raw_files,
            "wiki_files": wiki_files,
            "claude_stdout": result.stdout[-8000:],
        }, 0)
    finally:
        try:
            lock.unlink()
        except FileNotFoundError:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
