---
type: concept
topics:
  - "[[wiki/topics/ai-agents|AI Agents]]"
status: needs-update
sources:
  - "raw/드디어 나에게 딱 맞았던 AI 에이전트 설정 Hermes + OpenAI Codex + Claude Code.md"
created: "2026-08-28"
updated: "2026-08-28"
---

# Claude Subscription and API Billing Boundary

## Summary

구독(OAuth) 경로로 도는 호출과 API 키 경로로 도는 호출 사이의 경계. 에이전트 구성에서
이 경계를 잘못 넘으면 정액제인 줄 알았던 워크로드가 토큰당 과금으로 조용히 새어나간다.

**이 노트의 모든 사실은 Reddit 게시글과 그 댓글이 유일한 출처이며, Anthropic 공식
공지로 교차 확인되지 않았다. 금액·날짜를 의사결정에 쓰기 전에 반드시 1차 출처를
확인할 것 (needs-update).**

## Details

**성립하는 경계** — 오케스트레이터가 [[claude-code|Claude Code]] CLI를 서브프로세스로
호출하면 CLI가 자체 OAuth로 구독에 인증하므로 오케스트레이터는 Anthropic API를 전혀
호출하지 않는다. 반대로 구독을 "오케스트레이터가 API로 직접 부르는 모델 제공자"로
쓰는 것은 불가능하다.

**2026-06-15 정책 변경 (출처 주장, 미검증)** — `claude -p`와 Agent SDK 사용이 구독
풀에서 분리되고 티어별 월간 크레딧(Pro $20 / Max 5x $100 / Max 20x $200)으로 청구되며
이월되지 않는다. 터미널의 대화형 사용은 구독에 남는다. 프로그래밍 방식(`-p`, SDK,
GitHub Actions, 서드파티 하네스)은 새 크레딧 풀로 이동한다.

**빌링 이스케이프 해치 두 가지 (출처 주장, 미검증)**

1. `ANTHROPIC_API_KEY`가 설정되지 않았는데도 `-p` 헤드리스 모드가 구독 대신 API 요금으로
   자동 전환되는 버그가 일부 사용자에게 보고됨.
2. 페이로드에 남은 하네스 시그니처가 서드파티 하네스 사용 분류기를 트리거해 API로
   라우팅된다는 주장 — 커밋 메시지의 `HERMES.md` 문자열 때문에 $200이 청구된 사례로
   전해진다. 전언이며 검증되지 않았다.

**점검 절차** — `claude /status` 실행, 제공자 콘솔에서 예상치 못한 API 사용량 확인,
업스트림에 노출되는 프로젝트 파일에 하네스 이름 문자열이 있는지 스캔.

**일반 습관** — API 키를 붙일 일이 생기면 먼저 제공자 결제 대시보드에서 월 상한을
설정한다.

## Connections

- [[claude-code|Claude Code]] — 구독 인증으로 도는 CLI
- [[hermes-agent|Hermes Agent]] — API 키 대신 OAuth로 붙이면 정액제 유지
- [[multi-agent-role-separation|Multi-Agent Role Separation]] — 역할 배분의 비용 제약

## Open Questions

- 2026-06-15 정책 변경의 1차 출처(Anthropic 공지)를 확인하지 못했다. 오늘 기준 이미
  지난 날짜이므로 현재 실제 조건을 다시 조사해야 한다.
- 하네스 시그니처 분류기 주장은 재현 가능한 근거가 없다.
