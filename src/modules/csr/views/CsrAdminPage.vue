<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { authApi, getDb, unwrap } from '../api/neon'
import { nullIfBlank } from '../api/issues'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { ROLES, isConfigured } from '../config'
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
const authUsers = ref([]) // neon_auth 는 Data API 밖이라 못 읽습니다 — 이메일은 손으로 넣습니다.
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
 * 신규 등록에는 Neon Auth 의 User ID 가 필요합니다. Data API 는 neon_auth 스키마를 노출하지
 * 않아 이메일로 자동 조회할 수 없습니다(004 는 SQL 이라 가능했습니다). 콘솔 Auth → Users
 * 에서 ID 를 복사해 붙여 넣는 방식으로 둡니다 — 새 사용자는 드물어 그 정도가 맞습니다.
 */
async function saveUser() {
  const row = {
    user_id: form.user_id.trim(),
    email: form.email.trim().toLowerCase(),
    role: form.role,
    department: nullIfBlank(form.department),
    display_name: nullIfBlank(form.display_name),
  }
  if (!row.user_id || !row.email) {
    toast.error(t('User ID 와 이메일은 필수입니다', 'User ID dan email wajib diisi'))
    return
  }
  saving.value = true
  try {
    const db = getDb()
    if (isNew.value) unwrap(await db.from('csr_user_roles').insert(row).select('user_id'))
    else {
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
      t(
        `${u.email} 을(를) CSR 사용자에서 제외할까요? 로그인은 되지만 아무것도 보지 못하게 됩니다.`,
        `Hapus ${u.email} dari pengguna CSR?`,
      ),
    )
  )
    return
  saving.value = true
  try {
    unwrap(await getDb().from('csr_user_roles').delete().eq('user_id', u.user_id).select('user_id'))
    await load()
    toast.success(t('제외했습니다', 'Dihapus'))
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
        <p class="asm-eyebrow">Administrasi · 관리</p>
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
                <span
                  >User ID
                  <small class="muted"
                    >({{ t('콘솔 Auth → Users 에서 복사', 'salin dari konsol') }})</small
                  ></span
                >
                <input
                  v-model="form.user_id"
                  class="form-control form-control-sm"
                  :disabled="!isNew"
                  required
                />
              </label>
              <label class="field">
                <span>Email</span>
                <input
                  v-model="form.email"
                  type="email"
                  class="form-control form-control-sm"
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
                  <button
                    type="button"
                    class="btn btn-sm btn-link"
                    @click="
                      pwTarget = u
                      pwValue = ''
                    "
                  >
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
.headline .asm-eyebrow {
  margin: 0;
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
