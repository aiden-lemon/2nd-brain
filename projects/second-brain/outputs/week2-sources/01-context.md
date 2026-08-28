# 01. 컨텍스트(Context) — 1차 근거 자료

수집일: 2026-08-27. 모든 항목은 WebFetch/WebSearch로 실제 문서를 열어 확인했다.
1순위는 Anthropic 공식 문서(platform.claude.com, code.claude.com, anthropic.com/engineering)다.
2차 자료는 항목에 명시했다. 총 23개 소주제.

각 항목은 `쓸 곳`(교육에서 뒷받침할 주장)과 `우리 vault 대응`(이 근거가 설명하는 우리 파일·수치) 두 필드를
함께 갖는다. 우리 쪽 수치는 전부 이 저장소에서 직접 측정했고, 측정값과 셈법은 파일 끝
`## 우리 vault 실측값`에 정리했다. 전달받은 값과 다른 두 지점도 거기에 적었다.
근거와 우리 파일의 1:1 대응은 마지막 `## 우리 vault 대응 매핑` 표에 있다.

---

## A. 컨텍스트 엔지니어링

### A-1. 컨텍스트 엔지니어링의 정의

- **출처**: Effective context engineering for AI agents (Anthropic Engineering) — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **날짜**: 2025-09-29
- **핵심 인용**:
  > "Context refers to the set of tokens included when sampling from a large-language model (LLM)."
  > "Context engineering refers to the set of strategies for curating and maintaining the optimal set of tokens (information) during LLM inference, including all the other information that may land there outside of the prompts."
  (컨텍스트는 LLM에서 샘플링할 때 포함되는 토큰 집합이다. 컨텍스트 엔지니어링은 추론 중 최적의 토큰 집합을 선별하고 유지하는 전략의 총체이며, 프롬프트 밖에서 들어오는 정보까지 포함한다.)
- **프롬프트 엔지니어링과의 차이**: 프롬프트 엔지니어링은 "how to write effective prompts, particularly system prompts"에 집중한다. 컨텍스트 엔지니어링은 "the entire context state (system instructions, tools, Model Context Protocol (MCP), external data, message history, etc)"를 여러 턴에 걸쳐 관리한다. 후자는 "iterative" 하며 "each time we decide what to pass to the model" 반복된다.
- **수치**: 출처에 수치 없음
- **쓸 곳**: 컨텍스트는 프롬프트의 상위 개념이다. 프롬프트를 잘 쓰는 것과 컨텍스트를 잘 관리하는 것은 다른 일이다.
- **우리 vault 대응**: 우리 vault는 프롬프트 문구가 아니라 **파일 배치**로 컨텍스트를 관리한다. `CLAUDE.md`(2,128 B)가 진입점이고, 상세 계약은 `VAULT_RULES.md`(10,215 B)로 내보내 필요할 때만 읽게 했다. 이 분리 자체가 컨텍스트 엔지니어링이며, 프롬프트 엔지니어링으로는 설명되지 않는다.
- **다이어그램**: 문서에 2개 있다. "Prompt engineering vs. context engineering", "Calibrating the system prompt in the process of context engineering". 이미지 직접 URL은 확인하지 못했다. 사용 조건 표기 없음 — 재사용 전 확인 필요.

### A-2. 지도 원칙 — 최소 고신호 토큰

- **출처**: 동일 문서
- **날짜**: 2025-09-29
- **핵심 인용**:
  > "Find the smallest set of high-signal tokens that maximize the likelihood of your desired outcome."
  (원하는 결과가 나올 확률을 최대화하는, 가장 작은 고신호 토큰 집합을 찾는다.)
- **수치**: 출처에 수치 없음
- **쓸 곳**: 컨텍스트 관리의 목표는 "많이 넣기"가 아니라 "적게 넣고 정확히 넣기"다. 교육 자료 전체를 관통하는 한 줄.
- **우리 vault 대응**: `wiki/INDEX.md`가 **458 B**다. 위키 전체 목록을 458바이트 색인으로 압축해 두고, 본문은 필요한 노트만 읽는다. `wiki/VAULT_MEMORY.md`의 **8 KB 상한**도 같은 원칙의 수치화다 (현재 2,707 B = 상한의 33%).
- **다이어그램**: 없음

---

## B. 컨텍스트 창의 물리적 한계

### B-1. 컨텍스트 창의 정의와 "작업 기억" 비유

- **출처**: Context windows (Claude Platform Docs) — https://platform.claude.com/docs/en/build-with-claude/context-windows
- **날짜**: 미표기 (문서 상시 갱신형)
- **핵심 인용**:
  > "The 'context window' refers to all the text a language model can reference when generating a response, including the response itself. This is different from the large corpus of data the language model was trained on, and instead represents a 'working memory' for the model."
  (컨텍스트 창은 모델이 답을 생성할 때 참조할 수 있는 모든 텍스트이며, 응답 자체도 포함한다. 학습에 쓴 대규모 데이터와는 다르고, 모델의 '작업 기억'에 해당한다.)
  > "A larger context window allows the model to handle more complex and lengthy prompts, but more context isn't automatically better."
  (컨텍스트 창이 크면 더 복잡하고 긴 프롬프트를 다룰 수 있지만, 컨텍스트가 많다고 자동으로 좋아지지는 않는다.)
- **수치**: 출처에 수치 없음
- **쓸 곳**: 학습 데이터와 컨텍스트는 다른 것이다. 비개발자가 가장 먼저 혼동하는 지점이다.
- **우리 vault 대응**: vault 3계층이 이 구분을 그대로 구현한다. `raw/`(append-only 원본)는 컨텍스트에 올리지 않는 장기 저장소, `wiki/`는 작업 기억에 올릴 정제본, `Clippings/`는 수집 대기다. 'raw를 읽지 말고 wiki를 읽는다'는 규칙의 근거가 이 문장이다.
- **다이어그램**: 있음 — https://platform.claude.com/docs/images/context-window.svg (턴이 누적되어 토큰 한계에 접근하는 그림). 다른 2개: context-window-thinking.svg, context-window-thinking-tools.svg. 사용 조건 표기 없음.

### B-2. 컨텍스트 창에는 무엇이 들어가는가

- **출처**: 동일 문서
- **날짜**: 미표기
- **핵심 인용**:
  > "Everything in the request counts toward the context window: the system prompt, every message in `messages` (including tool results, images, and documents), and your tool definitions. The output Claude generates for the turn, including its extended thinking, counts too."
  (요청의 모든 것이 컨텍스트 창에 계산된다. 시스템 프롬프트, messages의 모든 메시지(도구 결과·이미지·문서 포함), 도구 정의가 그렇다. 그 턴에 생성하는 출력과 확장 사고도 계산된다.)
  > "Cached prompt prefixes still occupy the context window: prompt caching changes what you pay for those tokens, not whether they count."
  (캐시된 프롬프트 접두부도 컨텍스트 창을 차지한다. 프롬프트 캐싱은 그 토큰의 비용을 바꿀 뿐, 계산 여부를 바꾸지 않는다.)
- **수치**: 출처에 수치 없음
- **쓸 곳**: 도구 정의와 시스템 프롬프트도 컨텍스트를 먹는다. "내가 쓴 글자"만 컨텍스트가 아니다.
- **우리 vault 대응**: 실측으로 **20,762 B**가 첫 글자를 치기 전에 들어온다 — 자동 로드 7,382 B(`~/.claude/CLAUDE.md` 3,298 + `~/.claude/rules/lemon-rules.md` 1,460 + `CLAUDE.md` 2,128 + auto memory `MEMORY.md` 496)와 `CLAUDE.md`가 읽으라고 지시하는 13,380 B(`VAULT_RULES.md` 10,215 + `wiki/VAULT_MEMORY.md` 2,707 + `wiki/INDEX.md` 458). 도구 스키마와 스킬 목록은 여기에 더해진다.
- **다이어그램**: 위 3개 svg

### B-3. 모델별 컨텍스트 창 크기와 출력 상한

- **출처**: 동일 문서, § Context window sizes by model
- **날짜**: 미표기
- **핵심 인용**:
  > "Claude Opus 5, Claude Opus 4.8, Claude Opus 4.7, Claude Opus 4.6, Claude Sonnet 5, and Claude Sonnet 4.6 have a 1M-token context window on the Claude API, Amazon Bedrock, Google Cloud, and Microsoft Foundry."
  > "A single request to any model with a 1M-token context window can generate up to 128k output tokens (`max_tokens`). Other Claude models, including Claude Sonnet 4.5, have a 200k-token context window."
  > "For every model with a 1M-token context window, 1M is the default: you don't need a beta header, and long-context requests are billed at standard pricing."
- **수치**:
  - 1M 토큰 컨텍스트: Opus 5 / 4.8 / 4.7 / 4.6, Sonnet 5, Sonnet 4.6, Fable 5, Mythos 5
  - 200K 토큰 컨텍스트: Sonnet 4.5 등 그 외 모델 (Haiku 4.5 포함)
  - 단일 요청 최대 출력: 128K 토큰
  - 한 요청에 이미지·PDF 페이지 최대 600장 (200K 모델은 100장)
  - 1M 초과 프리미엄 요금 없음 — "standard pricing"
- **쓸 곳**: 컨텍스트 창은 무한이 아니라 숫자로 정해진 값이다. 지금 기준 최대는 1,000,000 토큰이다.
- **우리 vault 대응**: 20,762 B는 대략 6~9천 토큰이다. 1M 창에서는 1% 미만이지만 200K 창에서는 3~5%다. 즉 우리 vault의 8 KB·200줄 상한은 1M 시대에도 유효한 게 아니라, **200K로 떨어질 때를 대비한 보험**이다. 교육에서 두 창을 나눠 계산해 보여야 한다.
- **다이어그램**: 없음

### B-4. 컨텍스트 인식 — 모델이 남은 예산을 안다

- **출처**: 동일 문서, § Context awareness
- **날짜**: 미표기
- **핵심 인용**:
  > "Claude Sonnet 5, Claude Sonnet 4.6, Claude Sonnet 4.5, and Claude Haiku 4.5 have **context awareness:** these models track their remaining context window (their 'token budget') throughout a conversation."
  API가 시스템 프롬프트에 주입하는 태그: `<budget:token_budget>200000</budget:token_budget>`, 도구 호출 후 `<system_warning>Token usage: 35000/200000; 165000 remaining</system_warning>`
- **수치**: 예시 태그 기준 200,000 / 35,000 사용 / 165,000 잔여. Sonnet 5·4.6은 1M, Sonnet 4.5·Haiku 4.5는 200K가 예산값이다.
- **쓸 곳**: 남은 컨텍스트는 추상적 감각이 아니라 모델에게 숫자로 주입되는 값이다. 교육 자료에 실제 태그를 그대로 보여줄 수 있다.
- **우리 vault 대응**: 우리 vault는 모델의 자동 예산 추적에 의존하지 않고, `VAULT_RULES.md`가 `wiki/VAULT_MEMORY.md`에 **8 KB(`wc -c`)** 상한을 사람이 검증 가능한 숫자로 박아 뒀다. `wc -c`로 재는 바이트 기준이라 lint가 기계적으로 검사한다.
- **다이어그램**: 없음

### B-5. 한계 초과 시 실제로 벌어지는 일

- **출처**: 동일 문서, § Context window overflow behavior
- **날짜**: 미표기
- **핵심 인용**:
  > "If the input alone already exceeds the model's context window, the API returns a 400 `invalid_request_error` ('prompt is too long') on every model."
  > "On Claude 4.5 models and newer, if input tokens plus `max_tokens` exceeds the context window size, the API accepts the request. If generation then reaches the context window limit, it stops with `stop_reason: 'model_context_window_exceeded'`."
- **수치**: HTTP 400
- **쓸 곳**: 컨텍스트 한계는 성능이 나빠지는 정도가 아니라, 넘으면 요청 자체가 거절되는 물리적 벽이다.
- **우리 vault 대응**: `raw/`의 원본을 그대로 컨텍스트에 올리면 400에 걸릴 수 있다. `raw/` → `wiki/` 정제 단계가 선택이 아니라 필수인 이유가 이 오버플로 동작이다.
- **다이어그램**: 없음

---

## C. 컨텍스트가 길어질 때 성능이 떨어지는 현상

### C-1. context rot — 공식 문서의 정의

- **출처**: Context windows (Claude Platform Docs) — https://platform.claude.com/docs/en/build-with-claude/context-windows
- **날짜**: 미표기
- **핵심 인용**:
  > "As token count grows, accuracy and recall degrade, a phenomenon known as *context rot*. This makes curating what's in context just as important as how much space is available."
  (토큰 수가 늘면 정확도와 회상이 떨어진다. 이 현상을 context rot이라 한다. 그래서 무엇을 컨텍스트에 담을지 선별하는 일이, 공간이 얼마나 있는지와 똑같이 중요하다.)
- **수치**: 출처에 수치 없음 (정의만)
- **쓸 곳**: "context rot"은 블로거 용어가 아니라 Anthropic 공식 문서에 실린 용어다.
- **우리 vault 대응**: `wiki/VAULT_MEMORY.md`의 **8 KB 상한**이 정확히 이 근거로 존재한다. 메모리 파일이 커지면 세션마다 정확도를 깎는다. "per-run narrative를 append하지 말라"는 `CLAUDE.md` 규칙도 여기서 나온다.
- **다이어그램**: 없음

### C-2. attention budget과 트랜스포머 구조상의 이유

- **출처**: Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **날짜**: 2025-09-29
- **핵심 인용**:
  > "Like humans, who have limited working memory capacity, LLMs have an 'attention budget' that they draw on when parsing large volumes of context. Every new token introduced depletes this budget by some amount."
  > "Context, therefore, must be treated as a finite resource with diminishing marginal returns."
  > "[The transformer architecture] enables every token to attend to every other token across the entire context. This results in n² pairwise relationships for n tokens."
  > "Models develop their attention patterns from training data distributions where shorter sequences are typically more common than longer ones. This means models have less experience with, and fewer specialized parameters for, context-wide dependencies."
  > "Models remain highly capable at longer contexts but may show reduced precision for information retrieval and long-range reasoning compared to their performance on shorter contexts."
  (모델은 긴 컨텍스트에서도 충분히 유능하지만, 짧은 컨텍스트에 비해 정보 검색과 장거리 추론의 정밀도가 떨어질 수 있다.)
- **수치**: n개 토큰에 n² 쌍관계. 그 외 수치 없음.
- **쓸 곳**: 성능 저하에는 두 가지 구조적 이유가 있다 — 토큰 수의 제곱으로 늘어나는 관계 수, 그리고 짧은 문장이 많은 학습 데이터 분포. 절벽이 아니라 기울기다.
- **우리 vault 대응**: 우리 상시 로드 20,762 B 중 `VAULT_RULES.md`가 **10,215 B — 절반**이다. attention budget 관점에서 가장 먼저 줄일 후보가 어디인지 숫자가 지목한다. 다만 이 파일은 자동 로드가 아니라 지시로 읽히므로, 진짜 자동 로드분(7,382 B)과 구분해 설명해야 한다.
- **다이어그램**: 위 A-1의 2개 외 없음

### C-3. Chroma "Context Rot" 기술 보고서 — 18개 모델 실측

- **출처**: Context Rot: How Increasing Input Tokens Impacts LLM Performance (Chroma, 기술 보고서) — https://www.trychroma.com/research/context-rot
- **날짜**: 2025-07-14. 저자 Kelly Hong, Anton Troynikov, Jeff Huber
- **분류**: 1차 근거이나 Anthropic 공식이 아닌 외부 연구. 위 C-1 공식 문서가 이 유형의 연구를 인용하는 맥락이다.
- **핵심 인용**:
  > "Models do not use their context uniformly; instead, their performance grows increasingly unreliable as input length grows."
  (모델은 컨텍스트를 균일하게 쓰지 않는다. 입력이 길어질수록 성능은 점점 더 불안정해진다.)
  > "Models perform better on shuffled haystacks than on logically structured ones."
  (모델은 논리적으로 구조화된 건초더미보다 무작위로 섞은 건초더미에서 더 잘한다.)
- **수치**:
  - 평가 모델 18개 (Claude Opus 4·Sonnet 4·Sonnet 3.7·Sonnet 3.5·Haiku 3.5, o3, GPT-4.1 계열, GPT-4o, GPT-4 Turbo, GPT-3.5 Turbo, Gemini 2.5 Pro/Flash, 2.0 Flash, Qwen3-235B/32B/8B)
  - LongMemEval: 집중 프롬프트 약 300 토큰 vs 전체 프롬프트 약 113,000 토큰, 306개 과제. "Claude models exhibit the most pronounced gap between focused and full prompt performance"
  - 방해 문서(distractor) 0개 → 1개 → 4개 순으로 성능 단계적 하락
  - 반복 단어 과제: 25~10,000 단어 구간에서 전 모델 일관 저하. 거부율 GPT-4.1 2.55%, Claude Opus 4 2.89%
- **쓸 곳**: "컨텍스트가 길어지면 나빠진다"는 인상이 아니라 18개 모델에서 재현된 측정 결과다. 특히 300 토큰과 113K 토큰의 대비는 교육 자료의 핵심 수치로 쓸 수 있다.
- **우리 vault 대응**: 300 토큰 대 113K 토큰의 대비가 우리 방식과 정확히 겹친다. `wiki/INDEX.md` 458 B로 색인해 필요한 노트 1~2개만 읽는 것이 '집중 프롬프트'이고, `raw/` 전체를 투입하는 것이 '전체 프롬프트'다. Claude 모델이 이 격차가 가장 크다는 결과도 그대로 인용할 수 있다.
- **다이어그램**: 있음 — /img/context_rot/header_plot.jpg, /img/context_rot/hero_plot.png, /img/context_rot/niah_lexical.png (경로는 trychroma.com 기준 상대 경로). 사용 조건 표기 미확인.

### C-4. lost-in-the-middle — 위치에 따른 U자 성능 곡선

- **출처**: Nelson F. Liu 외, "Lost in the Middle: How Language Models Use Long Contexts", TACL Vol.12, pp.157–173 — https://aclanthology.org/2024.tacl-1.9/
- **날짜**: 2024 (TACL 게재). DOI 10.1162/tacl_a_00638
- **분류**: 학술 논문. Anthropic 공식 아님.
- **핵심 인용** (초록 원문):
  > "We observe that performance is often highest when relevant information occurs at the beginning or end of the input context, and significantly degrades when models must access relevant information in the middle of long contexts, even for explicitly long-context models."
  (관련 정보가 입력 컨텍스트의 처음이나 끝에 있을 때 성능이 가장 높고, 긴 컨텍스트의 중간에 있는 정보를 써야 할 때는 크게 떨어진다. 명시적으로 장문 컨텍스트용인 모델에서도 그렇다.)
- **수치**: 초록에는 수치 없음. 과제는 multi-document QA와 key-value retrieval 2종. (검색 요약에서 "중간 위치일 때 20~30점 하락"이라는 서술이 돌지만 초록에서 확인되지 않아 인용하지 않는다 — § 확인 못 한 것 참조.)
- **쓸 곳**: 중요한 정보는 맨 앞이나 맨 뒤에 둔다. 긴 문서 중간에 묻은 지시는 무시될 수 있다.
- **우리 vault 대응**: `VAULT_RULES.md` 10,215 B의 중간에 묻힌 규칙은 무시될 수 있다. 그래서 `CLAUDE.md`가 `## Hard Invariants`를 문서 앞쪽에 두고, 거기서 `VAULT_RULES.md`의 해당 절을 다시 가리킨다. 중요한 것을 앞에 두는 이 배치가 논문의 U자 곡선에 대한 대응이다.
- **다이어그램**: 논문 내 U자 곡선 그림 있으나 URL·라이선스 미확인

---

## D. 컨텍스트를 관리하는 실제 장치

### D-1. compaction — 요약해서 새 창을 연다

- **출처**: Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents / Context windows — https://platform.claude.com/docs/en/build-with-claude/context-windows
- **날짜**: 2025-09-29 / 미표기
- **핵심 인용**:
  > "Compaction [is] taking a conversation nearing the context window limit, summarizing its contents, and reinitiating a new context window with the summary."
  > "The art [is in the] selection of what to keep versus what to discard, as overly aggressive compaction can result in the loss of subtle but critical context."
  (무엇을 남기고 무엇을 버릴지가 기술이다. 너무 과하게 압축하면 미묘하지만 결정적인 컨텍스트를 잃는다.)
  공식 문서: "For long-running conversations and agentic workflows, server-side compaction is the primary strategy for context management."
- **수치**: 서버 사이드 compaction은 Claude 4.6 이후 모델에서 베타로 제공된다.
- **쓸 곳**: 대화가 길어지면 기록을 요약해 새 창에서 이어간다. 요약은 무손실이 아니다.
- **우리 vault 대응**: 실행 이력을 auto memory에서 `docs/vault-ingest-log.md`(828 B)로 분리한 결정이 바로 이 원칙이다. 이력은 요약하면 잃는 정보이므로 컨텍스트 밖 파일에 보관하고, 메모리는 8 KB 안에서 포인터만 유지한다.
- **다이어그램**: 없음

### D-2. just-in-time 검색과 progressive disclosure

- **출처**: Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **날짜**: 2025-09-29
- **핵심 인용**:
  > Agents "maintain lightweight identifiers (file paths, stored queries, web links, etc.) and use these references to dynamically load data into context at runtime using tools."
  > "Progressive disclosure allows agents to incrementally discover relevant context through exploration. Each interaction yields context that informs the next decision: file sizes suggest complexity; naming conventions hint at purpose; timestamps can be a proxy for relevance."
  > "[This] mirrors human cognition: we generally don't memorize entire corpuses of information, but rather introduce external organization and indexing systems like file systems, inboxes, and bookmarks to retrieve relevant information on demand."
  (이는 인간의 인지를 닮았다. 사람은 정보 전체를 암기하지 않고, 파일 시스템·받은편지함·북마크 같은 외부 조직·색인 체계를 만들어 필요할 때 꺼낸다.)
- **수치**: 출처에 수치 없음
- **쓸 곳**: 모든 자료를 미리 넣지 않고, 위치만 알고 필요할 때 꺼낸다. 비개발자에게는 "책을 다 외우지 않고 목차와 색인을 쓴다"로 설명할 수 있다.
- **우리 vault 대응**: 우리 vault에 이미 세 겹으로 구현돼 있다. ① `wiki/INDEX.md` 458 B 색인 → 필요한 노트만 읽기. ② 스킬 17개 중 메타데이터만 상시 로드(6,823 B = 전량 188,371 B의 **3.6%**, 약 1/28). ③ auto memory `MEMORY.md` 496 B만 상시 로드, 토픽 파일 3개 5,107 B는 온디맨드(색인이 전체의 8.9%). 세 사례 모두 '색인은 작게, 본문은 나중에'라는 같은 형태다.
- **다이어그램**: 없음

### D-3. sub-agent로 컨텍스트를 격리한다

- **출처**: Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **날짜**: 2025-09-29
- **핵심 인용**:
  > "Specialized sub-agents can handle focused tasks with clean context windows. The main agent coordinates with a high-level plan while subagents perform deep technical work or use tools to find relevant information."
  각 sub-agent는 "a condensed, distilled summary of its work (often 1,000-2,000 tokens)"를 돌려준다.
- **수치**: sub-agent 반환 요약 통상 1,000~2,000 토큰
- **쓸 곳**: 무거운 탐색은 별도 에이전트에 맡기고 결과 요약만 받는다. 본 대화의 컨텍스트를 지킨다.
- **우리 vault 대응**: `vault-ingest-claude.md` 스킬이 잉게스트를 위임하는 구조가 이것이다. `raw/` 원본을 sub-agent가 읽고, 메인 컨텍스트에는 정제 결과 요약만 돌아온다. 1,000~2,000 토큰이라는 반환 규모가 우리 위임 설계의 기준값이 된다.
- **다이어그램**: 없음

### D-4. sub-agent 격리의 실측 — 6,100 토큰이 420 토큰으로

- **출처**: Explore the context window (Claude Code Docs) — https://code.claude.com/docs/en/context-window
- **날짜**: 미표기 (v2.1.198·v2.1.234 등 버전 언급 있음 — 2026년 중반 기준 문서)
- **핵심 인용**:
  > "Only the subagent's final text response comes back to your context, plus a small metadata trailer with token counts and duration. The subagent read 6,100 tokens of files. You got a 420-token result. That's the context savings."
  > "The subagent loads CLAUDE.md too. Same file, same content, but it counts against the subagent's context, not yours. The built-in Explore and Plan agents skip this for a smaller context."
- **수치**: sub-agent가 읽은 파일 6,100 토큰 → 메인 컨텍스트에 돌아온 것 420 토큰. sub-agent 자체 시스템 프롬프트 900 토큰, CLAUDE.md 사본 1,800 토큰, MCP 도구+스킬 970 토큰, 위임 과제 프롬프트 120 토큰.
- **쓸 곳**: 컨텍스트 격리의 효과를 숫자 하나로 보여줄 수 있다. 6,100 → 420.
- **우리 vault 대응**: 6,100 → 420이라는 비율(약 1/15)이 우리 잉게스트 위임의 기대 효과다. `raw/` 파일 하나가 수천 토큰이어도 메인 컨텍스트는 요약만 받는다. 다만 sub-agent도 `CLAUDE.md` 사본 1,800 토큰을 자기 컨텍스트에 싣는다는 점 — 우리 `CLAUDE.md` 2,128 B를 짧게 유지해야 하는 두 번째 이유다.
- **다이어그램**: 문서 자체가 인터랙티브 타임라인 시각화다. 정적 이미지 URL 없음.

### D-5. prompt caching — TTL과 비용 배수

- **출처**: Prompt caching (Claude Platform Docs) — https://platform.claude.com/docs/en/build-with-claude/prompt-caching
- **날짜**: 미표기
- **핵심 인용**:
  > "By default, the cache has a 5-minute lifetime."
  > "If you find that 5 minutes is too short, Anthropic also offers a 1-hour cache duration at additional cost."
  > "5-minute cache write tokens are 1.25 times the base input tokens price / 1-hour cache write tokens are 2 times the base input tokens price / Cache read tokens are 0.1 times the base input tokens price"
  > "Shorter prompts cannot be cached, even if marked with `cache_control`. Any requests to cache fewer than this number of tokens will be processed without caching, and no error is returned."
- **수치**:
  - TTL: 5분(기본), 1시간(추가 비용)
  - 캐시 쓰기: 기본 입력가의 1.25배(5분) / 2배(1시간)
  - 캐시 읽기: 기본 입력가의 0.1배 → **입력 비용 90% 절감**
  - 최소 캐시 가능 길이: Opus 5·Fable 5·Mythos 5 512토큰 / Opus 4.8·Sonnet 5·Sonnet 4.6·Sonnet 4.5 1,024토큰 / Opus 4.7·Haiku 3.5 2,048토큰 / Opus 4.6·Opus 4.5·Haiku 4.5 4,096토큰
  - Opus 5 예: 입력 $5/MTok → 5분 캐시 쓰기 $6.25, 1시간 $10, 캐시 히트 $0.50
- **주의**: 캐싱은 비용을 줄이지만 컨텍스트 점유는 줄이지 않는다 (§ B-2 인용 참조).
- **쓸 곳**: 같은 컨텍스트를 반복해 보낼 때 읽기 비용이 1/10이 된다. 단, 컨텍스트 창은 그대로 찬다.
- **우리 vault 대응**: 우리 상시 로드 20,762 B는 세션마다 바이트가 동일해 캐시 접두부로 이상적이다. 다만 **컨텍스트 점유는 그대로다** — 캐싱은 8 KB 상한이나 200줄 권고를 면제해 주지 않는다. "캐시되니 길어도 된다"는 오해를 이 항목으로 막는다.
- **다이어그램**: 없음

### D-6. 도구 정의를 미리 안 올린다 — tool search

- **출처**: Tool search tool (Claude Platform Docs) — https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool / Advanced tool use (Anthropic Engineering) — https://www.anthropic.com/engineering/advanced-tool-use
- **날짜**: 미표기 / 2025-11-24
- **핵심 인용**:
  > "A typical multiserver setup (GitHub, Slack, Sentry, Grafana, and Splunk) can consume ~55k tokens in definitions before Claude does any work. Tool search typically reduces this by over 85 percent, loading only the 3–5 tools Claude needs for a given request."
  (GitHub·Slack·Sentry·Grafana·Splunk를 붙인 흔한 구성은 Claude가 일을 시작하기도 전에 정의만으로 약 55,000 토큰을 먹는다.)
  > "Claude's ability to pick the right tool degrades once you exceed 30–50 available tools."
  Advanced tool use: Opus 4는 MCP 평가에서 "improved from 49% to 74%", Opus 4.5는 "improved from 79.5% to 88.1%".
- **수치**:
  - MCP 5개 서버 58개 도구 = 약 55,000 토큰 (Jira 등 추가 시 100,000 토큰 이상)
  - tool search 적용 시 85% 이상 절감. 50개 이상 MCP 도구 상황에서 "preserves 191,300 tokens of context compared to 122,800"
  - 도구 선택 정확도가 무너지기 시작하는 지점: 사용 가능 도구 30~50개
  - MCP 평가 정확도: Opus 4 49% → 74%, Opus 4.5 79.5% → 88.1%
  - programmatic tool calling: "Average usage dropped from 43,588 to 27,297 tokens, a 37% reduction on complex research tasks."
  - tool search 권장 임계: 도구 10개 이상, 또는 도구 정의가 10K 토큰 초과
- **쓸 곳**: MCP 서버를 늘리면 대화를 시작하기 전에 컨텍스트가 이미 차 있다. 55,000 토큰은 매우 구체적인 경고 수치다.
- **우리 vault 대응**: MCP 5개 서버 = 약 55,000 토큰은 우리 상시 로드 20,762 B(≈6~9천 토큰)의 **6~9배**다. vault 문서를 8 KB로 깎아 아낀 양이 MCP 서버 하나로 사라진다. 우리 vault에서 컨텍스트를 지키는 가장 큰 레버는 문서 다이어트가 아니라 **MCP 서버 수 관리**라는 결론이 여기서 나온다.
- **다이어그램**: Advanced tool use 문서에 tool search 흐름도, programmatic tool calling 흐름도 있음. URL·사용 조건 미확인.

---

## E. Claude Code에서 컨텍스트를 차지하는 것들

### E-1. 세션 시작 시점의 실측 점유 — 항목별 토큰

- **출처**: Explore the context window (Claude Code Docs) — https://code.claude.com/docs/en/context-window
- **날짜**: 미표기
- **핵심 인용**:
  > "Claude Code's context window holds everything Claude knows about your session: your instructions, the files it reads, its own responses, and content that never appears in your terminal."
  > "The visualization uses representative numbers. To see your actual context usage at any point, run `/context` for a live breakdown by category with optimization suggestions."
  (시각화는 대표값이다. 실제 사용량은 `/context`로 확인한다.)
- **수치** (문서의 대표값, 200,000 토큰 창 기준):
  - 시스템 프롬프트 4,200 토큰 — "Always loaded first. You never see it."
  - 프로젝트 CLAUDE.md 1,800 토큰
  - `~/.claude/CLAUDE.md` 320 토큰
  - 스킬 설명 목록 450 토큰
  - MCP 도구 (기본값: 이름만, 스키마는 지연 로드) 120 토큰
  - auto memory MEMORY.md 680 토큰
  - 환경 정보 280 토큰
  - → 사용자가 첫 글자를 치기 전에 약 7,850 토큰
  - 이후 파일 1개 읽기 1,100~2,400 토큰, grep 600 토큰, 테스트 출력 1,200 토큰
- **쓸 곳**: 아무것도 하지 않은 상태에서 이미 컨텍스트가 차 있다. 항목별 숫자를 그대로 표로 옮길 수 있다.
- **우리 vault 대응**: 우리 실측과 1:1 대조표를 만들 수 있다 — 공식 문서의 프로젝트 CLAUDE.md 1,800 토큰 대표값 대 우리 `CLAUDE.md` 2,128 B, 스킬 설명 450 토큰 대 우리 스킬 메타데이터 6,823 B, auto memory 680 토큰 대 우리 `MEMORY.md` 496 B. 우리 스킬 목록이 대표값보다 눈에 띄게 크다는 사실이 이 대조로 드러난다.
- **다이어그램**: 인터랙티브 타임라인 (정적 이미지 없음)

### E-2. MCP 도구 스키마는 기본적으로 지연 로드된다

- **출처**: 동일 문서
- **날짜**: 미표기
- **핵심 인용**:
  > "MCP tool names listed so Claude knows what is available. By default, full schemas stay deferred and Claude loads specific ones on demand via tool search when a task needs them. Set `ENABLE_TOOL_SEARCH=auto` to load schemas upfront when they fit within 10% of the context window, or `ENABLE_TOOL_SEARCH=false` to load everything."
- **수치**: 이름만 로드 시 120 토큰. `ENABLE_TOOL_SEARCH=auto`의 기준선은 컨텍스트 창의 10%.
- **쓸 곳**: MCP를 많이 붙여도 기본 설정에서는 이름만 올라간다. 설정을 바꾸면 스키마 전체가 올라간다.
- **우리 vault 대응**: 우리 환경에도 MCP 서버(zeph 등)가 붙어 있고, 기본 설정에서는 이름만 올라간다. `ENABLE_TOOL_SEARCH=false`로 바꾸면 스키마 전량이 올라가 D-6의 55,000 토큰 시나리오가 현실이 된다. 설정을 건드리지 않는 것 자체가 컨텍스트 절약이다.
- **다이어그램**: 없음

### E-3. CLAUDE.md는 짧게 유지하라 — 공식 권고와 상한

- **출처**: How Claude remembers your project (Claude Code Docs) — https://code.claude.com/docs/en/memory
- **날짜**: 미표기
- **핵심 인용**:
  > "CLAUDE.md files are loaded into the context window at the start of every session, consuming tokens alongside your conversation."
  > "**Size**: target under 200 lines per CLAUDE.md file. Longer files consume more context and reduce adherence."
  (분량: CLAUDE.md 파일당 200줄 미만을 목표로 한다. 파일이 길면 컨텍스트를 더 먹고 준수도가 떨어진다.)
  > "The more specific and concise your instructions, the more consistently Claude follows them."
  > "Splitting into `@path` imports helps organization but doesn't reduce context, since imported files load at launch."
  (`@path` import로 쪼개면 정리는 되지만 컨텍스트는 줄지 않는다. import된 파일도 시작 시 로드된다.)
  > "Block-level HTML comments (`<!-- maintainer notes -->`) in CLAUDE.md files are stripped before the content is injected into Claude's context."
- **수치**:
  - 권고: CLAUDE.md 200줄 미만
  - 하드 상한: 4 MiB 초과 파일은 로드하지 않고 건너뛴다
  - auto memory MEMORY.md: 첫 200줄 또는 첫 25KB 중 먼저 도달하는 지점까지만 세션 시작 시 로드. 초과분은 로드되지 않는다.
  - 스킬 목록 문자 예산: 모델 컨텍스트 창의 1% (`skillListingBudgetFraction`로 조정). 항목별 description+when_to_use 합산 1,536자 상한.
- **쓸 곳**: "CLAUDE.md를 길게 쓰면 좋다"는 오해를 깨는 공식 근거. 길면 컨텍스트를 먹고 준수도까지 떨어진다.
- **우리 vault 대응**: 우리 파일 대조 — `CLAUDE.md` 2,128 B와 `~/.claude/CLAUDE.md` 3,298 B는 200줄 권고 안이다. 문제는 `VAULT_RULES.md` **10,215 B**로, 자동 로드가 아니라 `CLAUDE.md`가 "Before vault work, read"로 지시해 읽히는 파일이다. 이 구분이 우리 vault 설계의 핵심이며, `@import`로 붙이면 컨텍스트가 줄지 않는다는 공식 서술이 이 선택을 정당화한다. 참고로 `AGENTS.md` 597 B는 import도 참조도 없어 실제로 로드되지 않는다.
- **다이어그램**: 없음

### E-4. 스킬 — 본문은 호출할 때만 올라간다 (progressive disclosure 구현체)

- **출처**: Extend Claude with skills (Claude Code Docs) — https://code.claude.com/docs/en/skills
- **날짜**: 미표기
- **핵심 인용**:
  > "Unlike CLAUDE.md content, a skill's body loads only when it's used, so long reference material costs almost nothing until you need it."
  (CLAUDE.md 내용과 달리 스킬 본문은 쓸 때만 로드된다. 그래서 긴 참고 자료는 필요해질 때까지 거의 비용이 없다.)
  > "In a regular session, skill descriptions are loaded into context so Claude knows what's available, but full skill content only loads when invoked."
  > "Keep the body itself concise. Once a skill loads, its content stays in context across turns, so every line is a recurring token cost."
  (본문은 간결하게 유지한다. 한 번 로드되면 그 내용은 턴마다 컨텍스트에 남으므로, 모든 줄이 반복 비용이다.)
- **수치**: description+when_to_use 합산 1,536자에서 절단. 스킬 목록 예산은 컨텍스트 창의 1%.
- **쓸 곳**: 상시 필요한 사실은 CLAUDE.md, 절차는 스킬. 이 구분이 컨텍스트 절약의 실무 규칙이다.
- **우리 vault 대응**: 우리 스킬 17개가 이 구조를 그대로 쓴다. 전량 188,371 B 중 메타데이터 6,823 B(**3.6%**)만 상시 로드된다. 본문이 로드되면 턴마다 반복 비용이라는 서술은 `vault-ingest.md` 같은 긴 스킬을 왜 호출 시에만 읽어야 하는지를 설명한다. "상시 필요한 사실은 CLAUDE.md, 절차는 스킬"이 우리 vault의 배치 규칙과 일치한다.
- **다이어그램**: 없음

### E-5. compaction 후 무엇이 살아남는가

- **출처**: Explore the context window (Claude Code Docs) — https://code.claude.com/docs/en/context-window § What survives compaction / Model configuration — https://code.claude.com/docs/en/model-config
- **날짜**: 미표기
- **핵심 인용**:
  > "When a long session compacts, Claude Code summarizes the conversation history to fit the context window."
  > "Claude Code compacts automatically as you approach the limit, so a full context window doesn't end your session."
  > "Path-scoped rules and nested CLAUDE.md files load into message history when their trigger file is read, so compaction summarizes them away with everything else."
  > "Truncation keeps the start of the file, so put the most important instructions near the top of `SKILL.md`."
  (절단은 파일의 앞부분을 남긴다. 그래서 가장 중요한 지시는 SKILL.md 위쪽에 둔다.)
- **수치**:
  - 유지: 시스템 프롬프트(메시지 이력 밖), 프로젝트 루트 CLAUDE.md·비범위 규칙·auto memory·플랜 → 디스크에서 재주입
  - 요약되어 사라짐: `paths:` 프론트매터 규칙, 중첩 CLAUDE.md, 훅이 넣은 컨텍스트
  - 파일 재읽기: 최근 수정 순으로 최대 5개. 5,000 토큰 초과 파일은 내용 없이 경로 참조로만 복귀
  - 스킬 본문 재주입: 스킬당 5,000 토큰, 합계 25,000 토큰 상한. 오래된 것부터 탈락
  - Sonnet 5(1M 창): 기본 약 967K 토큰에서 자동 compaction — "Sessions auto-compact before the window fills, at about 967K tokens by default"
  - `CLAUDE_CODE_DISABLE_1M_CONTEXT=1` 설정 시 200K 경계에서 compaction
- **쓸 곳**: compaction은 무손실이 아니다. 무엇이 살아남는지 알면 어디에 지시를 적어야 하는지가 정해진다.
- **우리 vault 대응**: compaction 후 `CLAUDE.md`와 `~/.claude/rules/lemon-rules.md`는 디스크에서 재주입되지만, 지시로 읽었던 `VAULT_RULES.md`·`wiki/VAULT_MEMORY.md`·`wiki/INDEX.md`는 **요약되어 사라진다**. 즉 긴 세션에서 vault 계약을 다시 읽어야 하는 순간이 온다. 절대 잊혀선 안 되는 규칙(`raw/` append-only, 개인 실험 데이터 커밋 금지, 8 KB 상한)을 `CLAUDE.md`의 `## Hard Invariants`에 **중복 기재**해 둔 것이 이 동작에 대한 대비다.
- **다이어그램**: 없음

---

## F. 한국어 토큰 효율

### F-1. 한국어의 토큰 비효율 — 공식 수치 미확인

- **출처(공식, 수치 없음)**: Token counting (Claude Platform Docs) — https://platform.claude.com/docs/en/build-with-claude/token-counting
- **날짜**: 미표기
- **확인 결과**: Anthropic 공식 문서에서 "한국어가 영어 대비 몇 배"라는 수치는 찾지 못했다. 공식 권고는 추정하지 말고 Token Counting API(`POST /v1/messages/count_tokens`)로 실측하라는 것이다. 검색 요약에 나온 "1 token ≈ 3.5 English characters" 휴리스틱도 원문에서 직접 확인하지 못했다.
- **출처(2차)**: Sander Land, "On the Biology of Claude's Tokenizer" — https://tokencontributions.substack.com/p/on-the-biology-of-claudes-tokenizer
- **2차 인용**: "Han, Korean, emoji and many rare scripts do not have word markers, and are always tokenized character-by-character."
  (한자, 한글, 이모지, 다수의 희귀 문자는 단어 경계 표시가 없어 항상 문자 단위로 토크나이즈된다.)
- **수치**: **출처에 공식 수치 없음.** 2차 자료들이 1.38배~3배 범위의 서로 다른 수치를 제시하나, 측정 조건이 다르고 Anthropic 검증본이 아니어서 교육 자료에 단일 수치로 쓰기 어렵다.
- **쓸 곳**: 한국어는 문자 단위로 쪼개지므로 같은 내용에서 영어보다 토큰을 더 쓴다는 **방향**만 서술한다. 배수는 Token Counting API로 직접 측정해 자체 근거를 만드는 편이 안전하다.
- **우리 vault 대응**: 우리 vault 문서는 전부 한국어다. `VAULT_RULES.md` 10,215 B가 영문이라면 토큰 수가 더 적을 수 있다. 다만 배수를 단정할 근거가 없으므로, 교육에서는 방향만 말하고 필요하면 우리 실제 파일로 Token Counting API 실측을 하나 만든다 — 그러면 남의 수치가 아니라 우리 수치가 된다.
- **다이어그램**: 없음

---

## 비개발자용 설명 후보

1. **작업 기억 (working memory)** — 출처: Claude Platform Docs, Context windows. "represents a 'working memory' for the model". 컨텍스트 창은 모델의 장기 기억(학습 데이터)이 아니라 지금 책상에 펼쳐놓은 것에 해당한다. 공식 문서의 표현이라 그대로 인용할 수 있다.
2. **주의 예산 (attention budget)** — 출처: Anthropic Engineering, Effective context engineering. "Like humans, who have limited working memory capacity, LLMs have an 'attention budget'... Every new token introduced depletes this budget by some amount." 사람도 한 번에 붙잡을 수 있는 게 한정되어 있다는 비유. 토큰을 하나 넣으면 예산이 그만큼 준다.
3. **파일 시스템·받은편지함·북마크** — 출처: 동일 문서. "we generally don't memorize entire corpuses of information, but rather introduce external organization and indexing systems like file systems, inboxes, and bookmarks to retrieve relevant information on demand." 자료를 다 외우는 대신 어디 있는지만 알고 필요할 때 꺼낸다는 설명. just-in-time 검색을 비개발자에게 설명하기에 가장 적합하다.
4. **골디락스 구역 (Goldilocks zone)** — 출처: 동일 문서. 시스템 프롬프트의 구체성 수준을 두고 "the Goldilocks zone between two common failure modes"라고 쓴다. 너무 세밀해 부서지는 규칙과 너무 막연해 쓸모없는 규칙 사이. 문서를 얼마나 자세히 쓸지 설명할 때 쓸 수 있다.
5. **예시는 천 마디 말에 값하는 그림** — 출처: 동일 문서. "For an LLM, examples are the 'pictures' worth a thousand words." 규칙을 길게 쓰는 것보다 예시 하나가 낫다는 취지. 컨텍스트를 짧게 쓰라는 권고와 짝을 이룬다.
6. **책상 위 면적 (자작)** — 컨텍스트 창을 책상 넓이로 본다. 책상에 올릴 수 있는 서류는 정해져 있고, 참고서를 다 올려두면 정작 작업할 자리가 없다. CLAUDE.md 200줄 권고와 MCP 55,000 토큰 사례를 같은 그림으로 묶을 수 있다. **자작** — 출처 없음.

---

## 확인 못 한 것

1. **한국어 vs 영어 토큰 배수의 공식 수치.** Anthropic 공식 문서에는 없다. 공식 지침은 Token Counting API로 실측하라는 것뿐이다. 2차 자료들은 1.38배~3배로 서로 다르다. 교육 자료에 수치를 넣으려면 직접 측정해야 한다.
2. **Anthropic 자체의 context rot 정량 벤치마크.** 공식 문서는 context rot을 정의하고 "needle-in-a-haystack style benchmarking"을 언급하지만, Anthropic이 자체 측정한 수치 표는 찾지 못했다. 수치 근거는 외부(Chroma) 보고서에 의존한다.
3. **lost-in-the-middle의 "20~30점 하락" 수치.** 검색 결과 요약에는 나오지만 TACL 초록·ACL Anthology 페이지에서 확인하지 못했다. 논문 본문 PDF를 열어 표를 확인해야 인용할 수 있다.
4. **Anthropic 다이어그램의 재사용 조건.** 확인한 모든 문서에 이미지 라이선스·사용 허가 표기가 없다. 교육 자료에 그대로 넣기 전에 확인이 필요하다. platform.claude.com의 svg 3개는 직접 URL이 확인됐으나 조건은 미표기다.
5. **Opus 계열의 기본 auto-compact 임계값.** Sonnet 5의 약 967K 토큰은 확인했으나, Opus 4.8/5의 기본 임계값은 문서가 "compacts when the conversation reaches the model's context limit"라고만 서술하고 구체적 퍼센트를 주지 않는다.
6. **"1 token ≈ 3.5 English characters" 휴리스틱의 원문 위치.** 검색 요약에는 Anthropic 것으로 나오지만 token-counting 문서 원문에서 직접 확인하지 못했다.
7. **Claude Code 시작 시 점유 토큰의 실제 분포.** E-1의 숫자는 문서가 명시적으로 "representative numbers"라고 밝힌 대표값이다. 실제 값은 `/context`로 세션별로 측정해야 한다. 교육 자료에서 "대표값"임을 반드시 함께 적어야 한다.

---

## 우리 vault 실측값 (2026-08-27, 이 저장소에서 직접 측정)

매핑에 쓴 우리 쪽 수치다. 모두 `wc -c` 바이트 기준이다.

### 세션 시작 시 컨텍스트에 들어오는 것

자동 로드와 "지시로 읽는 것"을 구분해야 한다. 이 구분이 우리 vault 설계의 핵심이다.

| 구분 | 파일 | 바이트 |
| --- | --- | --- |
| 자동 로드 | `~/.claude/CLAUDE.md` | 3,298 |
| 자동 로드 | `~/.claude/rules/lemon-rules.md` | 1,460 |
| 자동 로드 | `CLAUDE.md` (프로젝트) | 2,128 |
| 자동 로드 | auto memory `MEMORY.md` | 496 |
| **자동 로드 소계** | | **7,382** |
| 지시로 읽음 | `VAULT_RULES.md` | 10,215 |
| 지시로 읽음 | `wiki/VAULT_MEMORY.md` | 2,707 |
| 지시로 읽음 | `wiki/INDEX.md` | 458 |
| **지시로 읽음 소계** | | **13,380** |
| **합계** | | **20,762** |

- 자동 로드분은 Claude Code가 세션 시작 시 무조건 싣는다. `~/.claude/rules/`의 규칙 파일은 `paths:` 프론트매터가 없어 시작 시 로드된다 (근거: § E-3 memory 문서).
- 지시로 읽는 3개는 `CLAUDE.md`의 `Before vault work, read:` 목록이다. `@import`가 아니므로 자동 로드가 아니고, 실제 vault 작업이 시작될 때 Read 도구로 들어온다. 그래서 compaction 후에는 사라진다 (§ E-5).
- 여기에 도구 스키마·스킬 목록·시스템 프롬프트가 더해진다. 그 몫은 `/context`로 세션별 측정이 필요하다.

### 팀 리드 전달값과 다른 두 지점

정직하게 남긴다. 결론은 바뀌지 않지만 숫자는 다르다.

1. **`AGENTS.md` 597 B는 컨텍스트에 로드되지 않는다.** `CLAUDE.md`에 `@AGENTS.md` import가 없고, 참조도 없다. 공식 문서도 "Claude Code reads `CLAUDE.md`, not `AGENTS.md`"라고 명시한다 (https://code.claude.com/docs/en/memory). 전달받은 합계 20,863 B는 이 파일을 포함하고 auto memory `MEMORY.md` 496 B를 제외한 값이다. 실측 합계는 **20,762 B**다.
2. **스킬 메타데이터는 셈법에 따라 두 값이 나온다.** frontmatter 블록 전체(`---` 구분선 포함)는 **8,524 B = 4.5%**, `name`/`description` 값 텍스트만 세면 **6,823 B = 3.6%**다. 전달값 6,823 B는 후자다. 어느 쪽이든 "전량의 1/22~1/28만 상시 로드"라는 주장은 성립한다. 교육 자료에는 셈법을 함께 밝히고 하나만 쓴다.

### progressive disclosure가 우리 vault에 구현된 3곳

같은 형태가 세 번 반복된다 — 색인은 작게, 본문은 나중에.

| 대상 | 상시 로드 | 전량 | 비율 |
| --- | --- | --- | --- |
| 스킬 17개 (메타데이터만) | 6,823 B | 188,371 B | 3.6% (약 1/28) |
| auto memory (`MEMORY.md`만) | 496 B | 5,603 B | 8.9% (약 1/11) |
| wiki (`INDEX.md`만) | 458 B | (노트 전량) | 색인 458 B |

- 스킬 17개 = `.md` 단일 파일 14개 + 디렉터리형 3개(`doc2md-ingest`, `hwp2md-ingest`, `pdf2md-ingest`). 전량 188,371 B는 하위 참조 파일까지 포함한 값이고 `.md`만 세면 162,143 B다.
- auto memory 전량 5,603 B = `MEMORY.md` 496 + 토픽 파일 3개 5,107. 토픽 파일은 Claude가 필요할 때 Read로 꺼낸다.
- `wiki/VAULT_MEMORY.md`는 `VAULT_RULES.md`가 **8 KB 상한**을 건 파일이다. 현재 2,707 B = 상한의 **33%**.
- 실행 이력은 컨텍스트 예산 때문에 auto memory에서 `docs/vault-ingest-log.md`(828 B)로 분리했다.

---

## 우리 vault 대응 매핑

| # | 외부 근거 | 우리 vault의 대응 파일/수치 | 교육에서 할 말 |
| --- | --- | --- | --- |
| A-1 | 컨텍스트 엔지니어링 = 토큰 집합 선별 (Anthropic, 2025-09-29) | `CLAUDE.md` 2,128 B ↔ `VAULT_RULES.md` 10,215 B 분리 | 진입점은 짧게, 상세 계약은 밖으로 낸다. 이 배치가 컨텍스트 엔지니어링이다. |
| A-2 | "최소 고신호 토큰 집합" | `wiki/INDEX.md` 458 B, `VAULT_MEMORY.md` 8 KB 상한 | 위키 전체를 458바이트 색인으로 압축했다. 목표는 많이 넣기가 아니다. |
| B-1 | 컨텍스트 창 = 모델의 "작업 기억" | `raw/` → `wiki/` → `Clippings/` 3계층 | `raw/`는 창고, `wiki/`는 책상. raw를 읽지 말고 wiki를 읽는 이유다. |
| B-2 | 시스템 프롬프트·도구 정의·이미지까지 전부 계산됨 | 자동 로드 7,382 B + 지시로 읽음 13,380 B = **20,762 B** | 첫 글자를 치기 전에 20 KB가 이미 들어와 있다. |
| B-3 | 1M / 200K 창, 출력 128K | 20,762 B ≈ 6~9천 토큰 = 1M의 1% 미만, 200K의 3~5% | 8 KB·200줄 상한은 200K로 떨어질 때를 위한 보험이다. |
| B-4 | 모델이 남은 토큰 예산을 태그로 받는다 | `VAULT_RULES.md`가 건 8 KB(`wc -c`) 상한 | 예산은 감각이 아니라 숫자다. 우리는 lint로 기계 검사한다. |
| B-5 | 입력 초과 시 HTTP 400 "prompt is too long" | `raw/` 원본 직접 투입 금지 | 정제 단계는 취향이 아니라 400을 피하는 장치다. |
| C-1 | context rot — 공식 문서의 정의 | `VAULT_MEMORY.md` 8 KB 상한, per-run narrative append 금지 | 메모리가 커지면 세션마다 정확도를 깎는다. 상한의 근거다. |
| C-2 | attention budget, n² 쌍관계 | 20,762 B 중 `VAULT_RULES.md`가 10,215 B = 절반 | 가장 먼저 줄일 후보를 숫자가 지목한다. |
| C-3 | Chroma 18개 모델: 300 토큰 vs 113K 토큰 | `INDEX.md` 458 B 색인 후 노트 1~2개 vs `raw/` 전량 | 집중 프롬프트와 전체 프롬프트의 차이가 우리 두 방식의 차이다. |
| C-4 | lost-in-the-middle U자 곡선 (TACL 2024) | `CLAUDE.md`의 `## Hard Invariants`를 앞쪽 배치 | 10 KB 문서 중간에 묻은 규칙은 무시된다. 중요한 건 앞에 둔다. |
| D-1 | compaction — 요약은 무손실이 아니다 | 실행 이력을 `docs/vault-ingest-log.md`(828 B)로 분리 | 요약하면 잃는 정보는 컨텍스트 밖 파일에 둔다. |
| D-2 | just-in-time 검색 + progressive disclosure | 스킬 3.6% · auto memory 8.9% · `INDEX.md` 458 B | 같은 형태가 세 번 반복된다. 색인은 작게, 본문은 나중에. |
| D-3 | sub-agent 요약 반환 1,000~2,000 토큰 | `vault-ingest-claude.md` 위임 구조 | 무거운 원본 읽기는 위임하고 요약만 받는다. |
| D-4 | sub-agent 격리 실측 6,100 → 420 토큰 | 잉게스트 위임의 기대 효과 (약 1/15) | 단, sub-agent도 `CLAUDE.md` 사본을 싣는다. 짧게 유지할 두 번째 이유. |
| D-5 | 캐시 읽기 0.1배 = 90% 절감, TTL 5분/1시간 | 상시 로드 20,762 B는 바이트 고정 = 캐시 접두부 적합 | 캐시는 비용만 줄인다. 8 KB 상한을 면제하지 않는다. |
| D-6 | MCP 5개 서버 58개 도구 ≈ 55,000 토큰, 85% 절감 | 우리 상시 로드의 **6~9배** | 문서를 8 KB로 깎아 아낀 양이 MCP 하나로 사라진다. 최대 레버는 서버 수다. |
| E-1 | Claude Code 시작 점유 대표값 (시스템 4,200 / CLAUDE.md 1,800 / 스킬 450) | 우리: `CLAUDE.md` 2,128 B, 스킬 메타 6,823 B, `MEMORY.md` 496 B | 우리 스킬 목록이 대표값보다 크다. 대조표로 바로 드러난다. |
| E-2 | MCP 스키마는 기본 지연 로드, `auto`는 창의 10% | zeph 등 연결된 MCP 서버 | 기본 설정을 건드리지 않는 것 자체가 절약이다. |
| E-3 | CLAUDE.md 200줄 미만 권고, `@import`는 컨텍스트를 줄이지 않음 | `CLAUDE.md` 2,128 B ✓ / `VAULT_RULES.md` 10,215 B는 지시로 읽음 / `AGENTS.md` 597 B는 미로드 | import로 쪼개는 건 정리일 뿐이다. 우리는 "읽으라고 지시"로 뺐다. |
| E-4 | 스킬 본문은 호출 시에만 로드, 로드되면 턴마다 반복 비용 | 스킬 17개 전량 188,371 B → 상시 6,823 B (3.6%) | 상시 필요한 사실은 CLAUDE.md, 절차는 스킬. |
| E-5 | compaction 생존 표 (스킬당 5,000·합계 25,000 토큰) | `CLAUDE.md`·`lemon-rules.md`는 재주입, `VAULT_RULES.md`·`VAULT_MEMORY.md`·`INDEX.md`는 소멸 | 절대 잊혀선 안 되는 규칙을 `## Hard Invariants`에 중복 기재한 이유다. |
| F-1 | 한국어 토큰 배수 — 공식 수치 없음 | vault 문서 전량 한국어, `VAULT_RULES.md` 10,215 B | 방향만 말한다. 배수가 필요하면 우리 파일로 직접 재서 우리 수치를 만든다. |
