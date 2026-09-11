-- =============================================================================
-- 담당자 이름 정리 (2026-09-11) — 담당자 값은 Neon 등록 사용자(csr_user_roles.display_name)와 같아야 합니다.
--   021 적용 후 실행. 달러 인용 없음. 재실행 안전.
--
--   1. 서종환 계정의 표시 이름을 'SEO' 로 — 이슈 13건의 담당자 'SEO' 가 본인이므로 이름 쪽을 맞춥니다.
--   2. Tari 계정의 표시 이름을 'Lestari' 로, 이슈 담당자 'Tari' 도 'Lestari' 로 — 같은 사람.
--   남는 미등록 담당자: Firman(14 · 15 · 38 · 46 · 47 · 53) · 'Lestari · Firman'(45) — Firman 등록 여부는 별도 결정.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:022 (담당자 이름 정리)', false);

UPDATE public.csr_user_roles SET display_name = 'SEO'     WHERE email = 'jhseo@ptascendo.com';
UPDATE public.csr_user_roles SET display_name = 'Lestari' WHERE email = 'tari@ptascendo.com';
UPDATE public.csr_issues SET it_pic = 'Lestari' WHERE it_pic = 'Tari';

-- 확인 — 등록 이름과 다른 담당자만 남습니다(Firman 계열 7건이어야 함).
SELECT email, display_name FROM public.csr_user_roles WHERE email IN ('jhseo@ptascendo.com', 'tari@ptascendo.com');
SELECT i.issue_no, i.it_pic
  FROM public.csr_issues i
 WHERE NOT i.is_archived AND i.it_pic IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM public.csr_user_roles u WHERE u.display_name = i.it_pic)
 ORDER BY i.issue_no;
