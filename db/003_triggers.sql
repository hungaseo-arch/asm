-- =============================================================================
-- ASM CSR — 컬럼 가드 · 상태 로그 트리거
--   작업지시서 §3-2 / 002_rls_policies.sql 적용 후 실행
--
-- RLS 는 '어떤 행'까지만 정합니다. '어떤 컬럼'을 바꿀 수 있는지는 여기서 판정합니다.
-- 프론트의 CSR_POLICY(작업지시서 §5-3)는 이 규칙을 화면에 비추기만 할 뿐이고,
-- 실제 거부는 항상 이 트리거가 합니다.
-- =============================================================================

BEGIN;

-- ─── 컬럼 가드 (BEFORE UPDATE) ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.csr_issues_column_guard()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  -- IT부서 전용 컬럼 — business 는 손댈 수 없습니다(it_status 는 아래에서 따로 처리).
  it_only    text[] := ARRAY['it_status', 'it_pic', 'target_release_on',
                             'it_reply_summary_ko', 'it_reply_summary_id'];
  -- 시스템이 관리하는 컬럼 — 누구도 직접 값을 넣지 않습니다.
  system_cols text[] := ARRAY['id', 'created_at', 'updated_at', 'updated_by'];
  actor_role text := public.csr_role();
  changed    text[];
  col        text;
BEGIN
  IF actor_role IS NULL THEN
    RAISE EXCEPTION 'CSR: 등록되지 않은 사용자입니다 (csr_user_roles 에 없음)'
      USING ERRCODE = '42501';
  END IF;

  -- 실제로 값이 달라진 컬럼만 봅니다. 화면이 폼 전체를 되보내더라도 안 바뀐 값은
  -- 위반으로 세지 않습니다 — 그러지 않으면 it_dept 가 회신만 고쳐도 거부됩니다.
  -- updated_at·updated_by 는 아래에서 우리가 덮어쓰므로 비교에서 뺍니다.
  SELECT COALESCE(array_agg(n.key), '{}'::text[])
    INTO changed
    FROM jsonb_each_text(to_jsonb(NEW)) AS n
   WHERE n.key <> ALL (ARRAY['updated_at', 'updated_by'])
     AND n.value IS DISTINCT FROM (to_jsonb(OLD) ->> n.key);

  IF actor_role <> 'admin' THEN
    FOREACH col IN ARRAY changed LOOP
      IF col = ANY (system_cols) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role %', col, actor_role
          USING ERRCODE = '42501';
      END IF;
    END LOOP;
  END IF;

  IF actor_role = 'it_dept' THEN
    FOREACH col IN ARRAY changed LOOP
      IF NOT (col = ANY (it_only)) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role %', col, actor_role
          USING ERRCODE = '42501';
      END IF;
    END LOOP;

  ELSIF actor_role = 'business' THEN
    FOREACH col IN ARRAY changed LOOP
      -- it_status 는 유일한 예외 — 검증을 마친 현업이 Completed 를 Verified 로 닫습니다.
      IF col = 'it_status' THEN
        IF NOT (OLD.it_status = 'Completed' AND NEW.it_status = 'Verified') THEN
          RAISE EXCEPTION 'CSR: it_status % -> % not allowed for role business (Completed -> Verified only)',
            OLD.it_status, NEW.it_status
            USING ERRCODE = '42501';
        END IF;
      ELSIF col = ANY (it_only) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role %', col, actor_role
          USING ERRCODE = '42501';
      END IF;
    END LOOP;
  END IF;

  NEW.updated_at := now();
  NEW.updated_by := auth.user_id();
  RETURN NEW;
END;
$fn$;

DROP TRIGGER IF EXISTS csr_issues_column_guard ON public.csr_issues;
CREATE TRIGGER csr_issues_column_guard
  BEFORE UPDATE ON public.csr_issues
  FOR EACH ROW EXECUTE FUNCTION public.csr_issues_column_guard();

-- ─── 상태 로그 (AFTER UPDATE) ────────────────────────────────────────────────
-- 감시 대상 5개 컬럼이 바뀔 때마다 csr_status_log 에 한 줄씩 남깁니다.
--
-- SECURITY DEFINER 인 이유: csr_status_log 에는 INSERT 정책이 없습니다(002). 아무도
-- 직접 로그를 쓰거나 고칠 수 없게 두고, 적재는 소유자 권한인 이 트리거만 합니다.
CREATE OR REPLACE FUNCTION public.csr_issues_status_log()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  watched text[] := ARRAY['it_status', 'it_decision', 'verification_result',
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
      VALUES (NEW.id, auth.user_id(), col, old_value, new_value);
    END IF;
  END LOOP;

  RETURN NULL;  -- AFTER 트리거의 반환값은 쓰이지 않습니다.
END;
$fn$;

REVOKE ALL ON FUNCTION public.csr_issues_status_log() FROM PUBLIC;

DROP TRIGGER IF EXISTS csr_issues_status_log ON public.csr_issues;
CREATE TRIGGER csr_issues_status_log
  AFTER UPDATE ON public.csr_issues
  FOR EACH ROW EXECUTE FUNCTION public.csr_issues_status_log();

COMMIT;
