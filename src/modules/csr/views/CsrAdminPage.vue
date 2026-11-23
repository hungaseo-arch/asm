<script setup>
import { nextTick, onMounted, reactive, ref } from 'vue'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { authApi, getDb, unwrap } from '../api/neon'
import { nullIfBlank } from '../api/issues'
import { useCsrSessionStore } from '../stores/session'
import { INITIAL_PASSWORD, ROLES, isConfigured } from '../config'
import { pickLang } from '../i18n'
import { fmtDate, fmtTs, isDateValue, logValue } from '../dates'
import { useCsrLang } from '../composables/useCsrLang'
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
const session = useCsrSessionStore()
const { lang, t } = useCsrLang()
const V = (v) => pickLang(v, lang.value)

const users = ref([])
const log = ref([])
const logins = ref([])
const loading = ref(true)
const error = ref('')
const saving = ref(false)
const tab = ref('users')
const TABS = ['users', 'log', 'logins']
const tabEls = ref({})
function onTabKey(e) {
  const i = TABS.indexOf(tab.value)
  let n = -1
  if (e.key === 'ArrowRight') n = (i + 1) % TABS.length
  else if (e.key === 'ArrowLeft') n = (i - 1 + TABS.length) % TABS.length
  else if (e.key === 'Home') n = 0
  else if (e.key === 'End') n = TABS.length - 1
  if (n < 0) return
  e.preventDefault()
  tab.value = TABS[n]
  nextTick(() => tabEls.value[TABS[n]]?.focus())
}

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
  // 로그인 이력(db/044) — 따로 받습니다. 044 미적용 환경이면 테이블이 없어 실패하는데,
  // 그 한 가지 때문에 사용자·상태 로그 탭까지 막히면 안 됩니다.
  try {
    logins.value =
      unwrap(
        await getDb()
          .from('csr_login_log')
          .select('*, csr_user_roles(email,display_name)')
          .order('logged_in_at', { ascending: false })
          .limit(200),
      ) ?? []
  } catch (e) {
    console.warn('[csr] 로그인 이력 조회 실패 — db/044 적용 여부를 확인하십시오', e)
    logins.value = []
  }
}
onMounted(async () => {
  if (!isConfigured()) {
    error.value = t('Neon 접속 정보가 설정되지 않았습니다', 'Informasi koneksi Neon belum diatur')
    loading.value = false
    return
  }
  await session.refresh()
  if (session.isAdmin) await load()
  else loading.value = false
})

function report(e, fallback) {
  if (e?.forbidden) toast.error(t(`권한이 없습니다 — ${e.message}`, `Tidak ada izin — ${e.message}`))
  else toast.error(e?.message ?? t(fallback[0], fallback[1]))
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
  if (!admin?.createUser) throw new Error(t('admin 플러그인이 클라이언트에 없습니다', 'Plugin admin tidak tersedia di klien'))
  const found = await admin.listUsers({
    query: { searchValue: email, searchField: 'email', searchOperator: 'contains', limit: 10 },
  })
  if (found?.error) throw new Error(found.error.message ?? found.error.statusText ?? 'list-users')
  const hit = (found?.data?.users ?? []).find((u) => u.email?.toLowerCase() === email)
  if (hit) return { id: hit.id, created: false }
  const made = await admin.createUser({ email, name: name ?? email, password: INITIAL_PASSWORD })
  if (made?.error) throw new Error(made.error.message ?? made.error.statusText ?? 'create-user')
  const id = made?.data?.user?.id
  if (!id) throw new Error(t('계정은 만들어졌으나 id 를 받지 못했습니다', 'Akun dibuat tetapi id tidak diterima'))
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
            `계정을 만들었습니다 — 초기 비밀번호 ${INITIAL_PASSWORD}. 본인이 로그인한 뒤 바꾸게 하십시오.`,
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
    report(e, ['저장에 실패했습니다', 'Gagal menyimpan'])
  } finally {
    saving.value = false
  }
}
// 제외 확인 — 인페이지 패널. 취소 / 역할만 제외 / 계정까지 삭제 를 각각 명시 버튼으로 분리합니다.
const removeTarget = ref(null)
const cancelRemoveBtn = ref(null)
function askRemove(u) {
  if (u.user_id === session.user?.id) {
    toast.error(t('자기 자신은 지울 수 없습니다', 'Tidak dapat menghapus diri sendiri'))
    return
  }
  removeTarget.value = u
  nextTick(() => cancelRemoveBtn.value?.focus())
}
async function removeUser(dropAccount) {
  const u = removeTarget.value
  if (!u) return
  saving.value = true
  try {
    unwrap(await getDb().from('csr_user_roles').delete().eq('user_id', u.user_id).select('user_id'))
    if (dropAccount) {
      // 옵셔널 호출 금지 — 프록시 메서드는 직접 부릅니다(session.js signOut 주석 참고).
      const admin = authApi()?.admin
      const r = admin ? await admin.removeUser({ userId: u.user_id }) : null
      if (r?.error)
        throw new Error(
          t(
            `역할은 제외했으나 계정 삭제 실패: ${r.error.message ?? ''}`,
            `Peran dihapus tetapi gagal menghapus akun: ${r.error.message ?? ''}`,
          ),
        )
    }
    removeTarget.value = null
    await load()
    toast.success(
      dropAccount ? t('계정까지 삭제했습니다', 'Akun dihapus') : t('제외했습니다', 'Dihapus'),
    )
  } catch (e) {
    report(e, ['삭제에 실패했습니다', 'Gagal menghapus'])
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
    if (!fn) throw new Error(t('admin 플러그인이 클라이언트에 없습니다', 'Plugin admin tidak tersedia di klien'))
    const r = await fn({ userId: pwTarget.value.user_id, newPassword: pwValue.value })
    if (r?.error) throw new Error(r.error.message ?? r.error.statusText ?? t('실패', 'Gagal'))
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
        `Reset gagal: ${e.message}. Jika akun konsol tidak memiliki izin Admin, buat SQL dengan scripts/csr_set_password.mjs lalu terapkan.`,
      ),
    )
  } finally {
    saving.value = false
  }
}

/**
 * 최종 접속 (2026-09-14) — 오늘·어제는 말로, 그 밖은 날짜로. 한 번도 안 들어온 계정은 「—」.
 * 값은 세션 확인 때마다 갱신되므로 '마지막 로그인'이 아니라 '마지막 사용' 입니다(db/029).
 */
const lastSeen = (u) => {
  if (!u.last_seen_at) return '—'
  const day = String(u.last_seen_at).slice(0, 10)
  const today = new Date()
  const d0 = today.toISOString().slice(0, 10)
  const d1 = new Date(today.getTime() - 864e5).toISOString().slice(0, 10)
  if (day === d0) return t('오늘', 'Hari ini')
  if (day === d1) return t('어제', 'Kemarin')
  return day
}
const userName = (id) => users.value.find((u) => u.user_id === id)?.display_name ?? id ?? '—'
</script>

<template>
  <DefaultLayout>
    <section class="admin">
      <div class="headline">
        <div class="page-titles">
          <h1 class="page-title">Admin</h1>
          <p class="page-sub mb-0">{{ t('관리', 'Administrasi') }}</p>
        </div>
      </div>

      <div v-if="loading" class="asm-panel state" role="status">{{ t('불러오는 중…', 'Memuat…') }}</div>
      <div v-else-if="error" class="asm-panel state err" role="alert">{{ error }}</div>
      <CsrSignIn v-else-if="!session.isAuthenticated" />
      <div v-else-if="!session.isAdmin" class="asm-panel state">
        {{ t('관리자만 볼 수 있습니다', 'Hanya untuk admin') }} ({{
          session.role ?? t('미등록', 'belum terdaftar')
        }})
      </div>

      <template v-else>
        <div class="tabs" role="tablist" :aria-label="t('관리 구역', 'Bagian administrasi')">
          <button
            v-for="tb in [
              { k: 'users', ko: '사용자 · 역할', id: 'Pengguna · Peran', n: users.length },
              { k: 'log', ko: '상태 변경 로그', id: 'Log perubahan', n: log.length },
              { k: 'logins', ko: '접속 로그', id: 'Log akses', n: logins.length },
            ]"
            :id="`tab-${tb.k}`"
            :key="tb.k"
            :ref="(el) => (tabEls[tb.k] = el)"
            type="button"
            role="tab"
            :aria-selected="tab === tb.k"
            :aria-controls="`panel-${tb.k}`"
            :tabindex="tab === tb.k ? 0 : -1"
            :class="{ active: tab === tb.k }"
            @click="tab = tb.k"
            @keydown="onTabKey"
          >
            {{ t(tb.ko, tb.id) }}
            <span class="count-pill">{{ tb.n }}</span>
          </button>
        </div>

        <!-- ── 사용자 · 역할 ── -->
        <section
          v-if="tab === 'users'"
          id="panel-users"
          role="tabpanel"
          aria-labelledby="tab-users"
          class="asm-panel sec"
        >
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
                  name="email"
                  autocomplete="email"
                  spellcheck="false"
                  class="form-control form-control-sm"
                  :disabled="!isNew"
                  required
                />
              </label>
              <label class="field">
                <span>{{ t('권한', 'Peran') }}</span>
                <select v-model="form.role" name="role" class="form-select form-select-sm">
                  <option v-for="r in ROLES" :key="r" :value="r">{{ r }}</option>
                </select>
              </label>
              <label class="field">
                <span>{{ t('소속', 'Bagian') }}</span>
                <input
                  v-model="form.department"
                  name="department"
                  autocomplete="off"
                  class="form-control form-control-sm"
                  placeholder="sales · import · finance · it…"
                />
              </label>
              <label class="field">
                <span>{{ t('표시 이름', 'Nama tampilan') }}</span>
                <input
                  v-model="form.display_name"
                  name="display_name"
                  autocomplete="off"
                  class="form-control form-control-sm"
                />
              </label>
            </div>
            <p class="muted hint">
              {{
                t(
                  '권한은 admin · it_dept · business 3종뿐입니다. 소속은 표시·집계용이며 권한과 무관합니다.',
                  'Peran hanya admin · it_dept · business. Bagian hanya untuk tampilan dan rekap, tidak terkait izin.',
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
                <span class="num">ID {{ form.user_id }}</span>
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

          <div v-if="removeTarget" class="sub-form rm" role="group" aria-labelledby="rm-title">
            <b id="rm-title">{{
              t(`${removeTarget.email} 을(를) 제외합니다`, `Hapus ${removeTarget.email}`)
            }}</b>
            <p class="muted hint">
              {{
                t(
                  '「역할만 제외」는 CSR 권한만 지웁니다(Neon 로그인 계정은 유지). 「계정까지 삭제」는 로그인 계정도 영구 삭제하며 되돌릴 수 없습니다.',
                  '«Hanya hapus peran» hanya menghapus peran CSR (akun login Neon tetap ada). «Hapus beserta akun» juga menghapus akun login secara permanen dan tidak dapat dibatalkan.',
                )
              }}
            </p>
            <div class="actions">
              <button
                ref="cancelRemoveBtn"
                type="button"
                class="btn btn-outline-secondary btn-sm"
                :disabled="saving"
                @click="removeTarget = null"
              >
                {{ t('취소', 'Batal') }}
              </button>
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                :disabled="saving"
                @click="removeUser(false)"
              >
                {{ t('역할만 제외', 'Hanya hapus peran') }}
              </button>
              <button
                type="button"
                class="btn btn-danger btn-sm"
                :disabled="saving"
                @click="removeUser(true)"
              >
                {{ t('계정까지 삭제', 'Hapus beserta akun') }}
              </button>
            </div>
          </div>

          <div class="table-scroll">
          <table class="table asm-table">
            <thead>
              <tr>
                <th>{{ t('이름', 'Nama') }}</th>
                <th>Email</th>
                <th>{{ t('권한', 'Peran') }}</th>
                <th>{{ t('소속', 'Bagian') }}</th>
                <th class="nowrap cell-date">{{ t('등록일', 'Terdaftar') }}</th>
                <th class="nowrap cell-date">{{ t('최종 접속', 'Akses terakhir') }}</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="u in users"
                :key="u.user_id"
                :class="{ me: u.user_id === session.user?.id }"
              >
                <td class="truncate-cell">{{ u.display_name ?? '—' }}</td>
                <td class="nowrap">{{ u.email }}</td>
                <td>
                  <span class="asm-pill">{{ u.role }}</span>
                </td>
                <td class="truncate-cell">{{ u.department ?? '—' }}</td>
                <td class="nowrap muted cell-date">{{ fmtDate(u.created_at) }}</td>
                <td class="nowrap muted cell-date" :title="fmtTs(u.last_seen_at)">{{ lastSeen(u) }}</td>
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
                    @click="askRemove(u)"
                  >
                    {{ t('제외', 'Hapus') }}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
          </div>

          <!-- 비밀번호 초기화 -->
          <form v-if="pwTarget" class="sub-form pw" @submit.prevent="resetPassword">
            <b>{{ t('비밀번호 초기화', 'Reset kata sandi') }} — {{ pwTarget.email }}</b>
            <div class="grid">
              <label class="field">
                <span>{{ t('새 비밀번호 (8자 이상)', 'Kata sandi baru (min. 8)') }}</span>
                <input
                  v-model="pwValue"
                  type="text"
                  name="new-password"
                  class="form-control form-control-sm"
                  autocomplete="new-password"
                  spellcheck="false"
                  required
                />
              </label>
            </div>
            <p class="muted hint">
              {{
                t(
                  '초기화 후 본인이 로그인해 헤더 계정 메뉴에서 바꾸도록 안내하십시오.',
                  'Setelah reset, minta pengguna masuk lalu menggantinya sendiri lewat menu akun di header.',
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
        <section
          v-else-if="tab === 'log'"
          id="panel-log"
          role="tabpanel"
          aria-labelledby="tab-log"
          class="asm-panel sec"
        >
          <h2 class="asm-title">
            {{ t('상태 변경 로그', 'Log perubahan') }}
            <small>{{ t('최근 200건', '200 terakhir') }}</small>
          </h2>
          <p v-if="!log.length" class="muted">{{ t('기록이 없습니다', 'Belum ada catatan') }}</p>
          <div v-else class="table-scroll">
            <table class="table asm-table">
              <thead>
                <tr>
                  <th class="nowrap cell-date">{{ t('일시', 'Waktu') }}</th>
                  <th class="nowrap">{{ t('이슈', 'Isu') }}</th>
                  <th class="nowrap">{{ t('컬럼', 'Kolom') }}</th>
                  <th>{{ t('이전', 'Sebelum') }}</th>
                  <th>{{ t('이후', 'Sesudah') }}</th>
                  <th class="nowrap">{{ t('변경자', 'Oleh') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="l in log" :key="l.id">
                  <td class="nowrap cell-date">{{ fmtDate(l.changed_at) }}</td>
                  <td class="nowrap">
                    <router-link :to="`/csr/${encodeURIComponent(l.csr_issues?.issue_no ?? '')}`">
                      {{ l.csr_issues?.issue_no ?? l.issue_id }}
                    </router-link>
                  </td>
                  <td class="nowrap">{{ l.column_name }}</td>
                  <td :class="{ nowrap: isDateValue(l.old_value) }">
                    {{ logValue(V(l.old_value)) ?? '—' }}
                  </td>
                  <td :class="{ nowrap: isDateValue(l.new_value) }">
                    {{ logValue(V(l.new_value)) ?? '—' }}
                  </td>
                  <td class="nowrap muted">{{ userName(l.changed_by) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- ── 접속 로그 (회원별 로그인 이력, db/044) ── -->
        <section
          v-else
          id="panel-logins"
          role="tabpanel"
          aria-labelledby="tab-logins"
          class="asm-panel sec"
        >
          <h2 class="asm-title">
            {{ t('접속 로그', 'Log akses') }}
            <small>{{ t('최근 200건', '200 terakhir') }}</small>
          </h2>
          <p v-if="!logins.length" class="muted">
            {{ t('기록이 없습니다', 'Belum ada catatan') }}
          </p>
          <div v-else class="table-scroll">
            <table class="table asm-table">
              <thead>
                <tr>
                  <th class="nowrap cell-date">{{ t('로그인 일시', 'Waktu masuk') }}</th>
                  <th>{{ t('이름', 'Nama') }}</th>
                  <th class="nowrap">Email</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="l in logins" :key="l.id">
                  <td class="nowrap cell-date">{{ fmtTs(l.logged_in_at) }}</td>
                  <td>{{ l.csr_user_roles?.display_name ?? '—' }}</td>
                  <td class="nowrap muted">{{ l.csr_user_roles?.email ?? l.user_id }}</td>
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
.num {
  font-size: 12px;
  font-variant-numeric: tabular-nums;
}
.cell-date {
  text-align: center;
  font-variant-numeric: tabular-nums;
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
  min-height: 36px;
  padding: 6px 12px;
  border-radius: var(--asm-radius-md);
  font-size: 13px;
  font-weight: 500;
  color: var(--asm-nav-fg);
  display: flex;
  align-items: center;
  gap: 6px;
}
.tabs button:hover:not(.active) {
  background: var(--asm-primary-6);
  color: var(--asm-primary);
}
.tabs button:focus-visible {
  outline: 2px solid transparent;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
.tabs button.active {
  background: var(--asm-primary-10);
  color: var(--asm-primary);
  font-weight: 700;
}
.count-pill {
  font-size: 12px;
  font-weight: 700;
  color: var(--asm-primary);
  background: var(--asm-primary-soft);
  padding: 2px 8px;
  border-radius: var(--asm-radius-sm);
}
.sec {
  padding: 20px 24px;
}
/* 좁은 화면 — 패널 안쪽 여백을 본문 여백(16px)에 맞춰 표·글 폭을 넓힙니다(2026-10-23 반응형 점검). */
@media (max-width: 767.98px) {
  .sec {
    padding: 16px;
  }
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
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-md);
  padding: 12px;
  margin-bottom: 12px;
}
.sub-form.rm {
  border-color: var(--asm-danger-border);
  background: var(--asm-danger-soft);
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
  font-size: 12px;
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
.truncate-cell {
  max-width: 220px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.ops {
  text-align: right;
}
.ops .btn {
  min-height: 36px;
}
tr.me td {
  background: var(--asm-primary-6);
}
</style>
