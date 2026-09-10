-- =============================================================================
-- ASM CSR — 초기 역할 3종 등록
--   작업지시서 §3-3 (C-6) / 003_triggers.sql 적용 후 실행
--
--   ★ 실행 전 준비 ─ 아래 이메일 3개를 실제 값으로 바꾸십시오 (C-6 미확정, 2026-09-10).
--     그리고 Neon Auth 콘솔에서 admin 이 계정 3개를 먼저 만들어야 합니다
--     (회원가입 비활성 — 작업지시서 §6).
--
--   csr_user_roles 에 없는 사용자는 로그인에 성공해도 아무것도 보지 못합니다
--   (002_rls_policies.sql 의 SELECT 정책이 csr_role() IS NOT NULL 이므로).
-- =============================================================================

BEGIN;

-- ─── 여기만 고치십시오 ───────────────────────────────────────────────────────
CREATE TEMP TABLE csr_seed (email text, role text, display_name text) ON COMMIT DROP;

INSERT INTO csr_seed (email, role, display_name) VALUES
  ('TODO-admin@example.com',    'admin',    'TODO 관리자'),
  ('TODO-it@example.com',       'it_dept',  'TODO IT부서'),
  ('TODO-business@example.com', 'business', 'TODO 현업');
-- ─────────────────────────────────────────────────────────────────────────────

-- Neon Auth 는 인증된 사용자를 neon_auth.users_sync 로 동기화합니다. 계정을 먼저 만든
-- 뒤 이 파일을 실행하면 user_id 를 손으로 옮겨 적을 필요가 없습니다.
INSERT INTO public.csr_user_roles (user_id, email, role, display_name)
SELECT u.id, s.email, s.role, s.display_name
  FROM csr_seed s
  JOIN neon_auth.users_sync u ON lower(u.email) = lower(s.email)
 WHERE u.deleted_at IS NULL
ON CONFLICT (user_id) DO UPDATE
  SET email        = EXCLUDED.email,
      role         = EXCLUDED.role,
      display_name = EXCLUDED.display_name;

-- 매칭되지 않은 이메일을 알려 줍니다 — 대개 계정을 아직 안 만들었거나 오타입니다.
DO $check$
DECLARE
  missing text;
BEGIN
  SELECT string_agg(s.email, ', ')
    INTO missing
    FROM csr_seed s
   WHERE NOT EXISTS (
     SELECT 1 FROM public.csr_user_roles r WHERE lower(r.email) = lower(s.email)
   );

  IF missing IS NOT NULL THEN
    RAISE WARNING 'CSR: 다음 이메일의 Neon Auth 계정을 찾지 못했습니다 → %', missing;
    RAISE WARNING 'CSR: 콘솔에서 계정을 만든 뒤 이 파일을 다시 실행하십시오.';
  END IF;
END;
$check$;

COMMIT;

-- ─── 확인용 조회 ─────────────────────────────────────────────────────────────
-- 3행이 나오면 정상입니다.
SELECT role, email, display_name, created_at
  FROM public.csr_user_roles
 ORDER BY CASE role WHEN 'admin' THEN 1 WHEN 'it_dept' THEN 2 ELSE 3 END;
