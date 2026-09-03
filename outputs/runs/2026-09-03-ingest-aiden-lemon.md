---
type: run-log
kind: ingest
run_date: "2026-09-03"
author: aiden-lemon
summary: "클리핑 1건 처리 — 송금 한도 정책 PDF에서 wiki 2건 신설, topic remittance-compliance 신설"
pr: 4
processed: 1
new_notes: 2
updated_notes: 0
tags:
  - remittance-compliance
  - pdf2md
sources:
  - "raw/송금한도정책.md"
  - "raw/pdf/송금한도정책.pdf"
notes:
  - "[[remittance-limit-policy|Remittance Limit Policy]]"
  - "[[edd-threshold-trigger|EDD Threshold Trigger]]"
---

# 2026-09-03 Ingest (aiden-lemon)

## Summary

`Clippings/` 1건을 처리했다. `pdf2md-ingest`가 S2(pymupdf4llm)로 변환해 투입한 송금 한도
정책 4페이지 문서에서 wiki article 2건과 topic page `remittance-compliance` 1건을 새로
만들었다. 기존 노트 갱신은 없다.

## Details

원문은 C2C 송금 한도 정책 문서이며, 본문이 세 층으로 나뉘어 있다 — 원문(확정된 값),
파생(원문 숫자에서 계산한 값), 빈칸(담당자가 채울 템플릿). 이 구분을 그대로 노트에
반영했다. 확정값과 파생 계산은 본문에 옮겼고, 빈칸으로 남은 승인 절차 5단계의
담당·산출물·SLA는 `needs-update`로 표시했다.

노트를 둘로 쪼갠 근거는 두 개념이 성격이 다르다는 것이다.

- [[remittance-limit-policy|Remittance Limit Policy]] — 거래를 막는 상한. 1회·연간 한도,
  국가별 값, 승인 절차 골격을 담는다.
- [[edd-threshold-trigger|EDD Threshold Trigger]] — 거래를 막지 않고 절차를 발동시키는
  기준선. `>=` 경계 판정과 누적 시나리오를 담는다.

두 노트 모두 `status: stub`이다. 원문의 확정 내용이 두 나라 값과 판정 코드 한 줄로
얇고, 문서 스스로 미확정으로 표시한 항목이 7건이라 확장 여지가 크다.

기존 wiki는 전부 AI 에이전트·지식관리 주제라 붙일 topic이 없어 root topic
`remittance-compliance`를 새로 만들고 `wiki/TOPIC_MAP.md`·`wiki/INDEX.md`에 등록했다.

중복 게이트는 변환 원본 레인 기준으로 판정했다 — `raw/pdf/송금한도정책.pdf`가 git HEAD에
없어 신규로 처리했다. 파일명은 정규화 규칙 적용 대상이 없었다(NFC 한글 21바이트, 금지
문자·emoji 없음).

## Dropped / Issues

- 원문 표 일부가 PDF 셀 wrap 때문에 변환 MD에서 두 행으로 쪼개졌다(파생 지표의 "연간 한도
  소진에 필요한 최소 송금 횟수", 누적 시나리오 헤더, 확인 필요 항목 1번). 내용 손실은
  없고 셀 경계만 어긋났다. wiki 노트에는 정상 표로 재구성해 넣었다. raw는 append-only라
  원문 MD는 그대로 둔다.
- 남은 needs-update 2건 — 승인 절차 5단계의 담당·SLA 미정, EDD 임계의 1건/누적 기준 미정.
  둘 다 원문 작성자 결정 대기 사항이다.
