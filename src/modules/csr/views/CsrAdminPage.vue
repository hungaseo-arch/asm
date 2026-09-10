<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { authApi, getDb, unwrap } from '../api/neon'
import { nullIfBlank } from '../api/issues'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { INITIAL_PASSWORD, ROLES, isConfigured } from '../config'
import { pickLang } from '../i18n'
import CsrSignIn from '../components/CsrSignIn.vue'

/**
 * 관리 화면 (작업지시서 §5-2 — admin 전용)
 *   1. csr_user_roles CRUD — 누가 어떤 권한으로 들어오는가
 *   2. 비밀번호 초기화 — 분실 시 관리자가 새 비밀번호를 정해 줍니다
 *   3. csr_status_log 조회 — 상태 컬럼이 언제 누구에 의해 바뀌었나
 *
 * 여기 버튼이 보인다고 권한이 생기는 게 아닙니다. 쓰기는 DB 정책(csr_user_roles_write =
 * admin)이 판정합니다. admin 이 아니면 화면 자체를 막지만, 그것은 UX 일 뿐입니다.
 */
const router = useRouter()
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()
const lang = computed(() => issues.lang)
const t = (ko, id) => (lang.value === 'id' ? id : ko)
const V = (v) => pickLang(v, lang.value)

const users = ref([])
const log = ref([])
const loading = ref(true)
const error = ref('')
const saving = ref(false)
const tab = ref('users')

async function load() {
  loading.value = true
  error.value = ''
  try {
    const db = getDb()
    users.value = unwrap(await db.from('csr_user_roles').select('*').order('email')) ?? []
    log.value =
      unwrap(
        await db
          .from('csr_status_log')
          .select('*, csr_issues(issue_no)')
          .order('changed_at', { ascending: false })
          .limit(200),
      ) ?? []
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}
onMounted(async () => {
  if (!isConfigured()) {
    error.value = 'Neon 접속 정보가 설정되지 않았습니다'
    loading.value = false
    return
  }
  await session.refresh()
  if (session.isAdmin) await load()
  else loading.value = false
})

function report(e, fallback) {
  if (e?.forbidden) toast.error(`권한이 없습니다 — ${e.message}`)
  else toast.error(e?.message ?? fallback)
}

// ─── 사용자 · 역할 ───────────────────────────────────────────────────────────
const EMPTY = () => ({ user_id: '', email: '', role: 'business', department: '', display_name: '' })
const form = reactive(EMPTY())
const editing = ref(false)
const isNew = ref(true)

function startNew() {
  Object.assign(form, EMPTY())
  isNew.value = true
  editing.value = true
}
function startEdit(u) {
  Object.assign(form, {
    user_id: u.user_id,
    email: u.email,
    role: u.role,
    department: u.department ?? '',
    display_name: u.display_name ?? '',
  })
  isNew.value = false
  editing.value = true
}
/**
 * Neon Auth 계정을 이메일로 찾거나 만듭니다 — 관리자가 콘솔을 열지 않아도 되게(2026-09-10
 * 「웹페이지에서 사용자 추가하면 네온에도 입력되도록」).
 *
 * 순서: 이미 있는 계정이면 그 id(예전에 콘솔에서 만든 계정, 또는 역할만 지웠던 사람),
 * 없으면 초기 비밀번호로 생성. 둘 다 admin 플러그인 엔드포인트라 호출자가 Neon Auth 쪽
 * Admin(콘솔 Users 의 Admin 배지)이어야 합니다 — 아니면 401/403 이 옵니다.
 */
async function findOrCreateAuthUser({ email, name }) {
  const admin = authApi()?.admin
  if (!admin?.createUser) throw new Error('admin 플러그인이 클라이언트에 없습니다')
  const found = await admin.listUsers({
    query: { searchValue: email, searchField: 'email', searchOperator: 'contains', limit: 10 },
  })
  if (found?.error) throw new Error(found.error.message ?? found.error.statusText ?? 'list-users')
  const hit = (found?.data?.users ?? []).find((u) => u.email?.toLowerCase() === email)
  if (hit) return { id: hit.id, created: false }
  const made = await admin.createUser({ email, name: name ?? email, password: INITIAL_PASSWORD })
  if (made?.error) throw new Error(made.error.message ?? made.error.statusText ?? 'create-user')
  const id = made?.data?.user?.id
  if (!id) throw new Error('계정은 만들어졌으나 id 를 받지 못했습니다')
  return { id, created: true }
}

async function saveUser() {
  const row = {
    user_id: form.user_id.trim(),
    email: form.email.trim().toLowerCase(),
    role: form.role,
    department: nullIfBlank(form.department),
    display_name: nullIfBlank(form.display_name),
  }
  if (!row.email) {
    toast.error(t('이메일은 필수입니다', 'Email wajib diisi'))
    return
  }
  saving.value = true
  try {
    const db = getDb()
    if (isNew.value) {
      // 계정 → 역할 순. 계정이 만들어지고 역할 INSERT 가 실패해도 다음 시도에서 '이미 있는
      // 계정' 으로 잡혀 중복 생성되지 않습니다.
      const acct = await findOrCreateAuthUser({ email: row.email, name: row.display_name })
      row.user_id = acct.id
      unwrap(await db.from('csr_user_roles').insert(row).select('user_id'))
      if (acct.created)
        toast.info(
          t(
            `계정을 만들었습니다 — 초기 비밀번호 ${INITIAL_PASSWORD}. 본인이 로그인 뒤 바꾸게 하십시오.`,
            `Akun dibuat — kata sandi awal ${INITIAL_PASSWORD}. Minta pengguna menggantinya setelah masuk.`,
          ),
          { duration: 8000 },
        )
    } else {
      const { user_id, ...patch } = row
      unwrap(await db.from('csr_user_roles').update(patch).eq('user_id', user_id).select('user_id'))
    }
    editing.value = false
    await load()
    toast.success(t('저장했습니다', 'Tersimpan'))
  } catch (e) {
    report(e, '저장에 실패했습니다')
  } finally {
    saving.value = false
  }
}
async function removeUser(u) {
  if (u.user_id === session.user?.id) {
    toast.error(t('자기 자신은 지울 수 없습니다', 'Tidak dapat menghapus diri sendiri'))
    return
  }
  if (
    !window.confirm(
      t(`${u.email} 을(를) CSR 사용자에서 제외할까요?`, `Hapus ${u.email} dari pengguna CSR?`),
    )
  )
    return
  // 계정까지 지울지는 따로 묻습니다 — 역할만 지우면 로그인은 되지만 아무것도 못 봅니다(퇴사면 계정도).
  const dropAccount = window.confirm(
    t(
      `Neon 로그인 계정도 삭제할까요? [확인] 계정까지 삭제 · [취소] 역할만 제외(로그인은 유지)`,
      `Hapus juga akun login Neon? [OK] hapus akun · [Cancel] hanya peran`,
    ),
  )
  saving.value = true
  try {
    unwrap(await getDb().from('csr_user_roles').delete().eq('user_id', u.user_id).select('user_id'))
    if (dropAccount) {
      const r = await authApi()?.admin?.removeUser?.({ userId: u.user_id })
      if (r?.error) throw new Error(`역할은 제외했으나 계정 삭제 실패: ${r.error.message ?? ''}`)
    }
    await load()
    toast.success(
      dropAccount ? t('계정까지 삭제했습니다', 'Akun dihapus') : t('제외했습니다', 'Dihapus'),
    )
  } catch (e) {
    report(e, '삭제에 실패했습니다')
  } finally {
    saving.value = false
  }
}

// ─── 비밀번호 초기화 ─────────────────────────────────────────────────────────
/**
 * Better Auth admin 플러그인의 /admin/set-user-password 를 씁니다. 호출자가 Neon Auth 쪽
 * admin 역할(neon_auth."user".role = 'admin')이어야 합니다 — 콘솔 Users 목록에 Admin 배지가
 * 붙은 계정입니다. 아니면 401/403 이 오고, 그때는 scripts/csr_set_password.mjs 로 SQL 을
 * 만들어 넣는 우회로를 안내합니다.
 */
const pwTarget = ref(null)
const pwValue = ref('')
function startPw(u) {
  pwTarget.value = u
  pwValue.value = ''
}
async function resetPassword() {
  if (pwValue.value.length < 8) {
    toast.error(t('8자 이상이어야 합니다', 'Minimal 8 karakter'))
    return
  }
  saving.value = true
  try {
    const api = authApi()
    const fn = api?.admin?.setUserPassword
    if (!fn) throw new Error('admin 플러그인이 클라이언트에 없습니다')
    const r = await fn({ userId: pwTarget.value.user_id, newPassword: pwValue.value })
    if (r?.error) throw new Error(r.error.message ?? r.error.statusText ?? '실패')
    toast.success(
      t(
        `${pwTarget.value.email} 비밀번호를 바꿨습니다`,
        `Kata sandi ${pwTarget.value.email} diubah`,
      ),
    )
    pwTarget.value = null
    pwValue.value = ''
  } catch (e) {
    toast.error(
      t(
        `초기화 실패: ${e.message}. 콘솔 계정에 Admin 권한이 없으면 scripts/csr_set_password.mjs 로 SQL 을 만들어 적용하십시오.`,
        `Gagal: ${e.message}`,
      ),
    )
  } finally {
    saving.value = false
  }
}

const fmtTs = (ts) => (ts ? String(ts).replace('T', ' ').slice(0, 16) : '')
const userName = (id) => users.value.find((u) => u.user_id === id)?.display_name ?? id ?? '—'
</script>

<template>
  <DefaultLayout>
    <section class="admin">
      <div class="headline">
        <div class="page-titles">
          <h1 class="page-title">Admin</h1>
          <p class="page-sub mb-0">Administrasi · 관리</p>
        </div>
        <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr')">
          ← {{ t('개선요청 목록', 'Daftar permintaan') }}
        </button>
      </div>

      <div v-if="loading" class="asm-panel state">{{ t('불러오는 중…', 'Memuat…') }}</div>
      <div v-else-if="error" class="asm-panel state err">{{ error }}</div>
      <CsrSignIn v-else-if="!session.isAuthenticated" />
      <div v-else-if="!session.isAdmin" class="asm-panel state">
        {{ t('관리자만 볼 수 있습니다', 'Hanya untuk admin') }} ({{ session.role ?? '미등록' }})
      </div>

      <template v-else>
        <div class="tabs" role="tablist">
          <button
            type="button"
            role="tab"
            :aria-selected="tab === 'users'"
            :class="{ active: tab === 'users' }"
            @click="tab = 'users'"
          >
            {{ t('사용자 · 역할', 'Pengguna · Peran') }}
            <span class="count-pill">{{ users.length }}</span>
          </button>
          <button
            type="button"
            role="tab"
            :aria-selected="tab === 'log'"
            :class="{ active: tab === 'log' }"
            @click="tab = 'log'"
          >
            {{ t('상태 변경 로그', 'Log perubahan') }}
            <span class="count-pill">{{ log.length }}</span>
          </button>
        </div>

        <!-- ── 사용자 · 역할 ── -->
        <section v-if="tab === 'users'" class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">{{ t('사용자 · 역할', 'Pengguna · Peran') }}</h2>
            <button v-if="!editing" type="button" class="btn btn-sm btn-primary" @click="startNew">
              + {{ t('사용자 추가', 'Tambah pengguna') }}
            </button>
          </div>

          <form v-if="editing" class="sub-form" @submit.prevent="saveUser">
            <div class="grid">
              <label class="field">
                <span>Email</span>
                <input
                  v-model="form.email"
                  type="email"
                  class="form-control form-control-sm"
                  :disabled="!isNew"
                  required
                />
              </label>
              <label class="field">
                <span>{{ t('권한', 'Peran') }}</span>
                <select v-model="form.role" class="form-select form-select-sm">
                  <option v-for="r in ROLES" :key="r" :value="r">{{ r }}</option>
                </select>
              </label>
              <label class="field">
                <span>{{ t('소속', 'Bagian') }}</span>
                <input
                  v-model="form.department"
                  class="form-control form-control-sm"
                  placeholder="sales · import · finance · it"
                />
              </label>
              <label class="field">
                <span>{{ t('표시 이름', 'Nama tampilan') }}</span>
                <input v-model="form.display_name" class="form-control form-control-sm" />
              </label>
            </div>
            <p class="muted hint">
              {{
                t(
                  '권한은 admin · it_dept · business 3종뿐입니다. 소속은 표시·집계용이며 권한과 무관합니다.',
                  'Peran hanya admin · it_dept · business. Bagian hanya untuk tampilan.',
                )
              }}
              <template v-if="isNew">
                {{
                  t(
                    `저장하면 Neon 로그인 계정이 함께 만들어집니다(초기 비밀번호 ${INITIAL_PASSWORD}). 이미 있는 이메일이면 그 계정에 역할만 붙입니다.`,
                    `Akun login Neon dibuat otomatis (kata sandi awal ${INITIAL_PASSWORD}); email yang sudah ada hanya diberi peran.`,
                  )
                }}
              </template>
              <template v-else>
                <span class="mono">ID {{ form.user_id }}</span>
              </template>
            </p>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="editing = false"
              >
                {{ t('취소', 'Batal') }}
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
                {{ t('저장', 'Simpan') }}
              </button>
            </div>
          </form>

          <table class="table asm-table">
            <thead>
              <tr>
                <th>{{ t('이름', 'Nama') }}</th>
                <th>Email</th>
                <th>{{ t('권한', 'Peran') }}</th>
                <th>{{ t('소속', 'Bagian') }}</th>
                <th class="nowrap">{{ t('등록일', 'Terdaftar') }}</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="u in users"
                :key="u.user_id"
                :class="{ me: u.user_id === session.user?.id }"
              >
                <td>{{ u.display_name ?? '—' }}</td>
                <td class="nowrap">{{ u.email }}</td>
                <td>
                  <span class="asm-pill">{{ u.role }}</span>
                </td>
                <td>{{ u.department ?? '—' }}</td>
                <td class="nowrap muted">{{ fmtTs(u.created_at).slice(0, 10) }}</td>
                <td class="nowrap ops">
                  <button type="button" class="btn btn-sm btn-link" @click="startEdit(u)">
                    {{ t('편집', 'Ubah') }}
                  </button>
                  <button type="button" class="btn btn-sm btn-link" @click="startPw(u)">
                    {{ t('비밀번호', 'Kata sandi') }}
                  </button>
                  <button
                    type="button"
                    class="btn btn-sm btn-link text-danger"
                    :disabled="u.user_id === session.user?.id"
                    @click="removeUser(u)"
                  >
                    {{ t('제외', 'Hapus') }}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>

          <!-- 비밀번호 초기화 -->
          <form v-if="pwTarget" class="sub-form pw" @submit.prevent="resetPassword">
            <b>{{ t('비밀번호 초기화', 'Reset kata sandi') }} — {{ pwTarget.email }}</b>
            <div class="grid">
              <label class="field">
                <span>{{ t('새 비밀번호 (8자 이상)', 'Kata sandi baru (min. 8)') }}</span>
                <input
                  v-model="pwValue"
                  type="text"
                  class="form-control form-control-sm"
                  autocomplete="off"
                  required
                />
              </label>
            </div>
            <p class="muted hint">
              {{
                t(
                  '초기화 후 본인이 로그인해 헤더 계정 메뉴에서 바꾸도록 안내하십시오.',
                  'Minta pengguna mengubahnya sendiri setelah masuk.',
                )
              }}
            </p>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="pwTarget = null"
              >
                {{ t('취소', 'Batal') }}
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
                {{ t('적용', 'Terapkan') }}
              </button>
            </div>
          </form>
        </section>

        <!-- ── 상태 변경 로그 ── -->
        <section v-else class="asm-panel sec">
          <h2 class="asm-title">
            {{ t('상태 변경 로그', 'Log perubahan') }}
            <small>{{ t('최근 200건', '200 terakhir') }}</small>
          </h2>
          <p v-if="!log.length" class="muted">{{ t('기록이 없습니다', 'Belum ada catatan') }}</p>
          <div v-else class="table-scroll">
            <table class="table asm-table">
              <thead>
                <tr>
                  <th class="nowrap">{{ t('일시', 'Waktu') }}</th>
                  <th class="nowrap">{{ t('이슈', 'Isu') }}</th>
                  <th class="nowrap">{{ t('컬럼', 'Kolom') }}</th>
                  <th>{{ t('이전', 'Sebelum') }}</th>
                  <th>{{ t('이후', 'Sesudah') }}</th>
                  <th class="nowrap">{{ t('변경자', 'Oleh') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="l in log" :key="l.id">
                  <td class="nowrap">{{ fmtTs(l.changed_at) }}</td>
                  <td class="nowrap">
                    <a
                      href="#"
                      @click.prevent="
                        router.push(`/csr/${encodeURIComponent(l.csr_issues?.issue_no ?? '')}`)
                      "
                      >{{ l.csr_issues?.issue_no ?? l.issue_id }}</a
                    >
                  </td>
                  <td class="nowrap">{{ l.column_name }}</td>
                  <td>{{ V(l.old_value) ?? '—' }}</td>
                  <td>{{ V(l.new_value) ?? '—' }}</td>
                  <td class="nowrap muted">{{ userName(l.changed_by) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </template>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.admin {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.headline {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}
.state {
  padding: 24px;
}
.err {
  color: var(--asm-danger);
}
.muted {
  color: var(--asm-fg-muted);
  font-size: 12px;
}
.mono {
  font-family: ui-monospace, Consolas, monospace;
  font-size: 11px;
}
.hint {
  margin: 8px 0 0;
}
.tabs {
  display: flex;
  gap: 4px;
}
.tabs button {
  border: 0;
  background: transparent;
  padding: 6px 12px;
  border-radius: var(--asm-radius-md);
  font-size: 13px;
  font-weight: 500;
  color: var(--asm-nav-fg);
  display: flex;
  align-items: center;
  gap: 6px;
}
.tabs button.active {
  background: var(--asm-primary-10);
  color: var(--asm-primary);
  font-weight: 700;
}
.count-pill {
  font-size: 11px;
  font-weight: 700;
  color: var(--asm-primary);
  background: var(--asm-primary-soft);
  padding: 2px 8px;
  border-radius: 9999px;
}
.sec {
  padding: 20px 24px;
}
.sec-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 12px;
}
.sec > h2,
.sec-head h2 {
  margin: 0;
}
.sec > h2 {
  margin-bottom: 12px;
}
.sec small {
  font-weight: 500;
  color: var(--asm-fg-muted);
}
.sub-form {
  border: 1px dashed var(--asm-border);
  border-radius: var(--asm-radius-md);
  padding: 12px;
  margin-bottom: 12px;
}
.sub-form.pw {
  margin-top: 12px;
  margin-bottom: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 10px 16px;
}
.field {
  display: flex;
  flex-direction: column;
  gap: 3px;
  min-width: 0;
}
.field > span {
  font-size: 11px;
  font-weight: 500;
  color: var(--asm-fg-muted);
}
.actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 10px;
}
.nowrap {
  white-space: nowrap;
}
.ops {
  text-align: right;
}
tr.me td {
  background: var(--asm-primary-6);
}
.table-scroll {
  overflow-x: auto;
}
</style>
