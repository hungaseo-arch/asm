-- =============================================================================
-- ASM CSR — 컬럼 가드: 콘솔(DB 소유자) 세션은 통과 (2026-09-10 실측 버그 수정)
--   001~010 적용 순서와 무관하게 실행 가능. 이것을 돌린 뒤 008 · 010 을 다시 실행하십시오.
--
-- ── 증상 ────────────────────────────────────────────────────────────────────
-- Neon SQL Editor 에서 008(화면경로) · 010(본문 번역)을 실행하면 UPDATE 문만 ERROR 로 끝나고
-- 데이터가 그대로였습니다(탭에 "3: ERROR", "9: ERROR"). v1·v2·v3 로 문장 형태를 바꿔도 같았습니다.
--
-- ── 원인 ────────────────────────────────────────────────────────────────────
-- csr_issues 의 BEFORE UPDATE 가드(006)가 public.csr_role() 을 부르는데, 콘솔 세션에는 JWT 가
-- 없어 auth.user_id() 가 NULL → csr_role() 이 NULL → 가드가 "등록되지 않은 사용자" 로
-- 42501 을 던집니다. 즉 **콘솔에서 하는 모든 UPDATE 가 가드에 막혔습니다.** ($$ 파싱 문제가
-- 아니었습니다 — 001~007 의 함수들은 같은 편집기에서 정상 생성됐습니다.)
--
-- ── 조치 ────────────────────────────────────────────────────────────────────
-- Data API 는 언제나 `authenticated`(또는 `anonymous`) 역할로 실행됩니다. 그 밖의 역할(콘솔의
-- DB 소유자, 마이그레이션)은 JWT 가 없는 신뢰된 유지보수 세션이므로 가드를 그대로 통과시키되
-- updated_at 만 찍습니다. 앱 사용자에 대한 판정은 006 과 한 글자도 다르지 않습니다.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.csr_issues_column_guard()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $fn$
DECLARE
  it_only     text[] := ARRAY['it_status', 'it_pic', 'target_release_on',
                              'it_reply_summary_ko', 'it_reply_summary_id'];
  system_cols text[] := ARRAY['id', 'created_at', 'updated_at', 'updated_by'];
  actor_role  text;
  changed     text[];
  col         text;
BEGIN
  -- 콘솔·마이그레이션(JWT 없는 DB 역할)은 통과. Data API 요청은 늘 authenticated/anonymous 입니다.
  IF current_user NOT IN ('authenticated', 'anonymous') THEN
    NEW.updated_at := now();
    RETURN NEW;
  END IF;

  actor_role := public.csr_role();

  IF actor_role IS NULL THEN
    RAISE EXCEPTION 'CSR: 등록되지 않은 사용자입니다 (csr_user_roles 에 없음)'
      USING ERRCODE = '42501';
  END IF;

  -- 아는 역할이 아니면 아무것도 못 바꿉니다.
  IF actor_role <> ALL (ARRAY['admin', 'it_dept', 'business']) THEN
    RAISE EXCEPTION 'CSR: 알 수 없는 역할 % — 권한을 판정할 수 없습니다', actor_role
      USING ERRCODE = '42501';
  END IF;

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

-- 확인 — 콘솔에서 무해한 UPDATE 가 통과하는지(0행 대상이라 아무것도 안 바뀝니다).
UPDATE public.csr_issues SET updated_at = updated_at WHERE false;
SELECT current_user AS console_role, 'guard bypass ok' AS result;
