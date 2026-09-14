-- =============================================================================
-- 최종 접속일 (2026-09-14 요청) — 028 적용 후 실행. 달러 인용($fn$) 있음 — 파일째 실행. 재실행 안전.
--
--   관리 화면의 사용자 표에 「최종 접속일」을 두려면 로그인 시각을 어딘가에 남겨야 합니다.
--   Neon Auth 의 세션 테이블(neon_auth 스키마)은 Data API 가 노출하지 않으므로(public 만 노출),
--   csr_user_roles 에 컬럼을 두고 앱이 세션을 확인할 때마다 자기 행만 찍습니다.
--
--   왜 함수인가: csr_user_roles 의 쓰기 정책(002)은 admin 뿐입니다. 자기 행 UPDATE 를 열어 주면
--   역할(role)까지 스스로 바꿀 수 있게 되므로, 정책은 그대로 두고 **이 컬럼만** 갱신하는
--   SECURITY DEFINER 함수를 둡니다. 인자가 없어 남의 행은 건드릴 수 없습니다 —
--   대상은 언제나 호출자 자신(csr_actor_id())입니다.
-- =============================================================================

ALTER TABLE public.csr_user_roles ADD COLUMN IF NOT EXISTS last_seen_at timestamptz;
COMMENT ON COLUMN public.csr_user_roles.last_seen_at IS '최종 접속일시 — 앱이 세션 확인 때 csr_touch_last_seen() 으로 찍습니다(로그인 시각이 아니라 마지막 사용 시각).';

CREATE OR REPLACE FUNCTION public.csr_touch_last_seen()
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
  UPDATE public.csr_user_roles
     SET last_seen_at = now()
   WHERE user_id = me
  RETURNING last_seen_at INTO ts;
  RETURN ts;  -- 미등록 사용자면 0행 → NULL
END;
$fn$;
COMMENT ON FUNCTION public.csr_touch_last_seen() IS '호출자 자신의 csr_user_roles.last_seen_at 을 now() 로. 인자 없음 — 남의 행은 갱신 불가.';

REVOKE ALL ON FUNCTION public.csr_touch_last_seen() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.csr_touch_last_seen() TO authenticated;

-- 확인 — 컬럼 · 함수 · 권한
SELECT column_name, data_type FROM information_schema.columns
 WHERE table_schema = 'public' AND table_name = 'csr_user_roles' AND column_name = 'last_seen_at';
SELECT has_function_privilege('authenticated', 'public.csr_touch_last_seen()', 'EXECUTE') AS exec_ok;
SELECT display_name, email, last_seen_at FROM public.csr_user_roles ORDER BY display_name;
