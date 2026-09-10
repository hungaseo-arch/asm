# ASM CSR v1.1 완료보고 — 목업 사이트 잔여 작업

- 작성일: 2026-09-10 · 작성: Claude(작업지시서 v1.1 수행) · 검수: 서종환
- 저장소: `hungaseo-arch/asm` (`main` 푸시 = GitHub Pages 배포 `hungaseo-arch.github.io/asm/csr`)
- DB 반영: **완료(2026-09-10)** — `db/015`(1~5 문장) · `015b` · `015c` · `016` · `017` · `018` · `019`. 015 는 콘솔에서
  6번째 문장(가드)이 ERROR 로 끝나 015b/015c 로 나눠 재실행(본문 ASCII 화). 화면은 종전 표기와 코드를 둘 다 읽습니다.
- 스크린샷: `docs/csr/shots/v1.1_*.png` (헤드리스 Chrome 1440×900, 계정 alya/business, 한국어 모드)

---

## [CSR-1.1-A] `csr_issues` UPDATE 403 — 원인 · 조치

- **원인(실측)**: business·admin 모두, 값이 안 바뀌는 PATCH 조차 `403 42501 permission denied for schema auth`.
  컬럼 가드(003/011, SECURITY INVOKER)가 `auth.user_id()` 를 직접 부르는데 `authenticated` 역할에 `auth` 스키마
  권한이 없음. 009 의 GRANT 는 실측 결과 남아 있지 않았음(Neon Auth Beta — 스키마 재생성 시 GRANT 소실).
  RLS 정책(002)은 정상 — 정책 누락이 아니라 트리거 안의 권한 오류였음.
- **조치**: `db/015_rls_guard_v2.sql`
  - `public.csr_actor_id()` — `auth.user_id()` 의 SECURITY DEFINER 래퍼. GRANT 에 기대지 않음.
  - 컬럼 가드 v2 — R&R(2026-09-08) 반영. admin·business(현업·총괄팀): IT 전용 컬럼 제외 전부, `it_status` 는
    Completed → Verified 만. it_dept: `it_status`(Verified 제외) · `it_pic` · `target_release_on` ·
    `it_decision`(IT수용여부, 현업 → IT 로 이관) · `it_reply_summary_ko/id`.
  - 상태 로그 트리거도 래퍼 사용, `verified_on` 감시 추가.
  - 프론트 거울: `config.js CSR_POLICY / canEditColumn`, 상세 편집 폼(현업은 Completed 건만 IT상태 셀렉트 = Completed·Verified,
    IT 는 Verified 제외).
- **변경 파일**: `db/015_rls_guard_v2.sql`, `src/modules/csr/config.js`, `src/modules/csr/views/CsrDetailPage.vue`
- **검증(적용 후, Data API · business/alya · CSR-202609-001 대상)**: 같은 값 PATCH **200** · 일반 컬럼(관련이슈) 변경 **200**(되돌림) ·
  `it_pic` **403** `column it_pic not editable by role business (IT department only)` · `it_decision` **403** ·
  `it_status Open→Ongoing` **403** `(Completed to Verified only)`. `updated_by` 에 사용자 ID 기록(래퍼 동작).
  적용 전 실측: 같은 값 PATCH 도 403 `permission denied for schema auth`. admin·it_dept 계정 시나리오(H-1·H-2)는 서종환 실행.
- **리스크**: admin 이 IT 전용 컬럼(담당자·목표배포일·IT수용여부·회신요약)을 화면에서 못 고치게 됨 — 지시서 A-2 그대로.
  잘못 들어간 IT 값 정정은 콘솔(SQL)로.

## [CSR-1.1-B] 검증 이력 등록 → 헤더 자동 동기화

- **조치**: `db/017_verification_sync.sql` — `AFTER INSERT ON csr_verifications` (SECURITY DEFINER).
  `verified_on` = 이력 일자, `verification_result` = 이력 결과 코드. **이력 일자가 기존 최종검증일보다 앞서면 덮어쓰지 않음.**
  가드(015)는 소유자 세션을 통과시키므로 business 가 이력을 넣어도 헤더 갱신이 막히지 않음. 상태 로그에는 이력을 넣은
  사용자가 변경자로 남음.
- 화면: 이력 등록 성공 후 헤더·상태 로그를 **서버에서 재조회**(`refreshIssue`) 하고 목록 행에도 반영(`issues.replaceRow`).
  낙관적 갱신 없음.
- **변경 파일**: `db/017_verification_sync.sql`, `CsrDetailPage.vue`, `stores/issues.js`
- **검증(적용 후)**: 019 의 이력 INSERT → CSR-202609-001 헤더 PENDING / 2026-09-10 자동 세팅. 과거 일자(2026-09-09, NOT APPLIED)
  이력을 Data API 로 넣어도 헤더는 PENDING / 09-10 유지(덮어쓰지 않음). ※ 이 테스트 행(csr_verifications id 266)은 삭제 대상.
  H-3(`/csr/13` REJECTED 추가)은 서종환 실행.
- **리스크**: 이력 **수정·삭제**는 동기화하지 않음(지시서 범위 밖, 화면에도 기능 없음).

## [CSR-1.1-C] 현업검증 상태 코드 표준화

- **코드 5종**: PENDING · NOT APPLIED · PARTIAL · ACCEPTED · REJECTED (변경 금지). IT상태 4단계 유지.
- **DB**: `db/016_verify_status_codes.sql` — `verification_result_legacy` · `result_legacy` 컬럼에 원문 보존 → 코드 일괄
  매핑 → CHECK 제약. 검증 이력의 기록성 값(최초 발견·제안·접수 60행)은 PENDING + legacy 보존, 화면에서 원문 곁들임.
- **상수 1곳**: `src/modules/csr/status.js` — 코드·ko·id·설명·톤·종전 표기·`mapLegacyVerifyStatus`·`PENDING_VERIFICATION`
  (검증 대기 정의) · `NOTION_VERIFY_OPTION`(코드 ↔ 노션 옵션명) · `TRANSITION_RULES`. `config.js` 는 다시 내보내기만.
- **화면**: 배지 = 영문 코드, 툴팁 = `ko / id — 설명`. 색: PENDING 회색 · NOT APPLIED 빨강 · PARTIAL 노랑 · ACCEPTED 초록 ·
  REJECTED **주황**(`.asm-badge--orange` 신설). 검증 이력 폼 `결과` = select(5 코드, "PENDING · 미검증 · Menunggu Verifikasi").
  헤더 편집 폼 현업검증 select 도 같은 라벨. 목록 상단 현업검증 필터(`PENDING (미검증)` 꼴) 신설.
  범례 컴포넌트 `CsrStatusLegend.vue` — 목록·상세 상단 우측, 접기 가능, IT상태 4행 + 현업검증 5행(Code·한국어·인니어·설명)
  + 전환 규칙 3개 언어. 대시보드 교차표 열은 코드 순(PENDING → REJECTED).
- **변경 파일**: `db/016_verify_status_codes.sql`, `status.js`(신규), `components/CsrStatusLegend.vue`(신규), `config.js`, `i18n.js`,
  `stores/issues.js`, `views/CsrListPage.vue`, `views/CsrDetailPage.vue`, `views/CsrDashboardPage.vue`,
  `views/CsrStatusGuidePage.vue`, `src/assets/asm-theme.css`
- **검증**: 적용 전(종전 표기) 교차표 22·20·5·12·1 = 60 으로 변경 전과 동일. 적용 후 Data API: 이슈 64건(아카이브 포함) 전부 코드,
  이력 156행 미매핑 0 · 원문 보존 155. 배포본 목록 61건 한국어 배지 0, 교차표 PENDING 23 · NOT APPLIED 18 · PARTIAL 7 · ACCEPTED 11 ·
  REJECTED 2 = 61(D 정정 + 신규 1건 반영). 필터·폼 select 5개, 범례 4행·5행·규칙 2건.
- **리스크**: 노션 재동기화 시 코드 → 옵션명 변환 필요(`NOTION_VERIFY_OPTION` 준비만 됨, 동기화 코드 없음).

## [CSR-1.1-D] 데이터 정정

- `db/018_data_fix_20260910.sql` — 지시서 표 12행 그대로(08 REJECTED · 09/22 PARTIAL · 나머지 최종검증일 2026-09-10).
  017 원칙(헤더 = 최신 이력)을 지키려고 **08 의 2026-09-10 이력(id 256, 종전 미검증) 결과도 REJECTED** 로 맞춤 — 그 이력의
  내용("Import Cost 1건 · SKU 열·탭 부재")이 정정 근거이기 때문. 60 의 09-10 이력 본문 교체(원문 ID, 한국어는 번역).
  02 담당자 `Import` — 노션 원본도 `Import`(사람 아님) → 공란.
- **검증(적용 후)**: 02 담당자 NULL · 08 REJECTED/09-10 · 09 PARTIAL/09-10 · 13 REJECTED/09-10 · 22 PARTIAL/09-10 · 23 NOT APPLIED/09-10 ·
  27/28/30 ACCEPTED/09-10 · 60 PARTIAL/09-10. 08 이력 256 REJECTED, 60 이력 264 본문 "Pengecekan server produksi…". 상세 08 상태 로그 2건.
  스크린샷 `v1.1_detail_08_head.png` · `v1.1_detail_08_verif.png`.

## [CSR-1.1-E] 신규 CSR-202609-001

- `db/019_new_issue_202609_001.sql` — `csr_next_issue_no()` 가 `CSR-202609-001` 을 돌려줄 때만 등록(1회 1건). 검증 이력
  1행(2026-09-10 PENDING) 동반, 017 이 헤더를 맞춤. 화면경로는 영문 규칙(`Filter dropdown`). 한국어 번역(개선 의견·수용기준·
  검증 내용)은 Claude — 검수 대상. `findings_md`(현상)는 지시서에 없어 비움.

- **검증(적용 후)**: id 101 · 목록 최하단(60 다음) 노출 · 상세 정상(PENDING · 미회신 · Open). `next_no = CSR-202609-002`.
  스크린샷 `v1.1_H5_list_bottom.png` · `v1.1_H5_detail_new.png`.

## [CSR-1.1-F] 27번 분리 — 승인됨(2026-09-10) → `db/020_split_27_202609_002.sql`

- CSR-202609-002 「결제조건(Payment Term) 이력 보존 — 전표 생성 시점 값 저장」 등록(27 과 같은 메뉴·경로, 개선 · S3 · 오픈 後,
  관련이슈 27) + 검증 이력 1행(PENDING, 분리 사실). 27 은 관련이슈에 `CSR-202609-002` 추가, 수용기준 후단 "마스터 변경 시 기존
  전표 소급 없음" 삭제, 검증 이력에 분리 기록(ACCEPTED 유지 → 헤더 변화 없음). 번역은 Claude — 검수 대상.
- **검증(적용 후, 2026-09-10)**: 002 등록(Open · 미회신 · PENDING · 09-10, 관련이슈 27), 27 관련이슈 `37 · CSR-202609-002` · 이력 5행(분리 기록 추가) · ACCEPTED 유지.
- 테스트 행 266 삭제 확인(2026-09-10).

## [CSR-1.1-G] 소규모 결함

- SPA 직접 진입: 배포 워크플로가 `404.html` = `index.html` 사본을 이미 둠. 실측 `https://hungaseo-arch.github.io/asm/csr/08`
  → HTTP 404 이지만 본문은 앱(index) → 라우터가 상세를 그림(정상). `asm.ascendotyre.com` 은 별도 nginx 배포본이라 대상 외.
- 검증·회신 일자 기본값 = **WIB**(`dates.js todayWib`, 라벨 「일자 (WIB)」). 종전엔 브라우저 UTC 기준.
- 목록 담당자 열: 정렬은 기존, **담당자 필터** 신설. 값 정리는 02 `Import` → 공란(D) 외 미실시(Lestari · Firman 병기 1건 등은
  노션 원본 그대로).
- 상태 변경 로그: 적재 트리거는 있었으나 모든 UPDATE 가 403 이라 0건. A 적용 후 자동 적재됨(`verified_on` 도 감시).

## H. 검증 시나리오 — 배포 후 확인 결과

| # | 시나리오 | 결과 |
|---|---|---|
| 1 | admin `/csr/09` PARTIAL · 09-10 저장 → 목록 반영 | **확인(서종환, 2026-09-10 15:51 UTC)** — 09 `updated_by` = admin ID, 저장 성공 |
| 2 | `/csr/30` VERIFIED 전환 성공 · OPEN 되돌리기 거부 | **확인** — 상태 로그 69 `Completed → Verified` (변경자 admin ID). 전환 뒤 편집 폼에서 IT상태 칸 잠김(되돌리기 불가) 실측 |
| 3 | `/csr/13` 검증 추가 REJECTED → 헤더 자동 갱신 | **미실행** — 13 에 새 이력 없음. 트리거 동작 자체는 CSR-202609-001·002 로 확인(로그 68 `verified_on null → 09-10`) |
| 4 | 「검증 대기」 = 08 · 13 · 27 · 28 · 30 (5건) → 30 VERIFIED 후 4건 | **확인** — 적용 전 5건(`v1.1_H4_list_pending.png`), 30 전환 후 08 · 13 · 27 · 28 4건 |
| 5 | CSR-202609-001 목록 최하단 · 상세 정상 | **확인** — `v1.1_H5_*.png` |
| 6 | `hungaseo-arch.github.io/asm/csr/08` 직접 진입 | **확인** — 앱이 그려지고 로그인 안내 표시(404 페이지 아님) |

- 테스트 잔재(csr_verifications id 266) — 삭제 완료(2026-09-10 실측 0행).
- **주의**: H-2 직후(15:52 UTC) 30 의 현업검증이 편집 저장으로 `ACCEPTED → PENDING` 으로 바뀜(로그 70, 이력 추가 없음). 편집 폼은
  현재 값을 그대로 띄우므로(04 번 실측 ACCEPTED) 셀렉트에서 고른 값이 저장된 것. Verified 건이 PENDING 인 상태라 ACCEPTED 복구 필요.

## 잔여 리스크

1. `db/015~019` 는 콘솔에서 사람이 실행 — 순서가 어긋나면 016 의 CHECK 제약이 018/019 를 막음(파일 머리에 순서 명시).
2. admin 의 IT 컬럼 편집 불가는 R&R 결정 사항 — 운영 중 정정 요청이 늘면 admin 예외를 다시 논의.
3. 노션은 여전히 종전 표기 — 재동기화 시 매핑 필요.
