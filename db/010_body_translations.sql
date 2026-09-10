-- =============================================================================
-- ASM CSR — 본문 3종 한국어·인도네시아어 쌍 (2026-09-10 「sql 009 번역 추가」 → 010)
--   001~009 적용 후 실행. 달러 인용 없음 — 문장마다 따로 실행해도 됩니다. 재실행 안전.
--   생성: node scripts/csr_gen_010.cjs  (번역 원본: import/translations/batch_*.json)
--
-- 본문(현상 · 개선 의견 · 현업 답변)은 Notion 원문이 이슈당 한 언어였습니다(한국어 37 ·
-- 인니어 26). 원문 컬럼(findings_md 등)은 그대로 두고 _ko/_id 쌍을 추가합니다. 원문 언어 쪽에는
-- 원문을, 반대쪽에는 번역을 넣습니다. 번역은 Claude 가 했고 검수 대상입니다 — 화면 편집으로
-- 언제든 고칠 수 있습니다(현업·admin).
-- =============================================================================

ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS findings_md_ko        text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS findings_md_id        text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS recommendation_md_ko  text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS recommendation_md_id  text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS business_answer_md_ko text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS business_answer_md_id text;
COMMENT ON COLUMN public.csr_issues.findings_md_ko IS '2. 현상 — 한국어. 비어 있으면 화면은 findings_md 로 되돌아감';
COMMENT ON COLUMN public.csr_issues.findings_md_id IS '2. Temuan — Bahasa Indonesia';

-- 01 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Area daftar item (ITEMS) diberi tinggi tetap, dan blok total (Subtotal~Grand Total) ter-render menumpuk di atasnya. Terjadi saat tinggi area tampil browser sekitar 800px atau kurang.
- [Verifikasi ulang 2026-09-01] Layar Quotation sudah teratasi, tetapi masalah masih muncul di Purchase PO (baru/detail) dan Shipment (baru). Tinggi area scroll item terhitung hanya 10.6px sehingga baris item tertutup penuh oleh blok total dan tidak dapat diklik maupun diisi. Tidak ada scrollbar atau indikator "masih ada data", sehingga user tidak menyadari data yang tersembunyi. Pada tinggi area tampil 825px tampilan normal, namun laptop standar kantor (1,366×768) maksimal 734px sehingga tidak bisa dihindari dengan mengubah ukuran jendela.

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Baru·Detail
2. Konfirmasi gejala — blok total menumpuk di atas area item sehingga baris item tidak dapat diklik atau diisi (area tampil 800px ke bawah)',
  findings_md_ko = '- 품목 목록(ITEMS) 영역에 고정 높이가 지정되어 있고, 합계 블록(Subtotal~Grand Total)이 그 위에 겹쳐서 렌더링됨. 브라우저 표시 영역 높이가 약 800px 이하일 때 발생.
- [2026-09-01 재검증] Quotation 화면은 해결되었으나 Purchase PO(신규/상세)와 Shipment(신규)에서는 여전히 발생. 품목 스크롤 영역 높이가 10.6px로 계산되어 품목 행이 합계 블록에 완전히 가려져 클릭·입력이 불가. 스크롤바나 "데이터 더 있음" 표시가 없어 사용자가 숨겨진 데이터를 인지하지 못함. 표시 영역 높이 825px에서는 정상이나, 사무실 표준 노트북(1,366×768)은 최대 734px이라 창 크기 조정으로는 회피 불가.

**재현 절차**

1. Purchasing > PO > 신규·상세 진입
2. 현상 확인 — 합계 블록이 품목 영역 위에 겹쳐 품목 행을 클릭·입력할 수 없음 (표시 영역 800px 이하)',
  recommendation_md_id = '- Hilangkan tumpang tindih antara area item (kontainer scroll) dan area total (card-footer). Tinggi area item dibuat dinamis, bukan nilai tetap, dan blok total ditempatkan berurutan di bawah daftar item. Mohon perbaikan yang sudah diterapkan pada layar Quotation diterapkan sama ke seluruh layar dokumen (Purchase PO, Shipment, dll). Tetapkan resolusi minimum yang didukung 1,366×768 (disarankan 1,920×1,080) dan sertakan regression test pada resolusi tersebut. Wajib diperbaiki sebelum Go-Live.',
  recommendation_md_ko = '- 품목 영역(스크롤 컨테이너)과 합계 영역(card-footer)의 겹침 제거. 품목 영역 높이를 고정값이 아닌 동적 값으로 하고, 합계 블록은 품목 목록 아래에 순차 배치. Quotation 화면에 이미 적용된 수정을 전 전표 화면(Purchase PO, Shipment 등)에 동일하게 적용 요청. 지원 최소 해상도를 1,366×768(권장 1,920×1,080)로 정하고 해당 해상도에서의 회귀 테스트 포함. 오픈 前 필수 수정.',
  business_answer_md_id = '- Verifikasi 2026-09-07 — penempatan berurutan pada layar PO detail dan Quotation sudah dikonfirmasi (1,366×768). Layar registrasi baru belum dapat diverifikasi karena keterbatasan hak akses (403). Sebagai item wajib sebelum Go-Live, mohon kepastian tanggal penyelesaian.',
  business_answer_md_ko = '- 2026-09-07 검증 — PO 상세 및 Quotation 화면의 순차 배치 확인 완료(1,366×768). 신규 등록 화면은 접근 권한 제한(403)으로 미검증. 오픈 前 필수 항목이므로 완료 예정일 확정 요청.'
WHERE issue_no = '01' AND NOT is_archived;

-- 02 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Kolom AMOUNT tidak mencantumkan mata uang, sehingga PO dalam USD dan PO dalam IDR tercampur dalam satu layar.
- [Verifikasi ulang 2026-09-01] Field CURRENCY sudah ditambahkan sebagai isian wajib di layar registrasi baru sehingga mata uang dikelola per dokumen, namun daftar tetap tidak memiliki kolom CURRENCY sehingga tidak dapat dibedakan. Pada dokumen uji, USD 108,800 (HA-20260901-001) dan IDR 1,359,972,000 (DF-20260901-001) tampil di kolom yang sama tanpa keterangan mata uang. Daftar PPC sama.

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Daftar
2. Konfirmasi gejala — kolom AMOUNT tanpa keterangan mata uang sehingga PO USD dan IDR tercampur di kolom yang sama (daftar PO · PPC)',
  findings_md_ko = '- AMOUNT 열에 통화가 표기되지 않아 USD PO와 IDR PO가 한 화면에 혼재됨.
- [2026-09-01 재검증] 신규 등록 화면에 CURRENCY 필드가 필수 입력으로 추가되어 전표별 통화 관리는 가능해졌으나, 목록에는 여전히 CURRENCY 열이 없어 구분 불가. 검증 전표 기준 USD 108,800(HA-20260901-001)과 IDR 1,359,972,000(DF-20260901-001)이 통화 표기 없이 같은 열에 표시됨. PPC 목록도 동일.

**재현 절차**

1. Purchasing > PO > 목록 진입
2. 현상 확인 — AMOUNT 열에 통화 표기가 없어 USD·IDR PO가 같은 열에 혼재 (PO · PPC 목록)',
  recommendation_md_id = '- Tampilkan nilai CURRENCY yang sudah tersimpan pada dokumen sebagai kolom di daftar, atau cantumkan kode mata uang di depan nominal (USD 108,800.00 / IDR 1,359,972,000). Sediakan filter impor/lokal sebagai standar.',
  recommendation_md_ko = '- 전표에 이미 저장된 CURRENCY 값을 목록 열로 표시하거나, 금액 앞에 통화 코드를 병기(USD 108,800.00 / IDR 1,359,972,000). 수입/로컬 필터를 기본 제공.',
  business_answer_md_id = '- Keputusan — diperlukan. Tampilkan nilai CURRENCY yang sudah ada pada dokumen sebagai kolom di daftar PO, PPC, Shipment, dan SO (bukan pengembangan baru, hanya menampilkan field yang sudah ada), disertai filter impor/lokal. Mohon: masuk kategori wajib sebelum Go-Live, ubah status menjadi Ongoing, dan cantumkan tanggal target penyelesaian.',
  business_answer_md_ko = '- 결정 — 필요. PO · PPC · Shipment · SO 목록에 전표의 기존 CURRENCY 값을 열로 표시(신규 개발이 아닌 기존 필드 노출)하고 수입/로컬 필터 병행. 요청 — 오픈 前 필수 분류, 상태 Ongoing 변경, 완료 목표일 기재.'
WHERE issue_no = '02' AND NOT is_archived;

-- 03 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Nilai PO yang sama tampil berbeda antar layar.
- [Verifikasi ulang 2026-09-01] Berdasarkan dokumen uji (DF-20260901-001), Daftar PO menampilkan 1,359,972,000 (termasuk PPN) sedangkan Daftar PPC menampilkan 1,225,200,000 (tidak termasuk PPN); selisih 134,772,000 persis sama dengan PPN 11%. PPC (Production Planning and Control) adalah layar perencanaan dan pemantauan produksi pabrik sehingga dasar nilainya dapat berbeda, namun kedua layar sama-sama tidak mencantumkan dasar pajak (termasuk/tidak termasuk pajak) dan tidak ada sarana untuk merekonsiliasi kuantitas alokasi produksi maupun kuantitas produksi selesai terhadap PO.

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Daftar
2. Konfirmasi gejala — nilai PO yang sama berbeda antara Daftar PO (termasuk pajak) dan Daftar PPC (tidak termasuk pajak); tidak ada penulisan dasar pajak maupun sarana rekonsiliasi kuantitas',
  findings_md_ko = '- 동일 PO 금액이 화면마다 다르게 표시됨.
- [2026-09-01 재검증] 검증 전표(DF-20260901-001) 기준 PO 목록은 1,359,972,000(PPN 포함), PPC 목록은 1,225,200,000(PPN 제외)으로 표시되며 차액 134,772,000은 PPN 11%와 정확히 일치. PPC(Production Planning and Control)는 공장 생산 계획·관리 화면이라 금액 기준이 다를 수 있으나, 두 화면 모두 세금 기준(포함/제외)을 표기하지 않고 PO 대비 생산 배정 수량·생산 완료 수량을 대사할 수단도 없음.

**재현 절차**

1. Purchasing > PO > 목록 진입
2. 현상 확인 — 동일 PO 금액이 PO 목록(세금 포함)과 PPC 목록(세금 제외)에서 상이; 세금 기준 표기 및 수량 대사 수단 부재',
  recommendation_md_id = '- Cantumkan dasar nilai "tidak termasuk pajak (DPP) / termasuk pajak" pada kolom nominal di setiap layar, dan tambahkan fungsi tampilan yang memungkinkan rekonsiliasi kuantitas PO terhadap kuantitas alokasi PPC, kuantitas produksi selesai, dan sisa yang belum dialokasikan dalam satu layar. Disarankan menampilkan progres PO (%).',
  recommendation_md_ko = '- 각 화면의 금액 열에 "세금 제외(DPP) / 세금 포함" 기준을 표기하고, PO 수량 대비 PPC 배정 수량·생산 완료 수량·미배정 잔량을 한 화면에서 대사할 수 있는 조회 기능 추가. PO 진행률(%) 표시 권장.',
  business_answer_md_id = '- Keputusan — AMOUNT pada daftar disatukan ke DPP (tidak termasuk pajak), dengan 「(excl. PPN)」 dicantumkan pada header. Pada layar detail, tampilan terpisah DPP · PPN · PPh · Grand Total tetap dipertahankan. Tambahkan kolom sisa yang belum dialokasikan pada Daftar PPC. Permintaan — penulisan header sebelum Go-Live, kolom sisa dan progres setelah Go-Live.',
  business_answer_md_ko = '- 결정 — 목록의 AMOUNT는 DPP(세금 제외)로 통일하고 헤더에 「(excl. PPN)」 표기. 상세 화면은 DPP · PPN · PPh · Grand Total 분리 표시 유지. PPC 목록에 미배정 잔량 열 추가. 요청 — 헤더 표기는 오픈 前, 잔량 열·진행률은 오픈 後.'
WHERE issue_no = '03' AND NOT is_archived;

-- 04 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- (1차 테스트 시점) PO NO. 수기 입력 필수, ''PO-120'' · ''123'' · ''11'' 등 채번 규칙 부재, 테스트 전표가 실데이터와 혼재
- [2026-09-01 조치 확인] PO NO. 입력란이 읽기전용으로 변경되고 ''공급사코드-YYYYMMDD-순번'' 규칙으로 자동 채번 (검증 전표 HA-20260901-001 · DF-20260901-001). 기존 테스트 전표 전량 삭제

**재현 절차 / Langkah reproduksi**

1. Purchasing > PO > 신규 진입
2. PO NO. 입력란 상태 확인 — 읽기전용 · 자동 채번 여부
3. PO 목록에서 테스트 전표(''PO-120'' 등) 잔존 여부 확인',
  findings_md_id = '- (Saat uji tahap 1) PO NO. wajib diisi manual, tidak ada aturan penomoran (''PO-120'' · ''123'' · ''11'', dll.), dokumen uji tercampur dengan data riil
- [Konfirmasi perbaikan 2026-09-01] Kolom PO NO. diubah menjadi read-only dan dinomori otomatis dengan aturan ''KodeSupplier-YYYYMMDD-Urutan'' (dokumen uji HA-20260901-001 · DF-20260901-001). Seluruh dokumen uji lama sudah dihapus

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Baru
2. Periksa kolom PO NO. — read-only · penomoran otomatis
3. Periksa daftar PO — apakah dokumen uji (''PO-120'', dll.) masih tersisa',
  recommendation_md_ko = '- 조치 완료. 채번 규칙(공급사코드 접두어 + 일자 + 순번)을 Shipment(SHP-) · Receipt(RCPT-) 체계와 함께 문서화하여 현업 공유 요청',
  recommendation_md_id = '- Perbaikan selesai. Mohon aturan penomoran (awalan kode supplier + tanggal + urutan) didokumentasikan bersama skema Shipment (SHP-) · Receipt (RCPT-) dan dibagikan ke tim bisnis',
  business_answer_md_ko = '- 조치 확인 (2026-09-01). 채번 체계 문서화 요청 잔여',
  business_answer_md_id = '- Perbaikan dikonfirmasi (2026-09-01). Permintaan dokumentasi skema penomoran masih tersisa'
WHERE issue_no = '04' AND NOT is_archived;

-- 05 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- [2026-09-01 조치 확인] 단가 입력 중 천 단위 구분기호가 표시됨(3063000 입력 → 3.063.000). 자릿수 오입력 위험 해소. 다만 구분기호가 인도네시아식이므로 표기 방식은 이슈 22와 함께 정비 필요.

**재현 절차 / Langkah reproduksi**

1. Purchasing > PO > 신규 (단가 입력) 진입
2. 현상 확인 — 단가 입력 시 천 단위 구분기호 미표시 → 반영 확인 (인도네시아식 구분기호는 22번 통합)',
  findings_md_id = '- [Konfirmasi perbaikan 2026-09-01] Pemisah ribuan tampil saat mengetik harga satuan (input 3063000 → 3.063.000). Risiko salah jumlah digit teratasi. Namun pemisah memakai format Indonesia, sehingga format penulisan perlu dirapikan bersama isu 22.

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Baru (input harga satuan)
2. Periksa gejala — pemisah ribuan tidak tampil saat input harga satuan → konfirmasi sudah diterapkan (pemisah format Indonesia digabung ke isu 22)',
  recommendation_md_ko = '- 조치 완료. 구분기호 표기 방식(콤마·마침표)은 이슈 22(숫자 표기 형식)에 통합하여 처리 요청.',
  recommendation_md_id = '- Perbaikan selesai. Format pemisah (koma · titik) mohon ditangani terpadu dalam isu 22 (format penulisan angka).',
  business_answer_md_ko = '- 조치 확인 (2026-09-01). 구분기호 표기 방식(콤마·마침표)은 이슈 22로 통합 처리',
  business_answer_md_id = '- Perbaikan dikonfirmasi (2026-09-01). Format pemisah (koma · titik) digabung ke isu 22'
WHERE issue_no = '05' AND NOT is_archived;

-- 06 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 입고일이 실제도착일보다 빠른 전표가 등록 가능함.
- [2026-09-01 재검증] 입고일 2026-10-01을 실제도착일 2026-10-15보다 2주 앞선 날짜로 입력하였으나 경고·차단 없이 저장됨(RCPT-20261001-001). 목록 화면에도 두 일자가 그대로 표시되어 육안 검증에 의존.

**재현 절차 / Langkah reproduksi**

1. Purchasing > Receipt > 신규 진입
2. 현상 확인 — 입고일·실제도착일 선후관계 검증 없음',
  findings_md_id = '- Dokumen dengan tanggal penerimaan lebih awal dari tanggal kedatangan aktual dapat disimpan.
- [Verifikasi ulang 2026-09-01] Tanggal penerimaan 2026-10-01 diinput 2 minggu lebih awal dari tanggal kedatangan aktual 2026-10-15, namun tersimpan tanpa peringatan/pemblokiran (RCPT-20261001-001). Kedua tanggal juga tampil apa adanya di daftar sehingga bergantung pada pemeriksaan visual.

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt > Baru
2. Periksa gejala — tidak ada validasi urutan tanggal penerimaan · tanggal kedatangan aktual',
  recommendation_md_ko = '- PO일 ≤ ETD ≤ ETA ≤ 실제도착일 ≤ 입고일 순서 검증 로직 추가.',
  recommendation_md_id = '- Tambahkan logika validasi urutan: tanggal PO ≤ ETD ≤ ETA ≤ tanggal kedatangan aktual ≤ tanggal penerimaan.',
  business_answer_md_ko = '- —',
  business_answer_md_id = '- —'
WHERE issue_no = '06' AND NOT is_archived;

-- 07 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- Total Import Cost에 PPN 11% (233,058,127) 및 PPh 22 7.5% (158,903,269)가 포함됨. 두 항목 합계 391,961,396은 총액 583,654,228의 67.2%로, 매입세액공제·법인세 선납 대상이어 재고자산 원가에 포함될 수 없음.
- [2026-09-01 재검증] 통관(Customs) 화면에서 BM 5% · PPN 11% · PPh 22 7.5%가 품목별로 산출되는 것을 확인(검증 전표 기준 BC 101,310,450 · PPN 234,027,139.50 · PPh 22 159,563,958.75). 다만 수입원가 화면은 입고 확정 후 생성되는 구조여서 재고원가 산입 여부는 미검증.

**재현 절차 / Langkah reproduksi**

1. Purchasing > Import Cost > ESTIMATED 탭 진입
2. 현상 확인 — Total Import Cost에 PPN·PPh 22(환급·공제 대상) 포함 — 재고원가 과대',
  findings_md_id = '- Total Import Cost mencakup PPN 11% (233,058,127) dan PPh 22 7.5% (158,903,269). Jumlah keduanya 391,961,396 adalah 67.2% dari total 583,654,228; keduanya merupakan pajak masukan yang dapat dikreditkan · pajak penghasilan dibayar di muka sehingga tidak boleh masuk ke harga pokok persediaan.
- [Verifikasi ulang 2026-09-01] Di layar Customs, BM 5% · PPN 11% · PPh 22 7.5% dihitung per item (dokumen uji: BC 101,310,450 · PPN 234,027,139.50 · PPh 22 159,563,958.75). Namun layar Import Cost baru terbentuk setelah penerimaan dikonfirmasi, sehingga apakah pajak ini masuk ke harga pokok persediaan belum terverifikasi.

**Langkah reproduksi**

1. Masuk ke Purchasing > Import Cost > tab ESTIMATED
2. Periksa gejala — Total Import Cost mencakup PPN · PPh 22 (dapat direstitusi/dikreditkan) — harga pokok persediaan terlalu tinggi',
  recommendation_md_ko = '- 화면을 ''자금 소요(Cash-out)''와 ''재고원가 산입(Landed Cost)'' 두 기준으로 분리 표기. 재고원가에는 BC(관세) + 부대비만 반영.',
  recommendation_md_id = '- Pisahkan tampilan layar menjadi dua dasar: ''Kebutuhan dana (Cash-out)'' dan ''Pembebanan ke harga pokok persediaan (Landed Cost)''. Harga pokok persediaan hanya mencakup BC (bea masuk) + biaya tambahan.',
  business_answer_md_ko = '- 조치 방향 정정 — 화면을 Cash-out(관세+PPN+PPh+부대비)과 Landed Cost(FOB+운임·보험+관세+부대비) 두 기준으로 분리 표기. 근거 PSAK 14 문단 11(환급 가능 세금은 재고 취득원가 제외). 오픈 前 완료 예정일 확정 요청',
  business_answer_md_id = '- Koreksi arah perbaikan — tampilan dipisah menjadi Cash-out (bea masuk + PPN + PPh + biaya tambahan) dan Landed Cost (FOB + freight · asuransi + bea masuk + biaya tambahan). Dasar: PSAK 14 paragraf 11 (pajak yang dapat direstitusi tidak termasuk biaya perolehan persediaan). Mohon kepastian tanggal penyelesaian sebelum Go-Live'
WHERE issue_no = '07' AND NOT is_archived;

-- 08 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 선적 단위 총액만 산출되고 품목(SKU)별 원가 배부 결과가 없음. 규격별 단가차가 큰 타이어 특성상 SKU별 착지원가 없이는 판매마진 산정 불가.
- [2026-09-01 재검증] 통관 화면은 품목별 CIF 금액과 세액을 산출하고 있어 세금 부분은 SKU별 배부가 이루어짐. 운임·보험·기타 부대비의 SKU별 배부 여부는 수입원가 화면 미검증으로 확인되지 않음.

**재현 절차**

1. Purchasing > Import Cost > COST ITEMS 진입
2. 현상 확인 — 품목(SKU)별 원가 배부 기능 부재 → 백엔드 배부 존재, 화면 노출 없음

# 8. 실서버 실측 (2026-09-07)

- 결과 — Completed 부적정. Purchasing > Import Cost 목록 0건(No import cost records found)
- 목록 컬럼: SHIPMENT NO · RECEIPT NO · PO NO · SUPPLIER · SHIPMENT QTY · RECEIPT QTY · RECEIPT AMOUNT · COST AMOUNT · COST STATUS · RECEIPT STATUS — 품목(SKU) 관련 열 없음
- 판정 근거 — 수용기준 ①SKU별 Landed_unit_cost 화면 조회 ②배부기준 문서화 모두 미충족, 개발부서 회신의 「개선내역 N/A」와 일치(기능 미개발)',
  findings_md_id = '- Hanya total biaya per pengapalan yang dihitung, tanpa hasil alokasi biaya per item (SKU). Karena selisih harga antar ukuran ban sangat besar, margin penjualan tidak dapat dihitung tanpa landed cost per SKU.
- [Verifikasi ulang 2026-09-01] Layar Customs sudah menghitung nilai CIF dan pajak per item, sehingga bagian pajak telah dialokasikan per SKU. Alokasi per SKU untuk freight, asuransi, dan biaya tambahan lain belum dapat dipastikan karena layar Import Cost belum terverifikasi.

**Langkah reproduksi**

1. Masuk ke Purchasing > Import Cost > COST ITEMS
2. Periksa gejala — fitur alokasi biaya per item (SKU) tidak tersedia di layar → alokasi ada di backend, tidak ditampilkan

# 8. Pengukuran di server produksi (2026-09-07)

- Hasil — status Completed tidak tepat. Daftar Purchasing > Import Cost 0 baris (No import cost records found)
- Kolom daftar: SHIPMENT NO · RECEIPT NO · PO NO · SUPPLIER · SHIPMENT QTY · RECEIPT QTY · RECEIPT AMOUNT · COST AMOUNT · COST STATUS · RECEIPT STATUS — tidak ada kolom terkait item (SKU)
- Dasar penilaian — kriteria selesai ① tampilan Landed_unit_cost per SKU ② dokumentasi dasar alokasi keduanya belum terpenuhi, sesuai balasan tim pengembang 「Perbaikan N/A」 (fitur belum dikembangkan)',
  recommendation_md_ko = '- 선적 부대비를 CIF 금액 기준 또는 중량 기준으로 SKU별 배부하는 기능 추가. 배부기준은 마스터에서 선택 가능하도록 설계.',
  recommendation_md_id = '- Tambahkan fitur alokasi biaya tambahan pengapalan per SKU berdasarkan nilai CIF atau berat. Dasar alokasi dirancang agar dapat dipilih dari master.',
  business_answer_md_ko = '- 회신 요청 — 선적 부대비의 SKU별 배부 기준(CIF / 중량 / 수량) 및 Landed_unit_cost 화면 노출 위치. 현 Import Cost 화면은 COST ITEMS 10개 행만 표시되고 품목별 열 없음',
  business_answer_md_id = '- Mohon konfirmasi — dasar alokasi biaya tambahan pengapalan per SKU (CIF / berat / kuantitas) dan lokasi tampilan Landed_unit_cost di layar. Layar Import Cost saat ini hanya menampilkan 10 baris COST ITEMS, tanpa kolom per item.'
WHERE issue_no = '08' AND NOT is_archived;

-- 09 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 3.관세 / 4.PPN / 5.PPh 행에 실적 입력란이 없어 PIB(수입신고필증) 확정 세액을 등록할 수 없음. 부대비 행에만 Billing vendor·Invoice no. 입력란 존재.
- [2026-09-01] 수입원가 화면은 입고 확정 이후 생성되는 구조이며, 재검증 시 입고 전표를 DRAFT로 유지(재고 영향 방지)하여 미검증. 개발부서 확인 요청.

**재현 절차 / Langkah reproduksi**

1. Purchasing > Import Cost > ACTUAL 탭 진입
2. 현상 확인 — ACTUAL 탭 세금 3개 행 입력란 없음 — PIB 확정세액 반영 불가',
  findings_md_id = '- Baris 3. Bea masuk / 4. PPN / 5. PPh tidak memiliki kolom input aktual sehingga nilai pajak final PIB (Pemberitahuan Impor Barang) tidak dapat dicatat. Kolom Billing vendor · Invoice no. hanya ada di baris biaya tambahan.
- [2026-09-01] Layar Import Cost baru terbentuk setelah penerimaan dikonfirmasi; saat verifikasi ulang dokumen penerimaan dibiarkan DRAFT (menghindari dampak ke stok) sehingga belum terverifikasi. Mohon konfirmasi tim pengembang.

**Langkah reproduksi**

1. Masuk ke Purchasing > Import Cost > tab ACTUAL
2. Periksa gejala — 3 baris pajak di tab ACTUAL tidak memiliki kolom input — nilai pajak final PIB tidak dapat dicatat',
  recommendation_md_ko = '- 세금 3개 항목에도 실적 입력란(PIB 번호, 납부일, 확정금액) 추가. 추정 대비 실적 차이 리포트 제공.',
  recommendation_md_id = '- Tambahkan kolom input aktual (nomor PIB, tanggal pembayaran, nilai final) juga untuk 3 item pajak. Sediakan laporan selisih estimasi vs aktual.',
  business_answer_md_ko = '- 결정 — 필요. ESTIMATED 자동계산 유지, ACTUAL 세금 3개 행(Import Duty·PPN·PPh)에 PIB 번호·납부일·확정금액 입력란 추가. 사유 — KMK 환율 주간 고시 변동·HS 재분류·관세평가 차이로 PIB 확정세액과 추정세액 상이. 오픈 前 완료 예정일 확정 요청',
  business_answer_md_id = '- Keputusan — diperlukan. Perhitungan otomatis ESTIMATED dipertahankan; tambahkan kolom nomor PIB · tanggal pembayaran · nilai final pada 3 baris pajak ACTUAL (Import Duty · PPN · PPh). Alasan — nilai pajak final PIB berbeda dari estimasi karena perubahan kurs KMK mingguan · reklasifikasi HS · perbedaan penilaian pabean. Mohon kepastian tanggal penyelesaian sebelum Go-Live'
WHERE issue_no = '09' AND NOT is_archived;

-- 10 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- [2026-09-01 조치 확인] 통관(Customs) 화면에 EXCHANGE RATE · EXCHANGE DATE 필수 입력 항목이 신설되어 적용 환율과 적용일자를 등록·확인할 수 있음. (1차 테스트 시점 현상 — 적용 환율 미표시, 세액 역산으로만 약 IDR 17,805/USD 추정 가능)

**재현 절차 / Langkah reproduksi**

1. Purchasing > Import Cost 진입
2. 현상 확인 — 적용 환율(Kurs KMK) 미표시',
  findings_md_id = '- [Konfirmasi perbaikan 2026-09-01] Di layar Customs ditambahkan isian wajib EXCHANGE RATE · EXCHANGE DATE sehingga kurs yang dipakai dan tanggalnya dapat dicatat dan diperiksa. (Gejala saat uji tahap 1 — kurs tidak ditampilkan, hanya dapat diperkirakan ±IDR 17,805/USD dari perhitungan balik pajak)

**Langkah reproduksi**

1. Masuk ke Purchasing > Import Cost
2. Periksa gejala — kurs yang dipakai (Kurs KMK) tidak ditampilkan',
  recommendation_md_ko = '- 조치 완료. 잔여 요청 — 환율 출처(Kurs KMK 여부) 표기, PIB 확정 환율 기준 재계산 기능, 주간 고시 환율 대비 허용범위 입력 검증 추가.',
  recommendation_md_id = '- Perbaikan selesai. Permintaan tersisa — tampilkan sumber kurs (Kurs KMK atau bukan), fitur perhitungan ulang berdasarkan kurs final PIB, dan validasi input rentang toleransi terhadap kurs mingguan yang diumumkan.',
  business_answer_md_ko = '- 조치 내용 미기재 Ongoing 항목 — 진행 범위 기재 요청 (2026-09-07)',
  business_answer_md_id = '- Item Ongoing tanpa uraian perbaikan — mohon cantumkan lingkup pengerjaan (2026-09-07)'
WHERE issue_no = '10' AND NOT is_archived;

-- 11 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Dropdown SALES REP yang merupakan field wajib tidak memiliki pilihan sama sekali (0 data).
- [Verifikasi ulang 2026-09-01] Tetap 0 data, dan dropdown PAYMENT TERM · INV DUE LENGTH juga 0 data. Penawaran tidak dapat disimpan, dan karena Customer PO hanya dapat dibuat dari penawaran, seluruh dokumen penjualan (SO, Delivery Note, dll) tidak dapat didaftarkan. Sebagai catatan, pada layar PO pembelian daftar mata uang dan termin pembayaran terisi setelah pemasok dipilih (struktur dependen), sehingga perlu dipastikan apakah layar penawaran juga dirancang dependen terhadap pemilihan pelanggan.

**Langkah reproduksi**

1. Masuk ke Sales > Quotation > Baru (SALES REP · INV DUE LENGTH)
2. Konfirmasi gejala — dropdown SALES REP 0 data → penawaran tidak dapat disimpan, seluruh dokumen penjualan tidak dapat didaftarkan',
  findings_md_ko = '- 필수 항목인 SALES REP 드롭다운에 선택지가 전혀 없음(0건).
- [2026-09-01 재검증] 여전히 0건이며, PAYMENT TERM · INV DUE LENGTH 드롭다운도 0건. 견적을 저장할 수 없고, Customer PO는 견적에서만 생성되므로 전 판매 전표(SO, Delivery Note 등)를 등록할 수 없음. 참고로 구매 PO 화면에서는 공급사 선택 후 통화·결제조건 목록이 채워지는(종속) 구조이므로, 견적 화면도 고객 선택에 종속되도록 설계된 것인지 확인 필요.

**재현 절차**

1. Sales > Quotation > 신규 (SALES REP · INV DUE LENGTH) 진입
2. 현상 확인 — SALES REP 드롭다운 0건 → 견적 저장 불가, 전 판매 전표 등록 불가',
  recommendation_md_id = '- Hubungkan API pengambilan daftar sales rep dan termin pembayaran. Daftar sebaiknya dapat ditampilkan meskipun pelanggan belum dipilih; bila strukturnya memang dependen, tampilkan pemberitahuan "Pilih pelanggan terlebih dahulu". Daftar sales rep disarankan terhubung dengan field sales rep pada master pelanggan. Wajib diperbaiki sebelum Go-Live.',
  recommendation_md_ko = '- 영업담당(sales rep)·결제조건 목록 조회 API 연결. 고객을 선택하기 전에도 목록이 표시되는 것이 바람직하며, 종속 구조라면 "고객을 먼저 선택하십시오" 안내 표시. 영업담당 목록은 고객 마스터의 담당 영업 필드와 연동 권장. 오픈 前 필수 수정.',
  business_answer_md_id = '- Belum terselesaikan — prioritas tertinggi sebelum Go-Live. SALES REP 0 data (tetap sama setelah pelanggan dipilih); saat PAYMENT TYPE = CREDIT, INV DUE LENGTH juga 0 data. Karena field wajib tidak terpenuhi, penawaran tidak dapat disimpan, dan karena Customer PO hanya dibuat dari penawaran, pendaftaran baru seluruh dokumen penjualan (SO, Delivery Note, dll) tetap tidak dapat dilakukan. Mohon kepastian tanggal penyelesaian.',
  business_answer_md_ko = '- 미해결 — 오픈 前 최우선. SALES REP 0건(고객 선택 후에도 동일); PAYMENT TYPE = CREDIT 시 INV DUE LENGTH도 0건. 필수 항목이 채워지지 않아 견적 저장 불가, Customer PO는 견적에서만 생성되므로 전 판매 전표(SO, Delivery Note 등) 신규 등록이 여전히 불가. 완료 예정일 확정 요청.'
WHERE issue_no = '11' AND NOT is_archived;

-- 12 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 테스트 입력(10 EA × IDR 137,777) 결과 DPP 1,377,770 / PPN 151,555 / 절사 325 / 합계 1,529,000. 절사를 ''총액''에 적용하여 DPP × 11% = PPN 관계가 깨짐(실제 PPN 151,554.70).
- [2026-09-01 재검증] 동일 조건 재입력 결과 값이 그대로 재현됨.

**재현 절차 / Langkah reproduksi**

1. Sales > Quotation > 신규 (합계 블록) 진입
2. 현상 확인 — 절사를 총액에 적용해 DPP × 11% = PPN 관계 불성립 (e-Faktur 불일치 우려)',
  findings_md_id = '- Hasil input uji (10 EA × IDR 137,777): DPP 1,377,770 / PPN 151,555 / pemotongan 325 / total 1,529,000. Pemotongan diterapkan pada ''total'' sehingga hubungan DPP × 11% = PPN tidak berlaku (PPN sebenarnya 151,554.70).
- [Verifikasi ulang 2026-09-01] Input ulang dengan kondisi sama menghasilkan nilai yang sama persis.

**Langkah reproduksi**

1. Masuk ke Sales > Quotation > Baru (blok total)
2. Periksa gejala — pemotongan diterapkan pada total sehingga DPP × 11% = PPN tidak berlaku (berisiko tidak cocok dengan e-Faktur)',
  recommendation_md_ko = '- 절사(Truncation)는 총액이 아닌 DPP(공급가액) 단계에 적용하고, PPN은 절사된 DPP를 기준으로 재계산. 그래야 e-Faktur(전자세금계산서) 신고금액과 청구금액이 일치.',
  recommendation_md_id = '- Pemotongan (truncation) diterapkan pada tahap DPP (dasar pengenaan pajak), bukan pada total, dan PPN dihitung ulang dari DPP yang sudah dipotong. Dengan begitu nilai pelaporan e-Faktur (faktur pajak elektronik) sama dengan nilai tagihan.',
  business_answer_md_ko = '- 결정 — 화면 표시 문제 아님. 절사는 DPP 단계에 실제 적용·저장하고 PPN은 절사된 DPP 기준 재계산. 화면 절사·DB 미절사 구조는 인쇄 견적서와 DB 금액 불일치 유발. 근거 — e-Faktur DPP·PPN 루피아 정수 신고 원칙',
  business_answer_md_id = '- Keputusan — bukan sekadar masalah tampilan. Pemotongan benar-benar diterapkan dan disimpan pada tahap DPP, PPN dihitung ulang dari DPP yang dipotong. Struktur ''dipotong di layar tetapi tidak di DB'' menyebabkan nilai penawaran cetak berbeda dengan DB. Dasar — prinsip pelaporan e-Faktur: DPP · PPN dalam rupiah bilangan bulat'
WHERE issue_no = '12' AND NOT is_archived;

-- 13 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 동일 건 금액이 SO 14,637,982.00, DN 14,637,982.14로 0.14 차이. IDR 금액에 소수점 2자리가 사용되고 있음.
- [2026-09-01] 견적 저장 불가(이슈 11)로 SO·Delivery Note 생성 자체가 불가하여 재검증하지 못함. 이슈 11 수정 후 재확인 필요.

**재현 절차**

1. Sales > SO > 목록 ↔ Sales > Delivery Note > 목록 진입
2. 현상 확인 — SO ↔ Delivery Note 금액 불일치 (IDR 소수점 잔존)

# 8. 실서버 실측 (2026-09-07)

- 결과 — Completed 부적정 유지. SO는 정수(,00) 표기로 변경되었으나 Delivery Note는 소수점 2자리 존치, 동일 건 금액 불일치 재현
- 대사 결과 — 2026/VIII/P(PT. ARSHAKA) SO 38,176,004.00 vs DN 6,136,005.41 + 32,039,997.93 = 38,176,003.34 (차 0.66) / 038/PO-JV(PT. JAVARA) SO 15,380,000.00 vs DN 15,380,000.16 (차 0.16) / TSS/013(PT. TRIJAYA) SO 118,500,015.00 vs DN 118,500,014.70 (차 0.30) / 26080057(CV. MITRA ANDALAN) SO 31,106,399.00 vs DN 1,298,399.98 + 29,807,999.97 = 31,106,399.95 (차 0.95)
- 추가 발견 — 견적 → SO 전이 시 반올림 규칙 불일치. 38,176,003.34 → 38,176,004.00(반올림) / 31,106,399.95 → 31,106,399.00(절사)가 같은 화면에 병존
- 조치 방향 — 이슈 12(합계 절사) · 22(숫자 표기)와 묶어 반올림·절사 시점 단일 정책으로 재회신 요구',
  findings_md_id = '- Nilai untuk transaksi yang sama berbeda: SO 14,637,982.00 vs DN 14,637,982.14, selisih 0.14. Nilai IDR masih menggunakan 2 angka desimal.
- [2026-09-01] Karena penawaran tidak dapat disimpan (Isu 11), SO dan Delivery Note tidak dapat dibuat sehingga verifikasi ulang belum dapat dilakukan. Perlu dicek kembali setelah Isu 11 diperbaiki.

**Langkah reproduksi**

1. Masuk ke Sales > SO > Daftar ↔ Sales > Delivery Note > Daftar
2. Konfirmasi gejala — nilai SO ↔ Delivery Note tidak sesuai (desimal IDR masih tersisa)

# 8. Pengukuran aktual di server produksi (2026-09-07)

- Hasil — tetap Completed tidak sesuai. Tampilan SO sudah diubah menjadi bilangan bulat (.00), namun Delivery Note masih 2 angka desimal, sehingga ketidaksesuaian nilai pada transaksi yang sama terulang
- Hasil rekonsiliasi — 2026/VIII/P (PT. ARSHAKA) SO 38,176,004.00 vs DN 6,136,005.41 + 32,039,997.93 = 38,176,003.34 (selisih 0.66) / 038/PO-JV (PT. JAVARA) SO 15,380,000.00 vs DN 15,380,000.16 (selisih 0.16) / TSS/013 (PT. TRIJAYA) SO 118,500,015.00 vs DN 118,500,014.70 (selisih 0.30) / 26080057 (CV. MITRA ANDALAN) SO 31,106,399.00 vs DN 1,298,399.98 + 29,807,999.97 = 31,106,399.95 (selisih 0.95)
- Temuan tambahan — aturan pembulatan tidak konsisten saat transisi Penawaran → SO. Pada layar yang sama muncul 38,176,003.34 → 38,176,004.00 (dibulatkan) dan 31,106,399.95 → 31,106,399.00 (dipotong)
- Arah tindak lanjut — digabung dengan Isu 12 (pemotongan total) · 22 (format angka), meminta balasan ulang dengan satu kebijakan tunggal titik pembulatan · pemotongan',
  recommendation_md_ko = '- IDR은 소수점을 사용하지 않으므로 전 전표에서 IDR 금액을 정수로 통일. 반올림 시점을 단가 단계로 일원화하여 SO·DN·Invoice 금액이 항상 일치하도록 처리.',
  recommendation_md_id = '- IDR tidak menggunakan angka desimal, maka nilai IDR pada seluruh dokumen harus diseragamkan menjadi bilangan bulat. Titik pembulatan disatukan pada tahap harga satuan agar nilai SO · DN · Invoice selalu sama.',
  business_answer_md_ko = '- 상태 재분류 요청 Completed → Ongoing. 표기만 2자리로 맞추고 값 불일치 존치. 결정 — IDR 총액 정수, 반올림 시점을 단가 단계로 일원화하여 SO·DN·Invoice 항상 일치. 「SO 화면 소수점 2자리 표기 예정」 철회 요청',
  business_answer_md_id = '- Permintaan reklasifikasi status Completed → Ongoing. Hanya tampilan yang disesuaikan ke 2 desimal, ketidaksesuaian nilai tetap ada. Keputusan — total IDR bilangan bulat, titik pembulatan disatukan pada tahap harga satuan sehingga SO · DN · Invoice selalu sama. Rencana 「tampilan 2 desimal pada layar SO」 diminta ditarik kembali'
WHERE issue_no = '13' AND NOT is_archived;

-- 14 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 2026년 7월 마감(202607)의 RCPT·SHIP·RTN·ADJ 수량이 모두 0이며 기초 171,974 EA = 기말 171,974 EA. 동 기간 입고 2건·출고 1건이 존재하나 마감에 반영되지 않음.
- [2026-09-01] 마감 데이터가 전량 삭제되어 재현 불가. 마감 실행은 되돌리기 어려운 작업이므로 실서버 재현을 보류하고 개발부서에 로직 검증을 요청함.

**재현 절차 / Langkah reproduksi**

1. Inventory > Monthly Closing 진입
2. 현상 확인 — 월마감 집계에 입·출고 트랜잭션 미반영',
  findings_md_id = '- Pada penutupan Juli 2026 (202607) kuantitas RCPT · SHIP · RTN · ADJ semuanya 0, dan saldo awal 171,974 EA = saldo akhir 171,974 EA. Padahal pada periode itu ada 2 penerimaan · 1 pengeluaran yang tidak tercermin di penutupan.
- [2026-09-01] Data penutupan sudah dihapus seluruhnya sehingga tidak dapat direproduksi. Karena eksekusi penutupan sulit dibatalkan, reproduksi di server produksi ditunda dan tim pengembang diminta memverifikasi logikanya.

**Langkah reproduksi**

1. Masuk ke Inventory > Monthly Closing
2. Periksa gejala — transaksi masuk · keluar tidak tercermin pada agregasi penutupan bulanan',
  recommendation_md_ko = '- 입·출고 트랜잭션과 월마감 집계 로직 연결 여부 재점검. 마감 실행 시 기초+입고-출고±조정=기말 검증식 자동 대사 기능 추가.',
  recommendation_md_id = '- Periksa kembali keterhubungan transaksi masuk · keluar dengan logika agregasi penutupan bulanan. Tambahkan rekonsiliasi otomatis rumus validasi saldo awal + masuk − keluar ± penyesuaian = saldo akhir saat penutupan dijalankan.',
  business_answer_md_ko = '- 상태·조치 기재 요청. 7월 마감 미반영 원인 및 로직 검증(기초 + 입고 − 출고 ± 조정 = 기말) 결과 회신 — 2026년 8월 마감 前 필수',
  business_answer_md_id = '- Mohon cantumkan status · tindakan. Balasan penyebab penutupan Juli tidak tercermin dan hasil verifikasi logika (saldo awal + masuk − keluar ± penyesuaian = saldo akhir) — wajib sebelum penutupan Agustus 2026'
WHERE issue_no = '14' AND NOT is_archived;

-- 15 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 날짜 입력란 안내문이 ''연도-월-일'', ''----년 --월''로 노출.
- [2026-09-01 원인 확인] 해당 입력란은 브라우저 기본 컨트롤(input type=date/month)이며 안내문과 날짜 표기 순서는 사용자 PC의 브라우저 언어 설정을 따름. 즉 애플리케이션에 한국어가 하드코딩된 것이 아니라, 사용자 환경에 따라 화면 표기가 달라지는 문제임. 한국어 PC에서는 ''연도-월-일'', 현지 직원 PC에서는 다른 형식으로 표시되어 사용 안내·교육 자료와 화면이 일치하지 않음.

**재현 절차 / Langkah reproduksi**

1. 전 화면 날짜 입력란 진입
2. 현상 확인 — 날짜 입력 안내문 한국어 노출, 읽기전용 날짜 형식 혼재(MM/DD/YYYY vs YYYY-MM-DD)',
  findings_md_id = '- Teks petunjuk kolom tanggal tampil sebagai ''연도-월-일'', ''----년 --월'' (bahasa Korea).
- [Konfirmasi penyebab 2026-09-01] Kolom tersebut adalah kontrol bawaan browser (input type=date/month); teks petunjuk dan urutan format tanggal mengikuti pengaturan bahasa browser di PC pengguna. Artinya bahasa Korea tidak di-hardcode di aplikasi, melainkan tampilan berubah sesuai lingkungan pengguna. Di PC berbahasa Korea tampil ''연도-월-일'', di PC staf lokal tampil format lain, sehingga panduan · materi pelatihan tidak sesuai dengan layar.

**Langkah reproduksi**

1. Masuk ke kolom tanggal di seluruh layar
2. Periksa gejala — petunjuk input tanggal berbahasa Korea, format tanggal read-only tercampur (MM/DD/YYYY vs YYYY-MM-DD)',
  recommendation_md_ko = '- 브라우저 언어 설정과 무관하게 날짜 형식이 YYYY-MM-DD(ISO 8601)로 고정 표시되도록 커스텀 날짜 입력 컴포넌트 적용. 안내문은 영어 또는 인도네시아어로 통일. 향후 KR/EN/ID 다국어 전환 기능 검토.',
  recommendation_md_id = '- Terapkan komponen input tanggal kustom agar format tanggal selalu YYYY-MM-DD (ISO 8601) terlepas dari pengaturan bahasa browser. Teks petunjuk diseragamkan ke bahasa Inggris atau Indonesia. Pertimbangkan fitur pergantian bahasa KR/EN/ID di kemudian hari.',
  business_answer_md_ko = '- 결정 — 필요하되 우선순위 하(오픈 後). 커스텀 날짜 컴포넌트로 ISO 8601 고정, 안내문은 영어 또는 인도네시아어 통일. 읽기전용 날짜 표기 통일은 오픈 前 처리 요청',
  business_answer_md_id = '- Keputusan — diperlukan namun prioritas rendah (setelah Go-Live). Komponen tanggal kustom dengan ISO 8601 tetap, petunjuk diseragamkan ke Inggris atau Indonesia. Penyeragaman format tanggal read-only mohon ditangani sebelum Go-Live'
WHERE issue_no = '15' AND NOT is_archived;

-- 16 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 여신한도(Credit Limit) 필드가 없음.
- [2026-09-01 재검증] 여신한도 필드는 여전히 없으며, 결제조건(Payment Term) 필드 자체도 고객 마스터에 존재하지 않고 DELIVERY TERM(LOCO/FRANCO)과 DC RATE만 관리됨. 미수채권 한도 통제와 대금회수 조건 관리가 모두 불가.

**재현 절차 / Langkah reproduksi**

1. Partners > Customers > 상세 진입
2. 현상 확인 — 고객 마스터 여신한도(Credit Limit) 필드 부재',
  findings_md_id = '- Tidak ada field Credit Limit (batas kredit).
- [Verifikasi ulang 2026-09-01] Field batas kredit masih tidak ada, dan field termin pembayaran (Payment Term) pun tidak ada di master pelanggan; yang dikelola hanya DELIVERY TERM (LOCO/FRANCO) dan DC RATE. Pengendalian batas piutang maupun pengelolaan syarat penagihan tidak dapat dilakukan.

**Langkah reproduksi**

1. Masuk ke Partners > Customers > Detail
2. Periksa gejala — field Credit Limit tidak ada di master pelanggan',
  recommendation_md_ko = '- 고객 마스터에 여신한도·여신등급·결제조건(Payment Term)·담당 영업 필드 추가. SO 등록 시 (미수잔액 + 신규주문액) > 여신한도인 경우 경고 또는 승인 요청 처리.',
  recommendation_md_id = '- Tambahkan field batas kredit · peringkat kredit · termin pembayaran (Payment Term) · sales penanggung jawab pada master pelanggan. Saat registrasi SO, bila (saldo piutang + nilai pesanan baru) > batas kredit, tampilkan peringatan atau proses permintaan persetujuan.',
  business_answer_md_ko = '- 여신 필드 정의서 2026-09-10 전달 — Credit Limit · 여신등급 · 승인일 · 만료일 · 담당 영업 · Payment Term. 결제조건 Table 고객 마스터 화면 노출 요청. 경고 로직 산식 = 미수잔액 + 신규주문액 > 여신한도. 요청 — 필드 신설·입력 오픈 前, 경고 로직 오픈 後',
  business_answer_md_id = '- Definisi field kredit disampaikan 2026-09-10 — Credit Limit · peringkat kredit · tanggal persetujuan · tanggal kedaluwarsa · sales penanggung jawab · Payment Term. Mohon tabel termin pembayaran ditampilkan di layar master pelanggan. Rumus logika peringatan = saldo piutang + nilai pesanan baru > batas kredit. Permintaan — pembuatan field · input sebelum Go-Live, logika peringatan setelah Go-Live'
WHERE issue_no = '16' AND NOT is_archived;

-- 17 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 상세 화면 PHONE NO. 필드에 담당자 이름(''Stevie'')이 저장되어 있고, PIC 탭의 PHONE NO. 열도 동일. FAX 번호는 HP 번호와 동일값. PIC·배송지 레코드가 각각 2건씩 중복. 주소는 Jakarta Utara(14460)이나 CITY는 ''KOTA ADM. JAKARTA SELATAN''.
- [2026-09-01 재검증] PT. TRANS MITRA SEJATI 기준 동일하게 재현(고객 마스터 총 506건).

**재현 절차 / Langkah reproduksi**

1. Partners > Customers > 목록·상세 진입
2. 현상 확인 — 고객 마스터 이관 품질 — 컴럼 매핑 오류(PHONE NO.에 담당자명)·중복',
  findings_md_id = '- Pada layar detail, field PHONE NO. berisi nama penanggung jawab (''Stevie''), dan kolom PHONE NO. di tab PIC juga sama. Nomor FAX sama dengan nomor HP. Record PIC · alamat pengiriman masing-masing ganda 2 baris. Alamat Jakarta Utara (14460) tetapi CITY ''KOTA ADM. JAKARTA SELATAN''.
- [Verifikasi ulang 2026-09-01] Tereproduksi sama pada PT. TRANS MITRA SEJATI (master pelanggan total 506 baris).

**Langkah reproduksi**

1. Masuk ke Partners > Customers > Daftar·Detail
2. Periksa gejala — kualitas migrasi master pelanggan — kesalahan pemetaan kolom (nama PIC di PHONE NO.) · duplikasi',
  recommendation_md_ko = '- 데이터 이관(Migration) 시 컴럼 매핑 재검증 및 전수 정비. 중복 등록 방지 로직(동일 PIC·동일 주소) 추가.',
  recommendation_md_id = '- Verifikasi ulang pemetaan kolom pada migrasi data dan rapikan seluruh data. Tambahkan logika pencegahan duplikasi (PIC sama · alamat sama).',
  business_answer_md_ko = '- 부분 수용. PHONE NO. · PIC 열의 담당자명 저장은 이관 컴럼 매핑 오류 → 개발부서 전수 재매핑(SQL 일괄 / 재이관 방식·일정 회신 요청). 주소 · CITY · 단가 정비는 현업(주요 고객 우선, 오픈 前 착수). 중복 방지 로직(동일 PIC · 동일 주소) 추가',
  business_answer_md_id = '- Diterima sebagian. Nama PIC yang tersimpan di kolom PHONE NO. · PIC adalah kesalahan pemetaan kolom migrasi → tim pengembang memetakan ulang seluruhnya (mohon balasan metode · jadwal: SQL massal / migrasi ulang). Perapian alamat · CITY · harga oleh tim bisnis (pelanggan utama lebih dulu, dimulai sebelum Go-Live). Tambahkan logika pencegahan duplikasi (PIC sama · alamat sama)'
WHERE issue_no = '17' AND NOT is_archived;

-- 18 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- JK TYRE & INDUSTIRES LTD의 COUNTRY가 ''CHINA''로 등록(실주소 New Delhi, India). COUNTRY가 자유 입력 텍스트 필드이며, 사명에 오타(INDUSTIRES) 존재.
- [2026-09-01 재검증] 동일하게 재현(공급사 마스터 총 17건).

**재현 절차 / Langkah reproduksi**

1. Partners > Suppliers > 상세 (COUNTRY) 진입
2. 현상 확인 — 공급사 마스터 COUNTRY 오등록·자유입력',
  findings_md_id = '- COUNTRY untuk JK TYRE & INDUSTIRES LTD terdaftar ''CHINA'' (alamat sebenarnya New Delhi, India). COUNTRY berupa field teks bebas, dan ada salah ketik pada nama perusahaan (INDUSTIRES).
- [Verifikasi ulang 2026-09-01] Tereproduksi sama (master supplier total 17 baris).

**Langkah reproduksi**

1. Masuk ke Partners > Suppliers > Detail (COUNTRY)
2. Periksa gejala — COUNTRY master supplier salah · input bebas',
  recommendation_md_ko = '- COUNTRY를 ISO 국가코드 드롭다운으로 변경. 원산지는 관세율·FTA 적용의 기준이므로 자유입력 금지.',
  recommendation_md_id = '- Ubah COUNTRY menjadi dropdown kode negara ISO. Negara asal adalah dasar penerapan tarif bea masuk · FTA sehingga input bebas dilarang.',
  business_answer_md_ko = '- 마스터 정비 계획(부서 분담표) 2026-09-10 전달 — 오픈 前 착수',
  business_answer_md_id = '- Rencana perapian master (tabel pembagian tugas per bagian) disampaikan 2026-09-10 — dimulai sebelum Go-Live'
WHERE issue_no = '18' AND NOT is_archived;

-- 19 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 필수 항목인 BUY PRICE·SELL PRICE가 대부분 0으로 등록되어 있고 WEIGHT도 0. 제품명에 ''14.00-24-28PR?55MM''와 같이 문자 깨짐 의심 항목 존재. SNI 인증번호·TKDN 등 현지 필수 관리항목 없음.
- [2026-09-01 재검증] 동일하게 재현(제품 마스터 총 1,286건).

**재현 절차 / Langkah reproduksi**

1. Master Data > Products > 목록·상세 진입
2. 현상 확인 — 제품 마스터 단가·중량 0, 인코딩 깨짐(14.00-24-28PR?55MM)',
  findings_md_id = '- BUY PRICE · SELL PRICE yang wajib diisi sebagian besar terdaftar 0, WEIGHT juga 0. Ada nama produk yang dicurigai rusak encoding-nya seperti ''14.00-24-28PR?55MM''. Tidak ada item wajib lokal seperti nomor sertifikat SNI · TKDN.
- [Verifikasi ulang 2026-09-01] Tereproduksi sama (master produk total 1,286 baris).

**Langkah reproduksi**

1. Masuk ke Master Data > Products > Daftar·Detail
2. Periksa gejala — harga · berat master produk 0, encoding rusak (14.00-24-28PR?55MM)',
  recommendation_md_ko = '- 단가·중량 마스터 정비(중량은 부대비 배부 기준으로 사용 가능). 특수문자 인코딩 점검. SNI 인증번호 필드 추가 검토.',
  recommendation_md_id = '- Rapikan master harga · berat (berat dapat dipakai sebagai dasar alokasi biaya tambahan). Periksa encoding karakter khusus. Pertimbangkan penambahan field nomor sertifikat SNI.',
  business_answer_md_ko = '- 해당 규격 삭제 처리 요청(인코딩 깨짐·규격 오류 — 개발부서 「미존재」 회신과 배치, 1,290건 중 3행 실존). 단가·중량 0 정비는 현업 수용. SNI 필드(인증번호·유효기간) 추가 가능 여부 회신 요청. Category 2·3·4 선택지 중복(LT·TB·OTR 각 3회, TT·TL 각 8회) 정리 요청',
  business_answer_md_id = '- Mohon ukuran tersebut dihapus (encoding rusak · ukuran salah — bertentangan dengan balasan tim pengembang 「tidak ada」, 3 baris dari 1,290 memang ada). Perapian harga · berat 0 diterima oleh tim bisnis. Mohon balasan apakah field SNI (nomor sertifikat · masa berlaku) dapat ditambahkan. Mohon rapikan duplikasi pilihan Category 2·3·4 (LT · TB · OTR masing-masing 3 kali, TT · TL masing-masing 8 kali)'
WHERE issue_no = '19' AND NOT is_archived;

-- 20 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 창고 4개소(KARAWANG·SURABAYA·SEMARANG·ASCENDO)의 TYPE이 모두 ''OFFLINE''으로 등록되어 구분 의미가 불명확함.
- [2026-09-01 재검증] 동일하게 재현.

**재현 절차 / Langkah reproduksi**

1. Master Data > Warehouses 진입
2. 현상 확인 — 창고 TYPE 코드값(OFFLINE/VIRTUAL) 구분 불명확, 등록 4개소 전부 OFFLINE',
  findings_md_id = '- TYPE keempat gudang (KARAWANG · SURABAYA · SEMARANG · ASCENDO) semuanya terdaftar ''OFFLINE'' sehingga makna pembedaannya tidak jelas.
- [Verifikasi ulang 2026-09-01] Tereproduksi sama.

**Langkah reproduksi**

1. Masuk ke Master Data > Warehouses
2. Periksa gejala — nilai kode TYPE gudang (OFFLINE/VIRTUAL) tidak jelas, keempat gudang semuanya OFFLINE',
  recommendation_md_ko = '- 창고 TYPE 코드값 정의 공유 및 자가창고·3PL(외부위탁) 구분 추가.',
  recommendation_md_id = '- Bagikan definisi nilai kode TYPE gudang dan tambahkan pembedaan gudang sendiri · 3PL (pihak ketiga).',
  business_answer_md_ko = '- 결정 — 추가 구분 불필요. OFFLINE / VIRTUAL 2구분 유지. VIRTUAL 용도 정의(Claim 창고 해당 여부) 회신 요청, 회신 후 Claim 창고 등록 요청서 전달. 요청 — 오픈 後 · 용도 회신 후 Completed 전환 · 이슈 30은 Open 재분류',
  business_answer_md_id = '- Keputusan — pembedaan tambahan tidak diperlukan. Pertahankan 2 jenis OFFLINE / VIRTUAL. Mohon balasan definisi kegunaan VIRTUAL (apakah mencakup gudang Claim); setelah balasan, formulir permintaan registrasi gudang Claim akan disampaikan. Permintaan — setelah Go-Live · ubah ke Completed setelah balasan kegunaan · Isu 30 direklasifikasi ke Open'
WHERE issue_no = '20' AND NOT is_archived;

-- 21 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 직원 마스터에 DEPARTMENT가 ''SEMARANG''(지역명)으로 등록된 건 존재. 부서 코드 체계가 정의되어 있지 않음.
- [2026-09-01 재검증] 동일하게 재현(직원 마스터 총 77건).

**재현 절차 / Langkah reproduksi**

1. Settings > Search Staff (직원 마스터 DEPARTMENT) 진입
2. 현상 확인 — 직원 마스터 DEPARTMENT 값 표준화 필요 (77명 14종 혼재)',
  findings_md_id = '- Ada data di master karyawan dengan DEPARTMENT ''SEMARANG'' (nama wilayah). Sistem kode departemen belum didefinisikan.
- [Verifikasi ulang 2026-09-01] Tereproduksi sama (master karyawan total 77 orang).

**Langkah reproduksi**

1. Masuk ke Settings > Search Staff (DEPARTMENT master karyawan)
2. Periksa gejala — nilai DEPARTMENT master karyawan perlu distandarkan (77 orang, 14 jenis tercampur)',
  recommendation_md_ko = '- 부서 코드 표준화(SALES / FINANCE / WAREHOUSE / ACCOUNTING / GENERAL) 후 일괄 정비.',
  recommendation_md_id = '- Standarkan kode departemen (SALES / FINANCE / WAREHOUSE / ACCOUNTING / GENERAL) lalu rapikan sekaligus.',
  business_answer_md_ko = '- 회신 내용과 Open 상태 모순 → 부서코드 마스터 적용 여부 확인 후 Completed 전환 또는 잔여 사유 기재. 부서 표준값 9종 제시(지점은 LOCATION으로만 관리). 중요도 공란 보완. 분담 — 개발부서 부서코드 드롭다운 강제·상태 정리 / 인사팀 77명 값 정비·HP NO. 형식 통일',
  business_answer_md_id = '- Isi balasan bertentangan dengan status Open → konfirmasi apakah master kode departemen sudah diterapkan, lalu ubah ke Completed atau cantumkan alasan yang tersisa. Diajukan 9 nilai standar departemen (cabang hanya dikelola lewat LOCATION). Lengkapi prioritas yang kosong. Pembagian — tim pengembang: paksa dropdown kode departemen · rapikan status / tim HR: rapikan nilai 77 orang · seragamkan format HP NO.'
WHERE issue_no = '21' AND NOT is_archived;

-- 22 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 금액이 인도네시아식(1.234,56)으로 표기됨. 당사 문서 표준은 영미식(1,234.56)이며 대외 문서와 표기가 상이.
- [2026-09-01 재검증] 견적 합계(1.377.770), 선적 금액(108.800,00), 제품 단가(0,00) 등 전 화면에서 동일하게 재현. IDR 금액에 소수점 2자리가 함께 사용되어 이슈 13(IDR 정수 원칙)과도 상충.

**재현 절차 / Langkah reproduksi**

1. 전 화면 (금액 · 수량 · 단가 표기) 진입
2. 현상 확인 — 전 화면 인도네시아식 숫자 표기(780.911.647), 합계 라벨만 영미식으로 혼재',
  findings_md_id = '- Nilai uang ditulis dengan format Indonesia (1.234,56). Standar dokumen perusahaan adalah format Inggris/Amerika (1,234.56) sehingga berbeda dengan dokumen eksternal.
- [Verifikasi ulang 2026-09-01] Tereproduksi sama di seluruh layar: total penawaran (1.377.770), nilai pengapalan (108.800,00), harga produk (0,00), dll. Nilai IDR juga memakai 2 angka desimal sehingga bertentangan dengan Isu 13 (prinsip IDR bilangan bulat).

**Langkah reproduksi**

1. Masuk ke seluruh layar (penulisan nilai · kuantitas · harga satuan)
2. Periksa gejala — format angka Indonesia di seluruh layar (780.911.647), hanya label total yang memakai format Inggris (tercampur)',
  recommendation_md_ko = '- 천 단위 구분은 콤마(,), 소수점은 마침표(.)로 통일. 수량은 정수, 단가는 소수점 2자리, IDR 총액은 정수로 자리수 규칙 고정.',
  recommendation_md_id = '- Seragamkan pemisah ribuan koma (,) dan desimal titik (.). Tetapkan aturan digit: kuantitas bilangan bulat, harga satuan 2 desimal, total IDR bilangan bulat.',
  business_answer_md_ko = '- 결정 — 영미식 확정. 천 단위 콤마(,) · 소수점 마침표(.) · 수량 정수 · 단가 소수점 2자리 · IDR 총액 정수. 13번(IDR 소수점)과 통합 처리. 요청 — 오픈 前 · Ongoing 전환 · 완료 예정일 기재',
  business_answer_md_id = '- Keputusan — format Inggris/Amerika ditetapkan. Pemisah ribuan koma (,) · desimal titik (.) · kuantitas bilangan bulat · harga satuan 2 desimal · total IDR bilangan bulat. Ditangani terpadu dengan Isu 13 (desimal IDR). Permintaan — sebelum Go-Live · ubah ke Ongoing · cantumkan tanggal target penyelesaian'
WHERE issue_no = '22' AND NOT is_archived;

-- 23 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 브라우저 폭 약 1,200px 미만에서 입력 폼이 무너지고 라벨·값이 잘림(Categ..., SECTION WIDT..., PAYME/NT). 목록은 대부분 가로 스크롤이 필요하며 좌측 기준열이 고정되지 않음.
- [2026-09-01 재검증] 창 폭 1,366px 견적 화면에서 QUOTE DATE 입력값이 ''202(''로 잘리는 현상 재현.

**재현 절차 / Langkah reproduksi**

1. 전 화면 (목록 · 상세 레이아웃) 진입
2. 현상 확인 — 반응형 레이아웃 라벨 잘림·기준열 미고정',
  findings_md_id = '- Pada lebar browser di bawah sekitar 1,200px, form input rusak dan label · nilai terpotong (Categ..., SECTION WIDT..., PAYME/NT). Sebagian besar daftar memerlukan scroll horizontal dan kolom acuan di kiri tidak terkunci.
- [Verifikasi ulang 2026-09-01] Pada layar penawaran dengan lebar jendela 1,366px, nilai input QUOTE DATE terpotong menjadi ''202('' — tereproduksi.

**Langkah reproduksi**

1. Masuk ke seluruh layar (tata letak daftar · detail)
2. Periksa gejala — tata letak responsif: label terpotong · kolom acuan tidak terkunci',
  recommendation_md_ko = '- 반응형 레이아웃 적용, 라벨 잘림 시 툴팁 제공, 목록 첫 열(문서번호·제품명) 고정(sticky) 처리. 최소 지원 해상도는 1,366 × 768 (권장 1,920 × 1,080)로 정의.',
  recommendation_md_id = '- Terapkan tata letak responsif, sediakan tooltip saat label terpotong, kunci (sticky) kolom pertama daftar (nomor dokumen · nama produk). Tetapkan resolusi minimum yang didukung 1,366 × 768 (disarankan 1,920 × 1,080).',
  business_answer_md_ko = '- —',
  business_answer_md_id = '- —'
WHERE issue_no = '23' AND NOT is_archived;

-- 24 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 페이지당 10건 고정(제품 1,286건 = 129페이지, 재고 602건 = 61페이지). 페이지 크기 선택·기간 필터·정렬 기능 없음. 페이지 크기 고정은 동일하게 재현. 다만 제품·재고 목록에는 카테고리 필터·Reset·Excel 내보내기 버튼이 제공되고 있어 화면별 편차가 확인됨.

**재현 절차 / Langkah reproduksi**

1. 전 목록 화면 진입
2. 현상 확인 — 목록 화면 페이지 크기·필터·정렬 기능 부재 (API는 page·limit 지원)',
  findings_md_id = '- Jumlah baris per halaman tetap 10 (produk 1,286 baris = 129 halaman, stok 602 baris = 61 halaman). Tidak ada pilihan ukuran halaman · filter periode · pengurutan. Ukuran halaman tetap tereproduksi sama. Namun daftar produk · stok menyediakan filter kategori · Reset · tombol ekspor Excel, sehingga terlihat perbedaan antar layar.

**Langkah reproduksi**

1. Masuk ke seluruh layar daftar
2. Periksa gejala — layar daftar tidak memiliki ukuran halaman · filter · pengurutan (API mendukung page · limit)',
  recommendation_md_ko = '- 페이지 크기 선택(10/30/50/100), 열 머리글 정렬, 기간(발주일·입고일) 필터 추가. Excel 내보내기 버튼도 화면별로 유무가 달라 일관성 필요.',
  recommendation_md_id = '- Tambahkan pilihan ukuran halaman (10/30/50/100), pengurutan lewat header kolom, filter periode (tanggal PO · tanggal penerimaan). Tombol ekspor Excel juga ada/tidak ada tergantung layar, perlu konsistensi.',
  business_answer_md_ko = '- 1단계 — 페이지 크기 선택(10 / 20 / 50 / 100) + 열 헤더 정렬 (API 변경 없이 화면만), 오픈 前. 2단계 — 상태 · 기간 · 거래처 필터, 오픈 後. 1단계 화면 적용 일정 회신 요청',
  business_answer_md_id = '- Tahap 1 — pilihan ukuran halaman (10 / 20 / 50 / 100) + pengurutan header kolom (hanya layar, tanpa perubahan API), sebelum Go-Live. Tahap 2 — filter status · periode · mitra usaha, setelah Go-Live. Mohon balasan jadwal penerapan tahap 1'
WHERE issue_no = '24' AND NOT is_archived;

-- 25 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 필수값 미입력 시 하단에 검정 토스트로 한 건씩만 안내되고, 해당 필드에 포커스나 색상 표시가 없음. 동일 재현(''Warehouse is required'', ''Container No. (row 1) is required''). 추가 확인 사항 — (1) 검색형 입력란(창고·공급사·고객·품목)은 목록에서 항목을 선택하지 않고 검색어만 남긴 경우 화면에는 값이 보이나 실제로는 미입력으로 처리되어, 담당자가 원인을 알기 어려움. (2) 다른 탭(CONTAINER)에 있는 미입력 항목의 오류가 탭 표시 없이 안내되어 위치 파악이 어려움.

**재현 절차 / Langkah reproduksi**

1. 전 입력 화면 (저장 시 검증) 진입
2. 현상 확인 — 입력 검증 — 미입력 항목 안내 없음, 저장 실패 원인 미표시',
  findings_md_id = '- Saat nilai wajib belum diisi, hanya muncul toast hitam di bawah satu per satu, tanpa fokus atau penanda warna pada field terkait. Tereproduksi sama (''Warehouse is required'', ''Container No. (row 1) is required''). Temuan tambahan — (1) Pada kolom input tipe pencarian (gudang · pemasok · pelanggan · item), bila hanya kata kunci yang diketik tanpa memilih dari daftar, nilai tampak terisi di layar namun sebenarnya dianggap kosong, sehingga pengguna sulit mengetahui penyebabnya. (2) Kesalahan pada item kosong di tab lain (CONTAINER) ditampilkan tanpa menyebut tab, sehingga lokasinya sulit ditemukan.

**Langkah reproduksi**

1. Masuk ke seluruh layar input (validasi saat simpan)
2. Periksa gejala — validasi input: tidak ada petunjuk item kosong, penyebab gagal simpan tidak ditampilkan',
  recommendation_md_ko = '- 미입력 항목 전체를 한 번에 표시하고 해당 필드를 적색 테두리로 표시, 첫 항목으로 자동 포커스 이동. 검색형 입력란은 목록에서 선택하지 않은 검색어를 저장 시 자동 초기화하거나 미선택 상태를 시각적으로 구분. 오류 항목이 다른 탭에 있는 경우 해당 탭으로 자동 이동.',
  recommendation_md_id = '- Tampilkan seluruh item yang belum diisi sekaligus, beri bingkai merah pada field terkait, dan pindahkan fokus otomatis ke item pertama. Pada kolom tipe pencarian, kata kunci yang tidak dipilih dari daftar dikosongkan otomatis saat simpan, atau status belum-dipilih dibedakan secara visual. Bila item bermasalah ada di tab lain, pindah otomatis ke tab tersebut.',
  business_answer_md_ko = '- 필수 항목 미입력 시 해당 필드 강조 + 항목명 포함 메시지 표시. 저장 실패 원인을 사용자가 인지하지 못하는 현상은 교육·운영 부담 직결. 오픈 前 · 완료 예정일 기재 요청',
  business_answer_md_id = '- Saat item wajib kosong: sorot field terkait + pesan yang menyebut nama item. Pengguna yang tidak tahu penyebab gagal simpan langsung menambah beban pelatihan · operasional. Sebelum Go-Live · mohon cantumkan tanggal target penyelesaian'
WHERE issue_no = '25' AND NOT is_archived;

-- 26 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 프로필 이미지 API(/api/avatar/A20170147/)가 404 반환(2026-09-01 재확인). 로그인 화면 배경 이미지는 자사 도메인([asm.ascendotyre.com/assets)으로](http://asm.ascendotyre.com/assets)으로) 변경되었으나, 애플리케이션 내 이미지 참조에는 외부 도메인([ascendo-asm.com/assets/images/auth/login.png)이](http://ascendo-asm.com/assets/images/auth/login.png)이) 남아 있어 도메인 혼재가 계속됨.

**재현 절차 / Langkah reproduksi**

1. 로그인 화면 · /api/avatar 진입
2. 현상 확인 — 정적 자원 404 및 도메인 혼재',
  findings_md_id = '- API gambar profil (/api/avatar/A20170147/) mengembalikan 404 (dicek ulang 2026-09-01). Gambar latar layar login sudah diubah ke domain perusahaan (asm.ascendotyre.com/assets), namun referensi gambar di dalam aplikasi masih memakai domain eksternal (ascendo-asm.com/assets/images/auth/login.png) sehingga domain tetap tercampur.

**Langkah reproduksi**

1. Masuk ke layar login · /api/avatar
2. Periksa gejala — aset statis 404 dan domain tercampur',
  recommendation_md_ko = '- 404 해소 및 정적 자원을 서비스 도메인([asm.ascendotyre.com](http://asm.ascendotyre.com))으로 일원화.',
  recommendation_md_id = '- Atasi 404 dan satukan aset statis ke domain layanan (asm.ascendotyre.com).',
  business_answer_md_ko = '- 조치 확인 (2026-09-07) — /api/avatar/A20170147/ 200 정상 응답, [ascendo-asm.com](http://ascendo-asm.com) 참조 없음',
  business_answer_md_id = '- Perbaikan dikonfirmasi (2026-09-07) — /api/avatar/A20170147/ merespons 200 normal, tidak ada referensi ke ascendo-asm.com'
WHERE issue_no = '26' AND NOT is_archived;

-- 27 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- PAYMENT TERM pada PO (HA-20260901-001) didaftarkan sebagai ''30 days'', namun pada layar Receipt yang dibuat dari PO tersebut PAYMENT TERM tampil sebagai ''14'' (sama dengan nilai default master pemasok). Diduga dokumen lanjutan mengacu pada nilai default master, bukan pada kondisi final dokumen asal. Termin pembayaran merupakan dasar perhitungan tanggal jatuh tempo pembayaran, sehingga perbedaan nilai antar dokumen dapat menimbulkan kesalahan pada rencana kas dan saldo utang. (dikonfirmasi 2026-09-01)

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Baru → Purchasing > Receipt > Detail
2. Konfirmasi gejala — PO PAYMENT TERM 30 days → tampil 14 (nilai default master) pada Receipt, dokumen lanjutan mengacu ke nilai default master

# 8. Pengukuran Aktual di Server Produksi (2026-09-07)

- Hasil — Perbaikan sebagian. PO HA-20260901-001 PAYMENT TERM 30 days → pada detail Receipt yang dibuat dari PO tersebut PAYMENT TERM tampil 30, pewarisan dikonfirmasi normal
- Item belum diverifikasi — apakah kondisi pada saat dokumen dibuat disimpan sebagai riwayat (pencegahan berlaku surut pada dokumen lama saat master pemasok diubah). Belum dilaksanakan karena memerlukan perubahan master pemasok yang sedang aktif bertransaksi
- Tindak lanjut — perlu dicek apakah nilai pada dokumen lama tetap dipertahankan setelah PAYMENT TERM master diubah menggunakan akun pemasok uji coba',
  findings_md_ko = '- PO(HA-20260901-001)의 PAYMENT TERM은 ''30 days''로 등록되었으나, 해당 PO에서 생성된 Receipt 화면에는 PAYMENT TERM이 ''14''(공급사 마스터 기본값과 동일)로 표시됨. 후속 전표가 원전표의 확정 조건이 아닌 마스터 기본값을 참조하는 것으로 추정. 결제조건은 지급 만기일 산정의 기준이므로 전표 간 값이 다르면 자금 계획·채무 잔액에 오류가 생길 수 있음. (2026-09-01 확인)

**재현 절차**

1. Purchasing > PO > 신규 → Purchasing > Receipt > 상세 진입
2. 현상 확인 — PO PAYMENT TERM 30 days → Receipt에서 14(마스터 기본값) 표시, 후속 전표가 마스터 기본값 참조

# 8. 실서버 실측 (2026-09-07)

- 결과 — 부분 조치. PO HA-20260901-001 PAYMENT TERM 30 days → 해당 PO에서 생성한 Receipt 상세의 PAYMENT TERM 30 표시, 승계 정상 확인
- 미검증 항목 — 전표 생성 시점의 조건이 이력으로 보존되는지(공급사 마스터 변경 시 기존 전표 소급 방지). 거래 중인 공급사 마스터를 변경해야 하므로 미실시
- 후속 조치 — 테스트용 공급사 계정으로 마스터 PAYMENT TERM 변경 후 기존 전표 값 유지 여부 확인 필요',
  recommendation_md_id = '- Dokumen lanjutan seperti pengapalan, kepabeanan, dan penerimaan barang harus mewarisi termin pembayaran final dari dokumen asal (PO), bukan nilai default master. Kondisi pada saat dokumen dibuat disimpan sebagai riwayat dan dipisahkan agar perubahan master tidak berlaku surut pada dokumen lama. Disarankan menampilkan peringatan apabila terjadi ketidaksesuaian kondisi antar dokumen.',
  recommendation_md_ko = '- 선적·통관·입고 등 후속 전표는 마스터 기본값이 아닌 원전표(PO)의 확정 결제조건을 승계해야 함. 전표 생성 시점의 조건을 이력으로 저장·분리하여 마스터 변경이 기존 전표에 소급되지 않도록 처리. 전표 간 조건 불일치 시 경고 표시 권장.',
  business_answer_md_id = '- Balasan Completed telah diterima. Pertanyaan tambahan — mohon konfirmasi apakah termin pembayaran pada saat dokumen dibuat disimpan sebagai riwayat (pencegahan berlaku surut pada dokumen lama saat master diubah) (2026-09-07)',
  business_answer_md_ko = '- Completed 회신 확인. 추가 질의 — 전표 생성 시점의 결제조건이 이력으로 보존되는지(마스터 변경 시 기존 전표 소급 방지) 확인 요청 (2026-09-07)'
WHERE issue_no = '27' AND NOT is_archived;

-- 28 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 1건의 신규 견적(Quotation)에 동일 품목을 두 번 입력할 수 없음. 중복 입력 시 「Check Product」 안내가 표시되며 저장되지 않음. 타이어 세트(Tire · Tube · Flap) 구성 시 동일 Flap 규격이 서로 다른 외경 타이어에 공용되므로, 창고팀의 세트 구성 확인과 문서 가독성을 위해 동일 품목의 복수 행 입력이 필요함. 요청자 입력 예시 — ASC 10.00R20 AR102HD 18++ / ASC 10.00-20 TR78 Heavy Duty / ASC 10.00/11.00R20 (H) Metal Plate / ASC 11.00R20 AR102HD 18++ / ASC 11.00-20 TR78 Heavy Duty / ASC 10.00/11.00R20 (H) Metal Plate.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Quotation > 신규 (품목 입력) 진입
2. 현상 확인 — 견적 신규 동일 품목 중복 입력 불가

# 8. 실서버 실측 (2026-09-07)

- 결과 — 부분조치. Sales > Quotation > 신규에서 Add Item 2행에 동일 품목(AOSO 10.00R20 AR101 18) 입력 성공, 「Check Product」 차단 안내 미발생
- 미검증 항목 — 저장(Save) 단계 서버 검증 통과 여부, 후속 전표(Customer PO · SO · Delivery Order · Delivery Note) 동일 기준 적용 여부
- 유의 — 수용기준이 「견적 신규」로만 기재되어 개선 의견(판매 전 전표 전체 적용)보다 범위가 좁음. Verified 전환 전 후속 전표 확인 필요',
  findings_md_id = '- Dalam satu penawaran (Quotation) baru, item yang sama tidak dapat diinput dua kali. Saat duplikat, muncul petunjuk 「Check Product」 dan tidak tersimpan. Pada penyusunan set ban (Tire · Tube · Flap), ukuran Flap yang sama dipakai bersama untuk ban berdiameter luar berbeda, sehingga input beberapa baris item yang sama diperlukan demi pengecekan set oleh tim gudang dan keterbacaan dokumen. Contoh input pemohon — ASC 10.00R20 AR102HD 18++ / ASC 10.00-20 TR78 Heavy Duty / ASC 10.00/11.00R20 (H) Metal Plate / ASC 11.00R20 AR102HD 18++ / ASC 11.00-20 TR78 Heavy Duty / ASC 10.00/11.00R20 (H) Metal Plate.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > Quotation > Baru (input item)
2. Periksa gejala — item yang sama tidak dapat diinput ganda pada penawaran baru

# 8. Pengukuran aktual di server produksi (2026-09-07)

- Hasil — perbaikan sebagian. Di Sales > Quotation > Baru, input item yang sama (AOSO 10.00R20 AR101 18) pada 2 baris Add Item berhasil, petunjuk pemblokiran 「Check Product」 tidak muncul
- Item belum diverifikasi — apakah lolos validasi server pada tahap Save, dan apakah kriteria yang sama berlaku pada dokumen lanjutan (Customer PO · SO · Delivery Order · Delivery Note)
- Catatan — kriteria selesai hanya mencantumkan 「penawaran baru」 sehingga lebih sempit dari rekomendasi (seluruh dokumen penjualan). Sebelum diubah ke Verified, dokumen lanjutan perlu dicek',
  recommendation_md_ko = '- 동일 품목의 복수 행 입력 허용. Flap·Tube 등 공용 부속은 중복 검증 대상에서 제외하거나, 중복 시 저장 차단이 아닌 확인 안내(경고) 후 저장 허용으로 변경. 판매 전 전표(견적 · Customer PO · SO · Delivery Order · Delivery Note)에 동일 기준 적용.',
  recommendation_md_id = '- Izinkan input beberapa baris untuk item yang sama. Komponen bersama seperti Flap · Tube dikecualikan dari validasi duplikat, atau saat duplikat tidak diblokir melainkan diberi peringatan konfirmasi lalu boleh disimpan. Terapkan kriteria yang sama pada seluruh dokumen penjualan (Penawaran · Customer PO · SO · Delivery Order · Delivery Note).',
  business_answer_md_ko = '- 현지 사용자 확인 후 Verified 전환 예정',
  business_answer_md_id = '- Akan diubah ke Verified setelah konfirmasi pengguna lokal'
WHERE issue_no = '28' AND NOT is_archived;

-- 29 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- Customer PO · SO 화면에는 품목행에 Remarks 입력란이 있으나 Delivery Order · Delivery Note 화면에는 없음. 출하 시 품목별 특기사항(포장 구분, 세트 구성, 고객 요청사항 등)을 현장에 전달할 수 없음.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Order 진입
2. 현상 확인 — DO·DN 신규 품목별 비고(Remarks) 열 부재',
  findings_md_id = '- Layar Customer PO · SO memiliki kolom Remarks pada baris item, namun layar Delivery Order · Delivery Note tidak. Catatan khusus per item saat pengiriman (jenis kemasan, komposisi set, permintaan pelanggan, dll.) tidak dapat disampaikan ke lapangan.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > Delivery Order
2. Periksa gejala — kolom Remarks per item tidak ada pada DO · DN baru',
  recommendation_md_ko = '- Delivery Order · Delivery Note 품목행에 Remarks 열 추가. 선행 전표(SO)의 품목 Remarks가 후속 전표로 승계되도록 하고, 출하 시점의 추가 입력·수정도 가능하도록 처리.',
  recommendation_md_id = '- Tambahkan kolom Remarks pada baris item Delivery Order · Delivery Note. Remarks item dari dokumen sebelumnya (SO) diwariskan ke dokumen lanjutan, dan input · perubahan tambahan saat pengiriman juga dimungkinkan.',
  business_answer_md_ko = '- 진행 범위 기재 요청 (2026-09-07 재현)',
  business_answer_md_id = '- Mohon cantumkan lingkup pengerjaan (tereproduksi 2026-09-07)'
WHERE issue_no = '29' AND NOT is_archived;

-- 30 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- SO 신규 화면의 Warehouse 선택 항목에 Arami 공장 클레임 교체품 전용 로케이션이 없음. 이로 인해 클레임 교체품이 고객에게 출고되었는지 여부를 시스템에서 구분하여 관리할 수 없고, 정상 판매 재고와 혼재됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > SO > 신규 (창고 선택) 진입
2. 현상 확인 — 클레임 교체품 보관 로케이션 부재',
  findings_md_id = '- Pada pilihan Warehouse di layar SO baru tidak ada lokasi khusus barang pengganti klaim pabrik Arami. Akibatnya, apakah barang pengganti klaim sudah dikirim ke pelanggan tidak dapat dibedakan dan dikelola di sistem, dan tercampur dengan stok penjualan normal.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > SO > Baru (pilih gudang)
2. Periksa gejala — tidak ada lokasi penyimpanan barang pengganti klaim',
  recommendation_md_ko = '- 창고 마스터에 클레임 전용 로케이션 3개 신설 — Claim Karawang · Claim Semarang · Claim Surabaya. Arami 공장 클레임 교체품에 한정하여 사용하고, 재고·출고 조회 시 정상 재고와 구분 표시. 창고 마스터 변경은 승인 매트릭스(R10 → R8, 1영업일)에 따라 처리.',
  recommendation_md_id = '- Buat 3 lokasi khusus klaim di master gudang — Claim Karawang · Claim Semarang · Claim Surabaya. Digunakan terbatas untuk barang pengganti klaim pabrik Arami, dan dibedakan dari stok normal saat cek stok · pengiriman. Perubahan master gudang diproses sesuai matriks persetujuan (R10 → R8, 1 hari kerja).',
  business_answer_md_ko = '- 상태 재분류 Completed → Open. 20번 VIRTUAL 용도 회신 후 Claim 창고 등록 요청서(Claim Karawang · Claim Semarang · Claim Surabaya, 승인 매트릭스 R10 → R8) 2026-09-10 전달',
  business_answer_md_id = '- Reklasifikasi status Completed → Open. Setelah balasan kegunaan VIRTUAL pada Isu 20, formulir permintaan registrasi gudang Claim (Claim Karawang · Claim Semarang · Claim Surabaya, matriks persetujuan R10 → R8) disampaikan 2026-09-10'
WHERE issue_no = '30' AND NOT is_archived;

-- 31 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 창고팀이 Delivery Note를 생성하려면 Admin의 확정(Confirm)을 대기해야 하는 구조인지 확인 필요. 현업 운영상 출고 실행 가능 여부는 실재고·차량 배차를 확인하는 창고 책임자의 판단 사항이므로, Admin 확정 대기 시 출고가 지연됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Note > 상세 (Confirm 권한) 진입
2. 현상 확인 — Delivery Note Confirm 주체 창고 책임자 지정 요청',
  findings_md_id = '- Perlu dipastikan apakah tim gudang harus menunggu konfirmasi (Confirm) Admin untuk membuat Delivery Note. Dalam operasional, keputusan bisa-tidaknya pengiriman dilakukan adalah kewenangan penanggung jawab gudang yang memeriksa stok riil · penjadwalan kendaraan, sehingga menunggu konfirmasi Admin menunda pengiriman.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > Delivery Note > Detail (hak Confirm)
2. Periksa gejala — permintaan agar penanggung jawab gudang ditetapkan sebagai pihak yang meng-Confirm Delivery Note',
  recommendation_md_ko = '- Delivery Note 생성 확정(Confirm) 권한을 Admin이 아닌 R10 창고 관리자(Firman Taurus)에게 부여 요청. 권한 문서 개정은 불필요 — 「ASM 권한가이드라인 v3.0」 02 역할 정의에서 R10의 핵심 권한에 이미 「출고 승인」이 포함되어 있고, 권한 매트릭스의 출고·배송 모듈도 R10 = ●(전체관리)로 부여되어 있음. 현재 Admin 확정을 요구하는 것은 문서와 다른 구현이므로 문서 기준대로 시정 요청. 단 요청에 포함된 Aris Budiana는 R11 창고 담당자로 출고·배송 = ◐(생성·편집, 승인 제외)이므로 확정 권한 부여 시 역할 정의와 충돌 — 확정은 R10, 실행은 R11로 분리 유지.',
  recommendation_md_id = '- Mohon hak konfirmasi (Confirm) pembuatan Delivery Note diberikan kepada R10 Manajer Gudang (Firman Taurus), bukan Admin. Revisi dokumen hak akses tidak diperlukan — pada 「Pedoman Hak Akses ASM v3.0」 bagian 02 definisi peran, hak inti R10 sudah mencakup 「persetujuan pengiriman」, dan pada matriks hak akses modul pengiriman · distribusi untuk R10 = ● (kelola penuh). Implementasi saat ini yang mewajibkan konfirmasi Admin berbeda dari dokumen, mohon disesuaikan dengan dokumen. Namun Aris Budiana yang tercantum dalam permintaan adalah R11 staf gudang dengan pengiriman · distribusi = ◐ (buat · ubah, tanpa persetujuan), sehingga pemberian hak konfirmasi bertentangan dengan definisi peran — konfirmasi tetap R10, pelaksanaan R11.',
  business_answer_md_ko = '- Flow 정의서 2026-09-10 전달 — 출고 확정 권한 Admin → 창고 책임자. 창고 계정의 Confirm 권한 보유 여부 계정별 확인 필요',
  business_answer_md_id = '- Dokumen definisi Flow disampaikan 2026-09-10 — hak konfirmasi pengiriman Admin → penanggung jawab gudang. Perlu pengecekan per akun apakah akun gudang memiliki hak Confirm'
WHERE issue_no = '31' AND NOT is_archived;

-- 32 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- Delivery Location에서 배송 주소를 변경하여도 Cust Contact 값이 함께 변경되지 않음. 실제 배송 시 전표상 담당자와 도착 창고의 인수 담당자가 달라 인수인계 오류 및 하차 지연이 발생할 수 있음. Delivery Note 화면에도 동일하게 적용됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Order > 신규 (배송지 · Cust Contact) 진입
2. 현상 확인 — 배송지 변경 시 고객 담당자(Cust Contact) 미연동',
  findings_md_id = '- Saat alamat pengiriman diubah di Delivery Location, nilai Cust Contact tidak ikut berubah. Pada pengiriman nyata, penanggung jawab di dokumen berbeda dengan penerima di gudang tujuan sehingga dapat terjadi kesalahan serah terima dan keterlambatan bongkar. Berlaku sama pada layar Delivery Note.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > Delivery Order > Baru (alamat pengiriman · Cust Contact)
2. Periksa gejala — Cust Contact tidak ikut berubah saat alamat pengiriman diganti',
  recommendation_md_ko = '- Delivery Location 선택 시 해당 주소의 창고 담당자(PIC)가 Cust Contact에 자동 반영되도록 처리. 이를 위해 고객 마스터에 배송지별 담당자(성명 · 연락처) 매핑 필드를 추가하고, 자동 반영 후 수동 수정도 가능하도록 함.',
  recommendation_md_id = '- Saat Delivery Location dipilih, PIC gudang untuk alamat tersebut otomatis terisi pada Cust Contact. Untuk itu tambahkan field pemetaan PIC per alamat pengiriman (nama · kontak) pada master pelanggan, dan setelah terisi otomatis tetap dapat diubah manual.',
  business_answer_md_ko = '- 조치 내용 미기재 Ongoing 항목 — 진행 범위 기재 요청 (2026-09-07)',
  business_answer_md_id = '- Item Ongoing tanpa uraian perbaikan — mohon cantumkan lingkup pengerjaan (2026-09-07)'
WHERE issue_no = '32' AND NOT is_archived;

-- 33 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 단가(Unit Price)를 직접 수정하면 마진율이 재계산되나, 단가를 유지한 채 할인율(DC Rate)만 입력하면 마진율이 변동하지 않음. 할인 판매 시 실제 마진을 화면에서 확인할 수 없어 할인 승인 판단 근거가 부재함.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Quotation > 신규 (DC Rate · Margin %) 진입
2. 현상 확인 — 할인율(DC Rate) 입력 시 마진율(Margin %) 미재계산',
  findings_md_id = '- Bila harga satuan (Unit Price) diubah langsung, margin dihitung ulang, tetapi bila hanya diskon (DC Rate) yang diinput dengan harga satuan tetap, margin tidak berubah. Margin nyata pada penjualan diskon tidak dapat dilihat di layar sehingga tidak ada dasar untuk keputusan persetujuan diskon.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > Quotation > Baru (DC Rate · Margin %)
2. Periksa gejala — Margin % tidak dihitung ulang saat DC Rate diinput',
  recommendation_md_ko = '- 마진율을 (단가 − 할인금액) 기준으로 산출하도록 계산식 수정. 할인율(DC Rate) · 할인금액(DC Amt) 입력 시 마진율이 즉시 재계산되도록 처리. 할인 판매 승인(R2/R12 → R1) 기준 금액과 동일한 산식 적용 요청. 표시 범위는 필드 마스킹(C2) 기준 유지 — 마진율(L3 기밀)은 R3 · R13에게 율(%) 비노출이므로, 견적 작성자 화면에는 「표준마진 미달」 여부만 신호로 표시하고 율 자체는 R1 · R2 · R4 · R8 · R12(자점)에만 노출.',
  recommendation_md_id = '- Ubah rumus agar margin dihitung dari (harga satuan − nilai diskon). Margin dihitung ulang seketika saat DC Rate · DC Amt diinput. Terapkan rumus yang sama dengan nilai dasar persetujuan penjualan diskon (R2/R12 → R1). Cakupan tampilan mengikuti masking field (C2) — margin (rahasia L3) tidak ditampilkan sebagai persentase kepada R3 · R13, sehingga pada layar pembuat penawaran hanya ditampilkan sinyal 「di bawah margin standar」, sedangkan persentasenya hanya untuk R1 · R2 · R4 · R8 · R12 (cabang sendiri).',
  business_answer_md_ko = '- 조치 내용 미기재 Ongoing 항목 — 진행 범위 기재 요청 (2026-09-07)',
  business_answer_md_id = '- Item Ongoing tanpa uraian perbaikan — mohon cantumkan lingkup pengerjaan (2026-09-07)'
WHERE issue_no = '33' AND NOT is_archived;

-- 34 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 견적 및 Customer PO 승인 요청 시 Checker 1 · Checker 2 · Approver에게 ASM 시스템 알림이 발송되지 않아 결재 대기 건의 인지가 지연됨. 결재 대기 건을 별도로 조회할 수 있는 화면도 없음.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Quotation 진입
2. 현상 확인 — 견적·Customer PO 승인 시 결재자 알림 기능 부재, 결재 대기 조회 화면 없음',
  findings_md_id = '- Saat permintaan persetujuan penawaran dan Customer PO, notifikasi sistem ASM tidak dikirim ke Checker 1 · Checker 2 · Approver sehingga dokumen yang menunggu persetujuan terlambat diketahui. Juga tidak ada layar untuk melihat daftar dokumen yang menunggu persetujuan.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Sales > Quotation
2. Periksa gejala — tidak ada notifikasi ke penyetuju saat persetujuan penawaran · Customer PO, tidak ada layar daftar menunggu persetujuan',
  recommendation_md_ko = '- 결재 요청 발생 시 지정 결재선에 시스템 알림 발송(내부 알림 및 메일). 결재 대기 건 목록 화면 제공. 발주(Purchase PO) 결재에도 동일 적용. 결재선 필수화(이슈 「승인 절차 연계」 항목)와 함께 처리 요청.',
  recommendation_md_id = '- Saat permintaan persetujuan dibuat, kirim notifikasi sistem ke jalur persetujuan yang ditetapkan (notifikasi internal dan email). Sediakan layar daftar dokumen menunggu persetujuan. Terapkan sama pada persetujuan pembelian (Purchase PO). Mohon ditangani bersama kewajiban jalur persetujuan (item isu 「keterkaitan prosedur persetujuan」).',
  business_answer_md_ko = '- 현업 Flow 정의서 2026-09-10 전달 — 결재선(Checker 1 · Checker 2 · Approver) · 알림 대상 · 알림 수단(내부 알림 + 메일). 「ASM 권한 가이드라인 v3.0」 승인 매트릭스 기준. 요청 — 결재 대기 목록 화면 오픈 前, 메일 알림 오픈 後, 정의서 수령 후 완료 예정일 기재',
  business_answer_md_id = '- Dokumen definisi Flow tim bisnis disampaikan 2026-09-10 — jalur persetujuan (Checker 1 · Checker 2 · Approver) · penerima notifikasi · sarana notifikasi (notifikasi internal + email). Mengacu matriks persetujuan 「Pedoman Hak Akses ASM v3.0」. Permintaan — layar daftar menunggu persetujuan sebelum Go-Live, notifikasi email setelah Go-Live, cantumkan tanggal target setelah dokumen definisi diterima'
WHERE issue_no = '34' AND NOT is_archived;

-- 35 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- (1) 재고 수량이 확보된 경우에만 SO 입력이 가능함. (2) 실제 출하가 계획과 다를 때(적재 만재, 실재고 부족 등) DO · SO의 잔량을 수정할 수 없음. (3) SO에 묶인 잔여 재고가 타 고객에게 판매되지 않아 재고 회전이 제약됨.
- [2026-09-02 현지 사용자 개선요청 — 원 요청은 「SO 재고 잠금 해제」였으나 동일 재고의 이중 확약(중복 판매) 위험을 고려하여 아래와 같이 조정하여 반영]

**재현 절차 / Langkah reproduksi**

1. Sales > SO > 신규·상세 (재고 연동) 진입
2. 현상 확인 — SO 재고 연동 및 후속 전표 수정 제약',
  findings_md_id = '- (1) SO hanya dapat diinput bila kuantitas stok tersedia. (2) Saat pengiriman nyata berbeda dari rencana (muatan penuh, stok riil kurang, dll.), sisa DO · SO tidak dapat diubah. (3) Sisa stok yang terikat pada SO tidak dapat dijual ke pelanggan lain sehingga perputaran stok terhambat.
- [Permintaan perbaikan pengguna lokal 2026-09-02 — permintaan asli adalah 「lepas penguncian stok SO」, namun dengan mempertimbangkan risiko komitmen ganda (penjualan ganda) atas stok yang sama, disesuaikan seperti di bawah]

**Langkah reproduksi**

1. Masuk ke Sales > SO > Baru·Detail (keterkaitan stok)
2. Periksa gejala — keterkaitan stok SO dan pembatasan perubahan dokumen lanjutan',
  recommendation_md_ko = '- DN(출하) 이후에도 DO · SO의 잔량 수정을 허용하되 수정 이력 보관. 재고를 「가용재고 / SO 확약재고」로 구분 표시하고, SO 확약분을 자동 잠금이 아닌 확약 상태로 관리하여 잔여 재고의 타 고객 판매가 가능하도록 처리. 다만 확약 합계가 실재고를 초과할 경우 저장 시 경고 표시 및 승인 절차 연계 요청. 재고 미확보 상태의 SO는 「수주 예약」 상태로 등록을 허용하되 출고(DN) 시점에 실재고를 재검증.',
  recommendation_md_id = '- Izinkan perubahan sisa DO · SO setelah DN (pengiriman) dengan menyimpan riwayat perubahan. Tampilkan stok terbagi 「stok tersedia / stok komitmen SO」, dan kelola bagian komitmen SO sebagai status komitmen (bukan penguncian otomatis) agar sisa stok dapat dijual ke pelanggan lain. Namun bila total komitmen melebihi stok riil, tampilkan peringatan saat simpan dan kaitkan dengan prosedur persetujuan. SO tanpa stok tersedia boleh didaftarkan sebagai status 「reservasi pesanan」, dengan stok riil diverifikasi ulang saat pengiriman (DN).',
  business_answer_md_ko = '- 개발부서 안 수용 + 보완 2건 — ① 확약 합계 > 실재고 시 저장 경고 및 승인 절차 연계 ② 재고 조회에 가용/확약 구분 표시. Flow 정의서 2026-09-10 전달. 요청 — Draft/Confirm 구조 오픈 前, Release·경고 오픈 後, 완료 예정일 기재',
  business_answer_md_id = '- Usulan tim pengembang diterima + 2 pelengkap — ① peringatan saat simpan dan keterkaitan prosedur persetujuan bila total komitmen > stok riil ② tampilan pembedaan tersedia/komitmen pada cek stok. Dokumen definisi Flow disampaikan 2026-09-10. Permintaan — struktur Draft/Confirm sebelum Go-Live, Release · peringatan setelah Go-Live, cantumkan tanggal target'
WHERE issue_no = '35' AND NOT is_archived;

-- 36 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- Purchase PO 신규 화면에서 구분을 LOCAL로 선택할 경우 Supplier Name 목록에 PT. Techking Tire Indonesia가 없어 해당 공급사 발주를 등록할 수 없음.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Purchasing > PO > 신규(LOCAL) 공급사 드롭다운 진입
2. 현상 확인 — 로컬 발주 신규 공급사 목록에 PT Techking Tire Indonesia 부재

# 8. 실서버 실측 (2026-09-07)

- 결과 — 조치확인, Verified 전환. Partners > Suppliers 검색 「Techking」 2건 조회 — PT. TECHKING TIRES INDONESIA(COUNTRY INDONESIA · TYPE LOCAL) 및 TECHKING TIRES LIMITED(CHINA · IMPORT)
- 수용기준 충족 — Purchasing > PO > 신규(LOCAL) SUPPLIERS 드롭다운에서 PT. TECHKING TIRES INDONESIA 선택 가능 확인
- 참고 — 마스터 등록 명칭은 「PT. TECHKING TIRES INDONESIA」로 개선요청서 표기(PT Techking Tire Indonesia)와 상이. 대외 문서 표기 통일 검토 필요',
  findings_md_id = '- Pada layar Purchase PO baru, bila jenis dipilih LOCAL, PT. Techking Tire Indonesia tidak ada di daftar Supplier Name sehingga pemesanan ke pemasok tersebut tidak dapat didaftarkan.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Baru (LOCAL) dropdown pemasok
2. Periksa gejala — PT Techking Tire Indonesia tidak ada di daftar pemasok pada pemesanan lokal baru

# 8. Pengukuran aktual di server produksi (2026-09-07)

- Hasil — perbaikan dikonfirmasi, diubah ke Verified. Pencarian 「Techking」 di Partners > Suppliers menampilkan 2 data — PT. TECHKING TIRES INDONESIA (COUNTRY INDONESIA · TYPE LOCAL) dan TECHKING TIRES LIMITED (CHINA · IMPORT)
- Kriteria selesai terpenuhi — PT. TECHKING TIRES INDONESIA dapat dipilih pada dropdown SUPPLIERS di Purchasing > PO > Baru (LOCAL)
- Catatan — nama terdaftar di master 「PT. TECHKING TIRES INDONESIA」 berbeda dari penulisan pada permintaan (PT Techking Tire Indonesia). Perlu ditinjau penyeragaman penulisan pada dokumen eksternal',
  recommendation_md_ko = '- 공급사 마스터에 PT. Techking Tire Indonesia를 LOCAL 공급사로 등록. 신규 공급사 등록은 승인 매트릭스(R4 → R1, 2영업일)에 따라 처리하고, 등록 시 원산지(COO) · Incoterms · 공장코드 검증을 완료할 것.',
  recommendation_md_id = '- Daftarkan PT. Techking Tire Indonesia sebagai pemasok LOCAL di master pemasok. Registrasi pemasok baru diproses sesuai matriks persetujuan (R4 → R1, 2 hari kerja), dengan validasi negara asal (COO) · Incoterms · kode pabrik diselesaikan saat registrasi.',
  business_answer_md_ko = '- 현지 사용자 확인 후 Verified 전환 예정',
  business_answer_md_id = '- Akan diubah ke Verified setelah konfirmasi pengguna lokal'
WHERE issue_no = '36' AND NOT is_archived;

-- 37 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- LOCAL 발주의 Payment Term 목록에 「21 Days」 선택지가 없어 실제 계약 조건대로 발주를 등록할 수 없음.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Purchasing > PO > 신규(LOCAL) PAYMENT TERM 진입
2. 현상 확인 — 결제조건 21일 선택지 부재 → Basic data 코드 추가 확인',
  findings_md_id = '- Daftar Payment Term untuk pemesanan LOCAL tidak memiliki pilihan 「21 Days」 sehingga pemesanan tidak dapat didaftarkan sesuai syarat kontrak sebenarnya.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > Baru (LOCAL) PAYMENT TERM
2. Periksa gejala — pilihan termin 21 hari tidak ada → cek penambahan kode di Basic data',
  recommendation_md_ko = '- 결제조건 마스터에 21 Days 추가. 아울러 결제조건 항목을 소스코드 고정값이 아닌 마스터 관리 항목으로 전환하여 현업이 추가·변경할 수 있도록 요청. 이슈 27(결제조건 전표 간 전이 불일치)과 함께 처리.',
  recommendation_md_id = '- Tambahkan 21 Days ke master termin pembayaran. Sekaligus mohon item termin pembayaran diubah dari nilai tetap di kode sumber menjadi item yang dikelola di master agar tim bisnis dapat menambah · mengubah. Ditangani bersama Isu 27 (ketidaksesuaian pewarisan termin antar dokumen).',
  business_answer_md_ko = '- 조치 확인 (2026-09-07) — PAYMENT TYPE = CREDIT 선택 시 21 days 선택지 존재',
  business_answer_md_id = '- Perbaikan dikonfirmasi (2026-09-07) — saat PAYMENT TYPE = CREDIT dipilih, pilihan 21 days tersedia'
WHERE issue_no = '37' AND NOT is_archived;

-- 38 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 입고(Receipt) 등록 시 AQL · Defect · DOT 열을 모두 입력하여야 확정(Confirm)이 가능하며, 확정 전까지 수입원가(Import Cost) 화면에 해당 건이 표시되지 않음. 품질검사 결과 확정보다 입고 확정 및 원가 산정이 선행되는 실제 업무 순서와 불일치하여 수입원가 산정이 지연됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Purchasing > Receipt > 신규(IMPORT · LOCAL) 진입
2. 현상 확인 — 입고 신규 시 AQL·Defect·DOT 필수 입력으로 확정 불가 (구매담당 Import Cost 선입력과 충돌)

# 8. 실서버 실측 (2026-09-07)

- 결과 — 조치확인, Verified 전환. AQL Qty · Defect Qty · DOT Code 전부 공란 상태로 입고 등록 → DRAFT 저장 → Confirm 실행, 「Receipt confirmed successfully」 확인
- 3개 항목 모두 필수(*) 표시 없음, 확정 차단 없음 → 원 현상(필수 입력으로 확정 불가) 해소
- 회신 정합성 지적 — 개발부서 회신은 「반려 · 개선내역 N/A · 기능 변경 없이 R&R 설명으로 종결」이었으나 실제로는 필수값이 해제되어 있음. 회신 내용과 실서버 상태 불일치로 회신 정확도 개선 요청 필요
- 테스트 전표 삭제 요청 대상 — Receipt ID 18 / PO AJ-20260901-003(PT. ARAMI JAYA) / 1 EA / 창고 KARAWANG / REMARK 「TEST-CAPTURE CSR-38 2026-09-07」 / SURAT JALAN 「TEST-CSR38-20260907」 / 상태 CONFIRMED',
  findings_md_id = '- Saat registrasi penerimaan (Receipt), kolom AQL · Defect · DOT harus diisi semua agar dapat dikonfirmasi (Confirm), dan sebelum konfirmasi dokumen tersebut tidak muncul di layar Import Cost. Tidak sesuai dengan urutan kerja nyata di mana konfirmasi penerimaan dan perhitungan biaya mendahului finalisasi hasil pemeriksaan mutu, sehingga perhitungan biaya impor tertunda.
- [Permintaan perbaikan pengguna lokal 2026-09-02]

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt > Baru (IMPORT · LOCAL)
2. Periksa gejala — penerimaan baru tidak dapat dikonfirmasi karena AQL · Defect · DOT wajib diisi (bertentangan dengan input Import Cost lebih dulu oleh staf pembelian)

# 8. Pengukuran aktual di server produksi (2026-09-07)

- Hasil — perbaikan dikonfirmasi, diubah ke Verified. Registrasi penerimaan dengan AQL Qty · Defect Qty · DOT Code semuanya kosong → simpan DRAFT → jalankan Confirm, muncul 「Receipt confirmed successfully」
- Ketiga item tidak bertanda wajib (*), tidak ada pemblokiran konfirmasi → gejala awal (tidak dapat konfirmasi karena wajib diisi) teratasi
- Catatan konsistensi balasan — balasan tim pengembang adalah 「ditolak · perbaikan N/A · ditutup dengan penjelasan R&R tanpa perubahan fitur」, namun nyatanya kewajiban isi sudah dilepas. Balasan tidak sesuai kondisi server produksi, perlu peningkatan akurasi balasan
- Dokumen uji yang mohon dihapus — Receipt ID 18 / PO AJ-20260901-003 (PT. ARAMI JAYA) / 1 EA / gudang KARAWANG / REMARK 「TEST-CAPTURE CSR-38 2026-09-07」 / SURAT JALAN 「TEST-CSR38-20260907」 / status CONFIRMED',
  recommendation_md_ko = '- AQL · Defect · DOT 미입력 상태에서도 입고 확정이 가능하도록 필수값 해제. 확정 이후 해당 항목을 추가 입력·수정할 수 있도록 처리하고, 미입력 건은 목록에서 「품질검사 미완」 상태로 구분 표시 요청.',
  recommendation_md_id = '- Lepas kewajiban isi agar konfirmasi penerimaan dapat dilakukan meskipun AQL · Defect · DOT belum diisi. Setelah konfirmasi, item tersebut dapat diinput · diubah, dan dokumen yang belum diisi ditandai di daftar dengan status 「pemeriksaan mutu belum selesai」.',
  business_answer_md_ko = '- 상태 재분류 요청 — Completed → Open. 기능 변경 없이 R&R 설명으로 종결된 건으로 현지 사용자 재확인 후 Flow 확정 필요. 입고 확정 주체·품질검사 후입력 Flow 정의서 2026-09-10 전달',
  business_answer_md_id = '- Permintaan reklasifikasi status — Completed → Open. Kasus ditutup dengan penjelasan R&R tanpa perubahan fitur, perlu konfirmasi ulang pengguna lokal lalu penetapan Flow. Dokumen definisi Flow pihak yang mengonfirmasi penerimaan · input hasil pemeriksaan mutu belakangan disampaikan 2026-09-10'
WHERE issue_no = '38' AND NOT is_archived;

-- 39 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Kolom PO NO. pada layar Purchase PO Baru terkunci hanya untuk penomoran otomatis (read-only) sehingga tidak dapat diinput manual. Pada saat go-live ASM masih terdapat banyak sisa PO yang sedang berjalan (pemesanan·pengapalan·kepabeanan) di sistem lama (Excel·SAP); PO tersebut tidak dapat didaftarkan dengan nomor PO asli yang tercantum pada dokumen pabrik (PI · Sales Contract · B/L), sehingga nomor pada dokumen lanjutan (PPC · Shipment · Customs · Receipt) tidak sesuai dengan dokumen fisik. [Usulan pengguna lokal 2026-09-09 — Lestari (Purchasing Import)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 04 (penomoran otomatis).

**Langkah reproduksi**

1. Masuk ke Purchasing > Purchase PO > Baru > PO No
2. Periksa gejala — PO NO. pada Purchase PO hanya penomoran otomatis — sisa PO berjalan tidak dapat didaftarkan dengan nomor aslinya',
  findings_md_ko = '- Purchase PO 신규 화면의 PO NO. 입력란이 자동 채번 전용(읽기전용)으로 잠겨 있어 수기 입력이 불가. ASM 오픈 시점에 구 시스템(Excel·SAP)에서 진행 중인 PO 잔량(발주·선적·통관)이 다수 남아 있는데, 공장 문서(PI · Sales Contract · B/L)에 기재된 원 PO 번호로 등록할 수 없어 후속 전표(PPC · Shipment · Customs · Receipt)의 번호가 실물 문서와 불일치함. [2026-09-09 현지 사용자 개선요청 — Lestari (Purchasing Import)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 04(자동 채번).

**재현 절차**

1. Purchasing > Purchase PO > 신규 > PO No 진입
2. 현상 확인 — Purchase PO의 PO NO.가 자동 채번만 가능 — 진행 중 PO 잔량을 원 번호로 등록 불가',
  recommendation_md_id = '- Tambahkan pilihan cara input PO NO.: 「Otomatis / Manual」. Input manual dibatasi pada masa migrasi (3 bulan setelah go-live) dan hak akses R4 (Pembelian) ke atas, dengan validasi nomor duplikat serta flag 「PO Migrasi」. Daftar sisa PO yang akan dimigrasi dikumpulkan lebih dahulu oleh tim pembelian; pertimbangkan juga metode unggah master. Setelah masa migrasi berakhir, opsi input manual dinonaktifkan.',
  recommendation_md_ko = '- PO NO. 입력 방식에 「자동 / 수기」 선택 추가. 수기 입력은 이관 기간(오픈 後 3개월)과 R4(구매) 이상 권한으로 제한하고, 중복 번호 검증 및 「이관 PO」 플래그를 둠. 이관 대상 PO 잔량 목록은 구매팀이 사전 집계하고, 마스터 업로드 방식도 검토. 이관 기간 종료 후 수기 입력 옵션은 비활성화.'
WHERE issue_no = '39' AND NOT is_archived;

-- 40 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- REMARK pada Purchase PO (contoh: 「ROSIBA : 3 (JASA) PENGIRIMAN JAKARTA (HARGA BARU)」) tidak ditampilkan pada layar Receipt maupun cetakan GRPO yang dibuat dari PO tersebut. Petugas penerimaan harus membuka layar PO secara terpisah untuk memeriksa catatan khusus pemesanan (syarat pengiriman · perubahan harga · item jasa), sehingga pencocokan invoice pemasok tertunda. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Purchasing > Purchase PO > Remark → Receipt · cetakan GRPO
2. Periksa gejala — REMARK pada Purchase PO tidak diteruskan ke layar Receipt dan cetakan GRPO',
  findings_md_ko = '- Purchase PO의 REMARK(예: 「ROSIBA : 3 (JASA) PENGIRIMAN JAKARTA (HARGA BARU)」)가 해당 PO에서 생성된 Receipt 화면과 GRPO 출력물에 표시되지 않음. 입고 담당자가 발주 특기사항(배송 조건 · 단가 변경 · 용역 항목)을 확인하려면 PO 화면을 따로 열어야 하므로 공급사 인보이스 대사가 지연됨. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Purchasing > Purchase PO > Remark → Receipt · GRPO 출력물 진입
2. 현상 확인 — Purchase PO의 REMARK가 Receipt 화면과 GRPO 출력물에 전달되지 않음',
  recommendation_md_id = '- Tampilkan PO REMARK (read-only) pada area PO INFO di layar Receipt Baru, dan tambahkan baris 「PO Remark」 pada cetakan GRPO. Terapkan prinsip pewarisan nilai dokumen asal (PO) ke dokumen lanjutan, sama seperti isu 27 (pewarisan termin pembayaran).',
  recommendation_md_ko = '- Receipt 신규 화면의 PO INFO 영역에 PO REMARK(읽기전용)를 표시하고, GRPO 출력물에 「PO Remark」 행 추가. 이슈 27(결제조건 승계)과 같이 원전표(PO) 값을 후속 전표로 승계하는 원칙 적용.'
WHERE issue_no = '40' AND NOT is_archived;

-- 41 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Kolom Discount pada layar PPC Baru hanya aktif bila diskon sudah diinput lebih dahulu di Purchase PO. Dalam praktik, diskon pabrik (diskon kuantitas · promosi · reward) baru ditetapkan saat PI (Proforma Invoice) atau Sales Contract diterima setelah pemesanan, sehingga tidak dapat diinput pada saat pembuatan PO. Akibatnya nilai PPC tidak sesuai dengan nilai PI dan dasar perhitungan rencana pembayaran (uang muka · pelunasan) menjadi keliru. [Usulan pengguna lokal 2026-09-09 — Lestari (Purchasing Import)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 03 (rekonsiliasi PO ↔ PPC).

**Langkah reproduksi**

1. Masuk ke Purchasing > PPC > Baru > Discount
2. Periksa gejala — Kolom Discount PPC hanya aktif bila sudah diinput di Purchase PO — diskon yang ditetapkan pada PI tidak dapat dicatat',
  findings_md_ko = '- PPC 신규 화면의 Discount 입력란은 Purchase PO에 할인이 먼저 입력된 경우에만 활성화됨. 실무에서는 공장 할인(수량 할인 · 프로모션 · 리워드)이 발주 후 PI(Proforma Invoice) 또는 Sales Contract 수령 시점에 확정되므로 PO 작성 시점에는 입력할 수 없음. 그 결과 PPC 금액이 PI 금액과 불일치하고, 지급 계획(선급금 · 잔금) 산정 기준이 틀어짐. [2026-09-09 현지 사용자 개선요청 — Lestari (Purchasing Import)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 03(PO ↔ PPC 대사).

**재현 절차**

1. Purchasing > PPC > 신규 > Discount 진입
2. 현상 확인 — PPC의 Discount 입력란은 Purchase PO에 입력된 경우에만 활성 — PI에서 확정된 할인을 기록할 수 없음',
  recommendation_md_id = '- Izinkan input Discount (rate · nilai) langsung pada tahap PPC. Simpan diskon PO dan diskon PPC sebagai item terpisah; selisihnya dicatat sebagai 「Diskon ditetapkan pada PI」. Saat konfirmasi PPC, tambahkan kolom No. PI · Nilai PI agar rekonsiliasi 3 tahap (nilai PO → nilai PPC/PI → nilai invoice aktual) dapat dilakukan. Perubahan diskon mengikuti matriks persetujuan (R4 → R1).',
  recommendation_md_ko = '- PPC 단계에서 Discount(율 · 금액)를 직접 입력할 수 있도록 허용. PO 할인과 PPC 할인을 별도 항목으로 저장하고 차액은 「PI 확정 할인」으로 기록. PPC 확정 시 PI 번호 · PI 금액 입력란을 추가하여 3단계 대사(PO 금액 → PPC/PI 금액 → 실제 인보이스 금액)가 가능하도록 처리. 할인 변경은 승인 매트릭스(R4 → R1)에 따름.'
WHERE issue_no = '41' AND NOT is_archived;

-- 42 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Pilihan jenis dokumen pada layar Customs > Attach Document tidak memiliki 「Discount」, sehingga Credit Note · dokumen penyelesaian Claim · bukti Reward (rebate) yang diterbitkan pabrik tidak dapat dilampirkan. Dokumen ini menjadi dasar pengurangan nilai invoice dan berpengaruh langsung pada nilai pabean (PIB) serta perhitungan biaya impor, dan wajib disampaikan saat audit pasca kepabeanan. [Usulan pengguna lokal 2026-09-09 — Lestari (Purchasing Import)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 07~10 (biaya impor).

**Langkah reproduksi**

1. Masuk ke Purchasing > Customs > Attach Document
2. Periksa gejala — Tidak ada pilihan jenis dokumen Discount (Credit Note · Claim · Reward) pada Attach Document menu Customs',
  findings_md_ko = '- Customs > Attach Document 화면의 문서 유형 선택지에 「Discount」가 없어, 공장이 발행하는 Credit Note · Claim 정산 문서 · Reward(리베이트) 증빙을 첨부할 수 없음. 이 문서들은 인보이스 금액 차감의 근거로서 관세 과세가격(PIB)과 수입원가 산정에 직접 영향을 미치며, 통관 사후심사 시 제출 의무가 있음. [2026-09-09 현지 사용자 개선요청 — Lestari (Purchasing Import)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 07~10(수입원가).

**재현 절차**

1. Purchasing > Customs > Attach Document 진입
2. 현상 확인 — Customs 메뉴 Attach Document에 Discount(Credit Note · Claim · Reward) 문서 유형 선택지 없음',
  recommendation_md_id = '- Tambahkan jenis dokumen 「Discount — Credit Note / Claim / Reward」 (dengan sub-jenis). Saat melampirkan, sediakan kolom nilai diskon · mata uang · nomor invoice terkait agar terhubung dengan pengurangan nilai invoice pada layar Import Cost. Satukan lokasi penyimpanan dokumen agar tidak terjadi pengelolaan ganda dengan menu Purchasing > Credit Note.',
  recommendation_md_ko = '- 문서 유형 「Discount — Credit Note / Claim / Reward」(하위 유형 포함) 추가. 첨부 시 할인 금액 · 통화 · 관련 인보이스 번호 입력란을 두어 Import Cost 화면의 인보이스 금액 차감과 연동. Purchasing > Credit Note 메뉴와 이중 관리가 되지 않도록 문서 보관 위치를 일원화.'
WHERE issue_no = '42' AND NOT is_archived;

-- 43 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Saat PO dipanggil pada layar Receipt Baru, seluruh item (contoh: PO AJ-20260904-004 — 39 item) terbuka otomatis, namun item yang belum diterima harus dihapus satu per satu melalui ikon tempat sampah per baris. Pada pengiriman bertahap dari pemasok lokal (PT Arami Jaya, dll.) lebih dari 30 baris harus dihapus satu per satu pada setiap penerimaan, sehingga waktu input berlebihan dan berisiko salah hapus. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt > Baru > Items
2. Periksa gejala — Saat penerimaan parsial PO multi-item, item yang belum diterima harus dihapus satu per satu — tidak ada pilih·hapus sekaligus',
  findings_md_ko = '- Receipt 신규 화면에서 PO를 불러오면 전 품목(예: PO AJ-20260904-004 — 39개 품목)이 자동으로 펼쳐지는데, 미입고 품목은 행별 휴지통 아이콘으로 하나씩 삭제해야 함. 로컬 공급사(PT Arami Jaya 등)의 분할 납품 시 입고 때마다 30행 이상을 하나씩 지워야 하므로 입력 시간이 과다하고 오삭제 위험이 있음. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Purchasing > Receipt > 신규 > Items 진입
2. 현상 확인 — 다품목 PO 부분 입고 시 미입고 품목을 하나씩 삭제해야 함 — 일괄 선택·삭제 없음',
  recommendation_md_id = '- Tambahkan kolom checkbox pada daftar item serta tombol 「Hapus Terpilih」 · 「Pilih Semua/Batal」. Sediakan juga opsi 「Kecualikan otomatis item qty 0」. Item yang belum diterima berdasarkan sisa PO (REM QTY) dibuka otomatis hanya sebesar sisa qty pada penerimaan berikutnya.',
  recommendation_md_ko = '- 품목 목록에 체크박스 열과 「선택 삭제」 · 「전체 선택/해제」 버튼 추가. 「수량 0 품목 자동 제외」 옵션도 제공. 다음 입고 시에는 PO 잔량(REM QTY) 기준 미입고 품목만 잔여 수량만큼 자동으로 펼침.'
WHERE issue_no = '43' AND NOT is_archived;

-- 44 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Layar Receipt Baru memiliki kolom SURAT JALAN NO., namun nilainya tidak tercetak pada GRPO, sehingga petugas harus menginput ulang nomor surat jalan di kolom REMARK agar tampil pada cetakan. Pencocokan tiga arah invoice pemasok · Surat Jalan · GRPO menjadi tertunda dan input ganda berisiko salah ketik. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt > Cetak (GRPO)
2. Periksa gejala — Surat Jalan No. yang diinput di layar Receipt tidak tercetak pada GRPO — harus diinput ulang di Remark',
  findings_md_ko = '- Receipt 신규 화면에 SURAT JALAN NO. 입력란이 있으나 그 값이 GRPO에 인쇄되지 않아, 담당자가 출력물에 표시되도록 REMARK 란에 송장 번호를 다시 입력해야 함. 공급사 인보이스 · Surat Jalan · GRPO의 3자 대사가 지연되고 이중 입력으로 오타 위험이 있음. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Purchasing > Receipt > 출력(GRPO) 진입
2. 현상 확인 — Receipt 화면에 입력한 Surat Jalan No.가 GRPO에 인쇄되지 않음 — Remark에 재입력 필요',
  recommendation_md_id = '- Tambahkan baris 「Surat Jalan No.」 dan 「Surat Jalan Date」 pada area informasi atas cetakan GRPO. Hilangkan kebiasaan input ganda di REMARK. Berlaku untuk cetakan penerimaan lokal maupun impor.',
  recommendation_md_ko = '- GRPO 출력물 상단 정보 영역에 「Surat Jalan No.」 · 「Surat Jalan Date」 행 추가. REMARK 이중 입력 관행 제거. 로컬 · 수입 입고 출력물 모두 적용.'
WHERE issue_no = '44' AND NOT is_archived;

-- 45 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Tombol 「+ Add Item」 pada layar Receipt Baru tidak mengizinkan penambahan item yang tidak ada di PO (item tidak dapat dipilih setelah dicari). Bila barang fisik berbeda dengan PO — salah kirim dari pabrik · beda brand · beda ukuran — penerimaan sesuai fisik tidak dapat dicatat, sehingga qty sistem tidak sesuai stok fisik dan tim gudang menyimpan barang tanpa dokumen. Permintaan yang sama diajukan oleh Lestari (Pembelian Impor) dan Firman (Gudang). [Usulan pengguna lokal 2026-09-09 — Lestari (Purchasing Import)] [Usulan pengguna lokal 2026-09-08 — Firman (Warehouse Manager, Karawang)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt > Baru > + Add Item
2. Periksa gejala — Tombol + Add Item pada Receipt tidak mengizinkan item di luar PO — penerimaan sesuai fisik tidak dapat dicatat',
  findings_md_ko = '- Receipt 신규 화면의 「+ Add Item」 버튼으로 PO에 없는 품목을 추가할 수 없음(검색 후 품목 선택 불가). 실물이 PO와 다른 경우 — 공장 오출고 · 브랜드 상이 · 규격 상이 — 실물 기준 입고를 기록할 수 없어 시스템 수량이 실재고와 불일치하고, 창고팀은 문서 없이 물품을 보관하게 됨. Lestari(수입 구매)와 Firman(창고)이 동일 요청을 제기함. [2026-09-09 현지 사용자 개선요청 — Lestari (Purchasing Import)] [2026-09-08 현지 사용자 개선요청 — Firman (Warehouse Manager, Karawang)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Purchasing > Receipt > 신규 > + Add Item 진입
2. 현상 확인 — Receipt의 + Add Item 버튼이 PO 외 품목을 허용하지 않음 — 실물 기준 입고 기록 불가',
  recommendation_md_id = '- Izinkan penambahan item di luar PO pada layar Receipt (flag 「Penerimaan di luar PO」 diberikan otomatis). Item tambahan ditandai berbeda dari item PO dan saat konfirmasi melewati persetujuan penanggung jawab pembelian (R4). Pertimbangkan fitur pemetaan item PO dengan item fisik (penerimaan pengganti). Kasus salah kirim dihubungkan dengan prosedur penanganan defect·selisih pada isu 46 sehingga berlanjut ke klaim pemasok (Vendor Return · Credit Note).',
  recommendation_md_ko = '- Receipt 화면에서 PO 외 품목 추가 허용(「PO 외 입고」 플래그 자동 부여). 추가 품목은 PO 품목과 구분 표시하고 확정 시 구매 책임자(R4) 승인을 거침. PO 품목과 실물 품목의 매핑(대체 입고) 기능 검토. 오출고 건은 이슈 46의 불량·차이 처리 절차와 연결하여 공급사 클레임(Vendor Return · Credit Note)으로 이어지도록 함.'
WHERE issue_no = '45' AND NOT is_archived;

-- 46 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Saat pemeriksaan penerimaan gudang (Receipt(WH)) ditemukan barang rusak · defect · kekurangan qty, belum jelas apakah qty penerimaan (QTY) boleh dikonfirmasi lebih kecil dari qty pengapalan (SHP. QTY); setelah DEFECT QTY diinput juga tidak ada jalur penanganan barang tersebut (stok tertahan · retur · klaim) di layar. Bila barang defect dihitung bersama stok normal, qty yang dapat dijual (AVAIL QTY) tampil terlalu besar. [Usulan pengguna lokal 2026-09-08 — Firman (Warehouse Manager, Karawang)] Prioritas pengusul tidak dicantumkan. Isu terkait 38 (AQL · Defect · DOT wajib diisi).

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt(WH) > Konfirmasi
2. Periksa gejala — Saat pemeriksaan penerimaan, aturan pengurangan qty dan pemisahan barang defect belum ditetapkan — defect tergabung dengan stok normal',
  findings_md_ko = '- 창고 입고 검수(Receipt(WH)) 시 파손 · 불량 · 수량 부족이 발견되면 입고 수량(QTY)을 선적 수량(SHP. QTY)보다 적게 확정할 수 있는지 불명확하고, DEFECT QTY를 입력한 뒤에도 해당 물품의 처리 경로(보류 재고 · 반품 · 클레임)가 화면에 없음. 불량품이 정상 재고와 함께 집계되면 판매 가능 수량(AVAIL QTY)이 과대 표시됨. [2026-09-08 현지 사용자 개선요청 — Firman (Warehouse Manager, Karawang)] 요청자 우선순위 미기재. 관련 이슈 38(AQL · Defect · DOT 필수 입력).

**재현 절차**

1. Purchasing > Receipt(WH) > 확정 진입
2. 현상 확인 — 입고 검수 시 수량 감액 규칙과 불량품 분리가 정해져 있지 않음 — 불량이 정상 재고에 합산',
  recommendation_md_id = '- Saat konfirmasi penerimaan, sediakan input terpisah 「qty normal / qty defect / qty kurang」; barang defect·kurang otomatis dipindahkan ke lokasi 「Quarantine (tertahan pemeriksaan)」. Buat layar daftar barang defect (Inventory > Defect List) dan hubungkan dengan pembuatan dokumen Vendor Return · Credit Note. Konfirmasi pengurangan qty menjadi wewenang penanggung jawab gudang (R6) dengan kode alasan wajib diisi.',
  recommendation_md_ko = '- 입고 확정 시 「정상 수량 / 불량 수량 / 부족 수량」을 분리 입력하고, 불량·부족분은 「Quarantine(검수 보류)」 로케이션으로 자동 이동. 불량품 목록 화면(Inventory > Defect List)을 만들어 Vendor Return · Credit Note 전표 생성과 연결. 수량 감액 확정은 창고 책임자(R6) 권한으로 하고 사유 코드 입력을 필수화.'
WHERE issue_no = '46' AND NOT is_archived;

-- 47 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Saat petugas gudang (akun Firman · Aris) login, menu Purchase > RECEIPT(WH) berstatus nonaktif (abu-abu) dan tidak dapat dibuka. Pemeriksaan·konfirmasi penerimaan gudang tidak dapat dilakukan di ASM sehingga saat ini diinput oleh akun tim pembelian, dan subjek konfirmasi penerimaan berbeda dari dokumen (definisi hak akses R6). [Usulan pengguna lokal 2026-09-08 — Firman (Warehouse Manager, Karawang)] Prioritas pengusul tidak dicantumkan. Isu terkait 31 (subjek konfirmasi pengeluaran).

**Langkah reproduksi**

1. Masuk ke Purchasing > Receipt(WH) (hak akses menu)
2. Periksa gejala — Menu RECEIPT(WH) terkunci pada akun gudang (Firman · Aris) — input diwakilkan oleh akun tim pembelian',
  findings_md_ko = '- 창고 담당자(Firman · Aris 계정)로 로그인하면 Purchase > RECEIPT(WH) 메뉴가 비활성(회색)으로 열리지 않음. 창고 입고 검수·확정을 ASM에서 할 수 없어 현재 구매팀 계정이 대신 입력하고 있으며, 입고 확정 주체가 문서(R6 권한 정의)와 다름. [2026-09-08 현지 사용자 개선요청 — Firman (Warehouse Manager, Karawang)] 요청자 우선순위 미기재. 관련 이슈 31(출고 확정 주체).

**재현 절차**

1. Purchasing > Receipt(WH) (메뉴 권한) 진입
2. 현상 확인 — 창고 계정(Firman · Aris)에서 RECEIPT(WH) 메뉴 잠김 — 구매팀 계정이 대리 입력',
  recommendation_md_id = '- Sesuai matriks hak akses, segera berikan akses menu RECEIPT(WH) dan DELIVERY NOTE(WH) kepada R6 (penanggung jawab gudang) · R7 (staf gudang). Periksa hak akses seluruh akun gudang cabang (Karawang · Surabaya · Semarang) sekaligus dan laporkan hasilnya. Tindakan wajib sebelum go-live.',
  recommendation_md_ko = '- 권한 매트릭스에 따라 R6(창고 책임자) · R7(창고 담당자)에게 RECEIPT(WH) 및 DELIVERY NOTE(WH) 메뉴 접근 권한을 즉시 부여. 지점 창고 계정(Karawang · Surabaya · Semarang) 전체의 권한을 일괄 점검하고 결과 보고. 오픈 前 필수 조치.'
WHERE issue_no = '47' AND NOT is_archived;

-- 48 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Pelanggan aktif yang belum memiliki Sales Rep pada master pelanggan (contoh: PT. SAMAS AGUNG TRANS) tidak dapat disimpan pada layar Quotation Baru karena dropdown SALES REP kosong dan muncul pesan 「Check Sales Rep」. Karena dokumen penjualan hanya dibuat dari Quotation, seluruh aktivitas penjualan pelanggan tersebut terhenti. [Usulan pengguna lokal 2026-09-08 — Merry (Admin Sales)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 11 (dropdown SALES REP) · 17 (kualitas migrasi master pelanggan).

**Langkah reproduksi**

1. Masuk ke Sales > Quotation > Baru > Sales Rep
2. Periksa gejala — Pelanggan aktif yang belum memiliki Sales Rep gagal disimpan dengan pesan ''Check Sales Rep'' pada penawaran baru',
  findings_md_ko = '- 고객 마스터에 Sales Rep이 없는 활성 고객(예: PT. SAMAS AGUNG TRANS)은 Quotation 신규 화면에서 SALES REP 드롭다운이 비어 「Check Sales Rep」 메시지가 뜨며 저장할 수 없음. 판매 전표는 Quotation에서만 생성되므로 해당 고객의 모든 판매 활동이 중단됨. [2026-09-08 현지 사용자 개선요청 — Merry (Admin Sales)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 11(SALES REP 드롭다운) · 17(고객 마스터 이관 품질).

**재현 절차**

1. Sales > Quotation > 신규 > Sales Rep 진입
2. 현상 확인 — Sales Rep이 없는 활성 고객은 견적 신규에서 ''Check Sales Rep'' 메시지로 저장 실패',
  recommendation_md_id = '- Ekstrak seluruh pelanggan aktif tanpa Sales Rep dan tetapkan sekaligus (unggah master setelah dikonfirmasi tim penjualan). Tambahkan validasi wajib Sales Rep saat menyimpan master pelanggan. Pada layar Quotation, bila pelanggan tanpa Sales Rep dipilih, tampilkan pesan 「Tetapkan Sales Rep pada master pelanggan terlebih dahulu」 beserta tautan ke layar master.',
  recommendation_md_ko = '- Sales Rep이 없는 활성 고객을 전수 추출하여 일괄 지정(영업팀 확인 후 마스터 업로드). 고객 마스터 저장 시 Sales Rep 필수 검증 추가. Quotation 화면에서 Sales Rep 없는 고객을 선택하면 「고객 마스터에서 Sales Rep을 먼저 지정하십시오」 메시지와 마스터 화면 링크를 표시.'
WHERE issue_no = '48' AND NOT is_archived;

-- 49 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Meskipun PO DATE · EST DELIVERY DATE pada Customer PO diubah, tanggal pada SO · Delivery Order · Delivery Note yang sudah dibuat tidak diperbarui sehingga setiap dokumen lanjutan harus diubah manual. Bila terlewat, cetakan (DO · Delivery Note) mencantumkan tanggal yang berbeda dari PO pelanggan, berisiko ditolak saat pemeriksaan pelanggan dan salah tanggal pengakuan penjualan. [Usulan pengguna lokal 2026-09-08 — Merry (Admin Sales)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 35 (batasan perubahan dokumen lanjutan).

**Langkah reproduksi**

1. Masuk ke Sales > Customer PO > ubah PO Date · Delivery Date
2. Periksa gejala — Perubahan PO Date·Delivery Date pada Customer PO tidak diteruskan ke SO·DO·DN — harus diubah manual satu per satu',
  findings_md_ko = '- Customer PO의 PO DATE · EST DELIVERY DATE를 변경해도 이미 생성된 SO · Delivery Order · Delivery Note의 날짜가 갱신되지 않아 후속 전표를 하나씩 수동 수정해야 함. 누락 시 출력물(DO · Delivery Note)에 고객 PO와 다른 날짜가 기재되어 고객 검수 시 반려와 매출 인식일 오류 위험이 있음. [2026-09-08 현지 사용자 개선요청 — Merry (Admin Sales)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 35(후속 전표 수정 제약).

**재현 절차**

1. Sales > Customer PO > PO Date · Delivery Date 변경 진입
2. 현상 확인 — Customer PO의 PO Date·Delivery Date 변경이 SO·DO·DN에 전달되지 않음 — 하나씩 수동 수정 필요',
  recommendation_md_id = '- Saat tanggal dokumen asal (Customer PO) diubah, dokumen lanjutan berstatus Draft diperbarui otomatis; dokumen yang sudah dikonfirmasi diperbarui sekaligus setelah konfirmasi 「perbarui tersinkron?」. Simpan riwayat perubahan (pengubah · waktu · nilai sebelum/sesudah). Tahap setelah Delivery Note terkonfirmasi dikunci dari perubahan; koreksi melalui prosedur batal · terbit ulang.',
  recommendation_md_ko = '- 원전표(Customer PO)의 날짜 변경 시 Draft 상태의 후속 전표는 자동 갱신하고, 확정된 전표는 「연동 갱신하시겠습니까?」 확인 후 일괄 갱신. 변경 이력(변경자 · 일시 · 변경 전/후 값) 보존. Delivery Note 확정 이후 단계는 변경 잠금, 정정은 취소 · 재발행 절차로 처리.'
WHERE issue_no = '49' AND NOT is_archived;

-- 50 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Saat mengunduh Excel dari Inventory List setelah pencarian berdasarkan periode · gudang, nama file dibuat dengan nilai tetap dan di dalam file tidak tercantum periode pencarian · gudang · waktu ekstraksi. Nama file yang sama terus dihasilkan sehingga saat disimpan terjadi timpa-tindih · kebingungan, dan di kemudian hari tidak dapat diketahui stok pada titik waktu mana hanya dari file. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Inventory > Inventory List > Excel
2. Periksa gejala — Nama file unduhan Excel tetap, periode·gudang·waktu ekstraksi tidak tercantum di dalam file',
  findings_md_ko = '- Inventory List에서 기간 · 창고 기준으로 조회한 뒤 Excel을 내려받으면 파일명이 고정값으로 생성되고, 파일 안에도 조회 기간 · 창고 · 추출 시각이 기재되지 않음. 같은 파일명이 계속 생성되어 저장 시 덮어쓰기 · 혼동이 발생하고, 나중에 파일만으로는 어느 시점의 재고인지 알 수 없음. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Inventory > Inventory List > Excel 진입
2. 현상 확인 — Excel 다운로드 파일명 고정, 파일 안에 기간·창고·추출 시각 미기재',
  recommendation_md_id = '- Ubah aturan nama file menjadi 「Inventory_{gudang}*{awal}~{akhir}*{waktu ekstraksi}.xlsx」. Cantumkan kondisi pencarian (periode · gudang · kategori) serta waktu · nama pengekstrak di bagian atas sheet. Terapkan aturan yang sama pada seluruh unduhan Excel.',
  recommendation_md_ko = '- 파일명 규칙을 「Inventory_{창고}_{시작}~{종료}_{추출시각}.xlsx」로 변경. 시트 상단에 조회 조건(기간 · 창고 · 카테고리)과 추출 시각 · 추출자 이름을 기재. 전 Excel 다운로드에 동일 규칙 적용.'
WHERE issue_no = '50' AND NOT is_archived;

-- 51 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Hasil ekstraksi Excel Inventory List dengan kondisi 2026-08-01~08-31 pada 2026-09-08 pukul 09:00 menunjukkan qty per item berbeda dengan stok fisik gudang (stok kelolaan Excel). Diduga penyebabnya: dokumen uji masih tersisa, data tutup buku Agustus belum tercermin, dan dasar filter periode (tanggal penerimaan vs. titik waktu stok) tidak jelas. Bila akurasi saldo awal (Opening Balance) saat go-live tidak terjamin, stok · biaya seluruh transaksi selanjutnya akan menyimpang. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 14 (agregasi tutup buku bulanan).

**Langkah reproduksi**

1. Masuk ke Inventory > Inventory List > Excel (2026-08-01~08-31)
2. Periksa gejala — Qty pada Excel Inventory List berbeda dengan stok fisik gudang (kelolaan Excel) — akurasi saldo awal belum terjamin',
  findings_md_ko = '- 2026-09-08 09:00에 2026-08-01~08-31 조건으로 추출한 Inventory List Excel의 품목별 수량이 창고 실재고(Excel 관리 재고)와 다름. 추정 원인: 테스트 전표 잔존, 8월 마감 데이터 미반영, 기간 필터 기준(입고일 vs 재고 시점) 불명확. 오픈 시점의 기초 재고(Opening Balance) 정확성이 보장되지 않으면 이후 모든 거래의 재고 · 원가가 어긋남. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 14(월마감 집계).

**재현 절차**

1. Inventory > Inventory List > Excel (2026-08-01~08-31) 진입
2. 현상 확인 — Inventory List Excel 수량이 창고 실재고(Excel 관리)와 상이 — 기초 재고 정확성 미보장',
  recommendation_md_id = '- ① Tetapkan dan tampilkan arti filter periode (item diterima dalam periode / stok pada akhir periode). ② Hapus seluruh dokumen uji lalu muat ulang saldo awal berdasarkan qty stock opname gudang per 2026-08-31. ③ Setelah dimuat, buat tabel rekonsiliasi per item dengan Excel tim gudang dan pastikan selisih 0 sebagai syarat go-live. ④ Selanjutnya verifikasi logika agregasi tutup buku bulanan (isu 14).',
  recommendation_md_ko = '- ① 기간 필터의 의미(기간 내 입고 품목 / 기간 말 재고)를 정의하고 화면에 표시. ② 테스트 전표를 전량 삭제한 뒤 2026-08-31 기준 창고 실사 수량으로 기초 재고를 재적재. ③ 적재 후 창고팀 Excel과 품목별 대사표를 작성하여 차이 0을 오픈 조건으로 확정. ④ 이후 월마감 집계 로직 검증(이슈 14).'
WHERE issue_no = '51' AND NOT is_archived;

-- 52 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Tidak ada layar untuk memindahkan stok dari gudang Karawang ke gudang cabang Semarang · Surabaya sehingga mutasi antar cabang tidak dapat dicatat di sistem. Saat ini barang dipindahkan tanpa dokumen penjualan sehingga stok cabang tidak tercermin di sistem dan muncul error kekurangan stok saat penjualan cabang. Menurut pengusul, permintaan sudah disampaikan ke tim pengembang dan sedang diproses (on process). [Usulan pengguna lokal 2026-09-08 — Merry (Admin Sales)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 20 (TYPE master gudang) · 30 (lokasi penyimpanan).

**Langkah reproduksi**

1. Masuk ke Inventory > Inventory Movement (baru)
2. Periksa gejala — Tidak ada layar perpindahan stok Karawang → Semarang·Surabaya — stok cabang tidak tercatat di sistem',
  findings_md_ko = '- Karawang 창고에서 Semarang · Surabaya 지점 창고로 재고를 이동하는 화면이 없어 지점 간 이동을 시스템에 기록할 수 없음. 현재는 판매 전표 없이 물품을 이동하고 있어 지점 재고가 시스템에 반영되지 않고 지점 판매 시 재고 부족 오류가 발생함. 요청자에 따르면 개발부서에 이미 요청되어 진행 중(on process). [2026-09-08 현지 사용자 개선요청 — Merry (Admin Sales)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 20(창고 마스터 TYPE) · 30(보관 로케이션).

**재현 절차**

1. Inventory > Inventory Movement (신설) 진입
2. 현상 확인 — Karawang → Semarang·Surabaya 재고 이동 화면 없음 — 지점 재고가 시스템에 미기록',
  recommendation_md_id = '- Buat menu Inventory > Inventory Movement (Transfer) — input gudang asal · gudang tujuan · item · qty · informasi angkutan (ekspedisi · kendaraan · no. surat jalan), dengan pengelolaan status 2 tahap: konfirmasi keluar (R6 gudang asal) → dalam perjalanan (In-Transit) → konfirmasi masuk (R6 gudang tujuan). Sediakan cetakan dokumen mutasi (Surat Jalan Antar Gudang) dan tambahkan kolom qty In-Transit pada Inventory List. Mohon balasan jadwal pengembangan · PIC.',
  recommendation_md_ko = '- Inventory > Inventory Movement(Transfer) 메뉴 신설 — 출발 창고 · 도착 창고 · 품목 · 수량 · 운송 정보(운송사 · 차량 · 송장 번호) 입력, 출고 확정(출발 창고 R6) → 이동 중(In-Transit) → 입고 확정(도착 창고 R6)의 2단계 상태 관리. 이동 전표 출력물(Surat Jalan Antar Gudang) 제공 및 Inventory List에 In-Transit 수량 열 추가. 개발 일정 · 담당자 회신 요청.'
WHERE issue_no = '52' AND NOT is_archived;

-- 53 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Tidak ada layar untuk menginput · merekonsiliasi hasil stock opname (Stock Taking) bulanan sehingga selisih qty fisik dan qty sistem dikelola terpisah di Excel (format 4W STOCK WAREHOUSE). Hasil opname tidak tercermin di sistem sehingga dasar penyesuaian stok (Adjustment) dan riwayat persetujuannya tidak tersimpan. [Usulan pengguna lokal 2026-09-08 — Firman (Warehouse Manager, Karawang)] Prioritas pengusul tidak dicantumkan. Isu terkait 14 (tutup buku bulanan).

**Langkah reproduksi**

1. Masuk ke Inventory > Stock Opname (baru)
2. Periksa gejala — Tidak ada layar input·rekonsiliasi hasil stock opname bulanan — dikelola di Excel, dasar penyesuaian tidak tersimpan',
  findings_md_ko = '- 월별 재고 실사(Stock Taking) 결과를 입력·대사하는 화면이 없어 실물 수량과 시스템 수량의 차이를 Excel(4W STOCK WAREHOUSE 양식)로 별도 관리함. 실사 결과가 시스템에 반영되지 않아 재고 조정(Adjustment)의 근거와 승인 이력이 남지 않음. [2026-09-08 현지 사용자 개선요청 — Firman (Warehouse Manager, Karawang)] 요청자 우선순위 미기재. 관련 이슈 14(월마감).

**재현 절차**

1. Inventory > Stock Opname (신설) 진입
2. 현상 확인 — 월별 재고 실사 결과 입력·대사 화면 없음 — Excel 관리, 조정 근거 미보존',
  recommendation_md_id = '- Buat menu Inventory > Stock Opname — saat tanggal acuan · gudang dipilih, qty sistem terbuka otomatis; input qty fisik (mendukung unggah Excel); selisih qty · kode alasan dihitung otomatis; konfirmasi penanggung jawab gudang (R6) → persetujuan akuntansi (R8) → dokumen penyesuaian stok dibuat otomatis. Sediakan cetakan lembar opname (item · qty sistem · qty fisik · selisih · keterangan). Kaitkan konfirmasi opname sebagai syarat wajib sebelum tutup buku bulanan.',
  recommendation_md_ko = '- Inventory > Stock Opname 메뉴 신설 — 기준일 · 창고 선택 시 시스템 수량 자동 펼침, 실물 수량 입력(Excel 업로드 지원), 차이 수량 · 사유 코드 자동 산출, 창고 책임자(R6) 확정 → 회계(R8) 승인 → 재고 조정 전표 자동 생성. 실사표 출력물(품목 · 시스템 수량 · 실물 수량 · 차이 · 비고) 제공. 실사 확정을 월마감의 필수 선행 조건으로 연계.'
WHERE issue_no = '53' AND NOT is_archived;

-- 54 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Laporan 「Summary Weekly Data Stock」 yang disusun tim bisnis setiap minggu di Excel (stok gudang per item · brand · ukuran, stok dapat dijual, stok fisik, penerimaan (Good Receipt · Incoming Import), pengeluaran (SO · Forecast · Shipped · Balance), stok pengaman (Minimum Stock · % pemenuhan)) tidak dapat dihasilkan langsung dari ASM. Penyusunan manual memakan lebih dari setengah hari per minggu dan berisiko tidak sesuai dengan stok sistem. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Inventory > Report > Summary Weekly Data Stock (baru)
2. Periksa gejala — Laporan stok mingguan (Summary Weekly Data Stock) masih dibuat manual di Excel setiap minggu',
  findings_md_ko = '- 현업이 매주 Excel로 작성하는 「Summary Weekly Data Stock」 보고서(품목 · 브랜드 · 규격별 창고 재고, 판매 가능 재고, 실물 재고, 입고(Good Receipt · Incoming Import), 출고(SO · Forecast · Shipped · Balance), 안전재고(Minimum Stock · 충족률))를 ASM에서 직접 산출할 수 없음. 수작업 작성에 주당 반나절 이상 소요되고 시스템 재고와 불일치 위험이 있음. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Inventory > Report > Summary Weekly Data Stock (신설) 진입
2. 현상 확인 — 주간 재고 보고서(Summary Weekly Data Stock)를 매주 Excel로 수작업 작성',
  recommendation_md_id = '- Buat laporan stok mingguan pada Inventory > Report — kondisi tanggal acuan · gudang · kategori (Radial · Bias · Tube · Flap), dengan susunan kolom sama seperti format Excel tim bisnis. Tambahkan Minimum Stock sebagai atribut master item agar % pemenuhan dihitung otomatis. Dukung unduh Excel (aturan nama file isu 50).',
  recommendation_md_ko = '- Inventory > Report에 주간 재고 보고서 신설 — 기준일 · 창고 · 카테고리(Radial · Bias · Tube · Flap) 조건, 열 구성은 현업 Excel 양식과 동일. Minimum Stock을 품목 마스터 속성으로 추가하여 충족률 자동 산출. Excel 다운로드 지원(파일명 규칙은 이슈 50).'
WHERE issue_no = '54' AND NOT is_archived;

-- 55 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Rekap biaya ekspedisi per perusahaan angkutan (ekspedisi · jenis kendaraan · tujuan · wilayah · tanggal · nomor invoice ekspedisi · ongkos · PPN · Jasa · lain-lain · total) yang dipadankan dengan transaksi penjualan terkait (pelanggan · nomor invoice penjualan · tanggal surat jalan · nilai penjualan · % ongkos · tanggal terima · jatuh tempo · tanggal bayar) dikelola di Excel (sheet MASTER DATA). Delivery Order · Delivery Note di ASM tidak memiliki data ekspedisi sehingga tidak dapat dihasilkan dari sistem. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live).

**Langkah reproduksi**

1. Masuk ke Sales > Report > Ekspedisi (baru) · data ekspedisi Delivery Note
2. Periksa gejala — Laporan rekap biaya ekspedisi dibuat manual di Excel — Delivery Note tidak memiliki kolom data ekspedisi',
  findings_md_ko = '- 운송사별 운송비 집계(운송사 · 차종 · 목적지 · 지역 · 일자 · 운송 인보이스 번호 · 운임 · PPN · Jasa · 기타 · 합계)를 관련 판매 거래(고객 · 판매 인보이스 번호 · 송장 일자 · 판매 금액 · 운임 비율 · 수령일 · 만기일 · 지급일)와 대조하여 Excel(MASTER DATA 시트)로 관리 중. ASM의 Delivery Order · Delivery Note에는 운송 데이터가 없어 시스템에서 산출할 수 없음. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수).

**재현 절차**

1. Sales > Report > Ekspedisi (신설) · Delivery Note 운송 정보 진입
2. 현상 확인 — 운송비 집계 보고서를 Excel로 수작업 작성 — Delivery Note에 운송 데이터 열 없음',
  recommendation_md_id = '- Tambahkan kolom ekspedisi · jenis kendaraan · nomor invoice ekspedisi · ongkos (DPP · PPN · Jasa) pada Delivery Note serta buat master ekspedisi. Buat laporan rekap ekspedisi pada Sales > Report (termasuk % ongkos terhadap invoice penjualan) dengan kolom saldo belum dibayar · jatuh tempo. Disarankan masuk lingkup perbaikan tahap 1 setelah go-live.',
  recommendation_md_ko = '- Delivery Note에 운송사 · 차종 · 운송 인보이스 번호 · 운임(DPP · PPN · Jasa) 열을 추가하고 운송사 마스터 신설. Sales > Report에 운송비 집계 보고서(판매 인보이스 대비 운임 비율 포함) 신설, 미지급 잔액 · 만기일 열 포함. 오픈 後 1차 개선 범위 권장.'
WHERE issue_no = '55' AND NOT is_archived;

-- 56 (원문 ID)
UPDATE public.csr_issues SET
  findings_md_id = '- Rekap pembelian bulanan per pemasok (Factory) · jenis item (Type 3 · Type 2) · brand — qty PO · qty PPC terkonfirmasi · qty penerimaan aktual · sisa belum diterima (Outstanding PLB) serta nilai (IDR · USD) — disusun manual di Excel. Data PO · PPC · Receipt di ASM tersebar di masing-masing daftar dan tidak ada layar agregasi. [Usulan pengguna lokal 2026-09-08 — Lia (Purchasing Lokal)] Prioritas pengusul A (wajib sebelum go-live). Isu terkait 03 (rekonsiliasi PO ↔ PPC).

**Langkah reproduksi**

1. Masuk ke Purchasing > Report > Summary PO · GRPO by Factory (baru)
2. Periksa gejala — Rekap pembelian bulanan per pemasok·jenis·brand (PO/PPC/Receipt/Outstanding·nilai) dibuat manual di Excel',
  findings_md_ko = '- 공급사(Factory) · 품목 유형(Type 3 · Type 2) · 브랜드별 월간 구매 집계 — PO 수량 · PPC 확정 수량 · 실제 입고 수량 · 미입고 잔량(Outstanding PLB)과 금액(IDR · USD) — 을 Excel로 수작업 작성함. ASM의 PO · PPC · Receipt 데이터는 각 목록에 흩어져 있고 집계 화면이 없음. [2026-09-08 현지 사용자 개선요청 — Lia (Purchasing Lokal)] 요청자 우선순위 A (오픈 前 필수). 관련 이슈 03(PO ↔ PPC 대사).

**재현 절차**

1. Purchasing > Report > Summary PO · GRPO by Factory (신설) 진입
2. 현상 확인 — 공급사·유형·브랜드별 월간 구매 집계(PO/PPC/Receipt/Outstanding·금액)를 Excel로 수작업 작성',
  recommendation_md_id = '- Buat laporan rekap pembelian bulanan pada Purchasing > Report — kondisi periode · pemasok · jenis (impor · lokal), dengan susunan kolom sama seperti format Excel tim bisnis (PO QTY · PPC Confirm · Actual Receipt · Outstanding · PO AMT · PPC Confirm AMT · Actual Receipt AMT, IDR · USD terpisah). Format mata uang mengikuti isu 02 · 22 (pemisah ribuan koma · kode mata uang).',
  recommendation_md_ko = '- Purchasing > Report에 월간 구매 집계 보고서 신설 — 기간 · 공급사 · 구분(수입 · 로컬) 조건, 열 구성은 현업 Excel 양식과 동일(PO QTY · PPC Confirm · Actual Receipt · Outstanding · PO AMT · PPC Confirm AMT · Actual Receipt AMT, IDR · USD 분리). 통화 표기는 이슈 02 · 22(천 단위 콤마 · 통화 코드)를 따름.'
WHERE issue_no = '56' AND NOT is_archived;

-- 57 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 절사(Truncation)를 총액에 적용하여 DPP × 11% = PPN 관계 불성립. e-Faktur 신고 시 청구금액과 세금계산서 금액 불일치 우려. 세율(PPN 11% · PPh 22 7.5% · BC 5%)이 소스코드 고정값.

**재현 절차**

1. Sales > Quotation · SO (합계 블록) · 세율 마스터 진입
2. 현상 확인 — 절사 총액 적용으로 DPP × 11% = PPN 불성립, 세율 하드코딩

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-3 (세무 정합성) → 이슈 60(초안) → **이슈 57** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 반올림(절사) 로직 부분은 이슈 12와 중복이라 삭제하고 세율 마스터 관리 요청만 유지. 담당: SEO. VIII 채번 체계 폐지 — 다음 신규 이슈는 61부터.',
  findings_md_id = '- Pemotongan (truncation) diterapkan pada total sehingga hubungan DPP × 11% = PPN tidak berlaku. Berisiko nilai tagihan tidak sesuai dengan faktur pajak saat pelaporan e-Faktur. Tarif pajak (PPN 11% · PPh 22 7.5% · BC 5%) berupa nilai tetap di kode sumber.

**Langkah reproduksi**

1. Masuk ke Sales > Quotation · SO (blok total) · master tarif pajak
2. Periksa gejala — pemotongan pada total membuat DPP × 11% = PPN tidak berlaku, tarif pajak di-hardcode

# 0. Catatan Penomoran

- 2026-09-09: VIII-3 (Kesesuaian Perpajakan) → isu 60 (draft) → **isu 57** (penomoran ulang setelah penghapusan 3 duplikat v1, 2026-09-09). Bagian logika pembulatan (truncation) dihapus karena duplikat dengan isu 12; hanya permintaan pengelolaan tarif pajak sebagai master yang dipertahankan. PIC: SEO. Sistem penomoran VIII dihapus — isu baru berikutnya mulai dari 61.',
  recommendation_md_ko = '- 절사를 DPP 단계로 이동하고 PPN은 절사 후 DPP 기준으로 재계산 (12번 연계)
- 세율(PPN 11% · PPh 22 7.5% · BC 5%)을 소스코드 고정값이 아닌 마스터 관리 항목으로 전환',
  recommendation_md_id = '- Pindahkan pemotongan ke tahap DPP dan hitung ulang PPN dari DPP setelah pemotongan (terkait isu 12)
- Ubah tarif pajak (PPN 11% · PPh 22 7.5% · BC 5%) dari nilai tetap di kode sumber menjadi item yang dikelola di master',
  business_answer_md_ko = '- 12번 결정(DPP 단계 절사·저장) 참조. 세율 마스터화 회신 요청',
  business_answer_md_id = '- Lihat keputusan isu 12 (pemotongan · penyimpanan pada tahap DPP). Mohon balasan mengenai pengelolaan tarif pajak sebagai master'
WHERE issue_no = '57' AND NOT is_archived;

-- 58 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- [2026-09-01 일부 반영 확인] 발주 승인 시 PREPARED BY · CHECKER 1 · CHECKER 2 · APPROVER 1의 결재선을 지정하는 팝업이 신설됨. 다만 결재선이 필수값이 아니어서 지정 없이도 CONFIRMED 전환이 가능하고, 금액 구간별 결재선 자동 지정 기능은 없음.

**재현 절차**

1. Purchasing > PO > 승인 팝업 진입
2. 현상 확인 — 결재선 지정 팝업은 신설되었으나 필수값 아님 — 지정 없이 CONFIRMED 가능

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-4 (승인 절차 연계) → 이슈 61(초안) → **이슈 58** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 이슈 34와 중복 아님(34는 결재자 알림만 다룸). 담당: SEO. VIII 채번 체계 폐지.',
  findings_md_id = '- [Konfirmasi penerapan sebagian 2026-09-01] Saat persetujuan pemesanan, ditambahkan popup untuk menetapkan jalur persetujuan PREPARED BY · CHECKER 1 · CHECKER 2 · APPROVER 1. Namun jalur persetujuan bukan nilai wajib sehingga dapat diubah ke CONFIRMED tanpa penetapan, dan tidak ada penetapan jalur otomatis berdasarkan rentang nilai.

**Langkah reproduksi**

1. Masuk ke Purchasing > PO > popup persetujuan
2. Periksa gejala — popup penetapan jalur persetujuan sudah ada tetapi tidak wajib — CONFIRMED tanpa penetapan masih bisa

# 0. Catatan Penomoran

- 2026-09-09: VIII-4 (Keterkaitan Prosedur Persetujuan) → isu 61 (draft) → **isu 58** (penomoran ulang setelah penghapusan 3 duplikat v1, 2026-09-09). Tidak duplikat dengan isu 34 (isu 34 hanya mencakup notifikasi approver). PIC: SEO. Sistem penomoran VIII dihapus.',
  recommendation_md_ko = '- 금액 구간별 필수 결재선 지정, 결재 완료 건만 CONFIRMED 전환, 결재 이력 조회 기능 보완 요청',
  recommendation_md_id = '- Mohon: penetapan jalur persetujuan wajib per rentang nilai, hanya dokumen yang selesai disetujui yang dapat diubah ke CONFIRMED, dan fitur pencarian riwayat persetujuan dilengkapi',
  business_answer_md_ko = '- 미회신 항목 — 결재선 필수화 회신 요청 (2026-09-07). Flow 정의서 2026-09-10(34번)와 연계',
  business_answer_md_id = '- Item belum dibalas — mohon balasan mengenai kewajiban jalur persetujuan (2026-09-07). Terkait dengan dokumen definisi Flow 2026-09-10 (isu 34)'
WHERE issue_no = '58' AND NOT is_archived;

-- 59 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 당사 수입 프로세스는 발주(PO) → 생산계획(PPC) → 대금지급(Payment) → 선적(Shipment) → 통관(Customs) → 입고(Receipt) 순으로 운영되나, Purchasing 메뉴에 대금지급 단계 대응 화면 부재. 현재 T/T 선급금·잔금 및 L/C 개설·네고 일정은 발주 엑셀의 PAYMENT PLAN 시트로 별도 관리 중이어서 발주·지급·선적 진행상황의 시스템 연계 추적 불가.

**재현 절차**

1. Purchasing > Payment Plan (신설 요청) 진입
2. 현상 확인 — 발주 → PPC → 대금지급 → 선적 → 통관 → 입고 흐름 중 대금지급 화면 부재 (PAYMENT PLAN 엑셀 별도 관리)

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-5 (Payment Plan) → 이슈 62(초안) → **이슈 59** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 01~59 중 중복 이슈 없음. 담당: SEO. VIII 채번 체계 폐지.',
  findings_md_id = '- Proses impor perusahaan berjalan dengan urutan pemesanan (PO) → rencana produksi (PPC) → pembayaran (Payment) → pengapalan (Shipment) → kepabeanan (Customs) → penerimaan (Receipt), namun menu Purchasing tidak memiliki layar untuk tahap pembayaran. Saat ini uang muka · pelunasan T/T serta jadwal pembukaan · negosiasi L/C dikelola terpisah di sheet PAYMENT PLAN pada Excel pemesanan, sehingga progres pemesanan · pembayaran · pengapalan tidak dapat dilacak secara terhubung di sistem.

**Langkah reproduksi**

1. Masuk ke Purchasing > Payment Plan (permintaan menu baru)
2. Periksa gejala — dalam alur pemesanan → PPC → pembayaran → pengapalan → kepabeanan → penerimaan, layar pembayaran tidak ada (PAYMENT PLAN dikelola terpisah di Excel)

# 0. Catatan Penomoran

- 2026-09-09: VIII-5 (Payment Plan) → isu 62 (draft) → **isu 59** (penomoran ulang setelah penghapusan 3 duplikat v1, 2026-09-09). Tidak ada isu duplikat di 01~59. PIC: SEO. Sistem penomoran VIII dihapus.',
  recommendation_md_ko = '- 신설 요청 화면: Purchasing > Payment Plan — PO 연결, 지급조건(예: T/T 30% 선급 / 70% B/L 사본), 지급 예정일·실제 지급일, 적용 환율, 잔여 지급액
- 연계 요건: PPC 생산완료 → 잔금 지급 → Shipment 등록 순으로 상태가 연동되도록 처리
- 조회 화면: 월별 지급 예정액(자금계획) 및 미지급 잔액 리포트',
  recommendation_md_id = '- Layar baru yang diminta: Purchasing > Payment Plan — terhubung ke PO, syarat pembayaran (mis. T/T 30% uang muka / 70% salinan B/L), tanggal rencana · tanggal aktual pembayaran, kurs yang dipakai, sisa pembayaran
- Syarat keterkaitan: status berjalan berurutan produksi PPC selesai → pelunasan → registrasi Shipment
- Layar pencarian: rencana pembayaran bulanan (rencana kas) dan laporan saldo belum dibayar',
  business_answer_md_ko = '- 미회신 항목 — 화면 신설 여부 회신 요청 (2026-09-07)',
  business_answer_md_id = '- Item belum dibalas — mohon balasan apakah layar baru akan dibuat (2026-09-07)'
WHERE issue_no = '59' AND NOT is_archived;

-- 60 (원문 KO)
UPDATE public.csr_issues SET
  findings_md_ko = '- 동일 약어가 서로 다른 대목차에 존재하여 현업 사용자 오인식 우려. 주체를 접두어로 명시하고 축약 표기를 풀어 쓰는 방향으로 정비 요청. [2026-09-01 반영 확인] Purchasing > Purchase PO, Sales > Customer PO로 명칭 변경 적용됨. 잔여 항목은 계속 정비 요청.

**재현 절차**

1. 메뉴 트리 (Purchasing · Sales) 진입
2. 현상 확인 — 동일 약어(PO)가 대목차 간 중복 → Purchase PO / Customer PO 반영 확인, 잔여 3건

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-6 (메뉴 명칭 정비) → 이슈 63(초안) → **이슈 60** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 01~59 중 중복 이슈 없음. 담당: SEO. VIII 채번 체계 폐지.',
  findings_md_id = '- Singkatan yang sama ada di beberapa menu utama sehingga berisiko salah paham bagi pengguna. Mohon dirapikan dengan mencantumkan subjek sebagai awalan dan menulis singkatan secara lengkap. [Konfirmasi penerapan 2026-09-01] Perubahan nama menjadi Purchasing > Purchase PO dan Sales > Customer PO sudah diterapkan. Item tersisa mohon terus dirapikan.

**Langkah reproduksi**

1. Masuk ke pohon menu (Purchasing · Sales)
2. Periksa gejala — singkatan yang sama (PO) berulang antar menu utama → Purchase PO / Customer PO sudah diterapkan, 3 item tersisa

# 0. Catatan Penomoran

- 2026-09-09: VIII-6 (Perapian Nama Menu) → isu 63 (draft) → **isu 60** (penomoran ulang setelah penghapusan 3 duplikat v1, 2026-09-09). Tidak ada isu duplikat di 01~59. PIC: SEO. Sistem penomoran VIII dihapus.',
  recommendation_md_ko = '- Sales > PO → Customer PO (고객 발주서 접수·관리) — 반영 확인
- Purchasing > PO → Purchase PO (자사 구매발주서 관리) — 반영 확인
- Purchasing > PPC → PPC (Production Plan) — 약어 단독으로는 생산계획·진행관리 기능의 식별이 어려움
- Purchasing > RECEIPT(WH) → Receipt (Warehouse) / Sales > DELIVERY NOTE(WH) → Delivery Note (Warehouse) — 축약 표기를 풀어 표기

**[Pembaruan 2026-09-09] Proposal Perapian Nama Menu ASM — Tinjauan Menyeluruh 25 Item Menu** / **메뉴 명칭 개선 제안서 (2026-09-09)**

- Sumber: ASM_메뉴_명칭_개선_제안.hwpx (folder G › 03-Claude › 09.시스템개발 › ASM 개발, versi 2026-09-09)
- Cakupan: seluruh 25 item menu ASM — Purchase(9) · Sales(6) · Inventory(2) · Partners(2) · Master Data(4) · Settings(2)
- Tujuan: konsistensi istilah dan peningkatan keterbacaan menu bagi pengguna (staf Korea · Indonesia)

**Poin Perbaikan Umum**

1. Istilah Vendor / Supplier tercampur: menu Purchase memakai Vendor (Vendor Return), menu Partners memakai Suppliers — **istilah disatukan menjadi Supplier**
2. Perbedaan fungsi Receipt vs Receipt(WH) tidak jelas: berisiko salah penggunaan — **mohon konfirmasi tim IT sebagai prioritas utama**
3. Singkatan tanpa penjelasan (PPC, SO): ditulis dengan nama lengkap
4. Kata “Monthly” berulang di 3 menu (Monthly Closing / Monthly Closed Data List / Upload Monthly Closing Data) — konteks sudah diberikan oleh label grup (CLOSING/FINANCE), sehingga nama item dipersingkat

**Usulan Nama Menu — 13 diubah · 12 dipertahankan**

| Grup | Nama Saat Ini | Usulan | Alasan | Keterangan |
| --- | --- | --- | --- | --- |
| Purchase | Purchase PO | **Purchase Order** | Singkatan ditulis lengkap | Pembuatan · pencarian PO pembelian ke supplier |
| Purchase | PPC | **Production Planning** | Nama lengkap ditampilkan dan dipersingkat | Pengelolaan rencana · progres produksi pabrik atas PO |
| Purchase | Shipment | **Import Shipment** | Khusus tahap impor | Pengelolaan informasi pengiriman · pemuatan dari luar negeri |
| Purchase | Customs | **Customs Clearance** | Nama lengkap ditampilkan | Pengelolaan dokumen · proses bea cukai impor |
| Purchase | Receipt(WH) | **Warehouse Receipt** | Singkatan ditulis lengkap | Konfirmasi penerimaan fisik barang di gudang |
| Purchase | Receipt | **Purchase Receipt** | Dibedakan dari Receipt(WH) | Perlu konfirmasi perbedaan dengan menu di atas (mohon balasan tim IT) |
| Purchase | Import Cost | Tetap | - | Pencatatan biaya tambahan (bea masuk, freight, dll.) |
| Purchase | Vendor Return | **Supplier Return** | Disamakan dengan istilah menu Partners (Suppliers) | Proses retur ke supplier |
| Purchase | Credit Note | Tetap | - | Dokumen penyelesaian retur · diskon |
| Sales | Quotation | Tetap | - | Pembuatan · pencarian penawaran harga ke customer |
| Sales | Customer PO | Tetap | - | Pendaftaran PO yang diterima dari customer |
| Sales | SO | **Sales Order** | Singkatan ditulis lengkap | Konfirmasi order penjualan internal |
| Sales | Delivery Order | Tetap | - | Dokumen perintah pengiriman |
| Sales | Delivery Note | Tetap | - | Dokumen bukti pengiriman aktual |
| Sales | Delivery Note(WH) | **Warehouse Delivery** | Penyeragaman aturan penamaan | Perlu konfirmasi perbedaan dengan menu di atas (mohon balasan tim IT) |
| Inventory | Inventory List | Tetap | - | Pencarian stok per gudang |
| Inventory | Create Inventory Monthly Closing | **Monthly Inventory Closing** | - | Proses upload data closing bulanan |
| Partners | Customers | Tetap | - | Pengelolaan master data customer |
| Partners | Suppliers | Tetap | - | Pengelolaan master data supplier |
| Master Data | Products | Tetap | - | Pengelolaan master data produk (ban, dll.) |
| Master Data | Warehouses | Tetap | - | Pengelolaan master data gudang |
| Master Data | Monthly Closed Data List | **Monthly Closing Data** | Kata “List” dihapus | Pencarian daftar data yang sudah closing |
| Master Data | Upload Monthly Closing Data | **Upload Closing Data** | Dipersingkat | Proses upload data closing bulanan |
| Settings | Search Staff | **Staff Directory** | Mencerminkan fungsi pencarian dan daftar | Pencarian informasi karyawan |
| Settings | Change Password | Tetap | - | Penggantian password akun |
- Ruang lingkup penerapan: hanya perubahan label menu (tanpa perubahan fungsi · DB)
- Setelah nama menu final, seluruh dokumen terkait (12 dokumen inti, dll.) akan diperbarui sekaligus',
  recommendation_md_id = '- Sales > PO → Customer PO (penerimaan · pengelolaan PO pelanggan) — sudah diterapkan
- Purchasing > PO → Purchase PO (pengelolaan PO pembelian perusahaan) — sudah diterapkan
- Purchasing > PPC → PPC (Production Plan) — singkatan saja sulit mengidentifikasi fungsi rencana · pemantauan produksi
- Purchasing > RECEIPT(WH) → Receipt (Warehouse) / Sales > DELIVERY NOTE(WH) → Delivery Note (Warehouse) — singkatan ditulis lengkap

**[Pembaruan 2026-09-09] Proposal Perapian Nama Menu ASM — Tinjauan Menyeluruh 25 Item Menu**

- Sumber: ASM_메뉴_명칭_개선_제안.hwpx (folder G › 03-Claude › 09.시스템개발 › ASM 개발, versi 2026-09-09)
- Cakupan: seluruh 25 item menu ASM — Purchase(9) · Sales(6) · Inventory(2) · Partners(2) · Master Data(4) · Settings(2)
- Tujuan: konsistensi istilah dan peningkatan keterbacaan menu bagi pengguna (staf Korea · Indonesia)

**Poin Perbaikan Umum**

1. Istilah Vendor / Supplier tercampur: menu Purchase memakai Vendor (Vendor Return), menu Partners memakai Suppliers — **istilah disatukan menjadi Supplier**
2. Perbedaan fungsi Receipt vs Receipt(WH) tidak jelas: berisiko salah penggunaan — **mohon konfirmasi tim IT sebagai prioritas utama**
3. Singkatan tanpa penjelasan (PPC, SO): ditulis dengan nama lengkap
4. Kata “Monthly” berulang di 3 menu (Monthly Closing / Monthly Closed Data List / Upload Monthly Closing Data) — konteks sudah diberikan oleh label grup (CLOSING/FINANCE), sehingga nama item dipersingkat

**Usulan Nama Menu — 13 diubah · 12 dipertahankan**

| Grup | Nama Saat Ini | Usulan | Alasan | Keterangan |
| --- | --- | --- | --- | --- |
| Purchase | Purchase PO | **Purchase Order** | Singkatan ditulis lengkap | Pembuatan · pencarian PO pembelian ke supplier |
| Purchase | PPC | **Production Planning** | Nama lengkap ditampilkan dan dipersingkat | Pengelolaan rencana · progres produksi pabrik atas PO |
| Purchase | Shipment | **Import Shipment** | Khusus tahap impor | Pengelolaan informasi pengiriman · pemuatan dari luar negeri |
| Purchase | Customs | **Customs Clearance** | Nama lengkap ditampilkan | Pengelolaan dokumen · proses bea cukai impor |
| Purchase | Receipt(WH) | **Warehouse Receipt** | Singkatan ditulis lengkap | Konfirmasi penerimaan fisik barang di gudang |
| Purchase | Receipt | **Purchase Receipt** | Dibedakan dari Receipt(WH) | Perlu konfirmasi perbedaan dengan menu di atas (mohon balasan tim IT) |
| Purchase | Import Cost | Tetap | - | Pencatatan biaya tambahan (bea masuk, freight, dll.) |
| Purchase | Vendor Return | **Supplier Return** | Disamakan dengan istilah menu Partners (Suppliers) | Proses retur ke supplier |
| Purchase | Credit Note | Tetap | - | Dokumen penyelesaian retur · diskon |
| Sales | Quotation | Tetap | - | Pembuatan · pencarian penawaran harga ke customer |
| Sales | Customer PO | Tetap | - | Pendaftaran PO yang diterima dari customer |
| Sales | SO | **Sales Order** | Singkatan ditulis lengkap | Konfirmasi order penjualan internal |
| Sales | Delivery Order | Tetap | - | Dokumen perintah pengiriman |
| Sales | Delivery Note | Tetap | - | Dokumen bukti pengiriman aktual |
| Sales | Delivery Note(WH) | **Warehouse Delivery** | Penyeragaman aturan penamaan | Perlu konfirmasi perbedaan dengan menu di atas (mohon balasan tim IT) |
| Inventory | Inventory List | Tetap | - | Pencarian stok per gudang |
| Inventory | Create Inventory Monthly Closing | **Monthly Inventory Closing** | - | Proses upload data closing bulanan |
| Partners | Customers | Tetap | - | Pengelolaan master data customer |
| Partners | Suppliers | Tetap | - | Pengelolaan master data supplier |
| Master Data | Products | Tetap | - | Pengelolaan master data produk (ban, dll.) |
| Master Data | Warehouses | Tetap | - | Pengelolaan master data gudang |
| Master Data | Monthly Closed Data List | **Monthly Closing Data** | Kata “List” dihapus | Pencarian daftar data yang sudah closing |
| Master Data | Upload Monthly Closing Data | **Upload Closing Data** | Dipersingkat | Proses upload data closing bulanan |
| Settings | Search Staff | **Staff Directory** | Mencerminkan fungsi pencarian dan daftar | Pencarian informasi karyawan |
| Settings | Change Password | Tetap | - | Penggantian password akun |
- Ruang lingkup penerapan: hanya perubahan label menu (tanpa perubahan fungsi · DB)
- Setelah nama menu final, seluruh dokumen terkait (12 dokumen inti, dll.) akan diperbarui sekaligus',
  business_answer_md_ko = '- 잔여 명칭 정비 회신 요청 (2026-09-07) — PPC · Receipt(WH) · Delivery Note(WH)
- 메뉴 명칭 개선 제안서 전달 (2026-09-09) — 메뉴 25종 전수 검토, 13종 변경 · 12종 유지 제안(3. 개선 의견의 갱신 표 참조). 최종 용어: Supplier(Vendor 사용 중단), 메뉴 그룹명 Purchase. Receipt/Receipt(WH) 및 Delivery Note/DN(WH)의 기능 차이에 대한 IT부서 회신 요청',
  business_answer_md_id = '- Mohon balasan perapian nama yang tersisa (2026-09-07) — PPC · Receipt(WH) · Delivery Note(WH)
- Proposal perapian nama menu disampaikan (2026-09-09) — tinjauan menyeluruh 25 item menu, usulan 13 diubah · 12 dipertahankan (lihat tabel pembaruan pada 3. Rekomendasi). Istilah final: Supplier (Vendor tidak dipakai lagi), nama grup menu Purchase. Mohon balasan tim IT atas perbedaan fungsi Receipt/Receipt(WH) dan Delivery Note/DN(WH)'
WHERE issue_no = '60' AND NOT is_archived;

-- 확인 — 살아 있는 60건 모두 양쪽이 채워져야 합니다(현업 답변은 원문이 있는 건만).
SELECT count(*) AS total,
       count(*) FILTER (WHERE findings_md_ko IS NULL OR findings_md_id IS NULL)             AS findings_missing,
       count(*) FILTER (WHERE recommendation_md_ko IS NULL OR recommendation_md_id IS NULL) AS reco_missing,
       count(*) FILTER (WHERE business_answer_md IS NOT NULL
                          AND (business_answer_md_ko IS NULL OR business_answer_md_id IS NULL)) AS answer_missing
  FROM public.csr_issues WHERE NOT is_archived;
