-- =============================================================================
-- ASM CSR — 검증 이력 KO/ID 쌍 보강 2차 (2026-09-19) — 인니어로 입력된 10행
--   033 적용 후 실행. 재실행 안전(같은 값 덮어씀). 달러 인용 없음.
--   대상: csr_verifications.note_ko / note_id 만 갱신 — 원문 note · result · verified_on · 헤더 속성은 손대지 않음.
--   키: 032 결과가 알려준 verif_id(v.id). 이슈번호를 AND 조건으로 함께 걸어, 행이 바뀌었으면
--        조용히 엉뚱한 행을 고치는 대신 0행 갱신으로 드러나게 했습니다.
--   출처: 032 표 2 의 10행 — note_ko · note_id 가 둘 다 비어 있고 인니어 원문 note 만 있던 행.
--        note_id 에는 원문을 그대로(오타·표기 포함 — §8 정규화 금지), note_ko 에는 번역을 넣습니다.
--   한국어 번역: Claude(검수 서종환).
--   032 표 2 의 14(186) · 15(195)는 손대지 않습니다 — 인니어 본문이 한국어 UI 문구
--        ('----년 --월')를 인용해 WRONG_LANG 으로 잡힌 오탐입니다.
-- =============================================================================
SELECT set_config('csr.actor', 'migration:035 (2026-09-19 검증 이력 KO/ID 보강 2차)', false);

-- ── 02 · verif_id 284 · 2026-09-18 · PENDING (Lestari) ──
UPDATE public.csr_verifications v
   SET note_ko = '공급사/공장으로 보내는 PO 에 통화(CURRENCY) 열·기호 추가가 필요합니다. 이전에 중국 공장으로 보내던 수기 PO 는 FOB 단가와 총액에 $ 180 처럼 통화 기호를 표시했습니다.',
       note_id = 'Penambahan kolom/Tanda CURRENCY diperlukan untuk PO ke Suplplier/Factory. PO manual sebelumnya yang kami kirim Ke factory china menampilkan tanda Currency di harga fob dan total amount seperti $ 180.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 284 AND i.issue_no = '02';

-- ── 08 · verif_id 256 · 2026-09-10 · REJECTED ──
UPDATE public.csr_verifications v
   SET note_ko = 'Import Cost 목록은 현재 1건(SHP-20260427-001 / PO HA-20260527-001). ESTIMATED·ACTUAL 탭 모두 선적 단위 COST ITEMS 10행만 보여 주고, SKU 별 비용 열·탭(Landed_unit_cost)이 없습니다. 수용기준 (1) SKU 별 Landed_unit_cost 표시 (2) 배부 기준(CIF/중량/수량) 문서화 — 둘 다 미충족. COMPLETED 상태는 맞지 않으니 ONGOING 으로 되돌려 주시기 바랍니다.',
       note_id = 'Daftar Import Cost kini 1 record (SHP-20260427-001 / PO HA-20260527-001). Tab ESTIMATED dan ACTUAL hanya menampilkan 10 baris COST ITEMS per shipment; tidak ada kolom/tab biaya per SKU (Landed_unit_cost). Kriteria penerimaan (1) tampilan Landed_unit_cost per SKU (2) dokumentasi dasar alokasi (CIF/berat/qty) keduanya belum terpenuhi. Status COMPLETED tidak sesuai; mohon dikembalikan ke ONGOING.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 256 AND i.issue_no = '08';

-- ── 09 · verif_id 261 · 2026-09-10 · PARTIAL ──
UPDATE public.csr_verifications v
   SET note_ko = 'Purchase > Import Cost > ACTUAL 탭에 세금 3개 항목(Bea Masuk, PPN, PPh 22)의 IDR 입력란과, 나머지 5개 비용 항목(PLB Handling, PLB Reimbursement, Inland Transport, LS, Miscellaneous)의 Billing vendor / Invoice no. / Invoice date 열이 생겼습니다. 미검증: 실제 값이 저장되는지, 그리고 Total Import Cost 에 반영되는지(시험 데이터를 입력하지 않음).',
       note_id = 'Purchase > Import Cost > tab ACTUAL kini menyediakan kolom input IDR untuk 3 pos pajak (Bea Masuk, PPN, PPh 22) dan kolom Billing vendor / Invoice no. / Invoice date untuk 5 pos biaya lain (PLB Handling, PLB Reimbursement, Inland Transport, LS, Miscellaneous). Belum diverifikasi: penyimpanan nilai aktual dan pengaruhnya ke Total Import Cost (data uji tidak diinput).'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 261 AND i.issue_no = '09';

-- ── 10 · verif_id 270 · 2026-09-11 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = '2026-09-11 실서버 점검: Import Cost 목록이 1건(SHP-20260427-001 / PO HA-20260527-001)이 되어 검증이 가능해졌습니다. KMK 환율과 적용 주차가 목록에도 상세(ESTIMATED·ACTUAL 탭)에도 표시되지 않고, 화면에 Kurs/Rate 라벨 자체가 없습니다. 수용기준(Import Cost 화면의 KMK 환율·적용 주차 표시) 미충족. 정정: 이전 헤더 검증 결과(ACCEPTED, 2026-09-08)가 이력(PENDING)과 맞지 않아 NOT APPLIED 로 바로잡았습니다.',
       note_id = 'Pengecekan server produksi 2026-09-11: daftar Import Cost kini 1 record (SHP-20260427-001 / PO HA-20260527-001) sehingga verifikasi dapat dilakukan. Kurs KMK dan minggu kurs tidak ditampilkan di daftar maupun detail (tab ESTIMATED dan ACTUAL); tidak ada label Kurs/Rate di layar. Kriteria penerimaan (tampilan Kurs KMK dan minggu kurs di layar Import Cost) belum terpenuhi. Koreksi: hasil verifikasi header sebelumnya (ACCEPTED, 2026-09-08) tidak sesuai dengan riwayat (PENDING) — diperbaiki menjadi NOT APPLIED.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 270 AND i.issue_no = '10';

-- ── 13 · verif_id 257 · 2026-09-10 · REJECTED ──
UPDATE public.csr_verifications v
   SET note_ko = 'SO 목록은 정수로 나오지만 Delivery Note 목록은 여전히 소수점 2자리라 차이가 계속 생깁니다. 예: MDA/CKR/034/VIII/2026 SO 34,096,003.00 vs DN 34,096,002.67(차이 0.33); I 0351 SO 24,700,000.00 vs DN 24,699,999.94; ABC/002/09/2026 SO 108,950,609.00 vs DN 108,950,609.75. 견적 → SO 반올림 규칙이 여전히 일관되지 않습니다(...002.67 → ...003 올림, ...609.75 → ...609 버림). 결정: IDR 총액은 정수로 하고 반올림은 단가 단계에서 통일해, SO · DN · Invoice 가 항상 같게 합니다. 상태를 ONGOING 으로 되돌려 주시기 바랍니다.',
       note_id = 'Daftar SO menampilkan bilangan bulat, daftar Delivery Note masih 2 desimal, selisih tetap terjadi. Contoh: MDA/CKR/034/VIII/2026 SO 34,096,003.00 vs DN 34,096,002.67 (selisih 0.33); I 0351 SO 24,700,000.00 vs DN 24,699,999.94; ABC/002/09/2026 SO 108,950,609.00 vs DN 108,950,609.75. Aturan pembulatan Quotation ke SO masih tidak konsisten (...002.67 -> ...003 dibulatkan ke atas, ...609.75 -> ...609 dipotong). Keputusan: total IDR bilangan bulat, pembulatan diseragamkan di tingkat harga satuan agar SO, DN, Invoice selalu sama. Status mohon dikembalikan ke ONGOING.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 257 AND i.issue_no = '13';

-- ── 22 · verif_id 262 · 2026-09-10 · PARTIAL ──
UPDATE public.csr_verifications v
   SET note_ko = '화면마다 숫자 형식이 섞여 있습니다. SO/DN/PO 목록은 국제 형식(34,096,002.67)이지만 입력 필드와 팝업은 여전히 인도네시아 형식입니다(PO 단가 2.658.900; 신규 SO 의 Customer PO 팝업 14.705.003,61; Receipt 목록 수량 21.269 / 1.650 인데 다른 행은 60). 팝업과 입력 필드를 포함해 전 화면을 한 가지 형식으로 통일해야 합니다.',
       note_id = 'Format angka campuran antar layar: daftar (list) SO/DN/PO sudah format internasional (34,096,002.67), namun field input dan pop-up masih format Indonesia (harga satuan PO 2.658.900; pop-up Customer PO pada SO baru 14.705.003,61; qty pada daftar Receipt 21.269 / 1.650 sementara baris lain 60). Perlu penyeragaman ke satu format di seluruh layar, termasuk pop-up dan field input.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 262 AND i.issue_no = '22';

-- ── 23 · verif_id 263 · 2026-09-10 · NOT APPLIED ──
UPDATE public.csr_verifications v
   SET note_ko = 'Sales > SO > List: 뷰포트 너비 1,280px 에서 STATUS(CONFIRMED) 와 DELIV(DELIVERED) 배지가 서로 겹칩니다(열이 좁고 배지가 줄바꿈되지 않음). 견적 목록은 AMOUNT 열이 3줄로 잘립니다. 열 너비 조정이나 고정 열(sticky) 적용은 아직 없습니다.',
       note_id = 'Sales > SO > List: badge STATUS (CONFIRMED) dan DELIV (DELIVERED) saling tumpang tindih pada lebar viewport 1,280 px (kolom sempit, badge tidak wrap). Daftar Quotation: kolom AMOUNT terpotong 3 baris. Belum ada perubahan lebar kolom/kolom tetap (sticky).'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 263 AND i.issue_no = '23';

-- ── 27 · verif_id 258 · 2026-09-10 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = '두 번째 표본: PO HT-20260908-004(PT. HA TIRE) PAYMENT TERM 60 days → Receipt RCPT-20260910-030 의 PO INFO PAYMENT TERM 60 으로 일치. 앞선 표본 AJ-20260901-003(45 days, 2026-09-08)과 함께 공급사 두 곳에서 결제조건 상속이 확인되었습니다. 미검증: 공급사 마스터를 바꿨을 때 기존 결제조건 이력이 유지되는지(시험용 공급사 계정 필요). 이 항목은 27 번을 VERIFIED 로 닫을 수 있도록 새 CSR 로 분리할 것을 제안합니다.',
       note_id = 'Sampel ke-2: PO HT-20260908-004 (PT. HA TIRE) PAYMENT TERM 60 days -> Receipt RCPT-20260910-030, PO INFO PAYMENT TERM 60, sesuai. Bersama sampel AJ-20260901-003 (45 days, 2026-09-08), pewarisan term terkonfirmasi pada 2 supplier. Belum diverifikasi: retensi histori term saat master supplier diubah (perlu akun supplier uji). Item ini diusulkan dipisah sebagai CSR baru agar 27 dapat ditutup VERIFIED.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 258 AND i.issue_no = '27';

-- ── 28 · verif_id 259 · 2026-09-10 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = 'Sales > Quotation > New: 같은 품목(AOSO 10.00R20 AR101 18)을 1행과 2행에 Check Product 경고 없이 입력할 수 있었습니다. 시험 데이터를 남기지 않으려고 저장은 하지 않았습니다. 수용기준(신규 견적에서 동일 품목 다중 행 입력) 충족. 현업이 실제 거래로 확인(저장 + Customer PO/SO)한 뒤 VERIFIED 로 합니다.',
       note_id = 'Sales > Quotation > New: item yang sama (AOSO 10.00R20 AR101 18) berhasil diinput pada baris 1 dan 2 tanpa peringatan Check Product. Penyimpanan tidak dilakukan (menghindari data uji). Kriteria penerimaan (input multi-baris item sama di Quotation baru) terpenuhi. VERIFIED setelah pengguna lapangan mengonfirmasi dengan transaksi riil (Save + Customer PO/SO).'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 259 AND i.issue_no = '28';

-- ── 30 · verif_id 260 · 2026-09-10 · ACCEPTED ──
UPDATE public.csr_verifications v
   SET note_ko = 'Master Data > Warehouses: 7건, CLAIM KARAWANG · CLAIM SEMARANG · CLAIM SURABAYA 포함(2026-09-08 에는 없었으나 지금은 등록됨). Inventory List 의 Warehouse 필터에도 Claim 창고 3곳이 나옵니다. 수용기준 두 가지 모두 충족 → VERIFIED. 참고: 신규 SO 의 WAREHOUSE 필드는 읽기전용(Customer PO 에서 상속)이라, Claim 창고 선택은 견적/Customer PO 단계에서 합니다.',
       note_id = 'Master Data > Warehouses: 7 record, termasuk CLAIM KARAWANG, CLAIM SEMARANG, CLAIM SURABAYA (per 2026-09-08 belum ada, kini terdaftar). Filter Warehouse pada Inventory List juga menampilkan 3 gudang Claim. Kedua kriteria penerimaan terpenuhi -> VERIFIED. Catatan: field WAREHOUSE pada SO baru bersifat read-only (diwarisi dari Customer PO), sehingga pemilihan gudang Claim dilakukan di tahap Quotation/Customer PO.'
  FROM public.csr_issues i
 WHERE v.issue_id = i.id AND v.id = 260 AND i.issue_no = '30';

-- ── 확인: 대상 10행이 모두 KO(한글 포함)·ID(한글 없음) 인지 ──
SELECT i.issue_no, v.id AS verif_id, v.verified_on, v.result,
       (v.note_ko ~ '[가-힣]') AS ko_ok, (v.note_id !~ '[가-힣]') AS id_ok
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE v.id IN (284, 256, 261, 270, 257, 262, 263, 258, 259, 260)
 ORDER BY i.issue_no, v.id;
