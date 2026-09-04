# Week2 근거 자료 — Agent Skills (스킬)

수집일: 2026-08-27. 수집자: skills-research. 1차 출처는 Anthropic 공식 문서(platform.claude.com,
code.claude.com, claude.com/blog, anthropic.com/engineering, support.claude.com)로 한정한다.
공식 문서 페이지는 대부분 발행일을 표기하지 않는다. 그 경우 "미표기 (2026-08-27 확인)"으로 적는다.

수집 건수: 16건 (항목 3b 포함).

---

### 1. Agent Skill의 공식 정의

- **출처**: Equipping agents for the real world with Agent Skills — https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- **날짜**: Published Oct 16, 2025
- **핵심 인용**: "organized folders of instructions, scripts, and resources that agents can discover
  and load dynamically to perform better at specific tasks." (에이전트가 스스로 찾아내 동적으로 불러오는,
  지시·스크립트·자료를 담은 폴더다.)
  / "Skills extend Claude's capabilities by packaging your expertise into composable resources for
  Claude, transforming general-purpose agents into specialized agents that fit your needs."
- **보조 인용**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
  — "Skills are reusable, filesystem-based resources that give Claude domain-specific expertise:
  workflows, context, and best practices that turn a general-purpose agent into a specialist."
- **쓸 곳**: 스킬은 모델을 바꾸는 것이 아니라 "폴더 하나"로 전문성을 얹는 방식이다. 범용 에이전트를
  특화 에이전트로 바꾸는 장치다.
- **우리 vault 대응**: 우리 `projects/second-brain/config/skills/`의 스킬 17개가 곧 그 "폴더"다.
  전량 188,371 B. 형태는 두 가지다. 평평한 `.md` 14개와 폴더형 3개(`doc2md-ingest`·`hwp2md-ingest`·
  `pdf2md-ingest`). 공식 정의의 "instructions, scripts, and resources"가 폴더형 3개에 그대로 있다.
  변환 스크립트(`scripts/d1-extract.py` 등)가 scripts이고 `design.md`·`implementation-plan.md`가
  resources다. 교육에서 할 말: "우리가 이미 쓰고 있는 게 스킬이다. 새로 배우는 개념이 아니다."
- **다이어그램**: `skills-progressive-disclosure-levels.jpg` 외 6종. 아래 다이어그램 인벤토리 참조.

---

### 2. SKILL.md 구조와 frontmatter 필드 규칙

- **출처**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "At its simplest, a skill is a directory that contains a `SKILL.md` file. This file
  must start with YAML frontmatter that contains some required metadata: `name` and `description`."
  (가장 단순한 스킬은 SKILL.md 하나를 담은 디렉터리다. 파일은 name·description을 담은 YAML
  frontmatter로 시작해야 한다.)
  / "**Required fields:** `name` and `description`"
- **수치**:
  - `name`: 최대 64자, 소문자·숫자·하이픈만, XML 태그 불가, 예약어 "anthropic"·"claude" 불가
  - `description`: 비어 있을 수 없음, 최대 1024자, XML 태그 불가
  - 폴더 규약(공식 예시): `pdf-processing/SKILL.md` + `FORMS.md` + `REFERENCE.md` + `scripts/fill_form.py`
- **오픈 표준의 폴더 규약**: Agent Skills Overview — https://agentskills.io — `my-skill/` 안에
  `SKILL.md`(필수) + `scripts/`(실행 코드) + `references/`(문서) + `assets/`(템플릿) — 모두 선택
- **쓸 곳**: 스킬을 만드는 최소 단위는 "폴더 + 마크다운 파일 1개"다. 진입 장벽이 낮다는 근거로 쓴다.
- **우리 vault 대응**: 우리 진입점 17개 중 **16개는 `name`·`description` 프론트매터를 갖췄고 1개는 없다**
  (`ollama-local-models.md` — 항목 6 참조). 갖춘 16개는 `description: >` 폴딩 블록을 쓴다.
  추가로 우리는 공식 규격에 없는 `origin:` 필드를 쓴다(16개 합계 1,557 B). 이 필드는 vault 동기화
  출처를 적는 우리 관례이고, Claude Code는 1단 메타데이터로 취급하지 않는다.
  교육에서 할 말: "필수는 name·description 둘이다. 나머지는 우리 관례다."
- **다이어그램**: `agent-skills-simple-file.png`(A simple SKILL.md file), `agent-skills-bundling-content.png`(Bundling additional content)

---

### 3. progressive disclosure — 3단 로딩과 토큰 수치

- **출처**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "This filesystem-based architecture enables **progressive disclosure:** Claude loads
  information in stages as needed, rather than consuming context upfront."
  / "This lightweight approach means you can install many Skills without context penalty: until a
  Skill is triggered, only its name and description occupy context." (스킬이 발동하기 전까지
  컨텍스트를 차지하는 것은 name과 description뿐이다.)
  / "Files don't consume context until accessed, so Skills can include comprehensive API
  documentation, large datasets, or extensive examples. There's no context penalty for bundled
  content that isn't used."
- **수치** (공식 문서의 표를 그대로 옮김):

  | Level | When loaded | Token cost | Content |
  | --- | --- | --- | --- |
  | Level 1: Metadata | Always (at startup) | ~100 tokens per Skill | `name`·`description` |
  | Level 2: Instructions | When Skill is triggered | Under 5k tokens | SKILL.md 본문 |
  | Level 3+: Resources | As needed | None until accessed | 번들 파일. 스크립트는 출력만 컨텍스트에 들어감 |

- **다른 수치 (블로그, 다른 값)**: Building Agents with Skills — https://claude.com/blog/building-agents-with-skills-equipping-agents-for-specialized-work
  (Jan 22, 2026) — "This three-tier approach means you can equip an agent with hundreds of skills
  without overwhelming its context window—metadata uses ~50 tokens, full SKILL.md files ~500 tokens,
  and reference files 2,000+ tokens and only when specifically needed."
  → 같은 3단을 두고 문서는 ~100/<5k/무제한, 블로그는 ~50/~500/2,000+로 다른 값을 쓴다. 교육 자료에는
  **공식 문서 표(~100 / <5k / 접근 전 0)**를 기준으로 쓰고, 블로그 값은 병기하지 않는다.
- **claude.ai 앱 문서의 값**: Skills overview — https://claude.com/docs/skills/overview —
  "Claude reads skill names and descriptions at startup (~100 tokens each)" → 문서 표와 일치.
- **쓸 곳**: 스킬 100개를 깔아도 시작 시 비용은 설명문 몇 줄이다. "많이 깔면 무거워진다"는 오해를
  깨는 핵심 근거다.
- **우리 vault 대응 (2026-08-27 실측)**: 공식 3단이 우리 스킬 폴더에서 그대로 재현된다.

  | 단계 | 우리 vault 실측 | 비율 |
  | --- | --- | --- |
  | 1단 메타데이터 (`name`+`description` 값 텍스트) | **6,823 B** | 전량의 **3.6%**, 약 **1/28** |
  | 2단 진입점 `.md` 17개 | 132,829 B (최소 2,678 `private-note.md` ~ 최대 18,011 `doc2md-ingest/SKILL.md`) | 70.5% |
  | 3단 번들 8개 | 55,542 B | 29.5% |
  | 전량 | 188,371 B | 100% |

  **1단 셈법을 밝힌다 — 시트에는 위 표의 6,823 B / 3.6% / 1/28만 쓴다.** 프론트매터를 어디까지
  세는지에 따라 값이 갈리므로 아래 3가지를 구분한다. 전량 188,371 B 기준이다.

  | 셈법 | 무엇을 세는가 | 바이트 | 비율 | 시트 사용 |
  | --- | --- | --- | --- | --- |
  | A | `---` 구분선을 포함한 프론트매터 블록 전체 | 8,524 B (닫는 줄 개행 제외 시 8,508 B) | 4.5% · 1/22 | 쓰지 않는다 |
  | B | 구분선 제외, `origin:`까지 포함한 프론트매터 본문 | 8,396 B | 4.5% · 1/22 | 쓰지 않는다 |
  | **C** | **`name`·`description` 값 텍스트만** | **6,839 B (마지막 개행 제외 시 6,823 B)** | **3.6% · 1/28** | **이것을 쓴다** |

  **C를 쓰는 이유**: 세션 시작에 시스템 프롬프트로 실제 주입되는 것은 name과 description뿐이다.
  공식 문서가 1단을 "`name` and `description` from YAML frontmatter"로 한정하고, "Claude Code loads
  a listing of skill names and descriptions into context"라고 적는다. `---` 구분선과 우리 관례
  `origin:`(16개 1,557 B)은 주입되지 않는다. A·B는 파일을 세는 값이고 C가 컨텍스트를 세는 값이다.

  **±16 B 차이의 원인은 규명됐다.** 프론트매터를 가진 파일이 16개이고, 마지막 줄의 개행 1 B를
  세는지 여부에서 파일당 1 B씩 차이가 난다(16개 x 1 B = 16 B). A와 C에서 같은 폭으로 나타난다.
  비율은 소수 둘째 자리까지 같으므로 어느 관례를 쓰든 주장은 동일하다.

  즉 스킬 17개를 모두 갖춰도 상시 비용은 전량의 1/28이다.
  교육에서 할 말: "1/28만 항상 켜져 있다. 나머지 27/28은 필요할 때 켠다."
- **다이어그램**: `skills-progressive-disclosure-levels.jpg` (Level/File/Context Window/# Tokens 4열 표.
  Level 1 ~100, Level 2 <5k, Level 3+ unlimited*)

---

### 3b. 공식 토큰 수치 ↔ 우리 바이트 실측 대조

- **출처**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
  / Skills overview — https://claude.com/docs/skills/overview
  / Extend Claude with skills — https://code.claude.com/docs/en/skills
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: 공식 문서가 상시 로드 비용을 토큰으로 밝힌 곳은 셋이다.
  1. platform docs 3단 표 — Level 1 Metadata / Always (at startup) / **"~100 tokens per Skill"**
  2. claude.com/docs — "Claude reads skill names and descriptions at startup (**~100 tokens each**)"
  3. Claude Code docs (상한 쪽) — "The budget scales at **1% of the model's context window**" ·
     "each entry's combined text is capped at **1,536 characters** regardless of budget"
- **수치 대조**:

  | | 공식 (토큰·문자) | 우리 vault (바이트 실측) |
  | --- | --- | --- |
  | 스킬 1개 1단 비용 | ~100 tokens | 평균 **426 B** (6,823 B / 프론트매터 보유 16개) |
  | 가장 큰 1개 | 항목당 1,536자 상한 | `doc2md-ingest` **937 B** |
  | 가장 작은 1개 | — | `vault-ingest-once.md` **266 B** |
  | 전체 목록 | 컨텍스트의 1% 예산 | **6,823 B** (전량 188,371 B의 3.6%) |
  | 실제 자동 발견되는 것만 | — | **2,010 B** (`.claude/skills/` 심링크 3개) |

- **환산은 하지 않는다**: 바이트에서 토큰을 추정해 적지 않는다. 한글의 바이트당 토큰비를 공식
  문서에서 찾지 못했고 토크나이저를 돌리지 않았다. 대신 두 축을 나란히 놓고, 자릿수가 어긋나지
  않는다는 것만 확인한다. 공식 1,536자 상한과 우리 최대 937 B는 같은 자릿수이고, 우리 최대값이
  상한 안에 들어온다.
- **실제 값을 얻는 방법 (공식)**: "The Skills row in `/context` reports the size of the listing after
  the budget is applied, so it matches what the model receives." → 이 저장소에서 `/context`를
  실행하면 모델이 받는 실제 크기가 나온다. `/doctor`는 "an estimate of the listing's context cost
  and its biggest contributors"를 보여준다. 시트에 토큰 수를 넣어야 한다면 이 두 명령의 출력을
  근거로 쓴다.
- **쓸 곳**: progressive disclosure 절감률이 시트의 핵심 수치다. 공식 토큰값과 우리 바이트값을
  한 표에 놓아 "공식이 말하는 구조가 우리 vault에서 이 숫자로 나타난다"를 보여준다.
- **우리 vault 대응**: 위 표가 곧 대응이다. 특히 마지막 행이 중요하다. 6,823 B는 스킬 17개를 모두
  자동 발견 경로에 올렸을 때의 값이고, 현재 실제 상시 비용은 **2,010 B**다(항목 7).
  교육에서 할 말: "공식 문서는 스킬 하나에 100토큰이라고 한다. 우리 스킬 중 가장 큰 description이
  937 B다. 상한은 1,536자다. 아직 여유가 많다."
- **다이어그램**: `skills-progressive-disclosure-levels.jpg` (공식 토큰값 표를 그림으로 보여준다)

---

### 4. 스킬이 발동할 때 컨텍스트에서 실제로 벌어지는 일

- **출처**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "When a Skill is triggered, Claude uses bash to read SKILL.md from the filesystem,
  bringing its instructions into the context window. If those instructions reference other files
  (such as FORMS.md or a database schema), Claude reads those files too using additional bash
  commands. When instructions mention executable scripts, Claude runs them through bash and receives
  only the output (the script code itself never enters context)."
  (스킬이 발동하면 Claude가 bash로 SKILL.md를 읽는다. 스크립트는 실행 결과만 컨텍스트에 들어오고
  코드 자체는 들어오지 않는다.)
- **공식 로딩 예시 5단계** (PDF 스킬):
  1. Startup: 시스템 프롬프트에 `pdf-processing - Extract text and tables from PDF files...` 포함
  2. User request: "Extract the text from this PDF and summarize it"
  3. Claude invokes: `bash: cat pdf-processing/SKILL.md`
  4. Claude determines: 폼 작성은 필요 없으므로 `FORMS.md`는 읽지 않음
  5. Claude executes: SKILL.md 지시대로 수행
- **쓸 곳**: 스킬은 마법이 아니라 "파일을 읽는 행위"다. 발동 = `cat SKILL.md`. 비개발자에게도
  설명 가능한 수준으로 내려가는 근거다.
- **우리 vault 대응**: `pdf2md-ingest`가 가장 좋은 교보재다. `SKILL.md`는 8,600 B인데 폴더 전체는
  42,348 B다. PDF 변환을 시킬 때 Claude가 읽는 것은 8,600 B뿐이고, `design.md`(6,438 B)와
  `implementation-plan.md`(22,876 B)는 읽지 않는다. `scripts/s2-convert.py`·`s6-ocr.mjs`·
  `measure-density.sh`는 실행되고 출력만 돌아온다. 다른 두 개는 `doc2md-ingest` 18,011 / 37,964 B,
  `hwp2md-ingest` 8,991 / 10,832 B다. 교육에서 할 말: "pdf2md-ingest를 부르면 42 KB가 아니라
  8.6 KB만 들어온다. 설계 문서를 폴더에 넣어도 공짜다."
- **다이어그램**: `agent-skills-context-window.png` (원제 "Skills and the Context Window" —
  시스템 프롬프트에 스킬 요약이 붙고, Tool use `Bash("cat /mnt/skills/pdf/SKILL.md")` → Tool result로
  본문이 들어오는 흐름을 그림으로 보여준다. 교육용으로 가장 직관적이다.)

---

### 5. 스킬은 언제 발동하는가 — description이 발동 조건이다

- **출처**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "The `description` is what Claude matches your request against when determining
  whether to trigger the Skill, so it must say both what the Skill does and when to use it."
  (description은 Claude가 요청과 대조하는 대상이다. 무엇을 하는지와 언제 쓰는지를 둘 다 담아야 한다.)
- **보조 출처**: Skill authoring best practices — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
  - "Each Skill has exactly one description field. The description is critical for skill selection:
    Claude uses it to choose the right Skill from potentially 100+ available Skills."
  - "**Always write in third person**. The description is injected into the system prompt, and
    inconsistent point-of-view can cause discovery problems." — Good: "Processes Excel files and
    generates reports" / Avoid: "I can help you process Excel files"
  - 좋은 예: `description: Extract text and tables from PDF files, fill forms, merge documents. Use
    when working with PDF files or when the user mentions PDFs, forms, or document extraction.`
  - 나쁜 예: `description: Helps with documents` / `Processes data` / `Does stuff with files`
- **수치**: "Keep SKILL.md body under 500 lines for optimal performance"
- **쓸 곳**: 스킬 작성에서 가장 중요한 한 줄은 description이다. 본문이 아무리 좋아도 description이
  모호하면 발동하지 않는다. 실습 과제의 채점 기준으로 쓴다.
- **우리 vault 대응**: **4주차 주제가 "스킬 제작"이다.** 이 항목이 4주차의 채점 기준이 된다.
  우리 스킬 중 description이 가장 긴 것은 `doc2md-ingest`(937 B)로, 전략 분기(D1/D2a/D2b/D2c/D3)와
  플랫폼 조건까지 담아 "언제 쓰는가"가 분명하다. `hwp2md-ingest`(560 B)도 "HWP/HWPX를 vault
  잉게스트 가능한 MD로"라는 대상과 "H1 직행, 희소 문서는 H3"라는 조건을 함께 적는다. 공식 권고
  그대로다. 반대로 짧은 쪽(`vault-ingest-once.md` 266 B)은 조건 서술이 얇다.
  교육에서 할 말: "2주차에서 description을 읽는 법을 배우고, 4주차에서 쓰는 법을 연습한다."
- **다이어그램**: 없음

---

### 6. 발동이 안 될 때 / 너무 자주 될 때 — 공식 트러블슈팅과 설명 예산

- **출처**: Extend Claude with skills — https://code.claude.com/docs/en/skills
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "If Claude doesn't use your skill when expected: 1. Check the description includes
  keywords users would naturally say 2. Verify the skill appears in `What skills are available?`
  3. Try rephrasing your request to match the description more closely 4. Invoke it directly with
  `/skill-name` if the skill is user-invocable"
  / "If Claude uses your skill when you don't want it: 1. Make the description more specific
  2. Add `disable-model-invocation: true` if you only want manual invocation"
  / "Claude Code loads a listing of skill names and descriptions into context so Claude knows what's
  available. The listing always contains every skill name, but if you have many skills, Claude Code
  shortens descriptions to fit the listing's character budget, which can strip the keywords Claude
  needs to match your request."
- **수치**:
  - 스킬 목록 예산: "The budget scales at 1% of the model's context window."
    (설정: `skillListingBudgetFraction`, 예 `0.02` = 2%)
  - 항목당 상한: "each entry's combined text is capped at 1,536 characters regardless of budget."
    (설정: `skillListingMaxDescChars`)
  - 예산 초과 시: "Claude Code drops descriptions starting with the skills you invoke least"
  - 진단 명령: `/doctor`, `/context`의 Skills 행
- **쓸 곳**: "스킬을 많이 깔면 안 걸린다"는 현상에는 실제 원인이 있다. 무제한이 아니라 컨텍스트의
  1% 예산 안에서 설명문이 잘린다. 스킬을 정리해야 하는 이유의 근거다.
- **우리 vault 대응 (결함 실물 1건)**: `config/skills/ollama-local-models.md`(3,035 B)에는
  **프론트매터가 아예 없다.** 첫 줄이 `# Skill: ollama-local-models (v1.0.0)`이고, `origin`은
  HTML 주석으로 들어가 있다. `name`·`description` 문자열이 파일 어디에도 없다.
  → 1단 메타데이터가 0이므로 Claude가 이 스킬의 존재를 알 방법이 없다. 공식 트러블슈팅의
  "If the frontmatter YAML is malformed, Claude Code loads the skill body with empty metadata, so
  `/skill-name` still works but Claude has no `description` to match against"의 실물 사례다.
  교육에서 할 말: "우리 vault에도 안 걸리는 스킬이 하나 있다. description이 발동 조건이라는 말은
  비유가 아니다." (4주차 실습 과제 후보: 이 파일에 프론트매터를 붙이는 것)
- **다이어그램**: 없음

---

### 7. 설치·배포 경로와 스코프별 우선순위 (Claude Code)

- **출처**: Extend Claude with skills — https://code.claude.com/docs/en/skills
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "Where you store a skill determines who can use it"

  | Location | Path | Applies to |
  | --- | --- | --- |
  | Enterprise | managed settings 참조 | All users in your organization |
  | Personal | `~/.claude/skills/<skill-name>/SKILL.md` | All your projects |
  | Project | `.claude/skills/<skill-name>/SKILL.md` | This project only |
  | Plugin | `<plugin>/skills/<skill-name>/SKILL.md` | Where plugin is enabled |

- **우선순위 (원문)**: "Across levels, enterprise overrides personal, and personal overrides project."
  → enterprise > personal > project. 예시: "with a `deploy` skill in both `~/.claude/skills/` and
  your project's `.claude/skills/`, `/deploy` runs the personal one."
  (**주의: 프로젝트가 아니라 개인 스킬이 이긴다.** 직관과 반대라 교육에서 반드시 짚어야 한다.)
- **플러그인**: "Plugin skills use a `plugin-name:skill-name` namespace, so they can't conflict with
  other levels." — 예: `/my-plugin:deploy`
- **탐색 범위**: "Project skills load from `.claude/skills/` in the directory where you start Claude
  Code and in every parent directory up to the repository root."
  / 중첩 디렉터리의 스킬은 시작 시 로드되지 않고, "They load the first time Claude reads or edits a
  file inside that subdirectory"
- **변경 감지**: "Claude Code watches skill directories for file changes... Claude Code picks up the
  change within the current session, without a restart." (단, 세션 시작 시 없던 최상위 skills 디렉터리를
  새로 만들면 재시작 필요)
- **다른 서피스의 공유 범위**: Agent Skills(platform) — "claude.ai: Individual user only. Each team
  member must upload separately. / Claude API: Workspace-wide. / Claude Code: Personal or
  project-based. Can also be shared through Claude Code Plugins."
  / "**Custom Skills do not sync across surfaces**."
- **쓸 곳**: 개인용은 `~/.claude/skills/`, 팀 공유는 저장소에 `.claude/skills/` 커밋. claude.ai 앱은
  개인 단위라 팀 공유가 안 된다는 점이 실무 판단의 갈림길이다.
- **우리 vault 대응 (가장 중요한 대비)**: 우리 스킬 17개는 `projects/second-brain/config/skills/`에
  있다. 이 경로는 Claude Code의 자동 발견 경로가 **아니다.** 대신 저장소 루트에
  `.claude/skills/` 심링크 3개가 있다.

  ```
  .claude/skills/doc2md-ingest -> ../../projects/second-brain/config/skills/doc2md-ingest
  .claude/skills/hwp2md-ingest -> ../../projects/second-brain/config/skills/hwp2md-ingest
  .claude/skills/pdf2md-ingest -> ../../projects/second-brain/config/skills/pdf2md-ingest
  ```

  이것은 공식 문서의 심링크 규정을 그대로 쓴 것이다 — "A `<skill-name>` entry in the enterprise,
  personal, or project locations can be a symlink to a directory elsewhere on disk. Claude Code
  follows the symlink and reads `SKILL.md` from the target directory."
  → **결과: 17개 중 3개만 자동 발동한다.** 세션 시작에 실제로 로드되는 1단 메타데이터는
  `doc2md-ingest` 937 + `hwp2md-ingest` 560 + `pdf2md-ingest` 513 = **2,010 B**다.
  나머지 14개는 `CLAUDE.md`와 `VAULT_RULES.md`가 가리키는 절차서이고, Claude가 스스로 찾아
  발동하는 스킬이 아니다.
  교육에서 할 말: "폴더에 SKILL.md를 뒀다고 스킬이 되는 게 아니다. Claude Code가 보는 경로에
  있어야 한다. 우리는 원본을 vault에 두고 `.claude/skills/`에 심링크를 걸어 둘 다 만족시켰다."
- **다이어그램**: 없음

---

### 8. 팀 배포 — 플러그인과 marketplace

- **출처**: Extend Claude with skills — https://code.claude.com/docs/en/skills (§ Share skills)
  / Discover and install prebuilt plugins through marketplaces — https://code.claude.com/docs/en/discover-plugins
  / Create plugins — https://code.claude.com/docs/en/plugins
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "Skills can be distributed at different scopes depending on your audience:
  **Project skills**: Commit `.claude/skills/` to version control / **Plugins**: Create a `skills/`
  directory in your plugin / **Managed**: Deploy organization-wide through managed settings"
  / "Plugins can include Agent Skills to extend Claude's capabilities. Skills are model-invoked:
  Claude automatically uses them based on the task context." — 플러그인 구조:
  `my-plugin/.claude-plugin/plugin.json` + `my-plugin/skills/code-review/SKILL.md`
  / "Claude Code adds the official Anthropic marketplace (`claude-plugins-official`) automatically
  the first time you start it interactively."
  / 설치: `/plugin install <name>@claude-plugins-official`, 카탈로그: https://claude.com/plugins
- **쓸 곳**: 팀 배포는 3단계다. 저장소 커밋 → 플러그인 → managed settings. 조직 규모에 따라 고르면 된다.
- **우리 vault 대응**: 우리는 3단계 중 1단계에 있다. `.claude/skills/`(심링크 3개)와
  `projects/second-brain/config/skills/`(원본 17개)를 저장소에 커밋해 배포한다. 플러그인이나
  managed settings는 쓰지 않는다. 교육 대상이 개인 vault를 각자 운영하는 형태라 현재는
  저장소 커밋이 맞는 선택이다. 교육에서 할 말: "지금은 git clone이 배포다. 팀이 같은 스킬을
  쓰기 시작하면 플러그인으로 올린다."
- **다이어그램**: 없음

---

### 9. 스킬 vs CLAUDE.md vs 슬래시 커맨드 — 공식 구분

- **출처**: Extend Claude Code — https://code.claude.com/docs/en/features-overview
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용 (CLAUDE.md vs Skill 표 원문)**:

  | Aspect | CLAUDE.md | Skill |
  | --- | --- | --- |
  | Loads | Every session, automatically | On demand |
  | Can trigger workflows | No | Yes, with `/<name>` |
  | Best for | "Always do X" rules | Reference material, invocable workflows |

  / "**Put it in CLAUDE.md** if Claude should always know it: coding conventions, build commands,
  project structure, 'never do X' rules. **Put it in a skill** if it's reference material Claude needs
  sometimes (API docs, style guides) or a workflow you trigger with `/<name>`."
  / "**Rule of thumb:** Keep CLAUDE.md under 200 lines."
- **슬래시 커맨드의 위치 (중요)**: Extend Claude with skills — https://code.claude.com/docs/en/skills
  — "**Custom commands have been merged into skills.** A file at `.claude/commands/deploy.md` and a
  skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way. Your existing
  `.claude/commands/` files keep working. Skills add optional features: a directory for supporting
  files, frontmatter to control whether you or Claude invokes them, and the ability for Claude to load
  them automatically when relevant."
  → **슬래시 커맨드는 스킬의 경쟁 개념이 아니라 스킬의 호출 방법이다.** 커스텀 커맨드는 스킬로
  통합되었고, `.claude/commands/`는 하위 호환으로 남아 있다.
  / 이름 충돌 시: "if a skill and a command share the same name, the skill takes precedence."
- **스킬을 만들 시점 (트리거 표 원문)**:
  - "Claude gets a convention or command wrong twice" → CLAUDE.md에 추가
  - "You keep typing the same prompt to start a task" → user-invocable skill로 저장
  - "You paste the same playbook or multi-step procedure into chat for the third time" → skill로 포착
  - "You keep copying data from a browser tab Claude can't see" → MCP 서버로 연결
- **컨텍스트 비용 표 원문**: CLAUDE.md는 "Session start / Full content / Every request",
  Skills는 "Session start + when used / Descriptions at start, full content when used / Low",
  MCP servers는 "Session start / Tool names; full schemas on demand / Low until a tool is used",
  Hooks는 "On trigger / Nothing (runs externally) / Zero"
- **쓸 곳**: 교육에서 가장 헷갈리는 지점을 공식 문장으로 정리한다. "항상 알아야 하면 CLAUDE.md,
  가끔 필요하면 스킬"이 한 줄 판별식이다.
- **우리 vault 대응**: 우리 vault는 이 구분을 이미 실행 중이다.
  - `CLAUDE.md`(항상 로드) — "Before vault work, read: VAULT_RULES.md / wiki/VAULT_MEMORY.md /
    wiki/INDEX.md", `raw/`·`archive/`는 append-only, `wiki/VAULT_MEMORY.md`는 8 KB 상한 같은
    **"항상 지켜야 하는 규칙"**만 담는다. 공식 권고 "Keep CLAUDE.md under 200 lines"에 부합한다.
  - 스킬 17개(필요할 때 로드) — 변환 절차, 잉게스트 절차, lint 절차 같은 **"할 때만 필요한 절차"**.
  - 우리 `CLAUDE.md`의 "Skills in `projects/second-brain/config/skills/` are the source of truth
    for procedures"라는 한 줄이 정확히 공식 판별식("항상 알아야 하면 CLAUDE.md, 절차면 스킬")을
    실행한 문장이다.
  교육에서 할 말: "우리 CLAUDE.md는 규칙만 있고 절차가 없다. 절차는 전부 스킬로 나갔다.
  그게 CLAUDE.md가 짧게 유지되는 이유다."
- **다이어그램**: `context-loading.svg` / `context-loading-dark.svg` (라이트·다크 2종. alt:
  "Context loading: CLAUDE.md loads at session start and stays in every request. MCP tool names load
  at start with full schemas deferred until use. Skills load descriptions at start, full content on
  invocation. Subagents get isolated context. Hooks run externally.")

---

### 10. 스킬 vs MCP — 공식 구분

- **출처**: Extend Claude Code — https://code.claude.com/docs/en/features-overview (§ MCP vs Skill 탭)
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "MCP connects Claude to external services. Skills extend what Claude knows,
  including how to use those services effectively."

  | Aspect | MCP | Skill |
  | --- | --- | --- |
  | What it is | Protocol for connecting to external services | Knowledge, workflows, and reference material |
  | Provides | Tools and data access | Knowledge, workflows, reference material |
  | Examples | Slack integration, database queries, browser control | Code review checklist, deploy workflow, API style guide |

  / "**MCP** gives Claude purpose-built tools for an external system, with the connection and
  authentication handled by the server. **Skills** give Claude knowledge about how to use those tools
  effectively, plus workflows you can trigger with `/<name>`."
  / 조합 패턴 원문: "**Skill + MCP** — MCP provides the connection; a skill teaches Claude how to use
  it well — MCP connects to your database, a skill documents your schema and query patterns"
- **보조 인용 (한 줄 요약으로 최적)**: Building Agents with Skills — https://claude.com/blog/building-agents-with-skills-equipping-agents-for-specialized-work
  (Jan 22, 2026) — "Each layer has a clear purpose: the loop reasons, the runtime executes, MCP
  connects, and skills guide." (루프는 판단하고, 런타임은 실행하고, MCP는 연결하고, 스킬은 안내한다.)
  / "Skills and MCP servers work together naturally. A competitive analysis skill might coordinate web
  search, internal databases via MCP, Slack message history, and Notion pages to synthesize a
  comprehensive report."
- **보조 인용 (Hook과의 대비 — 결정성)**: features-overview § Hook vs Skill — "**Determinism**: Hook —
  Always fires on its event; the trigger is guaranteed / Skill — Claude interprets the instructions;
  outcome can vary"
  / "An instruction like 'never edit `.env`' in CLAUDE.md or a skill is a request, not a guarantee.
  A `PreToolUse` hook that blocks the edit is enforcement."
- **쓸 곳**: MCP는 "손", 스킬은 "일하는 법"이다. 둘은 경쟁이 아니라 짝이다. 이 문장 하나로
  교육 중 절반의 질문이 정리된다.
- **우리 vault 대응 (Skill + MCP 짝의 실물)**: `config/skills/google-workspace.md`(5,897 B)가
  공식 조합 패턴 그대로다. MCP 서버 `workspace-mcp`
  (taylorwilsdon/google_workspace_mcp, stdio, `uvx workspace-mcp --tools drive sheets slides`)가
  Drive·Sheets·Slides에 **연결**하고, 이 스킬이 **어떻게 쓰는지**를 담는다. 스킬 본문은
  전제 조건으로 `claude mcp list`에서 `workspace-mcp - ✔ Connected` 확인을 요구하고, description은
  "(연결된 workspace-mcp 서버가 없으면 사용하지 않는다.)"로 끝난다. 즉 **스킬이 MCP에 의존한다는
  것을 description에 명시**해 둔 사례다.
  더 나아가 이 스킬은 "도구 스키마는 지연 로드된다 — 호출 전에 ToolSearch로 필요한 도구를 한 번에
  묶어 로드한다"고 지시한다. 공식 문서의 MCP 컨텍스트 비용 서술("Tool names; full schemas on
  demand")을 스킬이 절차로 번역한 것이다.
  반대쪽 극은 `hwp2md-ingest`다. MCP 없이 로컬 CLI와 번들 스크립트만 쓴다. 외부 연결이 필요 없는
  일은 스킬 단독으로 끝난다.
  교육에서 할 말: "`google-workspace.md`를 열어 보면 스킬과 MCP의 관계가 한 파일에 다 있다.
  MCP가 문을 열고, 스킬이 그 문으로 뭘 할지 적는다."
- **다이어그램**: `agent-skills-architecture.png` (원제 "Agent + Skills + Virtual Machine").
  **한 그림에 Equipped Skills와 Equipped MCP servers가 나란히 그려져 있어 스킬/MCP 구분 설명에
  가장 적합하다.** 왼쪽 Agent configuration(Core system prompt / Equipped Skills / Equipped MCP
  servers)과 오른쪽 Agent virtual machine(Bash·Python·Nodejs / File system의 `skills/*/SKILL.md`)이
  분리돼 있고, MCP 서버는 아래쪽 "Remote MCP servers (elsewhere on the internet)"로 빠진다.

---

### 11. 비개발자 경로 (1) — 코딩 없이 스킬을 쓰고 만든다

- **출처**: What are Skills? — https://support.claude.com/en/articles/12512176-what-are-skills
- **날짜**: 최종 갱신일 "Over 3 weeks ago" (정확한 날짜 미표기, 2026-08-27 확인)
- **핵심 인용**: "Anyone can create skills by writing instructions in Markdown—no coding required for
  simple skills, though you can attach executable scripts to custom skills for more advanced
  functionality." (누구나 마크다운으로 지시를 써서 스킬을 만들 수 있다. 단순한 스킬에는 코딩이
  필요하지 않다.)
  / "folders of instructions, scripts, and resources that Claude loads dynamically to improve
  performance on specialized tasks."
- **사용 경로**: 계정에서 Customize → Skills → `+` → Browse skills로 디렉터리를 연다.
- **플랜**: "Skills are available for users on Free, Pro, Max, Team, and Enterprise plans."
  → **주의: 플랫폼 문서는 다르게 적는다.** Agent Skills(platform) — "Available on Pro, Max, Team, and
  Enterprise plans with code execution enabled." / Skills overview(claude.com/docs) — "Skills are
  available for users on Pro, Max, Team, and Enterprise plans. The Skills feature requires code
  execution to be enabled." 두 서술이 Free 포함 여부에서 어긋난다. 교육 자료에서는 플랜을 단정하지
  않고 "플랜별로 다르며 코드 실행 활성화가 필요하다"로 적는다.
- **쓸 곳**: 스킬은 개발자 전용 기능이 아니다. 기획자도 마크다운만 쓸 수 있으면 만든다.
- **우리 vault 대응**: 우리 스킬 17개는 전부 마크다운이다. 코드가 들어 있는 것은 폴더형 3개의
  `scripts/`뿐이고, 그마저 진입점 `SKILL.md`는 마크다운 표와 산문이다. 평평한 `.md` 14개
  (`vault-ingest.md` 6,339 B, `vault-query.md` 4,584 B, `private-note.md` 2,678 B 등)는
  코드 없이 절차만 적은 문서다. 즉 우리 vault의 스킬 대부분은 비개발자가 읽고 고칠 수 있는 형태다.
  교육에서 할 말: "우리 스킬 17개 중 14개에는 코드가 한 줄도 없다. 기획자도 고칠 수 있다."
- **다이어그램**: 없음

---

### 12. 비개발자 경로 (2) — 화면 녹화로 스킬을 만든다 (Cowork)

- **출처**: How to create custom Skills — https://support.claude.com/en/articles/12512198-creating-custom-skills
- **날짜**: 최종 갱신 2026-07-22
- **핵심 인용**: "Claude starts a Cowork task and reviews the recording, then proposes a skill."
  (Claude가 Cowork 작업을 시작해 녹화를 검토하고 스킬을 제안한다.)
- **절차 (원문 요지)**: Claude for Mac의 Cowork에서 composer의 `+` → "Record a skill", 또는
  Customize > Skills → Add → "Record your screen" → Start recording → 평소대로 작업 → Done.
  대상 플랜은 Pro·Max·Team.
- **직접 작성 경로**: `skill.md`(name·description 필수) 작성 → 마크다운 지시와 선택 자료 추가 →
  ZIP으로 포장 → Customize > Skills에서 업로드·활성화 → 여러 프롬프트로 발동 확인.
  ZIP 구조: "The ZIP should contain the skill folder as its root (not a subfolder)."
  ```
  my-skill.zip
  └── my-skill/
      ├── skill.md
      └── resources/
  ```
- **쓸 곳**: 비개발자에게 가장 낮은 진입점이다. 작업을 한 번 시연하면 Claude가 스킬 초안을 만든다.
  교육에서 기획자 트랙 실습으로 쓸 수 있다.
- **우리 vault 대응**: 우리 스킬은 전부 파일로 직접 쓴 것이고, Cowork 녹화로 만든 것은 없다.
  4주차 "스킬 제작" 실습에서 두 경로를 병렬로 제시할 수 있다. 개발자 트랙은 `.claude/skills/`에
  폴더를 만들어 `SKILL.md`를 쓰는 우리 방식, 기획자 트랙은 Cowork "Record a skill"로 초안을 받아
  다듬는 방식. 두 결과물의 형식은 같다(`SKILL.md` + name·description).
  교육에서 할 말: "만드는 방법은 둘이지만 나오는 파일은 하나다."
- **다이어그램**: 없음

---

### 13. 문서 변환 관련 공식 스킬 (docx·pdf·xlsx·pptx)

- **출처**: anthropics/skills — https://github.com/anthropics/skills
  / 각 SKILL.md 원본: https://raw.githubusercontent.com/anthropics/skills/main/skills/{docx,pdf,xlsx,pptx}/SKILL.md
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용 (저장소)**: "We've also included the document creation & editing skills that power
  Claude's document capabilities under the hood in the `skills/docx`, `skills/pdf`, `skills/pptx`, and
  `skills/xlsx` subfolders. These are source-available, not open source, but we wanted to share these
  with developers as a reference for more complex skills that are actively used in a production AI
  application."
  → 4개 문서 스킬의 frontmatter는 모두 `license: Proprietary. LICENSE.txt has complete terms`다.
  저장소의 다른 스킬은 Apache 2.0이지만 문서 스킬은 그렇지 않다.
- **각 스킬이 실제로 하는 일 (SKILL.md 원문에서)**:
  - `docx` — "A `.docx` is a ZIP archive of XML files." 작업별 경로 표: **Create** → `docx`(npm) 스크립트,
    **Edit** → `unzip` → `word/document.xml` 편집 → `zip`, **Read** → `pandoc -t markdown file.docx`
  - `pptx` — **Read** → `markitdown deck.pptx` ("one block per slide under `<!-- Slide number: N -->`
    markers"), 시각 확인은 `scripts/thumbnail.py`
  - `xlsx` — **Quick look** → `markitdown file.xlsx` ("`## SheetName` per sheet; reads `.xlsm` too.
    No cell coordinates, so don't plan edits from it")
  - `pdf` — description: "reading or extracting text/tables from PDFs, combining or merging...
    filling PDF forms, encrypting/decrypting PDFs, extracting images, and OCR on scanned PDFs"
- **우리 교육의 hwp/doc→md 파트와 비교되는 지점**:
  1. 공식 문서 스킬의 **읽기 경로는 우리와 같은 도구 계열**이다. docx는 `pandoc -t markdown`,
     pptx·xlsx는 `markitdown`. 즉 "변환은 외부 CLI에 맡기고 스킬은 어느 도구를 언제 쓸지 표로 지시한다"는
     설계가 공식 패턴이다.
  2. **HWP/HWPX를 다루는 공식 스킬은 없다.** 4종은 Office·PDF 계열뿐이다. 우리 교육의 hwp2md-ingest는
     공식 커버리지의 빈칸을 메우는 자리다.
  3. 공식 스킬은 "작업 → 접근법" 2열 표로 시작한다. 우리 스킬의 전략 분기(H1/H3, D1/D2a/D2b/D2c/D3)와
     같은 구조다. 서식 근거로 인용할 수 있다.
- **우리 vault 대응 (직접 비교)**: 우리 변환 스킬 3종과 Anthropic 공식 문서 스킬 4종을 나란히 둔다.

  | | 우리 스킬 | 공식 스킬 |
  | --- | --- | --- |
  | Word | `doc2md-ingest` (18,011 / 37,964 B) — D1 `.docx`→pandoc 직행, D2a LibreOffice, D2b textutil, D2c Word COM, D3 비전 | `docx` — Read는 `pandoc -t markdown file.docx` |
  | PDF | `pdf2md-ingest` (8,600 / 42,348 B) — S2 pymupdf4llm / S6 로컬 OCR / S4 비전 | `pdf` — pypdf·OCR·폼 |
  | HWP | `hwp2md-ingest` (8,991 / 10,832 B) — H1 hwp-hwpx-parser 직행, H3 비전 | **없음** |
  | Excel·PPT | 없음 | `xlsx`·`pptx` — Read는 `markitdown` |

  세 가지가 확인된다.
  1. **읽기 도구 계열이 같다.** 공식 docx 스킬의 Read 경로가 `pandoc -t markdown`이고, 우리 D1도
     pandoc이다. 우리가 임의로 고른 것이 아니라 공식 스킬과 같은 선택을 한 것이다.
  2. **HWP는 공식 커버리지에 없다.** `hwp2md-ingest`는 빈칸을 메우는 자리다. 우리 vault가 공식
     스킬을 대체하는 게 아니라 확장한다.
  3. **서식이 같다.** 공식 스킬은 "Task | Approach" 2열 표로 시작하고, 우리 스킬도 전략 분기를
     표로 먼저 보여준다. 4주차 스킬 제작의 서식 근거로 이 표를 인용한다.

  교육에서 할 말: "Anthropic이 pandoc을 쓰는 자리에 우리도 pandoc을 쓴다. HWP만 우리 몫이다."
- **다이어그램**: 없음 (SKILL.md는 텍스트)

---

### 14. Agent Skills는 오픈 표준이다 — 이식성

- **출처**: Agent Skills Overview — https://agentskills.io
  / Building Agents with Skills — https://claude.com/blog/building-agents-with-skills-equipping-agents-for-specialized-work
- **날짜**: agentskills.io 미표기 (2026-08-27 확인) / 블로그 Jan 22, 2026
- **핵심 인용**: "Agent Skills are a lightweight, open format for extending AI agent capabilities with
  specialized knowledge and workflows."
  / "The Agent Skills format was originally developed by Anthropic, released as an open standard, and
  has been adopted by a growing number of agent products."
  / 블로그 — "To enable this vision, we're publishing Agent Skills as an open standard. Like MCP, we
  believe skills should be portable across tools and platforms. The same skill should work whether
  you're using Claude or other AI platforms."
  / Claude Code 문서 — "Claude Code skills follow the Agent Skills open standard, which works across
  multiple AI tools. Claude Code extends the standard with additional features like invocation
  control, subagent execution, and dynamic context injection."
- **표준의 3단 정의 (원문)**: "Agents load skills through **progressive disclosure**, in three stages:
  1. **Discovery**: At startup, agents load only the name and description of each available skill...
  2. **Activation**: When a task matches a skill's description, the agent reads the full `SKILL.md`
  instructions into context. 3. **Execution**: The agent follows the instructions, optionally
  executing bundled code or loading referenced files as needed."
- **채택 클라이언트 (Client Showcase에 실린 것 중 일부)**: Cursor, VS Code / GitHub Copilot,
  Gemini CLI, ChatGPT & Codex, OpenCode, OpenHands, Goose, Amp, Kiro, Roo Code, Letta,
  Databricks Genie Code, Snowflake Cortex Code, Laravel Boost, Spring AI, Junie(JetBrains),
  Mistral AI Vibe, Factory, Tabnine, Qodo
- **거버넌스**: GitHub https://github.com/agentskills/agentskills, 명세 https://agentskills.io/specification
- **쓸 곳**: 스킬을 배우는 것은 Claude 하나를 배우는 것이 아니다. 같은 폴더 형식이 Cursor·Copilot·
  Gemini CLI·Codex에서도 돈다. 학습 투자 대비 회수의 근거다.
- **우리 vault 대응**: 우리 스킬 17개는 Claude Code 확장 필드를 쓰지 않는다. `name`·`description`
  본체와 우리 관례인 `origin:`뿐이다. 즉 표준 부분만 쓰고 있어서 `.claude/skills/`에 있는 3개는
  Cursor·VS Code·Codex 같은 다른 클라이언트에도 폴더를 그대로 복사해 쓸 수 있다.
  (`origin:`은 표준 밖 필드라 다른 클라이언트가 무시하거나 경고할 수 있다. 확인하지 않았다.)
  교육에서 할 말: "우리가 만든 변환 스킬은 Claude 전용이 아니다. 폴더째로 옮겨진다."
- **다이어그램**: 없음 (agentskills.io는 로고 카루셀만 있고 도해는 없다)

---

### 15. 스킬의 보안 전제 — 신뢰할 수 있는 출처만

- **출처**: Agent Skills — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview (§ Security considerations)
- **날짜**: 미표기 (2026-08-27 확인)
- **핵심 인용**: "Use Skills only from trusted sources: those you created yourself or obtained from
  Anthropic. Skills give Claude new capabilities through instructions and code, which also means a
  malicious Skill can direct Claude to invoke tools or execute code in ways that don't match the
  Skill's stated purpose."
  / "**Treat like installing software:** Be especially careful when integrating Skills into production
  systems with access to sensitive data or critical operations."
  / "Skills that fetch data from external URLs pose particular risk, as fetched content may contain
  malicious instructions."
- **쓸 곳**: marketplace에서 스킬을 받는 실습을 하기 전에 반드시 붙일 경고다. 스킬 설치는 소프트웨어
  설치와 같은 무게로 다룬다.
- **우리 vault 대응**: 우리 스킬 17개는 전부 자체 제작이거나 `origin:` 필드로 출처
  (`lemoncloud-io/knowledge@<sha>`)를 명시한 것이다. 외부 marketplace에서 받은 스킬은 없다.
  `origin:` 필드가 사실상 감사 추적 역할을 한다. 4주차에서 marketplace 스킬을 설치하는 실습을
  한다면 이 경고를 먼저 붙인다.
  교육에서 할 말: "우리 스킬은 전부 출처가 적혀 있다. 밖에서 받은 스킬은 그 줄이 비어 있다는
  뜻이다."
- **다이어그램**: 없음

---

## 다이어그램 인벤토리

내려받은 파일은 `projects/second-brain/outputs/week2-sources/assets/`에 둔다.
아래 표는 이번 수집(스킬)에서 추가한 파일만 다룬다. 같은 디렉터리에 다른 수집자가 넣은
`mcp-*`·`progressive-discovery.svg`·`programmatic-tool-calling.svg`는 이 표의 범위가 아니다.

| 파일명 | 원본 URL | 출처 | 라이선스 | 보여줄 내용 | 임베드 방식 |
| --- | --- | --- | --- | --- | --- |
| `agent-skills-architecture.png` (2048x1153) | https://platform.claude.com/docs/images/agent-skills-architecture.png | Agent Skills (platform docs) / 원안은 engineering 블로그 "Agent + Skills + Virtual Machine" | 미표기 — Anthropic 공식 문서 이미지 | 왼쪽 Agent configuration(Equipped Skills + Equipped MCP servers), 오른쪽 Agent VM(Bash/Python/Node + skills 파일시스템), 아래 Remote MCP servers | 로컬 파일 `<img>`. 출처·URL 캡션 필수. **스킬 vs MCP 슬라이드의 주력 이미지** |
| `agent-skills-context-window.png` (2048x1154) | https://platform.claude.com/docs/images/agent-skills-context-window.png | 같음. 원안 제목 "Skills and the Context Window" | 미표기 — Anthropic 공식 문서 이미지 | 시스템 프롬프트에 스킬 요약이 붙고, `Bash("cat .../SKILL.md")` → Tool result로 본문이 들어오는 발동 흐름 | 로컬 파일 `<img>`. **progressive disclosure 발동 설명의 주력 이미지** |
| `agent-skills-simple-file.png` (2048x1153) | https://platform.claude.com/docs/images/agent-skills-simple-file.png | Skill authoring best practices. 원안 제목 "A simple SKILL.md file" | 미표기 — Anthropic 공식 문서 이미지 | YAML frontmatter(name·description) + Markdown 본문 2블록 | 로컬 파일 `<img>`. "스킬은 파일 하나다" 슬라이드 |
| `agent-skills-bundling-content.png` (2048x1327) | https://platform.claude.com/docs/images/agent-skills-bundling-content.png | 같음. 원안 제목 "Bundling additional content" | 미표기 — Anthropic 공식 문서 이미지 | SKILL.md 본문의 `./reference.md`·`./forms.md` 언급이 실제 파일로 이어지는 화살표 | 로컬 파일 `<img>`. Level 3 설명 |
| `skills-progressive-disclosure-levels.jpg` (1200px) | https://cdn.sanity.io/images/4zrzovbb/website/a3bca2763d7892982a59c28aa4df7993aaae55ae-2292x673.jpg | Equipping agents for the real world with Agent Skills (engineering 블로그, 2025-10-16) | 미표기 — Anthropic 공식 블로그 이미지 | Level / File / Context Window / # Tokens 4열 표. Level 1 ~100, Level 2 <5k, Level 3+ unlimited* | 로컬 파일 `<img>`. **토큰 수치를 그림으로 보여야 할 때 이것 하나면 된다.** 표를 직접 재작성해도 되나 수치 출처가 분명해지는 이점이 있다 |
| `skills-bundling-executable-scripts.jpg` (1200px) | https://cdn.sanity.io/images/4zrzovbb/website/c24b4a2ff77277c430f2c9ef1541101766ae5714-1650x929.jpg | 같은 블로그. 원제 "Bundling executable scripts" | 미표기 — Anthropic 공식 블로그 이미지 | `forms.md`의 스크립트 언급 → `extract_fields.py` 실제 코드로 이어지는 연결. 코드는 컨텍스트에 안 들어오고 출력만 들어온다는 설명의 그림 | 로컬 파일 `<img>`. 개발자 트랙에서만 씀 |
| `context-loading.svg` / `context-loading-dark.svg` (720x382) | https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/context-loading.svg (dark: `_xqph1dUOslCOwsj/images/context-loading-dark.svg`) | Extend Claude Code (code.claude.com) | 미표기 — Anthropic 공식 문서 이미지 | CLAUDE.md는 세션 시작에 전량, MCP는 도구 이름만, 스킬은 설명만 → 호출 시 본문, 서브에이전트는 격리, 훅은 외부 실행 | 인라인 SVG 또는 `<img>`. **CLAUDE.md/스킬/MCP/훅 4자 비교 슬라이드의 주력 이미지.** 라이트·다크 2종이 있어 테마 대응 가능. 두 파일은 실제로 다르다(md5 상이, 라이트는 `#F9F9F7`·`#1E1E1E` 계열, 다크는 `#1A1A1A`·`#C4C4C4` 계열) |
| `blog-skills-fig1.png` (2880x1354) | https://cdn.prod.website-files.com/68a44d4040f98a4adf2207b6/6972a852db1883d8c862151f_building-agents-with-skills-fig1-v3%402x.png | Building Agents with Skills (claude.com/blog, 2026-01-22) | 미표기 — Anthropic 공식 블로그 이미지 | 제목 "Before: Domain-specific coding agents". Coding / Research / Finance / Marketing 에이전트 4개를 나란히 둔 그림 | 로컬 파일 `<img>`. fig2와 2장 세트로 "왜 스킬인가" 도입부에 쓴다 |
| `blog-skills-fig2.png` (2880x1694) | .../6972a8b8cb336e177c409445_building-agents-with-skills-fig2-v4%402x.png | 같음 | 미표기 | 제목 "Today: General-purpose coding agent". 왼쪽에 코딩 에이전트 하나, 오른쪽에 Use cases 아이콘 9개(문서·표·메일·발표자료 등) | 로컬 파일 `<img>`. fig1 → fig2 순서로 붙여 "에이전트를 도메인별로 만들던 시대에서 범용 에이전트 하나에 전문성을 얹는 시대로"를 보여준다 |
| `blog-skills-fig3.png` (2880x1694) | .../6972ab24ac6df74ad6704f37_building-agents-with-skills-fig3-v2%402x.png | 같음 | 미표기 | 제목 "Skills: The complete picture". 가운데 Agent(루프 + 코드 실행), **왼쪽에 MCP server 1·2·3, 오른쪽에 Filesystem 안의 Skill 3개** | 로컬 파일 `<img>`. **비개발자용 스킬 vs MCP 설명에 가장 좋다.** `agent-skills-architecture.png`보다 요소가 훨씬 적어 한 장으로 "MCP는 밖으로, 스킬은 안의 파일"이 읽힌다 |

### 라이선스 판단

Anthropic 공식 문서·블로그의 도해에는 별도 이용 허락 표기가 없다. 저작권 표시나 CC 라이선스도
찾지 못했다. 따라서 다음 전제로만 쓴다.

- 사내 비공개 교육 자료 안에서 출처와 원본 URL을 캡션으로 밝히고 인용한다.
- 이미지를 잘라 재구성하거나 워터마크를 지우지 않는다.
- 외부 공개·재배포가 필요하면 그 시점에 다시 판단한다. 안전한 대안은 원본 URL만 링크로 걸고,
  같은 내용을 자체 Mermaid·SVG로 다시 그리는 것이다.
- `agentskills.io`의 클라이언트 로고는 각 회사 상표다. 내려받지 않았다.

Mermaid 소스는 어느 공식 문서에서도 제공하지 않는다. 도해는 모두 완성된 래스터(PNG/JPG) 또는
정적 SVG다. `context-loading.svg`만 텍스트 편집이 가능한 SVG다.

---

## 스킬 vs MCP 비교표

앞의 세 열은 위 항목 9·10의 공식 서술만으로 채웠다. 자체 추정은 넣지 않았다.
`우리 vault 실물` 열은 2026-08-27 `projects/second-brain/config/skills/` 실측값과 스킬 본문 인용이다.

| 축 | 스킬 (Agent Skills) | MCP (Model Context Protocol) | 우리 vault 실물 |
| --- | --- | --- | --- |
| **무엇을 늘리는가** | "Knowledge, workflows, and reference material" — Claude가 아는 것을 늘린다 | "Protocol for connecting to external services" — Claude가 닿는 곳을 늘린다 | 스킬: `hwp2md-ingest` — HWP를 MD로 바꾸는 절차를 안다 / MCP: `workspace-mcp` — Google Drive에 닿는다 |
| **제공물** | 지식·워크플로·참조 자료 | "Tools and data access" | 스킬: H1/H3 전략 분기와 `scripts/h1-extract.py` / MCP: 38개 도구(읽기 5·쓰기 4 실측 검증) |
| **컨텍스트 비용** | 세션 시작에 name·description만(스킬당 ~100 토큰), 발동 시 SKILL.md 본문(<5k), 번들 파일은 읽을 때까지 0 | 세션 시작에 "Tool names; full schemas on demand", 도구를 쓰기 전까지 낮음 | 스킬: `.claude/skills/` 3개 = 2,010 B 상시 / MCP: `google-workspace.md`가 "호출 전에 ToolSearch로 필요한 도구를 한 번에 묶어 로드한다"고 지시 |
| **만드는 난이도** | `SKILL.md` 1개로 성립. "no coding required for simple skills" (support.claude.com) | 서버를 구현하거나 기존 서버를 붙인다. 연결·인증은 "handled by the server" | 스킬: 우리 17개 중 14개가 코드 0줄 / MCP: 설치·OAuth 절차가 별도 문서 `docs/google-workspace-mcp-setup.md` |
| **배포 방식** | 파일시스템: `~/.claude/skills/`(개인) · `.claude/skills/`(프로젝트, 저장소 커밋) · 플러그인 `skills/` · managed settings(조직). 우선순위 enterprise > personal > project. 플러그인은 `plugin:skill` 네임스페이스 | 서버 설정: 스코프 우선순위 "local > project > user" (features-overview § Understand how features layer) | 스킬: 원본은 `config/skills/`, `.claude/skills/`에 심링크 3개 → git clone으로 배포 / MCP: user 스코프 등록, 저장소에 안 담긴다 |
| **언제 쓰나** | "Code review checklist, deploy workflow, API style guide" — 반복 절차와 참조 자료 | "Slack integration, database queries, browser control" — 외부 데이터·행동 | 스킬: 변환·잉게스트·lint 절차 / MCP: Drive 파일 검색, Sheets 범위 읽기·쓰기 |
| **한 줄 정의** | "skills guide" | "MCP connects" (Building Agents with Skills) | 우리 vault에서도 같다. `google-workspace.md`가 안내하고 `workspace-mcp`가 연결한다 |
| **조합** | "MCP provides the connection; a skill teaches Claude how to use it well" — MCP가 DB에 붙고, 스킬이 스키마와 쿼리 패턴을 문서화한다 | 같음 | `google-workspace.md` 한 파일이 이 조합의 실물이다. description이 "(연결된 workspace-mcp 서버가 없으면 사용하지 않는다.)"로 끝난다 |
| **결정성** | "Claude interprets the instructions; outcome can vary" | 표에 대응 서술 없음. 참고로 훅은 "Always fires on its event; the trigger is guaranteed" | 우리 vault의 하드 불변식(`raw/` append-only, `VAULT_MEMORY.md` 8 KB 상한)은 스킬이 아니라 `CLAUDE.md`에 있다. 스킬로는 보장이 안 되기 때문이다 |
| **이식성** | 오픈 표준. Cursor·VS Code·Gemini CLI·Codex 등이 같은 형식을 읽는다 | 오픈 표준. "MCP became the standard for agent connectivity" | 스킬: 표준 필드만 써서 폴더째 이식 가능 / MCP: `uvx workspace-mcp` 명령 그대로 다른 클라이언트에 등록 |

---

## 비개발자용 설명 후보

교육에서 스킬을 비개발자에게 설명할 비유 후보다. 출처가 공식 문서인 것과 자작인 것을 구분한다.

1. **온보딩 가이드** (출처: 공식) — "organized like an onboarding guide you'd create for a new team
   member" (Agent Skills, platform docs). 신입에게 건네는 업무 인수 문서다. 스킬 폴더가 곧 그 문서
   묶음이다. 공식 표현이라 가장 안전하다.

2. **목차가 있는 매뉴얼** (출처: 공식) — "Like a well-organized manual that starts with a table of
   contents, then specific chapters, and finally a detailed appendix, skills let Claude load
   information only as needed." (engineering 블로그). progressive disclosure를 설명할 때 이 비유를
   그대로 쓴다. 목차만 늘 펼쳐 두고, 필요한 장만 열고, 부록은 찾을 때만 본다.

3. **레시피 카드** (자작) — description은 카드 앞면의 "무엇을 만드는 요리인가 / 언제 꺼내는가"이고,
   본문은 뒷면의 조리 순서다. 주방에 카드 100장을 꽂아 둬도 부담이 없다. 앞면만 보이기 때문이다.
   카드 앞면을 모호하게 쓰면 필요할 때 못 찾는다는 점까지 그대로 대응한다.

4. **회사의 업무 매뉴얼 캐비닛** (자작) — CLAUDE.md는 벽에 붙은 사내 규정이다. 늘 눈에 있고 늘
   지켜야 한다. 스킬은 캐비닛에 꽂힌 업무별 매뉴얼이다. 해당 업무를 할 때만 꺼낸다. 규정을 계속
   늘리면 벽이 안 보이고, 그래서 "CLAUDE.md는 200줄 아래로"라는 공식 권고가 있다.

5. **전문가를 부르는 것 vs 전화선을 놓는 것** (자작) — 스킬은 그 일을 아는 전문가를 부르는 것이고,
   MCP는 외부 기관에 전화선을 놓는 것이다. 전화선만 있으면 무엇을 물어야 할지 모른다. 전문가만
   있으면 확인할 데이터가 없다. 둘이 짝이다. ("the loop reasons, the runtime executes, MCP connects,
   and skills guide"의 의역)

---

## 확인 못 한 것

1. **공식 도해의 이용 조건**. Anthropic 문서·블로그 이미지에 라이선스·이용 허락 표기를 찾지 못했다.
   사내 교육 인용 범위로 한정하고, 외부 공개 시 재판단한다.

2. **claude.ai 스킬의 대상 플랜**. support.claude.com은 "Free, Pro, Max, Team, and Enterprise",
   platform.claude.com과 claude.com/docs는 "Pro, Max, Team, and Enterprise"로 적는다. 어느 쪽이
   최신인지 판단할 근거(각 페이지의 발행일)가 없다. 교육 자료에서는 플랜을 단정하지 않는다.

3. **토큰 수치의 불일치**. 문서 표는 Level 1 ~100 / Level 2 <5k, 2026-01-22 블로그는 ~50 / ~500이다.
   어느 쪽이 갱신본인지 확인할 근거가 없다. 문서 표를 기준으로 쓰기로 정했으나 근거는 "문서가
   레퍼런스 성격"이라는 판단뿐이다.

4. **스킬 개수 상한**. "you can install many Skills without context penalty", "potentially 100+
   available Skills", "hundreds of skills"라는 서술은 있으나 명시적 상한은 어느 문서에도 없다.
   실질 제약은 스킬 목록 예산(컨텍스트의 1%, 항목당 1,536자)이다.

5. **HWP/HWPX 관련 공식 스킬**. anthropics/skills 저장소와 사전 제작 스킬 목록을 확인했으나 없다.
   "없다"를 확인한 것이라 근거 공백은 아니지만, 저장소 전체 파일 목록을 훑은 것은 아니고
   README와 문서 스킬 4종만 확인했다.

6. **`origin:` 필드의 타 클라이언트 호환성**. 우리 스킬 16개가 쓰는 `origin:`은 Agent Skills 규격에
   없는 필드다. Cursor·Codex 등이 무시하는지 경고하는지 확인하지 못했다. 항목 14의 "폴더째 이식
   가능"은 이 부분을 검증하지 않은 상태의 판단이다.

7. **우리 1단 메타데이터의 실제 토큰 수**. 바이트는 확정했으나(6,823 B) 토큰으로 환산하지 않았다.
   Claude 토크나이저를 돌리지 않았고, 한글의 바이트당 토큰비를 공식 문서에서 찾지 못했다.
   바이트에서 토큰을 추정해 적지 않는다. **닫는 방법은 있다** — 공식 문서가 "The Skills row in
   `/context` reports the size of the listing after the budget is applied, so it matches what the
   model receives"라고 적는다. 이 저장소에서 `/context`를 실행해 Skills 행을 읽으면 모델이 실제로
   받는 크기가 나온다. `/doctor`는 목록의 컨텍스트 비용 추정치와 최대 기여자를 보여준다.

8. **`skill-creator`의 비개발자 사용성**. Claude Code 플러그인(`/plugin install
   skill-creator@claude-plugins-official`)으로만 확인했다. claude.ai 앱에서 같은 도구를 쓸 수 있는지는
   확인하지 못했다. 앱 쪽 비개발자 경로는 Cowork의 "Record a skill"이 공식 안내다.


---

## 우리 vault 대응 매핑

2026-08-27 `projects/second-brain/config/skills/` 실측 기준. 위 15개 항목의 `우리 vault 대응`을
한 표로 압축한 것이다. 교육 자료를 쓸 때 이 표에서 슬라이드 순서를 잡는다.

| # | 외부 근거 | 우리 vault의 대응 스킬 / 수치 | 교육에서 할 말 |
| --- | --- | --- | --- |
| 1 | 스킬은 "지시·스크립트·자료를 담은 폴더" (engineering 블로그) | `config/skills/` 17개, 188,371 B. 평평한 `.md` 14개 + 폴더형 3개 | 우리가 이미 쓰고 있는 게 스킬이다 |
| 2 | 필수 필드는 `name`·`description` 둘 (platform docs) | 16개는 갖췄고 1개는 없다. 우리 관례 `origin:`은 규격 밖(16개 1,557 B) | 필수는 둘이다. 나머지는 우리 관례다 |
| 3 | 3단 로딩. 1단 ~100 토큰/스킬, 2단 <5k, 3단 접근 전 0 | **1단 6,823 B = 전량의 3.6% ≈ 1/28** (셈법 C: name+description 값만) · 2단 132,829 B(17개) · 3단 55,542 B(8개) · 전량 188,371 B | 1/28만 항상 켜져 있다 |
| 4 | 발동 = `cat SKILL.md`. 스크립트는 출력만 들어온다 | `pdf2md-ingest` SKILL.md 8,600 B / 폴더 42,348 B. `design.md` 6,438·`implementation-plan.md` 22,876은 안 읽힌다 | 42 KB짜리 폴더를 불러도 8.6 KB만 들어온다 |
| 5 | description이 발동 조건. 무엇+언제를 같이 쓴다 | 가장 잘 쓴 예 `doc2md-ingest` 937 B, `hwp2md-ingest` 560 B. 얇은 예 `vault-ingest-once.md` 266 B | **4주차 스킬 제작의 채점 기준** |
| 6 | 프론트매터가 깨지면 매칭할 description이 없다 | **`ollama-local-models.md`(3,035 B)에 프론트매터 없음.** 첫 줄이 `# Skill: ...`, origin은 HTML 주석 | 우리 vault에도 안 걸리는 스킬이 하나 있다 |
| 7 | 스킬 위치가 사용 범위를 정한다. 심링크 지원. enterprise > personal > project | 원본은 `config/skills/`(자동 발견 경로 아님). `.claude/skills/`에 **심링크 3개**뿐 → **17개 중 3개만 자동 발동, 상시 로드 2,010 B** | 폴더에 SKILL.md를 뒀다고 스킬이 되는 게 아니다 |
| 8 | 배포는 저장소 커밋 → 플러그인 → managed settings | 1단계에 있다. git clone이 배포다 | 팀이 같은 스킬을 쓰기 시작하면 플러그인으로 올린다 |
| 9 | 항상 알아야 하면 CLAUDE.md, 절차면 스킬. CLAUDE.md는 200줄 아래 | 우리 `CLAUDE.md`는 규칙(append-only, 8 KB 상한)만 담고 "Skills in `config/skills/` are the source of truth for procedures"로 절차를 넘긴다 | 우리 CLAUDE.md가 짧은 이유가 이것이다 |
| 10 | MCP는 연결, 스킬은 그 사용법. 둘은 짝이다 | `google-workspace.md`(5,897 B) ↔ `workspace-mcp` 서버. description이 "연결된 서버가 없으면 사용하지 않는다"로 끝난다. 반대 극은 `hwp2md-ingest`(MCP 불필요) | 한 파일에 스킬과 MCP의 관계가 다 있다 |
| 11 | "no coding required for simple skills" | 17개 중 **14개가 코드 0줄.** 코드는 폴더형 3개의 `scripts/`에만 | 기획자도 고칠 수 있다 |
| 12 | Cowork "Record a skill"로 녹화 기반 제작 | 우리는 전부 직접 작성. 녹화 제작 0건 | 4주차 기획자 트랙의 대안 경로 |
| 13 | 공식 문서 스킬 4종. docx Read는 `pandoc -t markdown`, xlsx·pptx는 `markitdown`. **HWP 없음** | `doc2md-ingest`(D1도 pandoc) · `pdf2md-ingest` · `hwp2md-ingest`. Excel·PPT는 우리에게 없다 | Anthropic이 pandoc 쓰는 자리에 우리도 pandoc을 쓴다. HWP만 우리 몫이다 |
| 14 | 오픈 표준. Cursor·Copilot·Gemini CLI·Codex가 같은 형식을 읽는다 | 확장 필드 미사용. `.claude/skills/` 3개는 폴더째 이식 가능 (`origin:`은 표준 밖) | 우리 변환 스킬은 Claude 전용이 아니다 |
| 15 | 신뢰할 수 있는 출처만. 설치는 소프트웨어 설치와 같은 무게 | 전부 자체 제작 또는 `origin: lemoncloud-io/knowledge@<sha>` 명시. 외부 marketplace 스킬 0건 | 밖에서 받은 스킬은 그 줄이 비어 있다 |

### 2주차 → 4주차 연결

4주차 주제가 "스킬 제작"이다. 2주차의 스킬 파트는 4주차의 사전 지식을 깔는 자리다. 연결점은 셋이다.

1. **읽는 법 → 쓰는 법.** 2주차에서 `hwp2md-ingest`의 description(560 B)이 왜 그렇게 생겼는지 읽는다.
   4주차에서 같은 형식으로 직접 쓴다. 근거는 항목 5(공식 작성 best practice).
2. **결함 실물이 과제가 된다.** `ollama-local-models.md`에 프론트매터를 붙이는 것이 4주차 실습
   과제로 그대로 쓰인다. 2주차에서 "왜 안 걸리는가"를 진단하고 4주차에서 고친다. 근거는 항목 6.
3. **평가 도구가 있다.** `skill-creator` 플러그인이 should-trigger / should-not-trigger 프롬프트를
   생성해 발동률을 측정하고 description 수정안을 제안한다
   (`/plugin install skill-creator@claude-plugins-official`). 4주차 실습의 검증 단계로 쓴다.
   근거는 항목 6의 출처 문서 § Run evals with skill-creator.

### 실측 재현 명령

이 문서의 수치를 다시 확인할 때 쓴다. `projects/second-brain/config/skills/`에서 실행한다.

```bash
# 전량
find . -type f | wc -l && find . -type f -exec cat {} + | wc -c
# 2단 진입점 17개
for f in *.md */SKILL.md; do printf "%7d  %s
" $(wc -c < "$f") "$f"; done | sort -rn
# 3단 번들 8개
find */ -type f ! -name "SKILL.md" | while read f; do printf "%7d  %s
" $(wc -c < "$f") "$f"; done
# 프론트매터 결함 탐지
for f in *.md */SKILL.md; do [ "$(head -1 "$f")" = "---" ] || echo "프론트매터 없음: $f"; done
# 자동 발견 경로에 실제로 올라간 스킬
ls -la ../../../../.claude/skills/
```
