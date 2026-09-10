-- =============================================================================
-- [CSR-1.1-C] 현업검증 상태 코드 표준화 (2026-09-10 결정)
--   015 적용 후 실행. 달러 인용 없음 — 문장마다 따로 실행돼도 됩니다. 재실행 안전.
--
--   코드 5종(변경 금지): PENDING · NOT APPLIED · PARTIAL · ACCEPTED · REJECTED
--   IT상태(Open/Ongoing/Completed/Verified…)는 그대로입니다.
--
--   원래 값은 *_legacy 컬럼에 보존합니다 — 되돌릴 수 있고, 검증 이력의 「최초 발견 · 최초 제안 ·
--   최초 접수」(코드에 없는 기록성 값)는 PENDING 으로 두되 화면이 legacy 를 곁들여 보여 줍니다.
--   노션 옵션명은 손대지 않습니다(코드 ↔ 노션 옵션 매핑은 프론트 config.NOTION_VERIFY_OPTION).
-- =============================================================================

ALTER TABLE public.csr_issues        ADD COLUMN IF NOT EXISTS verification_result_legacy text;
ALTER TABLE public.csr_verifications ADD COLUMN IF NOT EXISTS result_legacy text;

-- 원래 값 보존(코드가 아닌 값만, 한 번만)
UPDATE public.csr_issues
   SET verification_result_legacy = verification_result
 WHERE verification_result_legacy IS NULL
   AND verification_result IS NOT NULL
   AND verification_result NOT IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED');

UPDATE public.csr_verifications
   SET result_legacy = result
 WHERE result_legacy IS NULL
   AND result IS NOT NULL
   AND result NOT IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED');

-- 이슈 헤더: 종전 표기("조치확인 / Terkonfirmasi" 꼴) → 코드. NULL 은 PENDING.
UPDATE public.csr_issues
   SET verification_result = CASE
     WHEN verification_result IS NULL                                   THEN 'PENDING'
     WHEN verification_result ILIKE '미검증%'  OR verification_result ILIKE 'Belum Diverifikasi%'    THEN 'PENDING'
     WHEN verification_result ILIKE '미조치%'  OR verification_result ILIKE 'Belum Ditindaklanjuti%' THEN 'NOT APPLIED'
     WHEN verification_result ILIKE '부분조치%' OR verification_result ILIKE 'Sebagian%'              THEN 'PARTIAL'
     WHEN verification_result ILIKE '조치확인%' OR verification_result ILIKE 'Terkonfirmasi%'         THEN 'ACCEPTED'
     WHEN verification_result ILIKE 'Completed 부적정%' OR verification_result ILIKE 'Completed Tidak Sesuai%' THEN 'REJECTED'
     ELSE verification_result
   END
 WHERE verification_result IS NULL
    OR verification_result NOT IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED');

-- 검증 이력: 같은 매핑 + 기록성 값(최초 발견/제안/접수)은 PENDING.
UPDATE public.csr_verifications
   SET result = CASE
     WHEN result ILIKE '미검증%'  OR result ILIKE 'Belum diverifikasi%'    THEN 'PENDING'
     WHEN result ILIKE '미조치%'  OR result ILIKE 'Belum ditindaklanjuti%' THEN 'NOT APPLIED'
     WHEN result ILIKE '부분조치%' OR result ILIKE 'Sebagian%'              THEN 'PARTIAL'
     WHEN result ILIKE '조치확인%' OR result ILIKE 'Terkonfirmasi%'         THEN 'ACCEPTED'
     WHEN result ILIKE 'Completed 부적정%' OR result ILIKE 'Completed tidak sesuai%' THEN 'REJECTED'
     WHEN result ILIKE '최초 발견%' OR result ILIKE 'Temuan awal%'
       OR result ILIKE '최초 제안%' OR result ILIKE 'Usulan awal%'
       OR result ILIKE '최초 접수%' OR result ILIKE 'Diterima pertama kali%' THEN 'PENDING'
     ELSE result
   END
 WHERE result IS NOT NULL
   AND result NOT IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED');

-- 제약 — 앞으로는 5개 코드만. (제약 추가는 미매핑이 0일 때만 성공합니다 — 아래 확인 SELECT 참고)
ALTER TABLE public.csr_issues DROP CONSTRAINT IF EXISTS csr_issues_verification_result_chk;
ALTER TABLE public.csr_issues ADD CONSTRAINT csr_issues_verification_result_chk
  CHECK (verification_result IS NULL OR verification_result IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED'));
ALTER TABLE public.csr_verifications DROP CONSTRAINT IF EXISTS csr_verifications_result_chk;
ALTER TABLE public.csr_verifications ADD CONSTRAINT csr_verifications_result_chk
  CHECK (result IS NULL OR result IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED'));

COMMENT ON COLUMN public.csr_issues.verification_result IS '현업검증 코드 5종(PENDING·NOT APPLIED·PARTIAL·ACCEPTED·REJECTED). 종전 표기는 verification_result_legacy.';
COMMENT ON COLUMN public.csr_verifications.result IS '검증 결과 코드 5종. 최초 발견/제안/접수 같은 기록성 값은 PENDING + result_legacy.';

-- 확인 — issues_unmapped · verif_unmapped 가 0 이어야 합니다.
SELECT (SELECT count(*) FROM public.csr_issues
         WHERE verification_result IS NULL
            OR verification_result NOT IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED')) AS issues_unmapped,
       (SELECT count(*) FROM public.csr_verifications
         WHERE result IS NOT NULL
           AND result NOT IN ('PENDING', 'NOT APPLIED', 'PARTIAL', 'ACCEPTED', 'REJECTED')) AS verif_unmapped;
SELECT verification_result, count(*) FROM public.csr_issues WHERE NOT is_archived GROUP BY 1 ORDER BY 1;
