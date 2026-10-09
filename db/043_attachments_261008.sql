-- =============================================================================
-- ASM CSR — 261008 개선요청서 캡쳐 27건 → csr_attachments
--   생성: node scripts/csr_gen_043.cjs   (Drive 업로드는 csr_migrate_captures.mjs 가 이미 끝냄)
--   040 · 042 적용 후 실행. 재실행 안전(같은 이슈에 같은 drive_file_id 가 있으면 건너뜀).
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--
--   문서 수록 캡쳐 23장(75 · 77 · 78 · 82 ~ 98 · 100 ~ 102) + 동일 화면 재사용 4건
--   (79 · 80 · 81 ← 78, 99 ← 98). 76 은 문서에 「요청자 캡처 없음」.
-- =============================================================================

-- 75
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1k8ZlcI2WOARfoUkQyWgpme0mdkmxKXEX', '75_Delivery_Order_출력물_Payment_Method_미갱신_Quotati.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '75' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1k8ZlcI2WOARfoUkQyWgpme0mdkmxKXEX');

-- 77
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1JZnXs6iZfAqoeWgUlXVhq3L9iylqb6ky', '77_판촉물_Material_Promosi_입고_출고_In_Out_거래_기능_부재.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '77' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1JZnXs6iZfAqoeWgUlXVhq3L9iylqb6ky');

-- 78
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT', '78_Products_기본정보_창고입고가_WH_Price_항목_부재_입력_화면_그룹_구.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '78' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT');

-- 79 (이슈 78 과 동일 화면)
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT', '78_Products_기본정보_창고입고가_WH_Price_항목_부재_입력_화면_그룹_구.jpeg', '이슈 78 캡쳐와 동일 화면', 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '79' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT');

-- 80 (이슈 78 과 동일 화면)
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT', '78_Products_기본정보_창고입고가_WH_Price_항목_부재_입력_화면_그룹_구.jpeg', '이슈 78 캡쳐와 동일 화면', 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '80' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT');

-- 81 (이슈 78 과 동일 화면)
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT', '78_Products_기본정보_창고입고가_WH_Price_항목_부재_입력_화면_그룹_구.jpeg', '이슈 78 캡쳐와 동일 화면', 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '81' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '18tJuRIXzp3oSD08PxG1Nf04-s0_AKHFT');

-- 82
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1qexOnGgmLYKY0_ZHFeBWL30Q9Ky3ck-g', '82_Finance_Payment_Voucher_지급요청서_화면_부재_회계_지급_청구.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '82' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1qexOnGgmLYKY0_ZHFeBWL30Q9Ky3ck-g');

-- 83
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1nixkYLj2be2YkRnlgKbU_G2ZDQyFIujy', '83_Finance_Budget_Plan_예산계획_화면_부재_월_주차별_비용_계획_및.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '83' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1nixkYLj2be2YkRnlgKbU_G2ZDQyFIujy');

-- 84
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1h66LONNkaC5Jd9btv9LiG-wSt7YP8yFn', '84_Receipt_Customs_Shipment_날짜_선후관계_및_미래일자_검증_부재.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '84' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1h66LONNkaC5Jd9btv9LiG-wSt7YP8yFn');

-- 85
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1Pgze5D57hcAKcYugtFpJmN3awxmTpWX9', '85_Receipt_목록_ACT_ARRIVAL_컬럼에_PO_ETA_값_표시_실제_도착일.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '85' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1Pgze5D57hcAKcYugtFpJmN3awxmTpWX9');

-- 86
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1kKaL7GjFQpbNS3miCm9VdO4Z10viCkze', '86_취소_CANCELLED_전표_통제_취소_사유_이력_없음_취소_시_참조_전표_번호.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '86' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1kKaL7GjFQpbNS3miCm9VdO4Z10viCkze');

-- 87
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1oqAJT6ezvO374gbT-VA7UaNLTJ5nLugw', '87_견적_Quotation_Customer_PO_금액_1_IDR_불일치_소수점_처리.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '87' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1oqAJT6ezvO374gbT-VA7UaNLTJ5nLugw');

-- 88
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1uM1DlPSpD3CzR5FmzachPBzx-RiLsjrn', '88_SO_상세_MARGIN_산식_기준_원가_미표시_화면_수치로_재현_불가.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '88' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1uM1DlPSpD3CzR5FmzachPBzx-RiLsjrn');

-- 89
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1l0lVUNJDHNv2_V587_h253O5MQ69_YLo', '89_Delivery_Order_미래_납품일로_CONFIRMED_처리_허용_채번이_전표.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '89' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1l0lVUNJDHNv2_V587_h253O5MQ69_YLo');

-- 90
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1Y-asybOPcQMWBE9KwG-Wl5DQGD1OmKd2', '90_재고_목록_페이징_페이지_이동_시_동일_행_반복_표시_일부_품목_영구_누락_정렬.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '90' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1Y-asybOPcQMWBE9KwG-Wl5DQGD1OmKd2');

-- 91
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '17vRLyj6IAzqEe1oRqnrgRrIFOaUmeqAb', '91_취소_CANCELLED_입고_전표가_재고_목록_Receipt_Qty_Receipt.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '91' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '17vRLyj6IAzqEe1oRqnrgRrIFOaUmeqAb');

-- 92
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1O0yB-gH7we_CS0wkaDV7NYkxz105aWoe', '92_재고_목록_기간_필터_Receipt_Qty_Total_Qty_의미가_필터_유무에.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '92' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1O0yB-gH7we_CS0wkaDV7NYkxz105aWoe');

-- 93
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1jgGJuD0ilH-vjAc6X-iLCb5QCXeqiHBm', '93_재고_목록_종료일_시작일_입력_시_오류_메시지와_화면_상태_불일치_건수_배지_유지.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '93' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1jgGJuD0ilH-vjAc6X-iLCb5QCXeqiHBm');

-- 94
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '19redgHUQ04F_EDD58-9EuEM8-TmKsGnH', '94_재고_목록_재고_0_품목_숨김_옵션_재고금액_컬럼_부재_단가_0_품목_6건_재고평.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '94' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '19redgHUQ04F_EDD58-9EuEM8-TmKsGnH');

-- 95
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1_jXb4QoN3AFFqRJU64aFgx_c0l98sbUY', '95_월마감_수량_3원화_재고마감_Finance_업로드_재고목록_상호_불일치_업로드_데.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '95' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1_jXb4QoN3AFFqRJU64aFgx_c0l98sbUY');

-- 96
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1apfyOWUYXgkOn-FL0bFrcRUZNRxHlihV', '96_Receipt_History_TOTAL_AMT_IDR_산식_오류_수입_건_PPh.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '96' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1apfyOWUYXgkOn-FL0bFrcRUZNRxHlihV');

-- 97
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '13fetSy9H4jdT4Gdupm7yd0jLRXp74xeY', '97_Receipt_History_ARTICLE_NO_숫자_서식_적용_천_단위_구분_S.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '97' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '13fetSy9H4jdT4Gdupm7yd0jLRXp74xeY');

-- 98
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1kCtbgzQtR_gq9DYgNBSNsgxF6xN7z03i', '98_Shipment_History_할인_컬럼_산식_오류_U_PRICE_AFT_DC_U.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '98' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1kCtbgzQtR_gq9DYgNBSNsgxF6xN7z03i');

-- 99 (이슈 98 과 동일 화면)
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1kCtbgzQtR_gq9DYgNBSNsgxF6xN7z03i', '98_Shipment_History_할인_컬럼_산식_오류_U_PRICE_AFT_DC_U.jpeg', '이슈 98 캡쳐와 동일 화면', 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '99' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1kCtbgzQtR_gq9DYgNBSNsgxF6xN7z03i');

-- 100
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1lHv0fGHADpEvMNXKeX5FTfAQ9RLaGxDm', '100_직원_명부_HP_NO_앞자리_0_탈락_숫자형_저장.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '100' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1lHv0fGHADpEvMNXKeX5FTfAQ9RLaGxDm');

-- 101
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1HclWQhsAb7na5ajp7MgaCvWVDBNsiyzA', '101_전_화면_날짜_금액_표기_형식_화면_간_혼재_yyyy_mm_dd_mm_dd_yyy.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '101' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1HclWQhsAb7na5ajp7MgaCvWVDBNsiyzA');

-- 102
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1RSrMox1IXm24Z1Ry0ZQ7W0XZvYI5KAIa', '102_Excel_다운로드_헤더_오타_Categroy2_화면과_Excel_컬럼_구성_불일.jpeg', NULL, 0, '261008-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '102' AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = '1RSrMox1IXm24Z1Ry0ZQ7W0XZvYI5KAIa');

-- 확인 — 75~102 이슈별 첨부 수 (27행 기대, 76 만 0)
SELECT i.issue_no, count(a.id) AS captures
  FROM public.csr_issues i LEFT JOIN public.csr_attachments a ON a.issue_id = i.id
 WHERE NOT i.is_archived AND i.issue_no::int BETWEEN 75 AND 102
 GROUP BY i.issue_no ORDER BY i.issue_no::int;
