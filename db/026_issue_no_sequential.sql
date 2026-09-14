-- =============================================================================
-- 이슈 번호 한 체계로 통일 (2026-09-14 결정) — CSR-YYYYMM-nnn 폐지, 문서와 같은 연번
--   024 · 025 적용 후 실행. 달러 인용($fn$) 있음 — 파일째 실행. 재실행 안전.
--
--   CSR-202609-001 → 69, CSR-202609-002 → 70 (문서: 61~68 다음 신규는 69번부터).
--   참조 문구(27 관련이슈 · 27 검증 이력 268)도 함께 바꿉니다. 채번 함수는 「숫자 번호 최대값 + 1」로 교체.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:026 (번호 통일)', false);

UPDATE public.csr_issues SET issue_no = '69' WHERE issue_no = 'CSR-202609-001';
UPDATE public.csr_issues SET issue_no = '70' WHERE issue_no = 'CSR-202609-002';

UPDATE public.csr_issues
   SET related_issues = replace(related_issues, 'CSR-202609-002', '70')
 WHERE related_issues LIKE '%CSR-202609-002%';
UPDATE public.csr_issues
   SET related_issues = replace(related_issues, 'CSR-202609-001', '69')
 WHERE related_issues LIKE '%CSR-202609-001%';

UPDATE public.csr_verifications
   SET note    = replace(replace(note,    'CSR-202609-002', '70'), 'CSR-202609-001', '69'),
       note_ko = replace(replace(note_ko, 'CSR-202609-002', '70'), 'CSR-202609-001', '69'),
       note_id = replace(replace(note_id, 'CSR-202609-002', '70'), 'CSR-202609-001', '69')
 WHERE note LIKE '%CSR-202609-%' OR note_ko LIKE '%CSR-202609-%' OR note_id LIKE '%CSR-202609-%';

-- 채번: 숫자 번호의 최대값 + 1 (두 자리 미만은 0 채움 — '01'~'09' 와 같은 꼴)
CREATE OR REPLACE FUNCTION public.csr_next_issue_no()
RETURNS text
LANGUAGE plpgsql
STABLE
AS $fn$
DECLARE
  seq int;
BEGIN
  SELECT COALESCE(MAX(issue_no::int), 0) + 1
    INTO seq
    FROM public.csr_issues
   WHERE issue_no ~ '^[0-9]+$';
  RETURN lpad(seq::text, 2, '0');
END;
$fn$;
COMMENT ON FUNCTION public.csr_next_issue_no() IS '신규 등록용 이슈번호 — 숫자 번호 최대값 + 1 (2026-09-14 연번 통일, 종전 CSR-YYYYMM-nnn 폐지).';

-- 확인 — CSR- 잔존 0 · next_no 71
SELECT count(*) AS csr_prefix_left FROM public.csr_issues WHERE issue_no LIKE 'CSR-%';
SELECT issue_no, related_issues FROM public.csr_issues WHERE issue_no IN ('27', '69', '70') ORDER BY issue_no;
SELECT public.csr_next_issue_no() AS next_no;
