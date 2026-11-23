# Impeccable audit: dashboard

대상: `src/modules/csr/views/CsrDashboardPage.vue` (코드 읽기 기반. 렌더 캡처·실기기 터치는 실행하지 않음)
점수: **13 / 20 (Acceptable: 의미 있는 보완 필요)**. P0 0 · P1 2 · P2 8 · P3 4

| # | 차원 | 점수 | 핵심 |
|---|------|------|------|
| 1 | Accessibility | 2 | 클릭 행이 `li role=button`: 목록 의미 상실, 링크 아님 |
| 2 | Performance | 3 | 63건 규모라 문제 없음. computed 안 상태 변경만 정리 필요 |
| 3 | Theming | 3 | HEX 0건, 토큰 사용 양호. 글자 크기만 px 하드코딩 |
| 4 | Responsive | 2 | 목록 행 grid가 320px에서 제목 폭을 잠식 |
| 5 | Implementation Integrity | 3 | 표시 문구로 데이터 판정, 좌측 띠 카드 |
| | **합계** | **13/20** | |

## Integrity 판정
통과(조건부). 토큰만 쓰고 그림자가 없으며 tabular-nums도 지켜 DESIGN.md(Flat-At-Rest, No-Raw-Hex, Tabular)와 맞는다. 다만 비즈니스 판정이 표시 문구 정규식에 묶여 있고, 상태 카드가 Triple Status Rule 대신 좌측 3px 띠로만 톤을 낸다.

## 발견 사항

| P | 파일:라인 | 문제 | 추천 명령 | 공유 |
|---|-----------|------|-----------|------|
| P1 | CsrDashboardPage.vue:218-226, 264-272 | `<li role="button">` + `router.push`. `ul`의 listitem 의미가 사라지고, 이동인데 버튼으로 읽힌다. href가 없어 새 탭·Ctrl+클릭·링크 목록 탐색이 안 된다 (WCAG 1.3.1, 4.1.2). `<li><RouterLink>`로 교체하고 행 전체 클릭은 링크 확장 방식으로 처리 | `$impeccable harden` | 페이지 한정 |
| P1 | CsrDashboardPage.vue:471-480 | `.list li` grid가 `auto auto minmax(0,1fr) auto`. 320px(패널 안 폭 약 256px)에서 번호·배지·담당자가 폭을 먼저 가져가 제목 열이 수십 px로 줄어든다. PRODUCT.md의 320px 요구와 충돌 (렌더 미확인, 계산 추정) | `$impeccable adapt` | 페이지 한정 |
| P2 | :47-51 | `slicePage` computed가 `page[key]`를 변경(부수효과). Vue 안티패턴이고 재계산 연쇄 위험. watch나 clamp 계산값으로 분리 | `$impeccable optimize` | 페이지 한정 |
| P2 | :93 | `/미회신\|Belum Ada Balasan/`로 표시 문구에 의존해 판정. 문구가 바뀌면 조용히 누락. status.js에 코드 판정 함수로 이동 | `$impeccable harden` | 공유(status.js) |
| P2 | :136, 130 | 「설정이 필요합니다」가 한국어 단독(이중언어 규칙 위반). 반면 h1 "Dashboard"는 영문 고정 | `$impeccable clarify` | 페이지 한정 |
| P2 | :137-139, :35 | 로딩·권한 없음·설정 필요 상태에 `role="status"`/`aria-live`가 없다. `issues.load()` 실패 분기도 없어 빈 화면이 될 수 있다 | `$impeccable harden` | 페이지 한정 |
| P2 | :233, :279 | 두 `nav`가 같은 `aria-label="pagination"`(영문 고정, 비구분). 현재 페이지 변화 알림도 없음. 목록명을 넣어 현지화하고 `aria-live="polite"` 추가 | `$impeccable clarify` | 페이지 한정 |
| P2 | :180, :188-190, :309-317 | 빈 `<th></th>`, 행 머리 `th`에 `scope` 없음, 교차표에 caption 없음. 보조기기가 열·행 관계를 못 잇는다 | `$impeccable harden` | 페이지 한정 |
| P2 | :487-490 | 포커스를 `outline:none` + inset box-shadow로만 표시. Windows 고대비 모드에서 box-shadow가 사라져 포커스가 안 보인다. `outline: 2px solid transparent` 병기 | `$impeccable polish` | 공유 후보(전역 포커스 규칙과 정합) |
| P2 | :392-403 | 카드의 상태 톤이 좌측 3px 색 띠 단독. Triple Status Rule(글자·soft 배경·테두리 3종) 위반, 사이드 스트라이프 금지 규칙에도 걸린다. `tone-info`와 `tone-primary`가 동일 값 | `$impeccable colorize` | 토큰은 공유, 적용은 페이지 한정 |
| P3 | :336-357 | 글자 크기 12/13/14/18px와 `.asm-title`, `.asm-kpi-label`, `.asm-badge`를 이 화면에서 px로 재정의. 타입 토큰이 없어 화면마다 어긋남 | `$impeccable typeset` | 공유(전역 CSS·토큰 추가) |
| P3 | :229, :275 | 말줄임 제목은 `title` 속성뿐이라 키보드·터치에서 전체 제목을 못 본다 | `$impeccable clarify` | 페이지 한정 |
| P3 | :188, :76-77 | 템플릿에서 `rowTotal`/`colTotal`이 매 렌더 전체 filter. 63건이라 영향 없음. 단일 집계 computed로 | `$impeccable optimize` | 페이지 한정 |
| P3 | :234-251 | 페이지 버튼 `btn-sm`(약 31px 높이)과 「‹ ›」 글리프. AA 24px는 충족, 44px 권장에는 미달 | `$impeccable adapt` | 페이지 한정 |

## 패턴·체계 이슈
- 이 화면이 공유 클래스(`.asm-title` 등)의 크기를 scoped로 덮어쓴다. 다른 CSR 화면과 어긋나기 쉬우니 타입 스케일 토큰을 `asm-theme.css`에 두는 편이 낫다(공유 자원).
- 「행 전체 클릭」 패턴이 목록 화면에도 있는지 확인이 필요하다. 있으면 같은 컴포넌트로 일원화.

## 잘한 점
- HEX 직접 사용 0건, 색은 전부 `var(--asm-*)`.
- 정지 상태 그림자 없음, 숫자 열 tabular-nums, 헤더 계층 h1→h2 정상.
- 표는 `.table-scroll`로 가로 넘침을 가두고, 두 열 grid는 `min(380px,100%)`로 좁은 폭에서 접힌다.
- 클릭 행에 Enter/Space 키 처리와 `:focus-visible` 표시가 있다.

## 권장 순서
1. P1 `$impeccable harden`: 행을 RouterLink로 교체하고 상태 영역·표 구조·판정 코드화
2. P1 `$impeccable adapt`: 320px 목록 행 재배치
3. P2 `$impeccable clarify`, `$impeccable colorize`, `$impeccable typeset`
4. 마지막 `$impeccable polish`
