-- =============================================================================
-- [CSR-1.1-A] 컬럼 가드 v2 — 015 의 6번째 문장(ERROR)만 따로 뗀 것. 015 의 1~5(csr_actor_id 래퍼)는 적용됨.
--   파일째 실행($fn$). 재실행 안전. 함수 본문은 편집기 토크나이저 문제를 피하려고 ASCII 만 씁니다.
--   내용은 015 와 같습니다: admin/business 는 IT 전용 컬럼 제외 + it_status Completed->Verified 만,
--   it_dept 는 IT 전용 컬럼만(Verified 불가). auth.* 직접 호출 없음(csr_actor_id 래퍼).
-- =============================================================================

CREATE OR REPLACE FUNCTION public.csr_issues_column_guard()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  it_cols     text[] := ARRAY['it_status', 'it_pic', 'target_release_on', 'it_decision',
                              'it_reply_summary_ko', 'it_reply_summary_id'];
  system_cols text[] := ARRAY['id', 'created_at', 'updated_at', 'updated_by'];
  actor_role  text;
  changed     text[];
  col         text;
BEGIN
  -- console / migration sessions (no JWT) pass through, same as 011
  IF current_user NOT IN ('authenticated', 'anonymous') THEN
    NEW.updated_at := now();
    RETURN NEW;
  END IF;

  actor_role := public.csr_role();
  IF actor_role IS NULL THEN
    RAISE EXCEPTION 'CSR: user not registered in csr_user_roles' USING ERRCODE = '42501';
  END IF;
  IF actor_role <> ALL (ARRAY['admin', 'it_dept', 'business']) THEN
    RAISE EXCEPTION 'CSR: unknown role %', actor_role USING ERRCODE = '42501';
  END IF;

  -- only columns whose value actually changed
  SELECT COALESCE(array_agg(n.key), '{}'::text[])
    INTO changed
    FROM jsonb_each_text(to_jsonb(NEW)) AS n
   WHERE n.key <> ALL (ARRAY['updated_at', 'updated_by'])
     AND n.value IS DISTINCT FROM (to_jsonb(OLD) ->> n.key);

  FOREACH col IN ARRAY changed LOOP
    IF col = ANY (system_cols) THEN
      RAISE EXCEPTION 'CSR: column % is system-managed', col USING ERRCODE = '42501';
    END IF;
  END LOOP;

  IF actor_role IN ('admin', 'business') THEN
    -- business side: no IT-only columns; it_status only Completed -> Verified
    FOREACH col IN ARRAY changed LOOP
      IF col = 'it_status' THEN
        IF NOT (OLD.it_status = 'Completed' AND NEW.it_status = 'Verified') THEN
          RAISE EXCEPTION 'CSR: it_status % to % not allowed for role % (Completed to Verified only)',
            OLD.it_status, NEW.it_status, actor_role USING ERRCODE = '42501';
        END IF;
      ELSIF col = ANY (it_cols) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role % (IT department only)', col, actor_role
          USING ERRCODE = '42501';
      END IF;
    END LOOP;
  ELSIF actor_role = 'it_dept' THEN
    -- IT side: IT-only columns; cannot set or revert Verified
    FOREACH col IN ARRAY changed LOOP
      IF NOT (col = ANY (it_cols)) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role it_dept', col USING ERRCODE = '42501';
      END IF;
      IF col = 'it_status' THEN
        IF NEW.it_status = 'Verified' THEN
          RAISE EXCEPTION 'CSR: it_status Verified is set by the business side (admin)' USING ERRCODE = '42501';
        END IF;
        IF OLD.it_status = 'Verified' THEN
          RAISE EXCEPTION 'CSR: it_status Verified is final and cannot be changed by it_dept' USING ERRCODE = '42501';
        END IF;
      END IF;
    END LOOP;
  END IF;

  NEW.updated_at := now();
  NEW.updated_by := public.csr_actor_id();
  RETURN NEW;
END;
$fn$;

DROP TRIGGER IF EXISTS csr_issues_column_guard ON public.csr_issues;
CREATE TRIGGER csr_issues_column_guard
  BEFORE UPDATE ON public.csr_issues
  FOR EACH ROW EXECUTE FUNCTION public.csr_issues_column_guard();

-- 확인
UPDATE public.csr_issues SET updated_at = updated_at WHERE false;
SELECT 'guard v2 ok' AS result;
