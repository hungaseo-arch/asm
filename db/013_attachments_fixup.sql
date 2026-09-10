-- =============================================================================
-- ASM CSR — 첨부 시드 보정 (2026-09-10)
--   012 의 2차 실행이 부분 적용됐습니다(Data API 실측): 04·05 는 들어갔으나 26·36·37·38 은 빠졌고,
--   이슈 16 이 같은 drive_file_id 로 두 번 들어갔습니다. 이 파일 하나로 둘 다 바로잡습니다. 재실행 안전.
-- =============================================================================

-- 1) 같은 drive_file_id 중복 — 먼저 들어간 행(작은 id)만 남깁니다.
DELETE FROM public.csr_attachments a
 USING public.csr_attachments b
 WHERE a.drive_file_id = b.drive_file_id AND a.id > b.id;

-- 2) 빠진 4건
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1TY58eOY-IwpsfUCsQqws6I9Z3daswq1d', '26_정적_자원_404_및_도메인_혼재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '26' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1TY58eOY-IwpsfUCsQqws6I9Z3daswq1d');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1eSYvmBzvOl4eg23hiMwpDr3U0-f05hsv', '36_발주_신규_LOCAL_공급사_목록에_PT_Techk.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '36' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1eSYvmBzvOl4eg23hiMwpDr3U0-f05hsv');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1gpuEOz36MNucL7T-MOGl7Xnlw8bhIJYD', '37_발주_신규_LOCAL_결제조건_Payment_Ter.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '37' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1gpuEOz36MNucL7T-MOGl7Xnlw8bhIJYD');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1iQ7Tr8Juxp1WjvDr1CGPJYQ_--Ebgy1O', '38_입고_신규_IMPORT_LOCAL_AQL_Defec.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '38' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1iQ7Tr8Juxp1WjvDr1CGPJYQ_--Ebgy1O');

-- 3) 확인 — 38행 · 중복 0 · 이슈 01~38 각 1건
SELECT count(*) AS rows_total,
       count(*) - count(DISTINCT drive_file_id) AS dup_file_ids,
       count(DISTINCT issue_id) AS issues_with_capture
  FROM public.csr_attachments;
SELECT i.issue_no FROM public.csr_issues i
 WHERE NOT i.is_archived AND i.issue_no <= '38'
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.issue_id = i.id)
 ORDER BY 1;  -- 0행이어야 합니다
