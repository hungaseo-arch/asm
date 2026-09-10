-- =============================================================================
-- ASM CSR — 초기 역할 3종 등록
--   작업지시서 §3-3 (C-6) / 003_triggers.sql 적용 후 실행
--
--   ★ 실행 전 준비 (2026-09-10 현재 C-6 보류 — 계정을 만든 뒤에 실행하십시오)
--     1. Neon 콘솔 → Auth → Users → Create user 로 계정 3개를 만듭니다.
--     2. 아래 표의 이메일 3개를 실제 값으로 바꿉니다.
--     3. 이 파일을 실행합니다. user_id 는 이메일로 자동 조회됩니다.
--
--   csr_user_roles 에 없는 사용자는 로그인에 성공해도 아무것도 보지 못합니다
--   (002_rls_policies.sql 의 SELECT 정책이 csr_role() IS NOT NULL 이므로).
--   Neon Auth 가 아직 가입 제한을 지원하지 않으므로, 이 표가 사실상의 접근 통제입니다.
--
--   ── Neon Auth 스키마 실측 (2026-09-10) ────────────────────────────────────
--   당초 참조하려던 neon_auth.users_sync 는 존재하지 않습니다 — Neon Auth 가 Better Auth
--   기반으로 바뀌면서 Stack Auth 시절의 동기화 테이블이 사라졌습니다. 실제 사용자 테이블은
--   neon_auth."user" 이며 (id, name, email, emailVerified, ..., role, banned) 컬럼을 가집니다.
--   user 는 SQL 예약어라 반드시 큰따옴표로 감싸야 합니다.
--
--   Auth 는 Beta 라 이 스키마가 또 바뀔 수 있습니다. 그래서 조회가 실패해도 막히지 않도록
--   user_id 를 직접 적는 경로를 함께 열어 두었습니다(아래 seed_user_id 열).
-- =============================================================================

BEGIN;

-- ─── 여기만 고치십시오 ───────────────────────────────────────────────────────
--   seed_user_id: 보통은 NULL 로 두십시오 — 이메일로 자동 조회됩니다.
--                 자동 조회가 안 될 때만 콘솔 Auth → Users 의 User ID 를 적습니다.
CREATE TEMP TABLE csr_seed (email text, role text, display_name text, seed_user_id text)
  ON COMMIT DROP;

INSERT INTO csr_seed (email, role, display_name, seed_user_id) VALUES
  ('TODO-admin@example.com',    'admin',    'TODO 관리자', NULL),
  ('TODO-it@example.com',       'it_dept',  'TODO IT부서', NULL),
  ('TODO-business@example.com', 'business', 'TODO 현업',   NULL);
-- ─────────────────────────────────────────────────────────────────────────────

-- 자리표시자를 그대로 두고 실행하면 여기서 멈춥니다 — TODO 가 실제 역할로 등록되면
-- '왜 로그인이 안 되지' 를 한참 뒤에야 알게 됩니다.
DO $guard$
DECLARE
  n int;
BEGIN
  SELECT count(*) INTO n FROM csr_seed WHERE email LIKE 'TODO%';
  IF n > 0 THEN
    RAISE EXCEPTION 'CSR: 자리표시자가 %건 남아 있습니다 — 파일 상단의 TODO 이메일을 실제 값으로 바꾸십시오.', n;
  END IF;
END;
$guard$;

-- 이메일 → user_id 해석. seed_user_id 를 적어 두었으면 그쪽이 우선입니다.
CREATE TEMP TABLE csr_resolved ON COMMIT DROP AS
SELECT s.email,
       s.role,
       s.display_name,
       COALESCE(s.seed_user_id, u.id::text) AS user_id,
       u.banned
  FROM csr_seed s
  LEFT JOIN neon_auth."user" u ON lower(u.email) = lower(s.email);

-- 해석되지 않은 계정이 있으면 통째로 되돌립니다 — 일부만 등록되면 누가 빠졌는지
-- 알아채기 어렵습니다.
DO $check$
DECLARE
  missing text;
  banned  text;
BEGIN
  SELECT string_agg(email, ', ') INTO missing FROM csr_resolved WHERE user_id IS NULL;
  IF missing IS NOT NULL THEN
    RAISE EXCEPTION E'CSR: 다음 이메일의 Neon Auth 계정을 찾지 못했습니다 → %\n'
      '  · 콘솔 Auth → Users 에서 계정을 먼저 만드십시오(이메일 철자 확인).\n'
      '  · 계정이 분명히 있는데도 안 잡히면 해당 행의 seed_user_id 에 User ID 를 직접 적으십시오.',
      missing;
  END IF;

  SELECT string_agg(email, ', ') INTO banned FROM csr_resolved WHERE banned;
  IF banned IS NOT NULL THEN
    RAISE WARNING 'CSR: 정지(banned) 상태인 계정이 있습니다 → % — 로그인은 막히지만 역할은 등록합니다.', banned;
  END IF;
END;
$check$;

INSERT INTO public.csr_user_roles (user_id, email, role, display_name)
SELECT user_id, email, role, display_name FROM csr_resolved
ON CONFLICT (user_id) DO UPDATE
  SET email        = EXCLUDED.email,
      role         = EXCLUDED.role,
      display_name = EXCLUDED.display_name;

COMMIT;

-- ─── 확인용 조회 ─────────────────────────────────────────────────────────────
-- 3행이 나오면 정상입니다.
SELECT role, email, display_name, user_id, created_at
  FROM public.csr_user_roles
 ORDER BY CASE role WHEN 'admin' THEN 1 WHEN 'it_dept' THEN 2 ELSE 3 END;
