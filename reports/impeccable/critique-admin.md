# impeccable critique — admin (src/modules/csr/views/CsrAdminPage.vue)

**총점 25/40 · 등급 Acceptable (20–27)** · P0 0 · P1 5 · P2 8 · P3 4

Method: ⚠️ DEGRADED: single-context (delegated read-only run). Assessment A만 인라인 수행, B(detector·브라우저)는 미실행. 코드 수정 없음. 모드: Operate. 기준: PRODUCT.md, DESIGN.md.

## 휴리스틱 점수

| # | 항목 | 점수 | 핵심 |
|---|------|------|------|
| 1 | 시스템 상태 가시성 | 3 | 로딩·오류·탭 카운트 있음. 저장 중 표시는 버튼 disabled뿐 |
| 2 | 현실 일치 | 3 | 로그에 DB 컬럼명·UUID·`db/044`가 그대로 노출 |
| 3 | 사용자 제어 | 2 | confirm 2연속, 폼이 화면 밖에 열림 |
| 4 | 일관성·표준 | 3 | 제목·표는 공유 클래스. 탭·count-pill·.mono는 DESIGN 이탈 |
| 5 | 오류 예방 | 2 | 파괴 동작 확인이 브라우저 confirm 텍스트 의존 |
| 6 | 인식 우선 | 3 | 권한 3종이 raw 코드(`it_dept`)로만 표시 |
| 7 | 유연성·효율 | 2 | 로그 필터·검색 없음, 탭 키보드 이동 없음 |
| 8 | 미니멀 디자인 | 3 | 탭 라벨과 h2가 중복 |
| 9 | 오류 복구 | 2 | 한글 전용 오류 문구, 인니어 사용자는 원인 안내를 못 받음 |
| 10 | 도움말 | 2 | 힌트 문단이 한·인니 간 내용 불일치 |
| | **합계** | **25/40** | Acceptable |

## 총평

구조(탭 3개 + 공유 `.asm-panel`/`.asm-title`/`.asm-table`)는 DESIGN.md의 Ledger Desk와 잘 맞고 접근성 속성(role=tablist, aria-selected, aria-controls, label 감쌈, autocomplete)도 갖췄다. 약점은 (1) 파괴적 작업의 확인 UX, (2) 이중언어 동등성 붕괴(한글 전용 오류·힌트), (3) 편집·비밀번호 폼이 클릭한 행과 멀리 떨어져 열리는 점, (4) 탭과 count-pill 등 DESIGN 규칙 이탈이다.

잘된 점: 자기 자신 삭제 방지와 행 하이라이트(`tr.me`, L726); 계정 생성 후 역할 INSERT 실패까지 고려한 순서(L148); 로그인 이력 실패가 다른 탭을 막지 않음(L54).

## 이슈 목록

| P | 파일:라인 | 문제 | 추천 명령 | 공유 자원 |
|---|-----------|------|-----------|-----------|
| **P1** | CsrAdminPage.vue:179-191 | 사용자 제외가 `window.confirm` 2연속. 두 번째 문구가 「[확인] 계정까지 삭제 · [취소] 역할만 제외」로, 취소가 안전한 선택이 아니라 다른 동작을 뜻함. 인니어는 `[OK]/[Cancel]`이라 브라우저 로케일 버튼과 안 맞음. 계정 영구 삭제를 취소 버튼으로 구분하는 건 오조작 위험이 큼 | `$impeccable harden` + `$impeccable clarify` (인라인 모달 1개, 선택지 3개: 취소 / 역할만 제외 / 계정까지 삭제) | 아니오 (뷰 전용). 공용 확인 모달이 있으면 재사용 |
| **P1** | CsrAdminPage.vue:72, 82, 169, 199, 206, 118, 129 | 오류·검증 문구가 한글 전용. 인니어 모드에서도 한국어 토스트가 뜸. `t()` 미사용. PRODUCT.md의 이중언어 동등 위반 | `$impeccable clarify` | 아니오 (`useCsrLang` 사용만) |
| **P1** | CsrAdminPage.vue:246-251 | 비밀번호 초기화 실패 토스트가 한글은 원인+우회 절차(`scripts/csr_set_password.mjs`), 인니어는 `Gagal: …`뿐. 복구 안내 정보량이 한쪽에만 있음 | `$impeccable clarify` | 아니오 |
| **P1** | CsrAdminPage.vue:422-466 | 사용자 표에 `.table-scroll` 래퍼가 없음(로그 표 L521, L570에는 있음). 7열 + 3개 링크 버튼 열이 320~768px에서 패널 밖으로 넘치거나 레이아웃을 밀 수 있음. DESIGN.md Layout의 「표는 가로 스크롤 허용」 위반 | `$impeccable adapt` | 아니오 (래퍼 한 줄) |
| **P1** | CsrAdminPage.vue:294-331, 627-643 | 탭 버튼: 포커스 링 정의 없음(`border:0` 리셋, DESIGN은 3px #99c0e8 링 요구), 화살표 키 이동·roving tabindex 없음, hover 상태 없음, 높이 약 32px로 36px 기준 미달 | `$impeccable polish` + `$impeccable harden` | 탭 패턴이 다른 CSR 뷰에도 있으면 공유 후보(`.tabs`는 scoped라 현재는 이 파일 한정) |
| P2 | CsrAdminPage.vue:343, 348, 449 | 「편집」을 눌러도 폼은 표 위(L348)에 열려 긴 목록에서는 화면 밖. 포커스 이동·스크롤 없음. 추가 버튼은 편집 중 사라짐(L343) | `$impeccable layout` / `$impeccable harden` (폼 열릴 때 첫 필드 포커스+스크롤, 또는 행 인라인 편집) | 아니오 |
| P2 | CsrAdminPage.vue:469-505 | 비밀번호 초기화 폼이 표 아래에 열려 대상 행과 분리. 대상 행 하이라이트 없음, 폼 제목은 `<b>`(L470)로 위계 약함 | `$impeccable layout` | 아니오 |
| P2 | CsrAdminPage.vue:389-407, 568 | 힌트 문단이 언어 간 불일치: 한글에는 「소속은 표시·집계용이며 권한과 무관」「초기화 후 헤더 계정 메뉴에서 바꾸게」가 있고 인니어엔 축약. L568 한글만 `db/044` 개발 용어를 사용자에게 노출 | `$impeccable clarify` | 아니오 |
| P2 | CsrAdminPage.vue:541, 548, 271, 583 | 로그 열이 DB 원본값 노출: `column_name` raw, 변경자 이름을 못 찾으면 UUID, 접속 로그도 `user_id` 폴백. 상태 값도 평문이라 Triple Status 배지 규칙 미적용 | `$impeccable clarify` + `$impeccable colorize` (상태값을 공용 배지로) | 상태 배지 컴포넌트가 있으면 공유 |
| P2 | CsrAdminPage.vue:516-571 | 로그 두 표에 검색·필터·기간 선택이 없고 200건 고정. 「이 이슈는 누가 바꿨나」「이 사람 언제 접속했나」에 스크롤뿐 | `$impeccable shape` | 아니오 |
| P2 | CsrAdminPage.vue:644-651 | `.count-pill`이 9999px 알약. DESIGN은 알약을 역할 pill·스크롤바 썸 한정으로 허용. `--asm-primary-soft` 토큰이 asm-theme.css에 있는지 확인 필요 | `$impeccable polish` (4px 배지 또는 숫자만 muted) | `--asm-primary-soft` 토큰은 공유. 존재 여부 확인 |
| P2 | CsrAdminPage.vue:616-619, 405 | `.mono`가 `ui-monospace, Consolas` 사용. DESIGN Don't 「mono 서체 추가 금지, 본문 서체+tabular-nums」 위반 | `$impeccable typeset` | 아니오 |
| P2 | CsrAdminPage.vue:304-316 vs 342, 517 | 탭 라벨과 패널 h2 문구가 동일해 같은 말이 두 번 나옴. 탭 카운트와 h2 `small`(200건) 역할도 겹침 | `$impeccable distill` | 아니오 |
| P3 | CsrAdminPage.vue:449-462 | 편집·비밀번호·제외가 같은 `btn-link` 3개 나열. 파괴 동작(빨강)이 비파괴 링크와 바로 붙음. 36px 터치 기준 미달 | `$impeccable layout` (행 오버플로 메뉴 또는 간격·구분) | 아니오 |
| P3 | CsrAdminPage.vue:441, 446-447, 535 | 날짜 열이 좌측 정렬. DESIGN Tabular Rule은 날짜 열 가운데 정렬 | `$impeccable polish` | `.asm-table` 날짜 셀 클래스(`.date`)가 있으면 공유 |
| P3 | CsrAdminPage.vue:679-684 | 하위 폼 테두리가 `1px dashed`. DESIGN의 1px solid 체계에 없는 변형 | `$impeccable polish` | 아니오 |
| P3 | CsrAdminPage.vue:469-483, 156, 399 | 비밀번호 입력이 `type="text"`로 평문 표시(의도로 보임)이며, 초기 비밀번호가 8초 토스트와 폼 힌트에 상시 노출. 토스트는 놓치기 쉬움 | `$impeccable harden` | 아니오 |
| P3 | CsrAdminPage.vue:279-281 | h1이 영문 `Admin`, 부제만 번역. 한·인니 동등 관점에서 제목이 언어 영향을 받지 않음. 의도라면 무시 | `$impeccable clarify` | 아니오 |
| P3 | CsrAdminPage.vue:520, 567, 284 | 빈 상태가 12px muted 한 줄. 다음 행동 안내 없음. 로딩은 텍스트뿐 | `$impeccable onboard` | 아니오 |

## 페르소나 적색 신호

- **admin 서종환 (파워유저)**: 로그 필터·검색 없음, 탭 키보드 이동 없음, 폼이 시야 밖에서 열림.
- **인니 총괄팀 admin 대행 (이중언어)**: 오류 토스트 한글 전용, 복구 안내 부재.
- **실수하기 쉬운 첫 사용자**: 계정 영구 삭제가 confirm의 「취소」 버튼에 묶여 있음.

## 확인하지 못한 항목

Assessment B(detector, 렌더 확인, 320px 실측)는 읽기 전용 위임 실행이라 수행하지 않았다. `--asm-primary-soft` 토큰 존재, `.asm-table`의 모바일 동작, 헤더 겹침은 소스 기준 추정이다. 스냅샷 저장 없음.

## 권장 순서

1. `$impeccable harden` — 파괴 동작 확인 UI (P1 L179)
2. `$impeccable clarify` — 이중언어 오류·힌트 동등화 (P1 L72~251, P2 L389~568, L541)
3. `$impeccable adapt` — 사용자 표 스크롤 래퍼 (P1 L422)
4. `$impeccable polish` — 탭 포커스·높이·키보드, count-pill, mono, 날짜 정렬
5. `$impeccable layout` — 편집·비밀번호 폼 위치
