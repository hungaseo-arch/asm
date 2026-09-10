-- =============================================================================
-- [CSR-1.1-D] 데이터 정정 — 2026-09-10 실서버 검증 결과 반영
--   015 · 016 · 017 적용 후 실행. 달러 인용 없음. 재실행 안전(같은 값 덮어씀).
--
--   헤더 값을 바꿉니다. 017 의 원칙(헤더 = 최신 이력)이 깨지지 않도록 최신 이력 행의 결과도
--   같이 맞춥니다 — 08 은 2026-09-10 이력(id 256, 종전 「미검증」)이 정정 근거이므로 REJECTED 로.
--   나머지 8건은 최신 이력이 이미 정정 값과 같습니다(09 PARTIAL · 22 PARTIAL · 23 NOT APPLIED ·
--   13 REJECTED · 27/28/30 ACCEPTED · 60 PARTIAL).
-- =============================================================================

-- 변경자 표기(상태 로그 changed_by). 에디터가 세션을 유지하지 않으면 NULL 로 남습니다 — 무해.
SELECT set_config('csr.actor', 'migration:018 (2026-09-10 검증 정정)', false);

-- 현업검증 · 최종검증일
UPDATE public.csr_issues SET verification_result = 'REJECTED',    verified_on = DATE '2026-09-10' WHERE issue_no = '08' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'PARTIAL',     verified_on = DATE '2026-09-10' WHERE issue_no = '09' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'PARTIAL',     verified_on = DATE '2026-09-10' WHERE issue_no = '22' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'REJECTED',    verified_on = DATE '2026-09-10' WHERE issue_no = '13' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'ACCEPTED',    verified_on = DATE '2026-09-10' WHERE issue_no = '27' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'ACCEPTED',    verified_on = DATE '2026-09-10' WHERE issue_no = '28' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'ACCEPTED',    verified_on = DATE '2026-09-10' WHERE issue_no = '30' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'NOT APPLIED', verified_on = DATE '2026-09-10' WHERE issue_no = '23' AND NOT is_archived;
UPDATE public.csr_issues SET verification_result = 'PARTIAL',     verified_on = DATE '2026-09-10' WHERE issue_no = '60' AND NOT is_archived;

-- 08 의 2026-09-10 이력(근거: Import Cost 1건, SKU 열·탭 부재) 결과를 헤더와 맞춤
UPDATE public.csr_verifications SET result = 'REJECTED'
 WHERE issue_id = (SELECT id FROM public.csr_issues WHERE issue_no = '08' AND NOT is_archived)
   AND verified_on = DATE '2026-09-10';

-- 60 의 2026-09-10 이력 본문 교체 (원문 ID · 한국어는 Claude 번역 — 검수 서종환)
UPDATE public.csr_verifications
   SET note    = 'Pengecekan server produksi: grup menu atas sudah "Purchase" (bukan Purchasing), submenu PURCHASE PO dan Sales > CUSTOMER PO sudah diterapkan. 13 usulan proposal 2026-09-09 (Purchase Order · Production Planning · Import Shipment · Customs Clearance · Warehouse Receipt · Purchase Receipt · Supplier Return · Sales Order · Warehouse Delivery · Monthly Inventory Closing · Monthly Closing Data · Upload Closing Data · Staff Directory) belum diterapkan; label saat ini masih PPC · RECEIPT(WH) · RECEIPT · VENDOR RETURN · SO · DELIVERY NOTE(WH). Balasan tim IT atas proposal 09-09 belum diterima.',
       note_id = 'Pengecekan server produksi: grup menu atas sudah "Purchase" (bukan Purchasing), submenu PURCHASE PO dan Sales > CUSTOMER PO sudah diterapkan. 13 usulan proposal 2026-09-09 (Purchase Order · Production Planning · Import Shipment · Customs Clearance · Warehouse Receipt · Purchase Receipt · Supplier Return · Sales Order · Warehouse Delivery · Monthly Inventory Closing · Monthly Closing Data · Upload Closing Data · Staff Directory) belum diterapkan; label saat ini masih PPC · RECEIPT(WH) · RECEIPT · VENDOR RETURN · SO · DELIVERY NOTE(WH). Balasan tim IT atas proposal 09-09 belum diterima.',
       note_ko = '실서버 확인: 상단 메뉴 그룹은 "Purchase"(Purchasing 아님), 하위 메뉴 PURCHASE PO 와 Sales > CUSTOMER PO 는 적용됨. 2026-09-09 제안 13건(Purchase Order · Production Planning · Import Shipment · Customs Clearance · Warehouse Receipt · Purchase Receipt · Supplier Return · Sales Order · Warehouse Delivery · Monthly Inventory Closing · Monthly Closing Data · Upload Closing Data · Staff Directory)은 미적용; 현재 라벨은 여전히 PPC · RECEIPT(WH) · RECEIPT · VENDOR RETURN · SO · DELIVERY NOTE(WH). 09-09 제안에 대한 IT부서 회신 미접수.'
 WHERE issue_id = (SELECT id FROM public.csr_issues WHERE issue_no = '60' AND NOT is_archived)
   AND verified_on = DATE '2026-09-10';

-- 02 담당자 「Import」 — 노션 원본도 'Import'(사람 이름 아님) → 공란 처리
UPDATE public.csr_issues SET it_pic = NULL WHERE issue_no = '02' AND NOT is_archived AND it_pic = 'Import';

-- 확인
SELECT issue_no, it_status, verification_result, verified_on, it_pic
  FROM public.csr_issues
 WHERE issue_no IN ('02', '08', '09', '13', '22', '23', '27', '28', '30', '60') AND NOT is_archived
 ORDER BY issue_no;
SELECT v.id, i.issue_no, v.verified_on, v.result, left(v.note, 60) AS note
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id
 WHERE i.issue_no IN ('08', '60') AND v.verified_on = DATE '2026-09-10'
 ORDER BY i.issue_no;
