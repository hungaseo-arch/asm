-- =============================================================================
-- 261008 개선요청서(ASM_테스트결과_개선요청서_261008.hwpx) 신규 이슈 75~83 등록
--   039 적용 후 실행. 달러 인용 없음. 재실행 안전(같은 번호가 있으면 건너뜀)
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--
--   입력 : 현지 사용자 개선요청 양식 2026-10-06 접수 Merry 2 · Lia 3 + 총괄팀 SEO 4 = 9건
--   1. csr_issues 9행 — IT상태 Open · IT수용여부 미회신 · 현업검증 PENDING · 담당자 = 요청자
--      한국어 현상 · 개선 의견은 문서 원문 그대로, 인니어 · 요약 · 수용기준은 Claude 번역/초안 — 검수 서종환
--   2. csr_verifications 9행 — 2026-10-08 PENDING 「최초 접수」
--   3. 캡처(csr_attachments)는 미포함 — 사이트 상세 화면에서 업로드(75 · 77 · 78 · 82 · 83 캡처 有, 79~81은 78과 동일 화면)
--   다음 신규 이슈는 84번부터
-- =============================================================================

SELECT set_config('csr.actor', 'migration:040 (261008 개선요청서 75~83)', false);

-- ── 75 ──
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
  '75', '75. Delivery Order 출력물 — Payment Method 미갱신 (Quotation · Customer PO 변경분 미반영)', '75. Cetakan Delivery Order — Payment Method Tidak Diperbarui (Perubahan di Quotation · Customer PO Tidak Terbawa)',
  'Sales', 'Delivery Order', 'Sales > Delivery Order > Print', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '영업 / Penjualan', DATE '2026-10-06', 'Quotation · Customer PO에서 결제조건 변경 후에도 DO 출력물 Payment Method는 변경 전 값(예 : DO-20260901-007 「CASH CBD」) 인쇄', 'Setelah termin pembayaran diubah di Quotation · Customer PO, cetakan DO tetap mencetak Payment Method lama (contoh : DO-20260901-007 「CASH CBD」)',
  '결제조건 변경 → DO 신규 발행 → 출력물 Payment Term이 Sales 화면 최종 결제조건과 일치. DO 발행 후 변경 건은 이슈 70 기준(재발행 또는 변경 이력 표시) 적용', 'Ubah termin pembayaran → terbitkan DO baru → Payment Term pada cetakan sama dengan termin terakhir di layar Sales. Perubahan setelah DO terbit mengikuti isu 70 (terbit ulang atau tampilkan riwayat perubahan)', '27 · 70', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Quotation 및 Customer PO에서 결제조건(Payment Term)을 변경했으나 Delivery Order 출력물의 Payment Method는 변경 전 값 그대로 인쇄
- 캡처 사례 : DO-20260901-007 (PT. RISUN TRADING INDONESIA, No. PO CGDD26082802, ASC 23.5-25TR179 튜브 100본) 출력물 Payment Method 「CASH CBD」 표시
- 영향 : 출력물 결제조건과 실제 거래조건 불일치로 고객 인수 확인 · 대금 회수 단계에서 분쟁 소지
- 관련 이슈 : 27(DO 출력물 결제조건, 조치확인 상태) 재발 여부, 70(결제조건 이력 보존 · 전표 생성 시점 값 저장) 설계와의 충돌 여부 확인 필요
- 참고 : 동 출력물의 Delivery Date(01-09-2026)가 DO 일자(Tanggal 02-09-2026)보다 앞섬. 일자 선후 검증 규칙 별도 확인 필요
- [2026-10-06 현지 사용자 개선요청 — Merry(Admin Sales)] 요청 우선순위 A(오픈 前 필수). 원문 : Sudah rubah payment term di Quotation & Customer PO. Tapi ketika di Print out DO Payment method tidak berubah sesuai Quotation', '- Quotation 및 Customer PO에서 결제조건(Payment Term)을 변경했으나 Delivery Order 출력물의 Payment Method는 변경 전 값 그대로 인쇄
- 캡처 사례 : DO-20260901-007 (PT. RISUN TRADING INDONESIA, No. PO CGDD26082802, ASC 23.5-25TR179 튜브 100본) 출력물 Payment Method 「CASH CBD」 표시
- 영향 : 출력물 결제조건과 실제 거래조건 불일치로 고객 인수 확인 · 대금 회수 단계에서 분쟁 소지
- 관련 이슈 : 27(DO 출력물 결제조건, 조치확인 상태) 재발 여부, 70(결제조건 이력 보존 · 전표 생성 시점 값 저장) 설계와의 충돌 여부 확인 필요
- 참고 : 동 출력물의 Delivery Date(01-09-2026)가 DO 일자(Tanggal 02-09-2026)보다 앞섬. 일자 선후 검증 규칙 별도 확인 필요
- [2026-10-06 현지 사용자 개선요청 — Merry(Admin Sales)] 요청 우선순위 A(오픈 前 필수). 원문 : Sudah rubah payment term di Quotation & Customer PO. Tapi ketika di Print out DO Payment method tidak berubah sesuai Quotation', '- Termin pembayaran (Payment Term) sudah diubah di Quotation dan Customer PO, tetapi Payment Method pada cetakan Delivery Order tetap mencetak nilai sebelum perubahan
- Contoh capture : cetakan DO-20260901-007 (PT. RISUN TRADING INDONESIA, No. PO CGDD26082802, ASC 23.5-25TR179 tube 100 pcs) menampilkan Payment Method 「CASH CBD」
- Dampak : termin pada cetakan tidak sama dengan termin transaksi sebenarnya sehingga berpotensi sengketa saat konfirmasi penerimaan pelanggan · penagihan
- Isu terkait : perlu dicek apakah isu 27 (termin pembayaran cetakan DO, status sudah dikonfirmasi) muncul kembali, dan apakah bertentangan dengan desain isu 70 (riwayat termin pembayaran · simpan nilai saat dokumen dibuat)
- Catatan : pada cetakan yang sama Delivery Date (01-09-2026) lebih awal dari tanggal DO (Tanggal 02-09-2026). Aturan validasi urutan tanggal perlu dicek terpisah
- [Usulan perbaikan pengguna lokal 2026-10-06 — Merry (Admin Sales)] Prioritas permintaan A (wajib sebelum go-live). Teks asli : Sudah rubah payment term di Quotation & Customer PO. Tapi ketika di Print out DO Payment method tidak berubah sesuai Quotation',
  '- DO 출력물 Payment Method를 Sales 화면(Quotation → Customer PO → SO)의 최종 결제조건과 같은 기준으로 표시
- 반영 원칙 확정 : DO 발행 전 상위 전표 변경분은 DO에 자동 반영, DO 발행 후 변경은 이슈 70 기준(발행 시점 값 보존)에 따라 DO 재발행 또는 변경 이력 표시
- 출력물 라벨을 화면 용어와 통일 (Payment Method → Payment Term)
- 재검증 : 결제조건 변경 → DO 신규 발행 → 출력물 대조 순서로 현업(Merry) 확인 후 Verified 처리', '- DO 출력물 Payment Method를 Sales 화면(Quotation → Customer PO → SO)의 최종 결제조건과 같은 기준으로 표시
- 반영 원칙 확정 : DO 발행 전 상위 전표 변경분은 DO에 자동 반영, DO 발행 후 변경은 이슈 70 기준(발행 시점 값 보존)에 따라 DO 재발행 또는 변경 이력 표시
- 출력물 라벨을 화면 용어와 통일 (Payment Method → Payment Term)
- 재검증 : 결제조건 변경 → DO 신규 발행 → 출력물 대조 순서로 현업(Merry) 확인 후 Verified 처리', '- Payment Method pada cetakan DO ditampilkan dengan dasar yang sama dengan termin pembayaran terakhir di layar Sales (Quotation → Customer PO → SO)
- Tetapkan prinsip penerapan : perubahan pada dokumen induk sebelum DO terbit otomatis terbawa ke DO, perubahan setelah DO terbit mengikuti isu 70 (nilai saat terbit dipertahankan) dengan DO terbit ulang atau tampilan riwayat perubahan
- Label cetakan diseragamkan dengan istilah layar (Payment Method → Payment Term)
- Verifikasi ulang : ubah termin → terbitkan DO baru → cocokkan cetakan, dikonfirmasi pengguna (Merry) lalu diproses Verified',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '75' OR title_ko = '75. Delivery Order 출력물 — Payment Method 미갱신 (Quotation · Customer PO 변경분 미반영)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Merry, Admin Sales) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-06 개선요청서(Merry, Admin Sales) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Merry, Admin Sales) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '75' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 76 ──
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
  '76', '76. Sales 전 메뉴 — Admin 계정의 전 지점(Surabaya · Semarang) 거래 조회 권한 부재', '76. Semua Menu Sales — Akun Admin Belum Dapat Melihat Transaksi Semua Cabang (Surabaya · Semarang)',
  'Sales', '공통 (권한 · 데이터 범위) / Umum (Hak Akses)', 'Sales > 전 메뉴', '개선 / Perbaikan', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '영업 / Penjualan', DATE '2026-10-06', '본사 Admin 계정 10명(Merry · Lia · Lisa · Dinda · Tari · Alya · Riri · Rachma · Safira · Komang)이 Surabaya · Semarang 지점 Sales 거래를 조회할 수 없어 지점 거래 통제 불가', '10 akun Admin kantor pusat (Merry · Lia · Lisa · Dinda · Tari · Alya · Riri · Rachma · Safira · Komang) tidak dapat melihat transaksi Sales cabang Surabaya · Semarang sehingga kontrol transaksi cabang tidak dapat dilakukan',
  '대상 10개 계정으로 Sales 목록 전 화면에서 Surabaya · Semarang 거래 조회 가능, 지점 필터 동작. 타 지점 거래 수정 · 승인은 불가', 'Dengan 10 akun target, transaksi Surabaya · Semarang dapat dilihat di seluruh daftar Sales dan filter cabang berfungsi. Ubah · setujui transaksi cabang lain tetap tidak dapat dilakukan', '61', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Admin 계정으로 Sales 메뉴 조회 시 Surabaya · Semarang 지점 거래를 함께 확인할 수 없어 본사 Admin의 지점 거래 통제 · 점검 불가
- 대상 계정(요청자 기재 10명) : Merry · Lia · Lisa · Dinda · Tari(Lestari) · Alya · Riri · Rachma · Safira · Komang
- 요청자 캡처 없음. 현재 지점별 조회 범위 설정값은 개발부서 확인 필요
- 관련 이슈 : 61(Partners > Customer 메뉴 권한 미개방)
- [2026-10-06 현지 사용자 개선요청 — Merry(Admin Sales)] 요청 우선순위 A(오픈 前 필수). 원문 : Untuk akun admin dapat menampilkan transaksi dari Surabaya dan Semarang sehingga dapat mengontrol seluruh transaksi cabang', '- Admin 계정으로 Sales 메뉴 조회 시 Surabaya · Semarang 지점 거래를 함께 확인할 수 없어 본사 Admin의 지점 거래 통제 · 점검 불가
- 대상 계정(요청자 기재 10명) : Merry · Lia · Lisa · Dinda · Tari(Lestari) · Alya · Riri · Rachma · Safira · Komang
- 요청자 캡처 없음. 현재 지점별 조회 범위 설정값은 개발부서 확인 필요
- 관련 이슈 : 61(Partners > Customer 메뉴 권한 미개방)
- [2026-10-06 현지 사용자 개선요청 — Merry(Admin Sales)] 요청 우선순위 A(오픈 前 필수). 원문 : Untuk akun admin dapat menampilkan transaksi dari Surabaya dan Semarang sehingga dapat mengontrol seluruh transaksi cabang', '- Saat membuka menu Sales dengan akun Admin, transaksi cabang Surabaya · Semarang tidak dapat dilihat bersama sehingga Admin kantor pusat tidak dapat mengontrol · memeriksa transaksi cabang
- Akun target (ditulis pemohon, 10 orang) : Merry · Lia · Lisa · Dinda · Tari (Lestari) · Alya · Riri · Rachma · Safira · Komang
- Tidak ada capture dari pemohon. Pengaturan cakupan data per cabang saat ini perlu dicek Tim Pengembang
- Isu terkait : 61 (hak akses menu Partners > Customer belum dibuka)
- [Usulan perbaikan pengguna lokal 2026-10-06 — Merry (Admin Sales)] Prioritas permintaan A (wajib sebelum go-live). Teks asli : Untuk akun admin dapat menampilkan transaksi dari Surabaya dan Semarang sehingga dapat mengontrol seluruh transaksi cabang',
  '- 권한 체계에 「전 지점 조회(All Branch View)」 데이터 범위 옵션 추가 후 위 10개 계정에 부여
- Sales 목록 화면(Quotation · Customer PO · SO · DO · Invoice · Sales Return)에 지점 필터 추가, Admin 계정 기본값은 「전체」
- 조회 범위와 편집 범위 분리 : 타 지점 거래는 조회 전용, 수정 · 승인은 해당 지점 권한자로 한정
- 권한가이드라인(v3.0) 역할 정의에 데이터 범위(지점) 항목 반영 후 개발부서와 확정', '- 권한 체계에 「전 지점 조회(All Branch View)」 데이터 범위 옵션 추가 후 위 10개 계정에 부여
- Sales 목록 화면(Quotation · Customer PO · SO · DO · Invoice · Sales Return)에 지점 필터 추가, Admin 계정 기본값은 「전체」
- 조회 범위와 편집 범위 분리 : 타 지점 거래는 조회 전용, 수정 · 승인은 해당 지점 권한자로 한정
- 권한가이드라인(v3.0) 역할 정의에 데이터 범위(지점) 항목 반영 후 개발부서와 확정', '- Tambahkan opsi cakupan data 「Lihat Semua Cabang (All Branch View)」 pada sistem hak akses, lalu berikan kepada 10 akun di atas
- Tambahkan filter cabang pada layar daftar Sales (Quotation · Customer PO · SO · DO · Invoice · Sales Return), nilai default akun Admin = 「Semua」
- Pisahkan cakupan lihat dan cakupan edit : transaksi cabang lain hanya lihat, ubah · setujui terbatas pada pemegang hak cabang tersebut
- Cerminkan item cakupan data (cabang) pada definisi peran Pedoman Hak Akses (v3.0), lalu tetapkan bersama Tim Pengembang',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '76' OR title_ko = '76. Sales 전 메뉴 — Admin 계정의 전 지점(Surabaya · Semarang) 거래 조회 권한 부재'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Merry, Admin Sales) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-06 개선요청서(Merry, Admin Sales) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Merry, Admin Sales) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '76' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 77 ──
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
  '77', '77. 판촉물(Material Promosi) — 입고 · 출고(In – Out) 거래 기능 부재', '77. Material Promosi — Fitur Transaksi Masuk · Keluar (In – Out) Belum Ada',
  'Inventory', 'Promotional Materials', 'Master Data > Products > Promotional Materials', '신규기능 / Fitur Baru', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '구매 / Pembelian', DATE '2026-10-06', '판촉물 품목은 Products > Promotional Materials 탭에 등록되어 있으나 입고 · 출고 거래 기능이 없어 수량 · 배포처 추적 불가', 'Item material promosi sudah terdaftar di tab Products > Promotional Materials, tetapi belum ada fitur transaksi masuk · keluar sehingga jumlah · tujuan distribusi tidak dapat dilacak',
  '판촉물 입고 · 출고 등록 후 품목별 재고 수량 반영, 출고처 조회 가능. 타이어 재고 · 매출원가 집계에서 제외', 'Setelah pencatatan masuk · keluar material promosi, stok per item terupdate dan tujuan pengeluaran dapat dilihat. Dikecualikan dari stok ban · HPP', '83', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Products 목록의 Promotional Materials 탭에 판촉물 품목(카탈로그 · 부채 · 탁상 캘린더 · 티셔츠 · 인삼 · 커피 등, 4페이지 분량)이 등록되어 있으나 입고 · 출고 거래 기능 없음
- 판촉물 수량 · 배포처를 시스템에서 추적할 근거가 없어 별도 관리 의존
- [2026-10-06 현지 사용자 개선요청 — Lia(Purchasing Lokal)] 요청 우선순위 B(오픈 後). 원문 : Mohon bantu tambahkan transaksi In – Out Material Promosi', '- Products 목록의 Promotional Materials 탭에 판촉물 품목(카탈로그 · 부채 · 탁상 캘린더 · 티셔츠 · 인삼 · 커피 등, 4페이지 분량)이 등록되어 있으나 입고 · 출고 거래 기능 없음
- 판촉물 수량 · 배포처를 시스템에서 추적할 근거가 없어 별도 관리 의존
- [2026-10-06 현지 사용자 개선요청 — Lia(Purchasing Lokal)] 요청 우선순위 B(오픈 後). 원문 : Mohon bantu tambahkan transaksi In – Out Material Promosi', '- Item material promosi (katalog · kipas · kalender meja · kaos · ginseng · kopi, dll., 4 halaman) sudah terdaftar di tab Promotional Materials pada daftar Products, tetapi belum ada fitur transaksi masuk · keluar
- Tidak ada dasar di sistem untuk melacak jumlah · tujuan distribusi material promosi sehingga bergantung pada pencatatan terpisah
- [Usulan perbaikan pengguna lokal 2026-10-06 — Lia (Purchasing Lokal)] Prioritas permintaan B (setelah go-live). Teks asli : Mohon bantu tambahkan transaksi In – Out Material Promosi',
  '- Inventory 하위에 판촉물 입고(In) · 출고(Out) 거래 화면 추가 : 일자 · 품목 · 수량 · 창고 · 출고처(고객 · 영업담당 · 행사) · 비고
- 판촉물 재고는 타이어 재고와 분리 집계하고 재고 평가 · 매출원가 대상에서 제외
- 출고 실적은 이슈 83 Budget Plan의 판촉물 비용(Biaya Material Promosi) 항목과 연계
- 기존 Configure Minimum Stock 설정값 기준으로 재고 부족 알림 활용', '- Inventory 하위에 판촉물 입고(In) · 출고(Out) 거래 화면 추가 : 일자 · 품목 · 수량 · 창고 · 출고처(고객 · 영업담당 · 행사) · 비고
- 판촉물 재고는 타이어 재고와 분리 집계하고 재고 평가 · 매출원가 대상에서 제외
- 출고 실적은 이슈 83 Budget Plan의 판촉물 비용(Biaya Material Promosi) 항목과 연계
- 기존 Configure Minimum Stock 설정값 기준으로 재고 부족 알림 활용', '- Tambahkan layar transaksi masuk (In) · keluar (Out) material promosi di bawah Inventory : tanggal · item · jumlah · gudang · tujuan (pelanggan · sales · acara) · keterangan
- Stok material promosi dihitung terpisah dari stok ban dan dikecualikan dari penilaian persediaan · HPP
- Realisasi pengeluaran dihubungkan dengan item Biaya Material Promosi pada Budget Plan (isu 83)
- Gunakan nilai Configure Minimum Stock yang sudah ada untuk notifikasi stok kurang',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '77' OR title_ko = '77. 판촉물(Material Promosi) — 입고 · 출고(In – Out) 거래 기능 부재'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Lia, Purchasing Lokal) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-06 개선요청서(Lia, Purchasing Lokal) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Lia, Purchasing Lokal) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '77' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 78 ──
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
  '78', '78. Products 기본정보 — 창고입고가(WH Price) 항목 부재 · 입력 화면 그룹 구분 미흡', '78. Info Dasar Products — Item Harga Masuk Gudang (WH Price) Belum Ada · Pengelompokan Layar Input Kurang',
  'Master Data', 'Products', 'Master Data > Products > Basic Product Info', '개선 / Perbaikan', 'S2 Major',
  '미정 / Belum Ditentukan', '총괄팀 / Tim Umum', DATE '2026-10-08', '제품 등록 화면에 창고입고가(wh_price) 항목 없음(BUY PRICE와 정의 불명확). TECHNICAL SPECIFICATION 약 22개 항목 무그룹 나열, CLOSE · SAVE 버튼 위계 미흡', 'Layar input produk belum memiliki item harga masuk gudang (wh_price) (definisi terhadap BUY PRICE tidak jelas). Sekitar 22 item TECHNICAL SPECIFICATION tersusun tanpa grup, hierarki tombol CLOSE · SAVE lemah',
  '전 품목에 창고입고가 입력 · 조회 가능, BUY PRICE와 라벨 구분. 기술사양 3개 소그룹 표시, 하단 고정 바에 SAVE(주) · CLOSE(보조) 배치', 'Harga masuk gudang dapat diinput · dilihat untuk semua item dan labelnya dibedakan dari BUY PRICE. Spesifikasi teknis tampil dalam 3 subgrup, SAVE (utama) · CLOSE (sekunder) di bilah bawah tetap', '23 · 79', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Flap 품목 등록 화면(ASC 12.00R24 Metal Plate, ARTICLE NO 52100120024)에 창고입고가(wh_price) 항목 없음. BUY PRICE가 창고입고가를 뜻하는지 불명확
- TECHNICAL SPECIFICATION 영역에 약 22개 항목이 그룹 구분 없이 한 영역에 나열
- CLOSE · SAVE 버튼이 폼 하단에 고정되지 않고 두 버튼의 시각적 위계 구분이 약함
- 기존 CSR 등록 건 제외 : 23 반응형 레이아웃(라벨 잘림), 63 Finance 대메뉴 신설
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 미표기', '- Flap 품목 등록 화면(ASC 12.00R24 Metal Plate, ARTICLE NO 52100120024)에 창고입고가(wh_price) 항목 없음. BUY PRICE가 창고입고가를 뜻하는지 불명확
- TECHNICAL SPECIFICATION 영역에 약 22개 항목이 그룹 구분 없이 한 영역에 나열
- CLOSE · SAVE 버튼이 폼 하단에 고정되지 않고 두 버튼의 시각적 위계 구분이 약함
- 기존 CSR 등록 건 제외 : 23 반응형 레이아웃(라벨 잘림), 63 Finance 대메뉴 신설
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 미표기', '- Layar input item Flap (ASC 12.00R24 Metal Plate, ARTICLE NO 52100120024) tidak memiliki item harga masuk gudang (wh_price). Tidak jelas apakah BUY PRICE berarti harga masuk gudang
- Sekitar 22 item pada area TECHNICAL SPECIFICATION ditampilkan dalam satu area tanpa pengelompokan
- Tombol CLOSE · SAVE tidak tetap di bagian bawah formulir dan hierarki visual kedua tombol lemah
- Dikecualikan karena sudah terdaftar di CSR : 23 layout responsif (label terpotong), 63 pembuatan menu utama Finance
- [Usulan perbaikan Tim Umum 2026-10-08 — SEO] Prioritas permintaan tidak ditandai',
  '- 전 품목 공통으로 창고입고가 항목 추가. BUY PRICE(구매단가)와 창고입고가(입고 원가) 정의를 구분해 라벨 명확화
- TECHNICAL SPECIFICATION 소그룹 분할 : 규격(SIZE · TD · SECTION WIDTH · RIM · OVERALL/INTERNAL DIAMETER · THICK · WIDTH) / 성능(PLY RATING · PLY · LI_S · LI_D · SPEED SYMBOL · PRESS) / 물류 · 기타(WEIGHT · TYRE 40FT · PACK · VALVE · COUNTRY OF ORIGIN · REMARK)
- 하단 고정 바(Sticky Footer) 적용, SAVE는 주 버튼 · CLOSE는 보조 버튼으로 구분', '- 전 품목 공통으로 창고입고가 항목 추가. BUY PRICE(구매단가)와 창고입고가(입고 원가) 정의를 구분해 라벨 명확화
- TECHNICAL SPECIFICATION 소그룹 분할 : 규격(SIZE · TD · SECTION WIDTH · RIM · OVERALL/INTERNAL DIAMETER · THICK · WIDTH) / 성능(PLY RATING · PLY · LI_S · LI_D · SPEED SYMBOL · PRESS) / 물류 · 기타(WEIGHT · TYRE 40FT · PACK · VALVE · COUNTRY OF ORIGIN · REMARK)
- 하단 고정 바(Sticky Footer) 적용, SAVE는 주 버튼 · CLOSE는 보조 버튼으로 구분', '- Tambahkan item harga masuk gudang untuk semua item. Bedakan definisi BUY PRICE (harga beli) dan harga masuk gudang (biaya masuk) lalu perjelas labelnya
- Bagi TECHNICAL SPECIFICATION menjadi subgrup : Ukuran (SIZE · TD · SECTION WIDTH · RIM · OVERALL/INTERNAL DIAMETER · THICK · WIDTH) / Performa (PLY RATING · PLY · LI_S · LI_D · SPEED SYMBOL · PRESS) / Logistik · Lainnya (WEIGHT · TYRE 40FT · PACK · VALVE · COUNTRY OF ORIGIN · REMARK)
- Terapkan bilah bawah tetap (Sticky Footer), SAVE sebagai tombol utama · CLOSE sebagai tombol sekunder',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '78' OR title_ko = '78. Products 기본정보 — 창고입고가(WH Price) 항목 부재 · 입력 화면 그룹 구분 미흡'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-08 개선요청서(SEO, 총괄팀) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '78' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 79 ──
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
  '79', '79. Products 필수 입력 · 저장 검증 — 카테고리별 필수 · 표시 항목 미분리', '79. Input Wajib · Validasi Simpan Products — Item Wajib · Tampil per Kategori Belum Dipisahkan',
  'Master Data', 'Products', 'Master Data > Products > Basic Product Info', '개선 / Perbaikan', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'Flap 품목에도 PATTERN 필수 · 타이어 전용 항목 노출, 가격 통화 미표기, 숫자 항목 기본값 0(미입력 구분 불가), ARTICLE NO 중복 확인 불명확', 'Item Flap juga mewajibkan PATTERN · menampilkan item khusus ban, mata uang harga tidak ditulis, default item angka 0 (tidak dapat dibedakan dari belum diisi), cek duplikasi ARTICLE NO tidak jelas',
  'Flap 선택 시 타이어 전용 항목 숨김 · PATTERN 비필수, 가격 라벨 통화 표기, 미입력 숫자는 공란 저장, 중복 ARTICLE NO 입력 시 즉시 경고', 'Saat Flap dipilih item khusus ban disembunyikan · PATTERN tidak wajib, label harga mencantumkan mata uang, angka yang tidak diisi disimpan kosong, peringatan langsung saat ARTICLE NO duplikat', '19 · 25 · 78', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Flap(Flap > Truck/Bus(TB) > MP) 품목에서 PATTERN*(필수)이 공란이며 Flap에는 해당 없는 항목. 의도된 정책인지 확인 필요
- Flap 선택 상태에서도 PLY RATING · SPEED SYMBOL · LI_S · LI_D · PRESS 등 타이어 전용 항목 노출
- BUY PRICE* · SELL PRICE*에 통화(IDR / USD) 표기 없음
- OVERALL DIAMETER · TD · SECTION WIDTH · RIM · PLY · LI_S · LI_D · PRESS 기본값이 모두 0. 미입력과 실제 0 구분 불가
- ARTICLE NO(52100120024) 중복 확인 기능 불명확
- 기존 CSR 등록 건 제외 : 19 단가 · 중량 0 등록(제품 마스터), 25 입력 검증 미입력 안내 방식
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 A(오픈 前 필수)', '- Flap(Flap > Truck/Bus(TB) > MP) 품목에서 PATTERN*(필수)이 공란이며 Flap에는 해당 없는 항목. 의도된 정책인지 확인 필요
- Flap 선택 상태에서도 PLY RATING · SPEED SYMBOL · LI_S · LI_D · PRESS 등 타이어 전용 항목 노출
- BUY PRICE* · SELL PRICE*에 통화(IDR / USD) 표기 없음
- OVERALL DIAMETER · TD · SECTION WIDTH · RIM · PLY · LI_S · LI_D · PRESS 기본값이 모두 0. 미입력과 실제 0 구분 불가
- ARTICLE NO(52100120024) 중복 확인 기능 불명확
- 기존 CSR 등록 건 제외 : 19 단가 · 중량 0 등록(제품 마스터), 25 입력 검증 미입력 안내 방식
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 A(오픈 前 필수)', '- Pada item Flap (Flap > Truck/Bus(TB) > MP) PATTERN* (wajib) kosong dan tidak relevan untuk Flap. Perlu konfirmasi apakah ini kebijakan yang disengaja
- Saat Flap dipilih, item khusus ban seperti PLY RATING · SPEED SYMBOL · LI_S · LI_D · PRESS tetap tampil
- BUY PRICE* · SELL PRICE* tidak mencantumkan mata uang (IDR / USD)
- Nilai default OVERALL DIAMETER · TD · SECTION WIDTH · RIM · PLY · LI_S · LI_D · PRESS semuanya 0. Belum diisi dan nilai 0 sebenarnya tidak dapat dibedakan
- Fitur cek duplikasi ARTICLE NO (52100120024) tidak jelas
- Dikecualikan karena sudah terdaftar di CSR : 19 harga · berat 0 terdaftar (master produk), 25 cara pemberitahuan input kosong
- [Usulan perbaikan Tim Umum 2026-10-08 — SEO] Prioritas permintaan A (wajib sebelum go-live)',
  '- 카테고리별 필수 · 표시 항목 분리 (Flap : PATTERN 등 타이어 전용 항목 숨김 또는 선택 처리)
- BUY PRICE · SELL PRICE 라벨에 통화 명시
- 해당 없는 숫자 항목은 공란(NULL) 처리, 0은 실제 입력값에만 사용
- ARTICLE NO 입력 즉시 중복 체크, 중복 시 기존 품목 링크 표시', '- 카테고리별 필수 · 표시 항목 분리 (Flap : PATTERN 등 타이어 전용 항목 숨김 또는 선택 처리)
- BUY PRICE · SELL PRICE 라벨에 통화 명시
- 해당 없는 숫자 항목은 공란(NULL) 처리, 0은 실제 입력값에만 사용
- ARTICLE NO 입력 즉시 중복 체크, 중복 시 기존 품목 링크 표시', '- Pisahkan item wajib · tampil per kategori (Flap : item khusus ban seperti PATTERN disembunyikan atau dijadikan opsional)
- Cantumkan mata uang pada label BUY PRICE · SELL PRICE
- Item angka yang tidak relevan disimpan kosong (NULL), 0 hanya untuk nilai yang benar-benar diinput
- Cek duplikasi segera saat ARTICLE NO diinput, bila duplikat tampilkan tautan ke item yang sudah ada',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '79' OR title_ko = '79. Products 필수 입력 · 저장 검증 — 카테고리별 필수 · 표시 항목 미분리'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-08 개선요청서(SEO, 총괄팀) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '79' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 80 ──
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
  '80', '80. Products 숫자 · 단위 표기 — 세율 소수 자릿수 불일치 · 단위 및 약어 풀네임 미표기', '80. Penulisan Angka · Satuan Products — Jumlah Desimal Tarif Tidak Seragam · Satuan dan Kepanjangan Singkatan Belum Ditulis',
  'Master Data', 'Products', 'Master Data > Products > Basic Product Info', '개선 / Perbaikan', 'S3 Minor',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '세율(BM · PPN · PPH) 소수 자릿수 불일치(0 / 11 / 2.5), WEIGHT 단위 · 자릿수 미정, TYRE 40FT 정의 불명, 약어 라벨 풀네임 · 단위 없음', 'Jumlah desimal tarif (BM · PPN · PPH) tidak seragam (0 / 11 / 2.5), satuan · desimal WEIGHT belum ditetapkan, definisi TYRE 40FT tidak jelas, label singkatan tanpa kepanjangan · satuan',
  '세율 0.0% · 11.0% · 2.5% 형식 표시, WEIGHT (kg) 소수점 첫째 자리, TYRE 40FT 라벨 명확화, 약어 풀네임 · 단위(psi · mm) 병기', 'Tarif tampil dengan format 0.0% · 11.0% · 2.5%, WEIGHT (kg) satu desimal, label TYRE 40FT diperjelas, singkatan disertai kepanjangan · satuan (psi · mm)', '22', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- HS CODE BM(%) · PPN(%) · PPH(%)가 0 / 11 / 2.5로 소수 자릿수 불일치
- WEIGHT 3.25로 소수점 둘째 자리 표기, 단위(kg) 표기 없음
- TYRE 40FT 정의 불명. 40ft 컨테이너 적입 본수로 추정되나 확인 필요
- TD · LI_S · LI_D · PRESS · THICK 등 약어 라벨에 풀네임 · 단위 없음
- 기존 CSR 등록 건 제외 : 22 숫자 표기 형식(단가 소수점 · 수량 정수 · 콤마 / 마침표)
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 A(오픈 前 필수)', '- HS CODE BM(%) · PPN(%) · PPH(%)가 0 / 11 / 2.5로 소수 자릿수 불일치
- WEIGHT 3.25로 소수점 둘째 자리 표기, 단위(kg) 표기 없음
- TYRE 40FT 정의 불명. 40ft 컨테이너 적입 본수로 추정되나 확인 필요
- TD · LI_S · LI_D · PRESS · THICK 등 약어 라벨에 풀네임 · 단위 없음
- 기존 CSR 등록 건 제외 : 22 숫자 표기 형식(단가 소수점 · 수량 정수 · 콤마 / 마침표)
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 A(오픈 前 필수)', '- HS CODE BM(%) · PPN(%) · PPH(%) tertulis 0 / 11 / 2.5 sehingga jumlah desimal tidak seragam
- WEIGHT tertulis 3.25 (dua desimal) tanpa satuan (kg)
- Definisi TYRE 40FT tidak jelas. Diduga jumlah ban per kontainer 40ft, perlu konfirmasi
- Label singkatan seperti TD · LI_S · LI_D · PRESS · THICK tanpa kepanjangan · satuan
- Dikecualikan karena sudah terdaftar di CSR : 22 format penulisan angka (desimal harga · kuantitas bulat · koma / titik)
- [Usulan perbaikan Tim Umum 2026-10-08 — SEO] Prioritas permintaan A (wajib sebelum go-live)',
  '- 퍼센트 항목 소수점 첫째 자리 통일 (0.0% · 11.0% · 2.5%)
- 라벨에 (kg) 명시, 중량 소수점 첫째 자리 포맷. 더 높은 정밀도가 필요하면 현업 부서와 협의
- TYRE 40FT 정의 확인 후 라벨 명확화 (예 : Qty per 40ft)
- 약어 풀네임 병기 및 단위 표기 (PRESS : psi, 치수 : mm 등)', '- 퍼센트 항목 소수점 첫째 자리 통일 (0.0% · 11.0% · 2.5%)
- 라벨에 (kg) 명시, 중량 소수점 첫째 자리 포맷. 더 높은 정밀도가 필요하면 현업 부서와 협의
- TYRE 40FT 정의 확인 후 라벨 명확화 (예 : Qty per 40ft)
- 약어 풀네임 병기 및 단위 표기 (PRESS : psi, 치수 : mm 등)', '- Seragamkan item persen menjadi satu desimal (0.0% · 11.0% · 2.5%)
- Cantumkan (kg) pada label, format berat satu desimal. Bila perlu presisi lebih tinggi, dibahas dengan tim bisnis
- Konfirmasi definisi TYRE 40FT lalu perjelas labelnya (contoh : Qty per 40ft)
- Tulis kepanjangan singkatan dan satuannya (PRESS : psi, dimensi : mm, dll.)',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '80' OR title_ko = '80. Products 숫자 · 단위 표기 — 세율 소수 자릿수 불일치 · 단위 및 약어 풀네임 미표기'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-08 개선요청서(SEO, 총괄팀) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '80' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 81 ──
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
  '81', '81. Products 카테고리 · HS CODE · 품명 — 단계 라벨 부재 · 세율 및 명칭 수기 입력', '81. Kategori · HS CODE · Nama Produk Products — Label Tingkat Belum Ada · Tarif dan Nama Diinput Manual',
  'Master Data', 'Products', 'Master Data > Products > Basic Product Info', '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'CATEGORY 4단 드롭다운 단계 라벨 없음 · 4단계 공란 · MP 약어 불명, HS CODE와 세율 · DESCRIPTION 수기 입력으로 불일치 위험', 'Dropdown CATEGORY 4 tingkat tanpa label tingkat · tingkat 4 kosong · singkatan MP tidak jelas, HS CODE dengan tarif · DESCRIPTION diinput manual sehingga berisiko tidak konsisten',
  '카테고리 단계 라벨 표시, HS CODE 선택 시 세율 자동 제안(수기 변경 시 사유 · 이력 기록), DESCRIPTION 자동 생성 후 수정 가능', 'Label tingkat kategori tampil, tarif otomatis diusulkan saat HS CODE dipilih (alasan · riwayat tercatat bila diubah manual), DESCRIPTION dibuat otomatis lalu dapat diubah', '57', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- CATEGORY 드롭다운 4개 중 4번째가 공란이고 단계 라벨 없음. 3번째 값 MP 약어 의미 불명 (DESCRIPTION 기준 Metal Plate로 추정)
- HS CODE(4012.90.80)와 세율(BM · PPN · PPH)을 각각 수기 입력하여 불일치 위험
- DESCRIPTION(ASC 12.00R24 Metal Plate)을 수기 입력하여 명칭 규칙 통일 어려움
- 관련 이슈 : 57(세율 PPN · PPh 22 · BC 마스터)
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 B(오픈 後)', '- CATEGORY 드롭다운 4개 중 4번째가 공란이고 단계 라벨 없음. 3번째 값 MP 약어 의미 불명 (DESCRIPTION 기준 Metal Plate로 추정)
- HS CODE(4012.90.80)와 세율(BM · PPN · PPH)을 각각 수기 입력하여 불일치 위험
- DESCRIPTION(ASC 12.00R24 Metal Plate)을 수기 입력하여 명칭 규칙 통일 어려움
- 관련 이슈 : 57(세율 PPN · PPh 22 · BC 마스터)
- [2026-10-08 총괄팀 개선요청 — SEO] 요청 우선순위 B(오픈 後)', '- Dari 4 dropdown CATEGORY, yang ke-4 kosong dan tidak ada label tingkat. Arti singkatan MP pada nilai ke-3 tidak jelas (diduga Metal Plate berdasarkan DESCRIPTION)
- HS CODE (4012.90.80) dan tarif (BM · PPN · PPH) masing-masing diinput manual sehingga berisiko tidak konsisten
- DESCRIPTION (ASC 12.00R24 Metal Plate) diinput manual sehingga aturan penamaan sulit diseragamkan
- Isu terkait : 57 (master tarif PPN · PPh 22 · BC)
- [Usulan perbaikan Tim Umum 2026-10-08 — SEO] Prioritas permintaan B (setelah go-live)',
  '- 단계 라벨(대 · 중 · 소 · 세분류) 표기, 4단계가 불필요하면 제거. 상위 선택 전 하위 드롭다운 비활성. MP 등 약어 의미 표기
- HS CODE 선택 시 BM · PPN · PPH 자동 제안(이슈 57 세율 마스터 연동), 수기 변경 시 사유 · 이력 기록
- DESCRIPTION을 BRAND + SIZE + 유형 조합으로 자동 생성 후 수정 가능하도록 처리', '- 단계 라벨(대 · 중 · 소 · 세분류) 표기, 4단계가 불필요하면 제거. 상위 선택 전 하위 드롭다운 비활성. MP 등 약어 의미 표기
- HS CODE 선택 시 BM · PPN · PPH 자동 제안(이슈 57 세율 마스터 연동), 수기 변경 시 사유 · 이력 기록
- DESCRIPTION을 BRAND + SIZE + 유형 조합으로 자동 생성 후 수정 가능하도록 처리', '- Tampilkan label tingkat (besar · menengah · kecil · rinci), hapus tingkat 4 bila tidak diperlukan. Dropdown bawah nonaktif sebelum tingkat atas dipilih. Tulis arti singkatan seperti MP
- Saat HS CODE dipilih, BM · PPN · PPH diusulkan otomatis (terhubung master tarif isu 57), bila diubah manual catat alasan · riwayat
- DESCRIPTION dibuat otomatis dari gabungan BRAND + SIZE + jenis, lalu dapat diubah',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '81' OR title_ko = '81. Products 카테고리 · HS CODE · 품명 — 단계 라벨 부재 · 세율 및 명칭 수기 입력'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-08 개선요청서(SEO, 총괄팀) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '81' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 82 ──
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
  '82', '82. Finance > Payment Voucher(지급요청서) 화면 부재 — 회계 지급 청구 전산화', '82. Finance > Layar Payment Voucher Belum Ada — Digitalisasi Klaim Pembayaran ke Accounting',
  'Finance', 'Payment Voucher', 'Finance > Payment Voucher', '신규기능 / Fitur Baru', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '구매 / Pembelian', DATE '2026-10-06', '회계 지급 청구(Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice 등)를 엑셀 Payment Request Form으로 작성 · 결재 중. 시스템 기능 없음', 'Klaim pembayaran ke accounting (Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice, dll.) masih dibuat · disetujui dengan Payment Request Form Excel. Belum ada fitur di sistem',
  'Payment Voucher 등록(유형 · 계정 라인 · 증빙 · 수취 계좌) → 차대 일치 검증 → 결재선 승인 → 조회 · 출력 가능', 'Payment Voucher dapat diinput (jenis · baris akun · bukti · rekening penerima) → validasi debit = kredit → persetujuan sesuai jalur → dapat dilihat · dicetak', '58 · 59 · 63 · 83', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 회계 지급 청구용 Payment Voucher 기능 없음. 현재 엑셀 양식(Payment Request Form)으로 작성 · 결재
- 청구 유형(요청자 기재) : Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice 등
- 현행 양식 구성 : 회사 · 부서 · 요청자 · 발행일 · 지급요청일 / 계정과목(Account Name) · P&L Code · 차변(Expense) · 대변(Payment Method) / 적요 · 수취 은행정보 / 부서 · 회계 결재란(Prepared · Checked 1 · Checked 2 · Approved)
- 캡처 예시 : 웹사이트 유지보수비 청구 IDR 647,500 = Service Fees 583,333 + VAT 64,167. PPh 23 원천징수 11,667 차감 후 지급 635,833
- 관련 이슈 : 58(결재선 필수화 · 금액 구간별 자동 지정), 59(수입 대금 Payment Plan), 63(Finance 대메뉴)
- [2026-10-06 현지 사용자 개선요청 — Lia(Purchasing Lokal)] 요청 우선순위 B(오픈 後). 원문 : Payment Voucher untuk claim pembayaran ke accounting', '- 회계 지급 청구용 Payment Voucher 기능 없음. 현재 엑셀 양식(Payment Request Form)으로 작성 · 결재
- 청구 유형(요청자 기재) : Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice 등
- 현행 양식 구성 : 회사 · 부서 · 요청자 · 발행일 · 지급요청일 / 계정과목(Account Name) · P&L Code · 차변(Expense) · 대변(Payment Method) / 적요 · 수취 은행정보 / 부서 · 회계 결재란(Prepared · Checked 1 · Checked 2 · Approved)
- 캡처 예시 : 웹사이트 유지보수비 청구 IDR 647,500 = Service Fees 583,333 + VAT 64,167. PPh 23 원천징수 11,667 차감 후 지급 635,833
- 관련 이슈 : 58(결재선 필수화 · 금액 구간별 자동 지정), 59(수입 대금 Payment Plan), 63(Finance 대메뉴)
- [2026-10-06 현지 사용자 개선요청 — Lia(Purchasing Lokal)] 요청 우선순위 B(오픈 後). 원문 : Payment Voucher untuk claim pembayaran ke accounting', '- Belum ada fitur Payment Voucher untuk klaim pembayaran ke accounting. Saat ini dibuat · disetujui dengan form Excel (Payment Request Form)
- Jenis klaim (ditulis pemohon) : Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice, dll.
- Susunan form saat ini : perusahaan · departemen · pemohon · tanggal terbit · tanggal permintaan bayar / Account Name · P&L Code · debit (Expense) · kredit (Payment Method) / keterangan · info bank penerima / kolom persetujuan departemen · accounting (Prepared · Checked 1 · Checked 2 · Approved)
- Contoh capture : klaim biaya maintenance website IDR 647,500 = Service Fees 583,333 + VAT 64,167. Setelah dipotong PPh 23 11,667, dibayar 635,833
- Isu terkait : 58 (jalur persetujuan wajib · otomatis per rentang nilai), 59 (Payment Plan pembayaran impor), 63 (menu utama Finance)
- [Usulan perbaikan pengguna lokal 2026-10-06 — Lia (Purchasing Lokal)] Prioritas permintaan B (setelah go-live). Teks asli : Payment Voucher untuk claim pembayaran ke accounting',
  '- Finance 하위에 Payment Voucher 화면 신설 : 현행 양식 항목(헤더 · 계정 라인 · 적요 · 수취 계좌) 그대로 전산화
- 청구 유형 코드화(Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice · 기타), 유형별 필수 증빙 첨부
- 저장 시 차변 합계 = 대변 합계 검증, PPN · PPh 원천징수 계정 분개 자동 제안
- 결재선은 이슈 58 기준 적용. AP Invoice 유형은 Receipt · 공급사 인보이스와 연결', '- Finance 하위에 Payment Voucher 화면 신설 : 현행 양식 항목(헤더 · 계정 라인 · 적요 · 수취 계좌) 그대로 전산화
- 청구 유형 코드화(Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice · 기타), 유형별 필수 증빙 첨부
- 저장 시 차변 합계 = 대변 합계 검증, PPN · PPh 원천징수 계정 분개 자동 제안
- 결재선은 이슈 58 기준 적용. AP Invoice 유형은 Receipt · 공급사 인보이스와 연결', '- Buat layar Payment Voucher di bawah Finance : item form saat ini (header · baris akun · keterangan · rekening penerima) didigitalkan apa adanya
- Kodekan jenis klaim (Claim Driver · Petty Cash · Entertainment · Welfare · AP Invoice · lainnya), lampiran bukti wajib per jenis
- Saat simpan validasi total debit = total kredit, usulkan jurnal otomatis untuk akun PPN · PPh potong
- Jalur persetujuan mengikuti isu 58. Jenis AP Invoice dihubungkan dengan Receipt · invoice pemasok',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '82' OR title_ko = '82. Finance > Payment Voucher(지급요청서) 화면 부재 — 회계 지급 청구 전산화'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Lia, Purchasing Lokal) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-06 개선요청서(Lia, Purchasing Lokal) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Lia, Purchasing Lokal) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '82' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 83 ──
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
  '83', '83. Finance > Budget Plan(예산계획) 화면 부재 — 월 · 주차별 비용 계획 및 실적 대비', '83. Finance > Layar Budget Plan Belum Ada — Rencana Biaya Bulanan · Mingguan dan Realisasinya',
  'Finance', 'Budget Plan', 'Finance > Budget Plan', '신규기능 / Fitur Baru', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '구매 / Pembelian', DATE '2026-10-06', '예산계획을 스프레드시트(BUDGET PLAN 2026(NEW), 월 · 주차 · 통화별 시트)로 관리 중. 시스템 기능 없음 — Account Payable · 사무실 운영비 · 판촉물 비용 등 반영 요청', 'Budget plan dikelola di spreadsheet (BUDGET PLAN 2026(NEW), sheet per bulan · minggu · mata uang). Belum ada fitur di sistem — diminta mencakup Account Payable · biaya operasional kantor · biaya material promosi, dll.',
  '비용 항목 × 월 · 주차 예산 등록(IDR · USD), Payment Voucher · Payment Plan 실적 자동 집계로 예산 대비 실적 · 잔액 조회, 엑셀 업로드 · 다운로드', 'Anggaran per item biaya × bulan · minggu dapat diinput (IDR · USD), realisasi Payment Voucher · Payment Plan teragregasi otomatis untuk melihat anggaran vs realisasi · sisa, upload · download Excel', '59 · 77 · 82', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 예산계획을 스프레드시트(BUDGET PLAN 2026(NEW))로 관리 중이며 시스템 기능 없음
- 현행 시트 구성 : 3개월 요약(Summary Budget Plan 3 Month) · 월별 USD / IDR 시트 분리, 거래처 · 비용 항목(PIB · Forwarding · 창고 임차 · Marketing 등) × 주차(W.1~W.5) 금액, 월 합계
- 요청 대상 항목(요청자 기재) : Account Payable · 사무실 운영비 · 판촉물 비용 등
- [2026-10-06 현지 사용자 개선요청 — Lia(Purchasing Lokal)] 요청 우선순위 B(오픈 後). 원문 : Mohon bantu update untuk budget plan : Biaya Account Payable / Biaya Operasional Kantor / Biaya Material Promosi / Etc', '- 예산계획을 스프레드시트(BUDGET PLAN 2026(NEW))로 관리 중이며 시스템 기능 없음
- 현행 시트 구성 : 3개월 요약(Summary Budget Plan 3 Month) · 월별 USD / IDR 시트 분리, 거래처 · 비용 항목(PIB · Forwarding · 창고 임차 · Marketing 등) × 주차(W.1~W.5) 금액, 월 합계
- 요청 대상 항목(요청자 기재) : Account Payable · 사무실 운영비 · 판촉물 비용 등
- [2026-10-06 현지 사용자 개선요청 — Lia(Purchasing Lokal)] 요청 우선순위 B(오픈 後). 원문 : Mohon bantu update untuk budget plan : Biaya Account Payable / Biaya Operasional Kantor / Biaya Material Promosi / Etc', '- Budget plan dikelola di spreadsheet (BUDGET PLAN 2026(NEW)) dan belum ada fitur di sistem
- Susunan sheet saat ini : ringkasan 3 bulan (Summary Budget Plan 3 Month) · sheet USD / IDR per bulan terpisah, nilai per pemasok · item biaya (PIB · Forwarding · sewa gudang · Marketing, dll.) × minggu (W.1~W.5), total bulanan
- Item yang diminta (ditulis pemohon) : Account Payable · biaya operasional kantor · biaya material promosi, dll.
- [Usulan perbaikan pengguna lokal 2026-10-06 — Lia (Purchasing Lokal)] Prioritas permintaan B (setelah go-live). Teks asli : Mohon bantu update untuk budget plan : Biaya Account Payable / Biaya Operasional Kantor / Biaya Material Promosi / Etc',
  '- Finance 하위에 Budget Plan 화면 신설 : 비용 항목 × 월 · 주차 매트릭스, 통화(IDR · USD) 구분
- 실적 연계 : Payment Voucher(이슈 82) · Payment Plan(이슈 59) 지급 실적을 같은 항목 코드로 집계해 예산 대비 실적 · 잔액 표시
- 엑셀 업로드 · 다운로드 지원으로 현행 시트 이관
- 비용 항목 코드 체계는 재무(Komang)와 사전 확정', '- Finance 하위에 Budget Plan 화면 신설 : 비용 항목 × 월 · 주차 매트릭스, 통화(IDR · USD) 구분
- 실적 연계 : Payment Voucher(이슈 82) · Payment Plan(이슈 59) 지급 실적을 같은 항목 코드로 집계해 예산 대비 실적 · 잔액 표시
- 엑셀 업로드 · 다운로드 지원으로 현행 시트 이관
- 비용 항목 코드 체계는 재무(Komang)와 사전 확정', '- Buat layar Budget Plan di bawah Finance : matriks item biaya × bulan · minggu, dibedakan mata uang (IDR · USD)
- Hubungkan realisasi : realisasi pembayaran Payment Voucher (isu 82) · Payment Plan (isu 59) diagregasi dengan kode item yang sama untuk menampilkan anggaran vs realisasi · sisa
- Dukung upload · download Excel untuk migrasi sheet saat ini
- Sistem kode item biaya ditetapkan lebih dulu bersama Finance (Komang)',
  false, '261008-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '83' OR title_ko = '83. Finance > Budget Plan(예산계획) 화면 부재 — 월 · 주차별 비용 계획 및 실적 대비'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Lia, Purchasing Lokal) · dimuat di dokumen usulan 261008', '최초 접수 — 2026-10-06 개선요청서(Lia, Purchasing Lokal) · 261008 개선요청서 수록', 'Diterima pertama kali — Formulir Usulan Perbaikan 2026-10-06 (Lia, Purchasing Lokal) · dimuat di dokumen usulan 261008', i.it_status, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '83' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc');

-- ── 확인 ─────────────────────────────────────────────────────────────────────
-- ① 신규 75~83 (기대 : 9행, Open · PENDING · 미회신)
SELECT issue_no, title_ko, priority, go_live_category, it_pic, it_status, it_decision, verification_result
  FROM public.csr_issues WHERE issue_no IN ('75','76','77','78','79','80','81','82','83') AND NOT is_archived ORDER BY issue_no::int;
-- ② 최초 접수 검증 이력 (기대 : 9행)
SELECT i.issue_no, v.verified_on, v.result, v.note_ko
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE v.created_by = '261008-doc' ORDER BY i.issue_no::int;
-- ③ 번호 중복 점검 (기대 : 0행)
SELECT issue_no, count(*) FROM public.csr_issues WHERE NOT is_archived GROUP BY issue_no HAVING count(*) > 1;
