# Critique: CSR 목록 영역 (list)

총점 **25/40 (62.5%)** — 등급 **Acceptable (C+)**
P0 0 · P1 3 · P2 6 · P3 4

Method: ⚠️ DEGRADED: single-context (delegated read-only run). Assessment B(detector/브라우저)는 수행하지 않음. 소스 정독 기준 정적 비평. 읽기 전용, 코드 수정 없음.

대상: `src/modules/csr/views/CsrListPage.vue`, `components/CsrStatusBadge.vue`, `CsrStatusLegend.vue`, `CsrStatusDefTable.vue`
기준: PRODUCT.md, DESIGN.md (Operate 모드 / "The Ledger Desk")

## Heuristic 점수 (총 25/40 → 62.5%, Acceptable)

| # | 항목 | 점수 | 핵심 |
|---|---|---|---|
| 1 | 시스템 상태 가시성 | 3 | 로딩·오류·빈 행·정렬 aria 있음. 필터 적용 여부 표시 약함 |
| 2 | 현실 일치 | 3 | 코드+라벨, 이중언어 |
| 3 | 사용자 통제 | 2 | 프리셋 활성 상태 표시 없음, 필터 칩 없음 |
| 4 | 일관성·표준 | 2 | 툴바 3색 구분이 DESIGN.md One Voice와 충돌, 모서리·그림자 이탈 |
| 5 | 오류 예방 | 3 | |
| 6 | 인지 우선 | 2 | 필터 현재값이 "Priority: Reset" 문구로만 표현 |
| 7 | 유연성·효율 | 3 | URL 쿼리 동기화·키보드 행 이동 우수 |
| 8 | 미니멀 | 2 | 툴바 한 줄에 컨트롤 11개 이상, 3색 |
| 9 | 오류 복구 | 2 | 오류 행에 재시도 없음 |
| 10 | 도움말 | 3 | 범례 있음. 단 이중언어 비동등 |
| **합계** | | **25/40** | Acceptable |

## 잘 된 점
- 행 전체 클릭+키보드(Enter/Space), aria-sort, URL 쿼리 동기화로 새로고침·공유 유지.
- 배지가 코드 텍스트+톤을 함께 전달(색만 의존 안 함), 단일 컴포넌트로 3화면 공유.
- 범례 기본 접힘, 바깥클릭·Esc 닫힘.

## Findings

### P1

**P1-1 이중언어 비동등: 목록 본문 곳곳이 한쪽 언어만 노출**
- `CsrListPage.vue:342-343,565-568`: 아카이브 표식 `' (삭제)'`가 CSS content로 한국어 고정(인니어 사용자에게 누락). `:181-186` 설정 필요 패널도 한국어 단일.
- `CsrListPage.vue:168`: 제목 `CSR` + 부제는 lang 토글에 따라 한쪽만 — 허용 가능하나 PRODUCT.md 원칙1(한쪽만 보이는 상태 금지)에 위배되는 곳은 위 두 곳.
- 추천: `$impeccable clarify` (+ `harden` i18n)
- 공유 자원: 아니오 (i18n `label()` 사전에 키 추가 시 i18n.js 공유)

**P1-2 `colspan="7"` 이나 실제 열은 6개**
- `CsrListPage.vue:321,324,327` vs `COLUMNS` 6항목(110-117). 로딩·오류·빈 행이 표 폭을 어긋나게 계산.
- 추천: `$impeccable harden` / `polish`
- 공유 자원: 아니오

**P1-3 필터 현재 상태 식별 불가 (Recognition)**
- `CsrListPage.vue:233-273`: 프리셋 버튼에 활성 표시가 없고, 셀렉트는 미선택 시 「Priority: 초기화」처럼 "초기화"라는 동작어를 값 자리에 표시. 사용자는 지금 필터가 걸렸는지·어떤 프리셋인지 알 수 없음. 목록 주 업무가 조회·필터(PRODUCT.md)이므로 핵심 과업.
- 추천: `$impeccable layout` + `clarify` (placeholder는 "전체 / Semua", 활성 프리셋 `aria-pressed`+표시)
- 공유 자원: 아니오 (issues store의 활성 프리셋 상태가 필요하면 stores 공유)

### P2

**P2-1 툴바 3색 구분이 DESIGN.md 위반**
- `CsrListPage.vue:443-486`: 프리셋=블루, 필터=초록, 이동=회색. DESIGN.md의 One Voice Rule(블루는 구조·행동만)·Triple Status Rule(의미 있는 상태색만 색상환 다른 쪽)에 반해 초록(success)을 "필터" 장식에 사용. 초록은 완료 의미와 혼동. 컨트롤 11개가 한 줄이라 밀도도 높음.
- 추천: `$impeccable quieter` / `distill`
- 공유 자원: 아니오

**P2-2 하드코딩 값 (No-Raw-Hex / 토큰)**
- `CsrListPage.vue:474` `rgb(30 123 52 / 0.15)` 포커스 링 — DESIGN.md는 3px #99c0e8(`--asm-primary-40`) 단일 규정.
- `CsrStatusLegend.vue:99` `0 8px 24px rgb(0 0 0 / 0.12)` — Float 토큰(`0 4px 12px rgb(51 51 51/0.12)`)과 불일치.
- 추천: `$impeccable polish` (필요 시 `extract`)
- 공유 자원: 예 — Legend는 상세 화면과 공유, asm-theme.css 토큰 사용 권고

**P2-3 모서리 규정 이탈**
- `CsrListPage.vue:397` `.notice` 알약형(9999px), `:503` `.count-pill` 알약형. DESIGN.md는 알약형을 역할 pill·스크롤바 한정.
- 추천: `$impeccable polish`
- 공유 자원: 아니오

**P2-4 권한 없는/불가 상태와 오류 복구**
- `CsrListPage.vue:323-325`: 로딩 실패 시 오류 문구만 있고 재시도 없음. 미등록 화면은 「다시 확인」이 있어 비대칭.
- 추천: `$impeccable harden`
- 공유 자원: 아니오

**P2-5 범례 패널 접근성·반응형**
- `CsrStatusLegend.vue:52-57`: `role="dialog"`인데 포커스 이동·트랩 없음, 버튼에 `aria-controls` 없음. 320px에서 `width: min(760px, 92vw)`+`right:0` 이므로 좌측 잘림 가능(툴바 우측 정렬 컨테이너 기준).
- 추천: `$impeccable harden` / `adapt`
- 공유 자원: 예 (Legend는 상세 페이지 공용)

**P2-6 아카이브 행 opacity 0.55 → 대비 저하**
- `CsrListPage.vue:562-564`: 전체 행 투명도로 배지·텍스트 대비가 AA 4.5:1 미만이 될 수 있음(PRODUCT.md 접근성 기준). 취소선·「삭제」 라벨 같은 비색상 단서를 쓰고 대비는 유지 권장.
- 추천: `$impeccable audit`
- 공유 자원: 아니오 (배지 색은 공유 asm-badge)

### P3

**P3-1 `CsrStatusDefTable.vue:20` 열 헤더 `Code` 기본값이 번역 불가한 영문 고정**, 이름 열은 lang별 라벨을 받지만 code 라벨은 호출부가 안 넘김(`CsrStatusLegend.vue:62-67`). 일관성상 문제 없으나 `codeLabel` 이중언어 인자 확인.
- 추천: `$impeccable clarify` / 공유 자원: 예 (GuidePage도 사용)

**P3-2 `CsrStatusBadge.vue:43` 툴팁이 `title` 속성뿐** — 키보드·터치 접근 불가, it_decision은 툴팁 자체 없음.
- 추천: `$impeccable harden` / 공유 자원: 예 (목록·상세·대시보드 공통)

**P3-3 `CsrListPage.vue:275-280` 「대시보드/관리」 이동 버튼이 필터 툴바 안에 섞임** — 필터와 내비게이션이 한 줄에 공존, `.vr` 구분선 스타일 정의 없음(grep상 scoped CSS 없음, Bootstrap 기본 의존).
- 추천: `$impeccable layout` / 공유 자원: 아니오

**P3-4 `CsrListPage.vue:12-17` 스크립트 중간에 함수 선언 후 import 이어짐, `:287` 낡은 주석 잔존** — 가독성만.
- 추천: `$impeccable polish` / 공유 자원: 아니오

## 공유 자원 영향 요약
- `CsrStatusBadge.vue` — List·Detail·Dashboard 공유. 변경 시 3화면 회귀 확인 필요.
- `CsrStatusLegend.vue` — List·Detail 공유. `CsrStatusDefTable.vue` — Legend·StatusGuidePage 공유.
- 토큰(`asm-theme.css`), `i18n.js`/`status.js` 사전은 전역.

## 개인 페르소나 적색 신호
- **현업 담당자(인니)**: 삭제 표식·설정 안내가 한국어 고정. 필터 셀렉트 "초기화" 문구로 현재 필터 파악 곤란.
- **IT 담당자**: 「IT 대기」 프리셋이 눌렸는지 알 수 없어 목록이 필터된 상태인지 오인.
- **키보드 파워 사용자**: 행 이동은 우수하나 범례 열림 시 포커스 이동 없음.
