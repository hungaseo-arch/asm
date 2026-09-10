#!/usr/bin/env node
/**
 * Notion 내보내기 → CSR INSERT SQL (작업지시서 §4-2)
 *
 *   node scripts/import_notion.js [--dry-run] [--in <dir>] [--out <dir>]
 *
 * 입력  import/notion_export/**  — Notion Export (Markdown & CSV · Include content: Everything)
 *        · `*_all.csv`  전체 속성 63행
 *        · `*.md`       페이지 본문 (섹션 1~7 + 부가 절)
 * 출력  import/out/insert_YYYYMMDD.sql
 *
 * 원본은 건드리지 않습니다. Data API 로 직접 INSERT 하지 않고 **SQL 파일만** 만듭니다 —
 * 재현·검토가 가능해야 하고(§4-2), 적용은 사람이 콘솔에서 합니다(§3-3).
 *
 * ── 실측으로 알게 된 것 (2026-09-10) ────────────────────────────────────────
 * 1. 섹션 번호는 템플릿마다 다릅니다. 한국어 우선본은 검증 이력이 §7 이지만 인니어
 *    우선본은 §6 이고 현업 답변 절이 아예 없습니다. **제목 문자열로 분류**해야 합니다.
 * 2. 이슈번호 '(삭제) 48' 의 접두를 떼면 살아 있는 '48' 과 충돌합니다(3쌍).
 *    db/005_issue_no_unique_partial.sql 을 먼저 적용해야 합니다.
 * 3. §1 캡쳐 이미지는 이 스크립트가 다루지 않습니다 — Drive 업로드 프록시(Apps Script,
 *    Phase 3)가 준비된 뒤 별도 처리합니다. 참조 개수만 세어 보고합니다.
 */
import { readFileSync, readdirSync, writeFileSync, mkdirSync, existsSync } from 'node:fs'
import { join } from 'node:path'

// ─── 인자 ────────────────────────────────────────────────────────────────────
const argv = process.argv.slice(2)
const flag = (name) => argv.includes(name)
const opt = (name, fallback) => {
  const i = argv.indexOf(name)
  return i >= 0 && argv[i + 1] ? argv[i + 1] : fallback
}
const DRY_RUN = flag('--dry-run')
const IN_DIR = opt('--in', 'import/notion_export')
const OUT_DIR = opt('--out', 'import/out')
/*
 * 보완 본문 (Supplementary bodies / Isi tambahan)
 *
 * 내보내기가 일부 페이지를 빠뜨릴 수 있습니다 — 2026-09-10 내보내기에는 63건 중 57건만
 * 들어 있었습니다(04·05·26·36·37·38 누락, 필터된 뷰에서 내보낸 것으로 보입니다).
 * 그 6건은 Notion API 로 따로 받아 이 폴더에 JSON 으로 두었습니다. 형식은 파서 출력과
 * 같습니다: { "<이슈번호>": { findings, recommendation, business_answer, ... } }
 */
const EXTRA_DIR = opt('--extra', 'import/bodies')

// ─── CSV ─────────────────────────────────────────────────────────────────────
/** 따옴표 안의 줄바꿈·콤마를 지키는 최소 CSV 파서. */
function parseCsv(text) {
  const rows = []
  let row = []
  let cell = ''
  let quoted = false
  const QUOTE = '"'

  for (let i = 0; i < text.length; i++) {
    const ch = text[i]
    if (quoted) {
      if (ch === QUOTE) {
        if (text[i + 1] === QUOTE) {
          cell += QUOTE
          i++
        } else quoted = false
      } else cell += ch
      continue
    }
    if (ch === QUOTE) quoted = true
    else if (ch === ',') {
      row.push(cell)
      cell = ''
    } else if (ch === '\n') {
      row.push(cell)
      cell = ''
      rows.push(row)
      row = []
    } else if (ch !== '\r') cell += ch
  }
  if (cell !== '' || row.length) {
    row.push(cell)
    rows.push(row)
  }
  return rows
}

/**
 * '2026년 8월 31일' · '2026년 9월 9일 오전 7:43' → '2026-09-09'
 * 내보내기 CSV 는 날짜를 현지 표기로 내보냅니다. 시각은 버리고 날짜만 씁니다.
 */
function koDate(value) {
  const m = String(value ?? '').match(/(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일/)
  if (!m) return null
  const [, y, mo, d] = m
  return `${y}-${String(mo).padStart(2, '0')}-${String(d).padStart(2, '0')}`
}

/**
 * '2026년 9월 9일 오전 7:43' → '2026-09-09 07:43'
 * 최종수정(updated_at)은 시각까지 의미가 있어 날짜만 남기지 않습니다.
 */
function koDateTime(value) {
  const date = koDate(value)
  if (!date) return null
  const t = String(value).match(/(오전|오후)[ ]*([0-9]{1,2}):([0-9]{2})/)
  if (!t) return date
  let hour = Number(t[2]) % 12
  if (t[1] === '오후') hour += 12
  return date + ' ' + String(hour).padStart(2, '0') + ':' + t[3]
}

// ─── 마크다운 ────────────────────────────────────────────────────────────────
/** 파이프 표 → 셀 배열 (구분선 제외). */
function parseTable(text) {
  return text
    .split('\n')
    .filter((l) => l.trim().startsWith('|'))
    .map((l) =>
      l
        .trim()
        .replace(/^\|/, '')
        .replace(/\|$/, '')
        .split('|')
        .map((c) => c.trim()),
    )
    .filter((r) => !r.every((c) => /^-{2,}$/.test(c)))
}

const withoutTable = (text) =>
  text
    .split('\n')
    .filter((l) => !l.trim().startsWith('|'))
    .join('\n')
    .trim()

const headingDate = (h) => h.match(/\((\d{4}-\d{2}-\d{2})\)/)?.[1] ?? null

/**
 * 섹션 분류 — 번호가 아니라 제목으로 판정합니다(위 주석 1번).
 * 순서가 곧 우선순위입니다.
 */
const SECTIONS = [
  ['shot', /screen ?shot/i],
  ['findings', /findings|temuan/i],
  ['recommendation', /recommendation|rekomendasi/i],
  ['acceptance', /수용기준|kriteria\s+(selesai|penerimaan)/i], // §4 — 속성과 중복이라 버립니다
  ['reply', /개발부서 회신|balasan tim pengembang/i],
  ['answer', /현업 답변|tanggapan tim bisnis|balasan tim bisnis/i],
  ['verify', /검증 이력|riwayat verifikasi/i],
]

function parseMarkdown(raw) {
  const body = { images: 0, verifications: [], extra: [] }
  // '# ' 로 시작하는 줄에서 자릅니다. 첫 조각은 페이지 제목 + 속성 블록이라 버립니다.
  const parts = raw.split(/^# /m).slice(1)
  let first = true

  for (const part of parts) {
    const nl = part.indexOf('\n')
    const heading = (nl === -1 ? part : part.slice(0, nl)).trim()
    const content = (nl === -1 ? '' : part.slice(nl + 1)).trim()

    if (first) {
      first = false
      // 첫 헤딩이 섹션이 아니면 이슈 제목입니다.
      if (!SECTIONS.some(([, re]) => re.test(heading))) continue
    }

    const kind = SECTIONS.find(([, re]) => re.test(heading))?.[0]

    if (kind === 'shot') {
      body.images = (content.match(/!\[[^\]]*\]\([^)]+\)/g) ?? []).length
    } else if (kind === 'findings') body.findings = content
    else if (kind === 'recommendation') body.recommendation = content
    else if (kind === 'acceptance') continue
    else if (kind === 'reply') {
      const table = parseTable(content)
      if (table.length >= 2) {
        const v = table.slice(1).map((r) => r[1] ?? '')
        body.reply = {
          replied_on: headingDate(heading),
          decision: v[0] ?? null,
          fix_plan: v[1] ?? null,
          note: v[2] ?? null,
          needs_decision: v[3] ?? null,
          pic_and_target: v[4] ?? null,
        }
      }
      // 표 없이 '(Belum ada balasan)' 만 있으면 회신이 없다는 뜻이라 행을 만들지 않습니다.
    } else if (kind === 'answer') {
      body.business_answer = withoutTable(content)
      body.business_answered_on = headingDate(heading)
    } else if (kind === 'verify') {
      body.verifications = parseTable(content)
        .slice(1)
        .map((r) => [r[0] ?? '', r[1] ?? '', r[2] ?? ''])
    } else {
      // 작업지시서가 정의하지 않은 절(0. 채번 기록 · 8. 실서버 실측 · 9. 인니어 번역본).
      // 스키마에 자리가 없어 findings 뒤에 제목째로 붙입니다 — 버리면 근거가 사라집니다.
      body.extra.push(`# ${heading}\n\n${content}`)
    }
  }

  if (body.extra.length) {
    body.findings = [body.findings ?? '', ...body.extra].filter(Boolean).join('\n\n')
  }
  delete body.extra
  return body
}

// ─── SQL ─────────────────────────────────────────────────────────────────────
/** 빈 문자열은 NULL. '—' 같은 원문 표기는 그대로 둡니다(§8 — 값 정규화 금지). */
const q = (v) => {
  if (v === null || v === undefined) return 'NULL'
  const s = String(v).trim()
  return s === '' ? 'NULL' : `'${s.replace(/'/g, "''")}'`
}

// ─── 실행 ────────────────────────────────────────────────────────────────────
function findFiles(dir) {
  const out = { csv: null, md: [] }
  const walk = (d) => {
    for (const name of readdirSync(d, { withFileTypes: true })) {
      const p = join(d, name.name)
      if (name.isDirectory()) walk(p)
      else if (name.name.endsWith('_all.csv')) out.csv = p
      else if (name.name.endsWith('.md')) out.md.push(p)
    }
  }
  walk(dir)
  return out
}

if (!existsSync(IN_DIR)) {
  console.error(`입력 폴더가 없습니다: ${IN_DIR}`)
  console.error('Notion → Export → Markdown & CSV · Include content: Everything 으로 내보낸 뒤')
  console.error('압축을 풀어 이 경로에 두십시오.')
  process.exit(1)
}

const files = findFiles(IN_DIR)
if (!files.csv) {
  console.error(`속성 CSV(*_all.csv)를 찾지 못했습니다: ${IN_DIR}`)
  console.error('내보내기 시 Export format 을 "Markdown & CSV" 로 지정했는지 확인하십시오.')
  process.exit(1)
}

const csv = parseCsv(readFileSync(files.csv, 'utf8').replace(/^﻿/, ''))
const header = csv[0]
const col = (name) => header.indexOf(name)
const rows = csv.slice(1).filter((r) => r.length === header.length && r.some((c) => c !== ''))

/** 페이지 id(파일명 끝 32자리 hex) → 본문 */
const bodyByTitle = new Map()
for (const p of files.md) {
  const raw = readFileSync(p, 'utf8')
  // md 헤더의 '이슈번호 (No. Isu): 02' 로 붙입니다 — 파일명은 제목이라 안정적이지 않습니다.
  const no = raw.match(/^이슈번호 \(No\. Isu\): (.*)$/m)?.[1]?.trim()
  if (!no) continue
  const body = parseMarkdown(raw)
  // 내보내기 CSV 에는 페이지 URL 이 없습니다. 파일명 끝 32자리 hex 가 페이지 id 이므로
  // 거기서 되살립니다 — 원본으로 되짚을 수단이 없으면 이관 결과를 검증할 수 없습니다.
  body.page_id = p.match(/([0-9a-f]{32})[.]md$/i)?.[1] ?? null
  bodyByTitle.set(no, body)
}

// 내보내기에 없는 페이지의 본문을 덮어씁니다(있을 때만).
let nExtra = 0
if (existsSync(EXTRA_DIR)) {
  for (const f of readdirSync(EXTRA_DIR).filter((f) => f.endsWith('.json'))) {
    const j = JSON.parse(readFileSync(join(EXTRA_DIR, f), 'utf8'))
    for (const [no, body] of Object.entries(j)) {
      if (!bodyByTitle.has(no)) nExtra++
      bodyByTitle.set(no, body)
    }
  }
}

const G = (r, name) => r[col(name)] ?? null

const lines = []
const W = (s = '') => lines.push(s)
const today = new Date().toISOString().slice(0, 10)

let nIssues = 0
let nReplies = 0
let nVerif = 0
let nImages = 0
const noBody = []

const issueNos = rows.map((r) =>
  String(G(r, '이슈번호 (No. Isu)') ?? '').replace(/^\(삭제\)\s*/, ''),
)

W('-- =============================================================================')
W('-- ASM CSR — Notion 이관 INSERT (작업지시서 §4)')
W(`--   생성: scripts/import_notion.js · ${today}`)
W(`--   입력: ${IN_DIR}`)
W('--')
W('--   선행: db/001~003 + db/005_issue_no_unique_partial.sql')
W('--   §1 캡쳐(첨부)는 포함하지 않습니다 — Apps Script 업로드 프록시(Phase 3) 준비 후 별도 이관.')
W('--   재실행 안전: issue_no 기준으로 기존 행을 지우고 다시 넣습니다.')
W('-- =============================================================================')
W()
W('BEGIN;')
W()
W('-- 재적용 시 중복을 막습니다. 자식 테이블은 ON DELETE CASCADE 로 함께 지워집니다.')
W('DELETE FROM public.csr_issues WHERE issue_no IN (')
W('  ' + [...new Set(issueNos)].map(q).join(', '))
W(');')
W()

for (const r of rows) {
  const rawNo = String(G(r, '이슈번호 (No. Isu)') ?? '').trim()
  const archived = /^\(삭제\)/.test(rawNo)
  const issueNo = rawNo.replace(/^\(삭제\)\s*/, '')
  const b = bodyByTitle.get(rawNo) ?? bodyByTitle.get(issueNo)
  if (!b) noBody.push(rawNo)
  nImages += b?.images ?? 0
  nIssues++

  W(`-- ── ${rawNo} ──`)
  W('INSERT INTO public.csr_issues (')
  W('  issue_no, title_ko, title_id, menu_main, menu_sub, path_menu, issue_type, priority,')
  W('  go_live_category, request_dept, requested_on, summary_ko, summary_id,')
  W('  acceptance_ko, acceptance_id, related_issues, role_split,')
  W('  it_status, it_pic, target_release_on, it_reply_summary_ko, it_reply_summary_id,')
  W('  it_decision, verification_result, verified_on,')
  W('  findings_md, recommendation_md, business_answer_md, business_answered_on,')
  W('  is_archived, notion_url, updated_at, updated_by')
  W(') VALUES (')
  W(`  ${q(issueNo)}, ${q(G(r, '제목 (Judul)'))}, ${q(G(r, 'Judul (ID)'))},`)
  W(
    `  ${q(G(r, '대메뉴 (Menu Utama)'))}, ${q(G(r, '중메뉴 (Sub Menu)'))}, ${q(G(r, '화면경로 (Path Menu)'))},`,
  )
  W(`  ${q(G(r, '유형 (Jenis)'))}, ${q(G(r, '중요도 (Prioritas)'))},`)
  W(`  ${q(G(r, '오픈구분 (Kategori Go-Live)'))}, ${q(G(r, '요청부서 (Divisi Peminta)'))},`)
  W(`  ${q(koDate(G(r, '요청일 (Tgl. Permintaan)')))}::date,`)
  W(`  ${q(G(r, '요약 (Ringkasan)'))}, ${q(G(r, 'Ringkasan (ID)'))},`)
  W(`  ${q(G(r, '수용기준 (Kriteria Selesai)'))}, ${q(G(r, 'Kriteria Selesai (ID)'))},`)
  W(`  ${q(G(r, '관련이슈 (Isu Terkait)'))}, ${q(G(r, '분담 (Pembagian Peran)'))},`)
  W(`  ${q(G(r, 'IT상태 (Status)'))}, ${q(G(r, '담당자 (PIC)'))},`)
  W(`  ${q(koDate(G(r, '목표배포일 (Tgl. Rilis Target)')))}::date,`)
  W(`  ${q(G(r, '회신요약 (Ringkasan Balasan)'))}, ${q(G(r, 'Ringkasan Balasan (ID)'))},`)
  W(`  ${q(G(r, 'IT수용여부 (Keputusan)'))}, ${q(G(r, '현업검증 (Hasil Verifikasi)'))},`)
  W(`  ${q(koDate(G(r, '최종검증일 (Tgl. Verifikasi)')))}::date,`)
  W(`  ${q(b?.findings)}, ${q(b?.recommendation)}, ${q(b?.business_answer)},`)
  W(`  ${q(b?.business_answered_on)}::date,`)
  const notionUrl = b?.page_id ? 'https://app.notion.com/p/' + b.page_id : null
  W(`  ${archived}, ${q(notionUrl)},`)
  W(
    `  COALESCE(${q(koDateTime(G(r, '최종수정 (Terakhir Diubah)')))}::timestamptz, now()), ${q(G(r, '최종편집자 (Diubah Oleh)'))}`,
  )
  W(');')

  const where = `FROM public.csr_issues WHERE issue_no = ${q(issueNo)} AND is_archived = ${archived}`
  if (b?.reply) {
    nReplies++
    const y = b.reply
    W(
      'INSERT INTO public.csr_it_replies (issue_id, replied_on, decision, fix_plan, note, needs_decision, pic_and_target, created_by)',
    )
    W(
      `SELECT id, ${q(y.replied_on)}::date, ${q(y.decision)}, ${q(y.fix_plan)}, ${q(y.note)}, ${q(y.needs_decision)}, ${q(y.pic_and_target)}, 'notion-import'`,
    )
    W(`  ${where};`)
  }
  for (const v of b?.verifications ?? []) {
    nVerif++
    W('INSERT INTO public.csr_verifications (issue_id, verified_on, result, note, created_by)')
    W(`SELECT id, ${q(v[0])}::date, ${q(v[1])}, ${q(v[2])}, 'notion-import'`)
    W(`  ${where};`)
  }
  W()
}

W('COMMIT;')
W()
W('-- ─── 검증 (작업지시서 §4-4) ──────────────────────────────────────────────')
W("SELECT '이슈 합계' AS 항목, count(*)::text AS 값 FROM public.csr_issues")
W("UNION ALL SELECT '아카이브', count(*)::text FROM public.csr_issues WHERE is_archived")
W("UNION ALL SELECT 'IT회신', count(*)::text FROM public.csr_it_replies")
W("UNION ALL SELECT '검증이력', count(*)::text FROM public.csr_verifications;")
W()
W('SELECT it_status, count(*) FROM public.csr_issues GROUP BY 1 ORDER BY 2 DESC;')

console.log(`이슈 ${nIssues} · IT회신 ${nReplies} · 검증이력 ${nVerif} · 캡쳐 참조 ${nImages}`)
console.log('본문 미확보:', noBody.length ? noBody.join(', ') : '없음')
console.log('md 파일:', files.md.length, '· 보완 본문:', nExtra, '· 속성 CSV:', files.csv)

if (DRY_RUN) {
  console.log('\n--dry-run — SQL 파일을 쓰지 않았습니다.')
} else {
  mkdirSync(OUT_DIR, { recursive: true })
  const file = join(OUT_DIR, `insert_${today.replace(/-/g, '')}.sql`)
  writeFileSync(file, lines.join('\n'))
  console.log('\n출력:', file)
}
