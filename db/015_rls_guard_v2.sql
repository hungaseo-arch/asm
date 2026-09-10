-- =============================================================================
-- ※ 2026-09-10 콘솔 실행 시 6번째 문장(컬럼 가드)이 ERROR → 015b(가드) · 015c(상태 로그)로 나눠 재실행.
--    이 파일의 1~5(csr_actor_id 래퍼 + GRANT)는 적용됨. 이 파일 전체를 다시 돌려도 무해합니다.
-- =============================================================================
-- [CSR-1.1-A] csr_issues UPDATE 403 수정 + 역할별 컬럼 범위(R&R 2026-09-08) 재정의
--   001~014 적용 후 실행. 달러 인용($fn$)이 있으므로 Neon SQL Editor 에서 파일째 실행하십시오.
--   재실행 안전(CREATE OR REPLACE · DROP IF EXISTS).
--
-- ── 현상 (2026-09-10 실측, 계정 alya/business · 서종환/admin 공통) ──────────────
--   PATCH /rest/v1/csr_issues?id=eq.48  →  403  {"code":"42501","message":"permission denied for schema auth"}
--   값이 하나도 안 바뀌는 갱신조차 같은 오류. 검증 이력 INSERT 는 정상.
--
-- ── 원인 ────────────────────────────────────────────────────────────────────
--   컬럼 가드 csr_issues_column_guard(003/011)가 SECURITY INVOKER 로 돌면서 auth.user_id() 를
--   부릅니다. Data API 의 authenticated 역할에는 auth 스키마 USAGE 가 없습니다. 009 로 GRANT 를
--   줬지만 실측 결과 권한이 남아 있지 않습니다(Neon Auth 가 Beta 라 스키마가 다시 만들어지면
--   GRANT 가 사라집니다). 즉 GRANT 에 기대는 방식은 언제든 재발합니다.
--
-- ── 조치 ────────────────────────────────────────────────────────────────────
--   1. public.csr_actor_id() — SECURITY DEFINER 로 auth.user_id() 를 감싼 래퍼. 앱 역할에 auth
--      스키마 권한이 없어도 동작하고, 콘솔(JWT 없음)에서는 NULL 또는 set_config('csr.actor') 값.
--   2. 컬럼 가드 v2 — auth.* 를 직접 부르지 않고 래퍼만 사용. 역할별 컬럼 범위를 R&R 에 맞춰 재정의:
--        admin · business (현업·총괄팀): IT 전용 컬럼 제외 전부 + it_status 는 Completed → Verified 만
--        it_dept (IT부서)              : it_status(Verified 제외) · it_pic · target_release_on ·
--                                        it_decision(IT수용여부) · it_reply_summary_ko/id
--      ※ it_decision 이 현업 → IT 로 옮겨졌습니다(지시서 A-2). 프론트 config.CSR_POLICY 도 같이 바꿉니다.
--   3. 상태 로그 트리거도 래퍼를 쓰도록 재생성(변경자 기록).
--   RLS 정책(002)은 그대로입니다 — 행 단위는 이미 맞고, 컬럼 단위는 이 트리거가 판정합니다.
-- =============================================================================

-- ─── 1. 행위자 ID 래퍼 ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.csr_actor_id()
RETURNS text
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  v text;
BEGIN
  BEGIN
    v := auth.user_id();
  EXCEPTION WHEN OTHERS THEN
    v := NULL;  -- auth 스키마가 없거나 접근 불가한 세션(콘솔 · 마이그레이션)
  END;
  -- 콘솔 작업은 SELECT set_config('csr.actor', '...', false) 로 이름을 남길 수 있습니다.
  RETURN COALESCE(v, NULLIF(current_setting('csr.actor', true), ''));
END;
$fn$;
COMMENT ON FUNCTION public.csr_actor_id() IS 'auth.user_id() 의 SECURITY DEFINER 래퍼 — 앱 역할에 auth 스키마 권한이 없어도 동작. 콘솔에서는 csr.actor 설정값.';
REVOKE ALL ON FUNCTION public.csr_actor_id() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.csr_actor_id() TO authenticated;
GRANT EXECUTE ON FUNCTION public.csr_actor_id() TO anonymous;

-- ─── 2. 컬럼 가드 v2 ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.csr_issues_column_guard()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  -- IT부서 전용 컬럼 (지시서 A-2). it_decision 포함 — 종전(003)에는 없었습니다.
  it_cols     text[] := ARRAY['it_status', 'it_pic', 'target_release_on', 'it_decision',
                              'it_reply_summary_ko', 'it_reply_summary_id'];
  system_cols text[] := ARRAY['id', 'created_at', 'updated_at', 'updated_by'];
  actor_role  text;
  changed     text[];
  col         text;
BEGIN
  -- 콘솔·마이그레이션(JWT 없는 DB 역할)은 통과 — 011 과 같습니다.
  IF current_user NOT IN ('authenticated', 'anonymous') THEN
    NEW.updated_at := now();
    RETURN NEW;
  END IF;

  actor_role := public.csr_role();
  IF actor_role IS NULL THEN
    RAISE EXCEPTION 'CSR: 등록되지 않은 사용자입니다 (csr_user_roles 에 없음)' USING ERRCODE = '42501';
  END IF;
  IF actor_role <> ALL (ARRAY['admin', 'it_dept', 'business']) THEN
    RAISE EXCEPTION 'CSR: 알 수 없는 역할 % — 권한을 판정할 수 없습니다', actor_role USING ERRCODE = '42501';
  END IF;

  -- 실제로 값이 달라진 컬럼만 봅니다(폼 전체를 되보내도 안 바뀐 값은 위반이 아닙니다).
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
    -- 현업·총괄팀: IT 전용 컬럼은 못 바꾸고, it_status 는 Completed → Verified 로 닫는 것만.
    FOREACH col IN ARRAY changed LOOP
      IF col = 'it_status' THEN
        IF NOT (OLD.it_status = 'Completed' AND NEW.it_status = 'Verified') THEN
          RAISE EXCEPTION 'CSR: it_status % -> % not allowed for role % (Completed -> Verified only)',
            OLD.it_status, NEW.it_status, actor_role USING ERRCODE = '42501';
        END IF;
      ELSIF col = ANY (it_cols) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role % (IT department only)', col, actor_role
          USING ERRCODE = '42501';
      END IF;
    END LOOP;

  ELSIF actor_role = 'it_dept' THEN
    -- IT부서: IT 전용 컬럼만. Verified 로 올리거나 Verified 를 되돌리는 것은 현업 몫.
    FOREACH col IN ARRAY changed LOOP
      IF NOT (col = ANY (it_cols)) THEN
        RAISE EXCEPTION 'CSR: column % not editable by role it_dept', col USING ERRCODE = '42501';
      END IF;
      IF col = 'it_status' THEN
        IF NEW.it_status = 'Verified' THEN
          RAISE EXCEPTION 'CSR: it_status -> Verified is decided by the business side (admin)'
            USING ERRCODE = '42501';
        END IF;
        IF OLD.it_status = 'Verified' THEN
          RAISE EXCEPTION 'CSR: it_status Verified is final — cannot be changed by it_dept'
            USING ERRCODE = '42501';
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

-- ─── 3. 상태 로그 — 변경자를 래퍼로 ───────────────────────────────────────────
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

-- ─── 확인 (dry-run) ──────────────────────────────────────────────────────────
-- 콘솔에서 무해한 UPDATE 가 통과하는지(0행 대상).
UPDATE public.csr_issues SET updated_at = updated_at WHERE false;
-- 정책 · 트리거 목록 — 보고용.
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'csr_issues' ORDER BY policyname;
SELECT tgname, tgenabled FROM pg_trigger WHERE tgrelid = 'public.csr_issues'::regclass AND NOT tgisinternal ORDER BY tgname;
SELECT has_function_privilege('authenticated', 'public.csr_actor_id()', 'EXECUTE') AS actor_id_exec_ok;
