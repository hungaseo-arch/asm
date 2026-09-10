-- =============================================================================
-- ASM CSR — 초기 역할 3종 등록
--   작업지시서 §3-3 (C-6) / 003_triggers.sql 적용 후 실행
--
--   ★ 실행 전 준비
--     0. db/006_user_department.sql 을 먼저 적용하십시오 (department 컬럼).
--     1. Neon 콘솔 → Auth → Users → Create user 로 아래 계정을 만듭니다.
--     2. 이름(display_name)을 실제 표기로 맞춥니다.
--     3. 이 파일을 실행합니다. user_id 는 이메일로 자동 조회됩니다.
--
--   ── role 과 department 는 다릅니다 ───────────────────────────────────────
--   role 은 **권한 등급 3종**뿐입니다(admin · it_dept · business). RLS 정책(002)과
--   컬럼 가드(003)가 이 세 값에 1:1로 묶여 있어, 소속을 넣으면 CHECK 제약 위반으로
--   실패하고 설령 들어가도 권한 판정이 무너집니다.
--   영업·수입·재무 같은 소속은 department 에 적습니다 — 표시·집계용이며 권한과 무관합니다.
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
CREATE TEMP TABLE csr_seed (
  email text, role text, department text, display_name text, seed_user_id text
) ON COMMIT DROP;

INSERT INTO csr_seed (email, role, department, display_name, seed_user_id) VALUES
  -- 관리자 — 전 컬럼 편집 · 역할 관리 · 삭제
  ('jhseo@ptascendo.com',   'admin',    'it',          'Seo Jonghwan', NULL),
  -- IT부서 — 회신 등록 + it_status·담당자·목표배포일·회신요약 5개 컬럼만
  ('jklee@ptascendo.com',   'it_dept',  'it',          'Lee',          NULL),
  -- 현업 — 이슈 등록 · 현업 답변 · 검증 · 첨부 (소속만 다르고 권한은 같습니다)
  ('lia@ptascendo.com',     'business', 'sales_admin', 'Lia',          NULL),
  ('merry@ptascendo.com',   'business', 'sales_admin', 'Merry',        NULL),
  ('tari@ptascendo.com',    'business', 'import',      'Tari',         NULL),
  ('alya@ptascendo.com',    'business', 'import',      'Alya',         NULL),
  ('komang@ptascendo.com',  'business', 'finance',     'Komang',       NULL),
  ('arif@ptascendo.com',    'business', 'sales',       'Arif',         NULL),
  ('rizki@ptascendo.com',   'business', 'sales',       'Rizki',        NULL);
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

  -- 소속을 role 에 잘못 적는 실수를 여기서 잡습니다 — CHECK 제약보다 메시지가 친절합니다.
  SELECT count(*) INTO n FROM csr_seed WHERE role <> ALL (ARRAY['admin', 'it_dept', 'business']);
  IF n > 0 THEN
    RAISE EXCEPTION 'CSR: role 은 admin · it_dept · business 만 쓸 수 있습니다 (%건 위반). 소속은 department 에 적으십시오.', n;
  END IF;
END;
$guard$;

-- 이메일 → user_id 해석. seed_user_id 를 적어 두었으면 그쪽이 우선입니다.
CREATE TEMP TABLE csr_resolved ON COMMIT DROP AS
SELECT s.email,
       s.role,
       s.department,
       s.display_name,
       COALESCE(s.seed_user_id, u.id::text) AS user_id,
       u.banned
  FROM csr_seed s
  LEFT JOIN neon_auth."user" u ON lower(u.email) = lower(s.email);

-- 해석되지 않은 계정이 있으면 통째로 되돌립니다 — 일부만 등록되면 누가 빠졌는지
-- 알아채기 어렵습니다.
-- 변수 이름을 컬럼과 다르게 둡니다 — plpgsql 은 변수 banned 와 컬럼 banned 를 구분하지
-- 못해 "column reference is ambiguous" 로 실패합니다(2026-09-10 실측).
DO $check$
DECLARE
  missing     text;
  banned_list text;
BEGIN
  SELECT string_agg(email, ', ') INTO missing FROM csr_resolved WHERE user_id IS NULL;
  IF missing IS NOT NULL THEN
    RAISE EXCEPTION E'CSR: 다음 이메일의 Neon Auth 계정을 찾지 못했습니다 → %\n'
      '  · 콘솔 Auth → Users 에서 계정을 먼저 만드십시오(이메일 철자 확인).\n'
      '  · 계정이 분명히 있는데도 안 잡히면 해당 행의 seed_user_id 에 User ID 를 직접 적으십시오.',
      missing;
  END IF;

  SELECT string_agg(email, ', ') INTO banned_list
    FROM csr_resolved WHERE COALESCE(banned, false);
  IF banned_list IS NOT NULL THEN
    RAISE WARNING 'CSR: 정지(banned) 상태인 계정이 있습니다 → % — 로그인은 막히지만 역할은 등록합니다.', banned_list;
  END IF;
END;
$check$;

INSERT INTO public.csr_user_roles (user_id, email, role, department, display_name)
SELECT user_id, email, role, department, display_name FROM csr_resolved
ON CONFLICT (user_id) DO UPDATE
  SET email        = EXCLUDED.email,
      role         = EXCLUDED.role,
      department   = EXCLUDED.department,
      display_name = EXCLUDED.display_name;

COMMIT;

-- ─── 확인용 조회 ─────────────────────────────────────────────────────────────
-- 9행이 나오면 정상입니다.
SELECT role, department, email, display_name, user_id, created_at
  FROM public.csr_user_roles
 ORDER BY CASE role WHEN 'admin' THEN 1 WHEN 'it_dept' THEN 2 ELSE 3 END, department, email;
