-- =============================================================================
-- ASM CSR — issue_no 유일성 제약 완화 (부분 UNIQUE 로 교체)
--   Phase 2 이관 전에 적용해야 합니다. 001~003 적용 후 실행.
--
-- ── 왜 필요한가 ─────────────────────────────────────────────────────────────
-- 작업지시서 §4-3 은 이슈번호 '(삭제) 48' 을 '48' + is_archived=true 로 저장하라고
-- 정합니다. 그런데 원본 63건을 실측해 보니 살아 있는 '48' 이 따로 존재합니다.
--
--   (삭제) 48 [archived] + 48 [live]
--   (삭제) 50 [archived] + 50 [live]
--   (삭제) 52 [archived] + 52 [live]
--
-- 즉 접두를 떼면 3쌍이 충돌해 001_schema.sql 의 UNIQUE (issue_no) 를 위반합니다.
-- 삭제된 건이 같은 번호로 다시 발급된 정상적인 이력이므로, 데이터가 아니라 제약을
-- 고칩니다.
--
-- 살아 있는 이슈끼리의 번호 중복은 여전히 막아야 하므로 UNIQUE 를 없애지 않고
-- **부분 UNIQUE 인덱스**로 바꿉니다 — 아카이브가 아닌 행에 대해서만 유일성을 강제합니다.
-- =============================================================================

BEGIN;

-- 001_schema.sql 이 만든 전체 UNIQUE 제약을 걷어냅니다.
ALTER TABLE public.csr_issues DROP CONSTRAINT IF EXISTS csr_issues_issue_no_key;

-- 살아 있는(=아카이브가 아닌) 이슈끼리만 번호가 겹치지 않도록 합니다.
CREATE UNIQUE INDEX IF NOT EXISTS csr_issues_issue_no_live_uniq
  ON public.csr_issues (issue_no)
  WHERE NOT is_archived;

COMMENT ON INDEX public.csr_issues_issue_no_live_uniq IS
  '살아 있는 이슈의 번호만 유일. 삭제 후 같은 번호가 재발급된 이력이 있어 전체 UNIQUE 는 쓸 수 없습니다.';

COMMIT;

-- ─── 확인 ────────────────────────────────────────────────────────────────────
-- csr_issues_issue_no_key 가 사라지고 csr_issues_issue_no_live_uniq 가 보여야 합니다.
SELECT indexname, indexdef
  FROM pg_indexes
 WHERE schemaname = 'public' AND tablename = 'csr_issues'
   AND indexdef LIKE '%UNIQUE%'
 ORDER BY 1;
