-- 45번 담당자 「Lestari · Firman」 → 'Firman' (2026-09-11 확정). 022 적용 후 실행. 재실행 안전.
SELECT set_config('csr.actor', 'migration:023 (45번 담당자 Firman)', false);
UPDATE public.csr_issues SET it_pic = 'Firman' WHERE issue_no = '45' AND NOT is_archived AND it_pic = 'Lestari · Firman';
-- 확인 — 0행이어야 합니다(등록 사용자와 다른 담당자 없음).
SELECT i.issue_no, i.it_pic FROM public.csr_issues i
 WHERE NOT i.is_archived AND i.it_pic IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM public.csr_user_roles u WHERE u.display_name = i.it_pic);
