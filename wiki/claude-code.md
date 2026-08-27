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

# Claude Code

## Summary

Anthropic의 터미널 코딩 에이전트 CLI. 자체 OAuth로 사용자의 Claude 구독에 인증하므로,
외부 오케스트레이터가 서브프로세스로 호출해도 Anthropic API를 직접 건드리지 않는다 —
출처가 이 도구를 "구독 기반 코딩 전문가"로 배치한 이유다.

## Use Cases

- [[multi-agent-role-separation|역할 분리 구성]]에서 범위가 좁혀진 코딩 작업 담당
- 오케스트레이터가 셸 아웃으로 호출: `claude -p "여기에 작업" --max-turns 10`
- 긴 세션은 tmux 안에서 대화형으로 실행하고 오케스트레이터가 모니터링

## Setup Notes

- 래퍼나 커스텀 스킬 없이 서브프로세스 호출만으로 충분하다는 것이 출처의 보고다.
- [[hermes-agent|Hermes]]가 관리하는 Node 설치는 바이너리를 `~/.hermes/node/bin/claude`에
  두며 기본 PATH에 없다. 셸 rc에 경로를 추가하거나 `~/.local/bin/`으로 심볼릭 링크한다.
- 과금 경로 점검: `claude /status`, `echo $ANTHROPIC_API_KEY` —
  [[claude-subscription-billing-boundary|과금 경계]] 참고.

## Related Concepts

- [[multi-agent-role-separation|Multi-Agent Role Separation]]
- [[hermes-agent|Hermes Agent]]
- [[claude-subscription-billing-boundary|Claude Subscription and API Billing Boundary]]

## Open Questions

- 프로그래밍 방식 호출(`-p`, SDK)의 과금 귀속은 2026-06-15부로 바뀐다고 출처가 전한다.
  이 노트의 CLI 위임 패턴이 그 이후에도 같은 비용으로 성립하는지는 확인되지 않았다.
