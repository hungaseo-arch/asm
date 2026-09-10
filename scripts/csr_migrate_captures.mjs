/**
 * Notion 이관 캡쳐 → Drive 업로드 → db/012_attachments_seed.sql 생성
 *
 *   node scripts/csr_migrate_captures.mjs            # 업로드 + SQL 생성
 *   node scripts/csr_migrate_captures.mjs --dry-run  # 대상만 나열
 *
 * 입력
 *   import/notion_export/md/NN_*.jpeg|png   — Notion 내보내기의 이미지. 앞의 NN 이 이슈번호.
 *   .env 의 VITE_CSR_UPLOAD_URL (+ 선택 VITE_CSR_UPLOAD_TOKEN) — Apps Script 웹앱
 * 출력
 *   import/out/captures_manifest.json  — 파일별 Drive fileId (재실행 시 이미 올린 건 건너뜀)
 *   db/012_attachments_seed.sql        — csr_attachments INSERT (콘솔에서 실행, 재실행 안전)
 *
 * 왜 API 로 바로 INSERT 하지 않는가: 그러려면 admin 계정으로 로그인해야 하고 uploaded_by 가
 * 그 계정으로 찍힙니다. 이관분은 'notion' 으로 남기는 게 맞아 SQL 로 냅니다. 011 이 적용된 뒤라
 * 콘솔 UPDATE/INSERT 는 가드에 막히지 않습니다.
 */
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const MD_DIR = path.join(ROOT, 'import/notion_export/md')
const MANIFEST = path.join(ROOT, 'import/out/captures_manifest.json')
const OUT_SQL = path.join(ROOT, 'db/012_attachments_seed.sql')
const DRY = process.argv.includes('--dry-run')

// .env 를 손으로 읽습니다(dotenv 의존성 없이 — 작업지시서 §9).
const env = Object.fromEntries(
  fs
    .readFileSync(path.join(ROOT, '.env'), 'utf8')
    .split(/\r?\n/)
    .filter((l) => /^[A-Z_]+=/.test(l))
    .map((l) => [l.slice(0, l.indexOf('=')), l.slice(l.indexOf('=') + 1).trim()]),
)
const UPLOAD_URL = env.VITE_CSR_UPLOAD_URL
const TOKEN = env.VITE_CSR_UPLOAD_TOKEN ?? ''

const MIME = {
  '.jpeg': 'image/jpeg',
  '.jpg': 'image/jpeg',
  '.png': 'image/png',
  '.gif': 'image/gif',
  '.webp': 'image/webp',
}
const files = fs
  .readdirSync(MD_DIR)
  .filter((f) => MIME[path.extname(f).toLowerCase()])
  .map((f) => ({ file: f, issueNo: f.match(/^(\d{2})_/)?.[1] ?? null }))
  .sort((a, b) => a.file.localeCompare(b.file))

const noIssue = files.filter((f) => !f.issueNo)
console.log(`이미지 ${files.length}개 (이슈번호 없음 ${noIssue.length})`)
if (noIssue.length) console.log('  건너뜀:', noIssue.map((f) => f.file).join(', '))

const manifest = fs.existsSync(MANIFEST) ? JSON.parse(fs.readFileSync(MANIFEST, 'utf8')) : {}

if (DRY) {
  for (const f of files)
    console.log(' ', f.issueNo ?? '--', f.file, manifest[f.file]?.fileId ? '(uploaded)' : '')
  process.exit(0)
}
if (!UPLOAD_URL) {
  console.error('VITE_CSR_UPLOAD_URL 이 .env 에 없습니다 — Apps Script 배포 후 등록하십시오.')
  process.exit(1)
}

let uploaded = 0
for (const f of files) {
  if (!f.issueNo) continue
  if (manifest[f.file]?.fileId) continue
  const bytes = fs.readFileSync(path.join(MD_DIR, f.file))
  const body = JSON.stringify({
    name: f.file,
    mime: MIME[path.extname(f.file).toLowerCase()],
    data: bytes.toString('base64'),
    issueNo: f.issueNo,
    token: TOKEN,
  })
  const res = await fetch(UPLOAD_URL, { method: 'POST', body })
  const out = await res.json().catch(() => ({ ok: false, error: `HTTP ${res.status}` }))
  if (!out.ok) {
    console.error('  실패', f.file, out.error)
    continue
  }
  manifest[f.file] = {
    fileId: out.fileId,
    issueNo: f.issueNo,
    size: out.size,
    uploadedAt: new Date().toISOString(),
  }
  fs.mkdirSync(path.dirname(MANIFEST), { recursive: true })
  fs.writeFileSync(MANIFEST, JSON.stringify(manifest, null, 1))
  uploaded++
  console.log('  올림', f.issueNo, f.file, out.fileId)
}
console.log(`업로드 ${uploaded}개 (누적 ${Object.keys(manifest).length})`)

// SQL — 이슈번호 → 살아 있는 이슈의 id. 같은 fileId 가 이미 있으면 건너뜁니다.
const q = (s) => `'${String(s).replace(/'/g, "''")}'`
const rows = Object.entries(manifest).sort(([a], [b]) => a.localeCompare(b))
const sql = [
  `-- =============================================================================
-- ASM CSR — Notion 이관 캡쳐 ${rows.length}건 → csr_attachments (2026-09-10)
--   생성: node scripts/csr_migrate_captures.mjs   (Drive 업로드는 이미 끝났고 여기서는 행만 넣습니다)
--   001~011 적용 후 실행. 재실행 안전(같은 drive_file_id 는 건너뜀).
-- =============================================================================
`,
]
for (const [file, m] of rows) {
  sql.push(`INSERT INTO public.csr_attachments (issue_id, drive_file_id, file_name, caption, sort_order, uploaded_by)
SELECT i.id, ${q(m.fileId)}, ${q(file)}, NULL, 0, 'notion'
  FROM public.csr_issues i
 WHERE i.issue_no = ${q(m.issueNo)} AND NOT i.is_archived
   AND NOT EXISTS (SELECT 1 FROM public.csr_attachments a WHERE a.drive_file_id = ${q(m.fileId)});
`)
}
sql.push(`-- 확인 — 이슈별 첨부 수
SELECT i.issue_no, count(a.id) AS captures
  FROM public.csr_issues i LEFT JOIN public.csr_attachments a ON a.issue_id = i.id
 WHERE NOT i.is_archived GROUP BY i.issue_no HAVING count(a.id) > 0 ORDER BY i.issue_no;
`)
fs.writeFileSync(OUT_SQL, sql.join('\n'))
console.log(`SQL 작성 → ${path.relative(ROOT, OUT_SQL)} (${rows.length} INSERT)`)
