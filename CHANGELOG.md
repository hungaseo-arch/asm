# CHANGELOG

ASM Web (Vue 3) 변경 이력. 형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/)
를 따르되, 날짜는 커밋 기준입니다.

이 프로젝트는 아직 버전 태그를 쓰지 않습니다. `main` 에 푸시하면 GitHub Actions 가
Pages 로 배포하므로 **`main` 이 곧 배포본**입니다.

---

## [Unreleased]

### 진행 중

- **010 · 014 번역 검수** — 010(현상·개선 의견·현업 답변 60건) + 014(검증 이력 146행 · IT 회신 42행)
  Claude 번역분의 현업 검수. 담당 **서종환**(2026-09-10 지정). 010 수정은 상세 화면 「편집」(KO·ID 두 칸)으로,
  014 수정은 당분간 SQL(`csr_verifications.note_ko/id` · `csr_it_replies.<col>_ko/id`)
- **`db/014_sub_translations.sql` 적용 완료(2026-09-10)** — §7 검증 이력 · §5 IT 회신 본문의 KO/ID 쌍.
  Data API 실측: 검증 146/146 · 회신 42행 4컬럼 누락 0. 상세 화면 토글로 양방향 표시 확인

- **CSR §1 캡쳐(사진 첨부) 완료(2026-09-10)** — Apps Script 웹앱 배포(실행: 소유자 · 액세스: 모든 사용자),
  `VITE_CSR_UPLOAD_URL` 로컬·Actions 등록, Notion 캡쳐 **38건 전부** Drive 업로드 + `db/012`·`013` 적용.
  내보내기에서 페이지째 빠졌던 6건(04·05·26·36·37·38)은 Notion fetch 의 서명 URL(300초)로 회수.
  Data API 실측: 38행 · 이슈 01~38 각 1건 · 중복 0. 39~60 은 Notion 에도 캡쳐 없음(현지 요청 건).
  상세 §1 썸네일·「+ 캡쳐 추가」·admin 삭제 동작 확인

### 2026-09-10 — 작업지시서 v1.1 (잔여 작업) · DB 015/015b/015c/016~019 적용 완료

- **[A] `csr_issues` UPDATE 403 원인·수정** — 가드가 `auth.user_id()` 를 호출자 권한으로 불러 `permission denied for schema auth`.
  `db/015`: SECURITY DEFINER 래퍼 `csr_actor_id()` + 컬럼 가드 v2(R&R 2026-09-08: admin·business 는 IT 전용 컬럼 제외,
  it_status 는 Completed → Verified 만 / it_dept 는 IT 전용 컬럼만, Verified 불가). it_decision 이 IT 전용으로 이관.
  프론트 `CSR_POLICY`·상세 편집 폼도 같은 규칙. 콘솔에서 015 의 가드 문장이 ERROR → `015b`(가드, ASCII 본문)·`015c`(로그)로 재실행.
  적용 후 Data API 실측: 같은 값 PATCH 200, IT 전용 컬럼·상태 전이 403, updated_by 에 사용자 ID
- **[B] 검증 이력 → 헤더 동기화** — `db/017` AFTER INSERT 트리거(최신 일자만 덮어씀). 화면은 등록 후 서버 재조회 + 목록 행 반영
- **[C] 현업검증 코드 5종** — `db/016`(legacy 컬럼 보존 · 매핑 · CHECK). 상수 1곳 `status.js`. 배지 = 코드 + 툴팁,
  REJECTED 주황(`.asm-badge--orange`), 이력 폼 결과 select, 목록 현업검증·담당자 필터, 범례 컴포넌트(목록·상세, 3개 언어),
  대시보드 교차표 코드 순. 종전 표기도 코드로 읽음(`mapLegacyVerifyStatus`) — 016 적용 전후 모두 동작
- **[D] 데이터 정정** — `db/018`(08 REJECTED · 09/22 PARTIAL · 최종검증일 09-10 · 60 이력 본문 · 02 담당자 공란)
- **[E] 신규 CSR-202609-001** — `db/019`
- **[G]** 검증·회신 일자 기본값 WIB(`dates.js`), 상태 로그 `verified_on` 감시 추가. SPA 404 는 기존 404.html 로 정상
- **[F] 27번 분리** — `db/020` CSR-202609-002 결제조건 이력 보존(승인 2026-09-10, 적용 완료)
- 배포 후 수정(2026-09-11): **로그아웃 불가**(프로덕션 빌드의 옵셔널 호출 → better-auth 프록시 `.call` 경로화) — 프록시 메서드 직접 호출 + `/sign-out`
  보강 · **캡쳐 썸네일** lh3 직접 주소 + Drive 재시도 + 실패 안내
- H 시나리오 1~6 전부 확인(1·2·3 은 서종환 admin 실행). 30 번 현업검증 PENDING 오입력 → ACCEPTED 복구
- 범례·배지 툴팁을 토글 언어 한쪽만(2026-09-11) — Code · 이름 · 설명 3열, 전환 규칙도 해당 언어. 인니어 설명(`desc_id`) 추가
- 목록 열 순서 IT수용여부 → IT상태 → 담당자 → 현업검증, 목표배포일 열 삭제(상세에는 유지)
- 상세 편집 폼에 담당자 입력(2026-09-11) — admin 도 지정 가능(`db/021` 가드 v3), 선택지는 Neon 등록 사용자 이름(csr_user_roles)만.
  이관 데이터의 미등록 이름은 현재 값으로만 남고 바꿀 때는 등록 사용자 중에서 고름
- 보고: `docs/csr/ASM_CSR_v1.1_완료보고.md` · 원문 `docs/csr/작업지시서_v1.1_잔여작업.md`

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
- 상세 §7 검증 이력 · §5 IT 회신 KO/ID 정리 — 결과·수용 여부는 용어 사전(`i18n.termLang`)으로 표시만 바꾸고
  (「조치확인 ↔ Terkonfirmasi」「수용 — Completed ↔ Diterima — Completed」), 자유 텍스트는 `db/014` 의
  `_ko/_id` 쌍을 토글 언어 → 반대쪽 → 원문 순으로 표시(`pairOf`)
- 상세 IT 회신 카드 라벨·값 구분 — 항목마다 옅은 칸(속성 격자와 같은 모양), 라벨 11px 굵은 회색 · 값 14px 본문색
- 결정사항 색 구분 — IT 수용 여부(수용 초록 · 조건부 파랑 · 결정요청 노랑 · 반려 빨강 · 보류/미회신 회색)와
  현업 검증(조치확인 초록 · 부분조치 노랑 · 미조치/Completed 부적정 빨강 · 미검증 회색 · 최초 발견 파랑)을
  배지로 — 상세 속성 격자·§5·§7, 목록, 대시보드 교차표 머리. `config.DECISION_TONE/RESULT_TONE` · `i18n.toneOf`
- `.asm-badge--primary` 추가 — Verified 배지가 정의 없는 톤을 써서 맨색으로 보이던 것
- 목록 툴바 오른쪽에도 언어 토글(국기) — 대시보드와 같은 `CsrLangToggle`, 한쪽에서 바꾸면 전체에 적용
- 상태 기준 페이지 `/csr/status-guide` — 「상태 명칭 표준화 작업지시서」(IT상태 4 · 현업검증 5, ko/en/id/설명)를
  그대로 보여 주는 정적 문서. 대시보드 교차표 제목 오른쪽 「상태 기준 ↗」 링크로 진입. 원문은 `docs/csr/작업지시서_상태명칭표준화.md`.
  §4~§6(영문 코드 배지·범례·매핑 함수) 구현은 별도 착수
- `toneOf` 대소문자 무시 — 'COMPLETED 부적정'(문서 표기)이 DB 값 'Completed 부적정' 과 같은 색이 되도록

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
