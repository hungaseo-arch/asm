/**
 * db/014_sub_translations.sql 생성기 — 검증 이력 · IT 회신의 KO/ID 쌍
 *
 *   node scripts/csr_gen_014.cjs
 *
 * 입력
 *   import/out/sub_20260910.json              — Data API 로 내려받은 csr_verifications · csr_it_replies 원문
 *   import/translations/sub_verifications.json — { "<id>": { note_ko | note_id } }
 *   import/translations/sub_replies.json       — { "<id>": { fix_plan_ko|id, note_ko|id, needs_decision_ko|id, pic_and_target_ko|id } }
 *     키를 생략하면 원문 언어 쪽 컬럼에 원문이 들어가고, 반대쪽은 번역이 필요합니다(없으면 경고).
 *
 * 왜 쌍인가: 010 과 같은 이유 — 원문이 행마다 한 언어(검증 105 KO / 41 ID, 회신 37 KO / 5 ID).
 * 원문 컬럼은 보존하고 _ko/_id 를 덧붙입니다. 화면은 토글 언어 → 반대쪽 → 원문 순으로 되돌아갑니다.
 * 결과(result)·수용 여부(decision)처럼 값이 정해진 항목은 컬럼을 늘리지 않고 i18n.js 의 용어 사전으로
 * 표시만 바꿉니다.
 */
const fs = require('fs')
const path = require('path')

const ROOT = path.resolve(__dirname, '..')
const sub = JSON.parse(fs.readFileSync(path.join(ROOT, 'import/out/sub_20260910.json'), 'utf8'))
const trV = JSON.parse(fs.readFileSync(path.join(ROOT, 'import/translations/sub_verifications.json'), 'utf8'))
const trR = JSON.parse(fs.readFileSync(path.join(ROOT, 'import/translations/sub_replies.json'), 'utf8'))

const q = (s) => (s == null ? 'NULL' : `'${String(s).replace(/'/g, "''")}'`)
const hasKo = (s) => /[가-힣]/.test(s ?? '')
const missing = []

const lines = [
  `-- =============================================================================
-- ASM CSR — 검증 이력 · IT 회신 본문의 KO/ID 쌍 (2026-09-10)
--   001~013 적용 후 실행. 달러 인용 없음. 재실행 안전(같은 값 덮어씀).
--   생성: node scripts/csr_gen_014.cjs
--
-- 원문 컬럼(note · fix_plan …)은 그대로 두고 _ko/_id 를 추가합니다. 번역은 Claude(검수 대상 —
-- 담당 서종환). 결과(result)·수용 여부(decision)는 컬럼을 늘리지 않고 화면의 용어 사전으로 표시합니다.
-- =============================================================================

ALTER TABLE public.csr_verifications ADD COLUMN IF NOT EXISTS note_ko text;
ALTER TABLE public.csr_verifications ADD COLUMN IF NOT EXISTS note_id text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS fix_plan_ko       text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS fix_plan_id       text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS note_ko           text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS note_id           text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS needs_decision_ko text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS needs_decision_id text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS pic_and_target_ko text;
ALTER TABLE public.csr_it_replies ADD COLUMN IF NOT EXISTS pic_and_target_id text;
`,
]

// 검증 이력 — note 한 컬럼. 원문 언어 판정은 note 로.
let nv = 0
for (const v of sub.verifications) {
  if (!v.note) continue
  const src = hasKo(v.note) ? 'ko' : 'id'
  const other = src === 'ko' ? 'id' : 'ko'
  const t = trV[v.id] ?? {}
  const own = t[`note_${src}`] ?? v.note
  const trans = t[`note_${other}`]
  if (trans == null) missing.push(`verification ${v.id} note_${other}`)
  lines.push(
    `UPDATE public.csr_verifications SET note_${src} = ${q(own)}, note_${other} = ${q(trans ?? null)} WHERE id = ${v.id};`,
  )
  nv++
}
lines.push('')

// IT 회신 — 4개 텍스트 컬럼. 원문 언어 판정은 행 전체(fix_plan+note+needs_decision)로.
const COLS = ['fix_plan', 'note', 'needs_decision', 'pic_and_target']
let nr = 0
for (const r of sub.replies) {
  const blob = COLS.map((c) => r[c] ?? '').join(' ')
  const src = hasKo(blob) ? 'ko' : 'id'
  const other = src === 'ko' ? 'id' : 'ko'
  const t = trR[r.id] ?? {}
  const set = []
  for (const c of COLS) {
    if (r[c] == null) continue
    const own = t[`${c}_${src}`] ?? r[c]
    const trans = t[`${c}_${other}`]
    if (trans == null) missing.push(`reply ${r.id} ${c}_${other}`)
    set.push(`${c}_${src} = ${q(own)}`, `${c}_${other} = ${q(trans ?? null)}`)
  }
  if (!set.length) continue
  lines.push(`UPDATE public.csr_it_replies SET ${set.join(', ')} WHERE id = ${r.id};`)
  nr++
}

lines.push(`
-- 확인 — 누락 0 이어야 합니다.
SELECT (SELECT count(*) FROM public.csr_verifications WHERE note IS NOT NULL AND (note_ko IS NULL OR note_id IS NULL)) AS verif_missing,
       (SELECT count(*) FROM public.csr_it_replies WHERE note IS NOT NULL AND (note_ko IS NULL OR note_id IS NULL))     AS reply_missing;
`)

const out = path.join(ROOT, 'db/014_sub_translations.sql')
fs.writeFileSync(out, lines.join('\n'))
console.log(`wrote ${out} — 검증 ${nv}행 · 회신 ${nr}행 · 누락 번역 ${missing.length}${missing.length ? '\n  ' + missing.join('\n  ') : ''}`)
