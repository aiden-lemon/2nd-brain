---
type: tool
topics:
  - "[[wiki/topics/ai-agents|AI Agents]]"
status: stub
sources:
  - "raw/드디어 나에게 딱 맞았던 AI 에이전트 설정 Hermes + OpenAI Codex + Claude Code.md"
created: "2026-08-28"
updated: "2026-08-28"
---

# Hermes Agent

## Summary

항상 켜져 있는 코디네이터 역할의 에이전트 런타임. 메모리, 도구, 예약 작업(cron),
메시징을 갖추고 로컬 머신에서 실제 작업을 수행한다 — 이메일 발송, 스크립트 실행, 파일
확인, Telegram 통신, cron 관리, 작업 조정.

## Use Cases

- [[multi-agent-role-separation|멀티 에이전트 역할 분리]] 구성에서 오케스트레이터 자리
- 코딩 작업을 [[claude-code|Claude Code]] CLI에 서브프로세스로 위임하고 결과를 검증·보고
- Telegram을 원격 제어 인터페이스로 붙여 터미널 밖에서 시스템에 접근

## Setup Notes

- 메인 추론 모델은 OpenAI OAuth(ChatGPT 구독)로 연결할 수 있다. API 키를 붙이면 토큰당
  과금으로 넘어간다 — [[claude-subscription-billing-boundary|과금 경계]] 참고.
- Hermes가 관리하는 Node는 `claude` 바이너리를 `~/.hermes/node/bin/claude`에 두는데 기본
  PATH에 없다. 출처 작성자는 이를 셸 rc에 추가하고 `~/.local/bin/`으로 심볼릭 링크했다.
- 긴 세션은 `claude -p` 대신 tmux 세션에서 대화형으로 돌리고 Hermes가 모니터링하는 구성을 쓴다.

## Related Concepts

- [[multi-agent-role-separation|Multi-Agent Role Separation]]
- [[claude-code|Claude Code]]

## Open Questions

- 이 노트의 근거는 Reddit 게시글 1건이다. 공식 문서로 교차 확인되지 않았다 (needs-update).
- 프로필·에이전트 간 통신·워커 서비스는 댓글에서만 언급되며 구성 방법은 나오지 않는다.
