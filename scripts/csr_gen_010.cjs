/**
 * db/010_body_translations.sql 생성기
 *
 *   node scripts/csr_gen_010.cjs
 *
 * 입력
 *   import/out/bodies_20260910.json        — Data API 로 내려받은 63건의 본문 3종(원문)
 *   import/translations/batch_*.json       — 번역(2026-09-10, Claude 번역 · 검수 대상)
 *     { "01": { "findings_md_ko": "...", "findings_md_id": "..." , ... } }
 *     키를 생략하면 원문 언어 쪽 컬럼은 원문 그대로 들어갑니다.
 *
 * 출력: 순수 SQL — 달러 인용($$) 없음. Neon SQL Editor 가 $$ 블록을 문장 단위로 쪼개
 *       v1·v2 의 008 이 적용되지 않았던 전례 때문입니다(2026-09-10).
 *
 * 왜 컬럼을 6개 더 두는가: 본문은 Notion 원문이 이슈당 한 언어(한국어 37 · 인니어 26)였습니다.
 * 기존 findings_md 등은 그대로 두고(원문 보존, §8) _ko/_id 쌍을 추가해 화면이 토글 언어
 * 쪽을 고르게 합니다. 화면은 쌍이 비어 있으면 원문 컬럼으로 되돌아갑니다.
 */
const fs = require('fs')
const path = require('path')

const ROOT = path.resolve(__dirname, '..')
const bodies = JSON.parse(fs.readFileSync(path.join(ROOT, 'import/out/bodies_20260910.json'), 'utf8'))
const dir = path.join(ROOT, 'import/translations')
const tr = {}
for (const f of fs.readdirSync(dir).filter((x) => /^batch_.*\.json$/.test(x)).sort()) {
  Object.assign(tr, JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8')))
}

const BODIES = ['findings_md', 'recommendation_md', 'business_answer_md']
const q = (s) => (s == null ? 'NULL' : `'${String(s).replace(/'/g, "''")}'`)
const hasKo = (s) => /[가-힣]/.test(s ?? '')

const lines = []
lines.push(`-- =============================================================================
-- ASM CSR — 본문 3종 한국어·인도네시아어 쌍 (2026-09-10 「sql 009 번역 추가」 → 010)
--   001~009 + **011** 적용 후 실행(011 없이는 콘솔의 UPDATE 가 가드에 막혀 ERROR). 재실행 안전.
--   생성: node scripts/csr_gen_010.cjs  (번역 원본: import/translations/batch_*.json)
--
-- 본문(현상 · 개선 의견 · 현업 답변)은 Notion 원문이 이슈당 한 언어였습니다(한국어 37 ·
-- 인니어 26). 원문 컬럼(findings_md 등)은 그대로 두고 _ko/_id 쌍을 추가합니다. 원문 언어 쪽에는
-- 원문을, 반대쪽에는 번역을 넣습니다. 번역은 Claude 가 했고 검수 대상입니다 — 화면 편집으로
-- 언제든 고칠 수 있습니다(현업·admin).
-- =============================================================================

ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS findings_md_ko        text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS findings_md_id        text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS recommendation_md_ko  text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS recommendation_md_id  text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS business_answer_md_ko text;
ALTER TABLE public.csr_issues ADD COLUMN IF NOT EXISTS business_answer_md_id text;
COMMENT ON COLUMN public.csr_issues.findings_md_ko IS '2. 현상 — 한국어. 비어 있으면 화면은 findings_md 로 되돌아감';
COMMENT ON COLUMN public.csr_issues.findings_md_id IS '2. Temuan — Bahasa Indonesia';
`)

let n = 0
const missing = []
for (const r of bodies) {
  if (r.is_archived) continue
  const t = tr[r.issue_no] ?? {}
  const src = hasKo(r.findings_md) ? 'ko' : 'id'
  const other = src === 'ko' ? 'id' : 'ko'
  const set = []
  for (const c of BODIES) {
    if (!r[c]) continue // 원문이 없으면(현업 답변 미기재) 쌍도 비워 둡니다.
    const own = t[`${c}_${src}`] ?? r[c]
    const trans = t[`${c}_${other}`]
    if (trans == null) missing.push(`${r.issue_no}.${c}_${other}`)
    set.push(`${c}_${src} = ${q(own)}`)
    set.push(`${c}_${other} = ${q(trans ?? null)}`)
  }
  if (!set.length) continue
  n++
  lines.push(`-- ${r.issue_no} (원문 ${src.toUpperCase()})
UPDATE public.csr_issues SET
  ${set.join(',\n  ')}
WHERE issue_no = '${r.issue_no}' AND NOT is_archived;
`)
}

lines.push(`-- 확인 — 살아 있는 60건 모두 양쪽이 채워져야 합니다(현업 답변은 원문이 있는 건만).
SELECT count(*) AS total,
       count(*) FILTER (WHERE findings_md_ko IS NULL OR findings_md_id IS NULL)             AS findings_missing,
       count(*) FILTER (WHERE recommendation_md_ko IS NULL OR recommendation_md_id IS NULL) AS reco_missing,
       count(*) FILTER (WHERE business_answer_md IS NOT NULL
                          AND (business_answer_md_ko IS NULL OR business_answer_md_id IS NULL)) AS answer_missing
  FROM public.csr_issues WHERE NOT is_archived;
`)

const out = path.join(ROOT, 'db/010_body_translations.sql')
fs.writeFileSync(out, lines.join('\n'))
console.log(`wrote ${out} — UPDATE ${n}건, 누락 번역 ${missing.length}건${missing.length ? '\n  ' + missing.join('\n  ') : ''}`)
