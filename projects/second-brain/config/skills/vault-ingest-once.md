---
name: vault-ingest-once
description: >
  Claude Code 우선으로 vault Clippings ingest를 한 번 실행하는 원샷 스킬. 세부 규칙은
  vault-ingest-claude.md를 따르고, Claude가 시작 전 단계에서 불가하면 vault-ingest.md로 fallback한다.
---

# Vault Ingest Once

수동 실행, cron, webhook에서 공통으로 쓰는 ingest 진입점이다. 세부 정책과 Claude job spec은
`projects/second-brain/config/skills/vault-ingest-claude.md`를 따른다.

## Run

Vault root에서 실행한다.

```bash
python3 projects/second-brain/config/scripts/vault_ingest_once.py
```

## Result handling

- `status: no_work` → 처리할 클리핑 없음. 종료.
- `status: claude_success` → 결과를 검증하고 요약.
- exit code `42` 또는 `status: fallback_required` → Claude가 시작 전 단계에서 불가. `projects/second-brain/config/skills/vault-ingest.md`로 Hermes-native fallback.
- `status: locked` → 병렬 실행하지 말고 lock 경로 보고.
- `status: claude_failed_after_start` → 부분 변경 가능성 있음. 자동 fallback 금지; 변경 파일을 먼저 검토.

## Verify after run

`vault-ingest-claude.md`의 검증 기준을 따른다. 최소 확인:

- `Clippings/`, `raw/`, `wiki/`, `wiki/INDEX.md`, `wiki/TOPIC_MAP.md`, `wiki/VAULT_MEMORY.md` 상태
- raw source provenance가 `"raw/<file>.md"` 문자열인지
- raw/archive 파일 내용 미수정
- `wc -c wiki/VAULT_MEMORY.md` < 8192, `grep -c '^- Last Ingest' wiki/VAULT_MEMORY.md` == 1
- 실행 서술이 `docs/vault-ingest-log.md`에 append됐는지
- Claude 결과를 검증 없이 성공 처리하지 않았는지

## Cron prompt seed

```text
Run one vault ingest pass using projects/second-brain/config/skills/vault-ingest-once.md.
Use projects/second-brain/config/scripts/vault_ingest_once.py from the resolved VAULT_DIR.
If it exits 42/fallback_required, run the Hermes-native vault-ingest fallback.
If the vault root is unclear, stop and report the blocker. Do not ask questions during cron.
```
