---
type: run-log
kind: ingest
run_date: "2026-09-04"
author: aiden-lemon
summary: "클리핑 1건 처리 — 인사 휴가 규정 HWPX에서 wiki 2건 신설, topic hr-policy 신설"
pr: 5
processed: 1
new_notes: 2
updated_notes: 0
tags:
  - hr-policy
  - hwp2md
sources:
  - "raw/인사휴가규정.md"
  - "raw/hwp/인사휴가규정.hwpx"
notes:
  - "[[employee-leave-policy|Employee Leave Policy]]"
  - "[[annual-leave-usage-promotion|Annual Leave Usage Promotion]]"
---

# 2026-09-04 Ingest (aiden-lemon)

## Summary

`Clippings/` 1건을 처리했다. Google Drive에 있던 「인사휴가규정.hwpx」를 `hwp2md-ingest`가
H1(hwp-hwpx-parser)로 변환해 투입한 것이고, 여기서 wiki article 2건과 root topic
`hr-policy` 1건을 새로 만들었다. 기존 노트 갱신은 없다.

## Details

원문은 전 7조 + 부칙 한 장짜리 사내 휴가 규정이다. 954자에 표 4개(휴가 종류, 근속 가산
일수, 신청 기한, 경조사 일수), 이미지 0건 — 표가 전부 MD 표로 살아 있어 값 손실 없이
그대로 옮겼다.

노트를 둘로 쪼갠 근거는 규정 안에서 성격이 다른 두 층이 섞여 있다는 것이다.

- [[employee-leave-policy|Employee Leave Policy]] — 휴가가 **발생**하는 쪽. 법정/약정
  구분, 연차 산정 세 갈래, 신청 경로, 경조사 일수를 담는다.
- [[annual-leave-usage-promotion|Annual Leave Usage Promotion]] — 발생한 연차가 **돈으로
  바뀌는지**를 가르는 쪽. 제7조 세 항이 만드는 스위치 하나가 전부라 본체에 섞으면
  묻힌다.

원문 대조에서 규정 자체의 모순 하나를 찾아 `needs-update`로 표시했다. 제4조 ④가 연차
가산 총합의 상한을 10일로 못박는데, 같은 조 ③의 표는 "7년 이상 = 가산 3일"에서 닫힌다.
표대로 읽으면 10일에 닿는 근속 구간이 없어 ④가 사문이 된다. 근로기준법 제60조 제4항의
2년당 1일 가산과 대조하면 표가 7년 초과 구간을 생략한 것으로 보이지만, 규정 본문에
근거가 없어 추정으로 적지 않고 open question으로 남겼다.

적용 배제 범위도 좁게 읽었다. 제2조 단서는 수습 직원에 대해 제4조 **제1항**만 배제한다.
제2항(1년 미만 월 1일)은 배제 목록에 없으므로 수습 직원도 개근하면 월 1일이 쌓인다고
읽히며, 이는 `inference`로 표시했다.

기존 wiki는 AI 에이전트·지식관리·송금 컴플라이언스 세 주제뿐이라 붙일 topic이 없어 root
topic `hr-policy`를 새로 만들고 `wiki/TOPIC_MAP.md`·`wiki/INDEX.md`에 등록했다.

중복 게이트는 변환 원본 레인 기준으로 판정했다 — `raw/hwp/인사휴가규정.hwpx`가 git HEAD에
없어 신규로 처리했다. 파일명 정규화는 적용 대상이 없었다(NFC 한글 21바이트, 금지 문자·
emoji 없음).

## Dropped / Issues

- 남은 needs-update 2건 — 근속 7년 초과 구간의 연차 가산 규칙 부재, 제7조 ②의 "적법한
  시행" 요건 부재. 둘 다 규정 개정으로만 닫히는 사항이다.
- Drive 다운로드본은 파일명에 uuid가 붙어 나오므로 스크래치에 원래 이름으로 복사한 뒤
  변환 스킬에 넘겼다. 그대로 넘기면 `raw/`·`Clippings/` 산출물 이름까지 uuid가 샌다.
