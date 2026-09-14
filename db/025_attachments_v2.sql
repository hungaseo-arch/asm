-- =============================================================================
-- ASM CSR — 캡쳐 23건 → csr_attachments (v2_captures · v2-doc)
--   생성: node scripts/csr_migrate_captures.mjs   (Drive 업로드는 이미 끝났고 여기서는 행만 넣습니다)
--   001~011 적용 후 실행. 재실행 안전(같은 drive_file_id 는 건너뜀).
-- =============================================================================

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1R1WACIzVx7u8TKy06pQrnqFzWygbFycC', '39_Purchase_PO_신규_PO_번호_수기_입력_불가_기존_진행_중_발주.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '39' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1R1WACIzVx7u8TKy06pQrnqFzWygbFycC');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1KMaKGdDMPs0L6V1FmD6b7xXqIjNpv9LS', '40_Purchase_PO_Remark_입고_Receipt_GRPO_화면_및_.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '40' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1KMaKGdDMPs0L6V1FmD6b7xXqIjNpv9LS');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1bWLsVZFj_oNHM69ZlntJOqge2jsehqqj', '41_PPC_신규_Discount_입력_제약_Purchase_PO_선입력_필수.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '41' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1bWLsVZFj_oNHM69ZlntJOqge2jsehqqj');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1KkFstyMmKbkNk_CrsqpfuFRGrGQR2xDk', '42_Customs_첨부문서_할인_증빙_Discount_문서_유형_부재.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '42' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1KkFstyMmKbkNk_CrsqpfuFRGrGQR2xDk');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1NQLgUKENoUddMWY4xvc5TiLOzUI4gvyP', '43_Receipt_신규_품목_일괄_선택_삭제_기능_부재_다품목_PO_부분_입.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '43' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1NQLgUKENoUddMWY4xvc5TiLOzUI4gvyP');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1NKZNqtYtey268HE_pC7dnDMXkwuxFpKI', '45_Receipt_신규_오품목_오브랜드_입고_시_Add_Item_불가_1.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '45' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1NKZNqtYtey268HE_pC7dnDMXkwuxFpKI');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '19ovog0KI-DppPGFlN7DCm4hXvzNRmQyi', '45_Receipt_신규_오품목_오브랜드_입고_시_Add_Item_불가_2.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '45' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '19ovog0KI-DppPGFlN7DCm4hXvzNRmQyi');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1CkLZZXriyduhbL_hC1kHoPf1AGL_-MGK', '47_Receipt_WH_메뉴_잠김_창고_사용자_권한_미개방.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '47' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1CkLZZXriyduhbL_hC1kHoPf1AGL_-MGK');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '17PAHosntfvaqyHHWgoQ4e8L94BxOPfmV', '48_견적_신규_활성_고객의_Sales_Rep_미지정으로_견적_등록_불가.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '48' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '17PAHosntfvaqyHHWgoQ4e8L94BxOPfmV');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1QIohhixq14jv3ooLvMRgcRUHxutRSRxg', '49_Customer_PO_일자_변경_SO_Delivery_Order_Deli.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '49' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1QIohhixq14jv3ooLvMRgcRUHxutRSRxg');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1MWMH72BumUfeit6azqd0qE21yi_Q8_So', '50_재고_목록_Excel_다운로드_파일명_조회_기준_기간_창고_미표기_1.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '50' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1MWMH72BumUfeit6azqd0qE21yi_Q8_So');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1rE08AG780mu6lDsU4jeMlbW2x1P6qkLz', '50_재고_목록_Excel_다운로드_파일명_조회_기준_기간_창고_미표기_2.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '50' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1rE08AG780mu6lDsU4jeMlbW2x1P6qkLz');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1sc-ZJx-tm3_zTbAkNIQDSGyt-BOfR3FX', '51_재고_목록_Excel_수량_실재고_및_창고_집계와_불일치.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '51' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1sc-ZJx-tm3_zTbAkNIQDSGyt-BOfR3FX');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1ZN8A8BGjf4Ogd1LX3_1OGMKofgIy07KO', '52_지점_간_재고_이동_Inventory_Movement_메뉴_부재_Sema.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '52' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1ZN8A8BGjf4Ogd1LX3_1OGMKofgIy07KO');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '14QjNuWy3RbIE9ZwG9MQfXdZrM_t6W8t6', '53_월별_재고_실사_Stock_Taking_결과_입력_메뉴_부재_1.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '53' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '14QjNuWy3RbIE9ZwG9MQfXdZrM_t6W8t6');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1-_e8ftS7MmmO3hgEzCxUcLh4-IXC7TXG', '53_월별_재고_실사_Stock_Taking_결과_입력_메뉴_부재_2.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '53' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1-_e8ftS7MmmO3hgEzCxUcLh4-IXC7TXG');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1U7z-chf6XkNik2U6wBwiU074kHs50n1B', '54_주간_재고_현황_보고서_Summary_Weekly_Data_Stock_양.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '54' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1U7z-chf6XkNik2U6wBwiU074kHs50n1B');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '19SPFonjh403x22sjDC2DIm2PHAayQTRa', '55_운송_Ekspedisi_정산_보고서_양식_시스템_출력_요청.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '55' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '19SPFonjh403x22sjDC2DIm2PHAayQTRa');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1C2OzZPCBdhDX7ZV1mgUezaX-_yPCuGDS', '56_구매_실적_보고서_Summary_PO_GRPO_by_Factory_양식_.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '56' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1C2OzZPCBdhDX7ZV1mgUezaX-_yPCuGDS');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1k7GK8jyGPz1ki0pFJ_iH7KutrnDtKVJt', '61_Partners_Customer_메뉴_진입_불가_법무_재무_담당_계정_권.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '61' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1k7GK8jyGPz1ki0pFJ_iH7KutrnDtKVJt');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '172iG8kL9D_XZSWJR_VsPMkFwn0ljAw7R', '63_Finance_대메뉴_부재_메뉴_순서_업무_흐름_정렬_및_하위_메뉴_5종.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '63' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '172iG8kL9D_XZSWJR_VsPMkFwn0ljAw7R');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '167ezfec8pyWUqcwi5_z6FFcMoFm7m_9q', '64_Finance_Invoice_화면_부재_세금계산서_번호_발송_수령_어음__1.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '64' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '167ezfec8pyWUqcwi5_z6FFcMoFm7m_9q');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1GQ58H4ubz22Et9R8fOwhDCMDFhjzBqBx', '64_Finance_Invoice_화면_부재_세금계산서_번호_발송_수령_어음__2.jpeg', NULL, 0, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = '64' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1GQ58H4ubz22Et9R8fOwhDCMDFhjzBqBx');

-- 확인 — 이슈별 첨부 수
SELECT i.issue_no, count(a.id) AS captures
  FROM public.csr_issues i LEFT JOIN public.csr_attachments a ON a.issue_id = i.id
 WHERE NOT i.is_archived GROUP BY i.issue_no HAVING count(a.id) > 0 ORDER BY i.issue_no;
