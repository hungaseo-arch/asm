# CHANGELOG

ASM Web (Vue 3) 변경 이력. 형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/)
를 따르되, 날짜는 커밋 기준입니다.

이 프로젝트는 아직 버전 태그를 쓰지 않습니다. `main` 에 푸시하면 GitHub Actions 가
Pages 로 배포하므로 **`main` 이 곧 배포본**입니다.

---

## [Unreleased]

### 진행 중

- **CSR §1 캡쳐(사진 첨부)** — Apps Script 업로드 프록시(`scripts/apps_script/`) + 상세 화면
  업로드 UI + Notion 이관분 38건 `csr_attachments` 적재. 미착수
- **DB 적용 완료(2026-09-10)** — `db/008`(화면경로 영어화 54행) · `009`(auth GRANT) · `010`(본문 KO/ID
  쌍 60건) · `011`(가드 콘솔 통과). Data API 로 실측: 화면경로 한글 잔존 0 · 본문 쌍 누락 0.
  010 번역은 검수 대상(화면 편집으로 수정 가능)
- **배포본 동작 확인(2026-09-10)** — Actions Variables 주입 + Neon Auth Domains 등록 후
  https://hungaseo-arch.github.io/asm/csr 로그인·대시보드 정상

### 2026-09-10 (CSR 화면 정리 · 미배포)

- 계정·이름 불일치 수정 — 세션이 `csr_user_roles` 를 `user_id` 로 좁혀 읽음(admin 은 RLS 로
  전원이 보여 첫 행이 헤더에 올라갔음). 0건이면 0.7초 뒤 재시도, 미등록 화면에 「다시 확인」
- 로그아웃 상태 헤더는 「로그인 / Masuk」만 — APP_USER 자리표시자 제거
- 표시 언어를 `stores/identity.js` 로 이동(localStorage 유지) — 헤더 계정 메뉴까지 한 언어
- 상세: 문구 사전(`DICT`)으로 절 제목·라벨·버튼·토스트 전부 KO/ID 분리, 제목 번호 제거,
  잠긴 필드는 편집 폼에서 숨김, 화면경로 전폭 1행 + 경로별 칩(언어 토글 미적용),
  IT 회신 카드 재배치(수용 여부 배지 · 빈 값 숨김), 검증표 줄바꿈·상단 정렬
- 대시보드: 목록 10건 페이지네이션, 「오픈 前 필수」→「검증 대기」, 담당자 표 2열
- 관리: 사용자 추가 시 Neon Auth 계정을 함께 생성(admin 플러그인 `createUser`, 초기 비밀번호
  `ascendo123`) — 콘솔에서 User ID 를 복사하던 입력란 제거. 이미 있는 이메일은 `listUsers`
  로 id 조회. 「제외」 시 계정까지 지울지 선택(`removeUser`)
- 로그인 카드 가운데 정렬

---

## 2026-09-10

### 추가

- **CSR 모듈 Phase 1** — Neon `asm-csm` 스키마 일체 (`82d504d`)
  - 테이블 6종: `csr_user_roles` · `csr_issues` · `csr_it_replies` · `csr_verifications` ·
    `csr_attachments` · `csr_status_log`
  - RLS 정책 16종 + 역할 헬퍼 `csr_role()` + Data API `authenticated` GRANT
  - 컬럼 가드 트리거 `csr_issues_column_guard` · 상태 로그 트리거 `csr_issues_status_log`
  - 이슈번호 채번 함수 `csr_next_issue_no()` (WIB 기준 `CSR-YYYYMM-nnn`)
  - `docs/csr/이관절차_콘솔설정.md` · `docs/csr/보고_Phase1_20260910.md`
- 읽기 전용 점검 SQL 2종 — `db/000_preflight.sql`(적용 전) · `db/verify.sql`(적용 후 11항목) (`b47a8ed`, `0e2e98b`)
- 드로어 포커스 이동 `composables/useDrawerFocus.js` — 열면 드로어 안으로, 닫으면 열었던
  버튼으로 (`8fc3338`)
- 메뉴 드로어에 대분류 칩 — 992px 미만에서 헤더 상단 메뉴가 숨겨져 대분류를 바꿀 방법이
  없던 문제 (`8fc3338`)
- 프로젝트 문서 4종 — `README.md` 갱신 · `ARCHITECTURE.md` · `CONTRIBUTING.md` · `CHANGELOG.md`

### 변경

- **좌·우 레일을 드로어로 전환** (`8fc3338`) — 상시 220px×2 를 차지하던 것을 off-canvas 로
  바꿔 본문에 폭을 돌려줍니다. 1,366px 노트북에서 목록 표의 열이 잘리고 가로 스크롤이
  생기던 문제 해소
- 헤더 브랜드 메뉴 신설 — 요약·알림을 로고 한 곳으로 통합, 화면 제목 복원, 역할 pill 적용
- 회사 표기·버전을 사이드바 하단에서 본문 푸터로 이동 (가이드 7-1)
- 표 고정 열 헤더 배경을 나머지 헤더와 통일, 빈 상태 12px muted (가이드 9-1)
- 요약 카드에 tone 상태색 띠 적용, 카드 제목을 전역 `.asm-title` 로 통일
- `useBodyScrollLock` 에 반응형 인자 추가 + 참조 카운트 — 드로어처럼 마운트된 채 여닫는
  경우를 지원하고, 겹쳐 열릴 때 잠금이 어긋나지 않게 함
- `db/004_seed_roles.sql` 을 실제 Neon Auth 스키마 기준으로 재작성 (`a8dd243`) —
  `neon_auth.users_sync` 는 존재하지 않으며 실제 테이블은 `neon_auth."user"` 입니다

### 수정

- **1,280px 에서 상단 메뉴 잘림** — 새로 추가한 역할 pill 폭(약 140px) 때문에 가운데 열이
  115px 모자라 `PURCHASING` 이 왼쪽으로 잘렸습니다. pill 을 1,400px 이상에서만 표시하고
  `justify-content: safe center` 적용 (`8fc3338`)
- **`issue_no` UNIQUE 제약 충돌** (`ee8fc06`) — 지시서 §4-3 대로 `(삭제)` 접두를 떼면
  `48`·`50`·`52` 가 살아 있는 건과 충돌합니다(3쌍). 삭제 후 같은 번호가 재발급된 정상
  이력이므로 데이터가 아니라 제약을 고쳤습니다 — `WHERE NOT is_archived` 부분 UNIQUE
- 알림 표시 점이 열어 본 뒤에도 남던 문제
- 점검 SQL 7번 기대값이 문장(`'5개 테이블 이상'`)이라 판정식이 늘 어긋나던 문제 (`2c5ee31`)

### 확인 (실측)

- Neon `asm-csm` 프로젝트 생성 · Neon Auth · Data API 활성화 — `001`~`003` 적용,
  점검 11항목 전부 통과. `auth.user_id()` 는 `text` 반환 확인
- Notion 데이터소스 63건, 상태 분포(Open 35 · Ongoing 14 · Completed 5 · Verified 6 ·
  N/A 3)가 지시서 §4-4 기준과 정확히 일치
- 헤드리스 Chrome 실측 — 1280·1366·1440·1600·1920·768·375px 가로 스크롤 0px,
  콘솔 에러·경고 0건

### 알려진 제약

- **Neon Auth 는 가입 제한을 지원하지 않습니다** — 누구나 가입 가능. 다만 모든 SELECT
  정책이 `csr_role() IS NOT NULL` 이라 `csr_user_roles` 에 없는 사용자는 이슈를 한 건도
  보지 못합니다. 운영 중 Users 목록 주기 점검 필요

---

## 2026-09-04

- 목록 화면 UX 개편 및 브랜드 자산 적용 (`9c12dec`)
- `npm run deploy` 스크립트 추가 — `main` 푸시로 Pages 배포 트리거 (`801b072`)

---

## 2026-09-01

### 추가

- **ASM Vue 클라이언트 초기 구축** — Inventory List 화면 (`6eb20af`)
- GitHub Pages 배포 워크플로 (`346d1d2`)
- 화면 시안(asm-mockup) 목록 화면 15개 이식 (`f04964c`)
- Purchasing 8종 · Partners 2종 화면 추가 (`6f2a5fa`)
- 디자인가이드 · 업무프로세스 · 개선의견서 1차 반영 (`5e64c1e`, `01eb049`)
- 개선의견서 기준 메뉴 구조 정렬 (`ad69389`)
- 권한 가이드라인 v3.0 — 역할 · 부서 · 권한/승인 매트릭스 (`f9e3385`)
- 작업 지시서 `workOrder.md` 저장소 추가 (`274c4a4`)

### 변경

- **TypeScript → JavaScript 전량 전환** (`e0c8461`) — 실서버 번들에 TypeScript 흔적이
  없어 지시서 §2 스택에 맞췄습니다. 아이콘도 lucide → Font Awesome, 검증은 zod → yup
- 지시서 §3·§4·§5·§7 정합 — 라우트 · 디렉터리 구조 · HTTP 계층 · 엑셀 (`6cd84e6`)
- 로그인 기능 비활성화 — 백엔드 없는 화면 전용 배포 (`eaa7347`).
  `AuthPage.vue` · `stores/session.js` · `api/auth.js` 는 되살릴 수 있도록 남겨 둠

### 수정

- 아이콘 값 참조 누락으로 화면이 뜨지 않던 문제 (`c7a6252`)
- 문서 정합성 검증 리포트 v2.0 반영 — 메뉴 25종 · 용어 · 표 겹침 (`426afc9`)
- Inventory List 하단 숫자 표기 규칙 안내 블록 삭제 (`38128de`)

---

## 이관 배경

이 저장소는 기존 React 19 + shadcn/Tailwind 클라이언트(`asm-web/apps/client`)를
**Vue 3 + Vite + Bootstrap 5.3** 으로 옮긴 결과물입니다. 스택은 임의로 고른 것이 아니라
운영 서버(`asm.ascendotyre.com`)를 실측해 맞춘 것입니다 —
근거는 [workOrder.md](workOrder.md) §1 을 보십시오.

서버(`asm-web/apps/server`, Hono + Better Auth)는 변경하지 않았습니다.

**의도적 미이관** — Lovable/Skywork 전용 스캐폴드(`lovable-tagger`,
`react-router-dom-proxy`, prerender, CDN 이미지 리라이터), 미사용 shadcn/ui 컴포넌트 49종.
