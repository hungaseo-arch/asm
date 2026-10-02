-- =============================================================================
-- CSR 목록 업데이트 (2026-10-02) — 037 적용 후 실행. 달러 인용 없음. 재실행 안전.
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--
--   입력
--     · IT부서 조치현황 엑셀 「ASM CSR 개선요청 조치현황-260926.xlsx」 (직전 260920본 대비 비교)
--     · 실서버(asm.ascendotyre.com) 화면 검증 2026-10-02 10:30 WIB, 계정 Jo (서종환 수행)
--
--   1. IT상태(it_status) — 엑셀 진행현황으로 동기화. Verified 건(04·05·26·30·36·37·38)은 건드리지 않음
--      엑셀 N/A 행(메뉴 단위 표기)은 이슈가 아니므로 제외. 57·58·62~70은 엑셀에 없어 현행 유지
--   2. IT 회신(csr_it_replies) — 회신일 2026-09-26, 개선 내역·추가설명·의사결정사항이 있는 건만 1행씩
--      한국어는 엑셀 원문(줄바꿈은 ' / '), 인니어는 Claude 번역 — 검수 서종환
--   3. 신규 이슈 71~74 — 엑셀 「담당자 요청 분」 3건 + 「기타」 1건 (IT부서 Completed 상태로 접수)
--   4. 검증 이력(csr_verifications) 2026-10-02 — 실서버 확인 결과. 017 트리거가 헤더(현업검증·최종검증일) 동기화
--      Completed 부적정(REJECTED) : 03 · 07 · 13 · 15 · 22 · 50 / 부분조치 : 18 · 74 / 미조치 : 16 · 21 · 52 · 69
--      조치확인 : 02 · 09 · 29 · 71 · 72 · 73
-- =============================================================================

SELECT set_config('csr.actor', 'migration:038 (IT 조치현황 0926 · 실서버 검증 1002)', false);

-- ── 1. IT상태 동기화 ─────────────────────────────────────────────────────────
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '01' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '02' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '03' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '04' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '05' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '27' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '36' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '37' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '06' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '38' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '07' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '08' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '09' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '10' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '11' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '12' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '28' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '33' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '34' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '13' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '30' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '35' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '29' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '32' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '31' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '14' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '15' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '16' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '17' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '18' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '19' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '20' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '21' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '22' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '23' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '24' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '25' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '26' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '39' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '40' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '41' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '42' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '43' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '44' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '45' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '46' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '47' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '48' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '49' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '50' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '51' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '52' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '53' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '54' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '55' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Ongoing' WHERE issue_no = '56' AND NOT is_archived AND it_status NOT IN ('Verified', 'Ongoing');
UPDATE public.csr_issues SET it_status = 'Open' WHERE issue_no = '59' AND NOT is_archived AND it_status NOT IN ('Verified', 'Open');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '60' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');
UPDATE public.csr_issues SET it_status = 'Completed' WHERE issue_no = '61' AND NOT is_archived AND it_status NOT IN ('Verified', 'Completed');

-- ── 2. 신규 이슈 71~74 (IT부서 조치현황 「담당자 요청 분」 · 「기타」) ─────────────────────
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id, is_archived, updated_by
)
SELECT '71', '71. 목록 화면 — 상세 조회 후 뒤로가기 시 보던 페이지 유지', '71. Layar Daftar — Halaman yang Sedang Dilihat Tetap Dipertahankan Saat Kembali dari Detail',
  '공통 / Umum', '목록·입력 사용성 / Usabilitas Daftar & Input', '공통 > 목록 화면', '개선 / Perbaikan', 'S3 Minor',
  '미정 / Belum Ditentukan', '현지 사용자 / Pengguna Lokal', DATE '2026-09-26', '목록 2페이지 이후에서 상세 조회 후 Back 버튼 클릭 시 1페이지로 돌아가 다시 찾아 들어가야 함', 'Setelah membuka detail dari halaman ke-2 dst., tombol Back kembali ke halaman 1 sehingga data harus dicari ulang',
  '목록 n페이지 → 상세 → Back 시 n페이지 그대로 표시', 'Daftar halaman n → detail → Back tetap menampilkan halaman n', NULL, '개발부서 / Tim Pengembang',
  'Completed', 'SEO', '수용 / Diterima', 'PENDING',
  '현지 담당자 요청 — 페이지별 상세 조회(Pagination) 후 Back button 클릭 시 Click한 페이지 유지 요청. IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', '현지 담당자 요청 — 페이지별 상세 조회(Pagination) 후 Back button 클릭 시 Click한 페이지 유지 요청. IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', 'Permintaan PIC lokal — setelah membuka detail per halaman (Pagination), saat tombol Back diklik halaman yang diklik tetap dipertahankan. Tercatat 「Diterapkan · Completed」 pada laporan IT 2026-09-26', false, 'it-excel-260926'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '71' OR title_ko = '71. 목록 화면 — 상세 조회 후 뒤로가기 시 보던 페이지 유지'));
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id, is_archived, updated_by
)
SELECT '72', '72. Import Cost — 구매비용(CIF)에 Discount 항목 별도 표기', '72. Import Cost — Item Discount Ditampilkan Terpisah pada Biaya Pembelian (CIF)',
  'Purchasing', 'IMPORT COST', 'Purchasing > Import Cost', '개선 / Perbaikan', 'S3 Minor',
  '미정 / Belum Ditentukan', '현지 사용자 / Pengguna Lokal', DATE '2026-09-26', '구매비용(CIF = FOB + Freight & Insurance) 구성에 할인액이 드러나지 않아 원가 검토 시 확인 불가', 'Nilai diskon tidak terlihat pada komponen biaya pembelian (CIF = FOB + Freight & Insurance) sehingga tidak dapat dicek saat peninjauan biaya',
  'Import Cost 상세 ESTIMATED · ACTUAL 양쪽에 Discount 행이 FOB · Freight와 별도로 표시되고 CIF Total에 반영', 'Baris Discount tampil terpisah dari FOB · Freight pada ESTIMATED dan ACTUAL di detail Import Cost dan tercermin pada CIF Total', '07 · 41', '개발부서 / Tim Pengembang',
  'Completed', 'Lestari', '수용 / Diterima', 'PENDING',
  '현지 담당자 요청 — 구매비용(CIR, FOB+Freight&Insurance)에 discount 항목 별도 표기 추가. 관련 이슈 41(Discount 입력 위치 Shipment) · 07(수입원가 구성). IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', '현지 담당자 요청 — 구매비용(CIR, FOB+Freight&Insurance)에 discount 항목 별도 표기 추가. 관련 이슈 41(Discount 입력 위치 Shipment) · 07(수입원가 구성). IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', 'Permintaan PIC lokal — tambahkan item discount terpisah pada biaya pembelian (CIF, FOB+Freight&Insurance). Isu terkait 41 (input Discount di Shipment) · 07 (komposisi biaya impor). Tercatat 「Diterapkan · Completed」 pada laporan IT 2026-09-26', false, 'it-excel-260926'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '72' OR title_ko = '72. Import Cost — 구매비용(CIF)에 Discount 항목 별도 표기'));
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id, is_archived, updated_by
)
SELECT '73', '73. Delivery Order · Delivery Note 목록 — 검색어에 창고(Warehouse) 추가', '73. Daftar Delivery Order · Delivery Note — Gudang (Warehouse) Ditambahkan ke Kata Kunci Pencarian',
  'Sales', 'DELIVERY ORDER', 'Sales > Delivery Order · Delivery Note', '개선 / Perbaikan', 'S3 Minor',
  '미정 / Belum Ditentukan', '현지 사용자 / Pengguna Lokal', DATE '2026-09-26', 'DO · DN 목록 키워드 검색으로 창고별 조회 불가 — 지점(Karawang · Surabaya · Semarang) 담당자가 자기 창고 전표만 골라 보기 어려움', 'Pencarian kata kunci daftar DO · DN tidak dapat memfilter per gudang — PIC cabang (Karawang · Surabaya · Semarang) sulit melihat dokumen gudangnya saja',
  'DO · DN 목록 키워드에 창고명 입력 시 해당 창고 전표만 조회', 'Memasukkan nama gudang pada kata kunci daftar DO · DN hanya menampilkan dokumen gudang tersebut', NULL, '개발부서 / Tim Pengembang',
  'Completed', 'Merry', '수용 / Diterima', 'PENDING',
  '현지 담당자 요청 — Delivery Order / Delivery Note 목록의 search keyword에 ''창고'' 추가. IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', '현지 담당자 요청 — Delivery Order / Delivery Note 목록의 search keyword에 ''창고'' 추가. IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', 'Permintaan PIC lokal — tambahkan ''gudang'' pada kata kunci pencarian daftar Delivery Order / Delivery Note. Tercatat 「Diterapkan · Completed」 pada laporan IT 2026-09-26', false, 'it-excel-260926'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '73' OR title_ko = '73. Delivery Order · Delivery Note 목록 — 검색어에 창고(Warehouse) 추가'));
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id, is_archived, updated_by
)
SELECT '74', '74. 전 화면 — 글꼴(당사 표준 Noto Sans) 및 글자 크기 일괄 적용', '74. Semua Layar — Font (Standar Perusahaan Noto Sans) dan Ukuran Huruf Diseragamkan',
  '공통 / Umum', '표기·레이아웃 / Tampilan & Layout', '공통 > 전 화면', '개선 / Perbaikan', 'S3 Minor',
  '미정 / Belum Ditentukan', '현지 사용자 / Pengguna Lokal', DATE '2026-09-26', '화면별 글꼴 · 글자 크기가 달라 가독성과 통일감 저하', 'Font · ukuran huruf berbeda per layar sehingga keterbacaan dan keseragaman menurun',
  '전 화면 글꼴 Noto Sans, 본문 · 표 · 라벨 글자 크기를 정해진 단계로 통일', 'Seluruh layar memakai font Noto Sans, ukuran huruf isi · tabel · label diseragamkan sesuai tingkat yang ditetapkan', '23', '개발부서 / Tim Pengembang',
  'Completed', 'SEO', '수용 / Diterima', 'PENDING',
  '기타 개선 — Font 글자체(당사 표준 : Noto Sans) 및 font-size 일괄 적용. 관련 이슈 23(반응형 레이아웃). IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', '기타 개선 — Font 글자체(당사 표준 : Noto Sans) 및 font-size 일괄 적용. 관련 이슈 23(반응형 레이아웃). IT부서 2026-09-26 조치현황에 「반영 · Completed」로 등재', 'Perbaikan lain — font (standar perusahaan : Noto Sans) dan font-size diterapkan serentak. Isu terkait 23 (layout responsif). Tercatat 「Diterapkan · Completed」 pada laporan IT 2026-09-26', false, 'it-excel-260926'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '74' OR title_ko = '74. 전 화면 — 글꼴(당사 표준 Noto Sans) 및 글자 크기 일괄 적용'));

-- ── 3. IT 회신 2026-09-26 (엑셀 개선 내역 · 추가설명 · 의사결정사항) ─────────────────────
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'footer에 toggle 버튼 적용', 'footer에 toggle 버튼 적용', 'Tombol toggle diterapkan pada footer', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '01' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '업체로 통화 구분 가능 : 초기 담당자 의견 반영', '업체로 통화 구분 가능 : 초기 담당자 의견 반영', 'Mata uang dapat dibedakan per pemasok : sesuai masukan PIC awal', '필요?', '필요?', 'Apakah diperlukan?', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '02' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, '합계(Amount)에 대한 표시 기준 필요 / -구매 & 판매 공통 / -세전/세후 금액?', '합계(Amount)에 대한 표시 기준 필요 / -구매 & 판매 공통 / -세전/세후 금액?', 'Perlu standar tampilan total (Amount) / - berlaku umum untuk pembelian & penjualan / - sebelum atau sesudah pajak?', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '03' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'PO번호 자동부여 / (AJ-20260903-001, 업체 일자별 순번)', 'PO번호 자동부여 / (AJ-20260903-001, 업체 일자별 순번)', 'Nomor PO diberikan otomatis / (AJ-20260903-001, urutan per pemasok per tanggal)', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '04' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '05' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '27' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', 'Supplier 등록 가능(Partners -> Suppliers)', 'Supplier 등록 가능(Partners -> Suppliers)', 'Supplier dapat didaftarkan (Partners -> Suppliers)', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '36' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', 'Basic data 코드 추가', 'Basic data 코드 추가', 'Kode ditambahkan pada Basic Data', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '37' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '1.Receipt Date > Actual Arrival Date 조건 추가 완료 / 2.미래의 입고일자 불가 처리 진행 중', '1.Receipt Date > Actual Arrival Date 조건 추가 완료 / 2.미래의 입고일자 불가 처리 진행 중', '1. Kondisi Receipt Date > Actual Arrival Date sudah ditambahkan / 2. Larangan tanggal penerimaan di masa depan sedang dikerjakan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '06' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'N/A', 'N/A', 'N/A', '(Case 발생 상황) / 구매담당(Alya)이 Import Cost를 입력하고자 먼저 / 1.입고확정 처리하여 (기존 방식 biz flow) / 2.창고담당자가 수량(AQL,Defect qty)을 입력 못함 / (ASM 기능 현황) / 1.ASM에서는 입고 확정 후 Import Cost 입력 허용 / (해결방안 : 구매담당자에게 Biz Flow 설명 함) / 1.R&R 명확화 / -입고확정은 창고 담당자가 항상 처리(현장 정확한 수량) / -구매 담당자는 입고 확정 후 Import Cost 입력 / (필요 시 구매담당자 -> 창고 담당자 독려,Monitoring) / -긴급 경우, 기존 입력 입고 내역을 ''취소''처리 가능', '(Case 발생 상황) / 구매담당(Alya)이 Import Cost를 입력하고자 먼저 / 1.입고확정 처리하여 (기존 방식 biz flow) / 2.창고담당자가 수량(AQL,Defect qty)을 입력 못함 / (ASM 기능 현황) / 1.ASM에서는 입고 확정 후 Import Cost 입력 허용 / (해결방안 : 구매담당자에게 Biz Flow 설명 함) / 1.R&R 명확화 / -입고확정은 창고 담당자가 항상 처리(현장 정확한 수량) / -구매 담당자는 입고 확정 후 Import Cost 입력 / (필요 시 구매담당자 -> 창고 담당자 독려,Monitoring) / -긴급 경우, 기존 입력 입고 내역을 ''취소''처리 가능', '(Kasus yang terjadi) / PIC pembelian (Alya) lebih dulu / 1. mengonfirmasi penerimaan agar dapat menginput Import Cost (alur bisnis lama) / 2. PIC gudang tidak dapat menginput jumlah (AQL, Defect qty) / (Fungsi ASM saat ini) / 1. ASM mengizinkan input Import Cost setelah penerimaan dikonfirmasi / (Solusi : alur bisnis sudah dijelaskan kepada PIC pembelian) / 1. Memperjelas R&R / - Konfirmasi penerimaan selalu dilakukan PIC gudang (jumlah aktual di lapangan) / - PIC pembelian menginput Import Cost setelah penerimaan dikonfirmasi / (bila perlu PIC pembelian -> mendorong dan memantau PIC gudang) / - Dalam keadaan darurat, penerimaan yang sudah diinput dapat dibatalkan (Cancel)', 'Flow 확인 필요', 'Flow 확인 필요', 'Perlu konfirmasi alur (flow)', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '38' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '화면 하단 Total Import Cost에서 PPN,PPH 금액 제외 표시', '화면 하단 Total Import Cost에서 PPN,PPH 금액 제외 표시', 'Total Import Cost di bagian bawah layar ditampilkan tanpa PPN, PPh', 'PPN,PPH : 원가 반영 요소', 'PPN,PPH : 원가 반영 요소', 'PPN, PPh : unsur yang dibebankan ke biaya', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '07' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'N/A', 'N/A', 'N/A', '선적부대비는 품목별로 배분되어 Landed_unit_cost로 관리 됨 / (PLB HANDLING, PLB REIMBURSEMENT, INLAND_TRANSPORT, LS, MISC)', '선적부대비는 품목별로 배분되어 Landed_unit_cost로 관리 됨 / (PLB HANDLING, PLB REIMBURSEMENT, INLAND_TRANSPORT, LS, MISC)', 'Biaya tambahan pengapalan dialokasikan per item dan dikelola sebagai Landed_unit_cost / (PLB HANDLING, PLB REIMBURSEMENT, INLAND_TRANSPORT, LS, MISC)', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '08' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, '현재 자동 계산 중', '현재 자동 계산 중', 'Saat ini dihitung otomatis', '수기로 세금액 조정 필요?', '수기로 세금액 조정 필요?', 'Apakah perlu penyesuaian nilai pajak secara manual?', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '09' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '1.고객사별 영업대표 Basic Data 필요 / 2.Partners -> Customers에 해당 정보 등록 기능 추가 예정', '1.고객사별 영업대표 Basic Data 필요 / 2.Partners -> Customers에 해당 정보 등록 기능 추가 예정', '1. Perlu Basic Data sales representative per pelanggan / 2. Fitur pendaftaran informasi tersebut di Partners -> Customers akan ditambahkan', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '11' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '절사된 금액은 화면에서만 보여짐 / -실제 (계산)금액은 절사 안함', '절사된 금액은 화면에서만 보여짐 / -실제 (계산)금액은 절사 안함', 'Nilai pembulatan hanya ditampilkan di layar / - nilai (perhitungan) aktual tidak dibulatkan', '절사 금액 화면 노출 필요?', '절사 금액 화면 노출 필요?', 'Apakah nilai pembulatan perlu ditampilkan di layar?', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '12' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '28' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, NULL, NULL, NULL, 'Flow 정의 필요', 'Flow 정의 필요', 'Perlu definisi alur (flow)', 'IT 진행현황 : Open', 'IT 진행현황 : Open', 'Status IT : Open', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '34' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', 'SO화면에서 소수점(2자리) 표기 예정', 'SO화면에서 소수점(2자리) 표기 예정', 'Layar SO akan menampilkan 2 angka desimal', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '13' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', 'Claim창고 등록으로 처리함', 'Claim창고 등록으로 처리함', 'Ditangani dengan mendaftarkan gudang Claim', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '30' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '(ASM 기능 현황) / 1.SO는 Draft 상태와 Confirm 상태로 구분 / 1)Draft : 가용 재고와 무관하게 SO생성 가능 / 2)Confirm : SO수량을 재고에서 LOCK(잠금) / 2.SO Confirm 후 DO(출고지시) -> DN(출하) 가능 / (ASM 기능 보완 예정) / 1.SO 수량 대비 실제 DN(출하) 수량 간 발생한 차이 / (미래 어느시점에 확정)에 대하여 해당 수량 원복 / (Release, 타고객 판매 가능) 기능 추가', '(ASM 기능 현황) / 1.SO는 Draft 상태와 Confirm 상태로 구분 / 1)Draft : 가용 재고와 무관하게 SO생성 가능 / 2)Confirm : SO수량을 재고에서 LOCK(잠금) / 2.SO Confirm 후 DO(출고지시) -> DN(출하) 가능 / (ASM 기능 보완 예정) / 1.SO 수량 대비 실제 DN(출하) 수량 간 발생한 차이 / (미래 어느시점에 확정)에 대하여 해당 수량 원복 / (Release, 타고객 판매 가능) 기능 추가', '(Fungsi ASM saat ini) / 1. SO dibedakan menjadi status Draft dan Confirm / 1) Draft : SO dapat dibuat tanpa memperhatikan stok tersedia / 2) Confirm : jumlah SO dikunci (LOCK) dari stok / 2. Setelah SO Confirm, DO (instruksi keluar) -> DN (pengiriman) dapat dibuat / (Fungsi ASM yang akan dilengkapi) / 1. Untuk selisih antara jumlah SO dan jumlah DN (pengiriman) aktual / (dikonfirmasi pada suatu saat), jumlah tersebut dikembalikan / (Release, dapat dijual ke pelanggan lain)', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '35' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '29' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '32' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '위 Purchase -> Receipt-> 2에서 정의 함', '위 Purchase -> Receipt-> 2에서 정의 함', 'Sudah didefinisikan pada Purchase -> Receipt -> 2 di atas', NULL, NULL, NULL, 'Flow 확인 필요', 'Flow 확인 필요', 'Perlu konfirmasi alur (flow)', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '31' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '1.2026.08월 마감 미 진행(재무 마감 미실행 사유) / 2.재고실사(2026.08월)로 이관 된 Data를 그대로 마감 예정', '1.2026.08월 마감 미 진행(재무 마감 미실행 사유) / 2.재고실사(2026.08월)로 이관 된 Data를 그대로 마감 예정', '1. Penutupan Agustus 2026 belum dilakukan (karena penutupan keuangan belum dijalankan) / 2. Data hasil migrasi stock opname (Agustus 2026) akan ditutup apa adanya', NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '14' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '현재 상태 유지', '현재 상태 유지', 'Kondisi saat ini dipertahankan', '사용자 Browser 언어 설정에 종속', '사용자 Browser 언어 설정에 종속', 'Bergantung pada pengaturan bahasa browser pengguna', '필요?', '필요?', 'Apakah diperlukan?', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '15' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, '1.결재 조건(Payment Term)은 상세 Table에서 관리 중 / 2.여신한도, 여신등급 등 항목 추가 관리 예정', '1.결재 조건(Payment Term)은 상세 Table에서 관리 중 / 2.여신한도, 여신등급 등 항목 추가 관리 예정', '1. Syarat pembayaran (Payment Term) dikelola pada tabel detail / 2. Item batas kredit, peringkat kredit, dll. akan ditambahkan', '여신 관련 항목 정의 필요', '여신 관련 항목 정의 필요', 'Perlu definisi item terkait kredit', 'IT 진행현황 : Open', 'IT 진행현황 : Open', 'Status IT : Open', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '16' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, '1.SAP 기준 Data를 이관 함 / 2.Raw Data에 대한 현업 보정/Cleansing 필요 / (우선, 주요 Customer 진행)', '1.SAP 기준 Data를 이관 함 / 2.Raw Data에 대한 현업 보정/Cleansing 필요 / (우선, 주요 Customer 진행)', '1. Data dimigrasikan berdasarkan SAP / 2. Raw data perlu dikoreksi/dibersihkan oleh tim bisnis / (diprioritaskan untuk pelanggan utama)', 'Data 보정 필요', 'Data 보정 필요', 'Perlu koreksi data', 'IT 진행현황 : Ongoing', 'IT 진행현황 : Ongoing', 'Status IT : Ongoing', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '17' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '향후 개선', '향후 개선', 'Akan diperbaiki kemudian', '국가(INDONESIA, CHINA) Code화 예정', '국가(INDONESIA, CHINA) Code화 예정', 'Negara (INDONESIA, CHINA) akan dijadikan kode', 'Data 보정 필요', 'Data 보정 필요', 'Perlu koreksi data', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '18' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'N/A', 'N/A', 'N/A', '1.14.00-24-28PR?55MM 제품은 실제 미존재 / 2.Raw Data에 대한 현업 보정/Cleansing 필요', '1.14.00-24-28PR?55MM 제품은 실제 미존재 / 2.Raw Data에 대한 현업 보정/Cleansing 필요', '1. Produk 14.00-24-28PR?55MM sebenarnya tidak ada / 2. Raw data perlu dikoreksi/dibersihkan oleh tim bisnis', 'Data 보정 필요', 'Data 보정 필요', 'Perlu koreksi data', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '19' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '현재, OFFLINE & VIRTUAL 2개로 구분 중', '현재, OFFLINE & VIRTUAL 2개로 구분 중', 'Saat ini dibedakan menjadi 2 : OFFLINE & VIRTUAL', '추가 구분 필요?', '추가 구분 필요?', 'Apakah perlu klasifikasi tambahan?', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '20' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, '1.인사팀 Raw Data 기준 / 2.부서코드 적용됨', '1.인사팀 Raw Data 기준 / 2.부서코드 적용됨', '1. Berdasarkan raw data HRD / 2. Kode departemen sudah diterapkan', NULL, NULL, NULL, 'IT 진행현황 : Ongoing', 'IT 진행현황 : Ongoing', 'Status IT : Ongoing', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '21' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', '(현행) 인도네시아 방식 적용 중 / (지적 사항) / 1.천 단위 구분은 콤마(,) / 2.소수점은 마침표(.)로 통일 / 3.IDR 총액은 정수', '(현행) 인도네시아 방식 적용 중 / (지적 사항) / 1.천 단위 구분은 콤마(,) / 2.소수점은 마침표(.)로 통일 / 3.IDR 총액은 정수', '(Saat ini) format Indonesia diterapkan / (Temuan) / 1. Pemisah ribuan koma (,) / 2. Desimal diseragamkan dengan titik (.) / 3. Total IDR bilangan bulat', '확인 필요', '확인 필요', 'Perlu konfirmasi', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '22' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, '반응형 불완전 적용 상태', '반응형 불완전 적용 상태', 'Responsif belum diterapkan sepenuhnya', NULL, NULL, NULL, 'IT 진행현황 : Ongoing', 'IT 진행현황 : Ongoing', 'Status IT : Ongoing', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '23' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, 'All page 공통사항', 'All page 공통사항', 'Berlaku umum untuk semua halaman', NULL, NULL, NULL, 'IT 진행현황 : Open', 'IT 진행현황 : Open', 'Status IT : Open', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '24' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', NULL, NULL, NULL, 'All page 공통사항', 'All page 공통사항', 'Berlaku umum untuk semua halaman', NULL, NULL, NULL, 'IT 진행현황 : Open', 'IT 진행현황 : Open', 'Status IT : Open', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '25' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '26' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'SAP에서 진행 중인 건 : 신규 ASM에 다시 입력으로 처리 가능 / (ASM의 Remark에 기존 전표 번호 입력으로 추적 가능)', 'SAP에서 진행 중인 건 : 신규 ASM에 다시 입력으로 처리 가능 / (ASM의 Remark에 기존 전표 번호 입력으로 추적 가능)', 'Transaksi yang sedang berjalan di SAP : dapat ditangani dengan input ulang di ASM / (dapat dilacak dengan mencantumkan nomor dokumen lama pada Remark ASM)', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '39' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '40' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', 'Import의 경우로 ''Shipment''에서 Discount 입력 하기로 함', 'Import의 경우로 ''Shipment''에서 Discount 입력 하기로 함', 'Untuk Import, Discount diinput pada ''Shipment''', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '41' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '42' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '44' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '해당 건 Cancel 후 Create 하기로 함', '해당 건 Cancel 후 Create 하기로 함', 'Dokumen terkait di-Cancel lalu dibuat ulang (Create)', NULL, NULL, NULL, '전반에 영향 많음 / ''-PO기반 입고 원칙 위배 / ''-필요 시 신규 PO생성->입고 처리 고려 필요', '전반에 영향 많음 / ''-PO기반 입고 원칙 위배 / ''-필요 시 신규 PO생성->입고 처리 고려 필요', 'Berdampak luas / - melanggar prinsip penerimaan berbasis PO / - bila perlu, pertimbangkan membuat PO baru -> proses penerimaan', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '45' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '담당에 현황 설명', '담당에 현황 설명', 'Kondisi saat ini sudah dijelaskan kepada PIC', NULL, NULL, NULL, 'PROCESS 정의 필요', 'PROCESS 정의 필요', 'Perlu definisi PROSES', 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '46' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '47' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '48' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '49' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '50' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영(담당자 소유 실재고 수량 정확성 확인 요청 함)', '반영(담당자 소유 실재고 수량 정확성 확인 요청 함)', 'Diterapkan (PIC diminta memastikan akurasi jumlah stok fisik)', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '51' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '60' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '61' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '71' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '72' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '73' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');
INSERT INTO public.csr_it_replies (issue_id, replied_on, fix_plan, fix_plan_ko, fix_plan_id, note, note_ko, note_id, needs_decision, needs_decision_ko, needs_decision_id, pic_and_target, pic_and_target_ko, pic_and_target_id, created_by)
SELECT i.id, DATE '2026-09-26', '반영', '반영', 'Diterapkan', NULL, NULL, NULL, NULL, NULL, NULL, 'IT 진행현황 : Completed', 'IT 진행현황 : Completed', 'Status IT : Completed', 'it-excel-260926'
  FROM public.csr_issues i
 WHERE i.issue_no = '74' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_it_replies x WHERE x.issue_id = i.id AND x.replied_on = DATE '2026-09-26' AND x.created_by = 'it-excel-260926');

-- ── 4. 검증 이력 2026-10-02 (실서버 화면 확인) ─────────────────────────────────────
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'PO 목록 AMOUNT 열에 통화 코드(USD · IDR) 표시 확인(HA-20260527-001 USD 18,683.00 / HT-20260921-020 IDR 507,430,950.00)', 'PO 목록 AMOUNT 열에 통화 코드(USD · IDR) 표시 확인(HA-20260527-001 USD 18,683.00 / HT-20260921-020 IDR 507,430,950.00)', 'Kode mata uang (USD · IDR) tampil pada kolom AMOUNT daftar PO (HA-20260527-001 USD 18,683.00 / HT-20260921-020 IDR 507,430,950.00)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '02' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'REJECTED', 'AJ-20261001-005 : PO 상세 40품목 · 1,285본 vs PPC 상세 37품목 · PO QTY 합계 1,104본(3품목 · 181본 미표시). PPC 상세 REM QTY 136본이나 실제 잔량 317본. PPC 목록 PO QTY는 1,285로 상세와 불일치. 금액 대사(세전 · 세후 기준) 기능 없음 — PO Grand Total 2,168,130,889 vs PPC Grand Total 1,655,314,749 차이 표시 없음', 'AJ-20261001-005 : PO 상세 40품목 · 1,285본 vs PPC 상세 37품목 · PO QTY 합계 1,104본(3품목 · 181본 미표시). PPC 상세 REM QTY 136본이나 실제 잔량 317본. PPC 목록 PO QTY는 1,285로 상세와 불일치. 금액 대사(세전 · 세후 기준) 기능 없음 — PO Grand Total 2,168,130,889 vs PPC Grand Total 1,655,314,749 차이 표시 없음', 'AJ-20261001-005 : detail PO 40 item · 1,285 pcs vs detail PPC 37 item · total PO QTY 1,104 pcs (3 item · 181 pcs tidak tampil). REM QTY di detail PPC 136 pcs, padahal sisa aktual 317 pcs. PO QTY di daftar PPC 1,285, tidak sama dengan detail. Belum ada rekonsiliasi nilai (dasar sebelum/sesudah pajak) — selisih PO Grand Total 2,168,130,889 vs PPC Grand Total 1,655,314,749 tidak ditampilkan', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '03' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'REJECTED', 'SHP-20260928-006 ESTIMATED : Total Import Cost IDR 108,111,075 = Tax Total 91,292,000 + Etc Total 16,819,075 — PPN 43,170,000 · PPh 29,434,000 포함 유지(IT 회신 「PPN · PPH 제외 표시」 미반영). 목록 COST AMOUNT 14,052,710(Etc만) vs 상세 ACTUAL Total 105,344,710(세금 포함) — 화면 간 집계 기준 상이', 'SHP-20260928-006 ESTIMATED : Total Import Cost IDR 108,111,075 = Tax Total 91,292,000 + Etc Total 16,819,075 — PPN 43,170,000 · PPh 29,434,000 포함 유지(IT 회신 「PPN · PPH 제외 표시」 미반영). 목록 COST AMOUNT 14,052,710(Etc만) vs 상세 ACTUAL Total 105,344,710(세금 포함) — 화면 간 집계 기준 상이', 'SHP-20260928-006 ESTIMATED : Total Import Cost IDR 108,111,075 = Tax Total 91,292,000 + Etc Total 16,819,075 — PPN 43,170,000 · PPh 29,434,000 masih termasuk (balasan IT 「ditampilkan tanpa PPN · PPh」 belum diterapkan). COST AMOUNT daftar 14,052,710 (hanya Etc) vs Total ACTUAL detail 105,344,710 (termasuk pajak) — dasar perhitungan antar layar berbeda', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '07' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'SHP-20260928-006 ACTUAL 탭에 Bea Masuk · PPN · PPh 실적 입력란 신설 확인(18,688,000 / 43,170,000 / 29,434,000 입력값 표시)', 'SHP-20260928-006 ACTUAL 탭에 Bea Masuk · PPN · PPh 실적 입력란 신설 확인(18,688,000 / 43,170,000 / 29,434,000 입력값 표시)', 'Kolom input aktual Bea Masuk · PPN · PPh pada tab ACTUAL SHP-20260928-006 sudah tersedia (nilai 18,688,000 / 43,170,000 / 29,434,000 tampil)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '09' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'REJECTED', 'DN 상세(id 589, SURABAYA, 2026-09-30) : 목록 AMOUNT IDR 1,460,000.76 vs 상세 Total (incl. PPN) 1,460,000 — 불일치 지속. DN 목록 금액에 소수 잔여(.13 · .88 · .16 등) 다수', 'DN 상세(id 589, SURABAYA, 2026-09-30) : 목록 AMOUNT IDR 1,460,000.76 vs 상세 Total (incl. PPN) 1,460,000 — 불일치 지속. DN 목록 금액에 소수 잔여(.13 · .88 · .16 등) 다수', 'Detail DN (id 589, SURABAYA, 2026-09-30) : AMOUNT daftar IDR 1,460,000.76 vs Total (incl. PPN) detail 1,460,000 — masih tidak sama. Banyak sisa desimal (.13 · .88 · .16 dll.) pada nilai daftar DN', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '13' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'REJECTED', 'IT 회신 「현재 상태 유지」로 Completed 처리 — 조치 없음. 재고 목록 날짜 입력란 「연도-월-일」(브라우저 언어 종속) 유지, Import Cost 상세 날짜 09/28/2026(MM/DD/YYYY)로 형식 혼재. 현업이 현상 유지를 수용하면 N/A 재분류 검토', 'IT 회신 「현재 상태 유지」로 Completed 처리 — 조치 없음. 재고 목록 날짜 입력란 「연도-월-일」(브라우저 언어 종속) 유지, Import Cost 상세 날짜 09/28/2026(MM/DD/YYYY)로 형식 혼재. 현업이 현상 유지를 수용하면 N/A 재분류 검토', 'Ditandai Completed dengan balasan IT 「kondisi saat ini dipertahankan」 — tidak ada perbaikan. Kolom tanggal daftar stok tetap 「연도-월-일」 (bergantung bahasa browser), tanggal detail Import Cost 09/28/2026 (MM/DD/YYYY) sehingga format bercampur. Bila tim bisnis menerima kondisi ini, pertimbangkan reklasifikasi ke N/A', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '15' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', '고객 상세(customer/517) 탭 = ADDRESS · CUSTOMER PIC · PAYMENT CURRENCY · DELIVERY LOCATION · ASCENDO SALES PERSON — 여신한도(CREDIT) 항목 없음', '고객 상세(customer/517) 탭 = ADDRESS · CUSTOMER PIC · PAYMENT CURRENCY · DELIVERY LOCATION · ASCENDO SALES PERSON — 여신한도(CREDIT) 항목 없음', 'Tab detail pelanggan (customer/517) = ADDRESS · CUSTOMER PIC · PAYMENT CURRENCY · DELIVERY LOCATION · ASCENDO SALES PERSON — item batas kredit (CREDIT) belum ada', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '16' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'PARTIAL', '공급사 18건 COUNTRY 값 INDONESIA · CHINA로 정비 확인. 공급사 등록 화면 COUNTRY는 여전히 자유입력란 — 코드화 미적용(IT 회신 「향후 개선」)', '공급사 18건 COUNTRY 값 INDONESIA · CHINA로 정비 확인. 공급사 등록 화면 COUNTRY는 여전히 자유입력란 — 코드화 미적용(IT 회신 「향후 개선」)', 'Nilai COUNTRY 18 pemasok sudah dirapikan menjadi INDONESIA · CHINA. Kolom COUNTRY pada layar registrasi pemasok masih input bebas — belum dijadikan kode (balasan IT 「akan diperbaiki kemudian」)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '18' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', 'Search Staff 1페이지 DEPARTMENT 값에 SEMARANG(지점명), GUDANG · WAREHOUSE 이중 표기 혼재 지속', 'Search Staff 1페이지 DEPARTMENT 값에 SEMARANG(지점명), GUDANG · WAREHOUSE 이중 표기 혼재 지속', 'Nilai DEPARTMENT halaman 1 Search Staff masih bercampur SEMARANG (nama cabang) serta GUDANG · WAREHOUSE (penulisan ganda)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '21' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'REJECTED', '목록은 영미식(콤마) 표기이나 상세는 인니식 유지 — PO 상세 AJ-20261001-005 Subtotal 1.953.271.071, DN 상세(id 589) Subtotal 1.315.316, DO-20260930-516 Total 1.734.000. 화면 간 표기 혼재', '목록은 영미식(콤마) 표기이나 상세는 인니식 유지 — PO 상세 AJ-20261001-005 Subtotal 1.953.271.071, DN 상세(id 589) Subtotal 1.315.316, DO-20260930-516 Total 1.734.000. 화면 간 표기 혼재', 'Daftar memakai format koma, tetapi detail tetap format Indonesia — Subtotal detail PO AJ-20261001-005 1.953.271.071, Subtotal detail DN (id 589) 1.315.316, Total DO-20260930-516 1.734.000. Format bercampur antar layar', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '22' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'DO-20260930-516 상세 · DN 상세(id 589) 품목 표에 REMARK 열 확인', 'DO-20260930-516 상세 · DN 상세(id 589) 품목 표에 REMARK 열 확인', 'Kolom REMARK dikonfirmasi pada tabel item detail DO-20260930-516 · detail DN (id 589)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '29' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'REJECTED', 'SURABAYA + 2026-09-01~09-30 필터 후 Excel 다운로드 파일명 Inventory_2026-10-02.xlsx — 기간 · 창고 미표기, 시트(Inventory)에 조회조건 행 없음. 데이터는 필터 반영(화면 12건 = 파일 12건). 헤더 오타 「Categroy2」', 'SURABAYA + 2026-09-01~09-30 필터 후 Excel 다운로드 파일명 Inventory_2026-10-02.xlsx — 기간 · 창고 미표기, 시트(Inventory)에 조회조건 행 없음. 데이터는 필터 반영(화면 12건 = 파일 12건). 헤더 오타 「Categroy2」', 'Setelah filter SURABAYA + 2026-09-01~09-30, nama file unduhan Excel Inventory_2026-10-02.xlsx — periode · gudang tidak dicantumkan, sheet (Inventory) tidak memuat baris kondisi pencarian. Data sudah sesuai filter (layar 12 = file 12). Salah ketik header 「Categroy2」', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '50' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', '재고 이동(Inventory Movement) 메뉴 · 라우트 없음(라우터 경로 목록 확인). IT Ongoing', '재고 이동(Inventory Movement) 메뉴 · 라우트 없음(라우터 경로 목록 확인). IT Ongoing', 'Menu · route Inventory Movement belum ada (dicek pada daftar route). IT Ongoing', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '52' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', '재고 목록 Category 2 선택지에 Light Truck(LT) 중복, Category 3 · 4도 Radial · Bias / TT · TL 반복 노출 — 재현', '재고 목록 Category 2 선택지에 Light Truck(LT) 중복, Category 3 · 4도 Radial · Bias / TT · TL 반복 노출 — 재현', 'Pilihan Category 2 daftar stok menampilkan Light Truck (LT) ganda, Category 3 · 4 juga mengulang Radial · Bias / TT · TL — masih terjadi', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '69' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'DO 목록 3페이지(DO-20260930-516) → 상세 → 뒤로가기 시 3페이지 유지 확인', 'DO 목록 3페이지(DO-20260930-516) → 상세 → 뒤로가기 시 3페이지 유지 확인', 'Daftar DO halaman 3 (DO-20260930-516) → detail → kembali : halaman 3 tetap dipertahankan', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '71' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'SHP-20260928-006 상세 ESTIMATED · ACTUAL 탭에 「3. Discount」 행 확인(해당 건 할인액 공란)', 'SHP-20260928-006 상세 ESTIMATED · ACTUAL 탭에 「3. Discount」 행 확인(해당 건 할인액 공란)', 'Baris 「3. Discount」 dikonfirmasi pada tab ESTIMATED · ACTUAL detail SHP-20260928-006 (nilai diskon dokumen ini kosong)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '72' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'DO · DN 목록 검색 안내문에 Warehouse 포함, DN 목록 「SURABAYA」 검색 시 50건 조회(창고 SURABAYA 전표만) 확인', 'DO · DN 목록 검색 안내문에 Warehouse 포함, DN 목록 「SURABAYA」 검색 시 50건 조회(창고 SURABAYA 전표만) 확인', 'Placeholder pencarian daftar DO · DN mencantumkan Warehouse, pencarian 「SURABAYA」 pada daftar DN menampilkan 50 dokumen (hanya gudang SURABAYA)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '73' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'PARTIAL', '글꼴은 PO 상세 화면 텍스트 요소 전부 Noto Sans(웹폰트 로드) 확인. 글자 크기는 11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px 9종 혼재로 일괄 적용 미흡', '글꼴은 PO 상세 화면 텍스트 요소 전부 Noto Sans(웹폰트 로드) 확인. 글자 크기는 11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px 9종 혼재로 일괄 적용 미흡', 'Font dikonfirmasi Noto Sans (web font termuat) pada seluruh elemen teks layar detail PO. Ukuran huruf bercampur 9 jenis (11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px) sehingga penyeragaman belum memadai', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '74' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');

-- ── 확인 ─────────────────────────────────────────────────────────────────────
-- ① IT상태 분포 (기대 : 엑셀 0926 기준 Completed 다수, Verified 7건 유지)
SELECT it_status, count(*) FROM public.csr_issues WHERE NOT is_archived GROUP BY it_status ORDER BY 1;
-- ② 오늘 검증 이력과 헤더 동기화 (기대 : 18행, 헤더 verified_on = 2026-10-02)
SELECT i.issue_no, i.it_status, i.verification_result, i.verified_on, v.result
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002' ORDER BY i.issue_no;
-- ③ IT 회신 행 수 (기대 : 54)
SELECT count(*) AS replies_0926 FROM public.csr_it_replies WHERE replied_on = DATE '2026-09-26' AND created_by = 'it-excel-260926';
-- ④ 신규 71~74
SELECT issue_no, title_ko, it_status, verification_result FROM public.csr_issues WHERE issue_no IN ('71','72','73','74') AND NOT is_archived ORDER BY 1;
