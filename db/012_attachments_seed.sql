-- =============================================================================
-- ASM CSR — Notion 이관 캡쳐 38건 → csr_attachments (2026-09-10)
--   생성: node scripts/csr_migrate_captures.mjs   (Drive 업로드는 이미 끝났고 여기서는 행만 넣습니다)
--   001~011 적용 후 실행. 재실행 안전(같은 drive_file_id 는 건너뜀).
-- =============================================================================

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1pMGP59YRbslXGavst70fARP8R6iMLKQH', '01_PO_신규_상세_견적_신규_전_전표_공통.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '01' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1pMGP59YRbslXGavst70fARP8R6iMLKQH');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1Cbfbot25F6d---KkCSEwO8V3uZt0BNlk', '02_PO_목록_금액_통화_Currency_표기_부재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '02' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1Cbfbot25F6d---KkCSEwO8V3uZt0BNlk');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1DF9XnC6tTsCzR3PZZRrjAuRigYX1Lr-I', '03_PO__PPC_수량_금액_대사_Reconcilia.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '03' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1DF9XnC6tTsCzR3PZZRrjAuRigYX1Lr-I');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '154i8zr1KvKp9EsqE_4i6IeK3dkrESLcD', '04_PO_NO._채번_규칙_부재_및_테스트_전표_혼재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '04' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '154i8zr1KvKp9EsqE_4i6IeK3dkrESLcD');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '16xhQIIf40s75IlqirVQGxnvDgO_KCx4_', '05_단가_입력_천_단위_구분기호_미표시.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '05' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '16xhQIIf40s75IlqirVQGxnvDgO_KCx4_');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1EgwPPKnsElxJQsE6bfkjWYWgonz8WWRi', '06_입고일_실제도착일_선후관계_검증_부재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '06' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1EgwPPKnsElxJQsE6bfkjWYWgonz8WWRi');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1RFzZwDm-jM_LUhUgTrT2SBtag5psrEWQ', '07_수입원가_구성_PPN_PPh_22_재고원가_산입.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '07' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1RFzZwDm-jM_LUhUgTrT2SBtag5psrEWQ');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1hzDxIO98AzxoV8HPNVSLygJhZb-_oRwQ', '08_품목_SKU_별_원가_배부_기능_부재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '08' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1hzDxIO98AzxoV8HPNVSLygJhZb-_oRwQ');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1o_cXixeN8tVjX6RkTMRNLwQDoQWaaHCf', '09_ACTUAL_탭_세금_항목_실적_입력란_부재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '09' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1o_cXixeN8tVjX6RkTMRNLwQDoQWaaHCf');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '10flzCaxAQmUhzX46kOAouJ8FOB0EFrOj', '10_적용_환율_Kurs_KMK_미표시.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '10' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '10flzCaxAQmUhzX46kOAouJ8FOB0EFrOj');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1iKAaGCRVrNeIfL78rDzl99pRRR06rrqY', '11_견적_신규_SALES_REP_드롭다운_0건.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '11' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1iKAaGCRVrNeIfL78rDzl99pRRR06rrqY');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1ZP-Xj5DigABRa5qBc0BZrOJfLWwG9Sqt', '12_합계_절사_Truncation_로직_총액_기준_적용.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '12' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1ZP-Xj5DigABRa5qBc0BZrOJfLWwG9Sqt');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1sA5r7_ZkcpxSGZ0YJ_UmdIHle8npup89', '13_SO__Delivery_Note_금액_불일치_ID.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '13' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1sA5r7_ZkcpxSGZ0YJ_UmdIHle8npup89');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1nVwFBApDUJ_Yx_Rgp7NPgpm_K_YTECrs', '14_월마감_집계_미반영_입_출고_트랜잭션_미연결.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '14' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1nVwFBApDUJ_Yx_Rgp7NPgpm_K_YTECrs');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1DViz7u6FbbwKEXQdwoV-2gFUEcQRwKHo', '15_날짜_입력_안내문_한국어_노출.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '15' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1DViz7u6FbbwKEXQdwoV-2gFUEcQRwKHo');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1xWWoE39p7fDpzyJtRH5G665DReKh70Ho', '16_고객_마스터_여신한도_Credit_Limit_필드_.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '16' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1xWWoE39p7fDpzyJtRH5G665DReKh70Ho');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1aWazKDctbiETkMyc5j5SKYin8hd1MY9h', '17_고객_마스터_데이터_이관_품질_컬럼_매핑_중복.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '17' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1aWazKDctbiETkMyc5j5SKYin8hd1MY9h');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1RbEA07ROKKFPf8whiz0kdhwDui5yhWnk', '18_공급사_마스터_COUNTRY_오등록_및_자유입력.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '18' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1RbEA07ROKKFPf8whiz0kdhwDui5yhWnk');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1o0r6AKsWksHu7q-g_KbdWJ--sAXJvXKT', '19_제품_마스터_단가_중량_미등록_및_인코딩_깨짐.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '19' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1o0r6AKsWksHu7q-g_KbdWJ--sAXJvXKT');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1oENkuznuagI7h-oKokLn5rmBAovK1rZ4', '20_창고_마스터_TYPE_코드값_구분_불명확.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '20' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1oENkuznuagI7h-oKokLn5rmBAovK1rZ4');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1J3gZO9FVKTljo6TxxE22CAWNsE-MkHJj', '21_직원_마스터_DEPARTMENT_값_표준화_필요.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '21' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1J3gZO9FVKTljo6TxxE22CAWNsE-MkHJj');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1v7J7uR1Du488a_THP8alZ8wVxuZdtjWF', '22_숫자_표기_형식_인도네시아식_표기_적용.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '22' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1v7J7uR1Du488a_THP8alZ8wVxuZdtjWF');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1UC-W1WcpAmmDSGIXgMS7Qooq5Bgs22Zy', '23_반응형_레이아웃_라벨_잘림_및_기준열_미고정.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '23' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1UC-W1WcpAmmDSGIXgMS7Qooq5Bgs22Zy');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1UtYAC0Jn_fQ4BGHrBB02-YOTHZkLTewR', '24_목록_화면_페이지_크기_필터_정렬_기능_부재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '24' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1UtYAC0Jn_fQ4BGHrBB02-YOTHZkLTewR');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1XYbWVFWfKf0QOh68SP5hZLeA_eb9tXw4', '25_입력_검증_미입력_항목_안내_방식.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '25' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1XYbWVFWfKf0QOh68SP5hZLeA_eb9tXw4');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1TY58eOY-IwpsfUCsQqws6I9Z3daswq1d', '26_정적_자원_404_및_도메인_혼재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '26' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1TY58eOY-IwpsfUCsQqws6I9Z3daswq1d');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '115oOwkroO-PIniPdJeaJSgkdwJ3olBC9', '27_결제조건_Payment_Term_전표_간_전이_불일.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '27' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '115oOwkroO-PIniPdJeaJSgkdwJ3olBC9');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1YaS7pNjzv97YCAfn_JhtoyJXB8B_wbeE', '28_견적_신규_동일_품목_중복_입력_불가.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '28' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1YaS7pNjzv97YCAfn_JhtoyJXB8B_wbeE');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '10_NQkaSlLv4sqhmvhD4jMHwPrpIWEZ_7', '29_Delivery_Order_Delivery_Note.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '29' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '10_NQkaSlLv4sqhmvhD4jMHwPrpIWEZ_7');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '170U0B-PZ_DOFj4t5HGdoQb4PzLBNFzjP', '30_SO_신규_클레임_교체품_보관_로케이션_부재.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '30' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '170U0B-PZ_DOFj4t5HGdoQb4PzLBNFzjP');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1L9-Xshi5RmkElj6LDwgPJzFl2XoAAFFi', '31_Delivery_Note_확정_Confirm_주체_.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '31' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1L9-Xshi5RmkElj6LDwgPJzFl2XoAAFFi');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1EfyKcZmCrymlcyGvilUeNqUr934EzDkl', '32_Delivery_Order_신규_배송지_변경_시_고.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '32' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1EfyKcZmCrymlcyGvilUeNqUr934EzDkl');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1pNebvS5oZR7ATlnlhkZ_ztT0BSXvaLQm', '33_견적_신규_할인율_DC_Rate_입력_시_마진율_M.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '33' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1pNebvS5oZR7ATlnlhkZ_ztT0BSXvaLQm');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1ufiAcyVnyzh97n-T4wiW4pOrjJXL2ooO', '34_견적_Customer_PO_승인_결재자_알림_Not.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '34' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1ufiAcyVnyzh97n-T4wiW4pOrjJXL2ooO');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1GS84ZABSSBBGKVVBnNBHUPdryymlrD5o', '35_SO_신규_재고_연동_및_후속_전표_수정_제약.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '35' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1GS84ZABSSBBGKVVBnNBHUPdryymlrD5o');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1eSYvmBzvOl4eg23hiMwpDr3U0-f05hsv', '36_발주_신규_LOCAL_공급사_목록에_PT_Techk.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '36' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1eSYvmBzvOl4eg23hiMwpDr3U0-f05hsv');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1gpuEOz36MNucL7T-MOGl7Xnlw8bhIJYD', '37_발주_신규_LOCAL_결제조건_Payment_Ter.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '37' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1gpuEOz36MNucL7T-MOGl7Xnlw8bhIJYD');

INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, '1iQ7Tr8Juxp1WjvDr1CGPJYQ_--Ebgy1O', '38_입고_신규_IMPORT_LOCAL_AQL_Defec.jpeg', NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = '38' AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = '1iQ7Tr8Juxp1WjvDr1CGPJYQ_--Ebgy1O');

-- 확인 — 이슈별 첨부 수
SELECT i.issue_no, count(a.id) AS captures
  FROM public.csr_issues i LEFT JOIN public.csr_attachments a ON a.issue_id = i.id
 WHERE NOT i.is_archived GROUP BY i.issue_no HAVING count(a.id) > 0 ORDER BY i.issue_no;
