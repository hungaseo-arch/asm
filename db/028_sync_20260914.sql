-- =============================================================================
-- 3원 정합성 검증 후속 (2026-09-14) — 027 적용 후 실행. 달러 인용 없음. 재실행 안전.
--   보고서: docs/csr/정합성검증_3원_20260914.md
--
--   ① 02 현업검증 되돌리기 — 2026-09-11 사이트 편집으로 「조치확인 / 09-11」이 되었으나 IT상태 Open ·
--      수용여부 결정요청이라 앞뒤가 맞지 않음(오입력). 노션 값 「미조치 / 2026-09-08」로 복구합니다.
--      그날 들어온 검증 이력 1행(ACCEPTED)도 함께 지웁니다 — 헤더만 되돌리면 이력과 어긋납니다.
--      ※ 이력 삭제는 admin 권한(002 RLS)이라 앱에서 못 하고 콘솔에서만 됩니다.
--   ② 61~68 최종검증일 공란 — 024 의 「최초 접수」 이력이 017 트리거로 헤더 날짜를 채운 부작용.
--      현업검증이 미검증(PENDING)인데 최종검증일이 있으면 오해를 부르고, 노션도 공란입니다.
--      (2026-09-14 Data API 로 이미 적용 — 아래는 기록 · 재실행 안전용)
--   ③ 노션이 앞선 값 4건을 사이트에 반영 (2026-09-14 Data API 로 이미 적용)
--   ④ 13 H-3 테스트 이력(note 'test') 삭제 — 실제 검증이 아니라 시나리오 확인용이었음. 헤더는 09-10 으로 복구.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:028 (3원 정합성 후속)', false);

-- ① 02 — 오입력 이력 삭제 후 헤더 복구 (순서 중요: 이력 삭제 → 헤더)
DELETE FROM public.csr_verifications
 WHERE issue_id = (SELECT id FROM public.csr_issues WHERE issue_no = '02' AND NOT is_archived)
   AND verified_on = DATE '2026-09-11'
   AND result = 'ACCEPTED';

UPDATE public.csr_issues
   SET verification_result = 'NOT APPLIED', verified_on = DATE '2026-09-08'
 WHERE issue_no = '02' AND NOT is_archived;

-- ② 61~68 최종검증일 공란
UPDATE public.csr_issues SET verified_on = NULL
 WHERE issue_no IN ('61', '62', '63', '64', '65', '66', '67', '68') AND NOT is_archived;

-- ①-2 13 — H-3 검증 시나리오의 테스트 이력(note = 'test') 삭제 후 헤더를 직전 이력(2026-09-10 REJECTED)으로 복구
DELETE FROM public.csr_verifications
 WHERE issue_id = (SELECT id FROM public.csr_issues WHERE issue_no = '13' AND NOT is_archived)
   AND verified_on = DATE '2026-09-11' AND note = 'test';

UPDATE public.csr_issues
   SET verification_result = 'REJECTED', verified_on = DATE '2026-09-10'
 WHERE issue_no = '13' AND NOT is_archived;

-- ③ 노션 값 반영
UPDATE public.csr_issues SET menu_sub = '여신 / Kredit'        WHERE issue_no = '62' AND NOT is_archived;
UPDATE public.csr_issues SET menu_sub = '메뉴 명칭 / Nama Menu' WHERE issue_no = '63' AND NOT is_archived;
UPDATE public.csr_issues SET related_issues = '12 · 13 · 22 · 50 · 62' WHERE issue_no = '64' AND NOT is_archived;
UPDATE public.csr_issues SET related_issues = '62 · 64 · 66'           WHERE issue_no = '65' AND NOT is_archived;

-- 확인 — 02 미조치/09-08 · 이력에 09-11 ACCEPTED 없음 · 61~68 최종검증일 공란
SELECT issue_no, verification_result, verified_on, menu_sub, related_issues
  FROM public.csr_issues WHERE issue_no IN ('02', '62', '63', '64', '65') AND NOT is_archived ORDER BY issue_no;
SELECT v.id, v.verified_on, v.result FROM public.csr_verifications v
  JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE i.issue_no = '02' ORDER BY v.verified_on DESC;
SELECT count(*) AS verified_on_left FROM public.csr_issues
 WHERE issue_no IN ('61','62','63','64','65','66','67','68') AND verified_on IS NOT NULL;
SELECT issue_no, verification_result, verified_on FROM public.csr_issues WHERE issue_no = '13' AND NOT is_archived;
