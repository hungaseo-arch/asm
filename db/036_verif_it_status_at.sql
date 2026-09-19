-- =============================================================================
-- ASM CSR — 검증 이력에 「검증 시점의 IT 상태」 컬럼 추가 (2026-09-19)
--   배경: §7 검증 이력 표는 날짜·결과·내용만 보여 줘서, 그 검증이 IT 가 어느 단계일 때
--         이뤄진 것인지(개발 중이었는지, 이미 Completed 였는지) 표에서 알 수 없었습니다.
--   방법: csr_verifications.it_status_at — 그 행이 기록될 당시 이슈의 it_status 스냅샷.
--         · 앞으로: 사이트 「+ 검증 추가」 가 이슈의 현재 it_status 를 같이 넣습니다(034 이후 코드).
--         · 기존 행: csr_status_log 의 it_status 변경 이력으로 역산합니다.
--             - verified_on 이하의 마지막 변경이 있으면 그 new_value,
--             - 없으면 verified_on 이후 첫 변경의 old_value(= 그 이전까지의 값),
--             - 로그가 아예 없는 이슈(Notion 이관분)는 NULL 로 둡니다 — 현재 상태를 과거에
--               덧씌우면 없던 사실을 만들어 내므로, 모르는 것은 빈칸으로 남깁니다(§8 정규화 금지).
--   CHECK 는 걸지 않습니다 — 로그에 남은 과거 표기를 그대로 보존하기 위해서입니다.
--   RLS·권한 영향 없음(002 의 GRANT 는 테이블 단위, 015b 컬럼 가드는 csr_issues 전용).
--   실행: Neon 콘솔 SQL Editor (asm-csm · production). 재실행 안전.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:036 (2026-09-19 검증 시점 IT 상태)', false);

ALTER TABLE public.csr_verifications
  ADD COLUMN IF NOT EXISTS it_status_at text;

COMMENT ON COLUMN public.csr_verifications.it_status_at IS
  '검증 시점의 이슈 it_status 스냅샷(036). 역산 불가한 이관분은 NULL.';

-- ── 역산 백필 — 이미 값이 있는 행은 건드리지 않습니다(재실행 안전) ──────────────
WITH guess AS (
  SELECT v.id AS verif_id,
         COALESCE(
           -- verified_on 당일까지의 마지막 it_status 변경 결과
           (SELECT l.new_value
              FROM public.csr_status_log l
             WHERE l.issue_id = v.issue_id
               AND l.column_name = 'it_status'
               AND l.changed_at < (v.verified_on + 1)::timestamptz
             ORDER BY l.changed_at DESC, l.id DESC
             LIMIT 1),
           -- 그 전이면, 이후 첫 변경의 '변경 전 값' 이 곧 당시 값
           (SELECT l.old_value
              FROM public.csr_status_log l
             WHERE l.issue_id = v.issue_id
               AND l.column_name = 'it_status'
               AND l.changed_at >= (v.verified_on + 1)::timestamptz
             ORDER BY l.changed_at ASC, l.id ASC
             LIMIT 1)
         ) AS it_status_at
    FROM public.csr_verifications v
   WHERE v.it_status_at IS NULL
)
UPDATE public.csr_verifications v
   SET it_status_at = g.it_status_at
  FROM guess g
 WHERE v.id = g.verif_id
   AND g.it_status_at IS NOT NULL;

-- ── 확인 — 채운 건수 · 빈칸(로그 없는 이관분) 건수 · 값 분포 ────────────────────
SELECT count(*) AS total,
       count(it_status_at) AS filled,
       count(*) - count(it_status_at) AS blank_no_log
  FROM public.csr_verifications;

SELECT COALESCE(it_status_at, '(빈칸)') AS it_status_at, count(*) AS rows
  FROM public.csr_verifications
 GROUP BY 1
 ORDER BY 2 DESC;
