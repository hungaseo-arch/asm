-- =============================================================================
-- [CSR-1.1-E] 신규 CSR 등록 — CSR-202609-001 (Inventory List 카테고리 필터 중복 노출)
--   015 ~ 018 적용 후 실행. 달러 인용 없음. 재실행 안전(이미 있으면 건너뜀).
--
--   채번: csr_next_issue_no() 가 'CSR-202609-001' 을 돌려줄 때만 등록합니다(v1.0 규칙 — 1회 1건).
--   검증 이력 1행을 함께 넣으며, 017 트리거가 헤더(현업검증 PENDING · 최종검증일 2026-09-10)를 맞춥니다.
--   화면경로는 008 규칙(영문 메뉴명)에 맞춰 'Filter dropdown' 으로 적었습니다(지시서: 필터 드롭다운).
--   한국어 번역(개선 의견 · 수용기준 · 검증 내용)은 Claude 번역 — 검수 서종환.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:019 (CSR-202609-001 등록)', false);

INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, role_split,
  it_status, it_decision, verification_result,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  'CSR-202609-001',
  'Inventory List — 카테고리 필터(Category 2·3·4) 선택지 중복 노출',
  'Inventory List — Opsi Filter Kategori (Category 2·3·4) Tampil Ganda',
  'Inventory', 'Inventory List', 'Inventory > Inventory List > Filter dropdown',
  '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-09-10',
  'Category 2 드롭다운에 Truck/Bus(TB) 3회, Category 3에 Radial/Bias 반복, Category 4에 TT/TL 반복 노출 — 카테고리 테이블을 DISTINCT 없이 조회한 것으로 추정',
  'Opsi Category 2 menampilkan Truck/Bus(TB) 3 kali, Category 3 Radial/Bias berulang, Category 4 TT/TL berulang — diduga opsi diambil dari tabel kategori tanpa DISTINCT',
  'Category 1–4 각 드롭다운에 선택지가 한 번씩만 표시되고, 필터 결과가 선택한 옵션과 일치',
  'Setiap dropdown Category 1–4 menampilkan setiap opsi hanya satu kali, dan hasil filter sesuai dengan opsi yang dipilih',
  '개발부서 / Tim Pengembang',
  'Open', '미회신 / Belum Ada Balasan', 'PENDING',
  'Opsi filter diambil dengan DISTINCT per level kategori; opsi Category 2–4 difilter bertingkat sesuai pilihan level di atasnya (cascading)',
  '필터 선택지는 카테고리 레벨별로 DISTINCT 로 조회하고, Category 2–4 의 선택지는 상위 레벨 선택값에 따라 단계적으로(cascading) 걸러 냄',
  'Opsi filter diambil dengan DISTINCT per level kategori; opsi Category 2–4 difilter bertingkat sesuai pilihan level di atasnya (cascading)',
  false, 'migration:019'
WHERE public.csr_next_issue_no() = 'CSR-202609-001'
  AND NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = 'CSR-202609-001');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-10', 'PENDING',
       'Temuan awal saat verifikasi CSR 30 (filter Warehouse), belum diuji hasil filter per opsi ganda',
       'CSR 30 검증(Warehouse 필터) 중 최초 발견, 중복 옵션별 필터 결과는 미검증',
       'Temuan awal saat verifikasi CSR 30 (filter Warehouse), belum diuji hasil filter per opsi ganda',
       'migration:019'
  FROM public.csr_issues i
 WHERE i.issue_no = 'CSR-202609-001'
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- 확인 — 1행 · verification_result PENDING · verified_on 2026-09-10 · 이력 1건
SELECT issue_no, title_ko, it_status, it_decision, verification_result, verified_on,
       (SELECT count(*) FROM public.csr_verifications v WHERE v.issue_id = i.id) AS verif_rows
  FROM public.csr_issues i WHERE issue_no = 'CSR-202609-001';
SELECT public.csr_next_issue_no() AS next_no;
