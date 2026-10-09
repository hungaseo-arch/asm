-- =============================================================================
-- 로그인 이력 (2026-10-09 요청) — 001~030 적용 후 실행. 달러 인용($fn$) 있음 — 파일째 실행. 재실행 안전.
--
--   관리 화면에 "회원별 접속시간 및 현황" 을 보여주려면 로그인마다 한 행씩 남겨야
--   합니다. 029 의 csr_user_roles.last_seen_at 은 세션 확인(새로고침 포함)마다
--   덮어써 "마지막 사용 시각"일 뿐이라 로그인 건수·이력을 재구성할 수 없습니다.
--   이 파일은 실제 로그인(이메일·비밀번호 signIn 성공) 시점에만 한 행을 쌓는
--   별도 테이블 + RPC 를 둡니다 — last_seen_at 과 같은 이유로 함수를 통해서만
--   적재합니다(csr_user_roles 자기 행 UPDATE 를 열면 role 까지 스스로 바꿀 수
--   있던 것과 같은 문제를 피하기 위해, 029 의 구조를 그대로 따릅니다).
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.csr_login_log (
  id           bigserial PRIMARY KEY,
  user_id      text NOT NULL REFERENCES public.csr_user_roles(user_id) ON DELETE CASCADE,
  logged_in_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE public.csr_login_log IS '로그인 이력(행마다 1 로그인) — csr_log_login() 으로만 적재. 관리 화면 접속 로그 탭이 읽습니다.';

CREATE INDEX IF NOT EXISTS csr_login_log_user_id_idx ON public.csr_login_log (user_id, logged_in_at DESC);

ALTER TABLE public.csr_login_log ENABLE ROW LEVEL SECURITY;

-- ─── csr_login_log — 조회는 admin 만. 적재는 아래 SECURITY DEFINER 함수만(csr_status_log 와 같은 구조) ──
DROP POLICY IF EXISTS csr_login_log_select ON public.csr_login_log;
CREATE POLICY csr_login_log_select ON public.csr_login_log
  FOR SELECT USING (public.csr_role() = 'admin');
-- INSERT/UPDATE/DELETE 정책을 두지 않습니다 — RLS 는 정책이 없으면 거부가 기본이라
-- Data API 로는 아무도 직접 쓸 수 없고, 적재는 csr_log_login() 한 곳만 합니다.

CREATE OR REPLACE FUNCTION public.csr_log_login()
RETURNS timestamptz
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  me text := public.csr_actor_id();
  ts timestamptz;
BEGIN
  IF me IS NULL THEN
    RETURN NULL;  -- 로그인 전 · 콘솔 세션 — 조용히 통과
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.csr_user_roles WHERE user_id = me) THEN
    RETURN NULL;  -- 미등록 사용자 — csr_login_log 의 외래키 위반을 막습니다
  END IF;
  INSERT INTO public.csr_login_log (user_id) VALUES (me) RETURNING logged_in_at INTO ts;
  RETURN ts;
END;
$fn$;
COMMENT ON FUNCTION public.csr_log_login() IS '호출자 자신(csr_actor_id())의 로그인 1건을 csr_login_log 에 적재. 인자 없음 — 남의 이름으로 남길 수 없습니다.';

REVOKE ALL ON FUNCTION public.csr_log_login() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.csr_log_login() TO authenticated;
-- 030 의 선례(csr_touch_last_seen)를 따라 anonymous 에도 엽니다 — 인자가 없고 대상이
-- 언제나 호출자 자신이라, 로그인 전 세션은 csr_actor_id() 가 NULL 이라 아무것도 쌓이지 않습니다.
GRANT EXECUTE ON FUNCTION public.csr_log_login() TO anonymous;

DO $grant$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT USAGE ON SCHEMA public TO authenticated;
    GRANT SELECT ON public.csr_login_log TO authenticated;
    GRANT USAGE, SELECT ON public.csr_login_log_id_seq TO authenticated;
  ELSE
    RAISE NOTICE 'authenticated 역할이 없습니다 — Neon Data API 를 켠 뒤 이 파일을 다시 실행하십시오.';
  END IF;
END;
$grant$;

-- 029 때 겪은 PGRST202(함수를 스키마 캐시에서 못 찾음) 재발 방지 — 참고: 030 의 경과로는
-- Neon Data API 가 이 NOTIFY 를 듣지 않았으므로, 적용 후에도 PGRST202 가 나오면 콘솔
-- Data API 화면의 'Refresh schema cache' 를 누르십시오.
NOTIFY pgrst, 'reload schema';

-- 확인 — 함수 권한 · 테이블 생성
SELECT has_function_privilege('authenticated', 'public.csr_log_login()', 'EXECUTE') AS auth_exec_ok,
       has_function_privilege('anonymous',     'public.csr_log_login()', 'EXECUTE') AS anon_exec_ok;
SELECT count(*) FROM public.csr_login_log;
