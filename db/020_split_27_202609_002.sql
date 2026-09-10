-- =============================================================================
-- [CSR-1.1-F] 27번 분리 — 신규 CSR-202609-002 「결제조건(Payment Term) 이력 보존」 (Asura 승인 2026-09-10)
--   015~019 적용 후 실행. 달러 인용 없음. 재실행 안전(이미 있으면 건너뜀).
--
--   1. CSR-202609-002 등록(채번 함수가 002 를 돌려줄 때만) + 검증 이력 1행(PENDING, 분리 사실)
--   2. 27 관련이슈에 CSR-202609-002 추가, 수용기준 후단 "마스터 변경 시 기존 전표 소급 없음" 삭제
--   3. 27 검증 이력에 분리 사실 기록(결과 ACCEPTED = 현재 헤더와 같아 헤더는 그대로)
--   한국어/인니어 번역은 Claude — 검수 서종환.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:020 (27번 분리)', false);

-- 1. 신규 이슈
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  is_archived, updated_by
)
SELECT
  'CSR-202609-002',
  '결제조건(Payment Term) 이력 보존 — 전표 생성 시점 값 저장',
  'Riwayat Termin Pembayaran (Payment Term) — Simpan Nilai Saat Dokumen Dibuat',
  'Purchasing', 'PO', 'Purchasing > PO > New → Purchasing > Receipt > Detail',
  '개선 / Perbaikan', 'S3 Minor',
  '오픈 後 / Setelah Go-Live', '총괄팀 / Tim Umum', DATE '2026-09-10',
  '전표(PO · Receipt) 생성 시점의 결제조건을 이력으로 저장해, 공급사 마스터의 PAYMENT TERM 변경이 기존 전표에 소급되지 않아야 함. 검증에는 테스트용 공급사 계정이 필요(실거래에 영향 없이 마스터 변경 가능).',
  'Termin pembayaran pada saat dokumen (PO · Receipt) dibuat harus disimpan sebagai riwayat sehingga perubahan PAYMENT TERM pada master supplier tidak berlaku surut ke dokumen lama. Verifikasi memerlukan akun supplier uji (master dapat diubah tanpa memengaruhi transaksi riil).',
  '테스트 공급사의 마스터 PAYMENT TERM 을 변경한 뒤에도 기존 PO 와 Receipt 의 PAYMENT TERM 값이 그대로 유지됨',
  'Setelah PAYMENT TERM master supplier uji diubah, nilai PAYMENT TERM pada PO dan Receipt yang sudah ada tetap tidak berubah',
  '27', '개발부서 / Tim Pengembang',
  'Open', '미회신 / Belum Ada Balasan', 'PENDING',
  'Termin pembayaran pada saat dokumen (PO · Receipt) dibuat harus disimpan sebagai riwayat sehingga perubahan PAYMENT TERM pada master supplier tidak berlaku surut ke dokumen lama. Verifikasi memerlukan akun supplier uji (master dapat diubah tanpa memengaruhi transaksi riil).',
  '전표(PO · Receipt) 생성 시점의 결제조건을 이력으로 저장해, 공급사 마스터의 PAYMENT TERM 변경이 기존 전표에 소급되지 않아야 함. 검증에는 테스트용 공급사 계정이 필요(실거래에 영향 없이 마스터 변경 가능).',
  'Termin pembayaran pada saat dokumen (PO · Receipt) dibuat harus disimpan sebagai riwayat sehingga perubahan PAYMENT TERM pada master supplier tidak berlaku surut ke dokumen lama. Verifikasi memerlukan akun supplier uji (master dapat diubah tanpa memengaruhi transaksi riil).',
  false, 'migration:020'
WHERE public.csr_next_issue_no() = 'CSR-202609-002'
  AND NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = 'CSR-202609-002');

INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-10', 'PENDING',
       'Dipisahkan dari CSR 27 (disetujui Asura, 2026-09-10). Pada sampel 27, pewarisan term PO → Receipt sudah terkonfirmasi; retensi histori term saat master supplier diubah belum diverifikasi — perlu akun supplier uji.',
       'CSR 27 에서 분리(Asura 승인 2026-09-10). 27 의 샘플에서 PO → Receipt 결제조건 전이는 확인됨; 공급사 마스터 변경 시 이력 보존은 미검증 — 테스트 공급사 계정 필요.',
       'Dipisahkan dari CSR 27 (disetujui Asura, 2026-09-10). Pada sampel 27, pewarisan term PO → Receipt sudah terkonfirmasi; retensi histori term saat master supplier diubah belum diverifikasi — perlu akun supplier uji.',
       'migration:020'
  FROM public.csr_issues i
 WHERE i.issue_no = 'CSR-202609-002'
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);

-- 2. 27 — 관련이슈 상호 참조 · 수용기준 후단 삭제
UPDATE public.csr_issues
   SET related_issues = CASE
         WHEN related_issues IS NULL OR related_issues = '' THEN 'CSR-202609-002'
         WHEN related_issues LIKE '%CSR-202609-002%' THEN related_issues
         ELSE related_issues || ' · CSR-202609-002'
       END,
       acceptance_ko = '발주에 등록한 PAYMENT TERM이 후속 입고 전표에 동일하게 전이됨',
       acceptance_id = 'PAYMENT TERM yang didaftarkan pada PO diwariskan sama ke dokumen penerimaan lanjutan'
 WHERE issue_no = '27' AND NOT is_archived;

-- 3. 27 검증 이력 — 분리 기록 (결과는 현재 헤더와 같은 ACCEPTED → 헤더 값 변화 없음)
INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, note_ko, note_id, created_by)
SELECT i.id, DATE '2026-09-10', 'ACCEPTED',
       '결제조건 이력 보존(마스터 변경 시 기존 전표 소급 없음) 요구는 CSR-202609-002 로 분리(Asura 승인 2026-09-10). 27 수용기준 후단 문구 삭제 — 27 은 VERIFIED 전환 가능.',
       '결제조건 이력 보존(마스터 변경 시 기존 전표 소급 없음) 요구는 CSR-202609-002 로 분리(Asura 승인 2026-09-10). 27 수용기준 후단 문구 삭제 — 27 은 VERIFIED 전환 가능.',
       'Kebutuhan retensi riwayat termin pembayaran (perubahan master tidak berlaku surut) dipisahkan menjadi CSR-202609-002 (disetujui Asura, 2026-09-10). Kalimat akhir kriteria selesai 27 dihapus — 27 dapat ditutup VERIFIED.',
       'migration:020'
  FROM public.csr_issues i
 WHERE i.issue_no = '27' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id AND v.note LIKE '%CSR-202609-002 로 분리%');

-- 확인 — 002 1행(PENDING · 09-10 · 이력 1) / 27 관련이슈 '37 · CSR-202609-002' · 수용기준 후단 없음 · ACCEPTED 유지 / next_no 003
SELECT issue_no, it_status, it_decision, verification_result, verified_on, related_issues, acceptance_ko,
       (SELECT count(*) FROM public.csr_verifications v WHERE v.issue_id = i.id) AS verif_rows
  FROM public.csr_issues i WHERE issue_no IN ('27', 'CSR-202609-002') AND NOT is_archived ORDER BY issue_no;
SELECT public.csr_next_issue_no() AS next_no;
