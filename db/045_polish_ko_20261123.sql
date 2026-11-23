-- =============================================================================
-- 한국어 본문 문체 윤문 14건 (2026-11-23 「DB 자료도 윤문」) — 001~044 적용 후 실행. 재실행 안전.
--   달러 인용($q$) 있음 — 파일째 실행하세요.
--
--   대상: 한국어 칸 약 1,380행을 검토해 AI 티(번역투·딱딱한 한자어·중복 표현)로 판정된 14행만.
--   수치·날짜·코드명·인용·줄 구조는 윤문 전후에 같음을 기계 검증했습니다(어긋난 제안 0건).
--   의미가 달라질 수 있어 보류한 1건(이슈 108 findings_md「이어질」→「생길」)은 넣지 않았습니다.
--
--   안전장치
--     1) 각 UPDATE 는 **현재 값이 윤문 전 값과 정확히 같은 행**에만 적용합니다. 그사이 누가 고친 행
--        (예: 번역 검수 중인 칸)은 건너뛰어 덮어쓰지 않습니다.
--     2) 윤문 전 값을 public.csr_polish_backup_20261123 에 남깁니다(PK 로 중복 방지, RLS 켬 — 콘솔 전용).
--     3) 맨 아래 확인 쿼리가 적용 건수를 보여 줍니다. 14 미만이면 그만큼은 그사이 수정된 행입니다.
--
--   주의: csr_issues UPDATE 는 011 가드를 통과해야 합니다(010 과 같은 조건 — 콘솔에서 실행).
--         updated_at 이 실행 시각으로 바뀝니다.
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.csr_polish_backup_20261123 (
  tbl         text        NOT NULL,   -- 테이블명
  row_id      bigint      NOT NULL,
  col         text        NOT NULL,   -- 칼럼명
  before_text text        NOT NULL,   -- 윤문 전
  after_text  text        NOT NULL,   -- 윤문 후
  applied_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tbl, row_id, col)
);
ALTER TABLE public.csr_polish_backup_20261123 ENABLE ROW LEVEL SECURITY;   -- 정책 없음 = API 접근 불가


-- csr_issues.findings_md_ko — 8행 (이슈 07, 115, 24, 31, 32, 35, 38, 75)
WITH p(row_id, before_text, after_text) AS (VALUES
  (42, $q$- 입고(Receipt) 등록 시 AQL · Defect · DOT 열을 모두 입력하여야 확정(Confirm)이 가능하며, 확정 전까지 수입원가(Import Cost) 화면에 해당 건이 표시되지 않음. 품질검사 결과 확정보다 입고 확정 및 원가 산정이 선행되는 실제 업무 순서와 불일치하여 수입원가 산정이 지연됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Purchasing > Receipt > 신규(IMPORT · LOCAL) 진입
2. 현상 확인 — 입고 신규 시 AQL·Defect·DOT 필수 입력으로 확정 불가 (구매담당 Import Cost 선입력과 충돌)

# 8. 실서버 실측 (2026-09-07)

- 결과 — 조치확인, Verified 전환. AQL Qty · Defect Qty · DOT Code 전부 공란 상태로 입고 등록 → DRAFT 저장 → Confirm 실행, 「Receipt confirmed successfully」 확인
- 3개 항목 모두 필수(*) 표시 없음, 확정 차단 없음 → 원 현상(필수 입력으로 확정 불가) 해소
- 회신 정합성 지적 — 개발부서 회신은 「반려 · 개선내역 N/A · 기능 변경 없이 R&R 설명으로 종결」이었으나 실제로는 필수값이 해제되어 있음. 회신 내용과 실서버 상태 불일치로 회신 정확도 개선 요청 필요
- 테스트 전표 삭제 요청 대상 — Receipt ID 18 / PO AJ-20260901-003(PT. ARAMI JAYA) / 1 EA / 창고 KARAWANG / REMARK 「TEST-CAPTURE CSR-38 2026-09-07」 / SURAT JALAN 「TEST-CSR38-20260907」 / 상태 CONFIRMED$q$, $q$- 입고(Receipt) 등록 시 AQL · Defect · DOT 열을 모두 입력해야 확정(Confirm)이 가능하며, 확정 전까지 수입원가(Import Cost) 화면에 해당 건이 표시되지 않음. 품질검사 결과 확정보다 입고 확정 및 원가 산정이 선행되는 실제 업무 순서와 불일치하여 수입원가 산정이 지연됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Purchasing > Receipt > 신규(IMPORT · LOCAL) 진입
2. 현상 확인 — 입고 신규 시 AQL·Defect·DOT 필수 입력으로 확정 불가 (구매담당 Import Cost 선입력과 충돌)

# 8. 실서버 실측 (2026-09-07)

- 결과 — 조치확인, Verified 전환. AQL Qty · Defect Qty · DOT Code 전부 공란 상태로 입고 등록 → DRAFT 저장 → Confirm 실행, 「Receipt confirmed successfully」 확인
- 3개 항목 모두 필수(*) 표시 없음, 확정 차단 없음 → 원 현상(필수 입력으로 확정 불가) 해소
- 회신 정합성 지적 — 개발부서 회신은 「반려 · 개선내역 N/A · 기능 변경 없이 R&R 설명으로 종결」이었으나 실제로는 필수값이 해제되어 있음. 회신 내용과 실서버 상태 불일치로 회신 정확도 개선 요청 필요
- 테스트 전표 삭제 요청 대상 — Receipt ID 18 / PO AJ-20260901-003(PT. ARAMI JAYA) / 1 EA / 창고 KARAWANG / REMARK 「TEST-CAPTURE CSR-38 2026-09-07」 / SURAT JALAN 「TEST-CSR38-20260907」 / 상태 CONFIRMED$q$),
  (50, $q$- Total Import Cost에 PPN 11% (233,058,127) 및 PPh 22 7.5% (158,903,269)가 포함됨. 두 항목 합계 391,961,396은 총액 583,654,228의 67.2%로, 매입세액공제·법인세 선납 대상이어 재고자산 원가에 포함될 수 없음.
- [2026-09-01 재검증] 통관(Customs) 화면에서 BM 5% · PPN 11% · PPh 22 7.5%가 품목별로 산출되는 것을 확인(검증 전표 기준 BC 101,310,450 · PPN 234,027,139.50 · PPh 22 159,563,958.75). 다만 수입원가 화면은 입고 확정 후 생성되는 구조여서 재고원가 산입 여부는 미검증.

**재현 절차 / Langkah reproduksi**

1. Purchasing > Import Cost > ESTIMATED 탭 진입
2. 현상 확인 — Total Import Cost에 PPN·PPh 22(환급·공제 대상) 포함 — 재고원가 과대$q$, $q$- Total Import Cost에 PPN 11% (233,058,127) 및 PPh 22 7.5% (158,903,269)가 포함됨. 두 항목 합계 391,961,396은 총액 583,654,228의 67.2%로, 매입세액공제·법인세 선납 대상이라 재고자산 원가에 포함될 수 없음.
- [2026-09-01 재검증] 통관(Customs) 화면에서 BM 5% · PPN 11% · PPh 22 7.5%가 품목별로 산출되는 것을 확인(검증 전표 기준 BC 101,310,450 · PPN 234,027,139.50 · PPh 22 159,563,958.75). 다만 수입원가 화면은 입고 확정 후 생성되는 구조여서 재고원가 산입 여부는 미검증.

**재현 절차 / Langkah reproduksi**

1. Purchasing > Import Cost > ESTIMATED 탭 진입
2. 현상 확인 — Total Import Cost에 PPN·PPh 22(환급·공제 대상) 포함 — 재고원가 과대$q$),
  (58, $q$- Delivery Location에서 배송 주소를 변경하여도 Cust Contact 값이 함께 변경되지 않음. 실제 배송 시 전표상 담당자와 도착 창고의 인수 담당자가 달라 인수인계 오류 및 하차 지연이 발생할 수 있음. Delivery Note 화면에도 동일하게 적용됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Order > 신규 (배송지 · Cust Contact) 진입
2. 현상 확인 — 배송지 변경 시 고객 담당자(Cust Contact) 미연동$q$, $q$- Delivery Location에서 배송 주소를 변경해도 Cust Contact 값이 함께 변경되지 않음. 실제 배송 시 전표상 담당자와 도착 창고의 인수 담당자가 달라 인수인계 오류 및 하차 지연이 발생할 수 있음. Delivery Note 화면에도 동일하게 적용됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Order > 신규 (배송지 · Cust Contact) 진입
2. 현상 확인 — 배송지 변경 시 고객 담당자(Cust Contact) 미연동$q$),
  (59, $q$- 창고팀이 Delivery Note를 생성하려면 Admin의 확정(Confirm)을 대기해야 하는 구조인지 확인 필요. 현업 운영상 출고 실행 가능 여부는 실재고·차량 배차를 확인하는 창고 책임자의 판단 사항이므로, Admin 확정 대기 시 출고가 지연됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Note > 상세 (Confirm 권한) 진입
2. 현상 확인 — Delivery Note Confirm 주체 창고 책임자 지정 요청$q$, $q$- 창고팀이 Delivery Note를 생성하려면 Admin의 확정(Confirm)을 기다려야 하는 구조인지 확인 필요. 현업 운영상 출고 실행 가능 여부는 실재고·차량 배차를 확인하는 창고 책임자의 판단 사항이므로, Admin 확정 대기 시 출고가 지연됨.
- [2026-09-02 현지 사용자 개선요청]

**재현 절차 / Langkah reproduksi**

1. Sales > Delivery Note > 상세 (Confirm 권한) 진입
2. 현상 확인 — Delivery Note Confirm 주체 창고 책임자 지정 요청$q$),
  (61, $q$- (1) 재고 수량이 확보된 경우에만 SO 입력이 가능함. (2) 실제 출하가 계획과 다를 때(적재 만재, 실재고 부족 등) DO · SO의 잔량을 수정할 수 없음. (3) SO에 묶인 잔여 재고가 타 고객에게 판매되지 않아 재고 회전이 제약됨.
- [2026-09-02 현지 사용자 개선요청 — 원 요청은 「SO 재고 잠금 해제」였으나 동일 재고의 이중 확약(중복 판매) 위험을 고려하여 아래와 같이 조정하여 반영]

**재현 절차 / Langkah reproduksi**

1. Sales > SO > 신규·상세 (재고 연동) 진입
2. 현상 확인 — SO 재고 연동 및 후속 전표 수정 제약$q$, $q$- (1) 재고 수량이 확보된 경우에만 SO 입력이 가능함. (2) 실제 출하가 계획과 다를 때(적재 만재, 실재고 부족 등) DO · SO의 잔량을 수정할 수 없음. (3) SO에 묶인 잔여 재고가 타 고객에게 판매되지 않아 재고 회전이 제약됨.
- [2026-09-02 현지 사용자 개선요청 — 원 요청은 「SO 재고 잠금 해제」였으나 동일 재고의 이중 확약(중복 판매) 위험을 고려해 아래와 같이 조정해 반영]

**재현 절차 / Langkah reproduksi**

1. Sales > SO > 신규·상세 (재고 연동) 진입
2. 현상 확인 — SO 재고 연동 및 후속 전표 수정 제약$q$),
  (76, $q$- 페이지당 10건 고정(제품 1,286건 = 129페이지, 재고 602건 = 61페이지). 페이지 크기 선택·기간 필터·정렬 기능 없음. 페이지 크기 고정은 동일하게 재현. 다만 제품·재고 목록에는 카테고리 필터·Reset·Excel 내보내기 버튼이 제공되고 있어 화면별 편차가 확인됨.

**재현 절차 / Langkah reproduksi**

1. 전 목록 화면 진입
2. 현상 확인 — 목록 화면 페이지 크기·필터·정렬 기능 부재 (API는 page·limit 지원)$q$, $q$- 페이지당 10건 고정(제품 1,286건 = 129페이지, 재고 602건 = 61페이지). 페이지 크기 선택·기간 필터·정렬 기능 없음. 페이지 크기 고정은 동일하게 재현. 다만 제품·재고 목록에는 카테고리 필터·Reset·Excel 내보내기 버튼이 있어 화면별 편차가 확인됨.

**재현 절차 / Langkah reproduksi**

1. 전 목록 화면 진입
2. 현상 확인 — 목록 화면 페이지 크기·필터·정렬 기능 부재 (API는 page·limit 지원)$q$),
  (115, $q$- Quotation 및 Customer PO에서 결제조건(Payment Term)을 변경했으나 Delivery Order 출력물의 Payment Method는 변경 전 값 그대로 인쇄
- 캡처 사례 : DO-20260901-007 (PT. RISUN TRADING INDONESIA, No. PO CGDD26082802, ASC 23.5-25TR179 튜브 100본) 출력물 Payment Method 「CASH CBD」 표시
- 영향 : 출력물 결제조건과 실제 거래조건 불일치로 고객 인수 확인 · 대금 회수 단계에서 분쟁 소지
- 관련 이슈 : 27(DO 출력물 결제조건, 조치확인 상태) 재발 여부, 70(결제조건 이력 보존 · 전표 생성 시점 값 저장) 설계와의 충돌 여부 확인 필요
- 참고 : 동 출력물의 Delivery Date(01-09-2026)가 DO 일자(Tanggal 02-09-2026)보다 앞섬. 일자 선후 검증 규칙 별도 확인 필요
- [2026-10-06 현지 사용자 개선요청 — Merry(Admin Sales)] 요청 우선순위 A(오픈 前 필수). 원문 : Sudah rubah payment term di Quotation & Customer PO. Tapi ketika di Print out DO Payment method tidak berubah sesuai Quotation$q$, $q$- Quotation 및 Customer PO에서 결제조건(Payment Term)을 변경했으나 Delivery Order 출력물의 Payment Method는 변경 전 값 그대로 인쇄
- 캡처 사례 : DO-20260901-007 (PT. RISUN TRADING INDONESIA, No. PO CGDD26082802, ASC 23.5-25TR179 튜브 100본) 출력물 Payment Method 「CASH CBD」 표시
- 영향 : 출력물 결제조건과 실제 거래조건 불일치로 고객 인수 확인 · 대금 회수 단계에서 분쟁 소지
- 관련 이슈 : 27(DO 출력물 결제조건, 조치확인 상태) 재발 여부, 70(결제조건 이력 보존 · 전표 생성 시점 값 저장) 설계와의 충돌 여부 확인 필요
- 참고 : 같은 출력물의 Delivery Date(01-09-2026)가 DO 일자(Tanggal 02-09-2026)보다 앞섬. 일자 선후 검증 규칙 별도 확인 필요
- [2026-10-06 현지 사용자 개선요청 — Merry(Admin Sales)] 요청 우선순위 A(오픈 前 필수). 원문 : Sudah rubah payment term di Quotation & Customer PO. Tapi ketika di Print out DO Payment method tidak berubah sesuai Quotation$q$),
  (155, $q$- 2026-10-18 실서버 점검 : Sales 사이드바에 「Order Management」(기존 SALES ORDER) · 「Force Order Closure」 메뉴 추가
- Force Order Closure 목록 10건 — ORDER NO · ORDER DATE · PO NO · CUSTOMER · QTY · AMOUNT · DELIV. DATE · DO QTY · DN QTY · REM QTY · REMARK · SALES REP · CREATED BY (예 : OD-20261015-248 QTY 900 · DN 870 · REM 30)
- 해당 기능에 대한 IT부서 회신 · CSR 등록 없음$q$, $q$- 2026-10-18 실서버 점검 : Sales 사이드바에 「Order Management」(기존 SALES ORDER) · 「Force Order Closure」 메뉴 추가
- Force Order Closure 목록 10건 — ORDER NO · ORDER DATE · PO NO · CUSTOMER · QTY · AMOUNT · DELIV. DATE · DO QTY · DN QTY · REM QTY · REMARK · SALES REP · CREATED BY (예 : OD-20261015-248 QTY 900 · DN 870 · REM 30)
- 이 기능의 IT부서 회신 · CSR 등록 없음$q$)
),
bk AS (
  INSERT INTO public.csr_polish_backup_20261123 (tbl, row_id, col, before_text, after_text)
  SELECT 'csr_issues', t.id, 'findings_md_ko', p.before_text, p.after_text
    FROM public.csr_issues t JOIN p ON p.row_id = t.id AND t.findings_md_ko = p.before_text
  ON CONFLICT (tbl, row_id, col) DO NOTHING
  RETURNING 1
)
UPDATE public.csr_issues t SET findings_md_ko = p.after_text
  FROM p WHERE t.id = p.row_id AND t.findings_md_ko = p.before_text;

-- csr_issues.summary_ko — 2행 (이슈 145, 146)
WITH p(row_id, before_text, after_text) AS (VALUES
  (177, $q$2026-11-13 가격입력 회신(구매가 130개 · 판매가 235개)이 Products 화면 품목별 수기 입력으로만 반영되어 365개 수기 입력 시 오입력 위험과 검증 근거 미보존 문제가 있어 Excel 일괄 등록 기능이 필요함$q$, $q$2026-11-13 가격입력 회신(구매가 130개 · 판매가 235개)이 Products 화면 품목별 수기 입력으로만 반영되어 365개를 입력할 때 오입력 위험과 검증 근거 미보존 문제가 있어 Excel 일괄 등록 기능이 필요함$q$),
  (178, $q$판매가 입력 회신(Merry, 2026-11-13)에서 실제 판매 실적이 없는 품목 2건이 영업 오입력으로 견적 · Customer PO에 등록되어 판매가 입력 대상에 포함됨이 확인됨$q$, $q$판매가 입력 회신(Merry, 2026-11-13)에서 실제 판매 실적이 없는 품목 2건이 영업 오입력으로 견적 · Customer PO에 등록되어 판매가 입력 대상에 포함된 것으로 확인됨$q$)
),
bk AS (
  INSERT INTO public.csr_polish_backup_20261123 (tbl, row_id, col, before_text, after_text)
  SELECT 'csr_issues', t.id, 'summary_ko', p.before_text, p.after_text
    FROM public.csr_issues t JOIN p ON p.row_id = t.id AND t.summary_ko = p.before_text
  ON CONFLICT (tbl, row_id, col) DO NOTHING
  RETURNING 1
)
UPDATE public.csr_issues t SET summary_ko = p.after_text
  FROM p WHERE t.id = p.row_id AND t.summary_ko = p.before_text;

-- csr_it_replies.fix_plan_ko — 1행 (이슈 31)
WITH p(row_id, before_text, after_text) AS (VALUES
  (102, $q$위 Purchase -> Receipt-> 2에서 정의 함$q$, $q$위 Purchase -> Receipt-> 2에서 정의함$q$)
),
bk AS (
  INSERT INTO public.csr_polish_backup_20261123 (tbl, row_id, col, before_text, after_text)
  SELECT 'csr_it_replies', t.id, 'fix_plan_ko', p.before_text, p.after_text
    FROM public.csr_it_replies t JOIN p ON p.row_id = t.id AND t.fix_plan_ko = p.before_text
  ON CONFLICT (tbl, row_id, col) DO NOTHING
  RETURNING 1
)
UPDATE public.csr_it_replies t SET fix_plan_ko = p.after_text
  FROM p WHERE t.id = p.row_id AND t.fix_plan_ko = p.before_text;

-- csr_it_replies.needs_decision_ko — 1행 (이슈 03)
WITH p(row_id, before_text, after_text) AS (VALUES
  (82, $q$합계(Amount)에 대한 표시 기준 필요 / -구매 & 판매 공통 / -세전/세후 금액?$q$, $q$합계(Amount) 표시 기준 필요 / -구매 & 판매 공통 / -세전/세후 금액?$q$)
),
bk AS (
  INSERT INTO public.csr_polish_backup_20261123 (tbl, row_id, col, before_text, after_text)
  SELECT 'csr_it_replies', t.id, 'needs_decision_ko', p.before_text, p.after_text
    FROM public.csr_it_replies t JOIN p ON p.row_id = t.id AND t.needs_decision_ko = p.before_text
  ON CONFLICT (tbl, row_id, col) DO NOTHING
  RETURNING 1
)
UPDATE public.csr_it_replies t SET needs_decision_ko = p.after_text
  FROM p WHERE t.id = p.row_id AND t.needs_decision_ko = p.before_text;

-- csr_verifications.note_ko — 2행 (이슈 124, 90)
WITH p(row_id, before_text, after_text) AS (VALUES
  (610, $q$Receipt 상세(RCPT-20261119-050) 확인 결과 PO. Info 영역이 PO No. 단일 값 구조 그대로이고 품목별 PPC ID만 표시됨. 헤더가 PO 1건 기준인 구조가 지속되어 복수 PO 혼입 시 PO별 입고량 집계 왜곡 가능성 여전함$q$, $q$Receipt 상세(RCPT-20261119-050) 확인 결과 PO. Info 영역이 PO No. 단일 값 구조 그대로이고 품목별 PPC ID만 표시됨. 헤더가 PO 1건 기준인 구조가 지속되어 복수 PO 혼입 시 PO별 입고량 집계가 왜곡될 가능성이 여전히 있음$q$),
  (620, $q$Inventory List 페이지 번호 직접 클릭 정상 동작 확인(1→15건 필터 결과 기준), 67페이지 전수 중복·누락 재검증은 이번 회차에 재실시하지 않음, 이전 판정 유지$q$, $q$Inventory List 페이지 번호 직접 클릭 정상 동작 확인(1→15건 필터 결과 기준), 67페이지 전수 중복·누락 재검증은 이번 회차에 다시 하지 않음, 이전 판정 유지$q$)
),
bk AS (
  INSERT INTO public.csr_polish_backup_20261123 (tbl, row_id, col, before_text, after_text)
  SELECT 'csr_verifications', t.id, 'note_ko', p.before_text, p.after_text
    FROM public.csr_verifications t JOIN p ON p.row_id = t.id AND t.note_ko = p.before_text
  ON CONFLICT (tbl, row_id, col) DO NOTHING
  RETURNING 1
)
UPDATE public.csr_verifications t SET note_ko = p.after_text
  FROM p WHERE t.id = p.row_id AND t.note_ko = p.before_text;

-- ─── 확인 — 적용 건수(기대: csr_issues 10 · csr_it_replies 2 · csr_verifications 2 = 14) ───────────
SELECT tbl, count(*) AS applied FROM public.csr_polish_backup_20261123 GROUP BY tbl ORDER BY tbl;

-- ─── 되돌리기 (필요할 때만 실행) ─────────────────────────────────────────────────────────────
-- 현재 값이 윤문 후 값과 같은 행만 윤문 전 값으로 복원합니다.
-- UPDATE public.csr_issues t SET findings_md_ko = b.before_text
--   FROM public.csr_polish_backup_20261123 b
--  WHERE b.tbl = 'csr_issues' AND b.col = 'findings_md_ko' AND t.id = b.row_id AND t.findings_md_ko = b.after_text;
-- (summary_ko · csr_it_replies.fix_plan_ko · needs_decision_ko · csr_verifications.note_ko 도 같은 꼴로)
