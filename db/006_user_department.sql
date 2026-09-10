-- =============================================================================
-- ASM CSR — 사용자 부서 컬럼 추가 · 컬럼 가드 강화
--   001~003 적용 후 실행. 004_seed_roles.sql 보다 먼저 적용하십시오.
--
-- ── 왜 필요한가 ─────────────────────────────────────────────────────────────
-- 계정을 정리하다 보니 실제 사용자가 9명이고 소속이 영업·수입·재무로 갈립니다.
-- 그런데 CSR 의 `role` 은 **권한 등급**이라 admin · it_dept · business 세 개뿐이고,
-- RLS 정책(002)과 컬럼 가드(003)가 그 세 값에 1:1로 묶여 있습니다.
--
-- 소속을 role 에 넣으면 CHECK 제약을 어길 뿐 아니라 권한 판정이 통째로 무너집니다.
-- 그래서 권한(role)과 소속(department)을 분리합니다 — 권한은 셋, 소속은 자유 텍스트.
-- =============================================================================

BEGIN;

-- ─── 소속 ────────────────────────────────────────────────────────────────────
ALTER TABLE public.csr_user_roles
  ADD COLUMN IF NOT EXISTS department text;

COMMENT ON COLUMN public.csr_user_roles.department IS
  '소속(sales · sales_admin · import · finance · it 등). 권한과 무관한 표시·집계용입니다.';
COMMENT ON COLUMN public.csr_user_roles.role IS
  '권한 등급 3종. 소속을 넣지 마십시오 — RLS 정책과 컬럼 가드가 이 값에 묶여 있습니다.';

-- ─── 컬럼 가드 강화 ──────────────────────────────────────────────────────────
-- 003 의 가드는 it_dept 도 business 도 아닌 역할이 오면 어느 분기에도 걸리지 않아
-- 전 컬럼 편집을 허용했습니다. 지금은 CHECK 제약이 그런 값을 막지만, 제약이 느슨해지는
-- 날을 대비해 트리거가 스스로 거부하도록 합니다(모르는 역할 = 거부).
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
  actor_role  text := public.csr_role();
  changed     text[];
  col         text;
BEGIN
  IF actor_role IS NULL THEN
    RAISE EXCEPTION 'CSR: 등록되지 않은 사용자입니다 (csr_user_roles 에 없음)'
      USING ERRCODE = '42501';
  END IF;

  -- 아는 역할이 아니면 아무것도 못 바꿉니다. 003 에는 이 방어가 없었습니다.
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

COMMIT;

-- ─── 확인 ────────────────────────────────────────────────────────────────────
SELECT column_name, data_type
  FROM information_schema.columns
 WHERE table_schema = 'public' AND table_name = 'csr_user_roles'
 ORDER BY ordinal_position;
