-- =============================================================================
-- CSR 검증 이력 추가 (2026-10-08) — 038 ~ 040 적용 후 실행. 달러 인용 없음. 재실행 안전.
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--
--   입력
--     · 실서버(asm.ascendotyre.com) 화면 점검 2026-10-08 19:xx WIB, 계정 Jo (서종환 수행)
--     · 점검 대상 : IT상태 COMPLETED 이면서 현업검증이 ACCEPTED 가 아닌 17건
--     · 정합성 검증리포트 v3.7_261008 과 짝으로 사용
--
--   1. 검증 이력(csr_verifications) 2026-10-08 — 1차 14건 + 2차 15건 = 29건 입력
--      Completed 부적정(REJECTED) : 03 · 07 · 08 · 13 · 22 · 50
--      미조치(NOT APPLIED)         : 12 · 19
--      부분조치(PARTIAL)           : 18 · 35 · 51 · 60 · 74
--      미검증 유지(PENDING)        : 14
--   2. 입력하지 않은 건 : 45 · 46 · 47 · 06 · 17 · 23 · 25 · 31 · 34 · 38 · 43 · 49 · 70 · 73 · 76 — 전표 생성 · 확정 · 창고 계정 필요로 점검 불가(신규 증거 없음)
--   3. 017 트리거가 헤더(현업검증 · 최종검증일)를 동기화함. IT상태(it_status) · IT부서 회신은 변경하지 않음(총괄 지시 2026-10-08)
--   4. note = note_ko 동일, note_id 는 Claude 번역 — 검수 서종환
-- =============================================================================

SELECT set_config('csr.actor', 'migration:041 (실서버 검증 1008 · v3.7)', false);

-- ── 1. 검증 이력 2026-10-08 (실서버 화면 확인) ─────────────────────────────────────
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', 'PO 목록 AMOUNT 헤더에 「(excl. PPN)」 표기 없음(헤더 = # · PO NO. · SUPPLIER · QTY · AMOUNT · ETA · REMARK · STATUS · HANDLER). 10-02 지적(PO↔PPC 수량·금액 대사 기능 부재) 변동 없음 — 수용기준 「AMOUNT = DPP 통일 + 헤더 표기」 미충족. PPC 목록은 이번 점검 범위 아님', 'PO 목록 AMOUNT 헤더에 「(excl. PPN)」 표기 없음(헤더 = # · PO NO. · SUPPLIER · QTY · AMOUNT · ETA · REMARK · STATUS · HANDLER). 10-02 지적(PO↔PPC 수량·금액 대사 기능 부재) 변동 없음 — 수용기준 「AMOUNT = DPP 통일 + 헤더 표기」 미충족. PPC 목록은 이번 점검 범위 아님', 'Header kolom AMOUNT daftar PO belum memuat keterangan 「(excl. PPN)」 (header = # · PO NO. · SUPPLIER · QTY · AMOUNT · ETA · REMARK · STATUS · HANDLER). Temuan 02-10 (fitur rekonsiliasi qty·nilai PO↔PPC belum ada) tidak berubah — kriteria 「AMOUNT = DPP seragam + keterangan di header」 belum terpenuhi. Daftar PPC tidak termasuk cakupan pengecekan ini', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '03' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', 'Import Cost 상세(SHP-20260923-005, ESTIMATED) Total Import Cost IDR 109,463,165 = Tax Total 82,097,374(PPN 66,894,156 · PPh 15,203,217 포함) + Etc Total 27,365,791 — IT 회신 「PPN · PPH 제외 표시」 미반영. 목록 COST AMOUNT IDR 27,365,791(Etc만)과 상세 Total 집계 기준 상이. Cash-out / Landed Cost 분리 표기 없음', 'Import Cost 상세(SHP-20260923-005, ESTIMATED) Total Import Cost IDR 109,463,165 = Tax Total 82,097,374(PPN 66,894,156 · PPh 15,203,217 포함) + Etc Total 27,365,791 — IT 회신 「PPN · PPH 제외 표시」 미반영. 목록 COST AMOUNT IDR 27,365,791(Etc만)과 상세 Total 집계 기준 상이. Cash-out / Landed Cost 분리 표기 없음', 'Detail Import Cost (SHP-20260923-005, ESTIMATED) Total Import Cost IDR 109,463,165 = Tax Total 82,097,374 (termasuk PPN 66,894,156 · PPh 15,203,217) + Etc Total 27,365,791 — balasan IT 「PPN · PPH tidak ditampilkan」 belum diterapkan. COST AMOUNT di daftar IDR 27,365,791 (hanya Etc) berbeda basis dengan Total di detail. Tampilan Cash-out / Landed Cost belum dipisah', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '07' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', 'Import Cost 상세(SHP-20260923-005) COST ITEMS 11행(선적 단위)만 표시, SKU별 Landed_unit_cost 열 · 탭 없음, 배부 기준(CIF/중량/수량) 표기 없음. 목록 2건(SHP-20260928-006 · SHP-20260923-005). 09-10 판정 유지 — IT상태 ONGOING 환원 요청 유지', 'Import Cost 상세(SHP-20260923-005) COST ITEMS 11행(선적 단위)만 표시, SKU별 Landed_unit_cost 열 · 탭 없음, 배부 기준(CIF/중량/수량) 표기 없음. 목록 2건(SHP-20260928-006 · SHP-20260923-005). 09-10 판정 유지 — IT상태 ONGOING 환원 요청 유지', 'Detail Import Cost (SHP-20260923-005) hanya menampilkan 11 baris COST ITEMS per pengiriman; tidak ada kolom/tab Landed_unit_cost per SKU dan tidak ada keterangan dasar alokasi (CIF/berat/qty). Daftar berisi 2 data (SHP-20260928-006 · SHP-20260923-005). Penilaian 10-09 dipertahankan — permintaan mengembalikan status IT ke ONGOING tetap berlaku', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '08' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', '견적 상세(quotation/860, QT-20261008-116): Sub-Total 45,810,900 − Discount 1,604,059 = DPP 44,206,841, PPN 4,862,753, Truncation(1,000↓) 594, Total(incl. PPN) 49,069,000 — 절사가 DPP+PPN 합계(49,069,594) 단계에 적용됨. SO 상세(sales-order/835, OD-20261008-129)도 Truncation 595 · Total 49.069.000 동일 방식. 수용기준(DPP 절사 후 PPN = 절사 DPP × 11%) 미충족', '견적 상세(quotation/860, QT-20261008-116): Sub-Total 45,810,900 − Discount 1,604,059 = DPP 44,206,841, PPN 4,862,753, Truncation(1,000↓) 594, Total(incl. PPN) 49,069,000 — 절사가 DPP+PPN 합계(49,069,594) 단계에 적용됨. SO 상세(sales-order/835, OD-20261008-129)도 Truncation 595 · Total 49.069.000 동일 방식. 수용기준(DPP 절사 후 PPN = 절사 DPP × 11%) 미충족', 'Detail penawaran (quotation/860, QT-20261008-116): Sub-Total 45,810,900 − Discount 1,604,059 = DPP 44,206,841, PPN 4,862,753, Truncation (1,000↓) 594, Total (incl. PPN) 49,069,000 — pembulatan diterapkan pada total DPP+PPN (49,069,594). Detail SO (sales-order/835, OD-20261008-129) juga Truncation 595 · Total 49.069.000 dengan cara yang sama. Kriteria (pembulatan di DPP, PPN = DPP terbulat × 11%) belum terpenuhi', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '12' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', 'SO · DN · DO 목록 AMOUNT 소수점 표기는 해소(각 15건 확인, 소수 표기 0건). 다만 목록 금액과 상세 Total 불일치 지속 — OD-20261008-131 목록 IDR 6,279,998 vs 상세 6.279.000 · OD-20261008-130 4,039,998 vs 4.039.000 · OD-20261008-129 49,069,595 vs 49.069.000 · DN-20261008-105 125,760,991 vs 125.760.000(절사 전 금액이 목록에 표시). 수용기준(SO · DN · Invoice 금액 항상 일치) 미충족', 'SO · DN · DO 목록 AMOUNT 소수점 표기는 해소(각 15건 확인, 소수 표기 0건). 다만 목록 금액과 상세 Total 불일치 지속 — OD-20261008-131 목록 IDR 6,279,998 vs 상세 6.279.000 · OD-20261008-130 4,039,998 vs 4.039.000 · OD-20261008-129 49,069,595 vs 49.069.000 · DN-20261008-105 125,760,991 vs 125.760.000(절사 전 금액이 목록에 표시). 수용기준(SO · DN · Invoice 금액 항상 일치) 미충족', 'Angka desimal pada kolom AMOUNT daftar SO · DN · DO sudah hilang (masing-masing 15 data diperiksa, 0 data berdesimal). Namun nilai di daftar masih berbeda dengan Total di detail — OD-20261008-131 daftar IDR 6,279,998 vs detail 6.279.000 · OD-20261008-130 4,039,998 vs 4.039.000 · OD-20261008-129 49,069,595 vs 49.069.000 · DN-20261008-105 125,760,991 vs 125.760.000 (nilai sebelum pembulatan tampil di daftar). Kriteria (nilai SO · DN · Invoice selalu sama) belum terpenuhi', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '13' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '월마감 Summary 1건(202608, 작업일 2026-09-08 19:21:49): OPEN QTY 151,345 = CLOSING QTY 151,345, RCPT · SHIP · RTN · ADJ QTY 모두 0, OPEN AMT = CLOSE AMT 98,034,669,005. 8월 입 · 출고 집계 0 — 8/31 실사 기준 초기재고 적재에 따른 결과인지 IT 확인 필요. 7월 마감 행 없음, 7월 마감 미반영 원인 회신 미확인', '월마감 Summary 1건(202608, 작업일 2026-09-08 19:21:49): OPEN QTY 151,345 = CLOSING QTY 151,345, RCPT · SHIP · RTN · ADJ QTY 모두 0, OPEN AMT = CLOSE AMT 98,034,669,005. 8월 입 · 출고 집계 0 — 8/31 실사 기준 초기재고 적재에 따른 결과인지 IT 확인 필요. 7월 마감 행 없음, 7월 마감 미반영 원인 회신 미확인', 'Ringkasan penutupan bulanan 1 data (202608, tanggal kerja 2026-09-08 19:21:49): OPEN QTY 151,345 = CLOSING QTY 151,345, RCPT · SHIP · RTN · ADJ QTY semuanya 0, OPEN AMT = CLOSE AMT 98,034,669,005. Agregasi masuk/keluar Agustus = 0 — perlu konfirmasi IT apakah akibat pemuatan stok awal berdasarkan stock opname 31/8. Tidak ada baris penutupan Juli; balasan penyebab penutupan Juli belum diterima', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '14' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', 'Partners > Suppliers 18건 중 JK TYRE & INDUSTIRES LTD COUNTRY = CHINA 잔존(인도 소재, 09-18 지적 미정정), 공급사명 오타(INDUSTIRES) 잔존. 공급사 등록 화면(vendor/create) Country 입력란은 텍스트 자유입력 — 드롭다운 · 코드화 미적용', 'Partners > Suppliers 18건 중 JK TYRE & INDUSTIRES LTD COUNTRY = CHINA 잔존(인도 소재, 09-18 지적 미정정), 공급사명 오타(INDUSTIRES) 잔존. 공급사 등록 화면(vendor/create) Country 입력란은 텍스트 자유입력 — 드롭다운 · 코드화 미적용', 'Dari 18 data Partners > Suppliers, JK TYRE & INDUSTIRES LTD masih tercatat COUNTRY = CHINA (berlokasi di India, temuan 18-09 belum dikoreksi) dan salah ketik nama (INDUSTIRES) masih ada. Kolom Country di layar tambah pemasok (vendor/create) masih input teks bebas — dropdown/kodefikasi belum diterapkan', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '18' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Master Data > Products(1,310건): 3번 행 「14.00-24-28PR?55MM thick) + O-ring 7mm x1 +24 inch O-ring」 인코딩 오류 규격 잔존, 1페이지 BUY · SELL PRICE 0.00 다수, 재고 목록 카테고리 필터 선택지 중복(Category 2 LT · TB · OTR · IND · AGR 반복) 유지', 'Master Data > Products(1,310건): 3번 행 「14.00-24-28PR?55MM thick) + O-ring 7mm x1 +24 inch O-ring」 인코딩 오류 규격 잔존, 1페이지 BUY · SELL PRICE 0.00 다수, 재고 목록 카테고리 필터 선택지 중복(Category 2 LT · TB · OTR · IND · AGR 반복) 유지', 'Master Data > Products (1,310 data): baris ke-3 spesifikasi rusak encoding 「14.00-24-28PR?55MM thick) + O-ring 7mm x1 +24 inch O-ring」 masih ada, BUY · SELL PRICE 0.00 banyak di halaman 1, pilihan filter kategori daftar stok masih duplikat (Category 2 LT · TB · OTR · IND · AGR berulang)', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '19' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', 'PO 목록 AMOUNT 영미식(IDR 37,616,266)이나 PO 상세(AJ-20261001-006) Subtotal 307.140.724 · Grand Total 340.926.204, PO 신규 단가 입력 1234567 → 1.234.567, SO 상세 단가 228.829 등 인니식 유지. Import Cost 상세는 영미식(IDR 109,463,165) — 화면 간 혼재 지속', 'PO 목록 AMOUNT 영미식(IDR 37,616,266)이나 PO 상세(AJ-20261001-006) Subtotal 307.140.724 · Grand Total 340.926.204, PO 신규 단가 입력 1234567 → 1.234.567, SO 상세 단가 228.829 등 인니식 유지. Import Cost 상세는 영미식(IDR 109,463,165) — 화면 간 혼재 지속', 'AMOUNT daftar PO memakai format Anglo (IDR 37,616,266), tetapi detail PO (AJ-20261001-006) Subtotal 307.140.724 · Grand Total 340.926.204, input harga satuan PO baru 1234567 → 1.234.567, dan harga satuan detail SO 228.829 tetap format Indonesia. Detail Import Cost memakai format Anglo (IDR 109,463,165) — format masih campur antar layar', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '22' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', 'SO 상세(sales-order/835): 상태 DRAFT + Confirm · Delete · Save 버튼으로 Draft/Confirm 구조 확인, 품목 열에 PO QTY · QTY · REM QTY · INV QTY 표시. Release 기능 · 가용/확약 구분 표시 없음. 확약 합계 > 실재고 시 저장 경고는 실데이터 생성 방지를 위해 미실행', 'SO 상세(sales-order/835): 상태 DRAFT + Confirm · Delete · Save 버튼으로 Draft/Confirm 구조 확인, 품목 열에 PO QTY · QTY · REM QTY · INV QTY 표시. Release 기능 · 가용/확약 구분 표시 없음. 확약 합계 > 실재고 시 저장 경고는 실데이터 생성 방지를 위해 미실행', 'Detail SO (sales-order/835): status DRAFT dengan tombol Confirm · Delete · Save menunjukkan struktur Draft/Confirm; kolom item menampilkan PO QTY · QTY · REM QTY · INV QTY. Fitur Release dan pemisahan tersedia/komitmen tidak terlihat. Peringatan saat total komitmen > stok riil tidak diuji agar tidak membuat data nyata', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '35' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', 'Inventory List Excel(전체 조건) 다운로드: 파일명 Inventory_2026-10-08.xlsx — 창고 · 기간 미표기. 시트(Inventory) 1행이 곧바로 헤더(No. · Warehouse · Product · ArticleNo · ReceiptDate · TotalQty · ReservedQty · AvailableQty · UnitCost · Category1~4) — 조회조건 · 추출일시 · 추출자 행 없음. 헤더 오타 「Categroy2」 잔존', 'Inventory List Excel(전체 조건) 다운로드: 파일명 Inventory_2026-10-08.xlsx — 창고 · 기간 미표기. 시트(Inventory) 1행이 곧바로 헤더(No. · Warehouse · Product · ArticleNo · ReceiptDate · TotalQty · ReservedQty · AvailableQty · UnitCost · Category1~4) — 조회조건 · 추출일시 · 추출자 행 없음. 헤더 오타 「Categroy2」 잔존', 'Unduhan Excel Inventory List (semua kondisi): nama file Inventory_2026-10-08.xlsx — gudang dan periode tidak tercantum. Baris pertama sheet (Inventory) langsung header (No. · Warehouse · Product · ArticleNo · ReceiptDate · TotalQty · ReservedQty · AvailableQty · UnitCost · Category1~4) — tidak ada baris kondisi pencarian · waktu ekstraksi · pengekstrak. Salah ketik header 「Categroy2」 masih ada', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '50' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', '창고팀 엑셀 등 비교 자료가 없어 수량 대사 미수행. Receipt 신규(LOCAL) 대상 목록에 테스트 전표 DF-20260901-001(TEST-CAPTURE 2026-09-01 TEMPORARY, PREPARING 400본) 잔존 — 수용기준 「테스트 전표 삭제」 미충족', '창고팀 엑셀 등 비교 자료가 없어 수량 대사 미수행. Receipt 신규(LOCAL) 대상 목록에 테스트 전표 DF-20260901-001(TEST-CAPTURE 2026-09-01 TEMPORARY, PREPARING 400본) 잔존 — 수용기준 「테스트 전표 삭제」 미충족', 'Rekonsiliasi qty belum dilakukan karena tidak ada data pembanding (Excel tim gudang). Pada daftar target Receipt baru (LOCAL) masih ada dokumen uji DF-20260901-001 (TEST-CAPTURE 2026-09-01 TEMPORARY, PREPARING 400 pcs) — kriteria 「dokumen uji dihapus」 belum terpenuhi', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '51' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', '사이드바 확인: 「PURCHASE PO」 · 「RECEIPT」 명칭 미변경 — 미반영 2건(Purchase Order · Purchase Receipt) 유지. 상단 메뉴 그룹명은 「Purchase」. 다국어 리소스 관리 여부는 화면에서 확인 불가', '사이드바 확인: 「PURCHASE PO」 · 「RECEIPT」 명칭 미변경 — 미반영 2건(Purchase Order · Purchase Receipt) 유지. 상단 메뉴 그룹명은 「Purchase」. 다국어 리소스 관리 여부는 화면에서 확인 불가', 'Pengecekan sidebar: nama 「PURCHASE PO」 dan 「RECEIPT」 belum berubah — 2 butir belum diterapkan (Purchase Order · Purchase Receipt) tetap. Nama grup menu atas 「Purchase」. Pengelolaan resource multi-bahasa tidak dapat dipastikan dari layar', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '60' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', '글꼴 Noto Sans 확인(PO 상세 텍스트 요소 전부). 글자 크기 11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px 9종 혼재 유지(10-02와 동일)', '글꼴 Noto Sans 확인(PO 상세 텍스트 요소 전부). 글자 크기 11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px 9종 혼재 유지(10-02와 동일)', 'Font Noto Sans terkonfirmasi (seluruh elemen teks detail PO). Ukuran huruf masih campur 9 jenis: 11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px (sama dengan 02-10)', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '74' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');

-- ── 2. 검증 이력 2026-10-08 — 2차 점검(Completed 17건 외 58건 중 화면 판정 가능 건) ─────────────
--      조정 : 10 ACCEPTED→PARTIAL · 15 ACCEPTED→REJECTED · 44 ACCEPTED→PARTIAL · 32 ACCEPTED→PARTIAL (헤더 하향, 사유는 note)
--      유지 : 16 · 21 · 33 · 69 NOT APPLIED / 58 PARTIAL / 62 PENDING / 78~81 · 75 PENDING→NOT APPLIED(미반영 확인)
--      메뉴 부재 건(52 · 53 · 54 · 55 · 56 · 57 · 59 · 63~68 · 77 · 82 · 83)은 기존 NOT APPLIED 그대로 — 행 추가 없음
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', 'Import Cost 목록 · 상세(import-cost/4 · /5)에 적용 환율(Kurs KMK) · 고시 주차 미표시. KMK 환율은 Customs Clearance(SHP-20260928-006 EXCHANGE RATE · EXCHANGE DATE)에만 있음. 10-02 ACCEPTED는 「수기 입력 가능」 기준 — 수용기준(Import Cost 화면 표시)과 불일치하여 PARTIAL 로 조정', 'Import Cost 목록 · 상세(import-cost/4 · /5)에 적용 환율(Kurs KMK) · 고시 주차 미표시. KMK 환율은 Customs Clearance(SHP-20260928-006 EXCHANGE RATE · EXCHANGE DATE)에만 있음. 10-02 ACCEPTED는 「수기 입력 가능」 기준 — 수용기준(Import Cost 화면 표시)과 불일치하여 PARTIAL 로 조정', 'Daftar dan detail Import Cost (import-cost/4 · /5) belum menampilkan kurs KMK dan minggu penetapan. Kurs KMK hanya ada di Customs Clearance (SHP-20260928-006 EXCHANGE RATE · EXCHANGE DATE). ACCEPTED 02-10 berdasarkan 「bisa input manual」 — tidak sesuai kriteria (tampil di layar Import Cost), disesuaikan menjadi PARTIAL', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '10' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'REJECTED', '날짜 형식 혼재 지속 : Receipt 상세 Receipt Date 2026-10-06 / PO Info Po Date 09/07/2026 / GRPO 출력물 Receipt Date 06-10-2026 · Posting Date 07.10.2026 · Due Date 30-12-2026. 재고 목록 기간 입력란은 브라우저 기본 date 입력(언어 종속) 유지', '날짜 형식 혼재 지속 : Receipt 상세 Receipt Date 2026-10-06 / PO Info Po Date 09/07/2026 / GRPO 출력물 Receipt Date 06-10-2026 · Posting Date 07.10.2026 · Due Date 30-12-2026. 재고 목록 기간 입력란은 브라우저 기본 date 입력(언어 종속) 유지', 'Format tanggal masih campur: detail Receipt Receipt Date 2026-10-06 / PO Info Po Date 09/07/2026 / cetakan GRPO Receipt Date 06-10-2026 · Posting Date 07.10.2026 · Due Date 30-12-2026. Input periode daftar stok masih memakai input date bawaan browser (tergantung bahasa)', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '15' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', '고객 상세(customer/519) 탭 = ADDRESS · CUSTOMER PIC · PAYMENT CURRENCY · DELIVERY LOCATION · ASCENDO SALES PERSON, 헤더 = SAP CODE · TYPE · NPWP · PHONE · DELIVERY TERM · DC RATE — 여신한도 · 여신등급 · 승인일 · 만료일 필드 없음', '고객 상세(customer/519) 탭 = ADDRESS · CUSTOMER PIC · PAYMENT CURRENCY · DELIVERY LOCATION · ASCENDO SALES PERSON, 헤더 = SAP CODE · TYPE · NPWP · PHONE · DELIVERY TERM · DC RATE — 여신한도 · 여신등급 · 승인일 · 만료일 필드 없음', 'Tab detail pelanggan (customer/519) = ADDRESS · CUSTOMER PIC · PAYMENT CURRENCY · DELIVERY LOCATION · ASCENDO SALES PERSON, header = SAP CODE · TYPE · NPWP · PHONE · DELIVERY TERM · DC RATE — tidak ada kolom limit kredit · peringkat · tanggal persetujuan · tanggal berakhir', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '16' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '고객 상세(customer/519)에 「법무 · 여신」 탭 없음 — 10개 항목(고객 유형 · 계약서 · 담보 · 등급 · 결제조건 · 회수 상태 · 여신한도 등) 미등록. 16 과 동일 화면', '고객 상세(customer/519)에 「법무 · 여신」 탭 없음 — 10개 항목(고객 유형 · 계약서 · 담보 · 등급 · 결제조건 · 회수 상태 · 여신한도 등) 미등록. 16 과 동일 화면', 'Detail pelanggan (customer/519) belum memiliki tab 「Legal · Kredit」 — 10 butir (jenis pelanggan · kontrak · jaminan · peringkat · syarat bayar · status penagihan · limit kredit dll.) belum ada. Layar sama dengan 16', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '62' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Settings > Staff Directory 77명 전수 : DEPARTMENT 비표준값 20명 — SURABAYA 9 · GUDANG 5 · SEMARANG 4 · KARAWANG 1 · APARTEMENT 1 (지점명이 부서란에 입력). 표준 9종 외 값 잔존, 드롭다운 강제 미적용', 'Settings > Staff Directory 77명 전수 : DEPARTMENT 비표준값 20명 — SURABAYA 9 · GUDANG 5 · SEMARANG 4 · KARAWANG 1 · APARTEMENT 1 (지점명이 부서란에 입력). 표준 9종 외 값 잔존, 드롭다운 강제 미적용', 'Settings > Staff Directory 77 orang: nilai DEPARTMENT non-standar 20 orang — SURABAYA 9 · GUDANG 5 · SEMARANG 4 · KARAWANG 1 · APARTEMENT 1 (nama cabang diisi di kolom departemen). Nilai di luar 9 standar masih ada, dropdown wajib belum diterapkan', 'Ongoing', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '21' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', '견적 신규 품목 ASC 12.00R20TR179(원가 206,657) 단가 228,829 입력 → MARGIN 10% (206.657). DC RATE 10 입력 → DC AMT 22.883 생성되나 MARGIN 10% (206.657) 그대로, AMOUNT 228.829 도 할인 미반영(순단가 205,946 < 원가이므로 실제 마진 음수). 저장하지 않음', '견적 신규 품목 ASC 12.00R20TR179(원가 206,657) 단가 228,829 입력 → MARGIN 10% (206.657). DC RATE 10 입력 → DC AMT 22.883 생성되나 MARGIN 10% (206.657) 그대로, AMOUNT 228.829 도 할인 미반영(순단가 205,946 < 원가이므로 실제 마진 음수). 저장하지 않음', 'Item penawaran baru ASC 12.00R20TR179 (HPP 206,657) harga 228,829 → MARGIN 10% (206.657). Input DC RATE 10 → DC AMT 22.883 muncul tetapi MARGIN tetap 10% (206.657), AMOUNT 228.829 juga belum dikurangi diskon (harga bersih 205,946 < HPP, margin sebenarnya negatif). Tidak disimpan', 'Ongoing', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '33' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', 'GRPO 출력물(RCPT-20261006-010) : Surat Jalan 번호 R082-26-070302 가 하단 Remark 란 첫 줄에 출력됨. 상단 「Surat Jalan No. · Date」 라벨 행은 없음 — 수용기준(상단 라벨 행) 부분 충족', 'GRPO 출력물(RCPT-20261006-010) : Surat Jalan 번호 R082-26-070302 가 하단 Remark 란 첫 줄에 출력됨. 상단 「Surat Jalan No. · Date」 라벨 행은 없음 — 수용기준(상단 라벨 행) 부분 충족', 'Cetakan GRPO (RCPT-20261006-010): nomor Surat Jalan R082-26-070302 tercetak di baris pertama kolom Remark bagian bawah. Baris berlabel 「Surat Jalan No. · Date」 di bagian atas tidak ada — kriteria (baris berlabel di atas) terpenuhi sebagian', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '44' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', 'PO 상세(AJ-20261007-009, DRAFT) Approve 팝업 「Confirm Purchase Order」 : PREPARED BY(자동 JO SEGWON) · CHECKER 1 · CHECKER 2 · APPROVER 검색 선택 — 금액 구간별 자동 지정 · 필수 표시 · 결재 이력 조회 없음. 팝업은 Cancel 로 닫음(제출 안 함)', 'PO 상세(AJ-20261007-009, DRAFT) Approve 팝업 「Confirm Purchase Order」 : PREPARED BY(자동 JO SEGWON) · CHECKER 1 · CHECKER 2 · APPROVER 검색 선택 — 금액 구간별 자동 지정 · 필수 표시 · 결재 이력 조회 없음. 팝업은 Cancel 로 닫음(제출 안 함)', 'Popup Approve 「Confirm Purchase Order」 detail PO (AJ-20261007-009, DRAFT): PREPARED BY (otomatis JO SEGWON) · CHECKER 1 · CHECKER 2 · APPROVER dipilih lewat pencarian — tidak ada penetapan otomatis per rentang nilai, tanda wajib, maupun riwayat persetujuan. Popup ditutup dengan Cancel (tidak dikirim)', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '58' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Products 신규(product-create) · 재고 목록 필터 CATEGORY 2 선택지 18개(LT · TB · OTR · IND · AGR 3회 반복), CATEGORY 3 34개(Radial/Bias 6회 · HD/STD 5회 · STD/MP 5회), CATEGORY 4 20개(TT/TL 8회) — 중복 그대로', 'Products 신규(product-create) · 재고 목록 필터 CATEGORY 2 선택지 18개(LT · TB · OTR · IND · AGR 3회 반복), CATEGORY 3 34개(Radial/Bias 6회 · HD/STD 5회 · STD/MP 5회), CATEGORY 4 20개(TT/TL 8회) — 중복 그대로', 'Tambah produk (product-create) · filter daftar stok: pilihan CATEGORY 2 ada 18 (LT · TB · OTR · IND · AGR berulang 3×), CATEGORY 3 ada 34 (Radial/Bias 6× · HD/STD 5× · STD/MP 5×), CATEGORY 4 ada 20 (TT/TL 8×) — duplikasi masih ada', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '69' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Products 신규(product-create) : 가격 항목 BUY PRICE · SELL PRICE · USD PRICE 3개 — 창고입고가(WH Price) 없음. TECHNICAL SPECIFICATION 25개 항목이 소그룹 구분 없이 1열 나열, 하단 CLOSE · SAVE 는 고정 바 아님', 'Products 신규(product-create) : 가격 항목 BUY PRICE · SELL PRICE · USD PRICE 3개 — 창고입고가(WH Price) 없음. TECHNICAL SPECIFICATION 25개 항목이 소그룹 구분 없이 1열 나열, 하단 CLOSE · SAVE 는 고정 바 아님', 'Tambah produk (product-create): kolom harga hanya BUY PRICE · SELL PRICE · USD PRICE — tidak ada harga masuk gudang (WH Price). 25 kolom TECHNICAL SPECIFICATION tersusun satu kolom tanpa sub-grup, tombol CLOSE · SAVE di bawah bukan bar tetap', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '78' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Products 신규 : CATEGORY 1 선택과 무관하게 타이어 전용 항목(PATTERN · PLY RATING · TD · RIM 등) 상시 표시, 가격 라벨에 통화 없음, 숫자 기본값 0. 중복 ARTICLE NO 즉시 경고는 저장 미실행으로 미확인', 'Products 신규 : CATEGORY 1 선택과 무관하게 타이어 전용 항목(PATTERN · PLY RATING · TD · RIM 등) 상시 표시, 가격 라벨에 통화 없음, 숫자 기본값 0. 중복 ARTICLE NO 즉시 경고는 저장 미실행으로 미확인', 'Tambah produk: kolom khusus ban (PATTERN · PLY RATING · TD · RIM dll.) selalu tampil terlepas dari CATEGORY 1, label harga tanpa mata uang, nilai angka default 0. Peringatan ARTICLE NO ganda tidak diuji karena tidak disimpan', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '79' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Products 신규 : HS CODE BM(%) · PPN(%) · PPH(%) 란 값 「0」(0.0% 형식 아님, 비활성), WEIGHT 란 단위(kg) 미표기, TYRE 40FT · LI_S · LI_D · TD · PRESS 약어 풀네임 · 단위 미병기', 'Products 신규 : HS CODE BM(%) · PPN(%) · PPH(%) 란 값 「0」(0.0% 형식 아님, 비활성), WEIGHT 란 단위(kg) 미표기, TYRE 40FT · LI_S · LI_D · TD · PRESS 약어 풀네임 · 단위 미병기', 'Tambah produk: kolom HS CODE BM(%) · PPN(%) · PPH(%) bernilai 「0」 (bukan format 0.0%, nonaktif), kolom WEIGHT tanpa satuan (kg), singkatan TYRE 40FT · LI_S · LI_D · TD · PRESS tanpa nama lengkap dan satuan', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '80' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'Products 신규 : CATEGORY 드롭다운 4개 라벨이 CATEGORY 1~4 로만 표시(단계 의미 라벨 없음), HS CODE 란 비활성 · 세율 자동 제안 없음, DESCRIPTION 수기 입력', 'Products 신규 : CATEGORY 드롭다운 4개 라벨이 CATEGORY 1~4 로만 표시(단계 의미 라벨 없음), HS CODE 란 비활성 · 세율 자동 제안 없음, DESCRIPTION 수기 입력', 'Tambah produk: 4 dropdown kategori hanya berlabel CATEGORY 1~4 (tanpa label makna tingkat), kolom HS CODE nonaktif · tidak ada saran tarif otomatis, DESCRIPTION diisi manual', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '81' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PARTIAL', 'DO 상세(delivery-order/768, DO-20261012-115, CONFIRMED) CUST. CONTACT 빈값, DO 출력물 Contact Person : None · Telp : None. DELV. LOCATION 2건 중 선택은 되나 해당 배송지 담당자 연동 안 됨 — 09-18 ACCEPTED 와 다른 표본에서 불일치', 'DO 상세(delivery-order/768, DO-20261012-115, CONFIRMED) CUST. CONTACT 빈값, DO 출력물 Contact Person : None · Telp : None. DELV. LOCATION 2건 중 선택은 되나 해당 배송지 담당자 연동 안 됨 — 09-18 ACCEPTED 와 다른 표본에서 불일치', 'Detail DO (delivery-order/768, DO-20261012-115, CONFIRMED) CUST. CONTACT kosong, cetakan DO Contact Person : None · Telp : None. DELV. LOCATION bisa dipilih dari 2 alamat tetapi kontak pelanggan alamat tersebut tidak terisi — berbeda dengan sampel ACCEPTED 18-09', 'Completed', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '32' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'NOT APPLIED', 'DO 출력물(DO-20261012-115) 라벨 「Payment Method : CASH COD」 유지 — 개선의견(Payment Term 으로 통일) 미반영. 결제조건 변경 → 재발행 대조는 실데이터 변경이 필요해 미실행', 'DO 출력물(DO-20261012-115) 라벨 「Payment Method : CASH COD」 유지 — 개선의견(Payment Term 으로 통일) 미반영. 결제조건 변경 → 재발행 대조는 실데이터 변경이 필요해 미실행', 'Cetakan DO (DO-20261012-115) masih berlabel 「Payment Method : CASH COD」 — usulan (seragamkan ke Payment Term) belum diterapkan. Uji ubah syarat bayar → cetak ulang tidak dilakukan karena memerlukan perubahan data nyata', 'Open', 'seo-server-check-261008'
  FROM public.csr_issues i
 WHERE i.issue_no = '75' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008');

-- ── 확인 ─────────────────────────────────────────────────────────────────────
-- ① 오늘 검증 이력과 헤더 동기화 (기대 : 29행, 헤더 verified_on = 2026-10-08)
SELECT i.issue_no, i.it_status, i.verification_result, i.verified_on, v.result
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE v.verified_on = DATE '2026-10-08' AND v.created_by = 'seo-server-check-261008' ORDER BY i.issue_no;
-- ② 입력 행 수 (기대 : 29)
SELECT count(*) AS verif_1008 FROM public.csr_verifications WHERE verified_on = DATE '2026-10-08' AND created_by = 'seo-server-check-261008';
-- ③ 현업검증 분포 (IT상태 Completed 기준)
SELECT verification_result, count(*) FROM public.csr_issues WHERE NOT is_archived AND it_status = 'Completed' GROUP BY 1 ORDER BY 1;

