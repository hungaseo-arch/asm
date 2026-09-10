-- =============================================================================
-- ASM CSR (개선요청 관리) — 스키마
--   작업지시서 §3-1 / 적용 대상: Neon 프로젝트 `asm-csm`
--   적용 순서: 001_schema → 002_rls_policies → 003_triggers → 004_seed_roles
--
-- 식별자 접두사는 `csr_` 로 통일합니다 (2026-09-10 확정). 라우트 `/csr`, 원본 Notion DB
-- 「ASM 개선요청 관리 (CSR)」, 이슈번호 체계 CSR-YYYYMM-nnn 과 같은 이름을 씁니다.
--
-- 이 파일은 Neon SQL Editor 또는 psql 로 소스너가 직접 적용합니다 —
-- 절차는 docs/csr/이관절차_콘솔설정.md 를 보십시오.
-- =============================================================================

BEGIN;

-- ─── 역할 (Neon Auth 사용자 → 역할) ──────────────────────────────────────────
-- user_id 는 Neon Auth 가 발급한 식별자(auth.user_id())입니다. Data API 는 public
-- 스키마만 노출하므로 neon_auth 쪽 사용자 정보를 여기로 브리지해 둡니다.
CREATE TABLE IF NOT EXISTS public.csr_user_roles (
  user_id      text PRIMARY KEY,
  email        text NOT NULL,
  role         text NOT NULL CHECK (role IN ('admin', 'it_dept', 'business')),
  display_name text,
  created_at   timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE public.csr_user_roles IS '등록 사용자와 역할. 여기 없는 사용자는 조회조차 불가(익명 차단).';

-- ─── 이슈 본체 (Notion 속성 1:1 매핑, 작업지시서 §4-3) ────────────────────────
CREATE TABLE IF NOT EXISTS public.csr_issues (
  id                bigserial PRIMARY KEY,
  issue_no          text NOT NULL UNIQUE,          -- '02', 'VIII-6', 'CSR-202609-001'
  title_ko          text NOT NULL,                 -- 제목 (Judul)
  title_id          text,                          -- Judul (ID)
  menu_main         text,                          -- 대메뉴 (Menu Utama)
  menu_sub          text,                          -- 중메뉴 (Sub Menu)
  path_menu         text,                          -- 화면경로 (Path Menu)
  issue_type        text,                          -- 유형 (Jenis)
  priority          text,                          -- 중요도 (Prioritas) S1~S4
  go_live_category  text,                          -- 오픈구분 (Kategori Go-Live)
  request_dept      text,                          -- 요청부서 (Divisi Peminta)
  requested_on      date,                          -- 요청일 (Tgl. Permintaan)
  summary_ko        text,                          -- 요약 (Ringkasan)
  summary_id        text,                          -- Ringkasan (ID)
  acceptance_ko     text,                          -- 수용기준 (Kriteria Selesai)
  acceptance_id     text,                          -- Kriteria Selesai (ID)
  related_issues    text,                          -- 관련이슈 (Isu Terkait)
  role_split        text,                          -- 분담 (Pembagian Peran)

  -- IT부서 전용 3속성 + 상태 -------------------------------------------------
  it_status         text NOT NULL DEFAULT 'Open'
                    CHECK (it_status IN ('Open', 'Ongoing', 'Completed', 'Verified', 'On Hold', 'N/A')),
  it_pic            text,                          -- 담당자 (PIC)
  target_release_on date,                          -- 목표배포일 (Tgl. Rilis Target)
  it_reply_summary_ko text,                        -- 회신요약 (Ringkasan Balasan)
  it_reply_summary_id text,                        -- Ringkasan Balasan (ID)

  -- 현업 전용 -----------------------------------------------------------------
  it_decision         text,                        -- IT수용여부 (Keputusan)
  verification_result text,                        -- 현업검증 (Hasil Verifikasi)
  verified_on         date,                        -- 최종검증일 (Tgl. Verifikasi)

  -- 본문 (Notion 페이지 섹션 2·3·6) -------------------------------------------
  findings_md          text,                       -- 2. Findings
  recommendation_md    text,                       -- 3. Recommendation
  business_answer_md   text,                       -- 6. 현업 답변
  business_answered_on date,

  -- 메타 ----------------------------------------------------------------------
  is_archived  boolean NOT NULL DEFAULT false,     -- '(삭제)' 접두 레코드
  notion_url   text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  updated_by   text
);
COMMENT ON COLUMN public.csr_issues.is_archived IS 'Notion 이슈번호의 (삭제) 표기를 보존합니다 — 행을 지우지 않습니다(작업지시서 §8).';
COMMENT ON COLUMN public.csr_issues.it_status IS 'business 역할은 Completed → Verified 전이만 가능(003_triggers.sql).';

-- 목록 화면의 기본 정렬·필터를 받쳐 주는 인덱스 (작업지시서 §5-2)
CREATE INDEX IF NOT EXISTS csr_issues_issue_no_idx  ON public.csr_issues (issue_no);
CREATE INDEX IF NOT EXISTS csr_issues_it_status_idx ON public.csr_issues (it_status);
CREATE INDEX IF NOT EXISTS csr_issues_menu_idx      ON public.csr_issues (menu_main, menu_sub);
CREATE INDEX IF NOT EXISTS csr_issues_it_pic_idx    ON public.csr_issues (it_pic);
-- 아카이브는 기본 숨김이라 '표시 대상 60건' 조회가 대부분입니다.
CREATE INDEX IF NOT EXISTS csr_issues_active_idx    ON public.csr_issues (issue_no) WHERE NOT is_archived;

-- ─── 5. IT부서 회신 (회차별) ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.csr_it_replies (
  id             bigserial PRIMARY KEY,
  issue_id       bigint NOT NULL REFERENCES public.csr_issues(id) ON DELETE CASCADE,
  replied_on     date NOT NULL,
  decision       text,        -- Keputusan
  fix_plan       text,        -- Perbaikan
  note           text,        -- Penjelasan tambahan
  needs_decision text,        -- Hal yang perlu diputuskan
  pic_and_target text,        -- PIC · Target rilis
  created_by     text,
  created_at     timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS csr_it_replies_issue_idx ON public.csr_it_replies (issue_id, replied_on DESC);

-- ─── 7. 검증 이력 ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.csr_verifications (
  id          bigserial PRIMARY KEY,
  issue_id    bigint NOT NULL REFERENCES public.csr_issues(id) ON DELETE CASCADE,
  verified_on date NOT NULL,
  result      text NOT NULL,  -- Hasil
  note        text,           -- Keterangan
  created_by  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS csr_verifications_issue_idx ON public.csr_verifications (issue_id, verified_on DESC);

-- ─── 1. 캡쳐 (Google Drive) ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.csr_attachments (
  id            bigserial PRIMARY KEY,
  issue_id      bigint NOT NULL REFERENCES public.csr_issues(id) ON DELETE CASCADE,
  drive_file_id text NOT NULL,
  file_name     text,
  caption       text,
  sort_order    int NOT NULL DEFAULT 0,
  uploaded_by   text,
  created_at    timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS csr_attachments_issue_idx ON public.csr_attachments (issue_id, sort_order);

-- ─── 상태 전이 로그 (트리거가 자동 적재) ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.csr_status_log (
  id          bigserial PRIMARY KEY,
  issue_id    bigint NOT NULL REFERENCES public.csr_issues(id) ON DELETE CASCADE,
  changed_at  timestamptz NOT NULL DEFAULT now(),
  changed_by  text,
  column_name text NOT NULL,
  old_value   text,
  new_value   text
);
CREATE INDEX IF NOT EXISTS csr_status_log_issue_idx ON public.csr_status_log (issue_id, changed_at DESC);

-- ─── 이슈번호 자동 채번 (작업지시서 §5-4a) ───────────────────────────────────
-- 신규 등록분만 CSR-YYYYMM-nnn 을 씁니다. 이관분(01~38, VIII-1~6)은 원문 그대로 두므로
-- LIKE 로 걸러 해당 월의 최대값에만 +1 합니다.
--
-- 월 경계는 WIB(Asia/Jakarta) 기준입니다 — 사용자가 현지에서 등록하므로 UTC 로 계산하면
-- 저녁 등록분이 다음 달 번호를 받습니다.
--
-- 동시 등록이 겹치면 같은 번호가 나올 수 있으나 issue_no 의 UNIQUE 제약이 두 번째를
-- 거부합니다(프론트에서 재시도).
CREATE OR REPLACE FUNCTION public.csr_next_issue_no()
RETURNS text
LANGUAGE plpgsql
STABLE
AS $fn$
DECLARE
  ym  text := to_char(now() AT TIME ZONE 'Asia/Jakarta', 'YYYYMM');
  seq int;
BEGIN
  SELECT COALESCE(MAX(NULLIF(split_part(issue_no, '-', 3), '')::int), 0) + 1
    INTO seq
    FROM public.csr_issues
   WHERE issue_no LIKE 'CSR-' || ym || '-%'
     AND split_part(issue_no, '-', 3) ~ '^[0-9]+$';

  RETURN 'CSR-' || ym || '-' || to_char(seq, 'FM000');
END;
$fn$;
COMMENT ON FUNCTION public.csr_next_issue_no() IS '신규 등록용 이슈번호 CSR-YYYYMM-nnn (WIB 기준 해당 월 최대값 +1).';

COMMIT;
