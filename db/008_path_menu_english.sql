-- =============================================================================
-- ASM CSR — 화면경로(path_menu) 한글 문구 → 영어 (2026-09-10 요청)
--   001~007 적용 후 언제든 실행 가능. 두 번 실행해도 결과는 같습니다(치환할 한글이 없으면 무변화).
--
-- ── 왜 ──────────────────────────────────────────────────────────────────────
-- 실제 ASM(https://asm.ascendotyre.com/)은 메뉴·버튼이 전부 영어인데, Notion 에서 옮겨 온
-- 화면경로는 "Sales > SO > 신규 (창고 선택)" 처럼 한글이 섞여 있었습니다. 화면경로는 언어
-- 토글을 타지 않고 그대로 보여 주는 값이라(메뉴 이름 그 자체) 저장값을 사이트 용어로 맞춥니다.
--
-- 작업지시서 §8 의 "정규화 금지" 는 옵션값("조치확인 / Terkonfirmasi")에 대한 것이고,
-- 화면경로는 자유 텍스트라 여기서 고칩니다. 원문은 아래 csr_path_menu_backup 에 남깁니다.
--
-- ── 방법 ────────────────────────────────────────────────────────────────────
-- 토큰 표(ko → en)를 긴 것부터 차례로 replace 합니다. '신규·상세' 를 '신규' 보다 먼저 바꿔야
-- 'New·Detail' 이 되고, 순서가 뒤집히면 'New·상세' 가 됩니다 — ord 열이 그 순서입니다.
-- =============================================================================

BEGIN;

-- 원문 보관(있으면 건너뜀) — 되돌릴 일이 생기면 여기서 복원합니다.
CREATE TABLE IF NOT EXISTS public.csr_path_menu_backup (
  issue_id   bigint PRIMARY KEY,
  path_menu  text,
  saved_at   timestamptz NOT NULL DEFAULT now()
);
INSERT INTO public.csr_path_menu_backup (issue_id, path_menu)
SELECT id, path_menu FROM public.csr_issues
 WHERE path_menu ~ '[가-힣]'
ON CONFLICT (issue_id) DO NOTHING;

CREATE TEMP TABLE csr_path_map (ord int, ko text, en text) ON COMMIT DROP;
INSERT INTO csr_path_map (ord, ko, en) VALUES
  -- 값 하나가 통째로 설명문인 건(Payment Plan 신설 요청) — 경로만 남깁니다. 설명은 findings_md 에 이미 있습니다.
  ( 1, 'Purchasing > Payment Plan 신설 — PO 연결, 지급조건 · 예정일 · 실제 지급일 · 환율 · 잔액, PPC → 지급 → Shipment 상태 연동, 월별 지급 예정 · 미지급 리포트',
       'Purchasing > Payment Plan (new menu)'),
  -- 복합 토큰 먼저
  (10, '신규·상세 (재고 연동)', 'New·Detail (stock link)'),
  (11, '신규·상세',            'New·Detail'),
  (12, '목록·상세',            'List·Detail'),
  (13, '신규 (창고 선택)',      'New (warehouse selection)'),
  (14, '신규 (단가 입력)',      'New (unit price input)'),
  (15, '신규 (품목 입력)',      'New (item input)'),
  (16, '신규 (품목 행)',        'New (item row)'),
  (17, '신규 (합계 블록)',      'New (total block)'),
  (18, '신규 (배송지',          'New (shipping address'),
  (19, '신규(LOCAL) 공급사 드롭다운', 'New (LOCAL) supplier dropdown'),
  (20, '신규(LOCAL)',           'New (LOCAL)'),
  (21, '신규(IMPORT · LOCAL)',  'New (IMPORT · LOCAL)'),
  (22, '승인 팝업',             'Approval popup'),
  (23, '출력(GRPO)',            'Print (GRPO)'),
  (24, '(신설 요청)',           '(new menu request)'),
  (25, '(신설)',                '(new menu)'),
  (26, '(메뉴 권한)',           '(menu permission)'),
  (27, '(Confirm 권한)',        '(Confirm permission)'),
  (28, '(COUNTRY)',             '(COUNTRY)'),
  (29, '등 목록',               'etc. list'),
  (30, 'ACTUAL 탭',             'ACTUAL tab'),
  (31, 'ESTIMATED 탭',          'ESTIMATED tab'),
  (32, '명칭 변경 확인',        'name change check'),
  (33, 'Est. Delivery Date 정렬', 'Est. Delivery Date sort'),
  (34, 'PO Date · Delivery Date 변경', 'PO Date · Delivery Date change'),
  (35, 'Delivery Note 운송 정보', 'Delivery Note shipping info'),
  (36, '직원 마스터 DEPARTMENT', 'staff master DEPARTMENT'),
  (37, '전 화면 날짜 입력란',   'All screens date input'),
  (38, 'GRPO 출력물',           'GRPO printout'),
  -- 단일 토큰
  (50, '신규', 'New'),
  (51, '상세', 'Detail'),
  (52, '목록', 'List'),
  (53, '승인', 'Approve'),
  (54, '확정', 'Confirm'),
  (55, '출력', 'Print'),
  (56, '신설', 'new menu');

-- 치환 함수(임시) — 표를 ord 순으로 훑으며 replace.
CREATE OR REPLACE FUNCTION pg_temp.csr_path_en(src text) RETURNS text
LANGUAGE plpgsql AS $fn$
DECLARE r record; out text := src;
BEGIN
  IF src IS NULL THEN RETURN NULL; END IF;
  FOR r IN SELECT ko, en FROM csr_path_map ORDER BY ord LOOP
    out := replace(out, r.ko, r.en);
  END LOOP;
  RETURN out;
END;
$fn$;

-- 미리보기 — 바뀌는 행만. 이 결과가 마음에 안 들면 COMMIT 대신 ROLLBACK 하십시오.
SELECT issue_no, path_menu AS before, pg_temp.csr_path_en(path_menu) AS after
  FROM public.csr_issues
 WHERE path_menu IS DISTINCT FROM pg_temp.csr_path_en(path_menu)
 ORDER BY issue_no;

UPDATE public.csr_issues
   SET path_menu = pg_temp.csr_path_en(path_menu)
 WHERE path_menu IS DISTINCT FROM pg_temp.csr_path_en(path_menu);

-- 남은 한글 — 0행이어야 합니다. 남으면 위 표에 토큰을 추가해 다시 실행합니다.
SELECT issue_no, path_menu FROM public.csr_issues WHERE path_menu ~ '[가-힣]' ORDER BY issue_no;

COMMIT;

-- ─── (선택) 메뉴 이름을 실제 사이트와 맞추기 ─────────────────────────────────
-- 실제 사이트의 대메뉴는 "Purchase", 하위는 "Purchase PO" 입니다(Notion 은 "Purchasing > PO").
-- 이것까지 맞추려면 아래 블록의 주석을 풀고 따로 실행하십시오. menu_main 옵션값("Purchasing")은
-- 작업지시서 §8 대상이라 건드리지 않습니다 — path_menu 만 바꿉니다.
-- BEGIN;
-- UPDATE public.csr_issues SET path_menu = replace(path_menu, 'Purchasing > PO >', 'Purchase > Purchase PO >')
--  WHERE path_menu LIKE '%Purchasing > PO >%';
-- UPDATE public.csr_issues SET path_menu = replace(path_menu, 'Purchasing > ', 'Purchase > ')
--  WHERE path_menu LIKE '%Purchasing > %';
-- SELECT issue_no, path_menu FROM public.csr_issues WHERE path_menu LIKE '%Purchase%' ORDER BY issue_no;
-- COMMIT;
