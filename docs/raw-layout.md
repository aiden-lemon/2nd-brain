# raw/ 보존소 계약

`raw/`의 상세 계약. `VAULT_RULES.md` § Directory Contract의 한 줄("Processed source
originals. Append-only")을 이 문서가 구체화한다.

## 레인

raw/는 유입 경로가 다른 레인을 담는다. 레인마다 frontmatter 계약이 다르다.

### 1. 웹 클리핑 (루트 `*.md`)

- 유입: Obsidian Web Clipper → `Clippings/` → ingest가 이동
  (`projects/second-brain/config/skills/vault-ingest-claude.md`).
- frontmatter: clipper 표준 7키 — `title`, `source`(URL), `author`, `created`,
  `published`, `description`, `tags`.
- 파일명: 이동 시점에 정규화한다 — § 파일명 정규화.

### 2. repo-doc 스냅샷 (루트 `<project>-<doc-slug>-<short-commit>.md`)

- 유입: 팀/개인 repo 문서의 특정 commit 시점 원문 캡처.
- capture header 의무 (2026-08-14부터, 기존 파일 소급 없음):

  ```yaml
  ---
  title: "<사람이 읽는 제목>"
  source: "<org/repo> — <repo 내 경로>"
  commit: "<short-hash>"
  branch: "<branch>"
  captured: YYYY-MM-DD
  author: <캡처한 사람>
  note: "<캡처 맥락. 본문 무수정 명시>"
  ---
  ```

- capture header는 캡처 **시점에** 붙이는 메타데이터이고, 본문은 원문 그대로 둔다.
  이미 raw/에 들어간 파일에 header를 소급 추가하는 것은 append-only 위반이다 —
  메타데이터 보충은 색인(`docs/raw-index.md`)이 맡는다.

### 3. 자동 수집 레인 (`screenshots/YYYY-MM-DD/` 등, 선택)

- 스크린샷·녹취처럼 자동 수집기가 넣는 자산은 날짜 폴더 레인으로 분리한다
  (색인 스크립트가 집계하는 기본 레인 이름은 `screenshots/`).
- 레인의 파일명·짝 파일(`.ocr.md` 등) 계약은 그 수집기를 소유한 프로젝트 스킬
  (`projects/<name>/config/skills/<skill>.md`)이 정의하고, 이 문서는 append-only와
  날짜 폴더 규칙만 강제한다.

## Append-only의 정의

- **내용 수정 금지, rename 금지, 삭제 금지.** 셋 다 append-only 위반이다.
- provenance(`"raw/<file>.md"` 문자열)가 정확한 경로 매칭에 의존하므로, rename은 조용한
  링크 부패를 만든다.
- rename이 불가피하면(예: 개인정보가 노출된 파일명): **사용자 승인** 후, 참조하는 모든
  provenance 문자열을 같은 커밋에서 일괄 수정하고, `docs/vault-ingest-log.md`에 사유를
  append한다.

## 파일명 정규화 (Clippings → raw 이동 시점)

원제목은 frontmatter `title:`에 남으므로 파일명은 안정성을 우선한다. 이동 시점에
파일명만 바꾼다(내용 무수정):

1. smart punctuation을 ASCII로 치환: `’‘` → `'`, `“”` → `"`, `—`·`–` → `-`, `…` → `...`
2. emoji 제거
3. `.md` 포함 120바이트 초과 시 단어 경계에서 절단
4. 동명 충돌 시 `-1`, `-2` suffix (기존 규칙, `vault-ingest.md`)
5. 한글 파일명은 NFC로 저장

provenance는 정규화된 이름으로 기록한다. 기존 파일은 소급 rename하지 않는다
(§ Append-only).

## ingest 게이트

`vault-ingest-claude`/`vault-ingest`가 클리핑 처리 시 적용한다.

- **URL 중복 게이트**: 신규 클리핑의 `source:` URL이 기존 raw frontmatter에 이미 있으면
  새 wiki 노트를 만들지 않고 기존 노트를 갱신한다. 원문은 그래도 `-1` suffix로 raw/에
  보존한다 (재클리핑도 이력이다).
- **파일명 정규화 게이트**: § 파일명 정규화를 적용한 이름으로 이동한다.

## 색인

`docs/raw-index.md`가 raw 루트 파일별 유입일·source·파생 노트 역링크를 담는다.

- 재생성: vault 루트에서
  `python3 projects/second-brain/config/scripts/generate_raw_index.py`
- `vault-lint` 패스가 재생성한다. **수동 편집 금지.**
- 색인이 raw/ 밖에 있는 이유: raw/ 안의 index는 매 ingest마다 편집이 필요해
  append-only와 충돌한다.
- 오펀(참조 0건)·source URL 중복이 발견되면 색인 상단에 표시된다 — lint 리포트로
  올린다.

## 하지 않기로 한 것 (2026-08-14 결정)

- **기존 파일 소급 rename/슬러그화** — 참조 무결 상태에서 실익이 링크 부패 위험보다
  작다.
- **서브폴더 재구조화**(`raw/YYYY-MM/` 등) — flat 구조가 아직 감당된다. **루트 200건
  도달 시** 신규분부터 재검토한다 (파일 수는 색인 상단에 표시).
