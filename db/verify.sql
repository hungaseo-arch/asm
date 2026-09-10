-- =============================================================================
-- ASM CSR — 적용 결과 통합 점검 (읽기 전용)
--   001~004 를 적용한 뒤 이 파일 하나만 실행하고, 결과 표를 그대로 알려 주십시오.
--   아무것도 만들지도 고치지도 않습니다.
--
--   절차서 §4 의 점검 1~3 을 한 번에 돌리고, 004 와 Phase 3 에 필요한 확인을 더했습니다.
-- =============================================================================

WITH checks AS (

  SELECT 1 AS no, '테이블 6종' AS 항목, '6' AS 기대,
         count(*)::text AS 실제
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind = 'r'
     AND relname LIKE 'csr!_%' ESCAPE '!'

  UNION ALL
  SELECT 2, 'RLS 활성 테이블', '6',
         count(*)::text
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind = 'r'
     AND relname LIKE 'csr!_%' ESCAPE '!' AND relrowsecurity

  UNION ALL
  SELECT 3, 'RLS 정책', '16',
         count(*)::text
    FROM pg_policies
   WHERE schemaname = 'public' AND tablename LIKE 'csr!_%' ESCAPE '!'

  UNION ALL
  SELECT 4, 'csr_issues 트리거', '2',
         count(*)::text
    FROM pg_trigger
   WHERE tgrelid = 'public.csr_issues'::regclass AND NOT tgisinternal

  UNION ALL
  SELECT 5, '함수 4종', '4',
         count(*)::text
    FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
   WHERE n.nspname = 'public'
     AND p.proname IN ('csr_role', 'csr_next_issue_no',
                       'csr_issues_column_guard', 'csr_issues_status_log')

  UNION ALL
  SELECT 6, '인덱스 (PK·UNIQUE 포함)', '16',
         count(*)::text
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind = 'i'
     AND relname LIKE 'csr!_%' ESCAPE '!'

  UNION ALL
  -- 002 의 GRANT 가 실제로 걸렸는지. 0 이면 Data API 로 조회 시 빈 결과나 401/403 이 납니다.
  SELECT 7, 'authenticated 테이블 권한', '6',
         count(DISTINCT table_name)::text
    FROM information_schema.role_table_grants
   WHERE grantee = 'authenticated' AND table_schema = 'public'
     AND table_name LIKE 'csr!_%' ESCAPE '!'

  UNION ALL
  -- C-6 보류 중이므로 지금은 0 이 정상입니다.
  SELECT 8, 'csr_user_roles 등록 계정', '0 (C-6 보류 중)',
         count(*)::text
    FROM public.csr_user_roles

  UNION ALL
  SELECT 9, 'auth 스키마', 'true',
         EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'auth')::text

  UNION ALL
  -- 2026-09-10 실측: Better Auth 기반 Neon Auth 에는 users_sync 가 없습니다(false 가 정상).
  -- 004_seed_roles.sql 은 아래 참고 2 에서 확인한 실제 사용자 테이블을 참조하도록 고쳤습니다.
  SELECT 10, 'neon_auth 스키마 테이블 수', '9',
         (SELECT count(*)::text
            FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
           WHERE n.nspname = 'neon_auth' AND c.relkind IN ('r', 'v', 'm'))

  UNION ALL
  SELECT 11, '이슈 데이터 (Phase 2 대상)', '0 (아직 이관 전)',
         count(*)::text
    FROM public.csr_issues
)
SELECT no AS "#", 항목, 기대, 실제,
       CASE WHEN 실제 = split_part(기대, ' ', 1) THEN 'OK' ELSE '확인' END AS 판정
  FROM checks
 ORDER BY no;

-- ─── 참고 1. Neon Auth 가 노출하는 함수 목록 ─────────────────────────────────
-- 002 가 성공했다면 user_id 가 여기 있을 것입니다.
SELECT p.proname AS auth_function, pg_get_function_result(p.oid) AS returns
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
 WHERE n.nspname = 'auth'
 ORDER BY 1;

-- ─── 참고 2. neon_auth 스키마의 테이블 ───────────────────────────────────────
-- users_sync 가 없다면 여기 보이는 이름이 실제 사용자 테이블입니다
-- (Neon Auth 가 Better Auth 기반으로 바뀌며 이름이 달라졌을 수 있습니다).
-- 다르면 알려 주십시오 — 004_seed_roles.sql 의 JOIN 한 줄만 바꾸면 됩니다.
SELECT c.relname AS neon_auth_table,
       string_agg(a.attname, ', ' ORDER BY a.attnum) AS columns
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
 WHERE n.nspname = 'neon_auth' AND c.relkind IN ('r', 'v', 'm')
 GROUP BY 1
 ORDER BY 1;

-- ─── 참고 3. 채번 함수가 도는지 ──────────────────────────────────────────────
-- 이번 달 첫 번호가 나와야 합니다 (예: CSR-202609-001).
SELECT public.csr_next_issue_no() AS next_issue_no;
