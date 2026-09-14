-- =============================================================================
-- 중복 정리 (2026-09-14 점검 결과) — 026 적용 후 실행. 달러 인용 없음. 재실행 안전.
--
--   점검: 활성 70건 전수 대조 — 행 중복(이슈번호 · 첨부 · 검증 이력 · 회신) 0건.
--   내용이 겹치는 3건만 정리합니다. **삭제 · 아카이브 · 병합은 하지 않습니다** — 01~60 은 노션이 원장이고
--   운영 규칙(2026-09-08)이 노션의 삭제 · 아카이브 · 병합을 금지하므로, 사이트만 지우면 원장과 어긋납니다.
--
--   1. 11 ↔ 48 (견적 SALES REP) — 같은 증상의 다른 관찰. 11 은 드롭다운 전건 0건(PAYMENT TERM ·
--      INV DUE LENGTH 포함), 48 은 Sales Rep 미지정 고객만. 11 의 관련이슈에 역할 분담을 적습니다.
--   2. 16 ↔ 62 · 66 (고객 마스터 여신) — 16 의 요구(여신한도 · 결제조건 필드)가 62 의 ⑥ · ⑨ 와 같고,
--      16 메모의 「Aging 리포트 포함」은 지금 66 이 맡습니다. 16 의 관련이슈를 실제 배치에 맞춥니다.
--   3. 63 ↔ 64~68 (Finance) — 63 의 범위가 하위 5종을 통째로 포함해 진척이 두 번 세어집니다.
--      63 은 「대메뉴 신설 · 메뉴 순서」로 좁히고 하위 5종은 64~68 에서 관리합니다(63 은 사이트 전용 신규 건).
-- =============================================================================

SELECT set_config('csr.actor', 'migration:027 (중복 정리)', false);

-- 1. 11 — 역할 분담 표기
UPDATE public.csr_issues
   SET related_issues = '16 · 48 (본 이슈는 PAYMENT TERM · INV DUE LENGTH 드롭다운 0건 — Sales Rep 미지정 고객 건은 48 에서 관리)'
 WHERE issue_no = '11' AND NOT is_archived;

-- 2. 16 — 항목 확장은 62, Aging 리포트는 66
UPDATE public.csr_issues
   SET related_issues = '11 · 35 · 62 · 66 (VIII-2 중복 삭제 → 본 이슈에서 관리 · 마스터 항목 확장은 62 · Aging 리포트는 66)'
 WHERE issue_no = '16' AND NOT is_archived;

-- 3. 63 — 범위 축소(대메뉴 · 메뉴 순서). 하위 5종은 64~68.
UPDATE public.csr_issues
   SET title_ko = '63. Finance 대메뉴 부재 — 대메뉴 신설 및 메뉴 순서 업무 흐름 정렬',
       title_id = '63. Menu Utama Finance Belum Ada — Penambahan Menu Utama dan Penataan Urutan Menu',
       summary_ko = 'Finance 대메뉴 부재 — 인보이스 · 수금 · AR · 자금 계획을 시스템에서 수행 불가, 판매 프로세스가 Delivery Note 에서 종료. 본 이슈는 대메뉴 신설과 메뉴 순서 정렬까지 — 하위 5종은 이슈 64~68 에서 개별 관리',
       summary_id = 'Menu utama Finance belum ada — penerbitan invoice · penerimaan · AR · rencana kas tidak dapat dilakukan di sistem, proses penjualan berhenti di Delivery Note. Isu ini mencakup penambahan menu utama dan penataan urutan menu; kelima submenu dikelola pada isu 64~68'
 WHERE issue_no = '63' AND NOT is_archived;

-- 확인
SELECT issue_no, left(title_ko, 46) AS title_ko, related_issues
  FROM public.csr_issues WHERE issue_no IN ('11', '16', '63') AND NOT is_archived ORDER BY issue_no;
