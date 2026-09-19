-- =============================================================================
-- ASM CSR — 검증 시점 IT 상태 보완 백필 (2026-09-19, 036 후속)
--   증상: 036 을 넣었는데 §7 검증 이력의 「IT상태」 열이 거의 다 빈칸(예: /csr/67).
--   원인: csr_status_log 는 015c 트리거가 **UPDATE 때만** 적재합니다. Notion 이관 당시
--         INSERT 로 들어온 it_status 는 로그에 없고, 이후 한 번도 안 바뀐 이슈는
--         it_status 로그 행이 아예 0건 → 036 의 역산이 양쪽 다 NULL 을 돌려줍니다.
--   보완: **it_status 변경 로그가 0건인 이슈**는 트리거 도입 이후 상태가 바뀐 적이 없다는
--         뜻이므로, 그 이슈의 현재 it_status 가 곧 당시 값입니다 — 추정이 아니라 도출입니다.
--         (로그가 있는 이슈는 036 의 시점 역산이 이미 정답을 넣었으므로 건드리지 않습니다.)
--   실행: Neon 콘솔 SQL Editor (asm-csm · production). 036 다음. 재실행 안전.
-- =============================================================================

SELECT set_config('csr.actor', 'migration:037 (2026-09-19 검증 시점 IT 상태 보완)', false);

UPDATE public.csr_verifications v
   SET it_status_at = i.it_status
  FROM public.csr_issues i
 WHERE i.id = v.issue_id
   AND v.it_status_at IS NULL
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_status_log l
      WHERE l.issue_id = v.issue_id AND l.column_name = 'it_status'
   );

-- ── 확인 — 남은 빈칸은 '로그는 있는데 시점 역산이 안 되는' 예외뿐이어야 합니다 ──────
SELECT count(*) AS total,
       count(it_status_at) AS filled,
       count(*) - count(it_status_at) AS still_blank
  FROM public.csr_verifications;

SELECT COALESCE(it_status_at, '(빈칸)') AS it_status_at, count(*) AS rows
  FROM public.csr_verifications GROUP BY 1 ORDER BY 2 DESC;
