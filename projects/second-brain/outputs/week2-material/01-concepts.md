# 개념 20분

> 2주차 교육 자료 · 2026-08-28 · 개념부

---

### 문서함에서 위키까지

2주차 · 60분 · 개념 20분 + 시연 40분

각자 자기 private repo에 자기 vault를 만든다. 오늘은 그 vault에 문서 한 건이 들어가
위키 노트가 되는 경로를 끝까지 본다. 개념 20분은 그 경로가 왜 그렇게 생겼는지를 다룬다.

**화면**: 표지 — 제목과 시간 배분(개념 20 + 시연 40)
**근거**: `week2-outline.md` § 배분

---

## 01 오늘의 목표

> 3분 · 슬라이드 1장

이 섹션을 보면 자기 vault가 지금 어떤 상태인지, 오늘 끝나면 무엇이 늘어나는지 안다.

### 문서함에서 위키까지 3계층

vault는 세 칸으로 나뉜다. 칸마다 규칙이 다르다.

| 계층 | 역할 | 규칙 |
| --- | --- | --- |
| `Clippings/` | 수집 대기 | 아직 정리하지 않은 것을 넣는다 |
| `raw/` | 원본 보관 | append-only — 수정·삭제하지 않는다 |
| `wiki/` | LLM이 읽는 정제 노트 | 색인은 `wiki/INDEX.md` |

1주차에 각자 만든 vault는 지금 이 상태다.

| 항목 | 값 |
| --- | --- |
| `wiki/` 아티클 / 토픽 | 4개 / 2개 |
| `wiki/INDEX.md` | 915 B |
| `wiki/VAULT_MEMORY.md` | 2,781 B |
| `raw/` | 1건 |
| `Clippings/` | 0건 |

wiki 노트 4개는 1주차에 클리핑 1건을 넣은 결과다. 오늘 끝나면 여기에 자기 업무 문서가
`raw/`와 `wiki/` 양쪽으로 들어간다.

**화면**: 3계층 그림 하나 + 현재 상태 표
**근거**: `week2-outline.md` § 실습 시작 상태 · § 1

---

## 02 컨텍스트

> 9분 · 슬라이드 3장

이 섹션을 보면 자기 vault 문서를 왜 짧게 유지해야 하는지, 어느 파일을 먼저 줄여야 하는지
숫자로 판단할 수 있다. 뒤에 나오는 Skill과 MCP도 여기서 나온 예산 개념 위에 서 있다.

### 모델의 작업 기억

컨텍스트는 모델이 답을 만들 때 참조하는 텍스트 전체다. Anthropic 공식 문서는 이것을
학습 데이터와 구분해 "작업 기억"이라 부른다.

> "The 'context window' refers to all the text a language model can reference when generating
> a response, including the response itself. ... instead represents a 'working memory' for
> the model."

학습 데이터는 이미 모델 안에 있는 것이고, 컨텍스트는 지금 책상에 펼쳐 놓은 것이다.
자기 vault 문서는 학습 데이터가 아니다. 매번 책상에 다시 올린다.

책상에 올라가는 것은 자기가 타이핑한 글자만이 아니다.

> "Everything in the request counts toward the context window: the system prompt, every
> message in `messages` (including tool results, images, and documents), and your tool
> definitions."

시스템 프롬프트, 도구 정의, 읽어들인 파일이 전부 같은 자리를 쓴다. 그래서 규칙 파일을
짧게 쓰라는 말은 취향이 아니다. 자리 문제다.

**화면**: 공식 인용 2개 원문 + "학습 데이터 ≠ 컨텍스트" 대비 한 줄
**근거**: `01-context.md` B-1 · B-2

---

### 우리 vault의 고정 비용 21,293 B

우리 vault는 대화 첫 글자를 치기 전에 이미 21,293 B를 쓴다. `wc -c`로 직접 잰 값이다.

| 구분 | 파일 | bytes | 누구나 같은가 |
| --- | --- | --- | --- |
| 자동 로드 | `~/.claude/CLAUDE.md` | 3,298 | 개인차 |
| 자동 로드 | `~/.claude/rules/lemon-rules.md` | 1,460 | 개인차 |
| 자동 로드 | `CLAUDE.md` (프로젝트) | 2,128 | vault 공통 |
| 자동 로드 | auto memory `MEMORY.md` | 496 | 개인차 |
| **자동 로드 소계** | | **7,382** | |
| 지시로 읽음 | `VAULT_RULES.md` | 10,215 | vault 공통 |
| 지시로 읽음 | `wiki/VAULT_MEMORY.md` | 2,781 | vault 공통 |
| 지시로 읽음 | `wiki/INDEX.md` | 915 | vault 공통 |
| **지시로 읽음 소계** | | **13,911** | |
| **합계** | | **21,293** | |

**이 표는 발표자 환경 실측이다.** 오른쪽 칸을 함께 봐야 한다. vault가 가져오는 몫은
16,039 B로 누구나 같고, 나머지 5,254 B는 각자의 개인 설정(`~/.claude/`)이라 수강자 머신마다
다르다. 자기 값은 `/context`로 직접 잰다. 합계 숫자를 자기 값으로 옮겨 적지 않는다.

두 소계를 나눈 것이 핵심이다. 성격이 다르다.

- **자동 로드**: 세션 시작 시 무조건 실린다. 대화가 길어져 compaction이 일어나도 디스크에서
  다시 들어온다.
- **지시로 읽음**: `CLAUDE.md`의 `Before vault work, read:` 목록이다. `@import`가 아니라
  "읽어라"는 지시이므로, vault 작업이 시작될 때 Read로 들어온다. **compaction 후에는 요약되어
  사라진다.**

`VAULT_RULES.md` 하나가 10,215 B다. 자동 로드 소계 전체보다 크다. 그래서 자동 로드에서 빼고
필요할 때 읽게 만들었다. 대신 절대 잊혀선 안 되는 규칙 세 개(`raw/` append-only, 개인 실험
데이터 커밋 금지, 8 KB 상한)는 `CLAUDE.md`의 `## Hard Invariants`에 중복으로 적어 뒀다.
compaction 후에도 남는 쪽에 사본을 둔 것이다.

**화면**: 위 표 그대로 + 자동 로드/지시로 읽음 두 칸을 색으로 구분
**근거**: `00-internal-metrics.md` § 1 (2026-08-28 재실측값) · `01-context.md` E-5

---

### 숫자로 박아 둔 예산

예산은 감각이 아니라 숫자다. 우리 vault는 세 군데에 숫자를 박아 뒀다.

**1. 상한 하나.** `VAULT_RULES.md`가 `wiki/VAULT_MEMORY.md`에 8 KB(8,192 B) 상한을 걸었다.
현재 2,781 B로 상한의 33.9%다. `wc -c` 바이트 기준이라 lint가 기계적으로 검사한다.
매 실행 서술을 memory에 붙이면 금방 찬다. 그래서 실행 이력은 `docs/vault-ingest-log.md`로
분리했다.

**2. 색인은 작게, 본문은 나중에.** 같은 형태가 vault에 세 번 반복된다.

| 대상 | 상시 로드 | 전량 | 비율 |
| --- | --- | --- | --- |
| 스킬 17개 (메타데이터만) | 6,823 B | 188,371 B | 3.6% |
| auto memory (`MEMORY.md`만) | 496 B | 5,603 B | 8.9% |
| wiki (`INDEX.md`만) | 915 B | 노트 전량 | 색인 915 B |

**3. 원본과 정제본의 분리.** 여기서 `raw/`와 `wiki/`를 나눈 이유가 나온다. `raw/`는 창고이고
`wiki/`는 책상이다. 원본을 그대로 책상에 올리면 자리가 모자란다. 그래서 원본은 `raw/`에
그대로 두고, 컨텍스트에 올릴 정제본만 `wiki/`에 따로 만든다. 이 분리가 오늘 시연할
변환 → 인제스트 경로의 이유다.

토큰 수는 쓰지 않는다. 한국어가 영어보다 토큰을 더 쓰는 방향은 확인되지만, 배수의 공식 수치는
없다. 필요하면 `/context`로 자기 세션을 직접 재서 자기 수치를 만든다.

**화면**: 3곳 반복 표 + `raw/`(창고) ↔ `wiki/`(책상) 대비 그림
**근거**: `00-internal-metrics.md` § 1 (2026-08-28 재실측값) · `01-context.md` A-2 · D-2 · F-1

---

## 03 Skill

> 5분 · 슬라이드 2장

이 섹션을 보면 스킬이 어떤 파일이고 언제 켜지는지 안다. 뒤에 시연할 변환도 스킬 하나가
켜지면서 시작한다.

### 파일 하나로 된 스킬

스킬은 마크다운 파일 하나다. 구조는 두 부분이다 — YAML 프론트매터(`name`·`description`)와
본문. 필수 필드는 `name`과 `description` 둘뿐이고, 나머지는 각자의 관례다.

```yaml
---
name: hwp2md-ingest
description: HWP/HWPX 문서를 vault 인제스트 가능한 마크다운으로 변환한다. ...
---
```

여기서 `description`이 발동 조건이다. Claude는 사용자 요청을 이 문장과 대조해 스킬을 켤지
정한다. 공식 문서도 그렇게 적는다.

> "The `description` is what Claude matches your request against when determining whether to
> trigger the Skill, so it must say both what the Skill does and when to use it."

비유가 아니다. 우리 vault에 안 걸리는 스킬이 실제로 하나 있다.
`config/skills/ollama-local-models.md`에는 프론트매터가 아예 없다. 첫 줄이
`# Skill: ollama-local-models (v1.0.0)`이고 `name`·`description` 문자열이 파일 어디에도 없다.
1단 메타데이터가 0이므로 Claude가 이 스킬의 존재를 알 방법이 없다. 본문이 3,035 B로 잘 쓰여
있어도 켜지지 않는다.

스킬을 만드는 법은 4주차에 다룬다. 오늘은 읽는 법까지다.

**화면**: `hwp2md-ingest` 프론트매터 실물 + `ollama-local-models.md` 첫 줄 실물 나란히
**근거**: `03-skills.md` § 2 · § 5 · § 6 · `00-internal-metrics.md` § 2

---

### 3단 로딩과 상시 비용 3.6%

스킬을 많이 두면 무거워진다는 말은 사실이 아니다. 켜지기 전에 컨텍스트를 차지하는 것은
`name`과 `description`뿐이다.

우리 스킬 17개로 재면 이렇게 나온다.

| 단계 | 무엇이 로드되나 | 크기 | 전량 대비 |
| --- | --- | --- | --- |
| 1단 (상시) | 17개의 `name`·`description` 값 | 6,823 B | **3.6%** |
| 2단 (발동 시) | 해당 스킬의 진입점 `.md` 1개 | 2,678 ~ 18,011 B | — |
| 3단 (필요 시) | 스킬 폴더의 참조 문서·스크립트 | 접근 전 0 | — |
| 전량 | 스킬 폴더 전체 | 188,371 B | 100% |

**셈법을 밝힌다.** 3.6%는 `name`·`description` 값 텍스트만 센 값이다. `---` 구분선을 포함한
프론트매터 블록 전체를 세면 8,508 B = 4.5%가 된다. 세션 시작에 실제로 주입되는 것은 값
텍스트이므로 3.6%를 쓴다.

3단 구조가 눈에 보이는 예가 `pdf2md-ingest`다. 진입점 `SKILL.md`는 8,600 B인데 폴더 전체는
42,348 B다. PDF 변환을 시킬 때 들어오는 것은 8,600 B뿐이고, `scripts/` 3개와
`design.md`·`implementation-plan.md`는 필요할 때만 읽힌다. 설계 문서를 폴더에 넣어도
평소 비용이 없다.

오늘 시연할 `hwp2md-ingest`도 같은 구조다 — `SKILL.md` 8,991 B, 폴더 전체 10,832 B.
`.hwpx` 변환을 요청하면 이 8,991 B가 그때 들어오고, 그 안의 전략 분기표대로 변환 경로가
정해진다. 6단계 시연에서 이 동작을 화면으로 본다.

**화면**: 3단 로딩 표 + `pdf2md-ingest` 폴더 트리(8,600 B / 42,348 B 표시)
**근거**: `03-skills.md` § 3 · § 4 · `00-internal-metrics.md` § 2

---

## 04 MCP

> 3분 · 슬라이드 1장

이 섹션을 보면 MCP가 무엇을 표준화한 것인지, 무엇이 MCP가 아닌지 구분할 수 있다.

### AI 앱의 USB-C 포트

MCP(Model Context Protocol)는 AI 애플리케이션을 외부 시스템에 붙이는 오픈소스 표준이다.
공식 문서가 직접 USB-C에 비유한다.

> "Think of MCP like a USB-C port for AI applications. Just as USB-C provides a standardized
> way to connect electronic devices, MCP provides a standardized way to connect AI
> applications to external systems."

규격이 하나라 붙이는 방법이 하나다. 우리 vault에서는 `config/skills/google-workspace.md`가
그 실물이다.

```bash
uvx workspace-mcp --tools drive sheets slides
```

이 한 줄로 Drive·Sheets·Slides가 붙는다. 세 서비스를 각각 커스텀 스크립트로 만들지 않았다.
서버 하나가 세 서비스의 도구를 한꺼번에 들여온다.

**붙였다고 다 MCP는 아니다.** 같은 폴더의 `ollama-local-models.md`는 로컬 모델을 쓰지만
MCP가 아니다. 파일에 `grep -ci mcp`를 걸면 0이 나온다. 대신 HTTP API를 직접 호출한다.

```bash
curl http://127.0.0.1:11434/api/generate
```

외부 시스템을 붙이는 방법은 여럿이고, MCP는 그중 규격이 정해진 하나다. 이 구분을 못 하면
"연결됐다"는 말과 "MCP로 연결됐다"는 말을 섞어 쓴다.

3주차가 이 클라우드 연동이다 — 드라이브·슬라이드·시트·메일, 텔레그램/카카오톡. 오늘 MCP는
그 준비다.

**화면**: MCP 공식 다이어그램(CC-BY-4.0 표기) + `uvx` 한 줄과 `curl` 한 줄 대비
**근거**: `02-mcp.md` § 1 · § 2 · § 우리 vault 대응 매핑 2·5

---

## 검증 필요

1. ~~바이트 실측값의 측정일이 두 가지다~~ — **2026-08-28 검수에서 해소.** 팀 리드가 전달한
   소계 13,454 · 합계 20,836이 `INDEX.md`를 구값 458 B로 계산한 산수 오류였다. 재검산 결과
   **소계 13,911 · 합계 21,293**이며 본문과 근거 시트를 모두 이 값으로 갱신했다.
2. ~~`raw/`·`Clippings/` 건수가 시트와 outline에서 반대다~~ — **해소.** 두 값 모두 맞다.
   시트 § 3은 시연 전(08-27) 측정, outline § 실습 시작 상태는 시연 산출물 정리 후(08-28)
   측정이다. 시트에 측정 시점을 명기했다. 발표 직전에 다시 센다.
3. **`hwp2md-ingest` 8,991 B / 10,832 B는 팀 리드 확정 목록에 없는 수치다.**
   `00-internal-metrics.md` § 2에서 인용했다. 6단계 시연과 연결하려고 넣었으니, 불필요하면
   문단 마지막 두 문장을 삭제해도 슬라이드가 성립한다.
4. **`hwp2md-ingest` 프론트매터 예시의 `description` 문구를 요약해 적었다.** 원문 전체가
   560 B라 슬라이드에 그대로 넣기 어려워 앞부분만 옮기고 `...`으로 줄였다. 화면에 띄울 때는
   파일을 직접 열어 원문으로 보여주는 편이 안전하다.
5. ~~MCP 도구 38개~~ — **해소.** 지적대로 미확인 수치라 문장에서 빼고 "서버 하나가 세
   서비스의 도구를 한꺼번에 들여온다"로 바꿨다. 슬라이드 요점은 유지된다.
6. ~~개인 설정이 합계에 섞여 있다~~ — **해소.** 좋은 지적이라 표에 `누구나 같은가` 칸을
   넣고 vault 공통 16,039 B / 개인차 5,254 B로 갈랐다. "발표자 환경 실측"임과 `/context`로
   자기 값을 재라는 문장도 본문에 넣었다.
