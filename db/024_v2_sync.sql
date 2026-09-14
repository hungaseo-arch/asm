-- =============================================================================
-- v2 개선요청서(ASM_테스트결과_개선요청서_v2.hwpx, 2026-09-14) 정합화
--   021~023 적용 후 실행. 달러 인용 없음. 재실행 안전(이미 있으면 건너뜀 · 같은 값 덮어씀).
--   생성: node scripts/csr_gen_024.cjs
--
--   1. 이슈 61~68 등록(Komang, Legal · Finance & Adm, 2026-09-11 접수) + 검증 이력 1행(PENDING · 최초 접수)
--      한국어 현상·개선 의견은 문서 원문 그대로, 인니어·요약·수용기준은 Claude 번역/초안 — 검수 서종환.
--   2. 57 현상·개선 의견을 문서 본문으로 교체(절사 내용 제거 — 이슈 12 중복). 이슈번호 변경 기록은 유지.
--   3. 57 · 58 · 59 담당자 → SEO (문서: v1 업무 요건 이관분 담당 SEO).
-- =============================================================================

SELECT set_config('csr.actor', 'migration:024 (v2 정합화)', false);

-- ── 61 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '61', '61. Partners > Customer 메뉴 진입 불가 — 법무 · 재무 담당 계정 권한 미개방', '61. Menu Partners > Customer Tidak Dapat Diakses — Hak Akses Akun Legal · Finance Belum Dibuka',
  'Partners', 'Customers', 'Partners > Customers', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Legal, Finance & Adm 담당(Komang) 계정으로 Partners > CUSTOMERS 클릭 시 화면 미전환 — 고객 마스터 검토 불가', 'Akun Legal, Finance & Adm (Komang) tidak dapat membuka Partners > CUSTOMERS — layar tidak berpindah, master pelanggan tidak dapat ditinjau',
  'R8(재무 · 법무) 계정으로 Partners > Customers · Suppliers 조회 가능, 여신 · 계약 항목 편집 권한 부여', 'Akun R8 (Finance · Legal) dapat membuka Partners > Customers · Suppliers dan memiliki hak edit item kredit · kontrak', '17 · 47', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'Legal, Finance & Adm 담당(Komang 계정)으로 Partners > CUSTOMERS 메뉴를 클릭해도 화면이 전환되지 않고 직전 화면(Quotation 목록)이 그대로 표시됨. 고객 마스터에 등록된 항목을 확인할 수 없어 여신 · 계약 관련 항목의 검토와 수정 의견 제시가 불가. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 47(창고 계정 메뉴 잠김) · 17(고객 마스터 이관 품질).', 'Legal, Finance & Adm 담당(Komang 계정)으로 Partners > CUSTOMERS 메뉴를 클릭해도 화면이 전환되지 않고 직전 화면(Quotation 목록)이 그대로 표시됨. 고객 마스터에 등록된 항목을 확인할 수 없어 여신 · 계약 관련 항목의 검토와 수정 의견 제시가 불가. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 47(창고 계정 메뉴 잠김) · 17(고객 마스터 이관 품질).', 'Saat masuk dengan akun Legal, Finance & Adm (Komang) dan mengklik menu Partners > CUSTOMERS, layar tidak berpindah dan layar sebelumnya (daftar Quotation) tetap ditampilkan. Item yang terdaftar pada master pelanggan tidak dapat diperiksa sehingga peninjauan dan usulan perbaikan atas item kredit · kontrak tidak dapat dilakukan. [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live). Isu terkait 47 (menu akun gudang terkunci) · 17 (kualitas migrasi master pelanggan).',
  '권한 매트릭스에 따라 R8(재무 · 법무)에 Partners > Customers · Suppliers 조회 및 여신 · 계약 항목 편집 권한 부여. 개발 기간 중에는 검토 목적의 읽기 권한을 우선 개방하고, 이슈 47과 함께 전 부서 계정 메뉴 권한 일괄 점검 결과 회신 요청.', '권한 매트릭스에 따라 R8(재무 · 법무)에 Partners > Customers · Suppliers 조회 및 여신 · 계약 항목 편집 권한 부여. 개발 기간 중에는 검토 목적의 읽기 권한을 우선 개방하고, 이슈 47과 함께 전 부서 계정 메뉴 권한 일괄 점검 결과 회신 요청.', 'Sesuai matriks hak akses, berikan hak lihat Partners > Customers · Suppliers serta hak edit item kredit · kontrak kepada R8 (Finance · Legal). Selama masa pengembangan, buka lebih dulu hak baca untuk keperluan peninjauan, dan bersama isu 47 lakukan pemeriksaan menyeluruh hak menu seluruh akun departemen lalu sampaikan hasilnya.',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '61');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '61' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 62 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '62', '62. 고객 마스터 — 법무 · 여신 관리 항목 확장 (고객 유형 · 계약서 · 담보 · 등급 · 결제조건 · 회수 상태 · 여신한도)', '62. Master Pelanggan — Perluasan Item Legal · Kredit (Jenis Pelanggan · Kontrak · Jaminan · Grade · Termin Pembayaran · Status Penagihan · Batas Kredit)',
  'Partners', 'Customers', 'Partners > Customers > Detail', '신규기능 / Fitur Baru', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', '고객 마스터에 법무 · 여신 항목(고객 유형 · 세그먼트 · 계약 · 담보 · 등급 · TOP · 결제 수단 · 회수 상태 · 여신한도 · 출고 승인) 부재 — 엑셀로 별도 관리', 'Master pelanggan belum memiliki item legal · kredit (jenis pelanggan · segmen · kontrak · jaminan · grade · TOP · cara bayar · status penagihan · batas kredit · persetujuan pengiriman) — masih dikelola di Excel',
  '고객 마스터 「법무 · 여신」 탭에 10개 항목 등록 · 조회 가능, SO · DO 확정 시 AR 연체 / 한도 초과 / 어음 미수령 3조건 검사 및 경고 → 승인 → 차단 동작', 'Tab 「Legal · Kredit」 pada master pelanggan dapat mencatat · menampilkan 10 item, dan saat konfirmasi SO · DO sistem memeriksa 3 kondisi AR menunggak / melebihi batas / giro belum diterima dengan alur peringatan → persetujuan → pemblokiran', '16 · 35 · 48 · 58', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  '현행 고객 마스터에 법무 · 여신 관리에 필요한 항목이 없어 계약 · 담보 · 회수 상태를 시스템 외(엑셀)로 관리 중. 요청 항목 — ① Customer Type(Principal · Distributor Independen · Distributor · Sub Distributor · Fleet) ② 제품별 세그먼트(Ascendo Tire · Techking · Solid · OTR · AGR · Vulkanisir · Mix) ③ 계약 문서(MOA · PPDR · PKPJB · PFK · 계약 기간) ④ 담보(유무 · 형태 · 문서 · 금액 · 만료일) ⑤ Customer Grade(Prime · Big · Medium · Small · Micro) ⑥ Term of Payment(CBD · TOP 7D~90D) 및 TOP 기산일(납품일 · 인보이스 수령일 · 어음 만기일) ⑦ 결제 수단(Transfer · Cek/Bilyet Giro · Customer Financing) ⑧ 회수 상태(On Time · Lancar · Tidak Lancar · Dalam Perhatian · Rescheduling · Bad Debt) ⑨ 여신한도(Unlimited · Limited 금액) ⑩ 출고 승인 — AR 연체 · 한도 초과 · 어음 미수령 시 팝업 경고 및 추가 승인 또는 시스템 차단. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 16(여신한도 필드) · 35(SO 재고 연동) · 48(Sales Rep) · 58(결재선).', '현행 고객 마스터에 법무 · 여신 관리에 필요한 항목이 없어 계약 · 담보 · 회수 상태를 시스템 외(엑셀)로 관리 중. 요청 항목 — ① Customer Type(Principal · Distributor Independen · Distributor · Sub Distributor · Fleet) ② 제품별 세그먼트(Ascendo Tire · Techking · Solid · OTR · AGR · Vulkanisir · Mix) ③ 계약 문서(MOA · PPDR · PKPJB · PFK · 계약 기간) ④ 담보(유무 · 형태 · 문서 · 금액 · 만료일) ⑤ Customer Grade(Prime · Big · Medium · Small · Micro) ⑥ Term of Payment(CBD · TOP 7D~90D) 및 TOP 기산일(납품일 · 인보이스 수령일 · 어음 만기일) ⑦ 결제 수단(Transfer · Cek/Bilyet Giro · Customer Financing) ⑧ 회수 상태(On Time · Lancar · Tidak Lancar · Dalam Perhatian · Rescheduling · Bad Debt) ⑨ 여신한도(Unlimited · Limited 금액) ⑩ 출고 승인 — AR 연체 · 한도 초과 · 어음 미수령 시 팝업 경고 및 추가 승인 또는 시스템 차단. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 16(여신한도 필드) · 35(SO 재고 연동) · 48(Sales Rep) · 58(결재선).', 'Master pelanggan saat ini tidak memiliki item yang diperlukan untuk pengelolaan legal · kredit, sehingga kontrak · jaminan · status penagihan dikelola di luar sistem (Excel). Item yang diminta — ① Customer Type (Principal · Distributor Independen · Distributor · Sub Distributor · Fleet) ② Segmen per produk (Ascendo Tire · Techking · Solid · OTR · AGR · Vulkanisir · Mix) ③ Dokumen kontrak (MOA · PPDR · PKPJB · PFK · masa kontrak) ④ Jaminan (ada/tidak · bentuk · dokumen · nilai · tanggal kedaluwarsa) ⑤ Customer Grade (Prime · Big · Medium · Small · Micro) ⑥ Term of Payment (CBD · TOP 7D~90D) dan dasar hitung TOP (tanggal kirim · tanggal terima invoice · jatuh tempo giro) ⑦ Cara pembayaran (Transfer · Cek/Bilyet Giro · Customer Financing) ⑧ Status penagihan (On Time · Lancar · Tidak Lancar · Dalam Perhatian · Rescheduling · Bad Debt) ⑨ Batas kredit (Unlimited · Limited nominal) ⑩ Persetujuan pengiriman — pop-up peringatan serta persetujuan tambahan atau pemblokiran sistem saat AR menunggak · melebihi batas · giro belum diterima. [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live). Isu terkait 16 (field batas kredit) · 35 (integrasi stok SO) · 48 (Sales Rep) · 58 (jalur persetujuan).',
  '고객 마스터에 「법무 · 여신」 탭 신설 — 상기 10개 항목을 코드 마스터(선택형)로 관리하고 계약 · 담보 문서는 첨부 및 만료일 알림 제공. 이슈 16의 여신한도 · 결제조건 필드와 통합 설계. 출고 승인 로직은 SO · Delivery Order 확정 시 「AR 연체 / 한도 초과 / 어음 미수령」 3조건을 검사하여 경고(팝업) → 승인 요청(R8 → R1) → 차단 단계로 구성하고, 결재 체계는 이슈 58과 동일 매트릭스 적용. 항목 편집 권한은 R8(재무 · 법무)로 한정.', '고객 마스터에 「법무 · 여신」 탭 신설 — 상기 10개 항목을 코드 마스터(선택형)로 관리하고 계약 · 담보 문서는 첨부 및 만료일 알림 제공. 이슈 16의 여신한도 · 결제조건 필드와 통합 설계. 출고 승인 로직은 SO · Delivery Order 확정 시 「AR 연체 / 한도 초과 / 어음 미수령」 3조건을 검사하여 경고(팝업) → 승인 요청(R8 → R1) → 차단 단계로 구성하고, 결재 체계는 이슈 58과 동일 매트릭스 적용. 항목 편집 권한은 R8(재무 · 법무)로 한정.', 'Tambahkan tab 「Legal · Kredit」 pada master pelanggan — 10 item di atas dikelola sebagai master kode (pilihan), dokumen kontrak · jaminan dapat dilampirkan dengan notifikasi kedaluwarsa. Rancang terintegrasi dengan field batas kredit · termin pembayaran pada isu 16. Logika persetujuan pengiriman memeriksa 3 kondisi 「AR menunggak / melebihi batas / giro belum diterima」 saat konfirmasi SO · Delivery Order, dengan tahapan peringatan (pop-up) → permintaan persetujuan (R8 → R1) → pemblokiran; jalur persetujuan memakai matriks yang sama dengan isu 58. Hak edit item dibatasi pada R8 (Finance · Legal).',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '62');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '62' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 63 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '63', '63. Finance 대메뉴 부재 — 메뉴 순서 업무 흐름 정렬 및 하위 메뉴 5종 신설', '63. Menu Utama Finance Belum Ada — Penataan Urutan Menu Sesuai Alur Kerja dan 5 Submenu Baru',
  'Finance', 'Main Menu', 'Finance', '신규기능 / Fitur Baru', 'S1 Blocker',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Finance 대메뉴 부재 — 인보이스 · 수금 · AR · 자금 계획을 시스템에서 수행 불가, 판매 프로세스가 Delivery Note 에서 종료', 'Menu utama Finance belum ada — penerbitan invoice · penerimaan · AR · rencana kas tidak dapat dilakukan di sistem, proses penjualan berhenti di Delivery Note',
  '대메뉴 순서 Purchasing > Inventory > Sales > Finance > Partners > Master Data > Settings, Finance 하위 5종(Invoice · Income · AR · Income Plan · IPR) 메뉴 진입 가능', 'Urutan menu utama Purchasing > Inventory > Sales > Finance > Partners > Master Data > Settings, dan 5 submenu Finance (Invoice · Income · AR · Income Plan · IPR) dapat diakses', '16 · 59 · 64 · 65 · 66 · 67 · 68', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'New ASM에 Finance 대메뉴가 없어 인보이스 발행 · 수금 · 채권(AR) · 자금 계획 업무를 시스템에서 수행할 수 없음. 판매 프로세스가 Delivery Note에서 종료되어 매출 인식 · 세금계산서(Faktur Pajak) · 수금 대사가 구 ASM 또는 엑셀에 의존. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 16(여신) · 59(Payment Plan).', 'New ASM에 Finance 대메뉴가 없어 인보이스 발행 · 수금 · 채권(AR) · 자금 계획 업무를 시스템에서 수행할 수 없음. 판매 프로세스가 Delivery Note에서 종료되어 매출 인식 · 세금계산서(Faktur Pajak) · 수금 대사가 구 ASM 또는 엑셀에 의존. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 16(여신) · 59(Payment Plan).', 'New ASM belum memiliki menu utama Finance sehingga penerbitan invoice · penerimaan pembayaran · piutang (AR) · rencana kas tidak dapat dilakukan di sistem. Proses penjualan berakhir di Delivery Note, sehingga pengakuan penjualan · faktur pajak · rekonsiliasi penerimaan masih bergantung pada ASM lama atau Excel. [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live). Isu terkait 16 (kredit) · 59 (Payment Plan).',
  '대메뉴 순서를 업무 흐름에 맞춰 Purchasing > Inventory > Sales > Finance > Partners > Master Data > Settings로 조정하고 Finance 대메뉴 신설. 하위 메뉴 — Invoice · Income · AR(Account Receivables) · Income Plan · IPR(Income Plan & Realization) 5종(이슈 64~68). 구 ASM 화면을 기준 레이아웃으로 참조. 구매 측 Payment Plan(이슈 59)과 대칭 구조로 설계.', '대메뉴 순서를 업무 흐름에 맞춰 Purchasing > Inventory > Sales > Finance > Partners > Master Data > Settings로 조정하고 Finance 대메뉴 신설. 하위 메뉴 — Invoice · Income · AR(Account Receivables) · Income Plan · IPR(Income Plan & Realization) 5종(이슈 64~68). 구 ASM 화면을 기준 레이아웃으로 참조. 구매 측 Payment Plan(이슈 59)과 대칭 구조로 설계.', 'Susun ulang urutan menu utama mengikuti alur kerja menjadi Purchasing > Inventory > Sales > Finance > Partners > Master Data > Settings dan tambahkan menu utama Finance. Submenu — Invoice · Income · AR (Account Receivables) · Income Plan · IPR (Income Plan & Realization), 5 jenis (isu 64~68). Layar ASM lama dijadikan acuan tata letak. Dirancang simetris dengan Payment Plan sisi pembelian (isu 59).',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '63');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '63' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 64 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '64', '64. Finance > Invoice 화면 부재 — 세금계산서 번호 · 발송 · 수령 · 어음 만기 관리 및 판매 리포트', '64. Layar Finance > Invoice Belum Ada — Pengelolaan Nomor Faktur Pajak · Pengiriman · Penerimaan · Jatuh Tempo Giro dan Laporan Penjualan',
  'Finance', 'Invoice', 'Finance > Invoice', '신규기능 / Fitur Baru', 'S1 Blocker',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Finance > Invoice 부재 — 인보이스 조회 · 발행 · 편집(Faktur Pajak 번호 · 발송/수령일 · 어음 만기 · 입금 계좌) 및 Sales Report/Analysis 불가', 'Finance > Invoice belum ada — daftar · penerbitan · edit invoice (nomor Faktur Pajak · tanggal kirim/terima · jatuh tempo giro · rekening) serta Sales Report/Analysis tidak tersedia',
  'Delivery Note 확정 건에서 인보이스 생성, Faktur Pajak 번호 · 발송/수령일 · 어음 만기 · 은행 계좌 편집 및 이력 보관, 만기일 자동 산출, Sales Report · Analysis Excel 출력', 'Invoice dibuat dari Delivery Note terkonfirmasi; nomor Faktur Pajak · tanggal kirim/terima · jatuh tempo giro · rekening dapat diedit dengan riwayat; jatuh tempo dihitung otomatis; Sales Report · Analysis dapat diekspor ke Excel', '12 · 13 · 22 · 62', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'Finance > Invoice 메뉴가 없어 인보이스 목록 조회 · 발행 · 편집 불가. 필수 편집 항목 — Faktur Pajak 번호, 인보이스 발송일, 인보이스 수령일, Cek/Giro 만기일(인보이스 만기 산정 기준), 입금 은행 계좌(BCA · Mandiri). 리포트 — Sales Report(일 · 주 · 월 · 연), 필터(제품 · 제품 세그먼트 · 고객 · 지역), Sales Analysis(월별 · 제품별 · 고객별 추이). 구 ASM의 Invoice Index · Form을 참고 양식으로 첨부. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 12(절사) · 13(IDR 소수점) · 22(숫자 표기).', 'Finance > Invoice 메뉴가 없어 인보이스 목록 조회 · 발행 · 편집 불가. 필수 편집 항목 — Faktur Pajak 번호, 인보이스 발송일, 인보이스 수령일, Cek/Giro 만기일(인보이스 만기 산정 기준), 입금 은행 계좌(BCA · Mandiri). 리포트 — Sales Report(일 · 주 · 월 · 연), 필터(제품 · 제품 세그먼트 · 고객 · 지역), Sales Analysis(월별 · 제품별 · 고객별 추이). 구 ASM의 Invoice Index · Form을 참고 양식으로 첨부. [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 12(절사) · 13(IDR 소수점) · 22(숫자 표기).', 'Menu Finance > Invoice belum ada sehingga daftar invoice tidak dapat dilihat · diterbitkan · diedit. Item edit yang wajib — nomor Faktur Pajak, tanggal pengiriman invoice, tanggal penerimaan invoice, jatuh tempo Cek/Giro (dasar perhitungan jatuh tempo invoice), rekening bank penerimaan (BCA · Mandiri). Laporan — Sales Report (harian · mingguan · bulanan · tahunan), filter (produk · segmen produk · pelanggan · wilayah), Sales Analysis (tren per bulan · per produk · per pelanggan). Invoice Index · Form ASM lama dilampirkan sebagai format acuan. [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live). Isu terkait 12 (pemotongan) · 13 (desimal IDR) · 22 (format angka).',
  'Finance > Invoice 신설 — Delivery Note 확정 건에서 인보이스 생성, Faktur Pajak 번호 · 발송일 · 수령일 · 어음 만기일 · 은행 계좌 편집 허용(확정 후 변경은 이력 보관). 인보이스 만기일은 고객 마스터 TOP 기산일(이슈 62)에 따라 자동 산출. 출력물은 구 ASM 양식을 기준으로 정비. Sales Report · Sales Analysis는 Sales > Report로 배치하고 Excel 출력(이슈 50 파일명 규칙) 지원. 금액 표기는 이슈 12 · 13 · 22 기준 적용.', 'Finance > Invoice 신설 — Delivery Note 확정 건에서 인보이스 생성, Faktur Pajak 번호 · 발송일 · 수령일 · 어음 만기일 · 은행 계좌 편집 허용(확정 후 변경은 이력 보관). 인보이스 만기일은 고객 마스터 TOP 기산일(이슈 62)에 따라 자동 산출. 출력물은 구 ASM 양식을 기준으로 정비. Sales Report · Sales Analysis는 Sales > Report로 배치하고 Excel 출력(이슈 50 파일명 규칙) 지원. 금액 표기는 이슈 12 · 13 · 22 기준 적용.', 'Tambahkan Finance > Invoice — invoice dibuat dari Delivery Note yang sudah dikonfirmasi; nomor Faktur Pajak · tanggal kirim · tanggal terima · jatuh tempo giro · rekening bank dapat diedit (perubahan setelah konfirmasi disimpan sebagai riwayat). Jatuh tempo invoice dihitung otomatis berdasarkan dasar hitung TOP master pelanggan (isu 62). Format cetak mengacu pada format ASM lama. Sales Report · Sales Analysis ditempatkan di Sales > Report dengan dukungan ekspor Excel (aturan nama file isu 50). Format nilai mengikuti isu 12 · 13 · 22.',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '64');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '64' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 65 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '65', '65. Finance > Income(수금) 화면 부재 — 입금 등록 · 지연 수금 분석 · 어음 모니터링', '65. Layar Finance > Income (Penerimaan) Belum Ada — Pencatatan Penerimaan · Analisis Keterlambatan · Pemantauan Giro',
  'Finance', 'Income', 'Finance > Income', '신규기능 / Fitur Baru', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Finance > Income 부재 — 고객 입금(현금 · 이체 · Cek/Bilyet Giro)의 인보이스 대사 등록 및 Income Report · Late Payment · Giro 모니터링 불가', 'Finance > Income belum ada — penerimaan pelanggan (tunai · transfer · Cek/Bilyet Giro) tidak dapat dicatat dan direkonsiliasi ke invoice; Income Report · Late Payment · pemantauan Giro tidak tersedia',
  '입금 등록 후 인보이스 다건 대사(부분 입금 허용), 어음 상태 관리(수령 → 만기 → 결제/부도), 입금 확정 시 AR 자동 차감 및 회수 상태 갱신', 'Penerimaan dapat direkonsiliasi ke banyak invoice (pembayaran sebagian diizinkan), status giro dikelola (diterima → jatuh tempo → cair/tolak), dan konfirmasi penerimaan mengurangi AR serta memperbarui status penagihan secara otomatis', '62 · 66', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'Finance > Income 메뉴가 없어 고객 입금(현금 · 이체 · Cek/Bilyet Giro)을 인보이스에 대사하여 등록할 수 없음. 리포트 — Income Report(일 · 주 · 월 · 연), Late Payment 분석(인보이스별 · 고객별), Cek/Bilyet Giro 모니터링(수령 · 만기 · 결제 · 부도). 구 ASM Income Index 화면을 참고 양식으로 제시(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수).', 'Finance > Income 메뉴가 없어 고객 입금(현금 · 이체 · Cek/Bilyet Giro)을 인보이스에 대사하여 등록할 수 없음. 리포트 — Income Report(일 · 주 · 월 · 연), Late Payment 분석(인보이스별 · 고객별), Cek/Bilyet Giro 모니터링(수령 · 만기 · 결제 · 부도). 구 ASM Income Index 화면을 참고 양식으로 제시(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수).', 'Menu Finance > Income belum ada sehingga penerimaan dari pelanggan (tunai · transfer · Cek/Bilyet Giro) tidak dapat dicatat dengan rekonsiliasi ke invoice. Laporan — Income Report (harian · mingguan · bulanan · tahunan), analisis Late Payment (per invoice · per pelanggan), pemantauan Cek/Bilyet Giro (diterima · jatuh tempo · cair · tolak). Layar Income Index ASM lama diajukan sebagai format acuan (tangkapan format EMF, tidak dimuat dalam dokumen ini). [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live).',
  'Finance > Income 신설 — 입금 등록(일자 · 은행 · 수단 · 금액) 후 인보이스 다건 대사(부분 입금 허용), 어음은 수령 → 만기 → 결제/부도 상태 관리. Income Report · Late Payment 분석 · Giro 모니터링 화면 제공. 입금 확정 시 AR(이슈 66) 자동 차감 및 회수 상태(이슈 62 ⑧) 자동 갱신.', 'Finance > Income 신설 — 입금 등록(일자 · 은행 · 수단 · 금액) 후 인보이스 다건 대사(부분 입금 허용), 어음은 수령 → 만기 → 결제/부도 상태 관리. Income Report · Late Payment 분석 · Giro 모니터링 화면 제공. 입금 확정 시 AR(이슈 66) 자동 차감 및 회수 상태(이슈 62 ⑧) 자동 갱신.', 'Tambahkan Finance > Income — pencatatan penerimaan (tanggal · bank · cara · nominal) lalu rekonsiliasi ke banyak invoice (pembayaran sebagian diizinkan); giro dikelola dengan status diterima → jatuh tempo → cair/tolak. Sediakan layar Income Report · analisis Late Payment · pemantauan Giro. Saat penerimaan dikonfirmasi, AR (isu 66) berkurang otomatis dan status penagihan (isu 62 ⑧) diperbarui otomatis.',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '65');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '65' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 66 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '66', '66. Finance > AR(Account Receivables) 화면 부재 — 채권 변동 · 미수 잔액 · Aging · 연체 분석', '66. Layar Finance > AR (Account Receivables) Belum Ada — Mutasi Piutang · Saldo Outstanding · Aging · Analisis Tunggakan',
  'Finance', 'AR', 'Finance > AR', '신규기능 / Fitur Baru', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Finance > AR 부재 — 채권 잔액(AR = Sales − Income − Adjustment) 산출 · 조회 및 Aging · AR Mutation · 연체 분석 불가', 'Finance > AR belum ada — saldo piutang (AR = Sales − Income − Adjustment) tidak dapat dihitung · dilihat; Aging · AR Mutation · analisis tunggakan tidak tersedia',
  '고객별 · 인보이스별 AR 잔액 자동 산출, Aging 5구간 · AR Mutation · 연체 분석 리포트 제공, 여신한도 대비 미수 잔액이 SO · DO 출고 승인 검사에 연동', 'Saldo AR per pelanggan · per invoice dihitung otomatis; laporan Aging 5 rentang · AR Mutation · analisis tunggakan tersedia; outstanding terhadap batas kredit terhubung ke pemeriksaan persetujuan pengiriman SO · DO', '16 · 62 · 64 · 65', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'Finance > AR 메뉴가 없어 채권 잔액(AR = Sales − Income − Adjustment)을 시스템에서 산출 · 조회할 수 없음. Adjustment 예시 — AR ↔ AP 상계, AR ↔ 보증 클레임 상계, 판매 반품. 리포트 — AR Mutation(일 · 주 · 월 · 연), 인보이스별 · 고객별 미수 상세, Aging(고객 요약 · 인보이스 상세), AR Analysis(월별 · 고객별 추이 · 연체 요약 · Late Payment). 구 ASM AR Index 화면 참고(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 16(여신한도) · 62(회수 상태).', 'Finance > AR 메뉴가 없어 채권 잔액(AR = Sales − Income − Adjustment)을 시스템에서 산출 · 조회할 수 없음. Adjustment 예시 — AR ↔ AP 상계, AR ↔ 보증 클레임 상계, 판매 반품. 리포트 — AR Mutation(일 · 주 · 월 · 연), 인보이스별 · 고객별 미수 상세, Aging(고객 요약 · 인보이스 상세), AR Analysis(월별 · 고객별 추이 · 연체 요약 · Late Payment). 구 ASM AR Index 화면 참고(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 16(여신한도) · 62(회수 상태).', 'Menu Finance > AR belum ada sehingga saldo piutang (AR = Sales − Income − Adjustment) tidak dapat dihitung · dilihat di sistem. Contoh Adjustment — kompensasi AR ↔ AP, kompensasi AR ↔ klaim garansi, retur penjualan. Laporan — AR Mutation (harian · mingguan · bulanan · tahunan), rincian outstanding per invoice · per pelanggan, Aging (ringkasan pelanggan · rincian invoice), AR Analysis (tren bulanan · per pelanggan · ringkasan tunggakan · Late Payment). Layar AR Index ASM lama sebagai acuan (tangkapan format EMF, tidak dimuat dalam dokumen ini). [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live). Isu terkait 16 (batas kredit) · 62 (status penagihan).',
  'Finance > AR 신설 — 인보이스(이슈 64) · 입금(이슈 65) · 조정 전표(상계 · 반품 · 대손)를 연계하여 고객별 · 인보이스별 잔액 자동 산출. Aging 구간(미도래 · 1~30 · 31~60 · 61~90 · 90일 초과) 및 AR Mutation · 연체 분석 리포트 제공. 여신한도 대비 미수 잔액을 SO · DO 출고 승인 검사(이슈 62 ⑩)의 기준값으로 연동.', 'Finance > AR 신설 — 인보이스(이슈 64) · 입금(이슈 65) · 조정 전표(상계 · 반품 · 대손)를 연계하여 고객별 · 인보이스별 잔액 자동 산출. Aging 구간(미도래 · 1~30 · 31~60 · 61~90 · 90일 초과) 및 AR Mutation · 연체 분석 리포트 제공. 여신한도 대비 미수 잔액을 SO · DO 출고 승인 검사(이슈 62 ⑩)의 기준값으로 연동.', 'Tambahkan Finance > AR — saldo per pelanggan · per invoice dihitung otomatis dengan mengaitkan invoice (isu 64) · penerimaan (isu 65) · dokumen penyesuaian (kompensasi · retur · piutang tak tertagih). Sediakan rentang Aging (belum jatuh tempo · 1~30 · 31~60 · 61~90 · lebih dari 90 hari) serta laporan AR Mutation · analisis tunggakan. Saldo outstanding terhadap batas kredit dijadikan nilai acuan pemeriksaan persetujuan pengiriman SO · DO (isu 62 ⑩).',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '66');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '66' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 67 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '67', '67. Finance > Income Plan(수금 계획) 화면 부재 — 만기 기준 주차별 수금 계획 · 조정 · 현금 판매 추정', '67. Layar Finance > Income Plan (Rencana Penerimaan) Belum Ada — Rencana Penerimaan Mingguan Berbasis Jatuh Tempo · Penyesuaian · Estimasi Penjualan Tunai',
  'Finance', 'Income Plan', 'Finance > Income Plan', '신규기능 / Fitur Baru', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Finance > Income Plan 부재 — 미수 인보이스 만기 기준 수금 계획(M0 W1~W5 · M+1 · M+2)을 엑셀로 별도 작성', 'Finance > Income Plan belum ada — rencana penerimaan berbasis jatuh tempo invoice outstanding (M0 W1~W5 · M+1 · M+2) masih disusun terpisah di Excel',
  'AR 미수 상세에서 만기 기준 자동 분류(M0 W1~W5 · M+1 · M+2), 건별 수금 예정일 조정 · 사유 이력, 현금 판매 추정 항목 추가, 고객별 · 제품 분류별 집계', 'Klasifikasi otomatis berbasis jatuh tempo dari rincian outstanding AR (M0 W1~W5 · M+1 · M+2), penyesuaian tanggal rencana per invoice dengan riwayat alasan, item estimasi penjualan tunai dapat ditambahkan, rekap per pelanggan · per klasifikasi produk', '59 · 66', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'Finance > Income Plan 메뉴가 없어 미수 인보이스 만기 기준의 수금 계획을 엑셀로 별도 작성 중. 요청 — 미수 인보이스 상세를 기초 데이터로 당월 M0(W1~W5) · M+1 · M+2 구간 분류, 인보이스 만기와 다른 수금 예정일 조정 옵션(판단 · 특수 사례 · 과거 결제 이력), 미수 인보이스 외 항목(현금 판매 추정) 추가 옵션, 고객별 · 제품 분류별 양식. 구 ASM 양식 참고(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 59(수입 대금 지급 Payment Plan).', 'Finance > Income Plan 메뉴가 없어 미수 인보이스 만기 기준의 수금 계획을 엑셀로 별도 작성 중. 요청 — 미수 인보이스 상세를 기초 데이터로 당월 M0(W1~W5) · M+1 · M+2 구간 분류, 인보이스 만기와 다른 수금 예정일 조정 옵션(판단 · 특수 사례 · 과거 결제 이력), 미수 인보이스 외 항목(현금 판매 추정) 추가 옵션, 고객별 · 제품 분류별 양식. 구 ASM 양식 참고(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 A(오픈 前 필수). 관련 이슈 59(수입 대금 지급 Payment Plan).', 'Menu Finance > Income Plan belum ada sehingga rencana penerimaan berdasarkan jatuh tempo invoice outstanding disusun terpisah di Excel. Permintaan — rincian invoice outstanding sebagai data dasar, klasifikasi periode bulan berjalan M0 (W1~W5) · M+1 · M+2, opsi penyesuaian tanggal rencana penerimaan yang berbeda dari jatuh tempo invoice (pertimbangan · kasus khusus · riwayat pembayaran), opsi penambahan item di luar invoice outstanding (estimasi penjualan tunai), format per pelanggan · per klasifikasi produk. Format ASM lama sebagai acuan (tangkapan format EMF, tidak dimuat dalam dokumen ini). [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan A (wajib sebelum go-live). Isu terkait 59 (Payment Plan pembayaran impor).',
  'Finance > Income Plan 신설 — AR 미수 상세(이슈 66)에서 만기 기준 자동 분류(M0 W1~W5 · M+1 · M+2), 건별 수금 예정일 조정(사유 코드 · 이력 보관), 수동 항목(현금 판매 추정) 추가, 고객별 · 제품 분류별 집계. 구매 측 Payment Plan(이슈 59)과 함께 월별 자금 계획(수입 − 지출) 리포트로 통합 조회 가능하도록 설계.', 'Finance > Income Plan 신설 — AR 미수 상세(이슈 66)에서 만기 기준 자동 분류(M0 W1~W5 · M+1 · M+2), 건별 수금 예정일 조정(사유 코드 · 이력 보관), 수동 항목(현금 판매 추정) 추가, 고객별 · 제품 분류별 집계. 구매 측 Payment Plan(이슈 59)과 함께 월별 자금 계획(수입 − 지출) 리포트로 통합 조회 가능하도록 설계.', 'Tambahkan Finance > Income Plan — klasifikasi otomatis berbasis jatuh tempo dari rincian outstanding AR (isu 66) (M0 W1~W5 · M+1 · M+2), penyesuaian tanggal rencana per invoice (kode alasan · riwayat disimpan), penambahan item manual (estimasi penjualan tunai), rekap per pelanggan · per klasifikasi produk. Dirancang agar dapat digabung dengan Payment Plan sisi pembelian (isu 59) menjadi laporan rencana kas bulanan (penerimaan − pengeluaran).',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '67');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '67' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 68 ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  '68', '68. Finance > IPR(Income Plan & Realization) 화면 부재 — 수금 계획 대비 실적 · 미실현 사유 · 조치 계획', '68. Layar Finance > IPR (Income Plan & Realization) Belum Ada — Realisasi vs Rencana Penerimaan · Alasan Belum Terealisasi · Rencana Tindak Lanjut',
  'Finance', 'IPR', 'Finance > IPR', '신규기능 / Fitur Baru', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '재무 / Keuangan', DATE '2026-09-11', 'Finance > IPR 부재 — 수금 계획 대비 실적 대사 · 분석(IPR Status · IPR Analysis)을 엑셀로 수행', 'Finance > IPR belum ada — rekonsiliasi · analisis realisasi terhadap rencana penerimaan (IPR Status · IPR Analysis) masih dilakukan di Excel',
  'Income Plan 대비 Income 실현율 · 미실현 금액 산출, 미실현 건에 사유 코드 · 조치 계획 · 담당자 입력, 일 · 주 · 월 필터', 'Tingkat realisasi · nominal belum terealisasi Income terhadap Income Plan dihitung; item belum terealisasi dapat diberi kode alasan · rencana tindak lanjut · penanggung jawab; filter harian · mingguan · bulanan', '65 · 67', '개발부서 / Tim Pengembang',
  'Open', 'Komang', '미회신 / Belum Ada Balasan', 'PENDING',
  'Finance > IPR 메뉴가 없어 수금 계획(Income Plan) 대비 실적(Income)의 대사 · 분석을 엑셀로 수행. 요청 — IPR Status(일 · 주 · 월 필터), IPR Analysis(미실현 계획 · 사유 · 조치 계획). 구 ASM IPR Index 참고(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 B(오픈 後). 관련 이슈 65 · 67.', 'Finance > IPR 메뉴가 없어 수금 계획(Income Plan) 대비 실적(Income)의 대사 · 분석을 엑셀로 수행. 요청 — IPR Status(일 · 주 · 월 필터), IPR Analysis(미실현 계획 · 사유 · 조치 계획). 구 ASM IPR Index 참고(EMF 형식 캡처, 본 문서 미수록). [2026-09-11 현지 사용자 개선요청 — Komang(Legal, Finance & Adm, Jakarta)] 요청 우선순위 B(오픈 後). 관련 이슈 65 · 67.', 'Menu Finance > IPR belum ada sehingga rekonsiliasi · analisis realisasi (Income) terhadap rencana penerimaan (Income Plan) dilakukan di Excel. Permintaan — IPR Status (filter harian · mingguan · bulanan), IPR Analysis (rencana belum terealisasi · alasan · rencana tindak lanjut). IPR Index ASM lama sebagai acuan (tangkapan format EMF, tidak dimuat dalam dokumen ini). [Usulan perbaikan pengguna lokal 2026-09-11 — Komang (Legal, Finance & Adm, Jakarta)] Prioritas permintaan B (setelah go-live). Isu terkait 65 · 67.',
  'Finance > IPR 신설 — Income Plan(이슈 67)과 Income(이슈 65)을 계획 구간별로 대사하여 실현율 · 미실현 금액 산출, 미실현 건에 사유 코드 · 조치 계획 · 담당자 입력. 오픈 後 1차 개선(~2026-10) 범위, Income Plan · Income 안정화 후 착수.', 'Finance > IPR 신설 — Income Plan(이슈 67)과 Income(이슈 65)을 계획 구간별로 대사하여 실현율 · 미실현 금액 산출, 미실현 건에 사유 코드 · 조치 계획 · 담당자 입력. 오픈 後 1차 개선(~2026-10) 범위, Income Plan · Income 안정화 후 착수.', 'Tambahkan Finance > IPR — rekonsiliasi Income Plan (isu 67) dan Income (isu 65) per periode rencana untuk menghitung tingkat realisasi · nominal belum terealisasi, dengan input kode alasan · rencana tindak lanjut · penanggung jawab pada item yang belum terealisasi. Termasuk perbaikan tahap 1 setelah go-live (~2026-10), dimulai setelah Income Plan · Income stabil.',
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = '68');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-11', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', '최초 접수 — 2026-09-11 현지 사용자 개선요청서(Komang, Legal · Finance & Adm)', 'Diterima pertama kali — Formulir Usulan Perbaikan pengguna lokal 2026-09-11 (Komang, Legal · Finance & Adm)', 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '68' AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- ── 57 본문 교체 ──
UPDATE public.csr_issues
   SET findings_md          = 'PPN 11% · PPh 22 7.5% · BC(관세) 5% 등 세율이 소스코드 고정값으로 처리되어 세법 개정 · 품목별 관세율 차이 · 면세 거래 발생 시 현업이 변경할 수 없음. v1 VIII-3(세무 정합성) 중 절사 로직은 이슈 12와 중복되어 제외하고 세율 마스터화 요청만 본 이슈로 이관. [v1 업무 요건 제안 이관 — 담당 SEO(총괄팀)]

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-3 (세무 정합성) → 이슈 60(초안) → **이슈 57** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 반올림(절사) 로직 부분은 이슈 12와 중복이라 삭제하고 세율 마스터 관리 요청만 유지.',
       findings_md_ko       = 'PPN 11% · PPh 22 7.5% · BC(관세) 5% 등 세율이 소스코드 고정값으로 처리되어 세법 개정 · 품목별 관세율 차이 · 면세 거래 발생 시 현업이 변경할 수 없음. v1 VIII-3(세무 정합성) 중 절사 로직은 이슈 12와 중복되어 제외하고 세율 마스터화 요청만 본 이슈로 이관. [v1 업무 요건 제안 이관 — 담당 SEO(총괄팀)]

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-3 (세무 정합성) → 이슈 60(초안) → **이슈 57** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 반올림(절사) 로직 부분은 이슈 12와 중복이라 삭제하고 세율 마스터 관리 요청만 유지.',
       findings_md_id       = 'Tarif pajak seperti PPN 11% · PPh 22 7,5% · BC (bea masuk) 5% diproses sebagai nilai tetap dalam kode sumber, sehingga pengguna bisnis tidak dapat mengubahnya ketika terjadi perubahan peraturan pajak · perbedaan tarif bea per item · transaksi bebas pajak. Dari v1 VIII-3 (kesesuaian perpajakan), logika pemotongan dikecualikan karena tumpang tindih dengan isu 12, dan hanya permintaan master tarif pajak yang dialihkan ke isu ini. [Pengalihan usulan kebutuhan bisnis v1 — PIC SEO (Tim Umum)]',
       recommendation_md    = '세율을 마스터 관리 항목(세목 · 세율 · 적용 시작일 · 종료일 · HS 코드별 관세율)으로 전환하고 전표 생성 시점의 유효 세율을 참조. 세율 변경은 R8(회계) 등록 → R1 승인 경유, 변경 이력 보관. 이슈 12(절사 DPP 기준) · v1 09(PIB 실적 세액)와 함께 처리.',
       recommendation_md_ko = '세율을 마스터 관리 항목(세목 · 세율 · 적용 시작일 · 종료일 · HS 코드별 관세율)으로 전환하고 전표 생성 시점의 유효 세율을 참조. 세율 변경은 R8(회계) 등록 → R1 승인 경유, 변경 이력 보관. 이슈 12(절사 DPP 기준) · v1 09(PIB 실적 세액)와 함께 처리.',
       recommendation_md_id = 'Ubah tarif pajak menjadi item master (jenis pajak · tarif · tanggal mulai · tanggal akhir · tarif bea per kode HS) dan acu tarif yang berlaku pada saat dokumen dibuat. Perubahan tarif didaftarkan oleh R8 (Akuntansi) → disetujui R1, riwayat perubahan disimpan. Ditangani bersama isu 12 (dasar pemotongan DPP) · v1 09 (nilai pajak realisasi PIB).'
 WHERE issue_no = '57' AND NOT is_archived;

-- ── 57 · 58 · 59 담당자 SEO (문서 기준) ──
UPDATE public.csr_issues SET it_pic = 'SEO' WHERE issue_no IN ('57', '58', '59') AND NOT is_archived AND it_pic IS DISTINCT FROM 'SEO';

-- 확인 — 61~68 8행(PENDING · 09-11 · 이력 1) · 57~60 담당자 SEO
SELECT issue_no, priority, menu_main, menu_sub, it_pic, verification_result, verified_on,
       (SELECT count(*) FROM public.csr_verifications v WHERE v.issue_id = i.id) AS verif_rows
  FROM public.csr_issues i WHERE issue_no IN ('57','58','59','60','61','62','63','64','65','66','67','68') AND NOT is_archived
 ORDER BY issue_no;
SELECT count(*) AS total_live FROM public.csr_issues WHERE NOT is_archived;
