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

# EDD Threshold Trigger

## Summary

송금액이 EDD 임계에 닿으면 강화 확인 절차를 발동시키는 판정이다. 출처는 임계를
10,000 USD로 두고 `amount >= threshold`, 즉 경계값을 포함하는 비교로 못박았다.

## Details

판정 함수는 한 줄이다.

```python
def needs_edd(amount, threshold):
    return amount >= threshold
```

`>=`라서 임계와 정확히 같은 금액도 발동한다. 출처의 진리표는 9,999 USD를 FALSE로,
10,000 USD를 TRUE로 찍어 이 경계를 명시한다.

임계가 두 나라의 1회 한도(필리핀 3,000·베트남 5,000 USD)보다 높아서, 단일 송금으로는
어느 쪽도 EDD에 도달하지 못한다. 임계를 1회 한도로 나누면 필리핀 3.33배, 베트남 2.00배다.
발동이 일어나려면 누적이 필요하다.

1회 한도 최대치로 반복 송금할 때의 누적은 이렇게 벌어진다.

| 회차 | 필리핀 누적 (3,000씩) | 발동 | 베트남 누적 (5,000씩) | 발동 |
| --- | --- | --- | --- | --- |
| 1 | 3,000 | — | 5,000 | — |
| 2 | 6,000 | — | 10,000 | 발동 |
| 3 | 9,000 | — | 15,000 | 발동 |
| 4 | 12,000 | 발동 | 20,000 | 발동 |

1회 한도가 큰 베트남이 2회차에, 필리핀이 4회차에 걸린다. 같은 임계를 두어도 1회 한도에
따라 EDD 진입 속도가 두 배 차이 난다.

단, 이 누적 시나리오는 임계를 누적 기준으로 읽었을 때의 계산이다. 출처의 판정 코드는
`amount` 하나만 받으므로 1건 기준으로도 읽힌다. 어느 쪽인지는 출처에서 미정이다
(needs-update).

## Connections

- [[remittance-limit-policy|Remittance Limit Policy]] — 이 임계가 세 번째 축으로 들어가는 상위 정책

## Open Questions

- EDD 임계가 1건 기준인지 누적 기준인지. 누적이라면 집계 기간과 단위(건수·금액)도 함께
  정해야 한다. 위 누적 표는 누적 해석을 전제로 한 계산이다.
- 발동 이후의 EDD 절차 자체 — 담당·산출물·SLA·실패 시 처리는 출처에서 빈칸이다.
