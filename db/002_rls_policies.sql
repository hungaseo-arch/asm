-- =============================================================================
-- ASM CSR — 행 수준 보안(RLS) 정책
--   작업지시서 §3-2 / 001_schema.sql 적용 후 실행
--
-- 권한의 실제 통제는 전부 DB 에서 합니다. UI 의 비활성 표시는 UX 용일 뿐이며,
-- it_dept 계정으로 verification_result 를 바꾸려 하면 여기와 003_triggers.sql 이
-- 실제로 거부해야 합니다(작업지시서 §9 완료 정의).
-- =============================================================================

-- ★ 선행 조건 ─ **Neon Auth 를 먼저 활성화하십시오.**
--   아래 csr_role() 은 LANGUAGE sql 이라 만들 때 본문이 파싱됩니다. Neon Auth 가 켜지기
--   전에는 auth.user_id() 가 없어 이 파일이 첫 줄부터 실패합니다
--   (ERROR: schema "auth" does not exist). 001 은 auth 와 무관해 먼저 돌려도 됩니다.

BEGIN;

-- ─── 역할 조회 헬퍼 ──────────────────────────────────────────────────────────
-- auth.user_id() 는 Neon Auth 가 JWT 에서 채워 주는 현재 사용자 식별자입니다.
-- 프로젝트에서 이름이 다르면 이 함수 한 곳만 고치면 전 정책에 반영됩니다.
--
-- SECURITY DEFINER 인 이유: 이 함수는 csr_user_roles 를 읽는데, csr_user_roles 에도
-- RLS 가 걸려 있고 그 정책이 다시 csr_role() 을 부릅니다. 호출자 권한으로 두면 무한
-- 재귀가 됩니다. 소유자 권한으로 실행해 RLS 를 우회하고, search_path 를 고정해
-- 검색 경로 변조를 막습니다.
CREATE OR REPLACE FUNCTION public.csr_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $fn$
  SELECT role FROM public.csr_user_roles WHERE user_id = auth.user_id();
$fn$;
COMMENT ON FUNCTION public.csr_role() IS '현재 사용자의 역할(admin/it_dept/business). 미등록 사용자는 NULL — 조회조차 차단됩니다.';

REVOKE ALL ON FUNCTION public.csr_role() FROM PUBLIC;

-- ─── RLS 활성 (Data API 필수 조건) ───────────────────────────────────────────
ALTER TABLE public.csr_user_roles    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.csr_issues        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.csr_it_replies    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.csr_verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.csr_attachments   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.csr_status_log    ENABLE ROW LEVEL SECURITY;

-- 재적용을 위해 기존 정책을 먼저 걷어냅니다 (CREATE POLICY 는 IF NOT EXISTS 가 없습니다).
DROP POLICY IF EXISTS csr_user_roles_select    ON public.csr_user_roles;
DROP POLICY IF EXISTS csr_user_roles_write     ON public.csr_user_roles;
DROP POLICY IF EXISTS csr_issues_select        ON public.csr_issues;
DROP POLICY IF EXISTS csr_issues_insert        ON public.csr_issues;
DROP POLICY IF EXISTS csr_issues_update        ON public.csr_issues;
DROP POLICY IF EXISTS csr_issues_delete        ON public.csr_issues;
DROP POLICY IF EXISTS csr_it_replies_select    ON public.csr_it_replies;
DROP POLICY IF EXISTS csr_it_replies_insert    ON public.csr_it_replies;
DROP POLICY IF EXISTS csr_it_replies_delete    ON public.csr_it_replies;
DROP POLICY IF EXISTS csr_verifications_select ON public.csr_verifications;
DROP POLICY IF EXISTS csr_verifications_insert ON public.csr_verifications;
DROP POLICY IF EXISTS csr_verifications_delete ON public.csr_verifications;
DROP POLICY IF EXISTS csr_attachments_select   ON public.csr_attachments;
DROP POLICY IF EXISTS csr_attachments_insert   ON public.csr_attachments;
DROP POLICY IF EXISTS csr_attachments_delete   ON public.csr_attachments;
DROP POLICY IF EXISTS csr_status_log_select    ON public.csr_status_log;

-- ─── csr_user_roles — 조회는 등록 사용자, 변경은 admin (관리 화면 §5-2) ──────
CREATE POLICY csr_user_roles_select ON public.csr_user_roles
  FOR SELECT USING (public.csr_role() IS NOT NULL);

CREATE POLICY csr_user_roles_write ON public.csr_user_roles
  FOR ALL
  USING (public.csr_role() = 'admin')
  WITH CHECK (public.csr_role() = 'admin');

-- ─── csr_issues ──────────────────────────────────────────────────────────────
-- SELECT: 등록 사용자 전원 (익명 차단). 아카이브 숨김은 화면 필터가 맡습니다 —
--         감사·역추적을 위해 DB 에서는 가립니다.
CREATE POLICY csr_issues_select ON public.csr_issues
  FOR SELECT USING (public.csr_role() IS NOT NULL);

-- INSERT: 현업이 이슈를 올리고 admin 이 대행합니다. it_dept 는 회신만 답니다.
CREATE POLICY csr_issues_insert ON public.csr_issues
  FOR INSERT WITH CHECK (public.csr_role() IN ('admin', 'business'));

-- UPDATE: 행 단위로는 등록 사용자 전원에게 열고, 어느 '컬럼'을 바꿀 수 있는지는
--         003_triggers.sql 의 컬럼 가드가 판정합니다. RLS 는 컬럼 단위 조건을
--         표현할 수 없어 둘로 나눈 구조입니다(작업지시서 §3-2).
CREATE POLICY csr_issues_update ON public.csr_issues
  FOR UPDATE
  USING (public.csr_role() IS NOT NULL)
  WITH CHECK (public.csr_role() IS NOT NULL);

CREATE POLICY csr_issues_delete ON public.csr_issues
  FOR DELETE USING (public.csr_role() = 'admin');

-- ─── csr_it_replies — IT부서 회신 ───────────────────────────────────────────
CREATE POLICY csr_it_replies_select ON public.csr_it_replies
  FOR SELECT USING (public.csr_role() IS NOT NULL);

CREATE POLICY csr_it_replies_insert ON public.csr_it_replies
  FOR INSERT WITH CHECK (public.csr_role() IN ('admin', 'it_dept'));

CREATE POLICY csr_it_replies_delete ON public.csr_it_replies
  FOR DELETE USING (public.csr_role() = 'admin');

-- ─── csr_verifications — 현업 검증 이력 ─────────────────────────────────────
CREATE POLICY csr_verifications_select ON public.csr_verifications
  FOR SELECT USING (public.csr_role() IS NOT NULL);

CREATE POLICY csr_verifications_insert ON public.csr_verifications
  FOR INSERT WITH CHECK (public.csr_role() IN ('admin', 'business'));

CREATE POLICY csr_verifications_delete ON public.csr_verifications
  FOR DELETE USING (public.csr_role() = 'admin');

-- ─── csr_attachments — 캡쳐 ─────────────────────────────────────────────────
CREATE POLICY csr_attachments_select ON public.csr_attachments
  FOR SELECT USING (public.csr_role() IS NOT NULL);

CREATE POLICY csr_attachments_insert ON public.csr_attachments
  FOR INSERT WITH CHECK (public.csr_role() IN ('admin', 'business'));

CREATE POLICY csr_attachments_delete ON public.csr_attachments
  FOR DELETE USING (public.csr_role() = 'admin');

-- 회신·검증·첨부에는 UPDATE 정책을 두지 않습니다 — 이력은 덧붙이기만 하고 고치지
-- 않습니다(잘못 올린 건은 admin 이 지웁니다). RLS 는 정책이 없으면 거부가 기본입니다.

-- ─── csr_status_log — 조회 전용 ─────────────────────────────────────────────
-- 적재는 003_triggers.sql 의 SECURITY DEFINER 트리거만 합니다. INSERT/UPDATE/DELETE
-- 정책이 없으므로 Data API 로는 아무도 손댈 수 없습니다.
CREATE POLICY csr_status_log_select ON public.csr_status_log
  FOR SELECT USING (public.csr_role() IS NOT NULL);

-- ─── Data API 권한 부여 ─────────────────────────────────────────────────────
-- RLS 정책은 '어떤 행'을 다룰지만 정합니다. PostgREST 계열인 Neon Data API 가 테이블에
-- 닿으려면 역할에 테이블 권한도 있어야 합니다 — 둘 중 하나만 있으면 조회가 빈 결과나
-- 401/403 으로 나옵니다(작업지시서 §7 즉시 중단 조건).
--
-- 익명 토큰은 비활성이므로(작업지시서 §6) anonymous 에는 아무 권한도 주지 않습니다.
-- 역할명이 프로젝트마다 다를 수 있어 존재할 때만 실행합니다.
DO $grant$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT USAGE ON SCHEMA public TO authenticated;

    GRANT SELECT, INSERT, UPDATE, DELETE ON
      public.csr_issues, public.csr_it_replies, public.csr_verifications,
      public.csr_attachments, public.csr_user_roles
      TO authenticated;

    GRANT SELECT ON public.csr_status_log TO authenticated;

    -- bigserial 의 시퀀스 — INSERT 에 필요합니다. ALL SEQUENCES 로 뭉뚱그리지 않고
    -- csr_ 것만 집어 줍니다(같은 프로젝트에 다른 스키마가 들어와도 새지 않도록).
    GRANT USAGE, SELECT ON
      public.csr_issues_id_seq, public.csr_it_replies_id_seq,
      public.csr_verifications_id_seq, public.csr_attachments_id_seq,
      public.csr_status_log_id_seq
      TO authenticated;

    GRANT EXECUTE ON FUNCTION public.csr_role() TO authenticated;
    GRANT EXECUTE ON FUNCTION public.csr_next_issue_no() TO authenticated;
  ELSE
    RAISE NOTICE 'authenticated 역할이 없습니다 — Neon Data API 를 켠 뒤 이 파일을 다시 실행하십시오.';
  END IF;
END;
$grant$;

COMMIT;
