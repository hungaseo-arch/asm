<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { getDb, unwrap } from '../api/neon'
import { addReply, addVerification, loadStatusLog, nullIfBlank, updateIssue } from '../api/issues'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { IT_STATUSES, OPTIONS, STATUS_TONE, canAdd, canEditColumn, isConfigured } from '../config'
import { label, pickLang, pickPair } from '../i18n'

const route = useRoute()
const router = useRouter()
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()

const issue = ref(null)
const replies = ref([])
const verifications = ref([])
const attachments = ref([])
const statusLog = ref([])
const loading = ref(true)
const error = ref('')

const lang = computed(() => issues.lang)
/** 표시 언어에 맞춘 라벨·값. 저장값은 Notion 원문 그대로이고 화면에서만 가릅니다(§8). */
const L = (key) => label(key, lang.value)
const V = (value) => pickLang(value, lang.value)
const role = computed(() => session.role)
const me = computed(() => session.user?.id ?? session.user?.email ?? null)

/**
 * 아카이브된 건과 살아 있는 건이 같은 번호를 쓸 수 있습니다(48·50·52). 번호만으로는
 * 한 건을 특정할 수 없어, 두 건이 잡히면 살아 있는 쪽을 먼저 보여 줍니다.
 */
async function load() {
  if (!isConfigured()) {
    error.value = 'Neon 접속 정보가 설정되지 않았습니다'
    loading.value = false
    return
  }
  loading.value = true
  error.value = ''
  try {
    const db = getDb()
    const rows = unwrap(
      await db.from('csr_issues').select('*').eq('issue_no', route.params.issueNo),
    )
    issue.value = rows?.find((r) => !r.is_archived) ?? rows?.[0] ?? null
    if (!issue.value) {
      error.value = '해당 개선요청을 찾을 수 없습니다'
      return
    }
    const id = issue.value.id
    replies.value = unwrap(await db.from('csr_it_replies').select('*').eq('issue_id', id)) ?? []
    verifications.value =
      unwrap(await db.from('csr_verifications').select('*').eq('issue_id', id)) ?? []
    attachments.value =
      unwrap(await db.from('csr_attachments').select('*').eq('issue_id', id)) ?? []
    statusLog.value = await loadStatusLog(id)
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await session.refresh()
  if (session.isAuthenticated && !session.isUnregistered) await load()
  else loading.value = false
})
watch(() => route.params.issueNo, load)

/** 실패 사유를 사용자 말로. DB 가 권한으로 막은 것과 그 밖의 오류를 구분합니다. */
function report(e, fallback) {
  if (e?.forbidden) toast.error(`권한이 없습니다 — ${e.message}`)
  else toast.error(e?.message ?? fallback)
}

// ─── 속성 편집 ───────────────────────────────────────────────────────────────
/*
 * 편집 모드에서는 issue 의 사본(draft)을 고칩니다. 저장할 때 원본과 달라진 컬럼만 보냅니다 —
 * 컬럼 가드는 '실제로 달라진 컬럼' 만 세므로 안 바뀐 값을 함께 보내도 거부되진 않지만,
 * UPDATE 문과 상태 로그를 깨끗이 두려면 차이만 보내는 게 맞습니다.
 */
const editing = ref(false)
const draft = reactive({})
const saving = ref(false)

/**
 * 편집 대상 컬럼 — 순서가 곧 화면 순서입니다. `it` 표시는 IT부서 전용 5개(작업지시서 §3-2).
 * 라벨은 i18n 사전 키입니다.
 */
const FIELDS = [
  { key: 'menu_main', label: 'menu_main', type: 'select', options: OPTIONS.menu_main },
  { key: 'menu_sub', label: 'menu_sub', type: 'text' },
  { key: 'path_menu', label: 'path_menu', type: 'text' },
  { key: 'issue_type', label: 'issue_type', type: 'select', options: OPTIONS.issue_type },
  { key: 'priority', label: 'priority', type: 'select', options: OPTIONS.priority },
  {
    key: 'go_live_category',
    label: 'go_live_category',
    type: 'select',
    options: OPTIONS.go_live_category,
  },
  { key: 'request_dept', label: 'request_dept', type: 'select', options: OPTIONS.request_dept },
  { key: 'requested_on', label: 'requested_on', type: 'date' },
  { key: 'role_split', label: 'role_split', type: 'select', options: OPTIONS.role_split },
  { key: 'related_issues', label: 'related_issues', type: 'text' },
  { key: 'it_status', label: 'it_status', type: 'select', options: IT_STATUSES, it: true },
  { key: 'it_pic', label: 'it_pic', type: 'text', it: true },
  { key: 'target_release_on', label: 'target_release_on', type: 'date', it: true },
  { key: 'it_decision', label: 'it_decision', type: 'select', options: OPTIONS.it_decision },
  {
    key: 'verification_result',
    label: 'verification_result',
    type: 'select',
    options: OPTIONS.verification_result,
  },
  { key: 'verified_on', label: 'verified_on', type: 'date' },
]
/** 두 언어 쌍으로 된 긴 텍스트 — 속성 카드가 아니라 편집 폼 하단에 따로 둡니다. */
const TEXT_PAIRS = [
  { ko: 'title_ko', id: 'title_id', label: 'title' },
  { ko: 'summary_ko', id: 'summary_id', label: 'summary' },
  { ko: 'acceptance_ko', id: 'acceptance_id', label: 'acceptance' },
  { ko: 'it_reply_summary_ko', id: 'it_reply_summary_id', label: 'it_reply_summary', it: true },
]
const ALL_KEYS = [...FIELDS.map((f) => f.key), ...TEXT_PAIRS.flatMap((p) => [p.ko, p.id])]

/** 이 역할이 이 컬럼을 고칠 수 있는가 — 입력창 활성 여부. 실제 차단은 DB 가 합니다. */
const editable = (key) => {
  if (key === 'it_status' && role.value === 'business') {
    // business 는 Completed 인 건만 Verified 로 닫을 수 있습니다. 그 외 상태면 잠급니다.
    return issue.value?.it_status === 'Completed'
  }
  return canEditColumn(role.value, key)
}
/** it_status 선택지 — business 에게는 Completed → Verified 전이만 보여 줍니다. */
const statusOptions = computed(() =>
  role.value === 'business' ? ['Completed', 'Verified'] : IT_STATUSES,
)
const canEditAnything = computed(() => ALL_KEYS.some(editable))

function startEdit() {
  for (const k of ALL_KEYS) draft[k] = issue.value[k] ?? ''
  editing.value = true
}
async function saveEdit() {
  const patch = {}
  for (const k of ALL_KEYS) {
    if (!editable(k)) continue
    const before = issue.value[k] ?? null
    const after = nullIfBlank(draft[k])
    if (before !== after) patch[k] = after
  }
  if (!Object.keys(patch).length) {
    editing.value = false
    return
  }
  saving.value = true
  try {
    issue.value = await updateIssue(issue.value.id, patch)
    statusLog.value = await loadStatusLog(issue.value.id)
    editing.value = false
    toast.success(`${Object.keys(patch).length}개 항목을 저장했습니다`)
  } catch (e) {
    report(e, '저장에 실패했습니다')
  } finally {
    saving.value = false
  }
}

// ─── 본문(마크다운) 편집 — findings · recommendation · 현업 답변 ───────────────
const today = () => new Date().toISOString().slice(0, 10)
const mdEditing = ref(null)
const mdDraft = ref('')
const mdDate = ref('')
function startMd(key) {
  mdDraft.value = issue.value[key] ?? ''
  if (key === 'business_answer_md') mdDate.value = issue.value.business_answered_on ?? today()
  mdEditing.value = key
}
async function saveMd() {
  const key = mdEditing.value
  const patch = { [key]: nullIfBlank(mdDraft.value) }
  if (key === 'business_answer_md') patch.business_answered_on = nullIfBlank(mdDate.value)
  saving.value = true
  try {
    issue.value = await updateIssue(issue.value.id, patch)
    mdEditing.value = null
    toast.success('저장했습니다')
  } catch (e) {
    report(e, '저장에 실패했습니다')
  } finally {
    saving.value = false
  }
}

// ─── §5 IT부서 회신 추가 ─────────────────────────────────────────────────────
const EMPTY_REPLY = () => ({
  replied_on: today(),
  decision: '',
  fix_plan: '',
  note: '',
  needs_decision: '',
  pic_and_target: '',
})
const replyOpen = ref(false)
const replyDraft = reactive(EMPTY_REPLY())
async function submitReply() {
  saving.value = true
  try {
    const row = await addReply(
      issue.value.id,
      {
        replied_on: replyDraft.replied_on,
        decision: nullIfBlank(replyDraft.decision),
        fix_plan: nullIfBlank(replyDraft.fix_plan),
        note: nullIfBlank(replyDraft.note),
        needs_decision: nullIfBlank(replyDraft.needs_decision),
        pic_and_target: nullIfBlank(replyDraft.pic_and_target),
      },
      me.value,
    )
    replies.value = [row, ...replies.value]
    replyOpen.value = false
    Object.assign(replyDraft, EMPTY_REPLY())
    toast.success('회신을 등록했습니다')
  } catch (e) {
    report(e, '회신 등록에 실패했습니다')
  } finally {
    saving.value = false
  }
}

// ─── §7 검증 이력 추가 ───────────────────────────────────────────────────────
const verifyOpen = ref(false)
const verifyDraft = reactive({ verified_on: today(), result: '', note: '' })
async function submitVerification() {
  if (!verifyDraft.result.trim()) {
    toast.error('결과를 입력하십시오')
    return
  }
  saving.value = true
  try {
    const row = await addVerification(
      issue.value.id,
      {
        verified_on: verifyDraft.verified_on,
        result: verifyDraft.result.trim(),
        note: nullIfBlank(verifyDraft.note),
      },
      me.value,
    )
    verifications.value = [row, ...verifications.value]
    verifyOpen.value = false
    Object.assign(verifyDraft, { verified_on: today(), result: '', note: '' })
    toast.success('검증 이력을 등록했습니다')
  } catch (e) {
    report(e, '검증 이력 등록에 실패했습니다')
  } finally {
    saving.value = false
  }
}

/** 최신이 위로 — 회차가 쌓이면 아래로 스크롤해서 찾게 됩니다. */
const byDateDesc = (k) => (a, b) => String(b[k]).localeCompare(String(a[k]))
const sortedReplies = computed(() => [...replies.value].sort(byDateDesc('replied_on')))
const sortedVerifications = computed(() => [...verifications.value].sort(byDateDesc('verified_on')))
const logOpen = ref(false)

/** Drive 썸네일 — uc?export=view 는 대용량·권한 문제가 있어 쓰지 않습니다(작업지시서 §8). */
const thumb = (fileId) => `https://drive.google.com/thumbnail?id=${fileId}&sz=w1200`
const fmtTs = (ts) => (ts ? String(ts).replace('T', ' ').slice(0, 16) : '')
</script>

<template>
  <DefaultLayout>
    <section class="csr-detail">
      <button type="button" class="btn btn-sm btn-link back" @click="router.push('/csr')">
        ← {{ lang === 'id' ? 'Kembali ke daftar' : '목록으로' }}
      </button>

      <div v-if="loading" class="asm-panel state">{{ L('loading') }}</div>
      <div v-else-if="error" class="asm-panel state err">{{ error }}</div>
      <div v-else-if="!session.isAuthenticated" class="asm-panel state">로그인이 필요합니다</div>

      <template v-else-if="issue">
        <!-- 속성 카드 (작업지시서 §5-2 상단 — 역할별 편집 가능 필드만 활성) -->
        <header class="asm-panel head">
          <div class="head-top">
            <span class="issue-no">{{ issue.issue_no }}</span>
            <span
              class="asm-badge"
              :class="`asm-badge--${STATUS_TONE[issue.it_status] ?? 'neutral'}`"
            >
              {{ issue.it_status }}
            </span>
            <span v-if="issue.is_archived" class="asm-badge asm-badge--neutral">삭제됨</span>
            <span class="asm-pill ms-auto">{{ role }}</span>
            <a
              v-if="issue.notion_url"
              :href="issue.notion_url"
              target="_blank"
              rel="noopener"
              class="notion-link"
            >
              Notion ↗
            </a>
            <button
              v-if="canEditAnything && !editing"
              type="button"
              class="btn btn-sm btn-outline-primary"
              @click="startEdit"
            >
              {{ lang === 'id' ? 'Ubah' : '편집' }}
            </button>
          </div>

          <template v-if="!editing">
            <h1>{{ pickPair(issue.title_ko, issue.title_id, lang) }}</h1>
            <!-- 값은 한 줄 고정 — 화면경로처럼 긴 값이 카드를 세로로 늘리던 것을 막습니다. 전체는 툴팁. -->
            <dl class="props">
              <div v-for="f in FIELDS" :key="f.key">
                <dt>{{ L(f.label) }}</dt>
                <dd :title="V(issue[f.key]) ?? ''">{{ V(issue[f.key]) ?? '—' }}</dd>
              </div>
            </dl>
          </template>

          <!--
            편집 폼 — 잠긴 입력창은 '이 역할이 못 고치는 컬럼' 입니다. 열려 있어도 저장 시
            DB 컬럼 가드가 다시 판정하므로, 개발자 도구로 풀어도 42501 로 거부됩니다.
          -->
          <form v-else class="edit-form" @submit.prevent="saveEdit">
            <div class="grid">
              <label
                v-for="f in FIELDS"
                :key="f.key"
                class="field"
                :class="{ locked: !editable(f.key) }"
              >
                <span>{{ L(f.label) }}<em v-if="f.it" class="tag">IT</em></span>
                <select
                  v-if="f.type === 'select'"
                  v-model="draft[f.key]"
                  class="form-select form-select-sm"
                  :disabled="!editable(f.key)"
                >
                  <option value="">—</option>
                  <option
                    v-for="o in f.key === 'it_status' ? statusOptions : f.options"
                    :key="o"
                    :value="o"
                  >
                    {{ V(o) }}
                  </option>
                </select>
                <input
                  v-else
                  v-model="draft[f.key]"
                  :type="f.type"
                  class="form-control form-control-sm"
                  :disabled="!editable(f.key)"
                />
              </label>
            </div>

            <!-- 두 언어 텍스트는 KO·ID 를 나란히 둡니다 — 한쪽만 고치고 다른 쪽을 잊지 않도록. -->
            <div v-for="p in TEXT_PAIRS" :key="p.ko" class="pair">
              <span class="pair-label">{{ L(p.label) }}<em v-if="p.it" class="tag">IT</em></span>
              <div class="grid">
                <label class="field" :class="{ locked: !editable(p.ko) }">
                  <span>KO</span>
                  <textarea
                    v-model="draft[p.ko]"
                    class="form-control form-control-sm"
                    rows="2"
                    :disabled="!editable(p.ko)"
                  ></textarea>
                </label>
                <label class="field" :class="{ locked: !editable(p.id) }">
                  <span>ID</span>
                  <textarea
                    v-model="draft[p.id]"
                    class="form-control form-control-sm"
                    rows="2"
                    :disabled="!editable(p.id)"
                  ></textarea>
                </label>
              </div>
            </div>

            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="editing = false"
              >
                취소
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
                {{ saving ? '저장 중…' : '저장' }}
              </button>
            </div>
          </form>
        </header>

        <!-- §1 캡쳐 -->
        <section class="asm-panel sec">
          <h2 class="asm-title">1. 캡쳐 · Screen Shot</h2>
          <p v-if="!attachments.length" class="muted">
            첨부가 없습니다. Notion 이관분 38건은 Drive 업로드 프록시(Apps Script) 준비 후 옮깁니다.
          </p>
          <div v-else class="gallery">
            <a
              v-for="a in attachments"
              :key="a.id"
              :href="`https://drive.google.com/file/d/${a.drive_file_id}/view`"
              target="_blank"
              rel="noopener"
            >
              <img :src="thumb(a.drive_file_id)" :alt="a.caption ?? a.file_name ?? ''" />
            </a>
          </div>
        </section>

        <!-- §2 · §3 본문 — business · admin 편집 -->
        <section
          v-for="sec in [
            { key: 'findings_md', title: '2. 현상 · Findings' },
            { key: 'recommendation_md', title: '3. 개선 의견 · Recommendation' },
          ]"
          :key="sec.key"
          class="asm-panel sec"
        >
          <div class="sec-head">
            <h2 class="asm-title">{{ sec.title }}</h2>
            <button
              v-if="editable(sec.key) && mdEditing !== sec.key"
              type="button"
              class="btn btn-sm btn-link"
              @click="startMd(sec.key)"
            >
              편집
            </button>
          </div>
          <template v-if="mdEditing === sec.key">
            <textarea v-model="mdDraft" class="form-control md-edit" rows="10"></textarea>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="mdEditing = null"
              >
                취소
              </button>
              <button
                type="button"
                class="btn btn-primary btn-sm"
                :disabled="saving"
                @click="saveMd"
              >
                저장
              </button>
            </div>
          </template>
          <pre v-else-if="issue[sec.key]" class="md">{{ issue[sec.key] }}</pre>
          <p v-else class="muted">—</p>
        </section>

        <section class="asm-panel sec">
          <h2 class="asm-title">4. {{ L('acceptance') }}</h2>
          <pre class="md">{{
            pickPair(issue.acceptance_ko, issue.acceptance_id, lang) ?? '—'
          }}</pre>
        </section>

        <!-- §5 IT부서 회신 (회차별) — it_dept · admin 추가 -->
        <section class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">5. IT부서 회신 · Balasan Tim IT</h2>
            <button
              v-if="canAdd(role, 'it_replies') && !replyOpen"
              type="button"
              class="btn btn-sm btn-outline-primary"
              @click="replyOpen = true"
            >
              + 회신 추가
            </button>
          </div>

          <form v-if="replyOpen" class="sub-form" @submit.prevent="submitReply">
            <div class="grid">
              <label class="field">
                <span>회신일</span>
                <input
                  v-model="replyDraft.replied_on"
                  type="date"
                  class="form-control form-control-sm"
                  required
                />
              </label>
              <label class="field">
                <span>수용 여부 · Keputusan</span>
                <input v-model="replyDraft.decision" class="form-control form-control-sm" />
              </label>
              <label class="field wide">
                <span>개선 내역 · Perbaikan</span>
                <textarea
                  v-model="replyDraft.fix_plan"
                  class="form-control form-control-sm"
                  rows="2"
                ></textarea>
              </label>
              <label class="field wide">
                <span>추가 설명 · Penjelasan tambahan</span>
                <textarea
                  v-model="replyDraft.note"
                  class="form-control form-control-sm"
                  rows="2"
                ></textarea>
              </label>
              <label class="field">
                <span>의사결정 사항 · Hal yang perlu diputuskan</span>
                <input v-model="replyDraft.needs_decision" class="form-control form-control-sm" />
              </label>
              <label class="field">
                <span>담당자 · 목표 배포일</span>
                <input v-model="replyDraft.pic_and_target" class="form-control form-control-sm" />
              </label>
            </div>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="replyOpen = false"
              >
                취소
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">등록</button>
            </div>
          </form>

          <p v-if="!sortedReplies.length" class="muted">아직 회신이 없습니다.</p>
          <article v-for="r in sortedReplies" :key="r.id" class="reply">
            <h3>{{ r.replied_on }}</h3>
            <dl>
              <div>
                <dt>수용 여부</dt>
                <dd>{{ r.decision ?? '—' }}</dd>
              </div>
              <div>
                <dt>개선 내역</dt>
                <dd>{{ r.fix_plan ?? '—' }}</dd>
              </div>
              <div>
                <dt>추가 설명</dt>
                <dd>{{ r.note ?? '—' }}</dd>
              </div>
              <div>
                <dt>의사결정 사항</dt>
                <dd>{{ r.needs_decision ?? '—' }}</dd>
              </div>
              <div>
                <dt>담당자 · 목표 배포일</dt>
                <dd>{{ r.pic_and_target ?? '—' }}</dd>
              </div>
            </dl>
          </article>
        </section>

        <!-- §6 현업 답변 — business · admin 편집 -->
        <section class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">
              6. 현업 답변 · Tanggapan Tim Bisnis
              <small v-if="issue.business_answered_on">({{ issue.business_answered_on }})</small>
            </h2>
            <button
              v-if="editable('business_answer_md') && mdEditing !== 'business_answer_md'"
              type="button"
              class="btn btn-sm btn-link"
              @click="startMd('business_answer_md')"
            >
              {{ issue.business_answer_md ? '편집' : '+ 답변 작성' }}
            </button>
          </div>
          <template v-if="mdEditing === 'business_answer_md'">
            <label class="field date-field">
              <span>답변일</span>
              <input v-model="mdDate" type="date" class="form-control form-control-sm" />
            </label>
            <textarea v-model="mdDraft" class="form-control md-edit" rows="6"></textarea>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="mdEditing = null"
              >
                취소
              </button>
              <button
                type="button"
                class="btn btn-primary btn-sm"
                :disabled="saving"
                @click="saveMd"
              >
                저장
              </button>
            </div>
          </template>
          <pre v-else-if="issue.business_answer_md" class="md">{{ issue.business_answer_md }}</pre>
          <p v-else class="muted">아직 답변이 없습니다.</p>
        </section>

        <!-- §7 검증 이력 — business · admin 추가 -->
        <section class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">7. 검증 이력 · Riwayat Verifikasi</h2>
            <button
              v-if="canAdd(role, 'verifications') && !verifyOpen"
              type="button"
              class="btn btn-sm btn-outline-primary"
              @click="verifyOpen = true"
            >
              + 검증 추가
            </button>
          </div>

          <form v-if="verifyOpen" class="sub-form" @submit.prevent="submitVerification">
            <div class="grid">
              <label class="field">
                <span>일자</span>
                <input
                  v-model="verifyDraft.verified_on"
                  type="date"
                  class="form-control form-control-sm"
                  required
                />
              </label>
              <label class="field">
                <span>결과 · Hasil</span>
                <input v-model="verifyDraft.result" class="form-control form-control-sm" required />
              </label>
              <label class="field wide">
                <span>내용 · Keterangan</span>
                <textarea
                  v-model="verifyDraft.note"
                  class="form-control form-control-sm"
                  rows="2"
                ></textarea>
              </label>
            </div>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="verifyOpen = false"
              >
                취소
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">등록</button>
            </div>
          </form>

          <p v-if="!sortedVerifications.length" class="muted">검증 이력이 없습니다.</p>
          <table v-else class="table asm-table">
            <thead>
              <tr>
                <th>일자</th>
                <th>결과</th>
                <th>내용</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="v in sortedVerifications" :key="v.id">
                <td class="nowrap">{{ v.verified_on }}</td>
                <td class="nowrap">{{ v.result }}</td>
                <td>{{ v.note }}</td>
              </tr>
            </tbody>
          </table>
        </section>

        <!-- 상태 변경 로그 (접기) — 003 트리거가 자동 적재. 아무도 직접 쓰지 못합니다. -->
        <section class="asm-panel sec">
          <button
            type="button"
            class="log-toggle"
            :aria-expanded="logOpen"
            @click="logOpen = !logOpen"
          >
            <h2 class="asm-title">
              상태 변경 로그 <small>({{ statusLog.length }})</small>
            </h2>
            <span>{{ logOpen ? '접기' : '펼치기' }}</span>
          </button>
          <table v-if="logOpen && statusLog.length" class="table asm-table mt-2">
            <thead>
              <tr>
                <th>일시</th>
                <th>컬럼</th>
                <th>이전</th>
                <th>이후</th>
                <th>변경자</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="l in statusLog" :key="l.id">
                <td class="nowrap">{{ fmtTs(l.changed_at) }}</td>
                <td class="nowrap">{{ l.column_name }}</td>
                <td>{{ V(l.old_value) ?? '—' }}</td>
                <td>{{ V(l.new_value) ?? '—' }}</td>
                <td class="nowrap muted">{{ l.changed_by ?? '—' }}</td>
              </tr>
            </tbody>
          </table>
          <p v-else-if="logOpen" class="muted mt-2">기록이 없습니다.</p>
        </section>
      </template>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.csr-detail {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.back {
  align-self: flex-start;
  padding-left: 0;
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
  margin: 0;
}
.head {
  padding: 20px 24px;
}
.head-top {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.issue-no {
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}
.notion-link {
  font-size: 12px;
}
.head h1 {
  font-size: 20px;
  font-weight: 700;
  margin: 8px 0 16px;
  line-height: 1.4;
}
/* 속성은 격자로 흘립니다 — 항목이 16개라 표로 두면 세로로 길어집니다. */
.props {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 12px 24px;
  margin: 0;
}
.props div {
  min-width: 0;
}
.props dt {
  font-size: 11px;
  color: var(--asm-fg-muted);
  font-weight: 500;
}
/*
 * 값은 한 줄 고정(2026-09-10 요청) — 화면경로처럼 긴 값이 세 줄로 접혀 카드를 늘리던 것을
 * 막습니다. 잘린 부분은 dd 의 title 툴팁으로 봅니다. min-width:0 이 부모에 있어야 격자
 * 칸 안에서 말줄임이 먹습니다.
 */
.props dd {
  margin: 2px 0 0;
  font-size: 13px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.edit-form {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 10px 16px;
}
.field {
  display: flex;
  flex-direction: column;
  gap: 3px;
  min-width: 0;
}
.field.wide {
  grid-column: 1 / -1;
}
.field > span,
.pair-label {
  font-size: 11px;
  font-weight: 500;
  color: var(--asm-fg-muted);
  display: flex;
  align-items: center;
  gap: 6px;
}
/* 잠긴 필드는 흐리게. 왜 잠겼는지는 IT 태그로 힌트를 줍니다. */
.field.locked > span {
  opacity: 0.6;
}
.tag {
  font-style: normal;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.06em;
  color: var(--asm-primary);
  background: var(--asm-primary-10);
  padding: 1px 5px;
  border-radius: var(--asm-radius-sm);
}
.pair {
  border-top: 1px solid var(--asm-border);
  padding-top: 10px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.date-field {
  max-width: 200px;
  margin-bottom: 8px;
}
.actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 4px;
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
.sec-head h2,
.sec > h2 {
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
/*
 * 본문은 Notion 마크다운 원문입니다. 렌더러를 붙이면 의존성이 하나 더 늘고(§9 승인 대상)
 * 원문과 화면이 어긋날 여지가 생겨, 줄바꿈만 지켜 그대로 보여 줍니다.
 */
.md {
  margin: 0;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  font-family: inherit;
  font-size: 13px;
  line-height: 1.7;
}
.md-edit {
  font-family: inherit;
  font-size: 13px;
  line-height: 1.6;
}
.reply {
  border-top: 1px solid var(--asm-border);
  padding-top: 12px;
  margin-top: 12px;
}
.reply:first-of-type {
  border-top: 0;
  padding-top: 0;
  margin-top: 0;
}
.reply h3 {
  font-size: 13px;
  font-weight: 700;
  color: var(--asm-primary);
  margin: 0 0 8px;
}
.reply dl {
  margin: 0;
  display: grid;
  gap: 8px;
}
.reply dt {
  font-size: 11px;
  color: var(--asm-fg-muted);
}
.reply dd {
  margin: 2px 0 0;
  font-size: 13px;
  overflow-wrap: anywhere;
}
.gallery {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}
.gallery img {
  max-height: 200px;
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-md);
}
.nowrap {
  white-space: nowrap;
}
.log-toggle {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border: 0;
  background: transparent;
  padding: 0;
  text-align: left;
  font-size: 12px;
  color: var(--asm-fg-muted);
}
</style>
