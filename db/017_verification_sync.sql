-- =============================================================================
-- [CSR-1.1-B] 검증 이력 등록 시 헤더(현업검증 · 최종검증일) 자동 동기화
--   015 · 016 적용 후 실행. 달러 인용($fn$) 있음 — 파일째 실행. 재실행 안전.
--
--   AFTER INSERT ON csr_verifications → 부모 csr_issues 갱신
--     verified_on         = 이력 일자 (더 최신이거나 같은 일자일 때만 — 과거 일자는 덮어쓰지 않음)
--     verification_result = 이력 결과 코드 (같은 조건)
--
--   SECURITY DEFINER 인 이유: 갱신은 소유자 권한으로 실행됩니다. 컬럼 가드(015)는 콘솔·소유자
--   세션을 통과시키므로 business 가 이력을 추가해도 헤더 갱신이 가드에 막히지 않습니다.
--   상태 로그(015)는 그대로 찍히며 변경자는 이력을 넣은 사용자(csr_actor_id → JWT)입니다.
--   RLS 와의 충돌: 이력 INSERT 자체는 002 의 csr_verifications_insert(admin·business)로 판정되고,
--   그 뒤의 헤더 UPDATE 는 RLS 를 타지 않습니다(소유자).
-- =============================================================================

CREATE OR REPLACE FUNCTION public.csr_verifications_sync_issue()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $fn$
BEGIN
  IF NEW.result IS NULL OR NEW.verified_on IS NULL THEN
    RETURN NULL;
  END IF;
  UPDATE public.csr_issues
     SET verification_result = NEW.result,
         verified_on         = NEW.verified_on
   WHERE id = NEW.issue_id
     AND (verified_on IS NULL OR NEW.verified_on >= verified_on);
  RETURN NULL;
END;
$fn$;
REVOKE ALL ON FUNCTION public.csr_verifications_sync_issue() FROM PUBLIC;

DROP TRIGGER IF EXISTS csr_verifications_sync_issue ON public.csr_verifications;
CREATE TRIGGER csr_verifications_sync_issue
  AFTER INSERT ON public.csr_verifications
  FOR EACH ROW EXECUTE FUNCTION public.csr_verifications_sync_issue();

-- 확인
SELECT tgname, tgenabled FROM pg_trigger
 WHERE tgrelid = 'public.csr_verifications'::regclass AND NOT tgisinternal ORDER BY tgname;
