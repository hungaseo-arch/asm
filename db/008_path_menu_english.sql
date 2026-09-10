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
-- 화면경로는 자유 텍스트라 여기서 고칩니다. 원문은 csr_path_menu_backup 에 남깁니다.
--
-- ── 방법 ────────────────────────────────────────────────────────────────────
-- v1 은 TEMP TABLE + pg_temp 함수 + BEGIN/COMMIT 이었는데 Neon SQL Editor 에서 돌려도 데이터가
-- 그대로였습니다(2026-09-10 실측 — 문장별 실행이라 임시 객체가 사라지거나 중간 오류로 롤백).
-- 그래서 **DO 블록 하나**에 표를 넣어 한 문장으로 끝냅니다. 임시 객체·트랜잭션 의존 없음.
--
-- 토큰은 긴 것부터 차례로 replace 합니다. '신규·상세' 를 '신규' 보다 먼저 바꿔야 'New·Detail'
-- 이 되고, 뒤집히면 'New·상세' 가 됩니다 — 배열 순서가 그 순서입니다.
-- =============================================================================

-- 1) 원문 보관(있으면 건너뜀) — 되돌릴 일이 생기면 여기서 복원합니다.
CREATE TABLE IF NOT EXISTS public.csr_path_menu_backup (
  issue_id   bigint PRIMARY KEY,
  path_menu  text,
  saved_at   timestamptz NOT NULL DEFAULT now()
);
INSERT INTO public.csr_path_menu_backup (issue_id, path_menu)
SELECT id, path_menu FROM public.csr_issues
 WHERE path_menu ~ '[가-힣]'
ON CONFLICT (issue_id) DO NOTHING;

-- 2) 치환 — 한 문장. 끝나면 NOTICE 로 바뀐 행 수를 알립니다.
DO $do$
DECLARE
  -- ko → en 쌍. 홀수 = 한글, 짝수 = 영어. 긴 것부터.
  m text[] := ARRAY[
    -- 값 하나가 통째로 설명문인 건(59 Payment Plan) — 경로만 남깁니다. 설명은 findings_md 에 있습니다.
    'Purchasing > Payment Plan 신설 — PO 연결, 지급조건 · 예정일 · 실제 지급일 · 환율 · 잔액, PPC → 지급 → Shipment 상태 연동, 월별 지급 예정 · 미지급 리포트',
      'Purchasing > Payment Plan (new menu)',
    -- 화면 범위 표현(특정 메뉴가 아닌 것)
    '전 화면 (금액 · 수량 · 단가 표기)', 'All screens (amount · qty · unit price format)',
    '전 화면 (목록 · 상세 레이아웃)',   'All screens (list · detail layout)',
    '전 입력 화면 (저장 시 검증)',       'All input screens (validation on save)',
    '전 화면 날짜 입력란',               'All screens date input',
    '전 목록 화면',                      'All list screens',
    '전 화면',                           'All screens',
    '로그인 화면',                       'Login screen',
    '메뉴 트리',                         'Menu tree',
    -- 복합 토큰
    '신규·상세 (재고 연동)',      'New·Detail (stock link)',
    '신규·상세',                  'New·Detail',
    '목록·상세',                  'List·Detail',
    '신규 (창고 선택)',           'New (warehouse selection)',
    '신규 (단가 입력)',           'New (unit price input)',
    '신규 (품목 입력)',           'New (item input)',
    '신규 (품목 행)',             'New (item row)',
    '신규 (합계 블록)',           'New (total block)',
    '신규 (배송지',               'New (shipping address',
    '신규(LOCAL) 공급사 드롭다운', 'New (LOCAL) supplier dropdown',
    '신규(LOCAL)',                'New (LOCAL)',
    '신규(IMPORT · LOCAL)',       'New (IMPORT · LOCAL)',
    '승인 팝업',                  'Approval popup',
    '출력(GRPO)',                 'Print (GRPO)',
    '(신설 요청)',                '(new menu request)',
    '(신설)',                     '(new menu)',
    '(메뉴 권한)',                '(menu permission)',
    '(Confirm 권한)',             '(Confirm permission)',
    '등 목록',                    'etc. list',
    'ACTUAL 탭',                  'ACTUAL tab',
    'ESTIMATED 탭',               'ESTIMATED tab',
    '명칭 변경 확인',             'name change check',
    'Est. Delivery Date 정렬',    'Est. Delivery Date sort',
    'PO Date · Delivery Date 변경', 'PO Date · Delivery Date change',
    'Delivery Note 운송 정보',    'Delivery Note shipping info',
    '직원 마스터 DEPARTMENT',     'staff master DEPARTMENT',
    'GRPO 출력물',                'GRPO printout',
    -- 단일 토큰
    '신규', 'New',
    '상세', 'Detail',
    '목록', 'List',
    '승인', 'Approve',
    '확정', 'Confirm',
    '출력', 'Print',
    '신설', 'new menu'
  ];
  r record;
  v text;
  i int;
  n int := 0;
BEGIN
  FOR r IN SELECT id, path_menu FROM public.csr_issues WHERE path_menu ~ '[가-힣]' LOOP
    v := r.path_menu;
    i := 1;
    WHILE i < array_length(m, 1) LOOP
      v := replace(v, m[i], m[i + 1]);
      i := i + 2;
    END LOOP;
    IF v IS DISTINCT FROM r.path_menu THEN
      UPDATE public.csr_issues SET path_menu = v WHERE id = r.id;
      n := n + 1;
    END IF;
  END LOOP;
  RAISE NOTICE 'path_menu 치환: % 행', n;
END;
$do$;

-- 3) 확인 — 남은 한글은 0행이어야 합니다. 남으면 위 배열에 토큰을 추가해 다시 실행합니다.
SELECT issue_no, path_menu FROM public.csr_issues WHERE path_menu ~ '[가-힣]' ORDER BY issue_no;

-- 4) 표본 — 바뀐 모습 확인.
SELECT issue_no, path_menu FROM public.csr_issues
 WHERE issue_no IN ('01','02','05','07','24','29','52','59') ORDER BY issue_no;

-- ─── (선택) 메뉴 이름을 실제 사이트와 맞추기 ─────────────────────────────────
-- 실제 사이트의 대메뉴는 "Purchase", 하위는 "Purchase PO" 입니다(Notion 은 "Purchasing > PO").
-- 이것까지 맞추려면 아래 두 UPDATE 의 주석을 풀고 따로 실행하십시오. menu_main 옵션값("Purchasing")은
-- 작업지시서 §8 대상이라 건드리지 않습니다 — path_menu 만 바꿉니다.
-- UPDATE public.csr_issues SET path_menu = replace(path_menu, 'Purchasing > PO >', 'Purchase > Purchase PO >')
--  WHERE path_menu LIKE '%Purchasing > PO >%';
-- UPDATE public.csr_issues SET path_menu = replace(path_menu, 'Purchasing > ', 'Purchase > ')
--  WHERE path_menu LIKE '%Purchasing > %';
