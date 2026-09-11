-- =============================================================================
-- 컬럼 가드 v3 — admin 도 담당자(it_pic)를 고칠 수 있게 (2026-09-11 「담당자 입력창 추가」)
--   015b 다음 버전. 파일째 실행($fn$). 재실행 안전.
--   v2(015b)와의 차이는 한 줄: admin 이 it_pic 을 바꾸는 것을 허용. 나머지(IT 전용 컬럼 · Completed->Verified 만 ·
--   it_dept 범위)는 그대로. business 는 여전히 it_pic 불가. 화면 쪽 거울은 config.canEditColumn.
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
    FOREACH col IN ARRAY changed LOOP
      IF col = 'it_status' THEN
        IF NOT (OLD.it_status = 'Completed' AND NEW.it_status = 'Verified') THEN
          RAISE EXCEPTION 'CSR: it_status % to % not allowed for role % (Completed to Verified only)',
            OLD.it_status, NEW.it_status, actor_role USING ERRCODE = '42501';
        END IF;
      ELSIF col = 'it_pic' AND actor_role = 'admin' THEN
        NULL;  -- v3: admin may (re)assign the PIC
      ELSIF col = ANY (it_cols) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role % (IT department only)', col, actor_role
          USING ERRCODE = '42501';
      END IF;
    END LOOP;
  ELSIF actor_role = 'it_dept' THEN
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

-- 확인
UPDATE public.csr_issues SET updated_at = updated_at WHERE false;
SELECT 'guard v3 ok (admin may edit it_pic)' AS result;
