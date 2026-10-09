-- =============================================================================
-- 261008 개선요청서(ASM_테스트결과_개선요청서_261008.hwpx) 신규 이슈 84~102 등록
--   040 적용 후 실행. 달러 인용 없음. 재실행 안전(같은 번호가 있으면 건너뜀)
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--
--   입력 : 2026-10-08 ASM 시스템 직접 점검(총괄팀 SEO) 19건 = 로직 오류 · 오류 · ERP 기능 부족
--      근거 : 전 메뉴 화면 조작 + Excel 전수 검산(재고 목록 668행 · Receipt History 382행 · Shipment History 1,588행 · Finance 마감 1,660행)
--   1. csr_issues 19행 — IT상태 Open · IT수용여부 미회신 · 현업검증 PENDING · 담당자 = 업무 영역별 기존 배분(Lia · Lestari · Merry · Firman · SEO)
--      한국어 현상 · 개선 의견은 문서 원문 그대로, 인니어 · 요약 · 수용기준은 Claude 번역/초안 — 검수 서종환
--      menu_main 허용값에 Reports가 없어 Receipt History → Purchasing, Shipment History → Sales 하위로 등록(path_menu에 Reports 표기)
--   2. csr_verifications 19행 — 2026-10-08 PENDING 「최초 접수」
--   3. 캡처(csr_attachments)는 미포함 — 사이트 상세 화면에서 업로드(99는 98과 동일 화면, 나머지 18건 캡처 有)
--   다음 신규 이슈는 103번부터
-- =============================================================================

SELECT set_config('csr.actor', 'migration:042 (261008 개선요청서 84~102)', false);

-- ── 84 ──
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
  '84', '84. Receipt · Customs · Shipment — 날짜 선후관계 및 미래일자 검증 부재 (입고일 < PO일, 통관일 · ATA · 입고일 미래 저장)', '84. Receipt · Customs · Shipment — Validasi Urutan Tanggal dan Tanggal Masa Depan Belum Ada (Tanggal Terima < Tanggal PO, Tanggal Customs · ATA · Terima Tersimpan di Masa Depan)',
  'Purchasing', 'Receipt', 'Purchasing > Receipt · Customs Clearance · Import Shipment', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'Receipt History 48행(PO 7건)이 입고일 < PO일, 입고 10-20 · 통관 10-16 · ATA 10-15 등 미래 실적 일자 저장 허용 — 선후관계 · 미래일자 검증 없음', '48 baris Receipt History (7 PO) tanggal terima < tanggal PO; tanggal realisasi masa depan (terima 10-20 · customs 10-16 · ATA 10-15) dapat disimpan — tidak ada validasi urutan · tanggal masa depan',
  '입고일 < PO일, 통관일 < 선적일, ATA < ETD, 실적 일자 > 오늘 입력 시 저장 차단(또는 사유 + 승인). 기존 48행 정정 완료', 'Simpan ditolak (atau alasan + persetujuan) jika tanggal terima < tanggal PO, customs < kirim, ATA < ETD, atau tanggal realisasi > hari ini. 48 baris lama sudah dikoreksi', '06', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Receipt History 전수 검산(382행) 결과 입고일이 PO일보다 빠른 행 48행 · PO 7건(전부 PT. ARAMI JAYA). 예 : AJ-20260904-005 PO일 2026-09-04, 입고일 2026-09-01 ~ 09-03
- 미래일자 저장 사례(점검일 2026-10-08 기준) : 입고 RCPT-20261020-002 입고일 10-20, 통관 CUSTM-20261016-001 통관일 10-16, 선적 SHP-20260901-001 ATA 10-15
- ATA(실제 도착일) · 통관일 · 입고일은 실적 일자이므로 미래 입력은 논리상 불가. 현재 입력 검증 없음
- 관련 이슈 : 06(입고일 · 실제도착일 선후관계) — 본 항목은 PO일 · 통관일 · ATA 및 미래일자 범위로 확장', '- Receipt History 전수 검산(382행) 결과 입고일이 PO일보다 빠른 행 48행 · PO 7건(전부 PT. ARAMI JAYA). 예 : AJ-20260904-005 PO일 2026-09-04, 입고일 2026-09-01 ~ 09-03
- 미래일자 저장 사례(점검일 2026-10-08 기준) : 입고 RCPT-20261020-002 입고일 10-20, 통관 CUSTM-20261016-001 통관일 10-16, 선적 SHP-20260901-001 ATA 10-15
- ATA(실제 도착일) · 통관일 · 입고일은 실적 일자이므로 미래 입력은 논리상 불가. 현재 입력 검증 없음
- 관련 이슈 : 06(입고일 · 실제도착일 선후관계) — 본 항목은 PO일 · 통관일 · ATA 및 미래일자 범위로 확장', '- Hasil cek seluruh Receipt History (382 baris) : 48 baris · 7 PO (semua PT. ARAMI JAYA) tanggal terima lebih awal dari tanggal PO. Contoh : AJ-20260904-005 tanggal PO 2026-09-04, terima 2026-09-01 ~ 09-03
- Contoh tanggal masa depan tersimpan (cek 2026-10-08) : Receipt RCPT-20261020-002 tanggal terima 10-20, Customs CUSTM-20261016-001 tanggal 10-16, Shipment SHP-20260901-001 ATA 10-15
- ATA (tanggal tiba aktual) · tanggal customs · tanggal terima adalah tanggal realisasi sehingga secara logika tidak boleh di masa depan. Saat ini tidak ada validasi input
- Isu terkait : 06 (urutan tanggal terima · tiba aktual) — item ini memperluas ke tanggal PO · customs · ATA dan tanggal masa depan',
  '- 입고일 ≥ PO일, 통관일 ≥ 선적일, ATA ≥ ETD 검증 추가. 위반 시 저장 차단 또는 사유 입력 후 승인자 확인
- 실적 일자(ATA · 통관일 · 입고일 · 납품일 확정)는 당일 이후 입력 불가 처리. 예정 일자(ETA · REQ. ETA)만 미래 허용
- 기존 데이터 48행은 이관 시점 오입력 여부 확인 후 일괄 정정', '- 입고일 ≥ PO일, 통관일 ≥ 선적일, ATA ≥ ETD 검증 추가. 위반 시 저장 차단 또는 사유 입력 후 승인자 확인
- 실적 일자(ATA · 통관일 · 입고일 · 납품일 확정)는 당일 이후 입력 불가 처리. 예정 일자(ETA · REQ. ETA)만 미래 허용
- 기존 데이터 48행은 이관 시점 오입력 여부 확인 후 일괄 정정', '- Tambahkan validasi tanggal terima ≥ tanggal PO, customs ≥ tanggal kirim, ATA ≥ ETD. Jika dilanggar, tolak simpan atau wajib alasan + konfirmasi penyetuju
- Tanggal realisasi (ATA · customs · terima · konfirmasi kirim) tidak boleh lebih dari hari ini. Hanya tanggal rencana (ETA · REQ. ETA) yang boleh di masa depan
- Cek 48 baris lama apakah salah input saat migrasi, lalu koreksi sekaligus',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '84' OR title_ko = '84. Receipt · Customs · Shipment — 날짜 선후관계 및 미래일자 검증 부재 (입고일 < PO일, 통관일 · ATA · 입고일 미래 저장)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '84' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 85 ──
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
  '85', '85. Receipt 목록 — ACT. ARRIVAL 컬럼에 PO ETA 값 표시 (실제 도착일 필드 부재)', '85. Daftar Receipt — Kolom ACT. ARRIVAL Menampilkan Nilai PO ETA (Field Tanggal Tiba Aktual Belum Ada)',
  'Purchasing', 'Receipt', 'Purchasing > Receipt (list · detail)', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'Receipt 목록 ACT. ARRIVAL이 PO REQ. ETA(월말) 값으로 표시되고 상세에 실제 도착일 필드가 없어 이슈 06 검증이 무의미', 'ACT. ARRIVAL pada daftar Receipt menampilkan nilai REQ. ETA PO (akhir bulan) dan detail tidak punya field tanggal tiba aktual sehingga validasi isu 06 tidak bermakna',
  'Receipt 상세에 Actual Arrival 필드 존재, 목록 ACT. ARRIVAL = 해당 필드값, PO ETA는 별도 컬럼명으로 표시', 'Detail Receipt punya field Actual Arrival, ACT. ARRIVAL di daftar = nilai field tersebut, PO ETA ditampilkan dengan nama kolom terpisah', '06', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Receipt 목록의 ACT. ARRIVAL이 10-06 입고 전표 전부 2026-10-31로 표시 — 해당 PO의 REQ. ETA(월말) 값과 동일
- Receipt 상세 화면에는 실제 도착일 입력 필드 자체가 없어 목록 값은 PO ETA를 그대로 끌어온 것으로 확인
- 이슈 06(입고일 · 실제도착일 선후관계 검증) 조치 완료 후에도 표시값이 실제 도착일이 아니므로 검증 의미 없음', '- Receipt 목록의 ACT. ARRIVAL이 10-06 입고 전표 전부 2026-10-31로 표시 — 해당 PO의 REQ. ETA(월말) 값과 동일
- Receipt 상세 화면에는 실제 도착일 입력 필드 자체가 없어 목록 값은 PO ETA를 그대로 끌어온 것으로 확인
- 이슈 06(입고일 · 실제도착일 선후관계 검증) 조치 완료 후에도 표시값이 실제 도착일이 아니므로 검증 의미 없음', '- ACT. ARRIVAL pada daftar Receipt untuk semua dokumen terima 10-06 menampilkan 2026-10-31 — sama dengan REQ. ETA (akhir bulan) PO terkait
- Layar detail Receipt tidak memiliki field input tanggal tiba aktual, sehingga nilai di daftar dipastikan diambil langsung dari PO ETA
- Setelah isu 06 (validasi urutan tanggal terima · tiba aktual) selesai pun nilai yang ditampilkan bukan tanggal tiba aktual, sehingga validasi tidak bermakna',
  '- Receipt 상세에 실제 도착일(Actual Arrival) 입력 필드 신설(기본값 = 입고일), 목록 ACT. ARRIVAL은 해당 필드로 연결
- PO ETA를 표시해야 한다면 컬럼명을 「PO ETA」로 변경하고 ACT. ARRIVAL과 분리', '- Receipt 상세에 실제 도착일(Actual Arrival) 입력 필드 신설(기본값 = 입고일), 목록 ACT. ARRIVAL은 해당 필드로 연결
- PO ETA를 표시해야 한다면 컬럼명을 「PO ETA」로 변경하고 ACT. ARRIVAL과 분리', '- Tambahkan field Actual Arrival di detail Receipt (default = tanggal terima), ACT. ARRIVAL di daftar dihubungkan ke field tersebut
- Jika PO ETA memang perlu ditampilkan, ubah nama kolom menjadi 「PO ETA」 dan pisahkan dari ACT. ARRIVAL',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '85' OR title_ko = '85. Receipt 목록 — ACT. ARRIVAL 컬럼에 PO ETA 값 표시 (실제 도착일 필드 부재)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '85' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 86 ──
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
  '86', '86. 취소(CANCELLED) 전표 통제 — 취소 사유 · 이력 없음, 취소 시 참조 전표 번호 소실', '86. Kontrol Dokumen CANCELLED — Tidak Ada Alasan · Riwayat Pembatalan, Nomor Dokumen Referensi Hilang Saat Dibatalkan',
  'Purchasing', 'Customs Clearance · Import Shipment', 'Purchasing > Customs Clearance · Import Shipment', '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'Customs 6건 중 4건, Shipment 7건 중 4건 CANCELLED이며 취소 사유 · 취소자 · 일시 없음, 취소 건 SUPPLIER PO NO 공란으로 추적 불가', '4 dari 6 Customs dan 4 dari 7 Shipment berstatus CANCELLED tanpa alasan · pembatal · waktu, SUPPLIER PO NO dokumen batal kosong sehingga tidak dapat ditelusuri',
  '취소 시 사유 필수 입력, 취소자 · 일시 표시, 취소 전표에도 원 PO · Shipment 번호 유지. 취소 전표가 집계 · 리포트에서 제외됨 확인', 'Alasan wajib saat batal, pembatal · waktu ditampilkan, nomor PO · Shipment asal tetap ada pada dokumen batal. Dokumen batal dipastikan dikecualikan dari agregasi · laporan', '91', '개발부서 / Tim Pengembang',
  'Open', 'Lestari', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Customs 목록 6건 중 4건 CANCELLED, 취소 건은 SUPPLIER PO NO. 공란(참조 끊김) — 어떤 PO의 통관이 취소됐는지 추적 불가
- Shipment 목록도 7건 중 4건 CANCELLED이며 취소 사유 · 취소자 · 취소 일시 표시 없음
- 취소 전표가 수량 집계에 영향을 주는 사례 확인(이슈 91 참조)', '- Customs 목록 6건 중 4건 CANCELLED, 취소 건은 SUPPLIER PO NO. 공란(참조 끊김) — 어떤 PO의 통관이 취소됐는지 추적 불가
- Shipment 목록도 7건 중 4건 CANCELLED이며 취소 사유 · 취소자 · 취소 일시 표시 없음
- 취소 전표가 수량 집계에 영향을 주는 사례 확인(이슈 91 참조)', '- 4 dari 6 Customs berstatus CANCELLED, dan SUPPLIER PO NO. dokumen batal kosong (referensi putus) — tidak dapat ditelusuri customs PO mana yang dibatalkan
- Daftar Shipment juga 4 dari 7 CANCELLED tanpa tampilan alasan · pembatal · waktu pembatalan
- Ditemukan kasus dokumen batal memengaruhi agregasi kuantitas (lihat isu 91)',
  '- 취소 시 사유(필수) · 취소자 · 일시 저장 및 상세 화면 표시, 목록에 취소 사유 툴팁 추가
- 취소 전표도 원 PO · Shipment 참조 번호를 유지(공란 처리 금지)
- 취소 전표는 재고 · 수량 집계 · 리포트에서 전부 제외되는지 모듈별 점검', '- 취소 시 사유(필수) · 취소자 · 일시 저장 및 상세 화면 표시, 목록에 취소 사유 툴팁 추가
- 취소 전표도 원 PO · Shipment 참조 번호를 유지(공란 처리 금지)
- 취소 전표는 재고 · 수량 집계 · 리포트에서 전부 제외되는지 모듈별 점검', '- Saat batal simpan alasan (wajib) · pembatal · waktu dan tampilkan di detail, tambahkan tooltip alasan batal di daftar
- Dokumen batal tetap mempertahankan nomor referensi PO · Shipment asal (tidak dikosongkan)
- Cek per modul apakah dokumen batal sudah dikecualikan seluruhnya dari stok · agregasi kuantitas · laporan',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '86' OR title_ko = '86. 취소(CANCELLED) 전표 통제 — 취소 사유 · 이력 없음, 취소 시 참조 전표 번호 소실'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '86' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 87 ──
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
  '87', '87. 견적(Quotation) ↔ Customer PO 금액 1 IDR 불일치 (소수점 처리 차이)', '87. Quotation ↔ Customer PO Selisih Nilai 1 IDR (Perbedaan Penanganan Desimal)',
  'Sales', 'Quotation · Customer PO', 'Sales > Quotation · Customer PO', '오류 / Bug', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'QT-20261008-116 IDR 49,069,595 ↔ Customer PO 053/LBSA IDR 49,069,594 — 이슈 13(SO↔DN)과 같은 소수점 원인이 견적↔PO 구간에도 존재', 'QT-20261008-116 IDR 49.069.595 ↔ Customer PO 053/LBSA IDR 49.069.594 — penyebab desimal yang sama dengan isu 13 (SO↔DN) juga ada di tahap Quotation↔PO',
  '견적 → Customer PO → SO → DN 전 구간 합계 금액 동일(샘플 10건 차이 0). 견적 목록 QUOTE NAME 중복 컬럼 정리', 'Nilai total identik di seluruh tahap Quotation → Customer PO → SO → DN (10 sampel selisih 0). Kolom duplikat QUOTE NAME di daftar quotation dirapikan', '12 · 13', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- QT-20261008-116 금액 IDR 49,069,595 ↔ Customer PO 053/LBSA/BD/X/2026-R1 금액 IDR 49,069,594 (동일 300 pcs)
- 이슈 13(SO ↔ Delivery Note 소수점 불일치)과 동일 원인이 견적 ↔ Customer PO 구간에도 존재. 이슈 13은 REJECTED 상태
- 견적 목록의 QUOTE NAME과 PO NO. 컬럼이 동일 값으로 중복 표시', '- QT-20261008-116 금액 IDR 49,069,595 ↔ Customer PO 053/LBSA/BD/X/2026-R1 금액 IDR 49,069,594 (동일 300 pcs)
- 이슈 13(SO ↔ Delivery Note 소수점 불일치)과 동일 원인이 견적 ↔ Customer PO 구간에도 존재. 이슈 13은 REJECTED 상태
- 견적 목록의 QUOTE NAME과 PO NO. 컬럼이 동일 값으로 중복 표시', '- QT-20261008-116 nilai IDR 49.069.595 ↔ Customer PO 053/LBSA/BD/X/2026-R1 nilai IDR 49.069.594 (sama-sama 300 pcs)
- Penyebab yang sama dengan isu 13 (selisih desimal SO ↔ Delivery Note) juga ada pada tahap Quotation ↔ Customer PO. Isu 13 berstatus REJECTED
- Kolom QUOTE NAME dan PO NO. di daftar quotation menampilkan nilai yang sama (duplikat)',
  '- 전표 간 금액 전이 시 소수점 처리(절사 · 반올림) 규칙을 한 곳(공통 함수)으로 통일하고 라인 단위가 아닌 전표 합계 기준으로 고정(이슈 12 결정과 연동)
- 견적 목록 QUOTE NAME 컬럼 제거 또는 용도 분리', '- 전표 간 금액 전이 시 소수점 처리(절사 · 반올림) 규칙을 한 곳(공통 함수)으로 통일하고 라인 단위가 아닌 전표 합계 기준으로 고정(이슈 12 결정과 연동)
- 견적 목록 QUOTE NAME 컬럼 제거 또는 용도 분리', '- Satukan aturan desimal (pembulatan · pemotongan) saat nilai berpindah antar dokumen ke satu fungsi bersama dan kunci pada total dokumen, bukan per baris (terkait keputusan isu 12)
- Hapus kolom QUOTE NAME di daftar quotation atau pisahkan fungsinya',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '87' OR title_ko = '87. 견적(Quotation) ↔ Customer PO 금액 1 IDR 불일치 (소수점 처리 차이)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '87' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 88 ──
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
  '88', '88. SO 상세 — MARGIN(%) 산식 · 기준 원가 미표시 (화면 수치로 재현 불가)', '88. Detail SO — Rumus MARGIN(%) · Dasar HPP Tidak Ditampilkan (Tidak Dapat Direproduksi dari Angka di Layar)',
  'Sales', 'Sales Order', 'Sales > Sales Order > detail', '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'OD-20261008-132 MARGIN 15%(906,510)가 할인후 금액 기준 8.9%, 입고단가 기준 음수로 재현 불가 — 기준 원가 · 분모 미표시, INV QTY 명칭 오독 소지', 'MARGIN 15% (906.510) pada OD-20261008-132 tidak dapat direproduksi : 8,9% terhadap nilai setelah diskon, negatif terhadap harga terima — dasar HPP · penyebut tidak ditampilkan, nama INV QTY mudah salah tafsir',
  '마진 산식 · 기준 원가 종류가 화면에 표시되고 샘플 5건에서 표시값이 수기 계산과 일치. INV QTY 명칭 변경', 'Rumus margin · jenis HPP dasar ditampilkan di layar dan nilai pada 5 sampel sama dengan hitungan manual. Nama INV QTY diubah', '33 · 78', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- OD-20261008-132 (DIAMOND 6.00-9 XN-028, 10 pcs) MARGIN 표시 15% (906,510)
- 할인 후 금액 10,184,685 기준 906,510은 8.9%, 최근 입고 단가 952,728 기준 마진은 음수 — 15%가 어느 원가 · 어느 금액 기준인지 확인 불가
- INV QTY 컬럼명이 「재고 가용 수량(11)」을 뜻하나 Invoice 수량으로 오독 가능
- 관련 이슈 : 33(할인율 입력 시 마진율 미재계산)', '- OD-20261008-132 (DIAMOND 6.00-9 XN-028, 10 pcs) MARGIN 표시 15% (906,510)
- 할인 후 금액 10,184,685 기준 906,510은 8.9%, 최근 입고 단가 952,728 기준 마진은 음수 — 15%가 어느 원가 · 어느 금액 기준인지 확인 불가
- INV QTY 컬럼명이 「재고 가용 수량(11)」을 뜻하나 Invoice 수량으로 오독 가능
- 관련 이슈 : 33(할인율 입력 시 마진율 미재계산)', '- OD-20261008-132 (DIAMOND 6.00-9 XN-028, 10 pcs) menampilkan MARGIN 15% (906.510)
- Terhadap nilai setelah diskon 10.184.685, 906.510 = 8,9%; terhadap harga terima terakhir 952.728 margin negatif — tidak dapat dipastikan 15% dihitung dari HPP · nilai mana
- Nama kolom INV QTY berarti 「stok tersedia (11)」 tetapi mudah ditafsirkan sebagai jumlah Invoice
- Isu terkait : 33 (margin tidak dihitung ulang saat input diskon)',
  '- 마진 산식(기준 원가 종류 · 분모)을 화면 툴팁 또는 설명란에 명시, 기준 원가(이동평균 · 최근 입고가 · WH Price) 선택 기준을 이슈 78 WH Price와 함께 확정
- INV QTY → AVAIL. STOCK 등 의미가 드러나는 명칭으로 변경', '- 마진 산식(기준 원가 종류 · 분모)을 화면 툴팁 또는 설명란에 명시, 기준 원가(이동평균 · 최근 입고가 · WH Price) 선택 기준을 이슈 78 WH Price와 함께 확정
- INV QTY → AVAIL. STOCK 등 의미가 드러나는 명칭으로 변경', '- Tampilkan rumus margin (jenis HPP dasar · penyebut) lewat tooltip atau keterangan di layar, tetapkan dasar HPP (rata-rata bergerak · harga terima terakhir · WH Price) bersama WH Price isu 78
- Ubah INV QTY menjadi AVAIL. STOCK atau nama lain yang jelas maknanya',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '88' OR title_ko = '88. SO 상세 — MARGIN(%) 산식 · 기준 원가 미표시 (화면 수치로 재현 불가)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '88' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 89 ──
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
  '89', '89. Delivery Order — 미래 납품일로 CONFIRMED 처리 허용 · 채번이 전표일자 기준이라 목록 순서 역전', '89. Delivery Order — CONFIRMED dengan Tanggal Kirim Masa Depan Diizinkan · Penomoran Berdasarkan Tanggal Dokumen Membuat Urutan Daftar Terbalik',
  'Sales', 'Delivery Order', 'Sales > Delivery Order', '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '점검일 10-08에 DO-20261012-115~113(납품일 10-12) CONFIRMED, DO 번호가 납품일 기준이라 10-12 전표가 10-08 전표 앞에 정렬 — 생성 · 번호 · 일자 순서 불일치', 'Pada 10-08 DO-20261012-115~113 (tanggal kirim 10-12) sudah CONFIRMED; nomor DO berdasarkan tanggal kirim sehingga dokumen 10-12 tampil di atas 10-08 — urutan buat · nomor · tanggal tidak konsisten',
  '납품일이 오늘 이후인 DO는 Confirm 불가(DRAFT 유지), 채번은 생성일 연번 규칙으로 통일(이슈 04 규칙에 포함)', 'DO dengan tanggal kirim setelah hari ini tidak dapat Confirm (tetap DRAFT), penomoran diseragamkan berdasarkan tanggal pembuatan (masuk aturan isu 04)', '04', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 점검일 2026-10-08에 DO-20261012-115 ~ 113(납품일 10-12)이 CONFIRMED 상태 — 실적 확정이 미래 일자에 발생
- DO 번호가 납품일 기준으로 생성되어 10-12 전표가 10-08 전표보다 앞에 정렬, 생성 순서 · 번호 순서 · 일자 순서가 모두 불일치
- 관련 이슈 : 04(PO NO. 채번 규칙)', '- 점검일 2026-10-08에 DO-20261012-115 ~ 113(납품일 10-12)이 CONFIRMED 상태 — 실적 확정이 미래 일자에 발생
- DO 번호가 납품일 기준으로 생성되어 10-12 전표가 10-08 전표보다 앞에 정렬, 생성 순서 · 번호 순서 · 일자 순서가 모두 불일치
- 관련 이슈 : 04(PO NO. 채번 규칙)', '- Pada tanggal cek 2026-10-08, DO-20261012-115 ~ 113 (tanggal kirim 10-12) berstatus CONFIRMED — konfirmasi realisasi terjadi pada tanggal masa depan
- Nomor DO dibuat berdasarkan tanggal kirim sehingga dokumen 10-12 diurutkan di atas dokumen 10-08; urutan pembuatan · nomor · tanggal semuanya tidak konsisten
- Isu terkait : 04 (aturan penomoran PO NO.)',
  '- DO 확정(Confirm)은 납품 당일 이후만 허용, 사전 등록은 DRAFT 유지
- 채번은 생성일 기준 연번으로 통일하고 납품일은 별도 컬럼으로 관리 (전 전표 공통 규칙으로 이슈 04에 포함)', '- DO 확정(Confirm)은 납품 당일 이후만 허용, 사전 등록은 DRAFT 유지
- 채번은 생성일 기준 연번으로 통일하고 납품일은 별도 컬럼으로 관리 (전 전표 공통 규칙으로 이슈 04에 포함)', '- Confirm DO hanya diizinkan pada atau setelah tanggal kirim, pendaftaran lebih awal tetap DRAFT
- Penomoran diseragamkan sebagai nomor urut berdasarkan tanggal pembuatan dan tanggal kirim dikelola sebagai kolom terpisah (masuk aturan umum semua dokumen di isu 04)',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '89' OR title_ko = '89. Delivery Order — 미래 납품일로 CONFIRMED 처리 허용 · 채번이 전표일자 기준이라 목록 순서 역전'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '89' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 90 ──
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
  '90', '90. 재고 목록 페이징 — 페이지 이동 시 동일 행 반복 표시 · 일부 품목 영구 누락 (정렬 기준 없는 페이징)', '90. Paginasi Daftar Stok — Baris yang Sama Tampil Berulang Saat Pindah Halaman · Sebagian Item Tidak Pernah Tampil (Paginasi Tanpa Kunci Urut)',
  'Inventory', 'Inventory List', 'Inventory > Inventory List', '오류 / Bug', 'S1 Blocker',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '1~5페이지 50행 중 품목+창고 유일 37건 · 중복 13건(26%), 같은 비율로 화면에 전혀 안 나오는 품목 존재. Excel 668행은 중복 0 → 조회 쿼리 정렬 키 부재', 'Dari 50 baris halaman 1~5 hanya 37 unik (item+gudang) · 13 duplikat (26%), item dengan proporsi sama tidak pernah tampil di layar. Excel 668 baris 0 duplikat → query daftar tanpa kunci urut',
  '1~67페이지 전수 수집 결과 = Excel 668행과 1:1 일치(중복 0 · 누락 0), 페이지 번호 직접 클릭 동작', 'Pengumpulan seluruh halaman 1~67 = identik 1:1 dengan Excel 668 baris (0 duplikat · 0 hilang), klik nomor halaman langsung berfungsi', '24 · 51', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 1페이지 1행 「TK 7.50R16 SUPER AM S 14 (M) / KARAWANG」이 2페이지 11행에 다시 표시, 1페이지 10행 「TK 7.50R16 TKAL III 14 (M)」이 12행에 재표시
- 1 ~ 5페이지(50행) 수집 결과 품목 + 창고 기준 유일 행 37건 · 중복 13건(26%). 같은 비율로 화면에 전혀 나오지 않는 품목 존재
- Excel 다운로드(668행)는 품목 + 창고 중복 0건 → DB 데이터는 정상, 목록 조회 쿼리의 정렬 키 부재로 페이지마다 순서가 바뀌는 현상
- 페이지 번호(1 · 2 · 3) 직접 클릭 시 페이지 전환 안 됨(Next · Last만 동작) — 재확인 필요
- 관련 이슈 : 24(목록 정렬 기능), 51(Excel 수량 불일치) — 본 항목은 기능 부재가 아닌 조회 결과 오류', '- 1페이지 1행 「TK 7.50R16 SUPER AM S 14 (M) / KARAWANG」이 2페이지 11행에 다시 표시, 1페이지 10행 「TK 7.50R16 TKAL III 14 (M)」이 12행에 재표시
- 1 ~ 5페이지(50행) 수집 결과 품목 + 창고 기준 유일 행 37건 · 중복 13건(26%). 같은 비율로 화면에 전혀 나오지 않는 품목 존재
- Excel 다운로드(668행)는 품목 + 창고 중복 0건 → DB 데이터는 정상, 목록 조회 쿼리의 정렬 키 부재로 페이지마다 순서가 바뀌는 현상
- 페이지 번호(1 · 2 · 3) 직접 클릭 시 페이지 전환 안 됨(Next · Last만 동작) — 재확인 필요
- 관련 이슈 : 24(목록 정렬 기능), 51(Excel 수량 불일치) — 본 항목은 기능 부재가 아닌 조회 결과 오류', '- Baris 1 halaman 1 「TK 7.50R16 SUPER AM S 14 (M) / KARAWANG」 tampil lagi di baris 11 halaman 2, baris 10 「TK 7.50R16 TKAL III 14 (M)」 tampil lagi di baris 12
- Hasil pengumpulan halaman 1 ~ 5 (50 baris) : unik 37 · duplikat 13 (26%) berdasarkan item + gudang. Dengan proporsi sama ada item yang tidak pernah muncul di layar
- Excel download (668 baris) 0 duplikat item + gudang → data DB normal; query daftar tidak punya kunci urut sehingga urutan berubah tiap halaman
- Klik langsung nomor halaman (1 · 2 · 3) tidak berpindah halaman (hanya Next · Last yang berfungsi) — perlu dicek ulang
- Isu terkait : 24 (fitur sort daftar), 51 (selisih kuantitas Excel) — item ini bukan fitur yang belum ada, melainkan hasil query yang salah',
  '- 재고 목록 조회 SQL에 고정 정렬 키(창고 · Cat1 ~ 4 · 품목 · ID) 추가 후 페이징 적용. 전 목록 화면 공통 점검
- 페이지 번호 클릭 동작 수정
- 수정 후 1 ~ 67페이지 전수 수집 = Excel 668행과 1:1 일치 확인을 검수 조건으로 지정', '- 재고 목록 조회 SQL에 고정 정렬 키(창고 · Cat1 ~ 4 · 품목 · ID) 추가 후 페이징 적용. 전 목록 화면 공통 점검
- 페이지 번호 클릭 동작 수정
- 수정 후 1 ~ 67페이지 전수 수집 = Excel 668행과 1:1 일치 확인을 검수 조건으로 지정', '- Tambahkan kunci urut tetap (gudang · Cat1 ~ 4 · item · ID) pada SQL daftar stok lalu terapkan paginasi. Cek bersama untuk semua layar daftar
- Perbaiki aksi klik nomor halaman
- Jadikan syarat verifikasi : pengumpulan seluruh halaman 1 ~ 67 = identik 1:1 dengan Excel 668 baris',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '90' OR title_ko = '90. 재고 목록 페이징 — 페이지 이동 시 동일 행 반복 표시 · 일부 품목 영구 누락 (정렬 기준 없는 페이징)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '90' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 91 ──
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
  '91', '91. 취소(CANCELLED) 입고 전표가 재고 목록 Receipt Qty · Receipt Date에 반영', '91. Dokumen Terima CANCELLED Terhitung pada Receipt Qty · Receipt Date Daftar Stok',
  'Inventory', 'Inventory List', 'Inventory > Inventory List', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '취소 입고 RCPT-20261001-001(800) · RCPT-20261020-002(100)가 재고 목록 Receipt Qty/Date에 반영, Receipt 합계 50,569 vs Receipt History 49,368(차이 1,201 = 취소분)', 'Receipt batal RCPT-20261001-001 (800) · RCPT-20261020-002 (100) terhitung pada Receipt Qty/Date daftar stok, total Receipt 50.569 vs Receipt History 49.368 (selisih 1.201 = dokumen batal)',
  '재고 목록 Receipt Qty 합계 = Receipt History 확정 전표 합계, 취소 전표 품목의 Receipt Date에 취소 전표 일자 미표시', 'Total Receipt Qty daftar stok = total dokumen terkonfirmasi Receipt History, tanggal dokumen batal tidak tampil pada Receipt Date item terkait', '86', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- RCPT-20261001-001 (HUBEI, 800 pcs, CANCELLED) → 재고 목록 「ASC 12.00R24 AR585 20」 Receipt Date 2026-10-01 · Receipt Qty 800 표시
- RCPT-20261020-002 (100 pcs, CANCELLED, 미래일자) → 「ASC 10.00R20 AR102HD 18++」 Receipt Date 2026-10-20 · Receipt Qty 100 표시
- 재고 목록 Receipt Qty 합계 50,569 vs Receipt History 합계 49,368 — 차이 1,201은 취소 전표분
- Total Qty에는 미반영(취소분 제외)이나 Receipt 컬럼은 취소분 포함 → 같은 행 안에서 집계 기준 불일치', '- RCPT-20261001-001 (HUBEI, 800 pcs, CANCELLED) → 재고 목록 「ASC 12.00R24 AR585 20」 Receipt Date 2026-10-01 · Receipt Qty 800 표시
- RCPT-20261020-002 (100 pcs, CANCELLED, 미래일자) → 「ASC 10.00R20 AR102HD 18++」 Receipt Date 2026-10-20 · Receipt Qty 100 표시
- 재고 목록 Receipt Qty 합계 50,569 vs Receipt History 합계 49,368 — 차이 1,201은 취소 전표분
- Total Qty에는 미반영(취소분 제외)이나 Receipt 컬럼은 취소분 포함 → 같은 행 안에서 집계 기준 불일치', '- RCPT-20261001-001 (HUBEI, 800 pcs, CANCELLED) → daftar stok 「ASC 12.00R24 AR585 20」 menampilkan Receipt Date 2026-10-01 · Receipt Qty 800
- RCPT-20261020-002 (100 pcs, CANCELLED, tanggal masa depan) → 「ASC 10.00R20 AR102HD 18++」 menampilkan Receipt Date 2026-10-20 · Receipt Qty 100
- Total Receipt Qty daftar stok 50.569 vs total Receipt History 49.368 — selisih 1.201 adalah dokumen batal
- Total Qty tidak terpengaruh (dokumen batal dikecualikan) tetapi kolom Receipt memasukkan dokumen batal → dasar agregasi tidak konsisten dalam satu baris',
  '- 재고 목록 · 집계 · 리포트의 입고 관련 컬럼은 CONFIRMED(또는 COMPLETED) 전표만 집계하도록 상태 조건 추가
- 취소 전표가 참조되는 모든 집계 쿼리 전수 점검(이슈 86과 연동)', '- 재고 목록 · 집계 · 리포트의 입고 관련 컬럼은 CONFIRMED(또는 COMPLETED) 전표만 집계하도록 상태 조건 추가
- 취소 전표가 참조되는 모든 집계 쿼리 전수 점검(이슈 86과 연동)', '- Kolom terkait penerimaan pada daftar stok · agregasi · laporan hanya menghitung dokumen CONFIRMED (atau COMPLETED) dengan menambah kondisi status
- Cek seluruh query agregasi yang mereferensikan dokumen batal (terkait isu 86)',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '91' OR title_ko = '91. 취소(CANCELLED) 입고 전표가 재고 목록 Receipt Qty · Receipt Date에 반영'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '91' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 92 ──
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
  '92', '92. 재고 목록 기간 필터 — Receipt Qty · Total Qty 의미가 필터 유무에 따라 달라짐, 특정 일자 기준 재고 조회 불가', '92. Filter Periode Daftar Stok — Arti Receipt Qty · Total Qty Berubah Tergantung Filter, Stok per Tanggal Tertentu Tidak Dapat Dilihat',
  'Inventory', 'Inventory List', 'Inventory > Inventory List', '개선 / Perbaikan', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '기간 필터가 입고에만 적용되고 재고는 항상 현재 시점(AR585 20 : 무필터 355 → 10월 필터 0), 기초 · 출고 · 기말 컬럼 없음 → 특정일 재고 · 수불 검증 불가', 'Filter periode hanya berlaku pada penerimaan sedangkan stok selalu saat ini (AR585 20 : tanpa filter 355 → filter Oktober 0), tidak ada kolom awal · keluar · akhir → stok per tanggal · mutasi tidak dapat diverifikasi',
  '기간 필터 시 품목 · 창고별 기초 · 입고 · 출고 · 조정 · 기말 표시, 기준일 입력 시 해당일 기말 재고 산출, 무의미한 Receipt Qty 합계행 제거', 'Saat filter periode tampil awal · masuk · keluar · penyesuaian · akhir per item · gudang, input tanggal acuan menghasilkan stok akhir tanggal tersebut, baris total Receipt Qty yang tidak bermakna dihapus', '14 · 53', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 필터 없음 : Receipt Qty = 9/1 이후 누적 입고, Receipt Date = 최종 입고일, Total Qty = 현재 재고 (AR585 20 → 355)
- 10월 기간 필터 : Receipt Qty = 기간 내 입고, Total Qty = 0 으로 변경 (같은 품목 355 → 0). 컬럼 하나에 두 가지 의미
- 기간 필터가 입고에만 적용되고 재고 수량은 항상 현재 시점 → 「9/30 기준 재고」 조회 불가, 합계행 Receipt Qty(50,569)는 업무상 의미 없는 수치
- 출고 · 기초 · 기말 컬럼이 없어 입고 − 출고 = 재고 증감 검증 불가', '- 필터 없음 : Receipt Qty = 9/1 이후 누적 입고, Receipt Date = 최종 입고일, Total Qty = 현재 재고 (AR585 20 → 355)
- 10월 기간 필터 : Receipt Qty = 기간 내 입고, Total Qty = 0 으로 변경 (같은 품목 355 → 0). 컬럼 하나에 두 가지 의미
- 기간 필터가 입고에만 적용되고 재고 수량은 항상 현재 시점 → 「9/30 기준 재고」 조회 불가, 합계행 Receipt Qty(50,569)는 업무상 의미 없는 수치
- 출고 · 기초 · 기말 컬럼이 없어 입고 − 출고 = 재고 증감 검증 불가', '- Tanpa filter : Receipt Qty = akumulasi penerimaan sejak 1/9, Receipt Date = tanggal terima terakhir, Total Qty = stok saat ini (AR585 20 → 355)
- Filter periode Oktober : Receipt Qty = penerimaan dalam periode, Total Qty berubah jadi 0 (item yang sama 355 → 0). Satu kolom punya dua arti
- Filter periode hanya berlaku pada penerimaan dan stok selalu saat ini → 「stok per 30/9」 tidak dapat dilihat, total Receipt Qty (50.569) tidak bermakna secara bisnis
- Tidak ada kolom keluar · awal · akhir sehingga masuk − keluar = perubahan stok tidak dapat diverifikasi',
  '- 기간 필터 시 컬럼을 기초 · 입고 · 출고 · 조정 · 기말로 재구성(품목 · 창고별 수불부), 필터 없을 때는 현재 재고 화면으로 분리
- 기준일(As-of Date) 입력 시 해당 일자 기말 재고 산출 기능 추가 — 월마감 · 재고실사(이슈 53) 대사의 전제 조건
- Receipt Qty 합계행 제거 또는 「기간 입고 합계」로 명칭 변경', '- 기간 필터 시 컬럼을 기초 · 입고 · 출고 · 조정 · 기말로 재구성(품목 · 창고별 수불부), 필터 없을 때는 현재 재고 화면으로 분리
- 기준일(As-of Date) 입력 시 해당 일자 기말 재고 산출 기능 추가 — 월마감 · 재고실사(이슈 53) 대사의 전제 조건
- Receipt Qty 합계행 제거 또는 「기간 입고 합계」로 명칭 변경', '- Saat filter periode, susun ulang kolom menjadi awal · masuk · keluar · penyesuaian · akhir (kartu stok per item · gudang); tanpa filter pisahkan sebagai layar stok saat ini
- Tambahkan fitur stok akhir per tanggal acuan (As-of Date) — prasyarat rekonsiliasi tutup bulan · stock opname (isu 53)
- Hapus baris total Receipt Qty atau ubah nama menjadi 「Total Masuk Periode」',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '92' OR title_ko = '92. 재고 목록 기간 필터 — Receipt Qty · Total Qty 의미가 필터 유무에 따라 달라짐, 특정 일자 기준 재고 조회 불가'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '92' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 93 ──
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
  '93', '93. 재고 목록 — 종료일 < 시작일 입력 시 오류 메시지와 화면 상태 불일치 (건수 배지 유지 · 표 비움 · Excel 버튼 소실)', '93. Daftar Stok — Saat Tanggal Akhir < Tanggal Awal, Pesan Error dan Status Layar Tidak Konsisten (Badge Jumlah Tetap · Tabel Kosong · Tombol Excel Hilang)',
  'Inventory', 'Inventory List', 'Inventory > Inventory List', '오류 / Bug', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '종료일 < 시작일 검색 시 오류문구 + 표 「No data found」 + 건수 배지 668 유지 + Excel 버튼 소실이 동시에 발생 — 세 상태가 모순', 'Saat cari dengan tanggal akhir < awal muncul pesan error + tabel 「No data found」 + badge 668 tetap + tombol Excel hilang secara bersamaan — tiga status saling bertentangan',
  '검증 실패 시 기존 결과 · 버튼 유지하고 메시지만 표시, 날짜 입력란 min/max 연동으로 역순 선택 차단', 'Saat validasi gagal hasil · tombol sebelumnya tetap dan hanya pesan yang tampil, input tanggal dengan min/max mencegah pilihan terbalik', '25', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 시작일 2026-09-30 · 종료일 2026-01-01 입력 후 Search → 「End date cannot be earlier than Start date」 표시
- 동시에 표는 「No data found」로 비워지고 건수 배지는 668 · Page 1 of 67 그대로, Excel 버튼은 사라짐 → 세 가지 상태가 서로 모순
- 관련 이슈 : 25(입력 검증 안내 방식)', '- 시작일 2026-09-30 · 종료일 2026-01-01 입력 후 Search → 「End date cannot be earlier than Start date」 표시
- 동시에 표는 「No data found」로 비워지고 건수 배지는 668 · Page 1 of 67 그대로, Excel 버튼은 사라짐 → 세 가지 상태가 서로 모순
- 관련 이슈 : 25(입력 검증 안내 방식)', '- Input awal 2026-09-30 · akhir 2026-01-01 lalu Search → tampil 「End date cannot be earlier than Start date」
- Bersamaan tabel dikosongkan 「No data found」, badge jumlah tetap 668 · Page 1 of 67, tombol Excel hilang → tiga status saling bertentangan
- Isu terkait : 25 (cara pemberitahuan validasi input)',
  '- 입력 검증 실패 시 조회를 실행하지 않고 기존 결과 · 버튼을 유지(메시지만 표시)
- 날짜 입력란에 min · max 속성 연동으로 역순 선택 자체를 차단', '- 입력 검증 실패 시 조회를 실행하지 않고 기존 결과 · 버튼을 유지(메시지만 표시)
- 날짜 입력란에 min · max 속성 연동으로 역순 선택 자체를 차단', '- Jika validasi input gagal, jangan jalankan query dan pertahankan hasil · tombol sebelumnya (hanya tampilkan pesan)
- Hubungkan atribut min · max pada input tanggal untuk mencegah pemilihan terbalik sejak awal',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '93' OR title_ko = '93. 재고 목록 — 종료일 < 시작일 입력 시 오류 메시지와 화면 상태 불일치 (건수 배지 유지 · 표 비움 · Excel 버튼 소실)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '93' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 94 ──
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
  '94', '94. 재고 목록 — 재고 0 품목 숨김 옵션 · 재고금액 컬럼 부재, 단가 0 품목 6건 재고평가 누락', '94. Daftar Stok — Opsi Sembunyikan Item Stok 0 · Kolom Nilai Stok Belum Ada, 6 Item Harga 0 Tidak Ternilai',
  'Inventory', 'Inventory List', 'Inventory > Inventory List · Excel', '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '668행 중 재고 0 품목 71행 상시 노출, 화면에 재고금액 컬럼 없음(Excel에만 UnitCost), UnitCost 0 + 재고 보유 6행(Metal Plate · CLAIM 3품목) 재고평가 누락', '71 dari 668 baris stok 0 selalu tampil, layar tidak punya kolom nilai stok (UnitCost hanya di Excel), 6 baris UnitCost 0 + stok ada (Metal Plate · 3 item CLAIM) tidak ternilai',
  '「재고 0 제외」 옵션(기본 ON) · 재고금액 컬럼 · 합계 표시, 단가 0 품목 월마감 전 경고 표시', 'Opsi 「kecualikan stok 0」 (default ON) · kolom nilai stok · total tampil, item harga 0 diperingatkan sebelum tutup bulan', '19 · 78', '개발부서 / Tim Pengembang',
  'Open', 'Lia', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 668행 중 Total Qty 0 품목 71행이 항상 노출되어 실재고 파악에 방해
- 화면에 재고금액(Qty × 단가) 컬럼 없음. Excel에만 UnitCost 존재(이슈 102 참조)
- Excel 기준 UnitCost 0 이면서 재고 보유 6행 : ASC 6.50/7.00R16 (H) 508 pcs, ASC 12.00R24 Metal Plate 47 pcs, CLAIM KARAWANG 3품목(20 pcs) 등 → Σ(Qty × UnitCost) 92,017,880,011에서 누락
- 관련 이슈 : 19(제품 마스터 단가 미등록), 78(WH Price)', '- 668행 중 Total Qty 0 품목 71행이 항상 노출되어 실재고 파악에 방해
- 화면에 재고금액(Qty × 단가) 컬럼 없음. Excel에만 UnitCost 존재(이슈 102 참조)
- Excel 기준 UnitCost 0 이면서 재고 보유 6행 : ASC 6.50/7.00R16 (H) 508 pcs, ASC 12.00R24 Metal Plate 47 pcs, CLAIM KARAWANG 3품목(20 pcs) 등 → Σ(Qty × UnitCost) 92,017,880,011에서 누락
- 관련 이슈 : 19(제품 마스터 단가 미등록), 78(WH Price)', '- Dari 668 baris, 71 baris Total Qty 0 selalu tampil sehingga mengganggu pembacaan stok riil
- Tidak ada kolom nilai stok (Qty × harga) di layar. UnitCost hanya ada di Excel (lihat isu 102)
- Berdasarkan Excel, 6 baris UnitCost 0 tetapi punya stok : ASC 6.50/7.00R16 (H) 508 pcs, ASC 12.00R24 Metal Plate 47 pcs, 3 item CLAIM KARAWANG (20 pcs) dll. → hilang dari Σ(Qty × UnitCost) 92.017.880.011
- Isu terkait : 19 (harga master produk belum diisi), 78 (WH Price)',
  '- 「재고 0 제외」 체크박스(기본 ON) 및 재고금액 · 합계 컬럼 추가
- 단가 0 품목 목록을 월마감 전 경고로 표시, CLAIM 창고 품목은 클레임 원가 기준 정의 후 반영', '- 「재고 0 제외」 체크박스(기본 ON) 및 재고금액 · 합계 컬럼 추가
- 단가 0 품목 목록을 월마감 전 경고로 표시, CLAIM 창고 품목은 클레임 원가 기준 정의 후 반영', '- Tambahkan checkbox 「Kecualikan stok 0」 (default ON) serta kolom nilai stok · total
- Tampilkan daftar item harga 0 sebagai peringatan sebelum tutup bulan, item gudang CLAIM dinilai setelah dasar HPP klaim ditetapkan',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '94' OR title_ko = '94. 재고 목록 — 재고 0 품목 숨김 옵션 · 재고금액 컬럼 부재, 단가 0 품목 6건 재고평가 누락'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '94' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 95 ──
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
  '95', '95. 월마감 수량 3원화 — 재고마감 · Finance 업로드 · 재고목록 상호 불일치, 업로드 데이터 검증 부재, 202609 마감 미생성, 상세 드릴다운 없음', '95. Tiga Angka Tutup Bulan Tidak Konsisten — Inventory Closing · Upload Finance · Daftar Stok Saling Berbeda, Tidak Ada Validasi Upload, Closing 202609 Belum Dibuat, Tidak Ada Rincian',
  'Inventory', 'Monthly Inventory Closing · Finance Closing Data', 'Inventory > Monthly Inventory Closing · Master Data > Finance > Upload Closing Data', '데이터정비 / Perapian Data', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '재고마감 202608 151,345 ↔ Finance 8/31 155,052 ↔ Finance 9/30 155,052(8월과 동일 수량, 단가만 변경) ↔ 거래 기준 120,550 ↔ 현재 재고목록 115,285. 업로드 검증 · 3원 대사 · 상세 조회 없음, 202609 미생성', 'Inventory closing 202608 151.345 ↔ Finance 31/8 155.052 ↔ Finance 30/9 155.052 (kuantitas sama dengan Agustus, hanya harga berubah) ↔ basis transaksi 120.550 ↔ daftar stok saat ini 115.285. Tidak ada validasi upload · rekonsiliasi 3 sumber · rincian, closing 202609 belum dibuat',
  '업로드 시 검증 리포트(전월 동일 · 편차 · 시스템 차이) 표시, 마감 생성 시 3원 대사표 자동 생성 및 차이 0(또는 사유) 후 확정, 품목 · 창고별 상세 화면 제공', 'Saat upload tampil laporan validasi (sama dengan bulan lalu · deviasi · selisih sistem), saat buat closing tabel rekonsiliasi 3 sumber otomatis dan dikonfirmasi setelah selisih 0 (atau alasan), tersedia rincian per item · gudang', '14 · 53', '개발부서 / Tim Pengembang',
  'Open', 'Firman', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Inventory Monthly Closing 202608 Closing Qty 151,345 ↔ Finance 업로드 2026-08-31 합계 155,052 (3,707 차이)
- Finance 업로드 2026-09-30 합계 155,052 = 8월과 동일 수량, 단가만 변경 → 9월 수량 미갱신 파일이 검증 없이 업로드됨(2026-10-07 11:19)
- 시스템 거래 기준 8/31 155,052 + 9월 입고 45,956 − 9월 출고 80,458 = 120,550 ↔ Finance 9/30 155,052 (34,502 차이)
- 점검일 10-08 기준 202609 재고마감 미생성. 마감 행 클릭 시 품목 · 창고별 상세 없음, 창고별 마감 없음
- 관련 이슈 : 14(월마감 집계 트랜잭션 미연결) — 본 항목은 업로드 검증 · 3개 수치 대사 · 상세 조회 범위', '- Inventory Monthly Closing 202608 Closing Qty 151,345 ↔ Finance 업로드 2026-08-31 합계 155,052 (3,707 차이)
- Finance 업로드 2026-09-30 합계 155,052 = 8월과 동일 수량, 단가만 변경 → 9월 수량 미갱신 파일이 검증 없이 업로드됨(2026-10-07 11:19)
- 시스템 거래 기준 8/31 155,052 + 9월 입고 45,956 − 9월 출고 80,458 = 120,550 ↔ Finance 9/30 155,052 (34,502 차이)
- 점검일 10-08 기준 202609 재고마감 미생성. 마감 행 클릭 시 품목 · 창고별 상세 없음, 창고별 마감 없음
- 관련 이슈 : 14(월마감 집계 트랜잭션 미연결) — 본 항목은 업로드 검증 · 3개 수치 대사 · 상세 조회 범위', '- Inventory Monthly Closing 202608 Closing Qty 151.345 ↔ total upload Finance 2026-08-31 155.052 (selisih 3.707)
- Total upload Finance 2026-09-30 155.052 = kuantitas sama dengan Agustus, hanya harga berubah → file dengan kuantitas September belum diperbarui ter-upload tanpa validasi (2026-10-07 11:19)
- Basis transaksi sistem 31/8 155.052 + masuk Sept 45.956 − keluar Sept 80.458 = 120.550 ↔ Finance 30/9 155.052 (selisih 34.502)
- Per 10-08 closing 202609 belum dibuat. Klik baris closing tidak ada rincian per item · gudang, tidak ada closing per gudang
- Isu terkait : 14 (agregasi tutup bulan tidak terhubung transaksi) — item ini mencakup validasi upload · rekonsiliasi 3 angka · rincian',
  '- Finance 마감 CSV 업로드 시 전월 대비 수량 동일 · 합계 편차 N% 초과 · 시스템 재고와 차이 품목 수를 검증 리포트로 표시하고 확인 후 반영
- 월마감 생성 시 「재고마감 vs Finance vs 재고목록」 3원 대사표(품목별 차이) 자동 생성, 차이 0 또는 사유 입력 후 마감 확정
- 마감 행 → 품목 · 창고별 기초 · 입고 · 출고 · 조정 · 기말 상세 화면 추가, 마감 후 해당 월 전표 수정 잠금 규칙 명시', '- Finance 마감 CSV 업로드 시 전월 대비 수량 동일 · 합계 편차 N% 초과 · 시스템 재고와 차이 품목 수를 검증 리포트로 표시하고 확인 후 반영
- 월마감 생성 시 「재고마감 vs Finance vs 재고목록」 3원 대사표(품목별 차이) 자동 생성, 차이 0 또는 사유 입력 후 마감 확정
- 마감 행 → 품목 · 창고별 기초 · 입고 · 출고 · 조정 · 기말 상세 화면 추가, 마감 후 해당 월 전표 수정 잠금 규칙 명시', '- Saat upload CSV closing Finance tampilkan laporan validasi : kuantitas sama dengan bulan lalu · deviasi total > N% · jumlah item berbeda dari stok sistem, terapkan setelah dikonfirmasi
- Saat buat closing bulanan, otomatis buat tabel rekonsiliasi 「inventory closing vs Finance vs daftar stok」 (selisih per item), konfirmasi setelah selisih 0 atau alasan diinput
- Tambahkan layar rincian baris closing → awal · masuk · keluar · penyesuaian · akhir per item · gudang, tetapkan aturan penguncian dokumen bulan tersebut setelah closing',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '95' OR title_ko = '95. 월마감 수량 3원화 — 재고마감 · Finance 업로드 · 재고목록 상호 불일치, 업로드 데이터 검증 부재, 202609 마감 미생성, 상세 드릴다운 없음'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '95' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 96 ──
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
  '96', '96. Receipt History — TOTAL AMT IDR 산식 오류 (수입 건 PPh 22 차감 · PPN 수입 0) 및 금액 컬럼 정의 불명', '96. Receipt History — Rumus TOTAL AMT IDR Salah (Impor : PPh 22 Dikurangkan · PPN Impor 0) dan Definisi Kolom Nilai Tidak Jelas',
  'Purchasing', 'Reports > Receipt History', 'Reports > Receipt History', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '수입 11행 TOTAL = AMT − PPh22(22,837,012 − 599,955 = 22,237,057), PPN 0. PPh22 수입은 선납세금이라 차감 대상 아님. 로컬 JASA는 AMT + PPN − PPh23 → 같은 컬럼이 다른 의미', '11 baris impor TOTAL = AMT − PPh 22 (22.837.012 − 599.955 = 22.237.057), PPN 0. PPh 22 impor adalah pajak dibayar di muka sehingga bukan pengurang. JASA lokal AMT + PPN − PPh 23 → kolom yang sama berbeda arti',
  '공급가 · PPN · PPh(구분) · 공급사 지급액 · 재고 원가 산입액 컬럼 분리 및 산식 툴팁, 수입 PPN · PPh22는 Import Cost 실적과 연결(차감 아님)', 'Kolom DPP · PPN · PPh (dibedakan) · pembayaran ke pemasok · nilai masuk HPP dipisah dengan tooltip rumus, PPN · PPh 22 impor dihubungkan ke realisasi Import Cost (bukan pengurang)', '07 · 57', '개발부서 / Tim Pengembang',
  'Open', 'Lestari', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 수입 건(SH-20260814-002, 2026-09-23 입고 11행) TOTAL AMT IDR = AMT IDR − PPH (예 : 22,837,012 − 599,955.4 = 22,237,056.6), PPN 컬럼 0
- PPh 22 수입은 선납 법인세(추가 현금 지출)이므로 입고 금액에서 차감할 항목이 아님. PPN 수입(11%)도 미기록 → 수입 입고 금액 과소 · 세금 누락
- 로컬 JASA 건은 TOTAL = AMT + PPN − PPh 23 (공급사 지급액 기준)으로 계산 → 같은 컬럼이 수입 · 로컬에서 서로 다른 의미
- 리포트 컬럼이 「재고 입고 금액」인지 「공급사 지급 예정액」인지 정의 없음
- 관련 이슈 : 07(수입원가 PPN · PPh 22 산입), 57(세율 마스터)', '- 수입 건(SH-20260814-002, 2026-09-23 입고 11행) TOTAL AMT IDR = AMT IDR − PPH (예 : 22,837,012 − 599,955.4 = 22,237,056.6), PPN 컬럼 0
- PPh 22 수입은 선납 법인세(추가 현금 지출)이므로 입고 금액에서 차감할 항목이 아님. PPN 수입(11%)도 미기록 → 수입 입고 금액 과소 · 세금 누락
- 로컬 JASA 건은 TOTAL = AMT + PPN − PPh 23 (공급사 지급액 기준)으로 계산 → 같은 컬럼이 수입 · 로컬에서 서로 다른 의미
- 리포트 컬럼이 「재고 입고 금액」인지 「공급사 지급 예정액」인지 정의 없음
- 관련 이슈 : 07(수입원가 PPN · PPh 22 산입), 57(세율 마스터)', '- Impor (SH-20260814-002, 11 baris terima 2026-09-23) TOTAL AMT IDR = AMT IDR − PPH (contoh : 22.837.012 − 599.955,4 = 22.237.056,6), kolom PPN 0
- PPh 22 impor adalah PPh dibayar di muka (pengeluaran kas tambahan) sehingga bukan item yang dikurangkan dari nilai terima. PPN impor (11%) juga tidak tercatat → nilai terima impor terlalu rendah · pajak hilang
- JASA lokal dihitung TOTAL = AMT + PPN − PPh 23 (basis pembayaran ke pemasok) → kolom yang sama berbeda arti antara impor · lokal
- Tidak ada definisi apakah kolom laporan adalah 「nilai masuk stok」 atau 「jumlah yang akan dibayar ke pemasok」
- Isu terkait : 07 (PPN · PPh 22 masuk HPP impor), 57 (master tarif pajak)',
  '- 컬럼을 ① 공급가(DPP) ② PPN ③ PPh(원천징수 · 선납 구분) ④ 공급사 지급액 ⑤ 재고 원가 산입액으로 분리하고 각 산식을 헤더 툴팁에 명시
- 수입 건 PPN · PPh 22는 Import Cost(Customs) 실적값과 연결, 차감이 아닌 별도 표시', '- 컬럼을 ① 공급가(DPP) ② PPN ③ PPh(원천징수 · 선납 구분) ④ 공급사 지급액 ⑤ 재고 원가 산입액으로 분리하고 각 산식을 헤더 툴팁에 명시
- 수입 건 PPN · PPh 22는 Import Cost(Customs) 실적값과 연결, 차감이 아닌 별도 표시', '- Pisahkan kolom menjadi ① DPP ② PPN ③ PPh (dibedakan potong · bayar di muka) ④ pembayaran ke pemasok ⑤ nilai masuk HPP dan tuliskan rumus masing-masing di tooltip header
- PPN · PPh 22 impor dihubungkan ke nilai realisasi Import Cost (Customs), ditampilkan terpisah bukan dikurangkan',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '96' OR title_ko = '96. Receipt History — TOTAL AMT IDR 산식 오류 (수입 건 PPh 22 차감 · PPN 수입 0) 및 금액 컬럼 정의 불명'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '96' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 97 ──
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
  '97', '97. Receipt History — ARTICLE NO. 숫자 서식 적용(천 단위 구분) · Supplier 검색 미작동', '97. Receipt History — ARTICLE NO. Terformat Angka (Pemisah Ribuan) · Pencarian Supplier Tidak Berfungsi',
  'Purchasing', 'Reports > Receipt History', 'Reports > Receipt History', '오류 / Bug', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '숫자형 품번이 「10,220,075,110,163,000」으로 표시(Excel 정상), Supplier 입력란에 정확한 명칭 입력해도 382건 그대로 — 필터 미적용', 'Nomor artikel numerik tampil 「10,220,075,110,163,000」 (Excel normal), input nama Supplier yang tepat tetap 382 baris — filter tidak berlaku',
  'ARTICLE NO. 문자열 표시, Supplier 부분 일치 검색 결과 건수 감소 확인', 'ARTICLE NO. tampil sebagai teks, pencarian Supplier sebagian cocok mengurangi jumlah hasil', '101', '개발부서 / Tim Pengembang',
  'Open', 'Lestari', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 숫자형 품번이 「10,220,075,110,163,000」처럼 천 단위 구분기호로 표시(Excel 다운로드는 정상 「10220075110163000」)
- Supplier 입력란에 「HUBEI AULICE TYRE CO.,LTD」(정확한 명칭) 또는 「ARAMI」 입력 후 Search → 382건 그대로, 필터 미적용
- 날짜 표기가 dd-mm-yyyy(04-09-2026)로 타 화면(yyyy-mm-dd)과 상이 — 이슈 101 참조', '- 숫자형 품번이 「10,220,075,110,163,000」처럼 천 단위 구분기호로 표시(Excel 다운로드는 정상 「10220075110163000」)
- Supplier 입력란에 「HUBEI AULICE TYRE CO.,LTD」(정확한 명칭) 또는 「ARAMI」 입력 후 Search → 382건 그대로, 필터 미적용
- 날짜 표기가 dd-mm-yyyy(04-09-2026)로 타 화면(yyyy-mm-dd)과 상이 — 이슈 101 참조', '- Nomor artikel numerik tampil dengan pemisah ribuan seperti 「10,220,075,110,163,000」 (Excel download normal 「10220075110163000」)
- Input 「HUBEI AULICE TYRE CO.,LTD」 (nama tepat) atau 「ARAMI」 pada Supplier lalu Search → tetap 382 baris, filter tidak berlaku
- Format tanggal dd-mm-yyyy (04-09-2026) berbeda dari layar lain (yyyy-mm-dd) — lihat isu 101',
  '- ARTICLE NO. 컬럼을 문자열로 렌더링(숫자 포맷터 제외)
- Supplier 필터를 부분 일치(LIKE)로 수정하고 적용 여부 테스트 케이스 추가', '- ARTICLE NO. 컬럼을 문자열로 렌더링(숫자 포맷터 제외)
- Supplier 필터를 부분 일치(LIKE)로 수정하고 적용 여부 테스트 케이스 추가', '- Render kolom ARTICLE NO. sebagai string (kecualikan formatter angka)
- Ubah filter Supplier menjadi pencocokan sebagian (LIKE) dan tambahkan test case penerapannya',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '97' OR title_ko = '97. Receipt History — ARTICLE NO. 숫자 서식 적용(천 단위 구분) · Supplier 검색 미작동'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '97' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 98 ──
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
  '98', '98. Shipment History — 할인 컬럼 산식 오류 (U.PRICE AFT DC = UNIT PRICE, DISCOUNTED = AMOUNT, 할인 미반영)', '98. Shipment History — Rumus Kolom Diskon Salah (U.PRICE AFT DC = UNIT PRICE, DISCOUNTED = AMOUNT, Diskon Tidak Diterapkan)',
  'Sales', 'Reports > Shipment History', 'Reports > Shipment History', '오류 / Bug', 'S2 Major',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'Excel 1,588행 전부 U.PRICE AFT DC = UNIT PRICE, DISCOUNTED = AMOUNT인데 DC WITH PPN에 3~21% 값 826행 존재 → 할인 후 컬럼에 할인 미반영', 'Seluruh 1.588 baris Excel U.PRICE AFT DC = UNIT PRICE, DISCOUNTED = AMOUNT padahal DC WITH PPN berisi nilai 3~21% pada 826 baris → kolom setelah diskon tidak menerapkan diskon',
  'U.PRICE AFT DC = UNIT PRICE × (1 − DC RATE), DISCOUNTED = 할인 후 금액, 샘플 10건 SO · DN 할인값과 일치', 'U.PRICE AFT DC = UNIT PRICE × (1 − DC RATE), DISCOUNTED = nilai setelah diskon, 10 sampel sama dengan nilai diskon SO · DN', '54 · 55', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- Excel 1,588행 전수 검산 : U.PRICE AFT DC가 UNIT PRICE와 전부 동일, DISCOUNTED가 AMOUNT와 전부 동일(차이 0행)
- 반면 DC WITH PPN 컬럼에는 AMOUNT의 3 · 5 · 8 · 10 · 13 · 15 · 21% 값이 826행 존재 → 할인이 기록되어 있으나 「할인 후」 컬럼에 미반영
- DC WITH PPN의 정의(할인액 × 1.11인지, 할인율인지) 헤더만으로 판단 불가', '- Excel 1,588행 전수 검산 : U.PRICE AFT DC가 UNIT PRICE와 전부 동일, DISCOUNTED가 AMOUNT와 전부 동일(차이 0행)
- 반면 DC WITH PPN 컬럼에는 AMOUNT의 3 · 5 · 8 · 10 · 13 · 15 · 21% 값이 826행 존재 → 할인이 기록되어 있으나 「할인 후」 컬럼에 미반영
- DC WITH PPN의 정의(할인액 × 1.11인지, 할인율인지) 헤더만으로 판단 불가', '- Cek seluruh 1.588 baris Excel : U.PRICE AFT DC semuanya sama dengan UNIT PRICE, DISCOUNTED semuanya sama dengan AMOUNT (0 baris berbeda)
- Sebaliknya kolom DC WITH PPN berisi nilai 3 · 5 · 8 · 10 · 13 · 15 · 21% dari AMOUNT pada 826 baris → diskon tercatat tetapi tidak diterapkan pada kolom 「setelah diskon」
- Definisi DC WITH PPN (nilai diskon × 1,11 atau tarif diskon) tidak dapat dipastikan dari header',
  '- U.PRICE AFT DC = UNIT PRICE × (1 − DC RATE), DISCOUNTED = 할인 후 금액, DC AMT · DC WITH PPN 분리 표기로 산식 수정
- SO · DN 전표의 할인 값과 리포트 값 일치 여부를 샘플 10건으로 검수', '- U.PRICE AFT DC = UNIT PRICE × (1 − DC RATE), DISCOUNTED = 할인 후 금액, DC AMT · DC WITH PPN 분리 표기로 산식 수정
- SO · DN 전표의 할인 값과 리포트 값 일치 여부를 샘플 10건으로 검수', '- Perbaiki rumus : U.PRICE AFT DC = UNIT PRICE × (1 − DC RATE), DISCOUNTED = nilai setelah diskon, DC AMT · DC WITH PPN ditampilkan terpisah
- Verifikasi 10 sampel kesesuaian nilai diskon dokumen SO · DN dengan laporan',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '98' OR title_ko = '98. Shipment History — 할인 컬럼 산식 오류 (U.PRICE AFT DC = UNIT PRICE, DISCOUNTED = AMOUNT, 할인 미반영)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '98' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 99 ──
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
  '99', '99. Shipment History — 전표 번호(SO · DO · DN) · PPN · 총액 컬럼 부재, 창고 · 고객 필터 없음', '99. Shipment History — Kolom Nomor Dokumen (SO · DO · DN) · PPN · Total Belum Ada, Tidak Ada Filter Gudang · Pelanggan',
  'Sales', 'Reports > Shipment History', 'Reports > Shipment History', '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '컬럼에 CUSTOMER PO만 있고 SO · DO · DN 번호 · PPN · 총액 없음(Receipt History와 비대칭), 필터는 기간만 존재', 'Kolom hanya CUSTOMER PO tanpa nomor SO · DO · DN · PPN · total (tidak simetris dengan Receipt History), filter hanya periode',
  'ORDER NO. · DO NO. · DN NO. · PPN · TOTAL 컬럼 및 창고 · 고객 · 품목 필터 추가', 'Kolom ORDER NO. · DO NO. · DN NO. · PPN · TOTAL serta filter gudang · pelanggan · item ditambahkan', '54 · 55 · 56 · 64', '개발부서 / Tim Pengembang',
  'Open', 'Merry', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 컬럼에 CUSTOMER PO만 있고 SO · DO · DN 번호가 없어 전표 추적 · 대사 불가
- PPN · 총액(incl. PPN) 컬럼이 없어 매출 집계 · 세금계산서 대사 불가(Receipt History에는 PPN · TOTAL 존재 → 입 · 출고 리포트 비대칭)
- 필터가 기간만 존재, 창고 · 고객 · 품목 필터 없음(Receipt History는 창고 · 공급사 필터 보유)
- 관련 이슈 : 54 · 55 · 56(보고서 양식), 64(Invoice 화면)', '- 컬럼에 CUSTOMER PO만 있고 SO · DO · DN 번호가 없어 전표 추적 · 대사 불가
- PPN · 총액(incl. PPN) 컬럼이 없어 매출 집계 · 세금계산서 대사 불가(Receipt History에는 PPN · TOTAL 존재 → 입 · 출고 리포트 비대칭)
- 필터가 기간만 존재, 창고 · 고객 · 품목 필터 없음(Receipt History는 창고 · 공급사 필터 보유)
- 관련 이슈 : 54 · 55 · 56(보고서 양식), 64(Invoice 화면)', '- Kolom hanya CUSTOMER PO tanpa nomor SO · DO · DN sehingga penelusuran · rekonsiliasi dokumen tidak dapat dilakukan
- Tidak ada kolom PPN · total (incl. PPN) sehingga agregasi penjualan · rekonsiliasi faktur pajak tidak dapat dilakukan (Receipt History punya PPN · TOTAL → laporan masuk · keluar tidak simetris)
- Filter hanya periode, tidak ada filter gudang · pelanggan · item (Receipt History punya filter gudang · pemasok)
- Isu terkait : 54 · 55 · 56 (format laporan), 64 (layar Invoice)',
  '- ORDER NO. · DO NO. · DN NO. · PPN · TOTAL(incl. PPN) 컬럼 추가, Receipt History와 컬럼 체계 대칭화
- 창고 · 고객 · 품목 필터 추가', '- ORDER NO. · DO NO. · DN NO. · PPN · TOTAL(incl. PPN) 컬럼 추가, Receipt History와 컬럼 체계 대칭화
- 창고 · 고객 · 품목 필터 추가', '- Tambahkan kolom ORDER NO. · DO NO. · DN NO. · PPN · TOTAL (incl. PPN), samakan struktur kolom dengan Receipt History
- Tambahkan filter gudang · pelanggan · item',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '99' OR title_ko = '99. Shipment History — 전표 번호(SO · DO · DN) · PPN · 총액 컬럼 부재, 창고 · 고객 필터 없음'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '99' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 100 ──
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
  '100', '100. 직원 명부 — HP NO. 앞자리 0 탈락 (숫자형 저장)', '100. Direktori Staf — Angka 0 di Depan HP NO. Hilang (Disimpan Sebagai Numerik)',
  'Settings', 'Staff Directory', 'Settings > Staff Directory', '데이터정비 / Perapian Data', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', 'HP NO.가 「8569869885」처럼 선행 0 없이 표시(고객 마스터 08123019895는 정상) — 숫자형 저장으로 추정', 'HP NO. tampil tanpa 0 di depan seperti 「8569869885」 (master pelanggan 08123019895 normal) — diduga disimpan sebagai numerik',
  '전화번호 문자열 저장, 기존 데이터 0 복원, 표기 규칙(+62 / 0) 통일', 'Nomor telepon disimpan sebagai teks, 0 pada data lama dipulihkan, aturan penulisan (+62 / 0) diseragamkan', '21', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- HP NO.가 「8569869885」 「81902129706」처럼 선행 0 없이 표시 — 고객 마스터 PHONE NO.(08123019895)는 정상
- 숫자형 컬럼 저장으로 인한 선행 0 손실로 추정. 출력물 · 연락처 활용 시 번호 오류
- 관련 이슈 : 21(DEPARTMENT 값 표준화)', '- HP NO.가 「8569869885」 「81902129706」처럼 선행 0 없이 표시 — 고객 마스터 PHONE NO.(08123019895)는 정상
- 숫자형 컬럼 저장으로 인한 선행 0 손실로 추정. 출력물 · 연락처 활용 시 번호 오류
- 관련 이슈 : 21(DEPARTMENT 값 표준화)', '- HP NO. tampil tanpa 0 di depan seperti 「8569869885」 「81902129706」 — PHONE NO. master pelanggan (08123019895) normal
- Diduga 0 di depan hilang karena kolom numerik. Nomor salah saat dipakai di cetakan · kontak
- Isu terkait : 21 (standardisasi nilai DEPARTMENT)',
  '- 전화번호 컬럼을 문자열로 변경하고 기존 데이터에 0 복원, 입력 시 +62 / 0 표기 규칙 통일', '- 전화번호 컬럼을 문자열로 변경하고 기존 데이터에 0 복원, 입력 시 +62 / 0 표기 규칙 통일', '- Ubah kolom telepon menjadi string dan pulihkan 0 pada data lama, seragamkan aturan +62 / 0 saat input',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '100' OR title_ko = '100. 직원 명부 — HP NO. 앞자리 0 탈락 (숫자형 저장)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '100' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 101 ──
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
  '101', '101. 전 화면 — 날짜 · 금액 표기 형식 화면 간 혼재 (yyyy-mm-dd · mm/dd/yyyy · dd-mm-yyyy · yyyy. mm. dd. / 1,000 · 1.000)', '101. Semua Layar — Format Tanggal · Nilai Tidak Seragam Antar Layar (yyyy-mm-dd · mm/dd/yyyy · dd-mm-yyyy · yyyy. mm. dd. / 1,000 · 1.000)',
  '공통 / Umum', '날짜 · 숫자 표기 / Format Tanggal · Angka', '전 화면 / Semua layar', '개선 / Perbaikan', 'S3 Minor',
  '오픈 前 필수 / Wajib Sebelum Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '날짜 4종(목록 2026-10-06 · 상세 10/01/2026 · SO 2026. 10. 08. · 리포트 04-09-2026), 금액 2종(목록 73,116,069 · 상세 3.249.960) 혼재 — 이슈 22 REJECTED와 별개로 「한 가지로 통일」 요청', '4 format tanggal (daftar 2026-10-06 · detail 10/01/2026 · SO 2026. 10. 08. · laporan 04-09-2026) dan 2 format nilai (daftar 73,116,069 · detail 3.249.960) bercampur — terlepas dari isu 22 REJECTED, diminta 「diseragamkan satu format」',
  '전 화면 · 출력물 · Excel 날짜 yyyy-mm-dd, 금액 1종 포맷터로 통일, 브라우저 로캘 의존 없음', 'Semua layar · cetakan · Excel memakai tanggal yyyy-mm-dd dan satu formatter nilai, tidak bergantung locale browser', '15 · 22', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 목록 화면 2026-10-06, Receipt 상세 PO DATE 10/01/2026(mm/dd), SO 상세 ORDER DATE 2026. 10. 08.(한국어 로캘), 리포트 04-09-2026(dd-mm) → 4종 혼재
- 금액 : 목록 「IDR 73,116,069」(쉼표) vs 상세 「3.249.960」(마침표) → 같은 모듈 내 혼재
- 이슈 22(인도네시아식 표기 적용)는 REJECTED — 본 항목은 어느 방식이든 「한 가지로 통일」 요청', '- 목록 화면 2026-10-06, Receipt 상세 PO DATE 10/01/2026(mm/dd), SO 상세 ORDER DATE 2026. 10. 08.(한국어 로캘), 리포트 04-09-2026(dd-mm) → 4종 혼재
- 금액 : 목록 「IDR 73,116,069」(쉼표) vs 상세 「3.249.960」(마침표) → 같은 모듈 내 혼재
- 이슈 22(인도네시아식 표기 적용)는 REJECTED — 본 항목은 어느 방식이든 「한 가지로 통일」 요청', '- Daftar 2026-10-06, PO DATE detail Receipt 10/01/2026 (mm/dd), ORDER DATE detail SO 2026. 10. 08. (locale Korea), laporan 04-09-2026 (dd-mm) → 4 format bercampur
- Nilai : daftar 「IDR 73,116,069」 (koma) vs detail 「3.249.960」 (titik) → bercampur dalam modul yang sama
- Isu 22 (penerapan format Indonesia) REJECTED — item ini meminta 「diseragamkan satu format」 apa pun pilihannya',
  '- 날짜 yyyy-mm-dd, 금액 천 단위 쉼표(또는 결정된 1안)로 전 화면 · 출력물 · Excel 공통 포맷터 적용, 브라우저 로캘 의존 제거', '- 날짜 yyyy-mm-dd, 금액 천 단위 쉼표(또는 결정된 1안)로 전 화면 · 출력물 · Excel 공통 포맷터 적용, 브라우저 로캘 의존 제거', '- Terapkan formatter bersama untuk semua layar · cetakan · Excel : tanggal yyyy-mm-dd, nilai pemisah ribuan koma (atau opsi yang diputuskan), hilangkan ketergantungan locale browser',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '101' OR title_ko = '101. 전 화면 — 날짜 · 금액 표기 형식 화면 간 혼재 (yyyy-mm-dd · mm/dd/yyyy · dd-mm-yyyy · yyyy. mm. dd. / 1,000 · 1.000)'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '101' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 102 ──
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
  '102', '102. Excel 다운로드 — 헤더 오타(Categroy2) · 화면과 Excel 컬럼 구성 불일치', '102. Excel Download — Salah Ketik Header (Categroy2) · Susunan Kolom Layar dan Excel Tidak Sama',
  '공통 / Umum', 'Excel 다운로드 / Excel Download', 'Inventory > Inventory List · Master Data > Products (Excel)', '오류 / Bug', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-10-08', '재고 · 제품 Excel 헤더 「Categroy2」 오타, 재고 Excel에 Receipt Qty 없고 ArticleNo · UnitCost는 Excel에만, 제품 Excel에 Article No · HS Code · USD Price 없음', 'Header Excel stok · produk salah ketik 「Categroy2」, Excel stok tanpa Receipt Qty sedangkan ArticleNo · UnitCost hanya di Excel, Excel produk tanpa Article No · HS Code · USD Price',
  '헤더 오타 수정, 화면 컬럼 = Excel 컬럼(추가 컬럼은 화면에도 표시 또는 상세 Excel로 명시)', 'Salah ketik header diperbaiki, kolom layar = kolom Excel (kolom tambahan juga tampil di layar atau dinyatakan sebagai Excel rinci)', '50', '개발부서 / Tim Pengembang',
  'Open', 'SEO', '미회신 / Belum Ada Balasan', 'PENDING',
  '- 재고 목록 · 제품 목록 Excel 헤더 「Categroy2」 오타(Category2)
- 재고 목록 : 화면에 있는 Receipt Date · Receipt Qty가 Excel에는 Receipt Qty 없음, Excel에만 ArticleNo · UnitCost 존재
- 제품 목록 : 화면의 Article No · HS Code · USD Price가 Excel에 없음
- 관련 이슈 : 50(재고 Excel 파일명 · 조회 기준 미표기)', '- 재고 목록 · 제품 목록 Excel 헤더 「Categroy2」 오타(Category2)
- 재고 목록 : 화면에 있는 Receipt Date · Receipt Qty가 Excel에는 Receipt Qty 없음, Excel에만 ArticleNo · UnitCost 존재
- 제품 목록 : 화면의 Article No · HS Code · USD Price가 Excel에 없음
- 관련 이슈 : 50(재고 Excel 파일명 · 조회 기준 미표기)', '- Header Excel daftar stok · daftar produk salah ketik 「Categroy2」 (Category2)
- Daftar stok : Receipt Date · Receipt Qty ada di layar tetapi Receipt Qty tidak ada di Excel, ArticleNo · UnitCost hanya ada di Excel
- Daftar produk : Article No · HS Code · USD Price di layar tidak ada di Excel
- Isu terkait : 50 (nama file · dasar query Excel stok tidak tercantum)',
  '- 헤더 오타 수정, 화면 컬럼 = Excel 컬럼 원칙 적용(추가 컬럼은 화면에도 표시 또는 「상세 Excel」로 명시)', '- 헤더 오타 수정, 화면 컬럼 = Excel 컬럼 원칙 적용(추가 컬럼은 화면에도 표시 또는 「상세 Excel」로 명시)', '- Perbaiki salah ketik header, terapkan prinsip kolom layar = kolom Excel (kolom tambahan juga ditampilkan di layar atau dinyatakan sebagai 「Excel rinci」)',
  false, '261008-doc2'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE NOT is_archived AND (issue_no = '102' OR title_ko = '102. Excel 다운로드 — 헤더 오타(Categroy2) · 화면과 Excel 컬럼 구성 불일치'));

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-08', 'PENDING', '최초 접수', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', '최초 접수 — 2026-10-08 ASM 시스템 직접 점검(SEO, 총괄팀) · 261008 개선요청서 수록(84~102)', 'Diterima pertama kali — pemeriksaan sistem ASM 2026-10-08 (SEO, Tim Umum) · dimuat di dokumen usulan 261008 (84~102)', i.it_status, '261008-doc2'
  FROM public.csr_issues i
 WHERE i.issue_no = '102' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.created_by = '261008-doc2');

-- ── 확인 ─────────────────────────────────────────────────────────────────────
-- ① 신규 84~102 (기대 : 19행, Open · PENDING · 미회신)
SELECT issue_no, title_ko, priority, go_live_category, it_pic, it_status, it_decision, verification_result
  FROM public.csr_issues WHERE issue_no IN ('84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102') AND NOT is_archived ORDER BY issue_no::int;
-- ② 최초 접수 검증 이력 (기대 : 19행)
SELECT i.issue_no, v.verified_on, v.result, v.note_ko
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE v.created_by = '261008-doc2' ORDER BY i.issue_no::int;
-- ③ 번호 중복 점검 (기대 : 0행)
SELECT issue_no, count(*) FROM public.csr_issues WHERE NOT is_archived GROUP BY issue_no HAVING count(*) > 1;
-- ④ 심각도 분포 (기대 : S1 1 · S2 7 · S3 11)
SELECT priority, count(*) FROM public.csr_issues WHERE issue_no IN ('84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102') AND NOT is_archived GROUP BY priority ORDER BY priority;
