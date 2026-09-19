-- =============================================================================
-- ASM CSR — 검증 이력 KO/ID 쌍 일괄 보강 (2026-09-19) — 사이트 「검증 추가」 입력분 2026-09-18 · 19행
--   030 적용 후 실행. 재실행 안전(같은 값 덮어씀). 달러 인용 없음. 031 을 포함하므로 031 은 생략 가능.
--   대상: csr_verifications.note_ko / note_id 만 갱신 — 원문 note · result · verified_on · 헤더 속성은 손대지 않음.
--   키: 이슈번호 + 일자 + 결과 코드(같은 날 다른 결과의 행 — 02 Lestari PENDING, 07·10 Lestari 09-15 ACCEPTED — 는 영향 없음).
--   한국어 번역: Claude(검수 서종환). 인니어는 사이트 원문에서 한국어 괄호 요약을 뗀 것.
--   Lestari · Lia · Merry 가 09-15 ~ 09-18 에 직접 입력한 행은 원문을 알 수 없어 제외 — 032 결과로 후속 작성.
-- =============================================================================
SELECT set_config('csr.actor', 'migration:033 (2026-09-19 검증 이력 KO/ID 보강)', false);

-- ── 02 · 2026-09-18 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] PO 목록 AMOUNT 열에 통화코드 표시(USD 15,800.00 · IDR 794,504,700.00) 및 LOCAL/IMPORT 필터 제공 확인, SO 목록도 IDR 접두 표기 — 최초 요청 충족. Lestari의 09-18 사이트 메모(공장 발송 PO 출력물 통화 기호)는 별도 요청으로 처리.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Daftar PO kini menampilkan kode mata uang pada kolom AMOUNT (USD 15,800.00 · IDR 794,504,700.00) dan tersedia filter LOCAL/IMPORT; daftar SO juga berawalan IDR — permintaan awal terpenuhi. Catatan Lestari di situs CSR 09-18 (tanda mata uang pada cetakan PO ke factory) ditangani sebagai permintaan terpisah.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '02' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'ACCEPTED';

-- ── 07 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Import Cost SHP-20260427-001 ACTUAL 탭: Total Import Cost IDR 91,309,000 = Tax Total 87,809,000(BM + PPN + PPh) + Etc 3,500,000 → PPN·PPh가 총액에 여전히 포함, Cash-out vs Landed Cost 구분 표시 없음. Lestari가 사이트에 기록한 ACCEPTED(09-15, 내용 없음)는 실제 화면과 불일치 — NOT APPLIED로 정정.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Import Cost SHP-20260427-001 tab ACTUAL: Total Import Cost IDR 91,309,000 = Tax Total 87,809,000 (BM + PPN + PPh) + Etc 3,500,000 → PPN·PPh masih termasuk dalam total; tampilan Cash-out vs Landed Cost belum ada. Hasil ACCEPTED yang dicatat Lestari di situs CSR (09-15, tanpa keterangan) tidak sesuai layar aktual — dikembalikan ke NOT APPLIED.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '07' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 09 · 2026-09-18 · PARTIAL ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Import Cost SHP-20260427-001 ACTUAL 탭에 3. Bea Masuk · 4. PPN 11% · 5. PPH 7.5% IDR 입력란 존재하나 값은 공란이며 Tax Total(IDR 87,809,000)은 ESTIMATED 값을 상속. PIB 번호 · 납부일란 없음. 부분 반영 — PARTIAL 유지.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Import Cost SHP-20260427-001 tab ACTUAL memiliki kolom input IDR untuk 3. Bea Masuk · 4. PPN 11% · 5. PPH 7.5%, namun nilainya masih kosong dan Tax Total (IDR 87,809,000) mewarisi nilai ESTIMATED; kolom No. PIB · tanggal bayar belum ada. Sebagian diterapkan — tetap PARTIAL.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '09' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'PARTIAL';

-- ── 10 · 2026-09-18 · PARTIAL ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Customs Clearance(CUSTM-20260908-001)에 EXCHANGE RATE(KMK) 17,500 · EXCHANGE DATE 2026-09-08 표시 확인. Import Cost 화면(목록 · 상세 SHP-20260427-001)에는 KMK 환율 · 적용 주차 미표시 — 수용기준 부분 충족. Lestari의 사이트 ACCEPTED(09-15)는 실제 화면 기준 PARTIAL로 조정.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Customs Clearance (CUSTM-20260908-001) menampilkan EXCHANGE RATE (KMK) 17,500 dan EXCHANGE DATE 2026-09-08; layar Import Cost (daftar · detail SHP-20260427-001) masih belum menampilkan kurs KMK maupun minggu berlaku — kriteria penerimaan terpenuhi sebagian. Lestari mencatat ACCEPTED di situs CSR 09-15; disesuaikan menjadi PARTIAL mengikuti layar aktual.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '10' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'PARTIAL';

-- ── 11 · 2026-09-18 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] 견적 목록 337건 전건 SALES REP 기재(ARIF WIBOWO · HERY · ACHMAD RIZKI FIRDAUS 등) 및 저장 정상, 견적에서 SO · DN 발행 확인(OD-20260918-303 등). Merry의 사이트 ACCEPTED(09-16) — 노션 동기화.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Daftar Penawaran 337 dokumen, seluruhnya memiliki SALES REP (ARIF WIBOWO · HERY · ACHMAD RIZKI FIRDAUS dll.) dan tersimpan; SO · DN diterbitkan dari penawaran (OD-20260918-303 dst.). Merry mencatat ACCEPTED di situs CSR 09-16 — disinkronkan ke Notion.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '11' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'ACCEPTED';

-- ── 13 · 2026-09-18 · REJECTED ──
UPDATE public.csr_verifications v
   SET note_ko = '[수동 점검 2026-09-18 · SEO] 실서버 불일치 재현: SO OD-20260918-303 IDR 84,457,984.00 vs 견적 QT-20260918-337 IDR 84,457,984.58, SO OD-20260918-298 IDR 92,722,548.00 vs DN-20260918-257 IDR 92,722,547.97(MSTI/ASC/18/09/2026/002). DN 목록 소수점 2자리 존치, 견적→SO 반올림 규칙 불일치 지속.',
       note_id = '[Pemeriksaan manual 2026-09-18 · SEO] Masih tidak sesuai di server produksi: SO OD-20260918-303 IDR 84,457,984.00 vs Penawaran QT-20260918-337 IDR 84,457,984.58; SO OD-20260918-298 IDR 92,722,548.00 vs DN-20260918-257 IDR 92,722,547.97 (MSTI/ASC/18/09/2026/002). Daftar DN masih 2 desimal, pembulatan Penawaran→SO tetap tidak konsisten.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '13' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'REJECTED';

-- ── 18 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Partners > Suppliers: JK TYRE & INDUSTIRES LTD의 COUNTRY = CHINA 오등록 잔존(INDIA가 정확), 공급사명 오타 잔존. COUNTRY 열 표준화(드롭다운/검증) 미적용. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Partners > Suppliers: JK TYRE & INDUSTIRES LTD masih tercatat COUNTRY = CHINA (seharusnya INDIA), nama pemasok masih salah ketik; kolom COUNTRY belum distandarkan (dropdown/validasi). Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '18' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 40 · 2026-09-18 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Receipt 화면(RCPT-20260918-053 / PO HT-20260917-008)에 PO. INFO 블록과 REMARK 필드(읽기전용)가 추가되어 구매 PO의 Remark 값을 상속함. Lia의 09-15 확인 내용(GRPO 출력물 PO Remark 행 포함) 타당성 확인 — ASM 실측.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Layar Receipt (RCPT-20260918-053 / PO HT-20260917-008) kini memiliki blok PO. INFO dengan field REMARK (read-only) yang mewarisi Remark Purchase PO. Konfirmasi Lia 09-15 (termasuk baris PO Remark pada cetakan GRPO) dibenarkan — pengukuran aktual di ASM.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '40' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'ACCEPTED';

-- ── 44 · 2026-09-18 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Receipt 목록에 SJL NO. 열 추가(예: RCPT-20260918-053 → 08ASC260918, RCPT-20260917-055 → ARP 660) 및 상세 화면 SURAT JALAN NO. 필드 표시 확인. 요청자 Lia가 GRPO 출력물 확인 후 사이트에 ACCEPTED 기록(2026-09-16) — 노션 동기화.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Daftar Receipt kini memiliki kolom SJL NO. (mis. RCPT-20260918-053 → 08ASC260918, RCPT-20260917-055 → ARP 660) dan layar detail menampilkan field SURAT JALAN NO. Lia (pengusul) mencatat ACCEPTED di situs CSR pada 2026-09-16 setelah memeriksa cetakan GRPO — disinkronkan ke Notion.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '44' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'ACCEPTED';

-- ── 52 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] 실서버 Inventory 메뉴는 INVENTORY LIST · MONTHLY INVENTORY CLOSING 2종만 존재 — 지점 간(Semarang · Surabaya) 재고 이동 메뉴(Inventory Movement) 부재. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu Inventory pada server produksi hanya berisi INVENTORY LIST · MONTHLY INVENTORY CLOSING — menu Inventory Movement (mutasi antar cabang Semarang · Surabaya) belum ada. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '52' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 53 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] 실서버 Inventory 메뉴는 INVENTORY LIST · MONTHLY INVENTORY CLOSING만 존재 — 월별 재고 실사(Stock Opname) 결과 입력 메뉴 부재. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu Inventory pada server produksi hanya INVENTORY LIST · MONTHLY INVENTORY CLOSING — menu input hasil Stock Opname bulanan belum ada. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '53' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 59 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Purchase 메뉴(PURCHASE PO · PPC · SHIPMENT · CUSTOMS · WAREHOUSE RECEIPT · RECEIPT · IMPORT COST · SUPPLIER RETURN · CREDIT NOTE) 및 Master Data에 수입 대금 지급 계획(Payment Plan) 화면 부재. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu Purchase (PURCHASE PO · PPC · SHIPMENT · CUSTOMS · WAREHOUSE RECEIPT · RECEIPT · IMPORT COST · SUPPLIER RETURN · CREDIT NOTE) dan Master Data tidak memiliki layar Payment Plan pembayaran impor. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '59' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 63 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] 실서버 대메뉴: Purchase · Sales · Inventory · Partners · Master Data · Settings — Finance 대메뉴 부재, 메뉴 순서 미조정. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu utama server produksi: Purchase · Sales · Inventory · Partners · Master Data · Settings — menu utama Finance belum ada, urutan menu belum disusun ulang. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '63' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 64 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Finance 대메뉴 부재로 Finance > Invoice 화면(세금계산서 번호 · 발송 · 수령 · 어음 만기 · 판매 리포트) 미제공. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu utama Finance belum ada sehingga layar Finance > Invoice (nomor faktur pajak · pengiriman · penerimaan · jatuh tempo giro · laporan penjualan) belum tersedia. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '64' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 65 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Finance 대메뉴 부재 — Finance > Income 화면(입금 기록 · 지연 분석 · 어음 모니터링) 미제공. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu utama Finance belum ada — layar Finance > Income (pencatatan penerimaan · analisis keterlambatan · monitoring giro) belum tersedia. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '65' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 66 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Finance 대메뉴 부재 — Finance > AR 화면(미수금 변동 · 잔액 · Aging · 연체 분석) 미제공. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu utama Finance belum ada — layar Finance > AR (mutasi piutang · saldo · Aging · analisis tunggakan) belum tersedia. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '66' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 67 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Finance 대메뉴 부재 — Finance > Income Plan 화면(만기 기준 주간 입금 계획 · 조정 · 현금 판매 추정) 미제공. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu utama Finance belum ada — layar Finance > Income Plan (rencana penerimaan mingguan berdasarkan jatuh tempo · penyesuaian · estimasi penjualan tunai) belum tersedia. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '67' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 68 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Finance 대메뉴 부재 — Finance > IPR 화면(Income Plan & Realization: 입금 계획 대비 실적 · 미실현 사유 · 조치 계획) 미제공. 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Menu utama Finance belum ada — layar Finance > IPR (Income Plan & Realization: rencana vs realisasi penerimaan · alasan belum terealisasi · rencana tindakan) belum tersedia. Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '68' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 69 · 2026-09-18 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '[점검 2026-09-18 · SEO] Inventory > Inventory List: Category 2/3/4 필터 선택지 중복 잔존 — Cat2 19개(중복 10, Light Truck(LT) ×3), Cat3 35개(중복 25, Radial/Bias/HD/STD 반복), Cat4 21개(중복 16, TT/TL 반복). 미조치.',
       note_id = '[Pemeriksaan 2026-09-18 · SEO] Inventory > Inventory List: filter Category 2/3/4 masih menampilkan opsi ganda — Cat2 19 opsi (10 duplikat, Light Truck(LT) ×3), Cat3 35 opsi (25 duplikat, Radial/Bias/HD/STD berulang), Cat4 21 opsi (16 duplikat, TT/TL berulang). Belum diterapkan.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND i.issue_no = '69' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-09-18' AND v.result = 'NOT APPLIED';

-- ── 확인: 대상 19행이 모두 KO(한글 포함)·ID(한글 없음) 인지 ──
SELECT i.issue_no, v.verified_on, v.result,
       (v.note_ko ~ '[가-힣]') AS ko_ok, (v.note_id !~ '[가-힣]') AS id_ok
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE NOT i.is_archived AND v.verified_on >= DATE '2026-09-10'
   AND v.verified_on = DATE '2026-09-18'
 ORDER BY i.issue_no, v.verified_on;
