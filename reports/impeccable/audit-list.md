# Audit — list 영역 (읽기 전용 진단)

대상: `src/modules/csr/views/CsrListPage.vue`, `components/CsrStatusBadge.vue`, `CsrStatusLegend.vue`, `CsrStatusDefTable.vue`
기준: PRODUCT.md · DESIGN.md · `/impeccable audit`. 코드 수정 없음. 모드: Operate.

## 점수: 14/20 (Good — 약한 차원부터 보강)

| # | 차원 | 점수 | 핵심 |
|---|---|---|---|
| 1 | 접근성 | 2 | 정렬 헤더가 마우스 전용, `<tr role=button>`이 표 의미를 깨뜨림 |
| 2 | 성능 | 3 | 전역 document 리스너·행 전체 재렌더 외엔 양호 |
| 3 | 토큰 준수 | 3 | 범례 그림자·포커스 링 raw rgb, pill 반경 |
| 4 | 반응형 | 3 | 가로 스크롤 처리 양호, 터치 타깃·colspan 오차 |
| 5 | 구현 무결성 | 3 | 배지·상태 3종 규칙 준수, 일부 하드코딩 한국어 |
| **합계** | | **14/20** | P0 0 · P1 2 · P2 5 · P3 2 |

detector: 1건(advisory) — CsrStatusLegend.vue:145 `rgb(0 0 0 / 0.12)` (아래 P2-2로 확인, 오탐 아님).

## 구현 무결성 판정: 통과
배지는 `asm-badge--*`(글자·soft·테두리 3종)와 상태 텍스트를 함께 쓰고 Triple Status/Tabular 규칙을 따릅니다. 색은 대부분 `--asm-*` 변수입니다. 이탈은 아래 항목에 한정됩니다.

## P1

### [P1-1] 정렬 헤더가 키보드·보조기기로 조작 불가
- 위치: `CsrListPage.vue:306-316` (`<th @click>`)
- 문제: `th`에 `tabindex`·버튼 요소·키 핸들러가 없어 마우스로만 정렬됩니다. 정렬 상태(`aria-sort`)는 있으나 조작 수단이 없습니다. WCAG 2.1.1(키보드).
- 추천: `$impeccable harden` (th 안에 `<button>`으로 감싸고 포커스 링 부여)
- 공유: 아님

### [P1-2] `<tr role="button" tabindex="0">`가 표 의미를 파괴
- 위치: `CsrListPage.vue:329-340`
- 문제: 행에 `role=button`을 주면 스크린리더가 행·셀 관계(열 머리글 연결)를 잃고 안의 배지 텍스트가 한 덩어리로 읽힙니다. 열 6개마다 Tab 정지도 한 행당 1개뿐이라 링크 의미(새 탭 열기)도 없습니다. WCAG 1.3.1 / 4.1.2.
- 추천: `$impeccable harden` (행 의미 유지 + 이슈번호 셀에 `<router-link>`, 행 클릭은 보조 동작)
- 공유: 아님

## P2

### [P2-1] 키보드 포커스 링 대비 부족
- 위치: `CsrListPage.vue:557-560` (`.row-link:focus-visible`)
- 문제: `outline:none` 후 `inset 0 0 0 2px var(--asm-primary-40)`(#99c0e8) — 흰 배경 대비 약 1.9:1로 3:1 미달(WCAG 1.4.11). DESIGN.md의 Focus ring 토큰은 3px #99c0e8이지만 이 값 자체가 비텍스트 대비 미달입니다.
- 추천: `$impeccable polish` (토큰 상향은 DESIGN.md 결정 필요)
- 공유: **공유** (포커스 링 토큰 `--asm-primary-40` / DESIGN.md)

### [P2-2] 범례 패널 그림자가 토큰 밖
- 위치: `CsrStatusLegend.vue:145` `box-shadow: 0 8px 24px rgb(0 0 0 / 0.12)`
- 문제: DESIGN.md Float(`0 4px 12px rgb(51 51 51/0.12)`) · Overlay 토큰을 쓰지 않고 순흑 raw 값. No-Raw-Hex 규칙 위반(detector 일치).
- 추천: `$impeccable polish` (`var(--asm-shadow-md)` 로 교체)
- 공유: 아님 (토큰은 기존 것을 참조)

### [P2-3] 범례 버튼·패널의 다이얼로그 접근성 미비
- 위치: `CsrStatusLegend.vue:89-103`
- 문제: `role="dialog"`인데 열릴 때 포커스 이동이 없고 닫힌 뒤 복귀도 없음, `aria-controls` 없음, 화살표 `▴▾`(95행)가 `aria-hidden` 아님. 비모달 패널이면 `role=dialog` 대신 disclosure 패턴이 맞습니다. 바깥 클릭·Esc 닫기는 양호.
- 추천: `$impeccable harden`
- 공유: 아님

### [P2-4] 아카이브 행 `opacity:.55`로 글자 대비 하락
- 위치: `CsrListPage.vue:562-564`
- 문제: 행 전체를 반투명으로 만들어 본문·배지 글자가 4.5:1 아래로 떨어집니다(배지 글자는 DESIGN의 소프트 배경 대비 설계값을 잃음). WCAG 1.4.3. `(삭제)` 표기(565-569)는 있어 색 단독 전달은 아님.
- 추천: `$impeccable colorize` (opacity 대신 muted 토큰 + 취소선 등)
- 공유: 아님

### [P2-5] 요약 표 colspan 오차 · 하드코딩 한국어
- 위치: `CsrListPage.vue:321,324,327` (`colspan="7"`, 실제 열 6개), `:566` (`content: ' (삭제)'` — 인니어 UI에서도 한국어 고정)
- 문제: colspan이 열 수보다 큼(레이아웃 영향은 작음). 「삭제」는 `lang` 분기 없음 — 이중언어 원칙 위반.
- 추천: `$impeccable clarify` (문구), `$impeccable harden` (colspan)
- 공유: 아님

## P3

### [P3-1] 알약형 반경이 DESIGN.md의 Don't와 충돌
- 위치: `CsrListPage.vue:397` (`.notice`), `:503` (`.count-pill`) — `border-radius: 9999px`
- 문제: DESIGN.md는 역할 pill 외 9999px 금지. 건수·공지는 4/6px로 정리해야 합니다. 일관성만의 문제.
- 추천: `$impeccable polish`
- 공유: 아님 (`.asm-pill`은 전역이므로 건드리지 않음)

### [P3-2] 필터 select 포커스 그림자 raw rgb
- 위치: `CsrListPage.vue:474` `rgb(30 123 52 / 0.15)`
- 문제: `--asm-success` 파생 raw 값, 토큰 없음. detector는 잡지 않았으나 같은 계열 이탈. 또한 12px 글자·`btn-sm`은 터치 타깃이 24px 이상은 되나 44px 미만(조회는 데스크톱 중심이라 우선순위 낮음).
- 추천: `$impeccable adapt` / `$impeccable polish`
- 공유: 아님

## 반응형·성능 메모 (이슈 없음 수준)
- `.table-scroll{overflow-x:auto}` 로 320px 가로 스크롤 처리, `.headline` `.notice` 모바일 줄바꿈 처리 양호.
- 필터가 `v-model` + `watch deep` + 검색 debounce 300ms. 행은 `:key="row.id"` 사용. 가상 스크롤 없음 — 건수가 수백 건을 넘으면 `$impeccable optimize` 검토(현재 근거 없음).
- 레전드의 `document` 리스너는 mount/unmount에서 해제되어 누수 없음. 단 `open`이 닫힌 상태에서도 모든 클릭에 `onDoc`이 호출됨(비용 미미).

## 잘된 점
- 상태 배지: 텍스트 + 글자·soft·테두리 3종 + `title` 툴팁, 톤은 사전 한 곳(`STATUS_TONE`, status.js)에서 옴 — 색 단독 전달 아님.
- `aria-sort`, `aria-label`(검색·필터), 숫자·이슈번호 `tabular-nums`, 날짜·nowrap 규칙 준수.
- 필터·정렬을 URL 쿼리와 동기화하여 새로고침·공유 시 상태 유지.
- 제목 말줄임을 `overflow+nowrap+ellipsis` 3종 세트로 처리, 전체는 툴팁.

## 권장 실행 순서
1. [P1] `$impeccable harden` — 정렬 헤더 버튼화, 행 의미 복구, 범례 disclosure/포커스
2. [P2] `$impeccable polish` — 그림자 토큰, 반경, 포커스 링(공유 토큰은 별도 승인)
3. [P2] `$impeccable colorize` — 아카이브 행 대비
4. [P2] `$impeccable clarify` — 「(삭제)」 이중언어
5. 마무리 `$impeccable polish`

공유 자원 항목: P2-1 (포커스 링 토큰) 한 건뿐. 나머지는 영역 파일 내부에서 해결 가능.
