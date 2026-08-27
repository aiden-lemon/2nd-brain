---
type: run-log
kind: ingest
run_date: "2026-08-28"
author: aiden-lemon
summary: "클리핑 2건 처리 — Reddit 멀티에이전트 구성글에서 wiki 4건 신설, hwpx 교육용 샘플은 raw 보존만"
pr: 12
processed: 2
new_notes: 4
updated_notes: 0
tags:
  - ai-agents
  - hwp2md
sources:
  - "raw/드디어 나에게 딱 맞았던 AI 에이전트 설정 Hermes + OpenAI Codex + Claude Code.md"
  - "raw/점검-결과-보고.md"
  - "raw/hwp/점검-결과-보고.hwpx"
notes:
  - "[[multi-agent-role-separation|Multi-Agent Role Separation]]"
  - "[[hermes-agent|Hermes Agent]]"
  - "[[claude-code|Claude Code]]"
  - "[[claude-subscription-billing-boundary|Claude Subscription and API Billing Boundary]]"
---

# 2026-08-28 Ingest (aiden-lemon)

## Summary

`Clippings/` 2건을 처리했다. Reddit 게시글 1건에서 wiki article 4건과 topic page
`ai-agents` 1건을 새로 만들었고, hwpx 변환 산출물 1건은 raw 보존만 하고 wiki화하지
않았다. 이 vault의 첫 ingest run이며, 이전까지 wiki article은 0개였다.

## Details

**처리 1 — Reddit `r/hermesagent` 게시글 (18.9 KB, 본문 + 댓글 15스레드)**

본문의 스택·워크플로우와 댓글에서만 나오는 운영 정보(PATH 이슈, `-p` 과금 버그,
tmux 전환)를 함께 읽어 4개 개념으로 분해했다.

| 노트 | type | status | 분해 근거 |
| --- | --- | --- | --- |
| `multi-agent-role-separation` | pattern | draft | 게시글의 중심 주장. 5층 역할 배분표와 4단계 워크플로우가 여기 모인다 |
| `hermes-agent` | tool | stub | 오케스트레이터 자리의 구체 도구. 본문 + 댓글의 PATH·tmux 운영 정보 |
| `claude-code` | tool | stub | 전문가 자리의 구체 도구. 서브프로세스 호출 방식이 별도 개념 |
| `claude-subscription-billing-boundary` | concept | needs-update | 시간 민감 + 미검증 주장이 몰려 있어 다른 노트에 섞지 않고 분리 |

`status`를 3종으로 나눈 근거: 역할 분리 패턴만 350단어를 넘고 자체 논증이 서므로
`draft`, 도구 노트 2건은 출처 1건에서 얻은 사실만 담아 분량이 짧아 `stub`.

과금 노트는 `needs-update`로 열어 뒀다. 2026-06-15 정책 변경, 티어별 크레딧 금액,
`-p` 헤드리스 자동 전환 버그, 하네스 시그니처 분류기 주장 — 넷 다 Reddit 게시글과
전언이 유일한 근거이고 1차 출처로 확인되지 않았다. 게시 시점(2026-05) 기준으로도
미래 날짜였고 오늘(2026-08-28) 기준으로는 이미 지난 날짜라 현재 조건이 다를 수 있다.
노트 본문 상단에도 같은 경고를 박았다.

Ollama 로컬 LLM이 "너무 느렸다"는 서술은 작성자 하드웨어 조건의 관찰로만 남기고
일반 성능 결론으로 승격하지 않았다.

**처리 2 — `점검-결과-보고.md` (hwpx 변환 산출물, 403자)**

같은 세션에서 `hwp2md-ingest`(H1 경로)로 변환해 `Clippings/`에 투입한 파일이다.
원문 머리말에 "대외비 아님 (교육용 샘플)"이 명시된 합성 문서이고, 내용은 가상의
압축기 점검 측정값(CMP-02/CMP-03)과 조치 사항이다.

wiki 노트를 만들지 않았다. 실측이 아닌 합성 수치를 wiki article로 올리면 이 vault의
지식 계층에 검증 불가능한 도메인 사실이 들어간다. 원문은 `raw/점검-결과-보고.md`로,
바이너리 원본은 `raw/hwp/점검-결과-보고.hwpx`로 보존해 변환 파이프라인의 증거로만
남긴다.

**색인·메모리**

- `wiki/INDEX.md` — Articles 섹션 신설(4건), Topics에 `ai-agents` 추가
- `wiki/TOPIC_MAP.md` — root topic에 `ai-agents` 추가
- `wiki/VAULT_MEMORY.md` — `Last Ingest` 한 줄 교체, `Volume to date`·`Verification queue` 갱신. `wc -c` 2783 (8 KB 캡 이내)

## Dropped / Issues

- `점검-결과-보고.md` — wiki화 보류. 사유는 위 "처리 2". 실제 설비 점검 데이터가
  들어오면 그때 도메인 노트를 세우는 편이 낫다.
- `claude-subscription-billing-boundary` — `needs-update` 1건이 검증 큐에 남는다.
  Anthropic 공식 공지로 2026-06-15 정책 변경 여부와 현재 조건을 확인해야 한다.
- `docs/raw-index.md`는 이번 실행에서 재생성하지 않았다 — `vault-lint` 패스의 몫이며
  이번에 raw 루트 파일이 2건 늘었으므로 다음 lint 때 반영된다.
- 이번 ingest와 무관한 미커밋 변경(`Untitled.base` 삭제, `projects/second-brain/outputs/week2-*`,
  `projects/second-brain/samples/`)은 사용자 확인 후 손대지 않고 워킹트리에 남겼다.
