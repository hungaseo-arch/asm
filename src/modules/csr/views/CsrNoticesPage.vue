<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { getDb, unwrap } from '../api/neon'
import { nullIfBlank } from '../api/issues'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { isConfigured } from '../config'
import { markNoticesSeen } from '../notices'
import CsrSignIn from '../components/CsrSignIn.vue'

const router = useRouter()
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()
const lang = computed(() => issues.lang)
const id = (ko, idn) => (lang.value === 'id' ? idn : ko)

const notices = ref([])
const loading = ref(true)
const error = ref('')
const saving = ref(false)
const showExpired = ref(false)

const today = () => new Date().toISOString().slice(0, 10)

async function load() {
  loading.value = true
  error.value = ''
  try {
    notices.value =
      unwrap(
        await getDb()
          .from('csr_notices')
          .select('*')
          .order('is_pinned', { ascending: false })
          .order('published_on', { ascending: false })
          .order('id', { ascending: false }),
      ) ?? []
    // 여기까지 왔으면 다 읽은 것으로 칩니다 — 헤더 종의 빨간 점을 지웁니다.
    markNoticesSeen(notices.value)
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
  if (session.isAuthenticated && !session.isUnregistered) await load()
  else loading.value = false
})

/** 만료된 공지는 접습니다 — 지우지 않습니다. 지난 공지를 나중에 되짚을 일이 있습니다. */
const visible = computed(() =>
  showExpired.value
    ? notices.value
    : notices.value.filter((n) => !n.expires_on || n.expires_on >= today()),
)
const expiredCount = computed(() => notices.value.length - visible.value.length)

// ─── 작성 · 편집 (admin) ─────────────────────────────────────────────────────
const EMPTY = () => ({
  id: null,
  title: '',
  body_md: '',
  is_pinned: false,
  published_on: today(),
  expires_on: '',
})
const form = reactive(EMPTY())
const editing = ref(false)

function startNew() {
  Object.assign(form, EMPTY())
  editing.value = true
}
function startEdit(n) {
  Object.assign(form, {
    id: n.id,
    title: n.title,
    body_md: n.body_md ?? '',
    is_pinned: n.is_pinned,
    published_on: n.published_on,
    expires_on: n.expires_on ?? '',
  })
  editing.value = true
}

function report(e, fallback) {
  if (e?.forbidden) toast.error(`권한이 없습니다 — ${e.message}`)
  else toast.error(e?.message ?? fallback)
}

async function save() {
  if (!form.title.trim()) {
    toast.error(id('제목을 입력하십시오', 'Masukkan judul'))
    return
  }
  const payload = {
    title: form.title.trim(),
    body_md: nullIfBlank(form.body_md),
    is_pinned: form.is_pinned,
    published_on: form.published_on || today(),
    expires_on: nullIfBlank(form.expires_on),
  }
  saving.value = true
  try {
    const db = getDb()
    if (form.id) {
      unwrap(await db.from('csr_notices').update(payload).eq('id', form.id).select('id'))
    } else {
      unwrap(
        await db
          .from('csr_notices')
          .insert({ ...payload, created_by: session.user?.id ?? null })
          .select('id'),
      )
    }
    editing.value = false
    await load()
    toast.success(id('저장했습니다', 'Tersimpan'))
  } catch (e) {
    report(e, '저장에 실패했습니다')
  } finally {
    saving.value = false
  }
}

async function remove(n) {
  if (!window.confirm(id(`「${n.title}」 공지를 삭제할까요?`, `Hapus pengumuman「${n.title}」?`)))
    return
  saving.value = true
  try {
    unwrap(await getDb().from('csr_notices').delete().eq('id', n.id).select('id'))
    await load()
    toast.success(id('삭제했습니다', 'Dihapus'))
  } catch (e) {
    report(e, '삭제에 실패했습니다')
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <DefaultLayout>
    <section class="notices">
      <div class="head">
        <div>
          <p class="asm-eyebrow">Pengumuman · 알림</p>
          <h1 class="asm-title">{{ id('공지사항', 'Pengumuman') }}</h1>
        </div>
        <div class="d-flex gap-2 align-items-center">
          <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr')">
            ← {{ id('개선요청 목록', 'Daftar permintaan') }}
          </button>
          <!-- 쓰기는 admin 만 — 버튼이 없어도 DB 정책이 막지만, 없는 권한을 보여 주지 않습니다. -->
          <button
            v-if="session.isAdmin && !editing"
            type="button"
            class="btn btn-sm btn-primary"
            @click="startNew"
          >
            + {{ id('새 공지', 'Pengumuman baru') }}
          </button>
        </div>
      </div>

      <div v-if="loading" class="asm-panel state">{{ id('불러오는 중…', 'Memuat…') }}</div>
      <div v-else-if="error" class="asm-panel state err">{{ error }}</div>
      <CsrSignIn v-else-if="!session.isAuthenticated" />
      <div v-else-if="session.isUnregistered" class="asm-panel state">
        {{ id('접근 권한이 없습니다', 'Tidak memiliki akses') }} ({{ session.user?.email }})
      </div>

      <template v-else>
        <!-- 작성 폼 (admin) -->
        <form v-if="editing" class="asm-panel editor" @submit.prevent="save">
          <h2 class="asm-title">
            {{ form.id ? id('공지 편집', 'Ubah pengumuman') : id('새 공지', 'Pengumuman baru') }}
          </h2>
          <label class="field">
            <span>{{ id('제목', 'Judul') }}</span>
            <input v-model="form.title" class="form-control" required maxlength="200" />
          </label>
          <label class="field">
            <span>{{ id('내용', 'Isi') }} <small class="muted">(Markdown)</small></span>
            <textarea v-model="form.body_md" class="form-control body" rows="8"></textarea>
          </label>
          <div class="row-fields">
            <label class="field">
              <span>{{ id('게시일', 'Tgl. terbit') }}</span>
              <input v-model="form.published_on" type="date" class="form-control form-control-sm" />
            </label>
            <label class="field">
              <span
                >{{ id('만료일', 'Tgl. berakhir') }}
                <small class="muted">({{ id('선택', 'opsional') }})</small></span
              >
              <input v-model="form.expires_on" type="date" class="form-control form-control-sm" />
            </label>
            <label class="check">
              <input v-model="form.is_pinned" type="checkbox" />
              {{ id('상단 고정', 'Sematkan di atas') }}
            </label>
          </div>
          <div class="actions">
            <button type="button" class="btn btn-outline-secondary btn-sm" @click="editing = false">
              {{ id('취소', 'Batal') }}
            </button>
            <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
              {{ saving ? '…' : id('저장', 'Simpan') }}
            </button>
          </div>
        </form>

        <p v-if="!visible.length" class="asm-panel state muted">
          {{ id('공지가 없습니다.', 'Belum ada pengumuman.') }}
        </p>

        <article
          v-for="n in visible"
          :key="n.id"
          class="asm-panel notice"
          :class="{ pinned: n.is_pinned }"
        >
          <div class="notice-head">
            <span v-if="n.is_pinned" class="asm-badge asm-badge--primary">{{
              id('고정', 'Disematkan')
            }}</span>
            <h2>{{ n.title }}</h2>
            <span class="meta">
              {{ n.published_on }}
              <template v-if="n.expires_on"> · ~{{ n.expires_on }}</template>
            </span>
            <span v-if="session.isAdmin" class="ops">
              <button type="button" class="btn btn-sm btn-link" @click="startEdit(n)">
                {{ id('편집', 'Ubah') }}
              </button>
              <button type="button" class="btn btn-sm btn-link text-danger" @click="remove(n)">
                {{ id('삭제', 'Hapus') }}
              </button>
            </span>
          </div>
          <!-- 마크다운 원문을 줄바꿈만 지켜 보여 줍니다 — 렌더러는 의존성 승인 대상(§9). -->
          <pre v-if="n.body_md" class="md">{{ n.body_md }}</pre>
        </article>

        <button
          v-if="expiredCount"
          type="button"
          class="btn btn-sm btn-link align-self-start"
          @click="showExpired = !showExpired"
        >
          {{
            showExpired
              ? id('만료 공지 접기', 'Sembunyikan yang kedaluwarsa')
              : id(`만료된 공지 ${expiredCount}건 보기`, `Lihat ${expiredCount} yang kedaluwarsa`)
          }}
        </button>
      </template>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.notices {
  display: flex;
  flex-direction: column;
  gap: 16px;
  /* 폭 제한 없음 — 공지 행이 헤더보다 짧아 오른쪽이 비어 보였습니다(2026-09-10 「행 100%」). */
}
.head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.head h1 {
  font-size: 20px;
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
.editor {
  padding: 20px 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.editor h2 {
  margin: 0;
}
.field {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.field > span {
  font-size: 12px;
  font-weight: 500;
}
.body {
  font-family: inherit;
  font-size: 13px;
  line-height: 1.6;
}
.row-fields {
  display: flex;
  gap: 16px;
  align-items: flex-end;
  flex-wrap: wrap;
}
.check {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  padding-bottom: 6px;
}
.actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
.notice {
  padding: 16px 20px;
}
/* 고정 공지는 좌측 3px 블루 세로선 — 가이드 5-2 의 강조 방식 그대로. */
.notice.pinned {
  border-left: 3px solid var(--asm-primary);
}
.notice-head {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 8px;
}
.notice-head h2 {
  font-size: 15px;
  font-weight: 700;
  margin: 0;
  flex: 1 1 auto; /* 제목이 남는 폭을 차지 — 날짜·편집·삭제는 오른쪽 끝에 */
  min-width: 0;
}
.meta {
  font-size: 12px;
  color: var(--asm-fg-muted);
}
.ops {
  margin-left: auto;
  white-space: nowrap;
}
.md {
  margin: 0;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  font-family: inherit;
  font-size: 13px;
  line-height: 1.7;
}
</style>
