-- =============================================================================
-- ASM CSR — 화면경로(path_menu) 한글 문구 → 영어 (2026-09-10 요청)  · v3
--
-- ── 선행 조건: db/011 ──────────────────────────────────────────────────────
-- v1·v2·v3 가 편집기에서 모두 "UPDATE 만 ERROR" 였던 진짜 원인은 006 의 컬럼 가드였습니다 —
-- 콘솔 세션은 JWT 가 없어 csr_role() 이 NULL 이 되고 가드가 42501 을 던집니다($ 파싱 문제가
-- 아니었습니다). **011_guard_console_bypass.sql 을 먼저 실행**한 뒤 이 파일을 돌리십시오.
-- 문장마다 따로 실행해도 되고, 두 번 실행해도 결과는 같습니다.
--
-- ── 왜 바꾸는가 ────────────────────────────────────────────────────────────
-- 실제 ASM(https://asm.ascendotyre.com/)은 메뉴·버튼이 전부 영어인데 Notion 이관값은
-- "Sales > SO > 신규 (창고 선택)" 처럼 한글이 섞여 있었습니다. 화면경로는 언어 토글을 타지 않는
-- 값(메뉴 이름 그 자체)이라 저장값을 사이트 용어로 맞춥니다. 작업지시서 §8 의 정규화 금지는
-- 옵션값("조치확인 / Terkonfirmasi") 대상이고, 화면경로는 자유 텍스트입니다.
--
-- 치환은 긴 토큰부터(안쪽 replace 가 먼저 실행됩니다) — '신규·상세'→'New·Detail' 이 '신규'→'New'
-- 보다 먼저. 원문은 import/out/path_menu_backup_20260910.json(로컬) 과 아래 백업 테이블에.
-- =============================================================================

-- 1) 원문 보관(있으면 건너뜀).
CREATE TABLE IF NOT EXISTS public.csr_path_menu_backup (
  issue_id   bigint PRIMARY KEY,
  path_menu  text,
  saved_at   timestamptz NOT NULL DEFAULT now()
);
INSERT INTO public.csr_path_menu_backup (issue_id, path_menu)
SELECT id, path_menu FROM public.csr_issues WHERE path_menu ~ '[가-힣]'
ON CONFLICT (issue_id) DO NOTHING;

-- 2) 치환 — 한 문장. (43 쌍)
UPDATE public.csr_issues
   SET path_menu = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(path_menu,
    'Purchasing > Payment Plan 신설 — PO 연결, 지급조건 · 예정일 · 실제 지급일 · 환율 · 잔액, PPC → 지급 → Shipment 상태 연동, 월별 지급 예정 · 미지급 리포트', 'Purchasing > Payment Plan (new menu)'),
    '전 화면 (금액 · 수량 · 단가 표기)', 'All screens (amount · qty · unit price format)'),
    '전 화면 (목록 · 상세 레이아웃)', 'All screens (list · detail layout)'),
    '전 입력 화면 (저장 시 검증)', 'All input screens (validation on save)'),
    '전 화면 날짜 입력란', 'All screens date input'),
    '전 목록 화면', 'All list screens'),
    '전 화면', 'All screens'),
    '로그인 화면', 'Login screen'),
    '메뉴 트리', 'Menu tree'),
    '신규·상세 (재고 연동)', 'New·Detail (stock link)'),
    '신규·상세', 'New·Detail'),
    '목록·상세', 'List·Detail'),
    '신규 (창고 선택)', 'New (warehouse selection)'),
    '신규 (단가 입력)', 'New (unit price input)'),
    '신규 (품목 입력)', 'New (item input)'),
    '신규 (품목 행)', 'New (item row)'),
    '신규 (합계 블록)', 'New (total block)'),
    '신규 (배송지', 'New (shipping address'),
    '신규(LOCAL) 공급사 드롭다운', 'New (LOCAL) supplier dropdown'),
    '신규(LOCAL)', 'New (LOCAL)'),
    '신규(IMPORT · LOCAL)', 'New (IMPORT · LOCAL)'),
    '승인 팝업', 'Approval popup'),
    '출력(GRPO)', 'Print (GRPO)'),
    '(신설 요청)', '(new menu request)'),
    '(신설)', '(new menu)'),
    '(메뉴 권한)', '(menu permission)'),
    '(Confirm 권한)', '(Confirm permission)'),
    '등 목록', 'etc. list'),
    'ACTUAL 탭', 'ACTUAL tab'),
    'ESTIMATED 탭', 'ESTIMATED tab'),
    '명칭 변경 확인', 'name change check'),
    'Est. Delivery Date 정렬', 'Est. Delivery Date sort'),
    'PO Date · Delivery Date 변경', 'PO Date · Delivery Date change'),
    'Delivery Note 운송 정보', 'Delivery Note shipping info'),
    '직원 마스터 DEPARTMENT', 'staff master DEPARTMENT'),
    'GRPO 출력물', 'GRPO printout'),
    '신규', 'New'),
    '상세', 'Detail'),
    '목록', 'List'),
    '승인', 'Approve'),
    '확정', 'Confirm'),
    '출력', 'Print'),
    '신설', 'new menu')
 WHERE path_menu ~ '[가-힣]';

-- 3) 확인 — 0행이어야 합니다.
SELECT issue_no, path_menu FROM public.csr_issues WHERE path_menu ~ '[가-힣]' ORDER BY issue_no;

-- 4) 표본.
SELECT issue_no, path_menu FROM public.csr_issues
 WHERE issue_no IN ('01','02','05','07','24','29','52','59','60') AND NOT is_archived ORDER BY issue_no;

-- ─── (선택) 메뉴 이름을 실제 사이트와 맞추기 — 원하면 주석을 풀고 따로 실행 ─────────────
-- UPDATE public.csr_issues SET path_menu = replace(path_menu, 'Purchasing > PO >', 'Purchase > Purchase PO >')
--  WHERE path_menu LIKE '%Purchasing > PO >%';
-- UPDATE public.csr_issues SET path_menu = replace(path_menu, 'Purchasing > ', 'Purchase > ')
--  WHERE path_menu LIKE '%Purchasing > %';
