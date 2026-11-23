# impeccable 수정 후 독립 검증 (verify)

- 검증일 : 2026-11-23 · 대상 : d:\asm-web-vue `main`
  - 1차 검증 : HEAD `6fcc9bc` (수정 범위 `git diff dd48beb HEAD -- src`, 14개 파일)
  - **재검증 1/2** : HEAD `618cfba` (R-1·R-2 수정 커밋, asm-theme.css·CsrDashboardPage.vue 2개 파일). 아래 §0과 갱신된 표가 최신 판정임
- 검증자 : impeccable-verifier (수정 작업 미참여). 코드 수정 없음
- 기준 : `00_통합표.md`, audit-*.md / critique-*.md (수정 전), PRODUCT.md, DESIGN.md
- 방식 : **소스 정독 기반 audit 재실행** + 인증 없이 열리는 화면만 헤드리스 Chrome(CDP) 렌더·측정. 인증이 필요한 화면(목록 본체·상세·대시보드·관리)은 렌더하지 못함
- 빌드 : `npm run build` **통과** (1차 3.06s, 재검증 `618cfba` 17.34s · 경고 없음). 재검증 중 개발 서버와 Chrome이 함께 떠 있을 때 `memory allocation … failed`로 2회 중단됐고, 두 프로세스를 종료한 뒤 다시 실행해 통과함(코드 문제 아님)
- 대화형 확인 절차 : 서브에이전트라 사용자 질문 도구가 없어 지시문만으로 판정함

## 0. 재검증 1/2 (HEAD `618cfba`)

### R-1 전역 투명 outline 제거 — **해소 (CDP 실측)**
- asm-theme.css:204-217 : 전역 `:focus-visible{outline:2px solid transparent}`를 삭제하고 `@media (forced-colors: active)` 규칙만 남김. 런타임 스타일시트의 최상위 `:focus-visible` 규칙 수 = 0
- 404 화면에 스타일 없는 `<a href>`·`<button>`·`<input type=checkbox>`를 주입해 포커스(focusVisible) :
  - 1차 : `outline: solid 2px rgba(0,0,0,0)` → 보이지 않음
  - **재검증 : 세 요소 모두 `outline: auto 1px rgb(16,16,16)`** → UA 기본 링으로 돌아옴
- 자체 box-shadow 링이 있는 요소는 회귀 없음 : `/csr`(헤더·로그인) 11개, `/csr/status-guide` 16개, `/csr/flow` 17개, `/csr/docs` 20개, `/csr/docs/DOC-01` 23개, 404 1개 → **전부 `fv=true`·링 있음**
- 그 결과 list `.sort-btn`·`.no-link`·보관 체크박스, dashboard `.guide-link`, detail `.shot-open`·`.log-toggle`·Drive 링크, admin 로그 링크가 UA 기본 링을 받음. 인증 화면이라 직접 렌더하지 못했고, 같은 CSS 경로를 주입 실험으로 확인함

### R-2 대시보드 수치 링크 — **해소 (소스 확인)**
- CsrDashboardPage.vue:133-142 `LIST_RESET` = `search:''`, `itStatus·verification·priority·pic:'All'`, `showArchived:'0'`, `excludeVerified:'0'`. `listTo(q)` = `{...LIST_RESET, ...q}`
- CsrListPage.vue:44-53 `applyQueryToFilters` 확인 :
  - `q[key] === undefined`일 때만 건너뜀. `search=`는 vue-router가 `''`로 파싱하므로 `search=''`가 적용됨
  - boolean 키는 `q[key] === '1'`로 판정하므로 `'0'`은 `false`가 됨
  - `'All'` 문자열이 그대로 적용되고, 스토어 필터(issues.js:107-116)의 `!== 'All'` 판정과 맞음
  - 키 집합이 `FILTER_DEFAULTS`(:35-43)의 7개와 정확히 같음
- 적용 뒤 list watch(:56-80)가 기본값 키를 URL에서 빼므로 주소는 `/csr?itStatus=Verified`처럼 깔끔하게 남음
- 시나리오 판정 :
  1. IT부서용 프리셋(`excludeVerified=true`) 뒤 「Verified n」 클릭 → `excludeVerified='0'`이 false로 덮여 n건 표시 → **해소**
  2. 검색어·`priority=S1`이 남은 상태에서 「Open n」 클릭 → `search=''`, `priority='All'`로 초기화 → **해소**
  3. 「Total」·합계(`listTo()`) 클릭 → 7개 키 모두 기본값 → 보관 제외 전체 = `c.total` → **해소**
- 남는 점 : 정렬(`sort`)은 초기화하지 않지만 건수와 무관해 문제가 아님. 담당자 trim 불일치(R-4, P3)는 그대로

### 갱신 결과
- L-1, L-2 : 부분 → **해결** (근본 원인 R-1 해소)
- H-4 : 부분 → **해결** (근본 원인 R-2 해소)
- P1 잔여 5 → **0**. 신규 회귀 7 → **잔여 5** (P2 1 · P3 4), 해소 2 (R-1, R-2)
- 320px 공개 화면 재측정 : scrollWidth − clientWidth = 6(스크롤바 폭, R-7)으로 1차와 같음

## 1. 결론

| 항목 | 결과 |
|---|---|
| P0 잔여 | 0 |
| P1 잔여 | **0** (1차 5건 : L-1·L-2·H-4 부분 해결 + R-1·R-2 → `618cfba`에서 모두 해소) |
| 신규 회귀 | 1차 7건 중 **잔여 5** (P2 1 : R-3 · P3 4 : R-4~R-7). P1 회귀 0 |
| 빌드 | 통과 |
| 완료 조건(P0·P1 잔여 0, 빌드 통과) | **충족** (재검증 1/2 기준) |

## 2. 영역별 audit 점수 전/후 (20점, 소스 정독 기반)

점수는 audit.md의 5개 차원(접근성·성능·테마·반응형·안티패턴, 각 0~4)으로 매김. 렌더 확인은 공개 화면(로그인 화면, 404, 헤더, status-guide, flow, docs)만 가능.

| 영역 | 전 | 후 | 차원 (A11y/Perf/Theme/Resp/Anti) | P0 전→후 | P1 전→후 | 비고 |
|---|---|---|---|---|---|---|
| shell | 13 | 15 | 3/3/3/3/3 | 0→0 | 6→0 (S-4는 보류·승인) | R-1 해소(재검증). forced-colors 규칙 유지. 320px 스크롤바 6px 넘침(R-7) |
| list | 14 | 16 | 3/3/3/3/4 | 0→0 | 5→0 | 재검증으로 L-1·L-2 해결. 번호 링크의 행 강조 배경(primary-6)은 약하지만 UA 링이 함께 보임 |
| detail | 13 | 17 | 3/3/4/4/3 | 0→0 | 6→0 (D-6은 보류·승인) | R-1 해소로 포커스 표시 회복. 번호 목록 표시 충실도(R-3, P2)는 남음 |
| dashboard | 13 | 16 | 3/3/4/3/3 | 0→0 | 4→0 | R-2 해소로 H-4 해결. R-4·R-5(P3) 남음. 320px는 렌더 불가 |
| admin | 14 | 16 | 3/3/3/4/3 | 0→0 | 5→0 | R-1 해소. 제외 완료 뒤 포커스 유실(R-6, P3) |
| docs | 13 | 16 | 3/3/3/4/3 | 0→0 | 5→0 | 포커스 가능한 요소 전부 링 확인(CDP), 320px 칩 제목 확인 |

참고 : 수정 전 통합표의 P1 원본 합계 34(중복 제거 약 31)는 audit+critique 합산이고, 이 표의 P1 열은 통합표 §2 ID 목록 기준임.

## 3. P1 해결 판정 (실제 코드 확인)

| ID | 판정 | 근거 (파일:라인) |
|---|---|---|
| S-1 | 해결 | CsrPasswordDialog.vue:22-52 (열 때 첫 입력으로 포커스, Tab 트랩, 닫을 때 원래 버튼으로 복귀), :13 Esc, :86-88 완료 후 닫기 버튼으로 포커스 |
| S-2 | 해결 | CsrPasswordDialog.vue:156-171 `aria-invalid`·`aria-describedby`, 아이콘 + 「(현재 n자)」 문구로 색 단독 전달 해소 |
| S-3 | 해결 (렌더 확인) | AppTopbar.vue:558-574. CDP 320×640에서 헤더 오른쪽 끝 = 320px, 넘침 없음(404는 scrollWidth=clientWidth=320). 데스크톱의 일반 스크롤바(6px)가 있으면 6px 가로 넘침 → R-7(P3) |
| S-4 | 보류(승인됨) | Q1. 푸터 「Copyright © ASEOA」 그대로(렌더 확인) |
| S-5 | 해결 | NotFoundPage.vue:12-25 한·인니 병기, `lang` 속성, `<main>` (렌더 확인) |
| S-6 | 해결 (렌더 확인) | AppTopbar.vue:519-533 opacity 제거, 테두리 + 중립 아바타. 1440px에서 「? Masuk」 버튼이 선명함. 320px에서는 「?」 아바타만 보임(이전과 같음, `aria-label`=이름) |
| L-1 | 해결 (재검증) | CsrListPage.vue:352 `<button class="sort-btn">`. 1차에는 R-1 때문에 포커스가 보이지 않아 부분 해결이었으나, `618cfba` 이후 UA 기본 링이 표시됨(CDP 주입 실측) |
| L-2 | 해결 (재검증) | CsrListPage.vue:376-389 `role=button` 제거, 번호 `router-link` 추가. 1차에는 포커스 표시가 primary-6 배경뿐이었으나, 재검증에서 UA 기본 링이 함께 표시됨 |
| L-3 | 해결 | CsrListPage.vue:195-207, :390-392 「(삭제)/(dihapus)」·설정 안내 이중언어 |
| L-4 | 해결 | CsrListPage.vue:120 `COL_COUNT = 6`, :637-650 |
| L-5 | 해결 | CsrListPage.vue:136-147 프리셋 활성 계산 + `aria-pressed`, `.is-set` 셀렉트 블루 표시 |
| D-1 | 해결 | CsrDetailPage.vue:1372 검증 이력, :1489 변경 로그를 `.table-scroll`로 감쌈 |
| D-2 | 해결 | CsrDetailPage.vue:1585-1593 576px 미만 1열, :1607-1616 줄바꿈 허용·말줄임 제거 |
| D-3 | 해결 | CsrDetailPage.vue:470-474 다른 절을 작성 중이면 덮어쓰기 전에 확인, :610-645 절별 dirty 분리 |
| D-4 | 해결 | CsrDetailPage.vue:861-875 미등록 안내 + 다시 확인 / 다른 계정 / 목록 |
| D-5 | 해결 (Q3) | CsrDetailPage.vue:204-264 `renderMd`. XSS 점검은 §4 (a) 참조. 표시 충실도 P2 → R-3 |
| D-6 | 보류(승인됨) | Q4. 정책 변경 없이 안내문만 추가함(CsrDetailPage.vue:952-955 `verify_note`) |
| H-1 | 해결 | CsrDashboardPage.vue:263-264, :309-310 `li role=button` → `RouterLink` + stretched link |
| H-2 | 해결 (코드, 렌더 불가) | CsrDashboardPage.vue:619-648 520px 미만 2단 grid-template-areas |
| H-3 | 해결 | CsrDashboardPage.vue:146-148 |
| H-4 | 해결 (재검증) | CsrDashboardPage.vue:133-142 `LIST_RESET` + `listTo`로 나머지 필터를 기본값으로 명시. 1차 R-2 시나리오 3건 모두 해소(§0) |
| M-1 | 해결 | CsrAdminPage.vue:465 `.table-scroll` 래퍼(전역 정의 사용, 로컬 정의 제거) |
| M-2 | 해결 | CsrAdminPage.vue:34-47 화살표·Home·End 키, :325 roving tabindex, :689-692 포커스 링, `min-height:36px` |
| M-3 | 해결 | CsrAdminPage.vue:188-227, :424-463 화면 안 패널(취소 / 역할만 제외 / 계정까지 삭제). 의미 보존은 §4 (b) |
| M-4 | 해결 | CsrAdminPage.vue:86, :96-97, :132, :142, :183, :210-215 등 이중언어 |
| M-5 | 해결 | CsrAdminPage.vue:263-267 인니어 안내 정보량을 한국어와 맞춤 |
| G-1 | 해결 (렌더 확인) | CsrCoreDocsPage.vue:67-79 `aria-label`·`title`, :290-304. 320px에서 「DOC-01 Definisi Ruang Lingkup」 칩 확인 |
| G-2 | 해결 (렌더 확인) | CsrFlowPage.vue:138-151, :186-206 탭 ARIA·roving·화살표 키, 포커스 링 있음(CDP) |
| G-3 | 해결 (렌더 확인) | CsrFlowPage.vue:259-299 `tabindex=0 role=region` + 이름, 포커스 링 있음(CDP) |
| G-4 | 해결 (Q2 접기) | CsrStatusGuidePage.vue — §2·§4~6을 `FOLD_SECTIONS` 접힘으로 옮김(렌더 확인). 부제 「Instruksi kerja …」는 남음(P3) |
| G-5 | 해결 | 60건 → 「전체 건」, 3개 언어 → 정리, 자기모순 문장 정리. 남은 문장 `itStatus = COMPLETED AND itStatus ≠ VERIFIED`는 같은 말을 반복함(P3) |

집계(재검증) : 해결 28 · 부분 0 · 미해결 0 · 보류(승인됨) 2 (S-4, D-6). 1차 : 해결 25 · 부분 3

## 4. 신규 회귀 점검 (a)~(e)

### (a) CsrDetailPage 경량 마크다운 v-html XSS — **안전**
- `renderMd`(CsrDetailPage.vue:204-264)는 줄마다 `escapeHtml`(& < > " ')을 **먼저** 적용한 뒤 정규식으로 태그를 넣음. 그래서 입력에서 나온 `<`·`"`는 전부 엔티티가 됨
- 코드가 넣는 태그는 `h4·p·strong·ul·ol·li·br`뿐이고, 속성은 `class="lv${level}"` 하나인데 값은 계산된 숫자(0~3)임. 링크·이미지·원시 HTML은 변환하지 않음
- `md()`는 이중언어 제목 줄만 고르는 텍스트 함수라 HTML을 만들지 않음. `v-html` 사용처 3곳(:1119, :1131, :1289) 모두 `renderMd`를 거침
- 표시 충실도 회귀(R-3, P2) : 빈 줄 때문에 `<ol>`이 나뉘면 매번 1부터 다시 번호를 매김(「1. a ⏎⏎ 2. b」 → 1, 1). 시작 번호(`3.`)를 무시함. `<pre>`에서 보존되던 앞 공백 들여쓰기와 표(`|`) 정렬이 사라짐

### (b) CsrAdminPage 사용자 제외 패널 — **의미 보존됨**
- 서버 호출 순서가 그대로임 : `csr_user_roles` delete → (`dropAccount`일 때만) `admin.removeUser`(CsrAdminPage.vue:203-216)
- 이전 대응 : 첫 confirm 취소 = 아무것도 안 함 → 「취소」, 두 번째 confirm 확인 = 계정 삭제 → 「계정까지 삭제」, 두 번째 취소 = 역할만 → 「역할만 제외」
- 자기 자신 차단 유지(:191-194). 실패하면 패널이 남아 다시 시도할 수 있음. 처리 중 버튼 비활성화
- 경미 : 성공 후 패널이 사라지면 포커스가 body로 빠짐(R-6, P3)

### (c) Dashboard RouterLink 쿼리를 목록이 읽는지 — 1차 : 읽지만 결과가 어긋날 수 있음 (R-2, P1) → **재검증 : 해소(§0)**
- CsrListPage.vue:35-53 `FILTER_DEFAULTS`에 `itStatus·verification·pic`이 있어 진입할 때 반영되고, stores/issues.js:108-116 필터도 세 키를 모두 씀. 링크 계약 자체는 유효함
- 그러나 `applyQueryToFilters`는 **쿼리에 있는 키만 덮어쓰고** 나머지는 Pinia 스토어에 남은 값을 유지함(:46-51. 대시보드 주석 :50-52도 이를 의도라고 적음). 재현 예 :
  1. 목록에서 「IT부서용」 프리셋(`excludeVerified=true`) → 대시보드 「Verified 20」 클릭 → `/csr?itStatus=Verified` → **빈 목록**
  2. 목록에서 검색어나 `priority=S1`을 걸어 둠 → 대시보드 「Open 12」 → 12건보다 적게 나옴
  3. 「Total」·합계 링크(`listTo()`, 쿼리 없음) → 직전 필터가 그대로 남음
- 「숫자를 누르면 그 숫자의 목록」이라는 H-4의 약속이 깨지므로 P1로 판정함. 대시보드 링크가 나머지 필터를 기본값으로 명시하거나, 목록이 쿼리 진입 시 reset 후 적용하면 해소됨
- 경미(R-4, P3) : 담당자 집계는 `it_pic.trim()`(Dashboard:103), 목록 필터는 원값 일치(issues.js:116). 앞뒤 공백이 있는 담당자는 링크 결과가 0건이 됨

### (d) CsrListPage 행 클릭 + 번호 링크 이중 이동 — **이중 이동 없음**
- `router-link @click.stop`(CsrListPage.vue:383-389) : RouterLink가 렌더하는 `<a>`에 fallthrough 리스너가 병합되어 `navigate` 1회 실행 후 전파가 멈춤 → `tr @click` 미실행
- Ctrl/⌘ 클릭 : `navigate`가 보조키를 무시해 기본 동작(새 탭)만 일어나고, stop 때문에 현재 탭은 이동하지 않음. 정상
- 키보드 Enter는 `<a>`에서만 처리되고, tr에는 키 핸들러가 없어 중복이 없음

### (e) 전역 `:focus-visible{outline:2px solid transparent}` — 1차 : 회귀 확인 (R-1, P1) → **재검증 : 해소(§0, CDP 실측)**
- asm-theme.css:210-213 author 규칙이 UA 기본 `:focus-visible{outline:auto}`를 덮어씀. 그래서 **자체 포커스 스타일이 없는 모든 요소의 포커스 표시가 사라짐**(forced-colors 모드에서만 Highlight로 나타남)
- CDP 실측(404 화면에 일반 `<a href>`·스타일 없는 `<button>`·`<input type=checkbox>`를 주입해 포커스) :
  - 규칙 적용 시 : `outline: solid 2px rgba(0,0,0,0)`, box-shadow 없음 → **보이지 않음**
  - 규칙 제거 시 : `outline: auto 1px rgb(16,16,16)` → 보임
- 공개 화면(로그인·헤더·404·status-guide·flow·docs)의 포커스 가능한 요소는 모두 자체 box-shadow 링이 있어 영향 없음(CDP로 전부 OK 확인)
- 영향받는 요소(인증 화면, 소스로 확인. 모두 자체 focus 규칙 없음) :
  - CsrListPage `.sort-btn`(:352), `.no-link`(:383, 대체 표시는 primary-6 배경뿐), 보관 체크박스(:335)
  - CsrDashboardPage `.guide-link`(:197)
  - CsrDetailPage `.shot-open`(:1031), `.log-toggle`(:1413), 라이트박스 Drive 링크(:1475)
  - CsrAdminPage 로그 탭 이슈 `router-link`(:582)
- WCAG 2.4.7(포커스 표시) 위반을 새로 만든 회귀임. 전역 규칙에 `outline-color`만 투명으로 두지 말고, 자체 링이 없는 요소에 `box-shadow: 0 0 0 3px var(--asm-primary-40)`를 주는 전역 기본값을 함께 두면 해소됨

## 5. 신규 회귀 목록

| # | 심각도 | 위치 | 내용 | 상태(재검증) |
|---|---|---|---|---|
| R-1 | **P1** | asm-theme.css:210-213 → list·dashboard·detail·admin | 전역 투명 outline이 UA 포커스 링을 지워 자체 스타일이 없는 버튼·링크·체크박스의 포커스가 보이지 않음(CDP 실측). L-1·L-2를 부분 해결로 만든 원인 | **해소** (`618cfba`) |
| R-2 | **P1** | CsrDashboardPage.vue:53 × CsrListPage.vue:44-53 | 대시보드 수치 링크가 남아 있는 필터와 합쳐져 건수가 어긋나거나 빈 목록이 됨 | **해소** (`618cfba`) |
| R-3 | P2 | CsrDetailPage.vue:204-264 | 경량 마크다운 : 번호 목록이 빈 줄마다 1부터 다시 시작, 시작 번호 무시, 들여쓰기·표 정렬 소실 | 잔여 |
| R-4 | P3 | CsrDashboardPage.vue:103 vs stores/issues.js:116 | 담당자명 trim 불일치 → 공백 포함 이름의 링크 결과 0건 | 잔여 |
| R-5 | P3 | CsrDashboardPage.vue:603-608 | stretched link `::after`가 행 전체를 덮어 제목 `title` 툴팁에 마우스가 닿지 않음 | 잔여 |
| R-6 | P3 | CsrAdminPage.vue:217 | 제외 완료 후 패널이 사라지며 포커스가 body로 빠짐 | 잔여 |
| R-7 | P3 | AppTopbar.vue:558-574 | 320px에서 헤더가 폭을 꽉 채워 일반 스크롤바(데스크톱)가 있으면 6px 가로 넘침. 모바일 오버레이 스크롤바에서는 문제 없음 | 잔여 |

기타 P3(회귀 아님) : StatusGuide 부제가 아직 「작업지시서」 · G-5의 동어반복 조건식 · CsrCoreDocsPage 992px 미만 `.side-item`에 `align-items`가 중복 선언됨

## 6. 렌더 확인 범위와 한계

- 도구 : Chrome 헤드리스(`--screenshot`) + CDP(`Emulation.setDeviceMetricsOverride`·`setFocusEmulationEnabled`, `Runtime.evaluate`). 개발 서버는 `npx vite --port 5199`. 검증이 끝난 뒤 서버와 Chrome 프로세스를 종료함
- 렌더한 화면(1440×900, 320×640) : `/csr`(비로그인 → 로그인 카드·헤더), 404, `/csr/status-guide`, `/csr/flow`, `/csr/docs`, `/csr/docs/DOC-01`
- 스크린샷 : `C:\Users\jerry\AppData\Local\Temp\claude\608e3739f41ff02f\b7ec35fd-8c45-4013-af2b-ecddd14391c7\scratchpad\shots\` (`cdp_*-320.png`, `cdp_*-1440.png`, `docs-viewer-320.png` 등)
- 측정 결과 : 320px에서 scrollWidth − clientWidth = 6(스크롤바 폭)이고 그 밖의 넘침은 없음. flow의 도면 캔버스는 스크롤 영역 안에서 넘치는 것이라 정상
- `--window-size=320` 단순 캡처는 헤드리스 창 최소 폭 때문에 잘려 보였음. 판정에는 CDP 에뮬레이션 결과만 사용함
- **렌더 불가** : 목록 본체·상세·대시보드·관리는 로그인이 필요하고 자격증명이 없어 렌더하지 못함(로그인 시도하지 않음). H-2, D-1, D-2, M-1의 320px 판정과 R-1의 인증 화면 영향은 소스 정독과 주입 실험으로 추정함
- 재검증(`618cfba`) : 같은 CDP 절차로 공개 6개 화면의 포커스 링을 다시 재고, 404 주입 실험과 320px 넘침 측정을 다시 실행함. 끝난 뒤 개발 서버와 Chrome을 종료함
- 검증하지 않은 것 : 실제 터치 제스처, Windows 고대비(forced-colors) 실제 표시, 스크린리더 낭독
