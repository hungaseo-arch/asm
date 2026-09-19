-- =============================================================================
-- ASM CSR — 한·인니 번역 쌍 누락 점검 (읽기 전용 · 2026-09-19)
--   목적: /csr/nn 상세 70건이 국기 토글로 완전히 전환되려면 아래 컬럼 쌍이 모두 채워져야 합니다.
--         이 스크립트는 아무것도 바꾸지 않습니다 — 결과(3개 SELECT)를 그대로 복사해 주시면
--         누락분 번역 SQL(03x_fill)을 만들어 드립니다.
--   판정 규칙:
--     · 원문이 있는데 _ko 또는 _id 가 비어 있음 → MISSING_KO / MISSING_ID
--     · _ko 에 한글이 없음 / _id 에 한글이 섞여 있음 → WRONG_LANG (020 의 27번 이력처럼 양쪽이 같은 언어)
--   실행: Neon 콘솔 SQL Editor (asm-csm · production). 재실행 무해.
-- =============================================================================

-- ── 1. 이슈 헤더·본문 (csr_issues) — 활성 70건 ────────────────────────────────
WITH i AS (
  SELECT id, issue_no,
         title_ko, title_id, summary_ko, summary_id, acceptance_ko, acceptance_id,
         findings_md, findings_md_ko, findings_md_id,
         recommendation_md, recommendation_md_ko, recommendation_md_id,
         business_answer_md, business_answer_md_ko, business_answer_md_id,
         it_reply_summary_ko, it_reply_summary_id
    FROM public.csr_issues
   WHERE NOT is_archived
), chk AS (
  SELECT issue_no, 'title'          AS col, title_ko            AS ko, title_id            AS id, true                        AS has_src FROM i
  UNION ALL SELECT issue_no, 'summary',        summary_ko,           summary_id,           (summary_ko IS NOT NULL OR summary_id IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'acceptance',     acceptance_ko,        acceptance_id,        (acceptance_ko IS NOT NULL OR acceptance_id IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'findings_md',    findings_md_ko,       findings_md_id,       (findings_md IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'recommendation_md', recommendation_md_ko, recommendation_md_id, (recommendation_md IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'business_answer_md', business_answer_md_ko, business_answer_md_id, (business_answer_md IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'it_reply_summary', it_reply_summary_ko, it_reply_summary_id, (it_reply_summary_ko IS NOT NULL OR it_reply_summary_id IS NOT NULL) FROM i
)
SELECT issue_no, col,
       CASE
         WHEN NOT has_src THEN NULL
         WHEN btrim(coalesce(ko, '')) = '' THEN 'MISSING_KO'
         WHEN btrim(coalesce(id, '')) = '' THEN 'MISSING_ID'
         WHEN ko !~ '[가-힣]' OR id ~ '[가-힣]' THEN 'WRONG_LANG'
       END AS gap,
       left(ko, 60) AS ko_head, left(id, 60) AS id_head
  FROM chk
 WHERE has_src
   AND (btrim(coalesce(ko, '')) = '' OR btrim(coalesce(id, '')) = '' OR ko !~ '[가-힣]' OR id ~ '[가-힣]')
 ORDER BY issue_no, col;

-- ── 2. 검증 이력 (csr_verifications) — 원문 note 가 있는 행 ─────────────────────
SELECT i.issue_no, v.id AS verif_id, v.verified_on, v.result, v.created_by,
       CASE
         WHEN btrim(coalesce(v.note_ko, '')) = '' THEN 'MISSING_KO'
         WHEN btrim(coalesce(v.note_id, '')) = '' THEN 'MISSING_ID'
         WHEN v.note_ko !~ '[가-힣]' OR v.note_id ~ '[가-힣]' THEN 'WRONG_LANG'
       END AS gap,
       v.note                       AS note_src,      -- 원문 전체(번역 작성용 — 잘라내지 않음)
       left(v.note_ko, 40) AS ko_head, left(v.note_id, 40) AS id_head
  FROM public.csr_verifications v
  JOIN public.csr_issues i ON i.id = v.issue_id AND NOT i.is_archived
 WHERE btrim(coalesce(v.note, v.note_ko, v.note_id, '')) <> ''
   AND (btrim(coalesce(v.note_ko, '')) = '' OR btrim(coalesce(v.note_id, '')) = ''
        OR v.note_ko !~ '[가-힣]' OR v.note_id ~ '[가-힣]')
 ORDER BY i.issue_no, v.verified_on, v.id;

-- ── 3. IT부서 회신 (csr_it_replies) — 자유 텍스트 4항목 ─────────────────────────
WITH r AS (
  SELECT i.issue_no, r.id AS reply_id, r.replied_on, c.col, c.src, c.ko, c.id
    FROM public.csr_it_replies r
    JOIN public.csr_issues i ON i.id = r.issue_id AND NOT i.is_archived
    CROSS JOIN LATERAL (VALUES
      ('fix_plan',       r.fix_plan,       r.fix_plan_ko,       r.fix_plan_id),
      ('note',           r.note,           r.note_ko,           r.note_id),
      ('needs_decision', r.needs_decision, r.needs_decision_ko, r.needs_decision_id),
      ('pic_and_target', r.pic_and_target, r.pic_and_target_ko, r.pic_and_target_id)
    ) AS c(col, src, ko, id)
)
SELECT issue_no, reply_id, replied_on, col,
       CASE
         WHEN btrim(coalesce(ko, '')) = '' THEN 'MISSING_KO'
         WHEN btrim(coalesce(id, '')) = '' THEN 'MISSING_ID'
         WHEN ko !~ '[가-힣]' OR id ~ '[가-힣]' THEN 'WRONG_LANG'
       END AS gap,
       src AS text_src, left(ko, 40) AS ko_head, left(id, 40) AS id_head
  FROM r
 WHERE btrim(coalesce(src, ko, id, '')) <> ''
   -- Notion 이관분의 빈칸 표기('—' · '-' · '(미기재)' · '(tidak dicantumkan)')는 빈 것으로 봅니다(화면 isBlank 와 동일).
   AND btrim(coalesce(src, ko, id, '')) !~ '^[[:space:]—–-]*$|^\((tidak dicantumkan|미기재|없음)\)$'
   AND (btrim(coalesce(ko, '')) = '' OR btrim(coalesce(id, '')) = '' OR ko !~ '[가-힣]' OR id ~ '[가-힣]')
 ORDER BY issue_no, replied_on, reply_id, col;

-- ── 4. 요약 건수 ────────────────────────────────────────────────────────────────
SELECT 'verifications' AS tbl, count(*) AS gap_rows
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id AND NOT i.is_archived
 WHERE btrim(coalesce(v.note, v.note_ko, v.note_id, '')) <> ''
   AND (btrim(coalesce(v.note_ko, '')) = '' OR btrim(coalesce(v.note_id, '')) = '' OR v.note_ko !~ '[가-힣]' OR v.note_id ~ '[가-힣]')
UNION ALL
SELECT 'issues.findings_md', count(*) FROM public.csr_issues
 WHERE NOT is_archived AND findings_md IS NOT NULL
   AND (btrim(coalesce(findings_md_ko, '')) = '' OR btrim(coalesce(findings_md_id, '')) = '')
UNION ALL
SELECT 'issues.recommendation_md', count(*) FROM public.csr_issues
 WHERE NOT is_archived AND recommendation_md IS NOT NULL
   AND (btrim(coalesce(recommendation_md_ko, '')) = '' OR btrim(coalesce(recommendation_md_id, '')) = '')
UNION ALL
SELECT 'issues.business_answer_md', count(*) FROM public.csr_issues
 WHERE NOT is_archived AND business_answer_md IS NOT NULL
   AND (btrim(coalesce(business_answer_md_ko, '')) = '' OR btrim(coalesce(business_answer_md_id, '')) = '');
