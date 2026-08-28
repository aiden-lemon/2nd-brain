# 04 사내 자료 위키화 — 외부 근거 자료

수집일: 2026-08-28. 수집 방식: WebSearch·WebFetch로 원문 확인. 원문을 열지 못한 항목은 그렇게 적었다.

수집 건수: 15건. 원문 확인 실패 1건(McKinsey 2012), 근거 미확보 3건(§ 확인 못 한 것).

각 항목의 `쓸 곳`은 두 줄이다. 첫 줄은 교육 자료에서 이 근거가 뒷받침할 주장, 둘째 줄(**우리 vault 대응**)은 그 주장이 착지할 이 저장소의 파일·경로·수치다. vault 실측값의 출처는 2026-08-27 이 저장소 실행 결과다.

---

## 1. 왜 마크다운이냐

### LLM에 긴 문서를 넣을 때 Anthropic이 권고하는 구조
- **출처**: Prompting best practices — Claude Platform Docs — https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
- **날짜**: 최종 갱신일 미표기. Claude Fable 5·Opus 5·Sonnet 5를 다루므로 2026년 문서다.
- **핵심 인용**:
  - "When working with large documents or data-rich inputs (20k+ tokens), structure your prompt carefully to get the best results"
  - "**Put longform data at the top:** Place your long documents and inputs near the top of your prompt, above your query, instructions, and examples. This improves performance across all models."
  - "**Structure document content and metadata with XML tags:** When using multiple documents, wrap each document in `<document>` tags with `<document_content>` and `<source>` (and other metadata) subtags for clarity."
  - (한국어 요약: 2만 토큰 이상 입력은 구조를 잡아야 한다. 긴 문서는 프롬프트 위쪽에 두고, 문서마다 `<document>`·`<source>` 태그로 감싼다.)
- **수치**: "Queries at the end can improve response quality by up to 30 percent in tests, especially with complex, multidocument inputs." 원문 확인함. 단 자체 테스트이고 방법론은 공개되지 않았다.
- **쓸 곳**: 출처·제목 같은 메타데이터를 본문과 분리해 두면 LLM이 덜 헷갈린다.
  **우리 vault 대응** — 이게 `wiki/` 노트의 frontmatter가 존재하는 이유다. 변환 스킬이 붙이는 `source:`·`converted_by:` 필드(`hwp2md-ingest/SKILL.md` § 산출 규격)가 Anthropic이 말하는 `<source>` 서브태그와 같은 역할을 한다. 그리고 `wiki/INDEX.md`가 "긴 문서를 위쪽에" 두는 대신 **색인을 먼저 읽게** 하는 우리 방식이다.
- **신뢰도**: 1차 출처

### 마크다운 자체가 정답이라는 근거는 Anthropic 문서에 없다
- **출처**: Effective context engineering for AI agents — Anthropic Engineering — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **날짜**: 2025-09-29
- **핵심 인용**: "using techniques like XML tagging or Markdown headers to delineate these sections, although the exact formatting of prompts is likely becoming less important as models become more capable." / "you should be striving for the minimal set of information that fully outlines your expected behavior."
  - (한국어 요약: XML 태그든 마크다운 헤딩이든 섹션을 나누라고만 한다. 정확한 포맷은 모델이 좋아지면서 덜 중요해지고 있다고 명시한다.)
- **쓸 곳**: "마크다운이 LLM 전용 포맷이라 좋다"는 주장은 근거가 약하다. 실제 이유는 ① 사람이 diff·grep·git으로 다룰 수 있고 ② 바이너리가 아니라 텍스트라 파싱 단계가 없다는 것이다.
  **우리 vault 대응** — 우리가 마크다운을 쓰는 이유도 모델 성능이 아니다. `raw/`가 append-only 계약(`docs/raw-layout.md`)을 지킬 수 있는 건 git이 텍스트를 다룰 수 있기 때문이다. `.hwpx` 원본은 `raw/hwp/`에 바이너리로 남고, git이 의미 있는 diff를 낼 수 있는 건 `wiki/`의 마크다운뿐이다. 교육에서는 "LLM을 위해서"가 아니라 "이력을 남기기 위해서"로 설명한다.
- **신뢰도**: 1차 출처

### 같은 표를 어떤 포맷으로 직렬화하느냐에 따라 토큰이 최대 3배 차이 난다
- **출처**: TQA-Bench: Evaluating LLMs for Multi-Table Question Answering (Qiu, Li, Peng, He, Yuan, Wang) — https://arxiv.org/abs/2411.19504 (본문 https://arxiv.org/html/2411.19504v2)
- **날짜**: 2024-11 (arXiv preprint, v2)
- **핵심 인용**: "CSV is the most token-efficient format, while HTML requires nearly three times more tokens."
- **수치**: TABLE VII, 같은 데이터베이스를 4개 포맷으로 직렬화한 토큰 수. 원문 확인함.

  | 포맷 | 8K | 16K | 32K | 64K |
  |---|---|---|---|---|
  | Markdown | 5.40×10³ | 1.04×10⁴ | 2.02×10⁴ | 4.17×10⁴ |
  | CSV | 3.73×10³ | 7.24×10³ | 1.42×10⁴ | 2.93×10⁴ |
  | JSON | 5.75×10³ | 1.12×10⁴ | 2.19×10⁴ | 4.54×10⁴ |
  | HTML | 1.05×10⁴ | 2.02×10⁴ | 3.92×10⁴ | 8.16×10⁴ |

  마크다운은 JSON보다 약 6~8% 적고, HTML의 약 절반이다. CSV가 가장 적다.
- **쓸 곳**: "포맷을 바꾸면 같은 내용이 더 싸진다"의 유일한 정량 근거. 단 이 논문은 표 데이터 기준이고 산문은 다루지 않는다. 마크다운이 최소가 아니라는 점도 함께 말한다.
  **우리 vault 대응** — 실습 샘플의 표가 이 논문이 재는 대상이다. `점검-결과-보고.hwpx`(9,243 B)는 표 1개·403자이고, H1이 그 표를 **마크다운 표로 재구성**했다(2026-08-27 실측). `설비-점검-절차.docx`(39,669 B)도 표 1개다. 원본 바이너리 크기 대비 마크다운 산출물의 토큰 수를 실습 중에 직접 세어 보여주면 이 표가 근거가 된다.
- **신뢰도**: 1차 출처(단 preprint, 피어리뷰 미확인)

### PDF를 원본 그대로 넣으면 토큰이 몇 배로 든다
- **출처**: PDF support — Claude Platform Docs — https://platform.claude.com/docs/en/build-with-claude/pdf-support
- **날짜**: 최종 갱신일 미표기
- **핵심 인용**:
  - "The system converts each page of the document into an image. The text from each page is extracted and provided alongside each page's image."
  - "Dense PDFs (many small-font pages, complex tables, or heavy graphics) can fill the context window before reaching the page limit."
  - (한국어 요약: PDF는 페이지마다 이미지로 변환된 뒤 추출 텍스트와 함께 들어간다. 밀도 높은 PDF는 페이지 한도 전에 컨텍스트를 다 쓴다.)
- **수치**: Amazon Bedrock Converse API 두 모드 비교. "Uses approximately 1,000 tokens for a 3-page PDF"(텍스트 추출만) 대 "Uses approximately 7,000 tokens for a 3-page PDF"(페이지를 이미지로도 처리). 3페이지 기준 약 7배. 원문 확인함. 단 이 수치는 Bedrock Converse API 문맥이고, Messages API 전체에 그대로 적용된다고 문서가 말하지는 않는다.
- **제약**: 요청당 최대 32MB, 최대 600페이지(컨텍스트가 1M 미만이면 100페이지).
- **쓸 곳**: "PDF를 그냥 던지지 말고 마크다운으로 바꿔라"의 가장 실무적인 근거. 비용이 줄고 페이지 한도에 걸리지 않는다.
  **우리 vault 대응** — `pdf2md-ingest`의 S2(텍스트 추출)와 S4(Claude 비전 전사) 분기가 정확히 이 1,000 대 7,000의 대비다. 그리고 이 분기가 자동이 아니라 **페이지당 300자 기준의 판정**을 거치는 이유이기도 하다. `안전-교육-자료.pdf`는 499자/페이지라 S2로 가고, `점검-기록지-스캔.pdf`는 0자라 S4로 간다. 즉 우리 파이프라인은 "비싼 경로를 쓸 문서"를 먼저 골라낸다.
- **신뢰도**: 1차 출처

---

## 2. 문서 포맷 변환 도구 실태

### pandoc — 지원 입력 포맷과 손실 범위
- **출처**: Pandoc User's Guide (John MacFarlane) — https://pandoc.org/MANUAL.html · https://pandoc.org/
- **날짜**: 매뉴얼 표기 2026-07-21. 최신 릴리스는 3.10(3.9는 2026-02).
- **핵심 인용**:
  - "Because pandoc's intermediate representation of a document is less expressive than many of the formats it converts between, one should not expect perfect conversions between every format and every other."
  - "conversions from formats more expressive than pandoc's Markdown can be expected to be lossy"
  - (한국어 요약: pandoc의 중간 표현이 원본 포맷보다 표현력이 낮다. 완벽한 변환을 기대하면 안 되고, 마크다운보다 표현력 높은 포맷에서 오는 변환은 손실이 있다.)
- **수치**: `-f/--from` 입력 포맷 목록에 docx, odt, epub, html, pptx, xlsx, rtf, latex 등이 있다. **PDF와 HWP/HWPX는 입력 포맷 목록에 없다.** 원문 확인함.
- **라이선스·설치**: GPL. "Pandoc is free software released under the GPL."
- **쓸 곳**: docx는 pandoc 한 줄로 마크다운이 된다. 표·헤딩 같은 구조는 살고 여백 같은 서식은 죽는다. PDF와 한글 문서는 pandoc이 못 읽으므로 별도 경로가 필요하다.
  **우리 vault 대응** — 이 한 문장이 우리 변환 스킬이 3개로 갈라진 이유 전부다. pandoc이 docx를 읽으므로 `doc2md-ingest`의 D1은 pandoc 직행이다. pandoc이 hwpx와 pdf를 못 읽으므로 `hwp2md-ingest`(H1)와 `pdf2md-ingest`(S2)가 따로 있다. **그리고 이 머신에는 pandoc이 설치돼 있지 않아 `설비-점검-절차.docx`는 게이트에서 멈춘다.** 실습 순서를 `.hwpx` 먼저로 짜야 하는 실측 근거다.
- **신뢰도**: 1차 출처

### 레거시 .doc과 PDF — 사전 변환 및 OCR 경로
- **출처**:
  - Starting LibreOffice Software With Parameters — https://help.libreoffice.org/master/en-US/text/shared/guide/start_parameters.html
  - PyMuPDF4LLM — PyMuPDF documentation — https://pymupdf.readthedocs.io/en/latest/pymupdf4llm/index.html · PyPI 메타데이터 https://pypi.org/pypi/pymupdf4llm/json
  - tesseract-ocr/tessdata — https://github.com/tesseract-ocr/tessdata
- **날짜**: LibreOffice 헬프 최종 갱신일 미표기. pymupdf4llm 1.28.2. tessdata 릴리스일 미확인.
- **핵심 인용**:
  - LibreOffice: "The `--convert-to` option is used for batch converting files (implies `--headless`)." 구문은 `soffice --convert-to OutputFileExtension[:OutputFilterName[:OutputFilterParams]] [--outdir output_dir]`.
  - PyMuPDF4LLM: "PyMuPDF4LLM includes built-in OCR support for scanned documents and image-based PDFs. By default, OCR runs automatically when needed — you don't have to opt in." / "PyMuPDF4LLM applies OCR only when it is genuinely required to obtain the complete text of a PDF page."
  - (한국어 요약: 레거시 .doc은 LibreOffice headless로 docx·odf로 먼저 바꾼 뒤 pandoc에 넘긴다. 스캔 PDF는 텍스트 레이어가 없어 OCR이 필요하고, pymupdf4llm은 필요한 페이지에만 OCR을 돌린다.)
- **라이선스·설치**: PyMuPDF·pymupdf4llm은 "Dual Licensed - GNU AFFERO GPL 3.0 or Artifex Commercial License"(PyPI 메타데이터 확인). **AGPL이므로 사내 서비스에 넣을 때 라이선스 검토가 필요하다.** Python 3.10+. Tesseract와 `kor.traineddata`는 Apache-2.0.
- **쓸 곳**: 포맷별로 경로가 다르다. 그리고 무료 도구라도 라이선스는 확인해야 한다(pandoc GPL, PyMuPDF AGPL, Tesseract Apache-2.0).
  **우리 vault 대응** — `doc2md-ingest`의 D2a(LibreOffice headless → docx → pandoc)가 이 문서의 `--convert-to`를 그대로 쓴다. D2b(macOS `textutil`)는 내장이지만 **구조·이미지가 손실**되고, D2c(Word COM)는 **Windows 실기기 미검증**이다. 즉 우리 스킬의 경로 우선순위 D2a > D2b > D2c가 근거 있는 순서다. pymupdf4llm의 AGPL은 `pdf2md-ingest`가 사내 서비스로 승격될 때 검토 대상이 된다 — 교육에서 이 지점을 짚는다.
- **신뢰도**: 1차 출처(라이선스는 PyPI·GitHub 메타데이터 직접 확인)

### 변환 아티팩트는 자동으로 걸러지지 않는다 — 구조 오류가 검색을 망친다
- **출처**:
  - OCR Hinders RAG: Evaluating the Cascading Impact of OCR on Retrieval-Augmented Generation (Zhang 외 9인) — https://arxiv.org/abs/2412.02592 · 본문 https://arxiv.org/html/2412.02592v4 · 벤치마크 https://github.com/opendatalab/OHR-Bench
  - When Good OCR Is Not Enough: Benchmarking OCR Robustness for Retrieval-Augmented Generation (Sun 외) — https://aclanthology.org/2026.acl-industry.60/
- **날짜**: OHR-Bench 2024-12-03 제출, 2025-08-30 v4, **ICCV 2025 게재**. ACL 2026 Industry Track.
- **핵심 인용**:
  - "high OCR accuracy does not necessarily translate into strong downstream RAG performance: structural and semantic errors can cause substantial retrieval failures even when WER/CER remains low." (ACL 2026)
  - OHR-Bench는 잡음을 두 종류로 나눈다. **Semantic Noise** — "stems from OCR prediction errors that alter the semantic meaning of parsed content, misleading retrievers and LLMs away from correct information." **Formatting Noise** — "arises from stylistic commands and inconsistent structured data representations across Markdown, LaTeX, and HTML formats that don't affect semantics but complicate information integration."
  - (한국어 요약: 글자 정확도가 높아도 구조·의미 오류가 있으면 검색이 실패한다. 잡음은 의미를 바꾸는 것과 서식만 어긋나는 것으로 나뉜다.)
- **수치**: 최선의 OCR 솔루션도 정답 대비 전체 평가에서 **14%(F1 5점) 하락**. Semantic Noise 비율 0.6 이상에서는 대부분의 retriever·LLM에서 성능이 **약 50% 하락**하고, 특히 읽기 순서 관련 질문이 가장 크게 무너진다. 원문 확인함.
- **쓸 곳**: **"변환은 자동이지만 검수는 자동이 아니다"의 근거.** 글자가 다 나왔는지만 보면 안 된다. 순서가 뒤섞이거나 머리말이 본문에 섞이는 구조 오류가 검색 단계에서 훨씬 크게 터진다.
  **우리 vault 대응** — 2026-08-27 이 머신에서 `uv run hwp2md-ingest/scripts/h1-extract.py samples/점검-결과-보고.hwpx`를 실행한 결과가 `chars=403 tables=1 images=0 encrypted=False`(0.465s)로 정상이었다. 그런데 산출물 첫 줄이 이렇게 나왔다 — `제3공장 설비팀 — 대외비 아님 (교육용 샘플)압축기 정기 점검 결과 보고제3공장 설비팀 — 대외비 아님 (교육용 샘플)`. **머리말이 본문 제목과 붙어 두 번 들어갔다.** 글자 수 통계로는 잡히지 않는 정확히 이 논문의 Formatting Noise다. 이게 그대로 `wiki/`에 들어가면 검색 인덱스가 오염된다. 실습에서 이 첫 줄을 그대로 보여주고, 그래서 `raw/`(원본 보관)와 `wiki/`(정제 노트)를 왜 나눴는지로 이어간다 — `raw/`가 남아 있으면 잘못 변환된 노트를 버리고 다시 만들 수 있다.
- **신뢰도**: 1차 출처(ICCV 2025·ACL 2026 게재 논문)

---

## 3. HWPX 포맷의 공개 상태

### HWPX는 국가표준 KS X 6101(OWPML)을 따르는 개방형 포맷이다
- **출처**:
  - 한/글 문서 파일 형식: HWPX 포맷 구조 살펴보기 — 한컴테크 — https://tech.hancom.com/hwpxformat/
  - KS X 6101 개방형 워드프로세서 마크업 언어(OWPML) 문서 구조 — 국가기술표준원 — https://standard.go.kr/KSCI/standardIntro/getStandardSearchView.do?menuId=503&topMenuId=502&ksNo=KSX6101
- **날짜**: 한컴테크 글 2025-02-26. KS X 6101 제정 2011-12-30, 최근 개정 2024-10-30.
- **핵심 인용**:
  - "HWPX는 국가 표준(KS X 6101)인 OWPML을 따르는 개방형 문서 포맷입니다."
  - "HWPX는 ZIP 파일 구조를 가진 XML 기반 포맷이며, 관련된 파일들이 동일 디렉터리에 위치하도록 구성되어 있습니다."
  - "바이너리 포맷보다 개방성과 기술적 해석이 용이한 XML 기반의 패키지 포맷으로 구성되었습니다."
  - "주요 파일들이 XML이기 때문에 데이터 추출이 용이합니다."
- **쓸 곳**: 한컴오피스 없이 HWPX를 파싱할 수 있는 이유. 확장자를 .zip으로 바꾸면 내부 XML이 그대로 보인다.
  **우리 vault 대응** — **이 근거가 실습 순서를 결정한다.** HWPX가 ZIP+XML이라 순수 Python으로 읽히므로, `hwp2md-ingest`의 H1은 `uv`만 있으면 돈다(`SKILL.md` § 사전 요구 — "한컴오피스·JVM은 필요 없다"). 이 머신에는 pandoc·poppler가 없어 `.docx`(D1)와 `.pdf`(S2)는 게이트에서 멈추지만 **`.hwpx`(H1)는 설치 없이 즉시 돌았다**(0.465s, 2026-08-27 실측). 그래서 실습은 `점검-결과-보고.hwpx`로 시작한다. 한국 수강자에게 "가장 어려울 것 같던 한글 문서가 가장 먼저 돌아간다"는 순서 자체가 설득력이 된다.
- **신뢰도**: 1차 출처(벤더 공식 기술 블로그 + 국가표준 등록 정보)

### 한컴오피스 없이 순수 Python으로 HWP·HWPX를 읽는다
- **출처**: hwp-hwpx-parser 1.0.0 — PyPI — https://pypi.org/project/hwp-hwpx-parser/ · 저장소 https://github.com/KimDaehyeon6873/hwp-hwpx-parser
- **날짜**: 버전 1.0.0. 배포일은 별도 확인 안 함.
- **핵심 인용**: PyPI summary — "순수 Python HWP/HWPX 파서 - JVM 없이 텍스트, 표, 각주, 메모 추출"
- **수치**: `license_expression = Apache-2.0`, `requires_python = >=3.8`, 런타임 의존성은 `olefile>=0.46`과 `python-docx>=1.0.0`뿐. PyPI JSON API로 직접 확인함.
- **쓸 곳**: "한글 문서라서 못 한다"는 반론을 막는 근거. 한컴오피스도 JVM도 필요 없다.
  **우리 vault 대응** — `hwp2md-ingest/scripts/h1-extract.py`가 이 패키지를 쓴다. 2026-08-27 실행 로그의 `Installed 5 packages in 9ms`가 의존성이 얕다는 PyPI 메타데이터와 일치한다. 그리고 `SKILL.md`의 밀도 임계 `chars ≥ 300 → H1 채택`에 샘플이 403자로 걸려 H1이 채택됐다. 임계값과 실측값을 나란히 보여주면 판정 로직이 설명된다.
- **신뢰도**: 1차 출처(패키지 메타데이터)
- **주의**: 버전 1.0.0에 단독 관리자 저장소다. 사내 파이프라인에 넣기 전 실제 문서로 스모크 테스트를 돌려야 한다. 이 vault에는 2026-08-21 로컬 스모크 실측 근거가 `hwp2md-ingest/SKILL.md` § 근거·주의에 이미 있다.

### 한국 공공기관은 hwp 첨부를 제한하고 hwpx로 전환하는 중이다
- **출처**: 정부, AI가 못 읽는 hwp 파일 막는다…개방형 hwpx로 전환 — 아시아경제 — https://www.asiae.co.kr/article/2026042410101096553 (보조: 경향신문 https://www.khan.co.kr/article/202605121345001)
- **날짜**: 2026-04-24 입력, 2026-04-26 수정
- **핵심 인용**: "hwp 파일은 개방형 포맷인 hwpx와 달리 AI가 내부 정보를 학습하기 어려운 폐쇄형 구조를 지니고 있다" / 임문영 국가인공지능전략위 부위원장 — "이번 조치를 기점으로 AI 시대 공공부문 데이터 혁신을 위한 작지만 큰 속도감 있는 변화를 관계 부처와의 협력을 통해 확실히 실행해 나가겠다"
- **수치**: 중앙부처 온나라시스템은 2022년부터 hwpx 의무화. 지방정부 온나라시스템은 2026-05-18부터 확대. 공직자통합메일은 5월부터 권장 안내, 10월부터 hwp 첨부 제한. 정책 주체는 국가인공지능전략위원회·행정안전부·문화체육관광부.
- **쓸 곳**: 이건 우리만의 취향이 아니라 정부도 같은 방향으로 간다.
  **우리 vault 대응** — 외부 업체 교육에서 "왜 굳이 변환하느냐"는 저항을 정면으로 받는 카드다. 공공 납품이 있는 조직이면 `hwp2md-ingest`의 존재가 선택이 아니라 대비다. 다만 우리 스킬은 `.hwp`(바이너리 v5)와 `.hwpx` 둘 다 H1으로 처리하므로, 정부 정책과 무관하게 기존 `.hwp` 자산도 그대로 쓸 수 있다는 점을 함께 말한다.
- **신뢰도**: 2차 인용. **행정안전부 원 보도자료를 찾지 못했다.** 확인된 1차 자료는 2022-08-29 행정안전부 보도자료 "중앙부처, 행정문서 생산 시 개방형 서식 등 의무화 추진"(https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardArticle.do?bbsId=BBSMSTR_000000000008&nttId=94424)이며, 여기에 "행정안전부(장관 이상민)는 정부에서 생산한 행정문서의 데이터 활용을 강화하는 방안을 모든 중앙부처로 확대한다"가 있다. 2026년 일정은 언론 보도만 확인했다.

### "HWP라서 AI가 못 읽는다"는 표현은 부정확하다
- **출처**: HWP/HWPX 포맷은 AI가 인식하기 어렵다는데 사실입니까? — 한컴 FAQ — https://www.hancom.com/support/faqCenter/faq/detail/3135
- **날짜**: 미표기
- **핵심 인용**: "'HWP라서 AI가 읽기 어렵다'는 건 사실과 다릅니다. HWP는 'DOC, PDF'와 같은 '바이너리 형식 문서 포맷으로 AI가 바로 읽기 어렵다'는 게 정확한 표현입니다."
- **쓸 곳**: 문제는 한글 파일이 아니라 **바이너리라는 사실**이다. doc·pdf·xls도 같은 문제를 갖는다. 이 한 줄이 "우리 회사는 한글을 안 쓰니 상관없다"는 오해를 막는다.
  **우리 vault 대응** — 우리 스킬 3종이 서로 다른 도구를 쓰면서도 하는 일은 같다는 걸 설명하는 프레이밍이다. `doc2md-ingest`·`hwp2md-ingest`·`pdf2md-ingest`가 모두 "바이너리 → 마크다운 → `Clippings/`"로 끝나고, 그 뒤는 `vault-ingest`가 포맷과 무관하게 이어받는다. 즉 파이프라인의 갈라짐은 앞단 3개뿐이다.
- **신뢰도**: 1차 출처(벤더 공식 FAQ). 단 벤더는 이해관계자이므로 그렇게 표기한다.

---

## 4. 파편화된 지식의 비용

### McKinsey 2012 — 업무 시간의 19%를 정보 추적에 쓴다
- **출처**: The social economy: Unlocking value and productivity through social technologies — McKinsey Global Institute — https://www.mckinsey.com/industries/technology-media-and-telecommunications/our-insights/the-social-economy
- **날짜**: 2012-07
- **핵심 인용**: 널리 인용되는 문장은 interaction worker가 업무 시간의 28%를 이메일에, 19%를 정보 추적에, 14%를 동료와의 협업에 쓴다는 것이다.
- **수치**: 이메일 28%, 내부 정보 검색·동료 추적 19%, 협업 14%. 사회적 기술 도입 시 검색 시간을 최대 35% 줄여 주당 약 6%의 시간을 되돌릴 수 있다. interaction worker 생산성 20~25% 향상 여지.
- **원문 확인 여부**: **확인 실패.** mckinsey.com 본문과 executive summary PDF가 모두 타임아웃으로 열리지 않았다. archive.org 사본은 1MB에서 잘려 텍스트 추출이 불가능했다. 검색 결과 스니펫과 다수의 2차 인용이 서로 일치하나 원문 문장을 직접 보지 못했다.
- **쓸 곳**: "파편화된 문서는 시간을 먹는다"의 대표 수치. 쓸 경우 "McKinsey Global Institute, 2012" 출처와 조사 연도를 명시한다.
  **우리 vault 대응** — 우리 vault에는 이 비용을 재는 자체 수치가 없다. 있는 건 파이프라인의 **처리 비용** 실측뿐이다(`.hwpx` 403자 변환 0.465s, 설치 0건). 교육에서는 McKinsey 수치로 문제를 열고, 해결 쪽은 남의 수치가 아니라 이 실측으로 닫는다. "찾는 데 19%를 쓴다"와 "변환은 0.5초에 끝난다"의 대비가 슬라이드 한 장이 된다.
- **신뢰도**: **2차 인용, 원문 미확인.** 2012년 조사이므로 슬랙·노션·사내 검색이 보급된 2026년에 그대로 적용된다고 말하지 않는다.

### 이 계열 수치는 대부분 원 출처 추적이 안 된다
- **출처**: "Time spent searching" – a chronology of the myth and some recent research (Martin White) — https://www.linkedin.com/pulse/time-spent-searching-chronology-myth-some-recent-research-white
- **날짜**: 2020-05-26
- **핵심 인용**: 저자는 IDC의 "하루 2.5시간" 추정이 방법론 없이 나온 것이라고 본다. "This makes it clear that it is an estimate based on the ubiquity of intranets." IDC가 근거로 든 Kit Sims Taylor 1998 논문을 아카이브에서 찾아 확인한 결과 — "The statement related to time spent searching for information is not in the text of the paper, nor is it cited as a source."
  - (한국어 요약: 검색 시간 통계의 계보를 거슬러 올라가면 원 논문에 그 문장이 없다.)
- **보조 출처**: Document Search Times: How Long Does it Really Take to Find a File? — M-Files — https://m-files.com/resources/en-hub/rt-main-blog-en/how-long-does-it-actually-take-to-find-a-document-dissecting-the-many-stats-out-there — "It's worth mentioning that the above statistics are nowhere near homogenous in their methodology, a point made very poignantly by Martin White in his LinkedIn Pulse article." 여기서 정리한 연표: 2001 IDC 하루 2.5시간 / 2003 IDC 주 5시간 이상 / 2011 IDC 주 8.8시간 / 2012 McKinsey 하루 1.8시간 / 2012 IDC 주 5시간 / 2013 Gartner 문서당 18분.
- **쓸 곳**: **교육 자료에서 수치를 쓰는 방식 자체의 근거.** "직원이 하루 2.5시간을 검색에 쓴다" 같은 문장은 쓰지 않는다. 대신 원 출처 추적이 안 되는 수치가 많다고 말하고, 수강자가 자기 조직에서 재도록 유도한다.
  **우리 vault 대응** — 이 태도가 우리 vault의 실측 문화와 같다. `hwp2md-ingest/SKILL.md`는 판정 임계를 "2026-08-21 실측"으로 근거를 달고, `pdf2md-ingest`는 `projects/pdf2md-bench/outputs/verdict-report.md`를 근거로 든다. 교육에서 "우리도 남의 수치를 안 쓰고 이렇게 재서 적어 뒀다"고 스킬 문서를 실제로 열어 보여준다.
- **신뢰도**: 1차 출처(저자 본인의 추적 기록). Martin White는 정보검색·인트라넷 분야 저자다.

---

## 5. RAG / 문서 기반 AI 검색의 한계

이 절의 근거는 모두 같은 대비를 위한 것이다 — **원본을 그대로 검색에 던지는 방식** 대 **정제 노트 계층을 따로 두는 방식**. 우리 vault의 `raw/`(append-only 원본)와 `wiki/`(LLM이 읽는 정제 노트) 2계층 분리가 여기에 착지한다.

### chunking은 문맥을 잘라 낸다
- **출처**: Introducing Contextual Retrieval — Anthropic — https://www.anthropic.com/news/contextual-retrieval
- **날짜**: 2024-09-19
- **핵심 인용**: "In traditional RAG, documents are typically split into smaller chunks for efficient retrieval. While this approach works well for many applications, it can lead to problems when individual chunks lack sufficient context." 예시로 "The company's revenue grew by 3% over the previous quarter."라는 청크만 남으면 어느 회사·어느 분기인지 알 수 없다.
- **수치**: top-20 청크 검색 실패율 — 기본 5.7% → Contextual Embeddings만 적용 3.7%(35% 감소) → Contextual BM25 병용 2.9%(49% 감소) → reranking 추가 1.9%(67% 감소). 원문 확인함.
- **쓸 곳**: "문서를 그냥 벡터DB에 밀어 넣으면 안 된다"의 정량 근거. Anthropic이 청크마다 문맥을 붙여 해결한 문제를, 위키화는 **문서 단위로 미리** 해결한다.
  **우리 vault 대응** — `wiki/` 노트마다 frontmatter에 `source:`가 붙는 이유가 이것이다. `raw/` 원본을 그냥 검색에 던지면 "압축기 정기 점검 결과 보고"의 표 한 줄만 잘려 나와 어느 설비·어느 날짜인지 알 수 없다. 정제 노트는 제목·출처·요약을 갖고 있어 잘려도 문맥이 남는다. 그리고 provenance 규약이 `"raw/<source-file-name>.md"` 문자열인 것도 같은 목적이다 — 청크에서 원본으로 되돌아갈 수 있다.
- **신뢰도**: 1차 출처(Anthropic 자체 실험, 방법론 공개)

### 긴 컨텍스트 중간의 정보는 잘 안 쓰인다
- **출처**: Lost in the Middle: How Language Models Use Long Contexts (Liu, Lin, Hewitt, Paranjape, Bevilacqua, Petroni, Liang) — https://arxiv.org/abs/2307.03172
- **날짜**: 2023-07-06 제출, 2023-11-20 v3
- **핵심 인용**: "we observe that performance is often highest when relevant information occurs at the beginning or end of the input context, and significantly degrades when models must access relevant information in the middle of long contexts, even for explicitly long-context models." / "performance substantially decreases as the input context grows longer"
  - (한국어 요약: 관련 정보가 입력의 앞이나 끝에 있을 때 성능이 가장 좋고, 중간에 있으면 크게 떨어진다. 긴 컨텍스트 전용 모델도 그렇다.)
- **쓸 곳**: "문서를 다 넣으면 되지 않느냐"는 반론에 대한 답. 요약·색인 계층이 필요한 이유다. 다만 2023년 논문이라 최신 모델에 그대로 적용된다고 단정하지 않는다.
  **우리 vault 대응** — `wiki/INDEX.md`(색인)와 `wiki/VAULT_MEMORY.md`(현재 상태 포인터)가 존재하는 이유다. `VAULT_MEMORY.md`가 **8KB 상한**을 계약으로 갖는 것(`VAULT_RULES.md` § Core Rules)도 같은 논리다 — 매 세션 로드되는 문서에 실행 서사를 계속 붙이면 정작 중요한 포인터가 중간에 묻힌다. 상한이 있으니 색인은 색인으로 남는다.
- **신뢰도**: 1차 출처(arXiv). 학술지 게재 여부는 확인하지 않았다.

---

## 6. 개인정보·기밀 처리

이 절의 근거는 전부 `hwp2md-ingest`·`doc2md-ingest`·`pdf2md-ingest` 공통의 **게이트 0 — 커밋 가능성 확인**에 착지한다. 스킬은 변환 전에 "이 문서는 팀 공유 vault에 커밋 가능한가"를 묻고, 아니면 vault 밖 변환 모드로 간다. 아래 근거들이 그 질문에 답할 재료다.

### 상용 조건에서는 입력·출력을 학습에 쓰지 않는다
- **출처**:
  - Commercial Terms of Service — Anthropic — https://www.anthropic.com/legal/commercial-terms
  - Is my data used for model training? — Anthropic Privacy Center — https://privacy.claude.com/en/articles/7996868-is-my-data-used-for-model-training
  - Data usage — Claude Code Docs — https://code.claude.com/docs/en/data-usage
- **날짜**: 상용 약관 발효일 2025-06-17. Privacy Center 문서 최종 갱신 "over a week ago"(정확한 날짜 미표기).
- **핵심 인용**:
  - 약관 — "Customer (a) retains all rights to its Inputs, and (b) owns its Outputs." / "Anthropic may not train models on Customer Content from Services." / "Customer Content is Customer's Confidential Information"
  - Privacy Center — "By default, we will not use your inputs or outputs from our commercial products (e.g. Claude for Work, Anthropic API, Claude Gov, etc.) to train our models." / "If you explicitly report feedback or bugs to us (e.g. via our thumbs up/down feedback button), or otherwise choose to allow us to use your data, then we may use your chats and coding sessions to train our models."
  - Claude Code 문서 — "**Commercial users**: (Team and Enterprise plans, API, 3rd-party platforms, and Claude Gov) maintain existing policies: Anthropic does not train generative models using code or prompts sent to Claude Code under commercial terms, unless the customer has chosen to provide their data to us for model improvement" / "**Consumer users (Free, Pro, and Max plans)**: We give you the choice to allow your data to be used to improve future Claude models. We will train new models using data from Free, Pro, and Max accounts when this setting is on (including when you use Claude Code from these accounts)."
  - (한국어 요약: 입력은 고객 소유, 출력도 고객 소유다. 상용 조건에서는 학습에 쓰지 않는다. 단 피드백을 직접 보내거나 소비자 요금제에서 설정을 켜면 예외다.)
- **쓸 곳**: "우리 회사 문서를 넣어도 되나"의 정면 답변. **핵심은 요금제 구분이다.** Team·Enterprise·API는 기본 미학습, Free·Pro·Max는 설정에 따라 학습에 쓰인다.
  **우리 vault 대응** — 게이트 0의 답이 요금제만으로 결정되지 않는다는 걸 여기서 짚는다. 학습 여부는 이 근거로 답할 수 있지만, **커밋 여부는 별개 판단**이다. 고객사 문서를 Team 플랜으로 변환하는 건 약관상 문제가 없어도, 그 결과를 팀 공유 vault의 git 이력에 영구히 남기는 건 다른 결정이다. 그래서 스킬이 학습 여부를 묻지 않고 "커밋 가능한가"를 묻는다. 이 구분이 교육의 핵심 메시지다.
- **신뢰도**: 1차 출처

### 보관 기간과 zero data retention
- **출처**: API and data retention — Claude Platform Docs — https://platform.claude.com/docs/en/manage-claude/api-and-data-retention · Data usage — Claude Code Docs — https://code.claude.com/docs/en/data-usage
- **날짜**: 최종 갱신일 미표기
- **핵심 인용**:
  - "Retained data is never used for model training without your express permission."
  - "Only what is technically necessary for the feature to work is retained. Conversation content (your prompts and Claude's outputs) is not retained by default; the exception is Covered Models, which require 30-day retention."
  - "Where a feature does not require storage of customer prompts or responses, it may be eligible for ZDR."
- **수치**: 상용 사용자 표준 보관 30일. 소비자 사용자 — 학습 허용 시 5년, 미허용 시 30일. `/feedback`·`/bug`·`/share`로 공유한 전사본은 5년. 세션 전사본 공유는 최대 6개월. Claude Code 로컬 전사본은 `~/.claude/projects/`에 평문으로 기본 30일 보관(`cleanupPeriodDays`로 조정).
- **제약**: ZDR은 Claude Enterprise 표준 플랜에 포함되지 않고 조직 단위로 별도 활성화한다. Agent skills·code execution 등 상태를 저장하는 기능은 ZDR 대상이 아니다.
- **쓸 곳**: "로그가 어디에 얼마나 남느냐"는 질문에 답한다. **로컬 평문 전사본**이 실무에서 가장 놓치기 쉬운 지점이다.
  **우리 vault 대응** — vault 밖 변환 모드로 가도 흔적이 완전히 없어지지는 않는다는 점을 정직하게 말해야 한다. `raw/`에 원본을 넣지 않고 `wiki/`에 노트를 만들지 않아도, 변환 세션의 전사본은 `~/.claude/projects/`에 평문으로 30일 남는다. 즉 게이트 0을 "vault 밖으로"로 답한 것은 **git 이력을 피한 것이지 로컬 흔적을 지운 것이 아니다.** 진짜 민감한 문서는 `cleanupPeriodDays`를 줄이거나 ZDR 조직 계정을 쓰는 별개 결정이 필요하다.
- **신뢰도**: 1차 출처

---

## 다이어그램 인벤토리

이번 회차에 내려받은 파일은 아래 2개다. `assets/`의 다른 파일은 다른 담당이 수집한 것이다.

| 파일명 | 출처 | 라이선스 | 보여줄 내용 |
|---|---|---|---|
| `assets/RAG_schema.svg` | https://commons.wikimedia.org/wiki/File:RAG_schema.svg (저자 Gknor, 2023-10-24) | CC BY-SA 4.0 | 문서를 dense embedding으로 벡터화해 저장하고, 질의를 벡터로 바꿔 cosine distance로 검색한 뒤 LLM에 문맥으로 넘기는 2단계 흐름. **"원본을 그냥 던지는 방식"의 그림**으로 쓰고, 그 옆에 우리 `Clippings/ → raw/ → wiki/` 3계층을 나란히 두어 대비시킨다. |
| `assets/RAG_diagram.svg` | https://commons.wikimedia.org/wiki/File:RAG_diagram.svg (저자 Turtlecrown, 2024-07-16) | CC BY-SA 4.0 | 외부 문서와 사용자 입력이 하나의 프롬프트로 합쳐지는 구조. 더 단순해서 도입부 슬라이드에 맞는다. |

CC BY-SA 4.0은 **저작자 표시와 동일 라이선스 배포**를 요구한다. 슬라이드에 쓸 경우 저자명·출처 URL·라이선스명을 이미지 옆에 넣는다. 사내 비공개 교육이라도 표시는 넣는 게 안전하다.

내려받지 않고 URL만 남긴 것:
- Claude Code 데이터 흐름도 — https://code.claude.com/docs/en/data-usage 내 `claude-code-data-flow.svg`. 로컬 실행·API 전송·telemetry·`/feedback` 경로를 한 장에 보여준다. § 6과 게이트 0 설명에 딱 맞지만 **Anthropic 문서 이미지의 재배포 라이선스가 명확하지 않아 내려받지 않았다.** 교육 때는 문서 링크를 띄우고 화면에서 보여주는 방식을 권한다.
- Anthropic Contextual Retrieval 도식 — https://www.anthropic.com/news/contextual-retrieval. 같은 이유로 URL만 남긴다.
- OHR-Bench 파이프라인 도식 — https://github.com/opendatalab/OHR-Bench. 저장소 라이선스와 그림의 재사용 조건을 확인하지 않아 URL만 남긴다.

---

## 예상 질문과 근거

수강자(개발자·기획자)가 실제로 물을 형태로 적었다.

1. **"우리 회사 hwp 문서를 넣으면 학습에 쓰이나?"**
   근거: 상용 약관 "Anthropic may not train models on Customer Content from Services" + Privacy Center "By default, we will not use your inputs or outputs from our commercial products". **단 Free·Pro·Max 개인 계정은 설정에 따라 학습에 쓰인다.** 답의 마무리는 게이트 0 — 학습 여부와 별개로 "팀 공유 vault의 git 이력에 남겨도 되는가"를 따로 묻는다.

2. **"한컴오피스 없어도 되나?"**
   근거: HWPX가 KS X 6101 OWPML 기반 ZIP+XML이라는 한컴테크 문서 + hwp-hwpx-parser(Apache-2.0, 순수 Python, 의존성 2개). 실측으로 닫는다 — 2026-08-27 이 머신에서 `uv run h1-extract.py`가 `Installed 5 packages in 9ms`, `chars=403 tables=1`, 0.465s로 끝났다. 한컴오피스·JVM·pandoc 모두 없이 돌았다.

3. **"스캔 문서는 어떻게 되나?"**
   근거: pymupdf4llm — "PyMuPDF4LLM applies OCR only when it is genuinely required". 우리 쪽 실측 — `점검-기록지-스캔.pdf`(109,511 B)는 텍스트가 **0자**라 S2로는 아무것도 안 나오고 S4(비전 전사)로 분기한다. `안전-교육-자료.pdf`는 499자/페이지라 S2로 간다. 페이지당 300자 임계가 이 판정을 한다.

4. **"잘못 변환된 걸 어떻게 알아채나?"**
   근거: OHR-Bench(ICCV 2025) — 최선의 OCR도 F1 14% 하락, Semantic Noise 0.6 이상에서 약 50% 하락. ACL 2026 — "structural and semantic errors can cause substantial retrieval failures even when WER/CER remains low". 우리 쪽 실물 — H1 산출물 첫 줄에 머리말이 본문 제목과 붙어 두 번 들어갔다. **글자 수 통계로는 잡히지 않았다.** 그래서 검수가 사람 몫이고, `raw/`에 원본이 남아 있어야 다시 만들 수 있다.

5. **"PDF를 그냥 올려도 Claude가 읽는데 왜 변환하나?"**
   근거: Claude PDF support — 페이지마다 이미지로 변환, 3페이지 기준 텍스트 추출 1,000 토큰 대 이미지 병용 7,000 토큰, 요청당 32MB·600페이지 한도. 우리 쪽 대응 — S2/S4 분기가 이 비용 차이를 문서별로 골라내는 장치다.

6. **"위키로 안 모으고 벡터DB에 통째로 넣으면 안 되나?"**
   근거: Anthropic contextual retrieval — 청크가 문맥을 잃는 문제, 검색 실패율 5.7% → 1.9%. 우리 쪽 대응 — `wiki/` 노트의 frontmatter `source:`와 provenance 규약 `"raw/<source-file-name>.md"`가 청크에서 원본으로 되돌아갈 길을 남긴다.

7. **"컨텍스트가 1M이면 그냥 다 넣으면 되는 거 아닌가?"**
   근거: Lost in the Middle — 중간 위치 정보 성능 저하, 입력이 길어질수록 하락. Anthropic prompting best practices — 긴 문서는 위쪽에, 질의는 끝에(테스트에서 최대 30% 향상). 우리 쪽 대응 — `wiki/INDEX.md` 색인과 `VAULT_MEMORY.md` 8KB 상한.

8. **"docx는 왜 안 돌아가나?"**
   근거: pandoc 입력 포맷 목록에 docx는 있으나 **이 머신에 pandoc이 설치돼 있지 않다**(2026-08-27 확인). poppler도 없다. `.hwpx`만 `uv`로 돌아간다. 실습을 hwpx로 시작하는 이유를 이 자리에서 설명한다.

9. **"변환하면 표나 서식이 깨지지 않나?"**
   근거: pandoc 매뉴얼 — "one should not expect perfect conversions between every format and every other", "conversions from formats more expressive than pandoc's Markdown can be expected to be lossy". 구조(헤딩·표·목록)는 남고 서식 세부는 사라진다. 우리 쪽 기대값 — `설비-점검-절차.docx`는 헤딩 6·표 1·이미지 1·316자가 기대치이고, 변환 후 이 숫자로 검수한다.

10. **"레거시 .doc 파일이 산더미인데?"**
    근거: LibreOffice `--convert-to`(headless 함의). 우리 쪽 경로 — D2a(LibreOffice, 구조 보존) > D2b(macOS `textutil`, **구조·이미지 손실**) > D2c(Word COM, **Windows 실기기 미검증**). 우선순위에 근거가 있다는 점을 보여준다.

11. **"변환 도구 라이선스는 문제 없나?"**
    근거: pandoc GPL, PyMuPDF·pymupdf4llm AGPL-3.0 또는 Artifex 상용(PyPI 메타데이터 확인), Tesseract·tessdata Apache-2.0, hwp-hwpx-parser Apache-2.0. **AGPL은 `pdf2md-ingest`를 사내 서비스로 승격할 때 검토 대상**이다.

12. **"로그가 어디에 얼마나 남나?"**
    근거: 상용 표준 30일, ZDR은 조직 단위 별도 활성화, `/feedback` 전사본 5년, 로컬 전사본 `~/.claude/projects/` 평문 30일. 우리 쪽 정직한 답 — vault 밖 변환 모드는 git 이력을 피한 것이고 로컬 흔적을 지운 것이 아니다.

13. **"경영진이 왜 이걸 해야 하냐고 물으면?"** — 근거 미확보. 위키화의 ROI를 측정한 신뢰할 만한 조사를 찾지 못했다. 대외 정당성으로 쓸 수 있는 건 § 3의 정부 정책 전환뿐이다.

14. **"우리 조직 문서에서도 같은 성공률이 나오나?"** — 근거 미확보. 우리 실측은 샘플 4종뿐이고, 조직별 문서 특성(스캔 비율·표 복잡도·서식 남용)에 따른 변환 성공률 통계는 없다. 수강자에게 자기 문서 10개로 먼저 재보라고 답한다.

---

## 우리 vault 대응 매핑

| 외부 근거 | 우리 vault의 대응 파일/경로/수치 | 교육에서 할 말 |
|---|---|---|
| Anthropic prompting best practices — 문서마다 `<source>` 태그로 감싸라 | `wiki/` 노트 frontmatter의 `source:`·`converted_by:`, `wiki/INDEX.md` | 메타데이터를 본문과 섞지 않는 게 규약이다 |
| Anthropic effective context engineering — 포맷은 덜 중요해진다 | `raw/` append-only 계약(`docs/raw-layout.md`), `raw/hwp/`엔 바이너리 원본 | 마크다운은 모델을 위해서가 아니라 이력을 위해서 쓴다 |
| TQA-Bench TABLE VII — HTML은 마크다운의 약 2배 토큰 | `점검-결과-보고.hwpx` 표 1개 → H1이 마크다운 표로 재구성 | 같은 표가 포맷에 따라 값이 달라진다 |
| Claude PDF support — 3페이지 1,000 대 7,000 토큰 | `pdf2md-ingest` S2/S4 분기, 페이지당 300자 임계 | 비싼 경로를 쓸 문서를 먼저 골라낸다 |
| pandoc 매뉴얼 — 입력 목록에 PDF·HWP 없음, 변환은 lossy | 스킬 3종 분리(`doc2md-ingest` D1 / `hwp2md-ingest` H1 / `pdf2md-ingest` S2) | 도구 하나로 안 되니 경로가 갈라졌다 |
| LibreOffice `--convert-to` | D2a > D2b(구조 손실) > D2c(Windows 미검증) | 우선순위에 근거가 있다 |
| PyMuPDF AGPL-3.0 / Tesseract Apache-2.0 | `pdf2md-ingest`의 의존성 | 무료와 자유는 다르다 |
| **OHR-Bench(ICCV 2025) — F1 14% 하락, Semantic Noise 심할 때 약 50%** | **H1 산출물 첫 줄 머리말 중복(2026-08-27 실측). `chars=403` 통계로는 안 잡혔다** | **변환은 자동이지만 검수는 자동이 아니다** |
| HWPX = KS X 6101 OWPML, ZIP+XML | `hwp2md-ingest` H1이 `uv`만으로 동작. 0.465s, 설치 5패키지 9ms | 가장 어려울 것 같던 한글 문서가 가장 먼저 돌아간다 |
| hwp-hwpx-parser Apache-2.0, 의존성 2개 | `hwp2md-ingest/scripts/h1-extract.py`, 임계 `chars ≥ 300` 대 실측 403 | 판정 로직에 실측 근거가 붙어 있다 |
| 정부 hwp 첨부 제한(2026-05~10) | `hwp2md-ingest`가 `.hwp`·`.hwpx` 둘 다 처리 | 우리 취향이 아니라 방향이다 |
| 한컴 FAQ — 문제는 한글이 아니라 바이너리 | 스킬 3종이 모두 `Clippings/`로 끝나고 뒤는 `vault-ingest`가 받는다 | 갈라지는 건 앞단뿐이다 |
| McKinsey 2012 — 정보 추적에 19% (**원문 미확인**) | 대응 수치 없음. 있는 건 처리 비용 실측 0.465s뿐 | 문제는 남의 수치로 열고, 해결은 우리 실측으로 닫는다 |
| Martin White — 검색 시간 통계는 원 출처 추적 불가 | `hwp2md-ingest/SKILL.md`의 "2026-08-21 실측", `projects/pdf2md-bench/outputs/verdict-report.md` | 우리도 남의 수치를 안 쓴다 |
| Anthropic contextual retrieval — 실패율 5.7% → 1.9% | `wiki/` frontmatter `source:`, provenance `"raw/<source-file-name>.md"` | 청크가 잘려도 원본으로 돌아갈 길을 남긴다 |
| Lost in the Middle — 중간 정보 성능 저하 | `wiki/INDEX.md`, `wiki/VAULT_MEMORY.md` **8KB 상한** | 색인이 색인으로 남게 상한을 걸었다 |
| Anthropic 상용 약관 — 학습 금지·고객 소유 | 스킬 **게이트 0 — 커밋 가능성 확인**, vault 밖 변환 모드 | 학습 여부와 커밋 여부는 다른 질문이다 |
| 로컬 전사본 `~/.claude/projects/` 평문 30일 | vault 밖 변환 모드의 한계 | git 이력을 피한 것이고 흔적을 지운 것이 아니다 |
| 이 머신에 pandoc·poppler 없음 | `.docx` D1·`.pdf` S2 게이트 중단, `.hwpx` H1만 동작 | 실습은 hwpx로 시작한다 |

---

## 확인 못 한 것

1. **McKinsey 2012 원문.** mckinsey.com 본문·executive summary PDF 모두 타임아웃. archive.org 사본은 1MB에서 잘려 텍스트 추출 실패. 수치 자체는 다수 2차 인용이 일치하지만 원문 문장을 보지 못했다. 교육 자료에 쓸 때 이 사실을 함께 적거나, 수치를 쓰지 않는 쪽을 권한다.
2. **행정안전부 2026년 hwp 첨부 제한 원 보도자료.** mois.go.kr 보도자료 목록에서 해당 건을 찾지 못했다. 확보한 1차 자료는 2022-08-29 보도자료뿐이다. 2026년 일정(5/18 지방정부 확대, 10월 첨부 제한)은 아시아경제·경향신문 보도만 확인했다.
3. **IDC 원문 리포트.** "하루 2.5시간", "주 5시간" 등의 IDC 수치는 원 리포트를 열지 못했다. Coveo가 호스팅한 IDC 백서 PDF 링크는 404다. Martin White의 추적 결과를 근거로 이 계열 수치는 쓰지 않는 편이 낫다.
4. **한국어 문서 대상 근거.** 한국어 마크다운 변환·토큰 효율을 다룬 신뢰할 만한 자료를 찾지 못했다. TQA-Bench도 OHR-Bench도 영문·중문 데이터 기준이다. 한글 문서의 변환 아티팩트 통계는 없다.
5. **HWPX 국제표준(ISO/IEC) 진행 상황.** 한컴 보도자료 제목("전자문서 국제표준 위한 첫 관문 통과")은 검색에 잡혔으나 원문을 열지 않았다. 필요하면 https://www.hancomgroup.com/posts/3/292 를 확인한다.
6. **위키화의 ROI 조사.** 사내 문서 정리·위키 구축의 투자 대비 효과를 측정한 1차 조사를 찾지 못했다.
7. **머리말·꼬리말 혼입 아티팩트 자체를 다룬 연구.** OHR-Bench의 Formatting Noise가 개념적으로 이를 포함하지만, 워드프로세서 머리말이 본문에 섞이는 특정 현상의 빈도·영향을 측정한 자료는 찾지 못했다. 우리 실측 1건이 현재 유일한 근거다.
