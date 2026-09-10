-- =============================================================================
-- ASM CSR — 적용 결과 통합 점검 (읽기 전용)
--   아무 때나 실행해도 안전합니다. 아무것도 만들지도 고치지도 않습니다.
--   결과 표를 그대로 알려 주시면 다음 단계를 판정해 드립니다.
--
--   '상태' 열이 기대와 다른 행만 보면 됩니다.
-- =============================================================================

WITH checks AS (

  -- ── 001 스키마 ────────────────────────────────────────────────────────────
  SELECT 1 AS no, '001' AS 단계, '테이블 6종' AS 항목, '6' AS 기대,
         count(*)::text AS 실제
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind = 'r'
     AND relname LIKE 'csr!_%' ESCAPE '!'

  UNION ALL
  SELECT 2, '001', '인덱스 (PK·UNIQUE 포함)', '16',
         count(*)::text
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind = 'i'
     AND relname LIKE 'csr!_%' ESCAPE '!'

  -- ── 002 RLS ───────────────────────────────────────────────────────────────
  UNION ALL
  SELECT 3, '002', 'RLS 활성 테이블', '6',
         count(*)::text
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind = 'r'
     AND relname LIKE 'csr!_%' ESCAPE '!' AND relrowsecurity

  UNION ALL
  SELECT 4, '002', 'RLS 정책', '16',
         count(*)::text
    FROM pg_policies
   WHERE schemaname = 'public' AND tablename LIKE 'csr!_%' ESCAPE '!'

  UNION ALL
  -- 정책만 있고 GRANT 가 없으면 Data API 조회가 빈 결과나 401/403 으로 나옵니다.
  SELECT 5, '002', 'authenticated 테이블 권한', '6',
         count(DISTINCT table_name)::text
    FROM information_schema.role_table_grants
   WHERE grantee = 'authenticated' AND table_schema = 'public'
     AND table_name LIKE 'csr!_%' ESCAPE '!'

  -- ── 003 트리거 ────────────────────────────────────────────────────────────
  UNION ALL
  SELECT 6, '003', 'csr_issues 트리거', '2',
         count(*)::text
    FROM pg_trigger
   WHERE tgrelid = 'public.csr_issues'::regclass AND NOT tgisinternal

  UNION ALL
  SELECT 7, '003', '함수 4종', '4',
         count(*)::text
    FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
   WHERE n.nspname = 'public'
     AND p.proname IN ('csr_role', 'csr_next_issue_no',
                       'csr_issues_column_guard', 'csr_issues_status_log')

  -- ── 005 issue_no 부분 UNIQUE (Phase 2 선행) ───────────────────────────────
  UNION ALL
  SELECT 8, '005', '전체 UNIQUE 제거됨', 'true',
         (NOT EXISTS (
           SELECT 1 FROM pg_constraint
            WHERE conrelid = 'public.csr_issues'::regclass
              AND conname = 'csr_issues_issue_no_key'
         ))::text

  UNION ALL
  SELECT 9, '005', '부분 UNIQUE 인덱스', 'true',
         EXISTS (
           SELECT 1 FROM pg_indexes
            WHERE schemaname = 'public' AND tablename = 'csr_issues'
              AND indexname = 'csr_issues_issue_no_live_uniq'
         )::text

  -- ── 006 department · 가드 강화 ────────────────────────────────────────────
  UNION ALL
  SELECT 10, '006', 'department 컬럼', 'true',
         EXISTS (
           SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'public' AND table_name = 'csr_user_roles'
              AND column_name = 'department'
         )::text

  UNION ALL
  -- 모르는 역할을 거부하는 방어가 들어갔는지 함수 본문으로 확인합니다.
  SELECT 11, '006', '컬럼 가드 강화 반영', 'true',
         EXISTS (
           SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
            WHERE n.nspname = 'public' AND p.proname = 'csr_issues_column_guard'
              AND p.prosrc LIKE '%알 수 없는 역할%'
         )::text

  -- ── 004 사용자 등록 ───────────────────────────────────────────────────────
  UNION ALL
  SELECT 12, '004', '등록 사용자', '9',
         count(*)::text FROM public.csr_user_roles

  UNION ALL
  SELECT 13, '004', 'admin / it_dept 분리', 'true',
         (EXISTS (SELECT 1 FROM public.csr_user_roles WHERE role = 'admin')
          AND EXISTS (SELECT 1 FROM public.csr_user_roles WHERE role = 'it_dept'))::text

  -- ── 이관 ──────────────────────────────────────────────────────────────────
  UNION ALL
  SELECT 14, 'insert', '이슈', '63', count(*)::text FROM public.csr_issues
  UNION ALL
  SELECT 15, 'insert', '아카이브', '3', count(*)::text FROM public.csr_issues WHERE is_archived
  UNION ALL
  SELECT 16, 'insert', 'IT회신', '42', count(*)::text FROM public.csr_it_replies
  UNION ALL
  SELECT 17, 'insert', '검증이력', '146', count(*)::text FROM public.csr_verifications

  -- ── 환경 ──────────────────────────────────────────────────────────────────
  UNION ALL
  SELECT 18, 'env', 'auth 스키마', 'true',
         EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'auth')::text
  UNION ALL
  SELECT 19, 'env', 'neon_auth 계정 수', '9 이상',
         (SELECT count(*)::text FROM neon_auth."user" WHERE deleted_at IS NULL)
)
SELECT no AS "#", 단계, 항목, 기대, 실제,
       CASE WHEN 실제 = split_part(기대, ' ', 1) THEN 'OK' ELSE '확인' END AS 상태
  FROM checks
 ORDER BY no;

-- ─── 참고 1. 등록된 사용자 (004 적용 후) ────────────────────────────────────
SELECT role, department, email, display_name
  FROM public.csr_user_roles
 ORDER BY CASE role WHEN 'admin' THEN 1 WHEN 'it_dept' THEN 2 ELSE 3 END, department, email;

-- ─── 참고 2. 상태 분포 (이관 후 — 작업지시서 §4-4) ──────────────────────────
-- 기대: Open 35 · Ongoing 14 · Verified 6 · Completed 5 · N/A 3
SELECT it_status, count(*) FROM public.csr_issues GROUP BY 1 ORDER BY 2 DESC;

-- ─── 참고 3. 채번 함수 ──────────────────────────────────────────────────────
SELECT public.csr_next_issue_no() AS next_issue_no;
