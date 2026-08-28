# 2주차 내부 실측 — 이 vault에서 직접 잰 수치

측정 일시: 2026-08-27 · 측정 환경: macOS (Darwin 25.5.0), Claude Code 2.1.247, uv 0.8.14
측정 대상 vault: `2nd-brain` (교육 배포용 템플릿 저장소)

전부 이 저장소에서 `wc -c`·`os.path.getsize`·`command -v`로 잰 값이다. 추정치는 추정이라고 표시한다.

---

## 1. 세션마다 컨텍스트에 들어오는 것 — 고정 비용

**자동 로드**와 **지시로 읽는 것**을 구분해야 한다. 이 구분이 우리 vault 설계의 핵심이다.

| 구분 | 파일 | bytes |
| --- | --- | --- |
| 자동 로드 | `~/.claude/CLAUDE.md` | 3,298 |
| 자동 로드 | `~/.claude/rules/lemon-rules.md` | 1,460 |
| 자동 로드 | `CLAUDE.md` (프로젝트) | 2,128 |
| 자동 로드 | auto memory `MEMORY.md` | 496 |
| **자동 로드 소계** | | **7,382** |
| 지시로 읽음 | `VAULT_RULES.md` | 10,215 |
| 지시로 읽음 | `wiki/VAULT_MEMORY.md` | 2,781 |
| 지시로 읽음 | `wiki/INDEX.md` | 915 |
| **지시로 읽음 소계** | | **13,911** |
| **합계** | | **21,293** |

- 자동 로드분은 세션 시작 시 무조건 실린다. `~/.claude/rules/`의 파일은 `paths:` 프론트매터가
  없어 시작 시 로드된다.
- 지시로 읽는 3개는 `CLAUDE.md`의 `Before vault work, read:` 목록이다. `@import`가 아니므로
  자동 로드가 아니고, vault 작업이 시작될 때 Read 도구로 들어온다. 그래서 **compaction 후에는
  사라진다.**
- 여기에 시스템 프롬프트·도구 스키마·스킬 메타데이터가 더해진다. 그 몫은 `/context`로 세션별
  측정이 필요하다. 이 표는 vault 파일만의 몫이다.

### `AGENTS.md`(597 B)는 로드되지 않는다 — 초기 실측의 오류를 정정

`CLAUDE.md`에 `@AGENTS.md` import도 없고 본문 참조도 없다(`grep` 확인). `AGENTS.md`는
"규칙은 `CLAUDE.md`에 있다"고 안내하는 모델 중립 포인터 문서이고, Claude Code는 이 파일을
읽지 않는다. 첫 집계에서 이 파일을 포함하고 auto memory를 빼서 20,863 B로 계산했다.

정정 2회를 거쳤다. ① `AGENTS.md` 제외 + auto memory 포함 → 20,762 B (2026-08-27 값 기준).
② 2026-08-28 시연으로 `wiki/VAULT_MEMORY.md`가 2,781 B, `wiki/INDEX.md`가 915 B로 커졌고,
그때 소계를 `INDEX.md` 구값 458 B로 계산한 산수 오류가 있었다. **재검산한 실제 값은
21,293 B**(자동 로드 7,382 + 지시로 읽음 13,911)다. 이 값을 쓴다.

**교육에 쓸 주장**: "규칙 파일을 짧게 유지하라"는 취향이 아니라 예산 문제다. 이 vault는
대화 첫 글자를 치기 전에 약 20 KB를 이미 쓴다. `VAULT_RULES.md` 하나가 그 절반(10,215 B)이라
자동 로드 대상에서 빼고 필요할 때 읽게 만들었다.

### 메모리 상한 소진율

`VAULT_RULES.md`가 `wiki/VAULT_MEMORY.md`에 걸어 둔 상한은 8 KB(=8,192 B)다.

- 현재: 2,781 B → **상한의 33.9% 사용** · 남은 여유 5,411 B (2026-08-28 시연 후)

**교육에 쓸 주장**: 상한이 있는 파일은 소진율을 재면서 쓴다. 매 실행 서술을 memory에 붙이면
금방 찬다. 그래서 실행 이력은 `docs/vault-ingest-log.md`(828 B)로 분리했다(2026-07-29 결정).

### 토큰 환산

바이트→토큰 환산은 이 파일에서 확정하지 않는다. `01-context.md` 조사 결과, **한국어 대비
영어 토큰 배수의 공식 수치는 존재하지 않는다** — Anthropic 공식 지침은 Token Counting API로
실측하라는 것뿐이고 2차 자료는 1.38배~3배로 서로 다르다. 발표 자료에 토큰 수를 넣으려면
`/context` 실측값이나 count_tokens API 값을 쓴다. **추정 배수를 임의로 곱해 쓰지 않는다.**

---

## 2. 스킬 — progressive disclosure 절감률 실측

측정 대상: `projects/second-brain/config/skills/` (vault 배포 스킬 전량)

| 로드 단계 | 무엇이 로드되나 | 크기 | 전체 대비 |
| --- | --- | --- | --- |
| 1단 (상시) | 스킬 17개의 `name` + `description` 값만 | **6,823 B** | **3.6%** (1/28) |
| 1단 (상시, 다른 셈법) | 프론트매터 블록 전체 (`---` 구분선 포함) | **8,508 B** | **4.5%** (1/22) |
| 2단 (발동 시) | 해당 스킬의 진입점 `.md` 본문 1개 | 2,678 ~ 18,011 B | — |
| 3단 (필요 시) | 스킬 폴더의 참조 문서·스크립트 | 번들 8개 = 55,542 B | — |
| 전량 로드 시 | 스킬 폴더 전체 | 188,371 B | 100% |

- 스킬 수: **17개** (진입점 합계 132,829 B)
- **절감 배수: 약 1/22 ~ 1/28** — 셈법에 따라 두 값이 나온다. 프론트매터 블록 전체를 세면
  8,508 B(4.5%), `name`·`description` 값 텍스트만 세면 6,823 B(3.6%)다. 어느 쪽이든 주장은
  성립한다. **교육 자료에는 셈법을 밝히고 하나만 쓴다.**

### 스킬별 진입점 크기

| 스킬 | bytes |
| --- | --- |
| `doc2md-ingest/SKILL.md` | 18,011 |
| `vault-ingest-claude.md` | 13,843 |
| `vault-promote.md` | 13,522 |
| `vault-weekly-report.md` | 10,906 |
| `vault-lint.md` | 10,199 |
| `ai-studio-project-onboarding.md` | 9,178 |
| `hwp2md-ingest/SKILL.md` | 8,991 |
| `pdf2md-ingest/SKILL.md` | 8,600 |
| `vault-ingest.md` | 6,339 |
| `google-workspace.md` | 5,897 |
| `github-project-link.md` | 4,695 |
| `parallel-wp-orchestration.md` | 4,689 |
| `github-project-sync.md` | 4,595 |
| `vault-query.md` | 4,584 |
| `vault-ingest-once.md` | 3,067 |
| `ollama-local-models.md` | 3,035 |
| `private-note.md` | 2,678 |

### 3단 구조가 실제로 있는 스킬 (변환 스킬 3종)

| 스킬 | 진입점 `SKILL.md` | 폴더 전체 | 진입점 비중 |
| --- | --- | --- | --- |
| `doc2md-ingest` | 18,011 B | 37,964 B | 47% |
| `hwp2md-ingest` | 8,991 B | 10,832 B | 83% |
| `pdf2md-ingest` | 8,600 B | 42,348 B | 20% |

`pdf2md-ingest`가 3단 구조의 교보재로 가장 좋다 — 본문은 8.6 KB인데 폴더는 42 KB다.
`scripts/`(스크립트 3개)와 `design.md`·`implementation-plan.md`는 필요할 때만 읽힌다.

### 결함 1건 (교육 전 수정 대상)

- `ollama-local-models.md` — **프론트매터가 없다.** `name`·`description`이 없으면 1단 로드에
  잡히지 않아 발동 조건이 서지 않는다. 스킬 작성 규약을 설명하는 자리에서 반례로 쓸 수도
  있고, 그 전에 고칠 수도 있다. 판단이 필요하다.

---

## 3. vault 규모 — 시연 전(2026-08-27) 측정

> 아래는 **시연 전** 값이다. 2026-08-28 시연과 정리를 거친 뒤의 실습 시작 상태는
> `week2-outline.md` § 실습 시작 상태에 있다 (wiki 아티클 4 · `raw/` 1건 · `Clippings/` 0건).

| 레인 | 파일 수 |
| --- | --- |
| `wiki/*.md` | 4 |
| `raw/*.md` | 0 |
| `Clippings/` | 1 |
| `docs/*.md` | 7 |

**교육에 쓸 주장**: 수강자의 vault도 이 상태에서 출발한다. 2주차가 끝나면 `raw/`와 `wiki/`에
자기 문서가 들어간다.

---

## 4. 실습 전제 도구 — 이 머신 실측 (실습 진행에 직결)

| 도구 | 상태 | 필요한 경로 |
| --- | --- | --- |
| `uv` 0.8.14 | **있음** | H1(hwpx)·S2(pdf)·D1 스크립트 실행 |
| `git` | 있음 | vault 커밋 |
| `node` | 있음 | S6 OCR 스크립트 |
| `claude` 2.1.247 | 있음 | 전체 |
| `brew` | 있음 | 설치 수단 |
| **`pandoc`** | **없음** | **D1 — `.docx` → md 변환의 필수 도구** |
| poppler 26.08.0 (`pdfinfo`·`pdftotext`·`pdftoppm`) | **있음** (2026-08-28 재확인) | PDF 밀도 판정과 페이지 렌더 |
| LibreOffice (`soffice`) | 없음 | D2a — 레거시 `.doc` 경로 |
| `textutil` | 있음 (macOS 내장) | D2b — `.doc` 폴백 |
| Obsidian | CLI 미탐지 | (GUI 앱이라 `command -v`로 안 잡힘 — 별도 확인 필요) |

변환 스킬 3종은 모두 **"전제 도구 없으면 안내 후 중단, 자동 설치 금지"** 정책이다
(`doc2md-ingest/SKILL.md:37`, `hwp2md-ingest/SKILL.md:24`, `pdf2md-ingest/SKILL.md:22`).

> **실습 리스크**: 2026-08-28 재확인 결과 poppler 26.08.0이 설치돼 있고 스캔 PDF가 S6 로컬
> OCR로 실증됐다. 남은 결손은 `pandoc`뿐이며 `.docx` 경로만 게이트에서 중단된다. 2주차 실습을 하려면 수강자 머신에서 아래가 먼저 끝나야 한다.
>
> - macOS: `brew install pandoc uv poppler`
> - Windows: `winget install JohnMacFarlane.Pandoc` · `winget install astral-sh.uv`
>
> `.hwpx` 경로(H1)는 `uv`만으로 돌아가므로 설치 없이 실습 가능하다. 설치가 안 끝난 수강자는
> `.hwpx`부터 태우는 순서가 안전하다.
>
> **`.doc` 경로(D2a/D2b/D2c)는 Windows 실기기 미검증이다** (`doc2md-ingest/SKILL.md` § 근거·주의).

---

## 5. 실습 샘플 — 파일 실측

`projects/second-brain/samples/` (전부 합성 데이터, 커밋 가능)

| 파일 | bytes | 담당 스킬 | 태우는 경로 | 기대 결과 (samples/README.md 기재값) |
| --- | --- | --- | --- | --- |
| `설비-점검-절차.docx` | 39,669 | `doc2md-ingest` | D1 (pandoc) | 헤딩 6 · 표 1(20셀) · 불릿 3 · 이미지 1 · 316자 |
| `점검-결과-보고.hwpx` | 9,243 | `hwp2md-ingest` | H1 (순수 Python) | 표 1 · 403자 |
| `안전-교육-자료.pdf` | 226,920 | `pdf2md-ingest` | S2 (텍스트 추출) | 1페이지 · 499자/페이지 |
| `점검-기록지-스캔.pdf` | 109,511 | `pdf2md-ingest` | S4 (비전 전사 제안) | 1페이지 · **0자** · 이미지 1 |

두 PDF가 판정 기준선(페이지당 300자) 양쪽에 놓여 있어 분기를 실제로 태운다.

**교육에 쓸 주장**: 변환 결과가 쓸 만한지는 감으로 보지 않는다. `headings`·`tables`·`chars`
같은 수치로 판정한다. `headings=0`이 나오면 구조 손실 경로를 탄 것이다.

---

## 6. 참고 — 기존 2주차 핸드아웃 (백지 재작성 결정으로 대체 예정)

`projects/second-brain/outputs/week2-context-mcp-skills.html` · 113,445 B · 본문 약 20,997자
· 섹션 8개 · 총 58분 배분(5·8·5·6·11·18·4·1) · 인라인 SVG 3개 · 외부 출처 0건.

시간 배분과 실습 절차는 재사용 가치가 있다. 근거 계층이 전부 내부 문서였던 것이 재작성 사유다.
