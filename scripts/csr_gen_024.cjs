/**
 * db/024_v2_sync.sql 생성기 — 개선요청서 v2(2026-09-14) 와 사이트 정합화
 *
 *   node scripts/csr_gen_024.cjs
 *
 * 입력
 *   import/v2/v2_issues.json              — hwpx 에서 뽑은 이슈 39~68 (번호 · 제목 · 심각도 · 현상 · 개선 의견, 한국어 원문)
 *   import/translations/v2_61_68.json      — 61~68 등록 속성 + 인니어 번역, 57 본문 인니어
 * 출력
 *   db/024_v2_sync.sql                     — 61~68 INSERT(+검증 이력) · 57 본문 교체 · 57~59 담당자 SEO
 *
 * 왜 SQL 인가: 등록·정정은 콘솔에서 사람이 실행합니다(uploaded_by/created_by 를 'v2-doc' 으로 남김). 재실행 안전.
 */
const fs = require('fs')
const path = require('path')
const ROOT = path.resolve(__dirname, '..')
const issues = JSON.parse(fs.readFileSync(path.join(ROOT, 'import/v2/v2_issues.json'), 'utf8'))
const tr = JSON.parse(fs.readFileSync(path.join(ROOT, 'import/translations/v2_61_68.json'), 'utf8'))
const q = (s) => (s == null ? 'NULL' : `'${String(s).replace(/'/g, "''")}'`)
const byNo = Object.fromEntries(issues.map((i) => [i.no, i]))

const out = [`-- =============================================================================
-- v2 개선요청서(ASM_테스트결과_개선요청서_v2.hwpx, 2026-09-14) 정합화
--   021~023 적용 후 실행. 달러 인용 없음. 재실행 안전(이미 있으면 건너뜀 · 같은 값 덮어씀).
--   생성: node scripts/csr_gen_024.cjs
--
--   1. 이슈 61~68 등록(Komang, Legal · Finance & Adm, 2026-09-11 접수) + 검증 이력 1행(PENDING · 최초 접수)
--      한국어 현상·개선 의견은 문서 원문 그대로, 인니어·요약·수용기준은 Claude 번역/초안 — 검수 서종환.
--   2. 57 현상·개선 의견을 문서 본문으로 교체(절사 내용 제거 — 이슈 12 중복). 이슈번호 변경 기록은 유지.
--   3. 57 · 58 · 59 담당자 → SEO (문서: v1 업무 요건 이관분 담당 SEO).
-- =============================================================================

SELECT set_config('csr.actor', 'migration:024 (v2 정합화)', false);
`]

// 1. 61~68
for (const no of ['61', '62', '63', '64', '65', '66', '67', '68']) {
  const d = byNo[no]
  const t = tr[no]
  const c = tr.common
  if (!d || !t) throw new Error('missing ' + no)
  out.push(`-- ── ${no} ──
INSERT INTO public.csr_issues (
  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,
  go_live_category, request_dept, requested_on, summary_ko, summary_id,
  acceptance_ko, acceptance_id, related_issues, role_split,
  it_status, it_pic, it_decision, verification_result,
  findings_md, findings_md_ko, findings_md_id,
  recommendation_md, recommendation_md_ko, recommendation_md_id,
  is_archived, updated_by
)
SELECT
  ${q(no)}, ${q(`${no}. ${d.title}`)}, ${q(`${no}. ${t.title_id}`)},
  ${q(t.menu_main)}, ${q(t.menu_sub)}, ${q(t.path_menu)}, ${q(t.issue_type)}, ${q(t.priority)},
  ${q(t.go_live_category)}, ${q(c.request_dept)}, DATE '${c.requested_on}', ${q(t.summary_ko)}, ${q(t.summary_id)},
  ${q(t.acceptance_ko)}, ${q(t.acceptance_id)}, ${q(t.related_issues)}, ${q(c.role_split)},
  'Open', ${q(c.it_pic)}, '미회신 / Belum Ada Balasan', 'PENDING',
  ${q(d.findings)}, ${q(d.findings)}, ${q(t.findings_id)},
  ${q(d.recommendation)}, ${q(d.recommendation)}, ${q(t.recommendation_id)},
  false, 'v2-doc'
WHERE NOT EXISTS (SELECT 1 FROM public.csr_issues WHERE issue_no = ${q(no)});

INSERT INTO public.csr_verifications (issue_id, verified_on, result, result_legacy, note, note_ko, note_id, created_by)
SELECT i.id, DATE '${c.requested_on}', 'PENDING', '최초 접수', ${q(c.verify_note_id)}, ${q(c.verify_note_ko)}, ${q(c.verify_note_id)}, 'v2-doc'
  FROM public.csr_issues i
 WHERE i.issue_no = ${q(no)} AND NOT EXISTS (SELECT 1 FROM public.csr_verifications v WHERE v.issue_id = i.id);
`)
}

// 2. 57 본문 교체 (이슈번호 변경 기록 유지)
const d57 = byNo['57']
const hist57 = `

# 0. 이슈번호 변경 기록

- 2026-09-09: VIII-3 (세무 정합성) → 이슈 60(초안) → **이슈 57** (v1 중복 3건 삭제 후 재채번, 2026-09-09). 반올림(절사) 로직 부분은 이슈 12와 중복이라 삭제하고 세율 마스터 관리 요청만 유지.`
out.push(`-- ── 57 본문 교체 ──
UPDATE public.csr_issues
   SET findings_md          = ${q(d57.findings + hist57)},
       findings_md_ko       = ${q(d57.findings + hist57)},
       findings_md_id       = ${q(tr['57_update'].findings_id)},
       recommendation_md    = ${q(d57.recommendation)},
       recommendation_md_ko = ${q(d57.recommendation)},
       recommendation_md_id = ${q(tr['57_update'].recommendation_id)}
 WHERE issue_no = '57' AND NOT is_archived;

-- ── 57 · 58 · 59 담당자 SEO (문서 기준) ──
UPDATE public.csr_issues SET it_pic = 'SEO' WHERE issue_no IN ('57', '58', '59') AND NOT is_archived AND it_pic IS DISTINCT FROM 'SEO';

-- 확인 — 61~68 8행(PENDING · 09-11 · 이력 1) · 57~60 담당자 SEO
SELECT issue_no, priority, menu_main, menu_sub, it_pic, verification_result, verified_on,
       (SELECT count(*) FROM public.csr_verifications v WHERE v.issue_id = i.id) AS verif_rows
  FROM public.csr_issues i WHERE issue_no IN ('57','58','59','60','61','62','63','64','65','66','67','68') AND NOT is_archived
 ORDER BY issue_no;
SELECT count(*) AS total_live FROM public.csr_issues WHERE NOT is_archived;
`)
const dst = path.join(ROOT, 'db/024_v2_sync.sql')
fs.writeFileSync(dst, out.join('\n'))
console.log('wrote', path.relative(ROOT, dst), out.join('\n').length, 'chars')
