---
type: run-log
kind: ingest
run_date: "2026-08-28"
author: aiden-lemon
summary: "클리핑 1건 재처리 — 동일 원본 재클리핑을 raw에 -2로 보존, wiki화 없음"
pr: 3
processed: 1
new_notes: 0
updated_notes: 0
tags:
  - hwp2md
sources:
  - "raw/점검-결과-보고-2.md"
  - "raw/hwp/점검-결과-보고.hwpx"
notes: []
---

# 2026-08-28 Ingest 재실행 (aiden-lemon)

## Summary

`Clippings/` 1건을 처리했다. 같은 세션에서 `hwp2md-ingest` H1 경로로 다시 변환한
`점검-결과-보고.md`이며, PR #1에서 이미 처리한 문서와 동일 원본(sha256 `27ebab26…`)이다.
재클리핑본을 `raw/점검-결과-보고-2.md`로 보존했고 wiki 노트는 만들지 않았다.
신규·갱신 wiki 0건이라 `wiki/INDEX.md`·`wiki/TOPIC_MAP.md`는 건드리지 않았다.

## Details

**중복 판정 — 재클리핑 경로로 처리**

`raw/점검-결과-보고.md`에 동일 sha256의 처리본이 이미 있었다. 워킹트리에서는 그 파일이
삭제된 상태였고, `projects/second-brain/samples/README.md`가 반복 실습을 위한 raw 정리를
예외로 허용하고 있어 처음에는 같은 경로에 덮어쓰는 방향으로 갔다.

그 배치는 `vault_verify.py --lane ingest`에서 걸렸다.

```
FAIL (ingest, base 158e33b): 1 defect(s)
  - append-only violation (M): raw/점검-결과-보고.md
```

기계 검사가 판정을 뒤집었다. README의 실습 예외는 사람 사이의 관례일 뿐 검사기가 모르고,
`CLAUDE.md` § Hard Invariants의 append-only는 하드 룰이다. job spec의 재클리핑 규칙
(중복 source면 기존 노트를 갱신하고 재클리핑본은 `-1`/`-2` 접미사로 보존)으로 되돌려
기존 `raw/점검-결과-보고.md`를 원상 복구하고 새 산출본을 `-2`로 붙였다. 재검사 PASS.

두 산출본의 차이는 3줄이다.

```
+> 제3공장 설비팀 — 대외비 아님 (교육용 샘플)
+(빈 줄 2개)
```

이번 변환이 hwpx 머리말을 인용문으로 살렸고 PR #1 산출본은 떨어뜨렸다. 원문 정보가 늘어난
쪽이 `-2`에 남아 있으므로, 나중에 이 문서를 다시 쓸 일이 생기면 `-2`를 본다.

**wiki화 보류 — PR #1 판정 재현**

내용은 가상의 압축기 점검 측정값(CMP-02 토출 압력 7.1 bar, CMP-03 진동 속도
5.2 mm/s 부적합 등)과 조치 사항이다. 합성 수치를 wiki article로 올리면 검증 불가능한
도메인 사실이 지식 계층에 들어간다. PR #1과 같은 이유로 보류했다. 판단이 회차마다
흔들리지 않는지 확인하는 것이 이번 재실행의 목적 중 하나였고, 결과는 동일했다.

**변환 경로 실측 (H1)**

| 항목 | 값 |
| --- | --- |
| 전략 | H1 (hwp-hwpx-parser, 한컴오피스 불필요) |
| 추출 문자수 | 403 (채택 기준 300 이상) |
| 표 | 1 → 마크다운 표로 재구성 성공 |
| 이미지 | 0 · 암호화 없음 |
| 산출 MD | 1,206 bytes |

`samples/README.md`가 예고한 `표 1 · 403자 · 머리말 포함`과 정확히 일치한다.
샘플이 의도한 분기를 그대로 탔다.

**색인·메모리**

- `wiki/INDEX.md`·`wiki/TOPIC_MAP.md` — 변경 없음 (신규 wiki 0건)
- `wiki/VAULT_MEMORY.md` — `Last Ingest` 한 줄 교체, `Volume to date` 갱신. `wc -c` 2811

## Dropped / Issues

- `점검-결과-보고-2.md` — wiki화 보류. 사유는 위 "wiki화 보류". 실제 설비 점검 데이터가
  들어오면 그때 도메인 노트를 세운다.
- `samples/README.md`의 반복 실습 안내("`raw/`의 해당 파일과 `Clippings/`의 산출 MD를
  지우고 다시 실행한다")가 `vault_verify`의 append-only 검사와 충돌한다. 실습을 반복하면
  `raw/`에 `-2`, `-3`이 계속 쌓인다. README 문구를 검사기에 맞춰 고치거나, 검사기에
  실습 샘플 예외 경로를 두거나 둘 중 하나가 필요하다. **후속 결정 필요.**
- 이번 ingest와 무관했던 미커밋 작업물(2주차 교육자료 산출물, `samples/`,
  `areas/weekly/2026-08-28`, `Untitled.base` 삭제)은 선행 PR #2로 분리 커밋했다.
  이 브랜치는 PR #2 위에 쌓여 있어, PR #2가 머지되면 이 PR의 diff가 좁아진다.
- PR 리뷰어를 `team-settings.yaml`의 `default_reviewer`(`steve-lemon`)로 지정하지
  못했다 — origin이 개인 포크(`aiden-lemon/2nd-brain`)라 협업자가 아니다. 포크에서
  계속 작업한다면 `team-settings.yaml`의 리뷰어 값을 조정해야 한다.
- `docs/raw-index.md`는 이번 실행에서 재생성하지 않았다 — `vault-lint` 패스의 몫이다.
