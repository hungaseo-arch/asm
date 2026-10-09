/**
 * 261008 개선요청서 캡쳐 → db/043_attachments_261008.sql
 *
 *   node scripts/csr_gen_043.cjs
 *
 * 입력  import/out/captures_261008_manifest.json  (csr_migrate_captures.mjs 가 Drive 업로드 후 남김)
 * 출력  db/043_attachments_261008.sql             (콘솔에서 실행, 재실행 안전)
 *
 * 왜 csr_migrate_captures.mjs 의 생성기를 그대로 쓰지 않는가 ───────────────────
 * 문서가 「동일 화면이라 캡쳐 생략」이라고 적은 79 · 80 · 81(78과 동일) · 99(98과 동일) 에도
 * 같은 이미지를 붙이기로 했습니다(2026-10-09 결정). 그러면 한 fileId 가 여러 이슈에 쓰이는데,
 * 기존 생성기의 중복 가드는 drive_file_id 만 보기 때문에 두 번째 이슈부터 건너뜁니다.
 * 여기서는 (issue_no, drive_file_id) 쌍으로 가드합니다.
 */
const fs = require('node:fs')
const path = require('node:path')

const ROOT = path.resolve(__dirname, '..')
const MANIFEST = path.join(ROOT, 'import/out/captures_261008_manifest.json')
const OUT_SQL = path.join(ROOT, 'db/043_attachments_261008.sql')
const BY = '261008-doc'

/** 캡쳐가 없는 이슈 → 같은 화면을 쓰는 이슈의 캡쳐를 재사용 (문서 「동일 화면・캡쳐 생략」). */
const SHARED = { 79: '78', 80: '78', 81: '78', 99: '98' }

if (!fs.existsSync(MANIFEST)) {
  console.error(`매니페스트가 없습니다 — 먼저 업로드하십시오:\n  ${path.relative(ROOT, MANIFEST)}`)
  process.exit(1)
}
const manifest = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'))
const byIssue = new Map()
for (const [file, m] of Object.entries(manifest)) byIssue.set(String(m.issueNo), { file, ...m })

const rows = []
for (const [file, m] of Object.entries(manifest)) rows.push({ issueNo: String(m.issueNo), file, fileId: m.fileId, shared: null })
for (const [issueNo, from] of Object.entries(SHARED)) {
  const src = byIssue.get(from)
  if (!src) {
    console.warn(`  건너뜀 ${issueNo} — 원본 이슈 ${from} 캡쳐가 매니페스트에 없습니다`)
    continue
  }
  rows.push({ issueNo, file: src.file, fileId: src.fileId, shared: from })
}
rows.sort((a, b) => Number(a.issueNo) - Number(b.issueNo))

const q = (s) => `'${String(s).replace(/'/g, "''")}'`
const out = [
  `-- =============================================================================
-- ASM CSR — 261008 개선요청서 캡쳐 ${rows.length}건 → csr_attachments
--   생성: node scripts/csr_gen_043.cjs   (Drive 업로드는 csr_migrate_captures.mjs 가 이미 끝냄)
--   040 · 042 적용 후 실행. 재실행 안전(같은 이슈에 같은 drive_file_id 가 있으면 건너뜀).
--   실행 : Neon 콘솔 SQL Editor (asm-csm · production), 파일 전체를 한 번에 실행
--
--   문서 수록 캡쳐 23장(75 · 77 · 78 · 82 ~ 98 · 100 ~ 102) + 동일 화면 재사용 4건
--   (79 · 80 · 81 ← 78, 99 ← 98). 76 은 문서에 「요청자 캡처 없음」.
-- =============================================================================
`,
]
for (const r of rows) {
  out.push(`-- ${r.issueNo}${r.shared ? ` (이슈 ${r.shared} 과 동일 화면)` : ''}
INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, ${q(r.fileId)}, ${q(r.file)}, ${r.shared ? q(`이슈 ${r.shared} 캡쳐와 동일 화면`) : 'NULL'}, 0, ${q(BY)}
  FROM public.csr_issues i
 WHERE i.issue_no = ${q(r.issueNo)} AND NOT i.is_archived
   AND NOT EXISTS (
     SELECT 1 FROM public.csr_attachments a
      WHERE a.issue_id = i.id AND a.drive_file_id = ${q(r.fileId)});
`)
}
out.push(`-- 확인 — 75~102 이슈별 첨부 수 (27행 기대, 76 만 0)
SELECT i.issue_no, count(a.id) AS captures
  FROM public.csr_issues i LEFT JOIN public.csr_attachments a ON a.issue_id = i.id
 WHERE NOT i.is_archived AND i.issue_no::int BETWEEN 75 AND 102
 GROUP BY i.issue_no ORDER BY i.issue_no::int;
`)
fs.writeFileSync(OUT_SQL, out.join('\n'))
console.log(`SQL 작성 → ${path.relative(ROOT, OUT_SQL)} (${rows.length} INSERT)`)
