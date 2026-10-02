-- =============================================================================
-- SEO 담당 12건 현업 답변 · 검증 이력 (2026-10-02) — 038 적용 후 실행. 달러 인용 없음. 재실행 안전.
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--   대상 : 담당자(it_pic) = SEO 12건 — 21 · 22 · 23 · 24 · 25 · 26 · 57 · 58 · 59 · 60 · 71 · 74
--   근거 : 2026-10-02 실서버(asm.ascendotyre.com) 화면 검증, 계정 Jo
--
--   1. 현업 답변(business_answer_md_ko · _id · 원본) — 2026-10-02 답변을 맨 위에 넣고 기존 답변은
--      「[이전 답변 YYYY-MM-DD]」 표시 아래 그대로 보존. 기존 답변이 비어 있거나 '- —' 이면 교체.
--      business_answered_on = 2026-10-02. 이미 반영된 건(맨 앞 '[2026-10-02]')은 건너뜀
--   2. 검증 이력 2026-10-02 신규 8행 — 23 · 24 · 25 · 26 · 57 · 58 · 59 · 60
--      (21 · 22 · 71 · 74 는 038에서 등록 완료 → 22 · 71 은 내용만 보강). 017 트리거가 헤더 동기화
--      결과 : 23 · 24 · 25 · 57 · 59 미조치 / 58 · 60 부분조치 / 26 조치확인
--   3. 71 IT상태 Completed → Verified (현업 전환)
-- =============================================================================

SELECT set_config('csr.actor', 'migration:039 (2026-10-02 SEO 담당 12건 현업 답변 · 검증 이력)', false);

-- ── 1. 현업 답변 12건 ───────────────────────────────────────────────────────
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 재확인 : Staff Directory 77명 DEPARTMENT 14종 그대로(SALES 25 · WAREHOUSE 13 · SURABAYA 9 · GENERAL 6 · GUDANG 5 · SEMARANG 4 · ACCOUNTING 4 · IT SUPPORT 3 · FINANCE 2 · IMPORT 2 · ADM SALES 1 · LEGAL 1 · KARAWANG 1 · APARTEMENT 1). 09-07 결과와 변동 없음
- 「부서코드 적용됨」은 코드 테이블 생성으로 이해함. 화면·데이터에는 미반영 : 지점명 3종(SURABAYA · SEMARANG · KARAWANG)과 GUDANG/WAREHOUSE 이중 표기 유지, 지점 직원의 LOCATION도 JAKARTA로 되어 있어 지점 구분 기능 없음
- 요청 : ① 인사 Raw Data를 그대로 적재하지 말고 부서코드 매핑(표준 9종)을 거쳐 적재, 자유입력 차단 ② 지점명은 LOCATION(JAKARTA · KARAWANG · SEMARANG · SURABAYA)으로 분리 ③ 77명 매핑표는 총괄팀이 인사팀과 10-07까지 전달
- Ongoing 유지, 목표배포일 기재 요청'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan ulang server produksi 2026-10-02 : DEPARTMENT 77 karyawan di Staff Directory masih 14 jenis (SALES 25 · WAREHOUSE 13 · SURABAYA 9 · GENERAL 6 · GUDANG 5 · SEMARANG 4 · ACCOUNTING 4 · IT SUPPORT 3 · FINANCE 2 · IMPORT 2 · ADM SALES 1 · LEGAL 1 · KARAWANG 1 · APARTEMENT 1). Tidak ada perubahan dari hasil 09-07
- 「Kode departemen sudah diterapkan」 dipahami sebagai pembuatan tabel kode. Belum tercermin di layar · data : 3 nama cabang (SURABAYA · SEMARANG · KARAWANG) dan penulisan ganda GUDANG/WAREHOUSE masih ada, LOCATION karyawan cabang pun tertulis JAKARTA sehingga tidak berfungsi membedakan cabang
- Permintaan : ① Raw data HRD tidak dimuat apa adanya, melainkan melalui pemetaan kode departemen (standar 9 jenis), input bebas diblokir ② Nama cabang dipisahkan ke LOCATION (JAKARTA · KARAWANG · SEMARANG · SURABAYA) ③ Tabel pemetaan 77 karyawan disampaikan Tim Umum bersama HRD paling lambat 10-07
- Status Ongoing dipertahankan, mohon cantumkan tanggal rilis target'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 재확인 : Staff Directory 77명 DEPARTMENT 14종 그대로(SALES 25 · WAREHOUSE 13 · SURABAYA 9 · GENERAL 6 · GUDANG 5 · SEMARANG 4 · ACCOUNTING 4 · IT SUPPORT 3 · FINANCE 2 · IMPORT 2 · ADM SALES 1 · LEGAL 1 · KARAWANG 1 · APARTEMENT 1). 09-07 결과와 변동 없음
- 「부서코드 적용됨」은 코드 테이블 생성으로 이해함. 화면·데이터에는 미반영 : 지점명 3종(SURABAYA · SEMARANG · KARAWANG)과 GUDANG/WAREHOUSE 이중 표기 유지, 지점 직원의 LOCATION도 JAKARTA로 되어 있어 지점 구분 기능 없음
- 요청 : ① 인사 Raw Data를 그대로 적재하지 말고 부서코드 매핑(표준 9종)을 거쳐 적재, 자유입력 차단 ② 지점명은 LOCATION(JAKARTA · KARAWANG · SEMARANG · SURABAYA)으로 분리 ③ 77명 매핑표는 총괄팀이 인사팀과 10-07까지 전달
- Ongoing 유지, 목표배포일 기재 요청'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '21' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 재확인 : 목록 화면만 영미식, 상세·입력 화면은 인니식 유지 → Completed 부적정. 예) PO 상세 AJ-20261001-005 Subtotal 1.953.271.071 · PPC 상세 1.491.274.549 · 견적/고객PO/SO 상세 45.810.900 · SO 품목 단가 입력란 228.829 · Shipment 상세 19.247,91 · Customs 상세 18.688.000,00 / FOB 377,41 · Receipt 상세 AMOUNT 24.536,8. Import Cost 상세만 영미식(USD 19,247.91 / IDR 18,688,000)
- 「확인 필요」 답변 : 09-07 확정값 유지. 전 화면(목록 · 상세 · 입력 · 팝업 · 출력물) 천 단위 콤마(,) · 소수점 마침표(.) · 수량 정수 · 단가 소수점 2자리 · IDR 총액 정수. 환율(EXCHANGE RATE 17707)도 천 단위 구분 적용
- 요청 : IT상태 Ongoing 환원, 공통 포맷 함수 1곳으로 통일 후 상세·입력 화면 적용, 목표배포일 기재. 13번(IDR 소수점)과 함께 처리'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan ulang server produksi 2026-10-02 : hanya layar daftar yang memakai format internasional, layar detail · input masih format Indonesia → Completed tidak sesuai. Contoh) Subtotal detail PO AJ-20261001-005 1.953.271.071 · detail PPC 1.491.274.549 · detail Quotation/Customer PO/SO 45.810.900 · kolom input harga satuan item SO 228.829 · detail Shipment 19.247,91 · detail Customs 18.688.000,00 / FOB 377,41 · AMOUNT detail Receipt 24.536,8. Hanya detail Import Cost yang berformat internasional (USD 19,247.91 / IDR 18,688,000)
- Jawaban atas 「Perlu konfirmasi」 : keputusan 09-07 tetap. Seluruh layar (daftar · detail · input · popup · cetakan) memakai pemisah ribuan koma (,) · desimal titik (.) · kuantitas bilangan bulat · harga satuan 2 desimal · total IDR bilangan bulat. Kurs (EXCHANGE RATE 17707) juga diberi pemisah ribuan
- Permintaan : status IT dikembalikan ke Ongoing, fungsi format disatukan di satu tempat lalu diterapkan ke layar detail · input, cantumkan tanggal rilis target. Ditangani bersama isu 13 (desimal IDR)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 재확인 : 목록 화면만 영미식, 상세·입력 화면은 인니식 유지 → Completed 부적정. 예) PO 상세 AJ-20261001-005 Subtotal 1.953.271.071 · PPC 상세 1.491.274.549 · 견적/고객PO/SO 상세 45.810.900 · SO 품목 단가 입력란 228.829 · Shipment 상세 19.247,91 · Customs 상세 18.688.000,00 / FOB 377,41 · Receipt 상세 AMOUNT 24.536,8. Import Cost 상세만 영미식(USD 19,247.91 / IDR 18,688,000)
- 「확인 필요」 답변 : 09-07 확정값 유지. 전 화면(목록 · 상세 · 입력 · 팝업 · 출력물) 천 단위 콤마(,) · 소수점 마침표(.) · 수량 정수 · 단가 소수점 2자리 · IDR 총액 정수. 환율(EXCHANGE RATE 17707)도 천 단위 구분 적용
- 요청 : IT상태 Ongoing 환원, 공통 포맷 함수 1곳으로 통일 후 상세·입력 화면 적용, 목표배포일 기재. 13번(IDR 소수점)과 함께 처리'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '22' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 재확인(뷰포트 1,366px) : 견적 신규 QUOTE DATE 잘림은 해소. 잔여 ① SO 목록 QTY 열 한 자리씩 줄바꿈(3 0 0), AMOUNT 3줄, STATUS·DELIV 배지 겹침(CONFIRMED/PREPARING), 헤더 분절(WAREHO USE · REMAR K) ② Receipt 상세 헤더 입력값 잘림(RECEIPT NO. ''RCP1'' · RECEIPT DATE ''2('' · SURAT JALAN NO. ''ARI''), 품목 단가 1.363.160 잘림 ③ PO 목록 STATUS 배지 넘침 7건 ④ 전 목록 기준열(문서번호) 고정 없음
- 요청 : 수용기준(1,366×768 라벨 잘림 없음 + 목록 기준열 고정) 기준으로 화면별 조치 계획과 목표배포일 회신. 우선순위 : SO·PO·DN 목록(배지·수량 열 최소폭) → Receipt 상세 헤더(입력란 최소폭) → 기준열 고정
- Ongoing 유지'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan ulang server produksi 2026-10-02 (viewport 1,366px) : pemotongan QUOTE DATE pada Quotation baru sudah teratasi. Sisa ① Daftar SO : kolom QTY terpotong per digit (3 0 0), AMOUNT 3 baris, badge STATUS · DELIV tumpang tindih (CONFIRMED/PREPARING), header terpenggal (WAREHO USE · REMAR K) ② Detail Receipt : nilai header terpotong (RECEIPT NO. ''RCP1'' · RECEIPT DATE ''2('' · SURAT JALAN NO. ''ARI''), harga satuan item 1.363.160 terpotong ③ Daftar PO : badge STATUS meluap 7 baris ④ Seluruh daftar tanpa kolom acuan (nomor dokumen) yang terkunci
- Permintaan : balasan rencana perbaikan per layar dan tanggal rilis target berdasarkan kriteria selesai (tanpa label terpotong pada 1,366×768 + kolom acuan daftar terkunci). Prioritas : daftar SO · PO · DN (lebar minimum kolom badge · kuantitas) → header detail Receipt (lebar minimum kolom input) → kolom acuan terkunci
- Status Ongoing dipertahankan'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 재확인(뷰포트 1,366px) : 견적 신규 QUOTE DATE 잘림은 해소. 잔여 ① SO 목록 QTY 열 한 자리씩 줄바꿈(3 0 0), AMOUNT 3줄, STATUS·DELIV 배지 겹침(CONFIRMED/PREPARING), 헤더 분절(WAREHO USE · REMAR K) ② Receipt 상세 헤더 입력값 잘림(RECEIPT NO. ''RCP1'' · RECEIPT DATE ''2('' · SURAT JALAN NO. ''ARI''), 품목 단가 1.363.160 잘림 ③ PO 목록 STATUS 배지 넘침 7건 ④ 전 목록 기준열(문서번호) 고정 없음
- 요청 : 수용기준(1,366×768 라벨 잘림 없음 + 목록 기준열 고정) 기준으로 화면별 조치 계획과 목표배포일 회신. 우선순위 : SO·PO·DN 목록(배지·수량 열 최소폭) → Receipt 상세 헤더(입력란 최소폭) → 기준열 고정
- Ongoing 유지'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '23' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 재확인 : 전표 목록 페이지 크기 15건 고정(API limit=15), 재고 목록 10건 고정. 페이지 크기 선택 · 열 헤더 정렬(헤더 클릭 무반응, 정렬 아이콘 없음) · 기간 필터 없음. 09-08 결과와 동일(10건 → 15건 변경만 확인)
- 09-07 현업 결정 유지 : 1단계(오픈 前) 페이지 크기 선택 10/20/50/100 + 열 헤더 정렬은 API limit 파라미터가 이미 있어 화면만으로 가능 / 2단계(오픈 後) 상태 · 기간 · 거래처 필터
- 요청 : 「공통사항」으로 두지 말고 1단계 적용 화면 범위(PO · PPC · 입고 · 견적 · SO · DO · DN · 고객 · 제품 · 재고)와 목표배포일 회신. Open → Ongoing 전환 요청'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan ulang server produksi 2026-10-02 : ukuran halaman daftar dokumen tetap 15 baris (API limit=15), daftar stok tetap 10 baris. Tidak ada pilihan ukuran halaman · pengurutan header kolom (klik header tidak bereaksi, tanpa ikon urut) · filter periode. Sama dengan hasil 09-08 (hanya berubah 10 → 15 baris)
- Keputusan tim bisnis 09-07 tetap : Tahap 1 (sebelum Go-Live) pilihan ukuran halaman 10/20/50/100 + pengurutan header kolom dapat dilakukan di sisi layar saja karena parameter limit API sudah ada / Tahap 2 (setelah Go-Live) filter status · periode · mitra
- Permintaan : jangan dibiarkan sebagai 「item umum」, mohon balasan lingkup layar penerapan Tahap 1 (PO · PPC · Receipt · Quotation · SO · DO · DN · Customer · Product · Inventory) dan tanggal rilis target. Mohon ubah Open → Ongoing'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 재확인 : 전표 목록 페이지 크기 15건 고정(API limit=15), 재고 목록 10건 고정. 페이지 크기 선택 · 열 헤더 정렬(헤더 클릭 무반응, 정렬 아이콘 없음) · 기간 필터 없음. 09-08 결과와 동일(10건 → 15건 변경만 확인)
- 09-07 현업 결정 유지 : 1단계(오픈 前) 페이지 크기 선택 10/20/50/100 + 열 헤더 정렬은 API limit 파라미터가 이미 있어 화면만으로 가능 / 2단계(오픈 後) 상태 · 기간 · 거래처 필터
- 요청 : 「공통사항」으로 두지 말고 1단계 적용 화면 범위(PO · PPC · 입고 · 견적 · SO · DO · DN · 고객 · 제품 · 재고)와 목표배포일 회신. Open → Ongoing 전환 요청'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '24' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 확인(견적 신규, 저장 요청은 차단한 상태로 Save 클릭) : 하단 검정 토스트 「Check Quote Title」 1건만 표시, 해당 필드 강조 · 포커스 이동 없음, 입력란 required 속성 없음. 최초 현상 그대로
- 수용기준 유지 : 필수 미입력 항목 전체를 한 번에 표시 + 해당 필드 적색 테두리 + 첫 항목으로 포커스 이동 + 메시지에 항목명 포함. 검색형 입력란(고객 · 공급사 · 품목 · 창고) 미선택 상태 구분 표시, 다른 탭 오류 시 해당 탭으로 이동
- 요청 : 공통 입력 컴포넌트에서 1회 적용하면 전 화면 반영 가능 → 적용 방식과 목표배포일 회신. 오픈 前 필수'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan server produksi 2026-10-02 (Quotation baru, tombol Save diklik dengan permintaan simpan diblokir) : hanya satu toast hitam 「Check Quote Title」 di bagian bawah, tanpa penekanan field · perpindahan fokus, kolom input tanpa atribut required. Sama dengan temuan awal
- Kriteria selesai tetap : tampilkan seluruh item wajib yang kosong sekaligus + border merah pada field terkait + fokus ke item pertama + nama item dalam pesan. Kolom input tipe pencarian (customer · supplier · product · warehouse) menampilkan status belum dipilih secara jelas, bila kesalahan ada di tab lain pindah ke tab tersebut
- Permintaan : penerapan sekali pada komponen input bersama dapat berlaku ke seluruh layar → balasan cara penerapan dan tanggal rilis target. Wajib sebelum Go-Live'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 확인(견적 신규, 저장 요청은 차단한 상태로 Save 클릭) : 하단 검정 토스트 「Check Quote Title」 1건만 표시, 해당 필드 강조 · 포커스 이동 없음, 입력란 required 속성 없음. 최초 현상 그대로
- 수용기준 유지 : 필수 미입력 항목 전체를 한 번에 표시 + 해당 필드 적색 테두리 + 첫 항목으로 포커스 이동 + 메시지에 항목명 포함. 검색형 입력란(고객 · 공급사 · 품목 · 창고) 미선택 상태 구분 표시, 다른 탭 오류 시 해당 탭으로 이동
- 요청 : 공통 입력 컴포넌트에서 1회 적용하면 전 화면 반영 가능 → 적용 방식과 목표배포일 회신. 오픈 前 필수'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '25' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 재확인 : PO 목록 로딩 요청 134건 중 404 없음, ascendo-asm.com 참조 없음, /api/avatar 200. 조치 유지 확인(Verified 유지)
- 참고 : 74번(글꼴) 조치로 Google Fonts(fonts.googleapis.com · fonts.gstatic.com) 외부 참조가 새로 추가됨. 인터넷 차단 환경에서는 대체 글꼴로 표시되므로 Noto Sans를 자사 도메인(/assets)에 포함하는 방안 검토 요청. 본 이슈 재오픈은 하지 않음'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan ulang 2026-10-02 : dari 134 permintaan saat memuat daftar PO tidak ada 404, tidak ada referensi ascendo-asm.com, /api/avatar 200. Perbaikan dikonfirmasi tetap (Verified dipertahankan)
- Catatan : perbaikan isu 74 (font) menambahkan referensi eksternal Google Fonts (fonts.googleapis.com · fonts.gstatic.com). Pada lingkungan tanpa internet font akan diganti font pengganti, mohon pertimbangkan menyertakan Noto Sans pada domain sendiri (/assets). Isu ini tidak dibuka kembali'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 재확인 : PO 목록 로딩 요청 134건 중 404 없음, ascendo-asm.com 참조 없음, /api/avatar 200. 조치 유지 확인(Verified 유지)
- 참고 : 74번(글꼴) 조치로 Google Fonts(fonts.googleapis.com · fonts.gstatic.com) 외부 참조가 새로 추가됨. 인터넷 차단 환경에서는 대체 글꼴로 표시되므로 Noto Sans를 자사 도메인(/assets)에 포함하는 방안 검토 요청. 본 이슈 재오픈은 하지 않음'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '26' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- IT 09-26 조치현황에 본 건 누락, 09-07 요청 후 미회신 지속
- 2026-10-02 실서버 확인 : Customs 상세 열 제목이 「PPN 11(%) · PPH 7.5(%)」로 고정, BM(%)만 제품 마스터 HS CODE BM(%)에서 행별 적용(4011.80.40 → 5%). 제품 마스터에 HS CODE BM/PPN/PPH(%) 항목은 있으나 적용 기간 · 승인 · 이력 없음. 세율 변경 시 소스 수정이 필요한 구조 그대로
- 요청 : 세율 마스터(세목 · 세율 · 적용 시작일 · 종료일 · HS 코드별 BM) 신설 여부와 일정 회신. 단기 대안으로 제품 마스터의 HS CODE PPN/PPH(%) 값을 Customs · Import Cost 계산에 실제 참조하도록 변경 가능한지 함께 회신. 10-09 주간 갱신 시 회신 요청'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Isu ini tidak tercantum pada laporan tindak lanjut IT 09-26, belum ada balasan sejak permintaan 09-07
- Pemeriksaan server produksi 2026-10-02 : judul kolom detail Customs tetap 「PPN 11(%) · PPH 7.5(%)」, hanya BM(%) yang diterapkan per baris dari HS CODE BM(%) master produk (4011.80.40 → 5%). Master produk memiliki item HS CODE BM/PPN/PPH(%) tetapi tanpa periode berlaku · persetujuan · riwayat. Perubahan tarif pajak masih memerlukan perubahan kode sumber
- Permintaan : balasan apakah master tarif pajak (jenis pajak · tarif · tanggal mulai · tanggal akhir · BM per kode HS) akan dibuat beserta jadwalnya. Sebagai alternatif jangka pendek, mohon sekaligus dijawab apakah nilai HS CODE PPN/PPH(%) master produk dapat benar-benar dirujuk dalam perhitungan Customs · Import Cost. Mohon balasan pada pembaruan mingguan 10-09'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- IT 09-26 조치현황에 본 건 누락, 09-07 요청 후 미회신 지속
- 2026-10-02 실서버 확인 : Customs 상세 열 제목이 「PPN 11(%) · PPH 7.5(%)」로 고정, BM(%)만 제품 마스터 HS CODE BM(%)에서 행별 적용(4011.80.40 → 5%). 제품 마스터에 HS CODE BM/PPN/PPH(%) 항목은 있으나 적용 기간 · 승인 · 이력 없음. 세율 변경 시 소스 수정이 필요한 구조 그대로
- 요청 : 세율 마스터(세목 · 세율 · 적용 시작일 · 종료일 · HS 코드별 BM) 신설 여부와 일정 회신. 단기 대안으로 제품 마스터의 HS CODE PPN/PPH(%) 값을 Customs · Import Cost 계산에 실제 참조하도록 변경 가능한지 함께 회신. 10-09 주간 갱신 시 회신 요청'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '57' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- IT 09-26 조치현황에 본 건 누락, 미회신 지속
- 2026-10-02 실서버 확인 : 견적 상세 APPROVED BY 1인 표기(단일 승인자, 읽기전용)만 있음. 금액 구간별 결재선 자동 지정 · 결재 완료 전 CONFIRMED 차단 · 결재 이력 조회 화면 없음(결재 관련 라우트 없음). 09-01 확인한 PO 결재선 팝업(PREPARED BY · CHECKER 1 · 2 · APPROVER 1)은 선택 사항 그대로
- 요청 : 34번 Flow 정의서(2026-09-08 전달, Flow A 결재 · 알림) 기준으로 ① 결재선 필수화 ② 금액 구간표는 총괄팀이 10-07까지 전달 ③ 문서별 결재자 · 일시 조회 화면. 수용 여부와 일정 회신, 오픈 前 필수로 분류'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Isu ini tidak tercantum pada laporan tindak lanjut IT 09-26, belum ada balasan
- Pemeriksaan server produksi 2026-10-02 : detail Quotation hanya menampilkan APPROVED BY 1 orang (penyetuju tunggal, read-only). Belum ada penetapan jalur persetujuan otomatis per rentang nilai · pemblokiran CONFIRMED sebelum persetujuan selesai · layar riwayat persetujuan (tanpa route terkait persetujuan). Popup jalur persetujuan PO yang dikonfirmasi 09-01 (PREPARED BY · CHECKER 1 · 2 · APPROVER 1) masih bersifat opsional
- Permintaan : berdasarkan Dokumen Definisi Flow isu 34 (disampaikan 2026-09-08, Flow A persetujuan · notifikasi) ① jalur persetujuan diwajibkan ② tabel rentang nilai disampaikan Tim Umum paling lambat 10-07 ③ layar riwayat penyetuju · waktu per dokumen. Mohon balasan penerimaan dan jadwal, digolongkan wajib sebelum Go-Live'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- IT 09-26 조치현황에 본 건 누락, 미회신 지속
- 2026-10-02 실서버 확인 : 견적 상세 APPROVED BY 1인 표기(단일 승인자, 읽기전용)만 있음. 금액 구간별 결재선 자동 지정 · 결재 완료 전 CONFIRMED 차단 · 결재 이력 조회 화면 없음(결재 관련 라우트 없음). 09-01 확인한 PO 결재선 팝업(PREPARED BY · CHECKER 1 · 2 · APPROVER 1)은 선택 사항 그대로
- 요청 : 34번 Flow 정의서(2026-09-08 전달, Flow A 결재 · 알림) 기준으로 ① 결재선 필수화 ② 금액 구간표는 총괄팀이 10-07까지 전달 ③ 문서별 결재자 · 일시 조회 화면. 수용 여부와 일정 회신, 오픈 前 필수로 분류'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '58' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- IT 09-26 조치현황 : Open 표기만 있고 수용 여부 · 일정 미기재. 09-07 요청 후 미회신 지속
- 2026-10-02 실서버 확인 : Purchase 메뉴 9개(PURCHASE PO ~ CREDIT NOTE)에 대금지급 화면 없음, 관련 라우트 없음. 발주 엑셀 PAYMENT PLAN 시트로 계속 별도 관리 중
- 요청 : 화면 신설 수용 여부(수용 / 조건부 / 반려)와 사유를 10-09 주간 갱신 시 회신. 수용 시 1차 범위는 PO 연결 + 지급조건 · 예정일 · 실제 지급일 · 환율 · 잔액 입력과 월별 지급 예정 조회로 축소 가능(PPC → 지급 → Shipment 상태 연동은 2차)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Laporan tindak lanjut IT 09-26 : hanya tertulis Open tanpa penerimaan · jadwal. Belum ada balasan sejak permintaan 09-07
- Pemeriksaan server produksi 2026-10-02 : 9 menu Purchase (PURCHASE PO ~ CREDIT NOTE) tidak memiliki layar pembayaran, tanpa route terkait. Masih dikelola terpisah lewat sheet PAYMENT PLAN pada Excel pemesanan
- Permintaan : balasan penerimaan pembuatan layar (diterima / bersyarat / ditolak) beserta alasannya pada pembaruan mingguan 10-09. Bila diterima, lingkup tahap 1 dapat dipersempit menjadi keterkaitan PO + input syarat pembayaran · tanggal rencana · tanggal pembayaran aktual · kurs · sisa serta tampilan rencana pembayaran bulanan (keterkaitan status PPC → pembayaran → Shipment pada tahap 2)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- IT 09-26 조치현황 : Open 표기만 있고 수용 여부 · 일정 미기재. 09-07 요청 후 미회신 지속
- 2026-10-02 실서버 확인 : Purchase 메뉴 9개(PURCHASE PO ~ CREDIT NOTE)에 대금지급 화면 없음, 관련 라우트 없음. 발주 엑셀 PAYMENT PLAN 시트로 계속 별도 관리 중
- 요청 : 화면 신설 수용 여부(수용 / 조건부 / 반려)와 사유를 10-09 주간 갱신 시 회신. 수용 시 1차 범위는 PO 연결 + 지급조건 · 예정일 · 실제 지급일 · 환율 · 잔액 입력과 월별 지급 예정 조회로 축소 가능(PPC → 지급 → Shipment 상태 연동은 2차)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '59' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 확인 : 09-09 제안 13건 중 11건 반영(PRODUCTION PLANNING · IMPORT SHIPMENT · CUSTOMS CLEARANCE · WAREHOUSE RECEIPT · SUPPLIER RETURN · SALES ORDER · WAREHOUSE DELIVERY · MONTHLY INVENTORY CLOSING · MONTHLY CLOSING DATA · UPLOAD CLOSING DATA · STAFF DIRECTORY), 유지 12건 그대로. 미반영 2건 : PURCHASE PO → Purchase Order, RECEIPT → Purchase Receipt
- 판정 : 부분조치. 미반영 2건은 Receipt / Receipt(WH) 기능 차이 회신(09-09 요청)이 없어 보류된 것으로 봄
- 요청 : ① Receipt(구매 입고)와 Warehouse Receipt(창고 입고확정) 기능 차이 회신 후 명칭 확정 · 2건 반영 ② 메뉴 명칭 다국어 리소스(EN · ID) 관리 여부 회신. 2건 반영 후 Completed 재처리'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan server produksi 2026-10-02 : 11 dari 13 usulan 09-09 sudah diterapkan (PRODUCTION PLANNING · IMPORT SHIPMENT · CUSTOMS CLEARANCE · WAREHOUSE RECEIPT · SUPPLIER RETURN · SALES ORDER · WAREHOUSE DELIVERY · MONTHLY INVENTORY CLOSING · MONTHLY CLOSING DATA · UPLOAD CLOSING DATA · STAFF DIRECTORY), 12 item yang dipertahankan tetap. Belum diterapkan 2 item : PURCHASE PO → Purchase Order, RECEIPT → Purchase Receipt
- Penilaian : sebagian diterapkan. 2 item yang belum diterapkan dianggap tertunda karena tim IT belum menjawab perbedaan fungsi Receipt / Receipt(WH) (diminta 09-09)
- Permintaan : ① balasan perbedaan fungsi Receipt (penerimaan pembelian) dan Warehouse Receipt (konfirmasi penerimaan gudang), lalu nama difinalkan · 2 item diterapkan ② balasan apakah nama menu dikelola sebagai resource multibahasa (EN · ID). Completed diproses ulang setelah 2 item diterapkan'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 확인 : 09-09 제안 13건 중 11건 반영(PRODUCTION PLANNING · IMPORT SHIPMENT · CUSTOMS CLEARANCE · WAREHOUSE RECEIPT · SUPPLIER RETURN · SALES ORDER · WAREHOUSE DELIVERY · MONTHLY INVENTORY CLOSING · MONTHLY CLOSING DATA · UPLOAD CLOSING DATA · STAFF DIRECTORY), 유지 12건 그대로. 미반영 2건 : PURCHASE PO → Purchase Order, RECEIPT → Purchase Receipt
- 판정 : 부분조치. 미반영 2건은 Receipt / Receipt(WH) 기능 차이 회신(09-09 요청)이 없어 보류된 것으로 봄
- 요청 : ① Receipt(구매 입고)와 Warehouse Receipt(창고 입고확정) 기능 차이 회신 후 명칭 확정 · 2건 반영 ② 메뉴 명칭 다국어 리소스(EN · ID) 관리 여부 회신. 2건 반영 후 Completed 재처리'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '60' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 확인 : DO 목록 3페이지 → 상세 → 뒤로가기 3페이지 유지. PO 목록 3페이지(AJ-20261001-003) · 재고 목록 4페이지도 동일. 조치확인
- 참고 : 검색어 · 필터 조건의 유지 여부는 미확인. 24번 필터 적용 시 함께 유지되도록 요청
- Verified 전환'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan server produksi 2026-10-02 : daftar DO halaman 3 → detail → kembali tetap halaman 3. Daftar PO halaman 3 (AJ-20261001-003) · daftar stok halaman 4 juga sama. Perbaikan dikonfirmasi
- Catatan : apakah kata kunci · kondisi filter ikut dipertahankan saat kembali belum diperiksa. Mohon ikut dipertahankan saat filter isu 24 diterapkan
- Dialihkan ke Verified'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 확인 : DO 목록 3페이지 → 상세 → 뒤로가기 3페이지 유지. PO 목록 3페이지(AJ-20261001-003) · 재고 목록 4페이지도 동일. 조치확인
- 참고 : 검색어 · 필터 조건의 유지 여부는 미확인. 24번 필터 적용 시 함께 유지되도록 요청
- Verified 전환'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '71' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';
UPDATE public.csr_issues SET
  business_answer_md_ko = '[2026-10-02]
- 2026-10-02 실서버 확인 : 글꼴은 전 화면 Noto Sans(Google Fonts 웹폰트) 적용 확인. 글자 크기는 PO 상세 기준 9종 혼재(11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px)로 font-size 일괄 적용은 미흡. 부분조치
- 요청 : 글자 크기 단계를 3~4종(예 : 제목 16px · 본문 14px · 표 13px · 라벨 12px)으로 정의해 회신, 적용 후 Completed 재처리. 웹폰트 외부 참조는 26번 참고(자사 도메인 포함 검토)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answer_md_id = '[2026-10-02]
- Pemeriksaan server produksi 2026-10-02 : font Noto Sans (web font Google Fonts) dikonfirmasi di seluruh layar. Ukuran huruf pada detail PO bercampur 9 jenis (11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px) sehingga penyeragaman font-size belum memadai. Sebagian diterapkan
- Permintaan : tentukan tingkat ukuran huruf menjadi 3~4 jenis (contoh : judul 16px · isi 14px · tabel 13px · label 12px) dan balas, Completed diproses ulang setelah diterapkan. Referensi web font eksternal lihat isu 26 (pertimbangkan menyertakan di domain sendiri)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_id, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_id, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[Jawaban sebelumnya ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_id, business_answer_md) END,
  business_answer_md = '[2026-10-02]
- 2026-10-02 실서버 확인 : 글꼴은 전 화면 Noto Sans(Google Fonts 웹폰트) 적용 확인. 글자 크기는 PO 상세 기준 9종 혼재(11.2 · 11.52 · 12 · 13.12 · 13.76 · 14 · 14.4 · 15.2 · 16px)로 font-size 일괄 적용은 미흡. 부분조치
- 요청 : 글자 크기 단계를 3~4종(예 : 제목 16px · 본문 14px · 표 13px · 라벨 12px)으로 정의해 회신, 적용 후 Completed 재처리. 웹폰트 외부 참조는 26번 참고(자사 도메인 포함 검토)'
    || CASE WHEN NULLIF(btrim(COALESCE(business_answer_md_ko, business_answer_md, '')), '') IS NULL
              OR btrim(COALESCE(business_answer_md_ko, business_answer_md)) = '- —' THEN ''
            ELSE E'\n\n[이전 답변 ' || COALESCE(business_answered_on::text, '') || E']\n' || COALESCE(business_answer_md_ko, business_answer_md) END,
  business_answered_on = DATE '2026-10-02'
WHERE issue_no = '74' AND NOT is_archived
  AND COALESCE(business_answer_md_ko, '') NOT LIKE '[2026-10-02]%';

-- ── 2. 검증 이력 2026-10-02 신규 8행 ─────────────────────────────────────────
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', '1,366px 재확인 : 견적 신규 QUOTE DATE 잘림 해소. SO 목록 QTY 한 자리씩 줄바꿈 · AMOUNT 3줄 · STATUS/DELIV 배지 겹침 · 헤더 분절, Receipt 상세 헤더 입력값 잘림(RCP1 · 2( · ARI), PO 목록 배지 넘침 7건, 기준열 고정 없음', '1,366px 재확인 : 견적 신규 QUOTE DATE 잘림 해소. SO 목록 QTY 한 자리씩 줄바꿈 · AMOUNT 3줄 · STATUS/DELIV 배지 겹침 · 헤더 분절, Receipt 상세 헤더 입력값 잘림(RCP1 · 2( · ARI), PO 목록 배지 넘침 7건, 기준열 고정 없음', 'Pemeriksaan ulang 1,366px : pemotongan QUOTE DATE pada Quotation baru teratasi. Daftar SO : QTY terpotong per digit · AMOUNT 3 baris · badge STATUS/DELIV tumpang tindih · header terpenggal, nilai header detail Receipt terpotong (RCP1 · 2( · ARI), badge daftar PO meluap 7 baris, kolom acuan belum terkunci', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '23' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', '전표 목록 15건 고정(API limit=15) · 재고 10건 고정. 페이지 크기 선택 · 헤더 정렬(클릭 무반응) · 기간 필터 없음. 09-08과 동일(10 → 15건만 변경)', '전표 목록 15건 고정(API limit=15) · 재고 10건 고정. 페이지 크기 선택 · 헤더 정렬(클릭 무반응) · 기간 필터 없음. 09-08과 동일(10 → 15건만 변경)', 'Daftar dokumen tetap 15 baris (API limit=15) · stok 10 baris. Tanpa pilihan ukuran halaman · pengurutan header (klik tidak bereaksi) · filter periode. Sama dengan 09-08 (hanya 10 → 15 baris)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '24' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', '견적 신규에서 저장 요청 차단 후 Save 클릭 : 검정 토스트 「Check Quote Title」 1건만, 필드 강조 · 포커스 이동 없음, required 속성 없음. 전표 미생성', '견적 신규에서 저장 요청 차단 후 Save 클릭 : 검정 토스트 「Check Quote Title」 1건만, 필드 강조 · 포커스 이동 없음, required 속성 없음. 전표 미생성', 'Save diklik pada Quotation baru dengan permintaan simpan diblokir : hanya satu toast hitam 「Check Quote Title」, tanpa penekanan field · perpindahan fokus, tanpa atribut required. Dokumen tidak dibuat', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '25' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'ACCEPTED', 'PO 목록 로딩 134건 요청 404 없음, ascendo-asm.com 참조 없음, /api/avatar 200. 74번으로 Google Fonts 외부 참조 추가됨(참고)', 'PO 목록 로딩 134건 요청 404 없음, ascendo-asm.com 참조 없음, /api/avatar 200. 74번으로 Google Fonts 외부 참조 추가됨(참고)', '134 permintaan saat memuat daftar PO tanpa 404, tanpa referensi ascendo-asm.com, /api/avatar 200. Referensi eksternal Google Fonts bertambah karena isu 74 (catatan)', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '26' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', 'Customs 상세 열 제목 PPN 11(%) · PPH 7.5(%) 고정, BM(%)만 제품 마스터 HS CODE BM(%) 행별 적용(4011.80.40 → 5%). 세율 마스터 · 적용 기간 · 승인 · 이력 없음. IT 09-26 조치현황 누락', 'Customs 상세 열 제목 PPN 11(%) · PPH 7.5(%) 고정, BM(%)만 제품 마스터 HS CODE BM(%) 행별 적용(4011.80.40 → 5%). 세율 마스터 · 적용 기간 · 승인 · 이력 없음. IT 09-26 조치현황 누락', 'Judul kolom detail Customs PPN 11(%) · PPH 7.5(%) tetap, hanya BM(%) per baris dari HS CODE BM(%) master produk (4011.80.40 → 5%). Tanpa master tarif · periode berlaku · persetujuan · riwayat. Tidak tercantum pada laporan IT 09-26', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '57' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'PARTIAL', '견적 상세 APPROVED BY 1인 표기(읽기전용)만 있음. 금액 구간별 결재선 자동 지정 · 결재 전 CONFIRMED 차단 · 결재 이력 조회 없음, 결재 라우트 없음. IT 09-26 조치현황 누락', '견적 상세 APPROVED BY 1인 표기(읽기전용)만 있음. 금액 구간별 결재선 자동 지정 · 결재 전 CONFIRMED 차단 · 결재 이력 조회 없음, 결재 라우트 없음. IT 09-26 조치현황 누락', 'Detail Quotation hanya menampilkan APPROVED BY 1 orang (read-only). Tanpa jalur persetujuan otomatis per rentang nilai · pemblokiran CONFIRMED sebelum persetujuan · riwayat persetujuan, tanpa route persetujuan. Tidak tercantum pada laporan IT 09-26', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '58' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'NOT APPLIED', 'Purchase 메뉴 9개에 대금지급 화면 없음, 관련 라우트 없음. IT 09-26 조치현황은 Open 표기만, 수용 여부 · 일정 미기재', 'Purchase 메뉴 9개에 대금지급 화면 없음, 관련 라우트 없음. IT 09-26 조치현황은 Open 표기만, 수용 여부 · 일정 미기재', '9 menu Purchase tanpa layar pembayaran, tanpa route terkait. Laporan IT 09-26 hanya mencantumkan Open tanpa penerimaan · jadwal', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '59' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, it_status_at, created_by)
SELECT i.id, DATE '2026-10-02', 'PARTIAL', '09-09 제안 13건 중 11건 반영, 미반영 2건 : PURCHASE PO → Purchase Order, RECEIPT → Purchase Receipt. 유지 12건 그대로. 다국어 리소스 관리 여부 미확인', '09-09 제안 13건 중 11건 반영, 미반영 2건 : PURCHASE PO → Purchase Order, RECEIPT → Purchase Receipt. 유지 12건 그대로. 다국어 리소스 관리 여부 미확인', '11 dari 13 usulan 09-09 diterapkan, belum 2 item : PURCHASE PO → Purchase Order, RECEIPT → Purchase Receipt. 12 item yang dipertahankan tetap. Pengelolaan resource multibahasa belum dapat dipastikan', i.it_status, 'seo-server-check-261002'
  FROM public.csr_issues i
 WHERE i.issue_no = '60' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002');

-- ── 2-1. 038 등록분 내용 보강 (22 · 71) ─────────────────────────────────────
UPDATE public.csr_verifications v SET
  note    = COALESCE(v.note, '') || ' SO 품목 단가 입력란 228.829 · Customs 상세 18.688.000,00 / FOB 377,41 · Shipment 상세 19.247,91 · Receipt 상세 24.536,8 · 환율 17707(구분 없음). Import Cost 상세만 영미식',
  note_ko = COALESCE(v.note_ko, v.note, '') || ' SO 품목 단가 입력란 228.829 · Customs 상세 18.688.000,00 / FOB 377,41 · Shipment 상세 19.247,91 · Receipt 상세 24.536,8 · 환율 17707(구분 없음). Import Cost 상세만 영미식',
  note_id = COALESCE(v.note_id, '') || ' Kolom input harga satuan SO 228.829 · detail Customs 18.688.000,00 / FOB 377,41 · detail Shipment 19.247,91 · detail Receipt 24.536,8 · kurs 17707 (tanpa pemisah). Hanya detail Import Cost berformat internasional'
  FROM public.csr_issues i
 WHERE i.id = v.issue_id AND i.issue_no = '22' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002'
   AND COALESCE(v.note_ko, v.note, '') NOT LIKE '%228.829%';
UPDATE public.csr_verifications v SET
  note    = COALESCE(v.note, '') || ' PO 목록 3페이지(AJ-20261001-003) · 재고 목록 4페이지도 유지 확인',
  note_ko = COALESCE(v.note_ko, v.note, '') || ' PO 목록 3페이지(AJ-20261001-003) · 재고 목록 4페이지도 유지 확인',
  note_id = COALESCE(v.note_id, '') || ' Daftar PO halaman 3 (AJ-20261001-003) · daftar stok halaman 4 juga tetap dipertahankan'
  FROM public.csr_issues i
 WHERE i.id = v.issue_id AND i.issue_no = '71' AND NOT i.is_archived
   AND v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002'
   AND COALESCE(v.note_ko, v.note, '') NOT LIKE '%AJ-20261001-003%';

-- ── 3. 71 Verified 전환 (현업) ───────────────────────────────────────────────
UPDATE public.csr_issues SET it_status = 'Verified'
 WHERE issue_no = '71' AND NOT is_archived AND it_status = 'Completed';

-- ── 확인 ─────────────────────────────────────────────────────────────────────
-- ① 12건 답변일 · 현업검증 · 최종검증일 (기대 : 답변일 전건 2026-10-02, 최종검증일 전건 2026-10-02, 71 Verified)
SELECT issue_no, it_status, verification_result, verified_on, business_answered_on,
       left(business_answer_md_ko, 14) AS ko_head, left(business_answer_md_id, 14) AS id_head
  FROM public.csr_issues WHERE it_pic = 'SEO' AND NOT is_archived ORDER BY issue_no;
-- ② 2026-10-02 검증 이력 (기대 : SEO 12건 각 1행, 전체 26행)
SELECT i.issue_no, v.result, v.it_status_at, left(v.note_ko, 40) AS note
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE v.verified_on = DATE '2026-10-02' AND v.created_by = 'seo-server-check-261002' ORDER BY i.issue_no;
