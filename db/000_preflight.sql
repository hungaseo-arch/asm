-- =============================================================================
-- ASM CSR — 선행 점검 (읽기 전용)
--   001~003 을 적용하기 전에 이 파일을 먼저 실행하십시오.
--   아무것도 만들지도 고치지도 않습니다. 확인만 합니다.
--
-- 왜 필요한가
--   002_rls_policies.sql 의 csr_role() 은 LANGUAGE sql 이라 **만들 때 본문이 파싱**됩니다.
--   Neon Auth 가 노출하는 '현재 사용자 함수'의 이름이 auth.user_id() 가 아니면 002 가
--   첫 줄부터 실패합니다. 여기서 실제 이름을 먼저 확인하고, 다르면 002·003 의 두 곳만
--   그 이름으로 바꾸면 됩니다.
-- =============================================================================

-- ─── 점검 1. auth 스키마가 있는가 ────────────────────────────────────────────
SELECT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'auth') AS auth_schema_exists;
-- 기대: true  (false 면 Neon Auth 가 아직 켜지지 않았거나 이 브랜치에 반영되지 않은 것)

-- ─── 점검 2. auth 스키마의 함수 목록 ─────────────────────────────────────────
-- 여기에 user_id() 가 보여야 합니다. 대신 uid() · session() · jwt() 같은 이름만
-- 보인다면 그 이름이 이 프로젝트의 '현재 사용자' 함수입니다.
SELECT p.proname            AS function_name,
       pg_get_function_arguments(p.oid) AS args,
       pg_get_function_result(p.oid)    AS returns
  FROM pg_proc p
  JOIN pg_namespace n ON n.oid = p.pronamespace
 WHERE n.nspname = 'auth'
 ORDER BY 1;

-- ─── 점검 3. auth.user_id() 를 실제로 부를 수 있는가 ─────────────────────────
-- 콘솔 SQL Editor 는 로그인 사용자가 아니라 DB 역할로 붙으므로 NULL 이 정상입니다.
-- 중요한 것은 '오류 없이 NULL 이 나오는가' 입니다.
DO $probe$
DECLARE
  v text;
BEGIN
  EXECUTE 'SELECT auth.user_id()' INTO v;
  RAISE NOTICE 'OK — auth.user_id() 호출 가능 (현재 값: %). 002 를 그대로 실행하십시오.',
    COALESCE(v, 'NULL — 콘솔 접속이라 정상');
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '실패 — auth.user_id() 를 부를 수 없습니다: %', SQLERRM;
  RAISE WARNING '점검 2 의 목록에서 실제 함수명을 확인한 뒤, 002_rls_policies.sql 의 csr_role() 과';
  RAISE WARNING '003_triggers.sql 의 NEW.updated_by / changed_by 세 곳을 그 이름으로 바꾸십시오.';
END;
$probe$;

-- ─── 점검 4. Data API 역할이 있는가 ──────────────────────────────────────────
SELECT rolname FROM pg_roles
 WHERE rolname IN ('authenticated', 'anonymous', 'authenticator')
 ORDER BY 1;
-- 기대: authenticated 가 보여야 합니다 (002 의 GRANT 대상).
-- 없으면 Data API 가 아직 켜지지 않은 것입니다.

-- ─── 점검 5. 이미 만들어진 csr_ 객체가 있는가 ────────────────────────────────
-- 첫 적용이라면 0행이 정상입니다. 재적용이라면 이전 상태를 보여 줍니다.
SELECT c.relname AS object_name,
       CASE c.relkind WHEN 'r' THEN 'table' WHEN 'i' THEN 'index' WHEN 'S' THEN 'sequence' END AS kind,
       c.relrowsecurity AS rls_enabled
  FROM pg_class c
 WHERE c.relnamespace = 'public'::regnamespace
   AND c.relname LIKE 'csr!_%' ESCAPE '!'
 ORDER BY 2, 1;
