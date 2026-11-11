-- =============================================================================
-- 048 : CSR 조회 공개 — 로그인 없이 개선요청・대시보드・상세 열람 (2026-11-11 서종환 지시)
--
--   지시 : 「개선요청, 대시보드 페이지도 비밀번호 없이 열리도록 하고 데이터 입력, 수정시에만
--          로그인해야 가능토록 변경」. 공개 범위는 「전체 공개」로 확인받음(2026-11-11).
--
--   구조
--     · 화면은 로그인 전에 Neon Auth `GET /token/anonymous` 로 role=anonymous JWT 를 받아
--       Data API 를 부릅니다(src/modules/csr/api/neon.js getAnonymousJwt).
--     · 이 파일은 그 anonymous 역할에 「SELECT 만」 줍니다. INSERT・UPDATE・DELETE 정책과
--       003 컬럼 가드는 그대로라 입력・수정은 계속 로그인 + 역할이 필요합니다.
--     · 로그인했지만 역할이 없는 계정(authenticated, csr_role() NULL)도 같은 범위를 봅니다.
--
--   공개 대상 : csr_issues, csr_it_replies, csr_verifications, csr_attachments,
--               csr_status_log, csr_notices
--   계속 비공개 : csr_user_roles(이메일・역할), csr_login_log(접속 기록), csr_path_menu_backup
--
--   주의 : csr_it_replies・csr_verifications 의 created_by, csr_status_log 의 changed_by 에
--          작성자 표시값(이름 또는 이메일)이 들어 있으면 함께 공개됩니다.
--
--   실행 후 : Neon 콘솔 Data API 화면의 「Refresh schema cache」 1회(030 경과 참고).
--   재실행 안전(DROP POLICY IF EXISTS 후 재생성).
-- =============================================================================

BEGIN;

-- ─── 1. SELECT 정책 : 누구나 조회 ─────────────────────────────────────────────
DROP POLICY IF EXISTS csr_issues_select        ON public.csr_issues;
DROP POLICY IF EXISTS csr_it_replies_select    ON public.csr_it_replies;
DROP POLICY IF EXISTS csr_verifications_select ON public.csr_verifications;
DROP POLICY IF EXISTS csr_attachments_select   ON public.csr_attachments;
DROP POLICY IF EXISTS csr_status_log_select    ON public.csr_status_log;
DROP POLICY IF EXISTS csr_notices_select       ON public.csr_notices;

CREATE POLICY csr_issues_select        ON public.csr_issues        FOR SELECT USING (true);
CREATE POLICY csr_it_replies_select    ON public.csr_it_replies    FOR SELECT USING (true);
CREATE POLICY csr_verifications_select ON public.csr_verifications FOR SELECT USING (true);
CREATE POLICY csr_attachments_select   ON public.csr_attachments   FOR SELECT USING (true);
CREATE POLICY csr_status_log_select    ON public.csr_status_log    FOR SELECT USING (true);
CREATE POLICY csr_notices_select       ON public.csr_notices       FOR SELECT USING (true);

-- ─── 2. anonymous 역할 권한 : 스키마 USAGE + 위 6개 테이블 SELECT 만 ─────────
DO $grant$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anonymous') THEN
    GRANT USAGE ON SCHEMA public TO anonymous;
    GRANT SELECT ON
      public.csr_issues,
      public.csr_it_replies,
      public.csr_verifications,
      public.csr_attachments,
      public.csr_status_log,
      public.csr_notices
      TO anonymous;
    -- 쓰기 권한은 주지 않습니다. 혹시 남아 있으면 회수합니다.
    REVOKE INSERT, UPDATE, DELETE ON
      public.csr_issues,
      public.csr_it_replies,
      public.csr_verifications,
      public.csr_attachments,
      public.csr_status_log,
      public.csr_notices,
      public.csr_user_roles
      FROM anonymous;
    REVOKE SELECT ON public.csr_user_roles FROM anonymous;
  ELSE
    RAISE EXCEPTION 'anonymous 역할이 없습니다. Neon Data API 설정을 확인하십시오.';
  END IF;
END
$grant$;

COMMIT;

-- ─── 3. 확인 ────────────────────────────────────────────────────────────────
-- (a) anonymous 는 6개 테이블 SELECT = true, 쓰기 = false, csr_user_roles = false 여야 합니다.
SELECT t AS table_name,
       has_table_privilege('anonymous', t, 'SELECT') AS anon_select,
       has_table_privilege('anonymous', t, 'INSERT') OR has_table_privilege('anonymous', t, 'UPDATE')
         OR has_table_privilege('anonymous', t, 'DELETE') AS anon_write
FROM unnest(ARRAY[
  'public.csr_issues', 'public.csr_it_replies', 'public.csr_verifications',
  'public.csr_attachments', 'public.csr_status_log', 'public.csr_notices',
  'public.csr_user_roles'
]) AS t;

-- (b) SELECT 정책이 USING (true) 로 바뀌었는지
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE policyname LIKE 'csr\_%\_select'
ORDER BY tablename;

-- ─── 되돌리기 (필요할 때만) ─────────────────────────────────────────────────
-- BEGIN;
-- REVOKE SELECT ON public.csr_issues, public.csr_it_replies, public.csr_verifications,
--   public.csr_attachments, public.csr_status_log, public.csr_notices FROM anonymous;
-- DROP POLICY IF EXISTS csr_issues_select ON public.csr_issues;
-- CREATE POLICY csr_issues_select ON public.csr_issues FOR SELECT USING (public.csr_role() IS NOT NULL);
-- (csr_it_replies・csr_verifications・csr_attachments・csr_status_log・csr_notices 도 같은 방식)
-- COMMIT;
