#!/usr/bin/env node
/**
 * CSR 계정 초기 비밀번호 설정 SQL 생성기
 *
 *   node scripts/csr_set_password.mjs [--password ascendo123] [--email a@b.c] [--out import/out]
 *
 * ── 왜 이런 방식인가 (2026-09-10 실측) ──────────────────────────────────────
 * Neon Auth 콘솔에서 만든 계정 9개가 **비밀번호 없이** 생성되었습니다
 * (neon_auth.account.password IS NULL, providerId = 'credential').
 * 콘솔의 사용자 메뉴에는 View Details · Remove admin · Delete 뿐이라 비밀번호를
 * 정할 수 없고, 인증 서버의 다른 경로도 모두 막혀 있습니다:
 *
 *   /forget-password          404  (미사용)
 *   /change-password          현재 비밀번호 + 세션 필요 → 지금은 둘 다 없음
 *   /admin/set-user-password  admin 세션 필요 → 로그인해야 얻는데 그게 막힘 (순환)
 *
 * 계정을 지우고 /sign-up/email 로 다시 만드는 방법도 있지만 user_id 가 바뀌어
 * csr_user_roles 를 다시 채워야 합니다. 그래서 **계정은 그대로 두고 비밀번호 해시만**
 * 넣습니다 — Better Auth 가 쓰는 것과 같은 함수로 해시를 만들어 SQL 로 기록합니다.
 *
 * 해시는 better-auth/crypto 의 hashPassword 로 만듭니다(scrypt, `salt:hash` 형식).
 * 로컬은 1.7.2, Neon 서버는 1.6.23 이라 **먼저 한 계정으로 로그인을 확인**한 뒤
 * 나머지에 적용하십시오 — 형식이 어긋나면 로그인만 실패하고 데이터는 멀쩡합니다.
 *
 * 출력물에는 비밀번호 해시가 들어갑니다. import/ 는 .gitignore 대상이라 커밋되지
 * 않습니다 — 다른 곳으로 옮기지 마십시오.
 */
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { hashPassword, verifyPassword } from 'better-auth/crypto'

const argv = process.argv.slice(2)
const opt = (name, fallback) => {
  const i = argv.indexOf(name)
  return i >= 0 && argv[i + 1] ? argv[i + 1] : fallback
}
const many = (name) => argv.reduce((out, v, i) => (argv[i - 1] === name ? [...out, v] : out), [])

const PASSWORD = opt('--password', 'ascendo123')
const OUT_DIR = opt('--out', 'import/out')

/**
 * 대상 이메일은 db/004_seed_roles.sql 에서 읽습니다 — 계정 목록의 단일 출처를 하나로
 * 두어야 둘이 어긋나지 않습니다. --email 로 특정 계정만 지정할 수도 있습니다.
 */
function emailsFromSeed() {
  const sql = readFileSync('db/004_seed_roles.sql', 'utf8')
  const block = sql.slice(
    sql.indexOf('INSERT INTO csr_seed'),
    sql.indexOf('-- ─────', sql.indexOf('INSERT INTO csr_seed')),
  )
  return [...block.matchAll(/\('([^']+@[^']+)'/g)].map((m) => m[1])
}

const emails = many('--email').length ? many('--email') : emailsFromSeed()
if (!emails.length) {
  console.error(
    '대상 이메일을 찾지 못했습니다. db/004_seed_roles.sql 을 확인하거나 --email 로 지정하십시오.',
  )
  process.exit(1)
}

const q = (v) => `'${String(v).replace(/'/g, "''")}'`

const lines = []
const W = (s = '') => lines.push(s)
const today = new Date().toISOString().slice(0, 10)

W('-- =============================================================================')
W('-- ASM CSR — 계정 초기 비밀번호 설정')
W(`--   생성: scripts/csr_set_password.mjs · ${today}`)
W(`--   대상 ${emails.length}건 · 비밀번호 ${q(PASSWORD)}`)
W('--')
W('--   ★ 먼저 한 계정으로 로그인을 확인한 뒤 나머지를 적용하십시오.')
W('--     로컬 better-auth 와 Neon 서버 버전이 달라 해시 형식이 어긋날 수 있습니다.')
W('--     어긋나도 로그인만 실패하며 데이터는 영향받지 않습니다.')
W('--')
W('--   이 파일에는 비밀번호 해시가 들어 있습니다. 커밋하거나 공유하지 마십시오.')
W('-- =============================================================================')
W()
W('BEGIN;')
W()

for (const email of emails) {
  const hash = await hashPassword(PASSWORD)
  // 만든 즉시 되돌려 확인합니다 — 잘못된 해시를 DB 에 넣는 것보다 여기서 멈추는 게 낫습니다.
  if (!(await verifyPassword({ hash, password: PASSWORD }))) {
    console.error(`해시 검증 실패: ${email}`)
    process.exit(1)
  }
  W(`-- ${email}`)
  W('UPDATE neon_auth.account a')
  W(`   SET password = ${q(hash)}, "updatedAt" = now()`)
  W('  FROM neon_auth."user" u')
  W(' WHERE a."userId" = u.id')
  W(`   AND a."providerId" = 'credential'`)
  W(`   AND lower(u.email) = lower(${q(email)});`)
  W()
}

W('COMMIT;')
W()
W('-- ─── 확인 ────────────────────────────────────────────────────────────────────')
W('-- 비밀번호_설정됨 이 모두 true 여야 합니다.')
W('SELECT u.email, (a.password IS NOT NULL) AS 비밀번호_설정됨, a."updatedAt"')
W('  FROM neon_auth."user" u')
W('  JOIN neon_auth.account a ON a."userId" = u.id')
W(` WHERE a."providerId" = 'credential'`)
W(' ORDER BY u.email;')

mkdirSync(OUT_DIR, { recursive: true })
const file = join(OUT_DIR, `set_password_${today.replace(/-/g, '')}.sql`)
writeFileSync(file, lines.join('\n'))

console.log(`대상 ${emails.length}건:`)
emails.forEach((e) => console.log('  ' + e))
console.log(`\n비밀번호: ${PASSWORD}`)
console.log('출력:', file)
console.log('\n※ 이 파일에는 해시가 들어 있습니다. 커밋·공유하지 마십시오.')
