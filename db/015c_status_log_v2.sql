-- =============================================================================
-- [CSR-1.1-A] 상태 로그 트리거 v2 — 015 의 뒷부분(변경자 = csr_actor_id, verified_on 감시 추가).
--   015b 다음에 파일째 실행($fn$). 재실행 안전.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.csr_issues_status_log()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  watched text[] := ARRAY['it_status', 'it_decision', 'verification_result', 'verified_on',
                          'it_pic', 'target_release_on'];
  col       text;
  old_value text;
  new_value text;
BEGIN
  FOREACH col IN ARRAY watched LOOP
    old_value := to_jsonb(OLD) ->> col;
    new_value := to_jsonb(NEW) ->> col;
    IF old_value IS DISTINCT FROM new_value THEN
      INSERT INTO public.csr_status_log (issue_id, changed_by, column_name, old_value, new_value)
      VALUES (NEW.id, public.csr_actor_id(), col, old_value, new_value);
    END IF;
  END LOOP;
  RETURN NULL;
END;
$fn$;
REVOKE ALL ON FUNCTION public.csr_issues_status_log() FROM PUBLIC;

DROP TRIGGER IF EXISTS csr_issues_status_log ON public.csr_issues;
CREATE TRIGGER csr_issues_status_log
  AFTER UPDATE ON public.csr_issues
  FOR EACH ROW EXECUTE FUNCTION public.csr_issues_status_log();

-- 확인 — 트리거 2개 · 래퍼 실행 권한 true
SELECT tgname, tgenabled FROM pg_trigger WHERE tgrelid = 'public.csr_issues'::regclass AND NOT tgisinternal ORDER BY tgname;
SELECT has_function_privilege('authenticated', 'public.csr_actor_id()', 'EXECUTE') AS actor_id_exec_ok;
