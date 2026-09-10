-- =============================================================================
-- ASM CSR — auth 스키마 접근 권한 (2026-09-10 실측 버그 수정)
--   001~008 적용 후 실행. 달러 인용 없음 — 문장마다 따로 실행해도 됩니다.
--
-- ── 증상 ────────────────────────────────────────────────────────────────────
-- 앱(Data API, authenticated 역할)에서 csr_issues 를 UPDATE 하면 전부 실패합니다:
--   403  42501  "permission denied for schema auth"
-- 상세 화면의 「편집 → 저장」이 역할과 무관하게 막힙니다(admin 포함).
--
-- ── 원인 ────────────────────────────────────────────────────────────────────
-- 006 의 컬럼 가드(csr_issues_column_guard)가 NEW.updated_by := auth.user_id() 를 호출합니다.
-- 이 트리거는 호출자 권한으로 실행되는데(SECURITY INVOKER) authenticated 역할에는 auth 스키마
-- USAGE 가 없습니다. csr_role() 은 SECURITY DEFINER 라 같은 함수를 불러도 통과했고, 그래서
-- 읽기(SELECT · RLS)는 되고 쓰기만 막히는 모양이 됐습니다.
--
-- ── 조치 ────────────────────────────────────────────────────────────────────
-- 스키마 USAGE 와 함수 EXECUTE 만 줍니다. auth.user_id() 는 JWT 클레임을 읽을 뿐 데이터를
-- 노출하지 않으므로 안전합니다. (SECURITY DEFINER 로 바꾸는 대안은 가드가 RLS 를 우회하게 되어
-- 택하지 않았습니다.)
-- =============================================================================

GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT EXECUTE ON FUNCTION auth.user_id() TO authenticated;

-- 확인 — 두 행 모두 true 여야 합니다.
SELECT has_schema_privilege('authenticated', 'auth', 'USAGE')            AS auth_schema_usage,
       has_function_privilege('authenticated', 'auth.user_id()', 'EXECUTE') AS auth_user_id_execute;
