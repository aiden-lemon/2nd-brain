---
type: concept
topics:
  - "[[wiki/topics/remittance-compliance|Remittance Compliance]]"
status: stub
sources:
  - "raw/송금한도정책.md"
created: "2026-09-03"
updated: "2026-09-03"
---

# Remittance Limit Policy

## Summary

C2C 송금에 국가별로 1회 한도·연간 한도·EDD 임계 세 축을 걸어 통제하는 정책 구조다.
출처는 필리핀과 베트남 두 나라의 값만 확정했고, 나머지 국가의 기본 한도와 승인 절차의
담당·SLA는 아직 비어 있다.

## Details

확정된 한도는 두 나라뿐이다.

| 국가 | 1회 한도 | 연간 한도 | EDD 임계 |
| --- | --- | --- | --- |
| 필리핀 | 3,000 USD | 50,000 USD | 10,000 USD |
| 베트남 | 5,000 USD | 50,000 USD | 10,000 USD |

연간 한도는 두 나라가 같고 1회 한도만 다르다. 그래서 연간 한도를 다 쓰는 데 필요한
최소 송금 횟수가 갈린다 — 필리핀 17회, 베트남 10회다. 1회 한도가 연간 한도에서 차지하는
비중도 각각 6.0%와 10.0%로 벌어진다.

세 축은 성격이 다르다. 1회 한도와 연간 한도는 거래를 막는 상한이고, EDD 임계는 거래를
막지 않고 [[edd-threshold-trigger|강화 확인 절차]]를 발동시키는 기준선이다. 두 나라 모두
EDD 임계(10,000 USD)가 1회 한도보다 높아서, 한 번의 송금만으로는 EDD에 걸리지 않는다.

승인 절차는 신청 접수 → 신분증 확인 → 셀피 인증 → 임계 초과 시 EDD → 컴플라이언스 승인
5단계 골격만 잡혀 있다. 각 단계의 담당·산출물·SLA·실패 시 처리는 출처에서 전부 빈칸이다
(needs-update).

출처가 근거로 든 법령은 전자금융감독규정 제37조 하나다.

## Connections

- [[edd-threshold-trigger|EDD Threshold Trigger]] — 이 정책의 세 번째 축, 임계 초과 시 발동하는 절차

## Open Questions

출처가 스스로 미확정으로 표시한 항목이 7건이다.

- 연간 한도의 "연간" 정의 — 역년인지 가입일 기준 12개월인지
- USD 외 통화로 송금할 때의 환산 기준 환율과 적용 시점
- 필리핀·베트남 외 국가의 기본 한도
- 예외 승인의 승인 권한자와 상향 한도 범위
- 한도 초과 시도의 거부 처리 방식과 사용자 안내 문구
- 정책 시행일·개정 주기·승인권자
- EDD 임계의 적용 단위 — [[edd-threshold-trigger|EDD Threshold Trigger]] 참조
