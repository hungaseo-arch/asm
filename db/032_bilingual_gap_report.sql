-- =============================================================================
-- ASM CSR — 한·인니 번역 쌍 누락 점검 (읽기 전용 · 2026-09-19, 규칙 보정 2026-09-19)
--   목적: /csr/nn 상세 70건이 국기 토글로 완전히 전환되려면 아래 컬럼 쌍이 모두 채워져야 합니다.
--         이 스크립트는 아무것도 바꾸지 않습니다 — 결과(4개 SELECT)를 그대로 복사해 주시면
--         누락분 번역 SQL(03x_fill)을 만들어 드립니다.
--   판정 규칙:
--     · 원문이 있는데 _ko 또는 _id 가 비어 있음 → MISSING_KO / MISSING_ID
--     · _ko 에 한글이 없음 / _id 가 통째로 한국어 → WRONG_LANG (020 의 27번 이력처럼 양쪽이 같은 언어)
--   빈칸 표기(2026-09-19 보정): '—' · '-' · 'N/A' · '(미기재)' · '(tidak dicantumkan)' · '(없음)' 는
--     비어 있는 것으로 봅니다 — 화면 isBlank 와 같은 판단입니다. 처음에는 §3 에만 있어 §1 의
--     06·23 business_answer_md('- —')와 §3 의 08·14·38 fix_plan('N/A')이 누락으로 잡혔습니다.
--   인니어 속 한글(2026-09-19 보정): 한글이 조금이라도 있으면 WRONG_LANG 이던 규칙을,
--     전체 길이의 10%를 넘을 때만 잡도록 바꿨습니다. 인니어 본문이 한국어 UI 문구를 인용하는
--     정상 번역(15 findings_md 의 '연도-월-일', 14·15 검증 이력의 '----년 --월')이 걸리던 오탐입니다.
--     양쪽이 같은 언어인 진짜 사고는 한글 비중이 100% 에 가까우므로 그대로 잡힙니다.
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
  -- src 가 NULL 인 항목(title·summary·acceptance·it_reply_summary)은 원문 컬럼이 따로 없습니다 — 쌍이 곧 전부입니다.
  SELECT issue_no, 'title'          AS col, NULL::text AS src, title_ko  AS ko, title_id  AS id, true    AS has_src FROM i
  UNION ALL SELECT issue_no, 'summary',        NULL,               summary_ko,           summary_id,           (summary_ko IS NOT NULL OR summary_id IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'acceptance',     NULL,               acceptance_ko,        acceptance_id,        (acceptance_ko IS NOT NULL OR acceptance_id IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'findings_md',    findings_md,        findings_md_ko,       findings_md_id,       (findings_md IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'recommendation_md', recommendation_md, recommendation_md_ko, recommendation_md_id, (recommendation_md IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'business_answer_md', business_answer_md, business_answer_md_ko, business_answer_md_id, (business_answer_md IS NOT NULL) FROM i
  UNION ALL SELECT issue_no, 'it_reply_summary', NULL,             it_reply_summary_ko,  it_reply_summary_id,  (it_reply_summary_ko IS NOT NULL OR it_reply_summary_id IS NOT NULL) FROM i
), flagged AS (
  SELECT issue_no, col, ko, id,
         -- 번역할 것이 없는 행: 원문이 빈칸 표기이거나, 원문 컬럼이 없는데 쌍이 양쪽 다 빈칸 표기.
         (btrim(coalesce(src, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS src_blank,
         (src IS NULL) AS no_src_col,
         (btrim(coalesce(ko, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS ko_blank,
         (btrim(coalesce(id, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS id_blank,
         (ko !~ '[가-힣]') AS ko_not_korean,
         -- 인용이 아니라 통째로 한국어일 때만: 한글이 전체 길이의 10% 초과
         (length(regexp_replace(coalesce(id, ''), '[^가-힣]', '', 'g')) * 10 > length(coalesce(id, ''))) AS id_is_korean
    FROM chk WHERE has_src
)
SELECT issue_no, col,
       CASE
         WHEN ko_blank THEN 'MISSING_KO'
         WHEN id_blank THEN 'MISSING_ID'
         ELSE 'WRONG_LANG'
       END AS gap,
       left(ko, 60) AS ko_head, left(id, 60) AS id_head
  FROM flagged
 WHERE NOT (CASE WHEN no_src_col THEN ko_blank AND id_blank ELSE src_blank END)
   AND (ko_blank OR id_blank OR ko_not_korean OR id_is_korean)
 ORDER BY issue_no, col;

-- ── 2. 검증 이력 (csr_verifications) — 원문 note 가 있는 행 ─────────────────────
WITH v AS (
  SELECT i.issue_no, v.id AS verif_id, v.verified_on, v.result, v.created_by,
         v.note, v.note_ko, v.note_id,
         (btrim(coalesce(v.note_ko, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS ko_blank,
         (btrim(coalesce(v.note_id, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS id_blank,
         (v.note_ko !~ '[가-힣]') AS ko_not_korean,
         (length(regexp_replace(coalesce(v.note_id, ''), '[^가-힣]', '', 'g')) * 10 > length(coalesce(v.note_id, ''))) AS id_is_korean
    FROM public.csr_verifications v
    JOIN public.csr_issues i ON i.id = v.issue_id AND NOT i.is_archived
   WHERE btrim(coalesce(v.note, v.note_ko, v.note_id, '')) <> ''
)
SELECT issue_no, verif_id, verified_on, result, created_by,
       CASE
         WHEN ko_blank THEN 'MISSING_KO'
         WHEN id_blank THEN 'MISSING_ID'
         ELSE 'WRONG_LANG'
       END AS gap,
       note                        AS note_src,      -- 원문 전체(번역 작성용 — 잘라내지 않음)
       left(note_ko, 40) AS ko_head, left(note_id, 40) AS id_head
  FROM v
 WHERE ko_blank OR id_blank OR ko_not_korean OR id_is_korean
 ORDER BY issue_no, verified_on, verif_id;

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
), flagged AS (
  SELECT issue_no, reply_id, replied_on, col, src, ko, id,
         (btrim(coalesce(ko, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS ko_blank,
         (btrim(coalesce(id, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$') AS id_blank,
         (ko !~ '[가-힣]') AS ko_not_korean,
         (length(regexp_replace(coalesce(id, ''), '[^가-힣]', '', 'g')) * 10 > length(coalesce(id, ''))) AS id_is_korean
    FROM r
   WHERE btrim(coalesce(src, ko, id, '')) <> ''
     -- 원문 자체가 빈칸 표기면 번역할 것이 없습니다.
     AND btrim(coalesce(src, ko, id, '')) !~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$'
)
SELECT issue_no, reply_id, replied_on, col,
       CASE
         WHEN ko_blank THEN 'MISSING_KO'
         WHEN id_blank THEN 'MISSING_ID'
         ELSE 'WRONG_LANG'
       END AS gap,
       src AS text_src, left(ko, 40) AS ko_head, left(id, 40) AS id_head
  FROM flagged
 WHERE ko_blank OR id_blank OR ko_not_korean OR id_is_korean
 ORDER BY issue_no, replied_on, reply_id, col;

-- ── 4. 요약 건수 ────────────────────────────────────────────────────────────────
SELECT 'verifications' AS tbl, count(*) AS gap_rows
  FROM public.csr_verifications v JOIN public.csr_issues i ON i.id = v.issue_id AND NOT i.is_archived
 WHERE btrim(coalesce(v.note, v.note_ko, v.note_id, '')) <> ''
   AND (btrim(coalesce(v.note_ko, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$'
        OR btrim(coalesce(v.note_id, '')) ~* '^([[:space:]—–-]*|n/?a|\((tidak dicantumkan|미기재|없음)\))$'
        OR v.note_ko !~ '[가-힣]'
        OR length(regexp_replace(coalesce(v.note_id, ''), '[^가-힣]', '', 'g')) * 10 > length(coalesce(v.note_id, '')))
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
