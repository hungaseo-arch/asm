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
/**
 * 화면 문구 사전 — 토글 언어 하나만 보여 줍니다(2026-09-10 「상세페이지 전체 언어구분」).
 * [ko, id] 순. 저장된 본문(현상·회신 등)은 쓴 사람의 언어 그대로이고, 여기서는 화면
 * 껍데기(절 제목·라벨·버튼·안내·토스트)만 다룹니다.
 */
const DICT = {
  back: ['목록으로', 'Kembali ke daftar'],
  need_login: ['로그인이 필요합니다', 'Silakan masuk terlebih dahulu'],
  not_found: ['해당 개선요청을 찾을 수 없습니다', 'Permintaan perbaikan tidak ditemukan'],
  not_configured: ['Neon 접속 정보가 설정되지 않았습니다', 'Koneksi Neon belum dikonfigurasi'],
  archived: ['삭제됨', 'Dihapus'],
  edit: ['편집', 'Ubah'],
  cancel: ['취소', 'Batal'],
  save: ['저장', 'Simpan'],
  saving: ['저장 중…', 'Menyimpan…'],
  submit: ['등록', 'Kirim'],
  mine: [
    '내 권한으로 고칠 수 있는 항목만 보입니다',
    'Hanya kolom yang boleh Anda ubah yang ditampilkan',
  ],
  sec_capture: ['캡쳐', 'Tangkapan layar'],
  no_capture: [
    '첨부가 없습니다. Notion 이관분 38건은 Drive 업로드 프록시(Apps Script) 준비 후 옮깁니다.',
    'Belum ada lampiran. 38 tangkapan dari Notion dipindahkan setelah proksi unggah Drive siap.',
  ],
  sec_findings: ['현상', 'Temuan'],
  sec_reco: ['개선 의견', 'Rekomendasi'],
  sec_reply: ['IT부서 회신', 'Balasan Tim IT'],
  add_reply: ['+ 회신 추가', '+ Tambah balasan'],
  replied_on: ['회신일', 'Tgl. balasan'],
  decision: ['수용 여부', 'Keputusan'],
  fix_plan: ['개선 내역', 'Perbaikan'],
  note: ['추가 설명', 'Penjelasan tambahan'],
  needs_decision: ['의사결정 사항', 'Hal yang perlu diputuskan'],
  pic_and_target: ['담당자 · 목표 배포일', 'PIC · target rilis'],
  no_reply: ['아직 회신이 없습니다.', 'Belum ada balasan.'],
  sec_answer: ['현업 답변', 'Tanggapan Tim Bisnis'],
  write_answer: ['+ 답변 작성', '+ Tulis tanggapan'],
  answered_on: ['답변일', 'Tgl. tanggapan'],
  no_answer: ['아직 답변이 없습니다.', 'Belum ada tanggapan.'],
  sec_verif: ['검증 이력', 'Riwayat Verifikasi'],
  add_verif: ['+ 검증 추가', '+ Tambah verifikasi'],
  date: ['일자', 'Tanggal'],
  result: ['결과', 'Hasil'],
  content: ['내용', 'Keterangan'],
  no_verif: ['검증 이력이 없습니다.', 'Belum ada riwayat verifikasi.'],
  log: ['상태 변경 로그', 'Log perubahan status'],
  expand: ['펼치기', 'Buka'],
  collapse: ['접기', 'Tutup'],
  ts: ['일시', 'Waktu'],
  column: ['컬럼', 'Kolom'],
  before: ['이전', 'Sebelum'],
  after: ['이후', 'Sesudah'],
  by: ['변경자', 'Oleh'],
  no_log: ['기록이 없습니다.', 'Tidak ada catatan.'],
  forbidden: ['권한이 없습니다', 'Tidak memiliki izin'],
  saved: ['저장했습니다', 'Tersimpan'],
  save_failed: ['저장에 실패했습니다', 'Gagal menyimpan'],
  reply_added: ['회신을 등록했습니다', 'Balasan tersimpan'],
  reply_failed: ['회신 등록에 실패했습니다', 'Gagal menyimpan balasan'],
  result_required: ['결과를 입력하십시오', 'Isi hasil verifikasi'],
  verif_added: ['검증 이력을 등록했습니다', 'Riwayat verifikasi tersimpan'],
  verif_failed: ['검증 이력 등록에 실패했습니다', 'Gagal menyimpan riwayat verifikasi'],
}
const T = (key) => DICT[key]?.[lang.value === 'id' ? 1 : 0] ?? key
/**
 * 값 표시. 화면경로(path_menu)는 예외 — ASM 메뉴 이름(Purchasing > PO > 신규·상세)을 그대로
 * 적은 것이라 언어 토글을 타지 않습니다(2026-09-10 「메뉴언어와 동일하게」). 나머지 옵션값은
 * "조치확인 / Terkonfirmasi" 꼴이라 토글 언어 쪽만 보여 줍니다.
 */
const VF = (key, value) => (key === 'path_menu' ? (value ?? null) : V(value))
/**
 * 본문(마크다운) 표시. 본문은 이슈마다 한 언어로 쓰여 있고(한국어 37건 · 인니어 26건) 번역본
 * 컬럼은 없어 그대로 보여 줍니다. 다만 "**재현 절차 / Langkah reproduksi**" 처럼 **한 줄 안에
 * 두 언어를 " / " 로 이어 둔 제목 줄**만 토글 언어 쪽을 남깁니다(2026-09-10 「63건 언어 분리 확인」).
 * 저장값은 손대지 않습니다 — 화면에서만 가릅니다(§8).
 */
// 제목 줄(** 또는 # 로 시작)만 대상 — 본문 문장이나 목록 항목의 "A / B" 는 건드리지 않습니다.
const MD_BILINGUAL_LINE =
  /^([ ]*(?:[*]{2}|#+[ ]+))([^/\n]{1,60}?)[ ]+[/][ ]+([^/\n]{1,60}?)((?:[*]{2})?[ ]*)$/
const md = (text) =>
  text == null
    ? text
    : String(text)
        .split('\n')
        .map((line) => {
          const mm = line.match(MD_BILINGUAL_LINE)
          if (!mm) return line
          const [, open, a, b, close] = mm
          const koFirst = /[가-힣]/.test(a)
          const pick = lang.value === 'id' ? (koFirst ? b : a) : koFirst ? a : b
          return open + pick + close
        })
        .join('\n')
/**
 * 화면경로가 여럿이면 " · "(양쪽 공백) 로 이어져 있습니다 — "신규·상세" 처럼 공백 없는 가운뎃점은
 * 한 경로 안의 구분이라 건드리지 않습니다. 경로마다 칩으로 그려 어디서 끊기는지 보이게
 * 합니다(2026-09-10 「구분이 잘 되도록」).
 */
const splitPaths = (v) =>
  String(v ?? '')
    .split(/\s+·\s+/)
    .map((x) => x.trim())
    .filter(Boolean)
/** 제목 앞 "02. " 번호는 뗍니다 — 이슈번호가 바로 위에 따로 있습니다. 저장값은 원문 그대로. */
const stripNo = (v) => (v ? String(v).replace(/^[0-9]+[.][ ]*/, '') : v)
const me = computed(() => session.user?.id ?? session.user?.email ?? null)

/**
 * 아카이브된 건과 살아 있는 건이 같은 번호를 쓸 수 있습니다(48·50·52). 번호만으로는
 * 한 건을 특정할 수 없어, 두 건이 잡히면 살아 있는 쪽을 먼저 보여 줍니다.
 */
async function load() {
  if (!isConfigured()) {
    error.value = T('not_configured')
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
      error.value = T('not_found')
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
  if (e?.forbidden) toast.error(`${T('forbidden')} — ${e.message}`)
  else toast.error(e?.message ?? T(fallback))
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
    const n = Object.keys(patch).length
    toast.success(lang.value === 'id' ? `${n} kolom tersimpan` : `${n}개 항목을 저장했습니다`)
  } catch (e) {
    report(e, 'save_failed')
  } finally {
    saving.value = false
  }
}

// ─── 본문(마크다운) 편집 — findings · recommendation · 현업 답변 ───────────────
const today = () => new Date().toISOString().slice(0, 10)
/*
 * 본문은 010 이후 _ko/_id 쌍으로 저장됩니다(원문 컬럼은 보존). 표시는 토글 언어 쪽, 없으면 반대쪽,
 * 그것도 없으면 원문 컬럼 — 010 을 아직 안 돌린 DB 에서도 그대로 보입니다.
 */
const bodyOf = (key) => {
  const i = issue.value
  if (!i) return null
  const [a, b] =
    lang.value === 'id' ? [i[key + '_id'], i[key + '_ko']] : [i[key + '_ko'], i[key + '_id']]
  return a || b || i[key] || null
}
const mdEditing = ref(null)
const mdDraft = reactive({ ko: '', id: '' })
const mdDate = ref('')
function startMd(key) {
  const i = issue.value
  // 쌍이 비어 있으면 원문을 원문 언어 쪽 칸에 채워 줍니다 — 010 전 데이터도 편집 가능하게.
  const legacy = i[key] ?? ''
  const legacyIsKo = /[가-힣]/.test(legacy)
  mdDraft.ko = i[key + '_ko'] ?? (legacyIsKo ? legacy : '')
  mdDraft.id = i[key + '_id'] ?? (legacyIsKo ? '' : legacy)
  if (key === 'business_answer_md') mdDate.value = i.business_answered_on ?? today()
  mdEditing.value = key
}
async function saveMd() {
  const key = mdEditing.value
  const ko = nullIfBlank(mdDraft.ko)
  const id = nullIfBlank(mdDraft.id)
  // 원문 컬럼도 함께 갱신(한국어 우선) — 쌍을 모르는 곳(대시보드·내보내기)이 옛 값을 보지 않도록.
  const patch = { [key + '_ko']: ko, [key + '_id']: id, [key]: ko ?? id }
  if (key === 'business_answer_md') patch.business_answered_on = nullIfBlank(mdDate.value)
  saving.value = true
  try {
    issue.value = await updateIssue(issue.value.id, patch)
    mdEditing.value = null
    toast.success(T('saved'))
  } catch (e) {
    report(e, 'save_failed')
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
    toast.success(T('reply_added'))
  } catch (e) {
    report(e, 'reply_failed')
  } finally {
    saving.value = false
  }
}

// ─── §7 검증 이력 추가 ───────────────────────────────────────────────────────
const verifyOpen = ref(false)
const verifyDraft = reactive({ verified_on: today(), result: '', note: '' })
async function submitVerification() {
  if (!verifyDraft.result.trim()) {
    toast.error(T('result_required'))
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
    toast.success(T('verif_added'))
  } catch (e) {
    report(e, 'verif_failed')
  } finally {
    saving.value = false
  }
}

/** 최신이 위로 — 회차가 쌓이면 아래로 스크롤해서 찾게 됩니다. */
/**
 * 회신 카드에 보일 항목(2026-09-10 「내용 배치 재구성」). 빈 항목은 '—' 로 자리를 차지하던 것을
 * 빼고, 긴 글(개선 내역·추가 설명)은 전폭, 짧은 것(의사결정·담당자)은 나란히 둡니다.
 * 수용 여부는 카드 머리의 배지로 올립니다.
 */
const REPLY_FIELDS = [
  { key: 'fix_plan', wide: true },
  { key: 'note', wide: true },
  { key: 'needs_decision' },
  { key: 'pic_and_target' },
]
/** Notion 이관분은 빈 칸을 '—' · '-' · '(tidak dicantumkan)' · '(미기재)' 로 적어 두었습니다 — 빈 것으로 칩니다. */
const isBlank = (v) =>
  !v || /^[\s—–\-]*$|^\((tidak dicantumkan|미기재|없음)\)$/i.test(String(v).trim())
const replyFields = (r) => REPLY_FIELDS.filter((f) => !isBlank(r[f.key]))

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
        ← {{ T('back') }}
      </button>

      <div v-if="loading" class="asm-panel state">{{ L('loading') }}</div>
      <div v-else-if="error" class="asm-panel state err">{{ error }}</div>
      <div v-else-if="!session.isAuthenticated" class="asm-panel state">{{ T('need_login') }}</div>

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
            <span v-if="issue.is_archived" class="asm-badge asm-badge--neutral">{{
              T('archived')
            }}</span>
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
              {{ T('edit') }}
            </button>
          </div>

          <template v-if="!editing">
            <h1>{{ stripNo(pickPair(issue.title_ko, issue.title_id, lang)) }}</h1>
            <!-- 값은 한 줄 고정 — 화면경로처럼 긴 값이 카드를 세로로 늘리던 것을 막습니다. 전체는 툴팁. -->
            <dl class="props">
              <!-- 화면경로는 길어서 격자 한 줄을 통째로 씁니다 — 잘라 보이면 어느 화면인지 모릅니다. -->
              <div v-for="f in FIELDS" :key="f.key" :class="{ 'full-row': f.key === 'path_menu' }">
                <dt>{{ L(f.label) }}</dt>
                <dd v-if="f.key === 'path_menu' && issue.path_menu" class="paths">
                  <span v-for="(pth, i) in splitPaths(issue.path_menu)" :key="i" class="path-chip">
                    {{ pth }}
                  </span>
                </dd>
                <dd v-else :title="VF(f.key, issue[f.key]) ?? ''">
                  {{ VF(f.key, issue[f.key]) ?? '—' }}
                </dd>
              </div>
            </dl>
          </template>

          <!--
            편집 폼 — 잠긴 입력창은 '이 역할이 못 고치는 컬럼' 입니다. 열려 있어도 저장 시
            DB 컬럼 가드가 다시 판정하므로, 개발자 도구로 풀어도 42501 로 거부됩니다.
          -->
          <form v-else class="edit-form" @submit.prevent="saveEdit">
            <!--
              내 권한 밖 컬럼은 폼에서 숨깁니다(2026-09-10 「자기 부분만 편집」). 비활성으로만
              두면 '왜 안 되지' 가 되고, 숨기면 '내 몫이 이것' 이 됩니다. 읽기 모드에는 전부 보입니다.
            -->
            <p class="muted mine">
              {{ T('mine') }}
              — <b>{{ role }}</b>
            </p>
            <div class="grid">
              <label v-for="f in FIELDS.filter((x) => editable(x.key))" :key="f.key" class="field">
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
            <div v-for="p in TEXT_PAIRS.filter((x) => editable(x.ko))" :key="p.ko" class="pair">
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
                {{ T('cancel') }}
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
                {{ saving ? T('saving') : T('save') }}
              </button>
            </div>
          </form>
        </header>

        <!-- §1 캡쳐 -->
        <section class="asm-panel sec">
          <h2 class="asm-title">1. {{ T('sec_capture') }}</h2>
          <p v-if="!attachments.length" class="muted">
            {{ T('no_capture') }}
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
            { key: 'findings_md', title: '2. ' + T('sec_findings') },
            { key: 'recommendation_md', title: '3. ' + T('sec_reco') },
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
              {{ T('edit') }}
            </button>
          </div>
          <template v-if="mdEditing === sec.key">
            <div class="md-pair">
              <label class="field">
                <span>KO</span>
                <textarea v-model="mdDraft.ko" class="form-control md-edit" rows="10"></textarea>
              </label>
              <label class="field">
                <span>ID</span>
                <textarea v-model="mdDraft.id" class="form-control md-edit" rows="10"></textarea>
              </label>
            </div>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="mdEditing = null"
              >
                {{ T('cancel') }}
              </button>
              <button
                type="button"
                class="btn btn-primary btn-sm"
                :disabled="saving"
                @click="saveMd"
              >
                {{ T('save') }}
              </button>
            </div>
          </template>
          <pre v-else-if="bodyOf(sec.key)" class="md">{{ md(bodyOf(sec.key)) }}</pre>
          <p v-else class="muted">—</p>
        </section>

        <section class="asm-panel sec">
          <h2 class="asm-title">4. {{ L('acceptance') }}</h2>
          <pre class="md">{{
            md(pickPair(issue.acceptance_ko, issue.acceptance_id, lang)) ?? '—'
          }}</pre>
        </section>

        <!-- §5 IT부서 회신 (회차별) — it_dept · admin 추가 -->
        <section class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">5. {{ T('sec_reply') }}</h2>
            <button
              v-if="canAdd(role, 'it_replies') && !replyOpen"
              type="button"
              class="btn btn-sm btn-outline-primary"
              @click="replyOpen = true"
            >
              {{ T('add_reply') }}
            </button>
          </div>

          <form v-if="replyOpen" class="sub-form" @submit.prevent="submitReply">
            <div class="grid">
              <label class="field">
                <span>{{ T('replied_on') }}</span>
                <input
                  v-model="replyDraft.replied_on"
                  type="date"
                  class="form-control form-control-sm"
                  required
                />
              </label>
              <label class="field">
                <span>{{ T('decision') }}</span>
                <input v-model="replyDraft.decision" class="form-control form-control-sm" />
              </label>
              <label class="field wide">
                <span>{{ T('fix_plan') }}</span>
                <textarea
                  v-model="replyDraft.fix_plan"
                  class="form-control form-control-sm"
                  rows="2"
                ></textarea>
              </label>
              <label class="field wide">
                <span>{{ T('note') }}</span>
                <textarea
                  v-model="replyDraft.note"
                  class="form-control form-control-sm"
                  rows="2"
                ></textarea>
              </label>
              <label class="field">
                <span>{{ T('needs_decision') }}</span>
                <input v-model="replyDraft.needs_decision" class="form-control form-control-sm" />
              </label>
              <label class="field">
                <span>{{ T('pic_and_target') }}</span>
                <input v-model="replyDraft.pic_and_target" class="form-control form-control-sm" />
              </label>
            </div>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="replyOpen = false"
              >
                {{ T('cancel') }}
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
                {{ T('submit') }}
              </button>
            </div>
          </form>

          <p v-if="!sortedReplies.length" class="muted">{{ T('no_reply') }}</p>
          <article v-for="r in sortedReplies" :key="r.id" class="reply">
            <!-- 머리: 회신일 + 수용 여부 배지. 본문: 채워진 항목만, 긴 글은 전폭. -->
            <div class="reply-head">
              <h3>{{ r.replied_on }}</h3>
              <span v-if="r.decision" class="asm-badge asm-badge--info">{{ r.decision }}</span>
            </div>
            <dl v-if="replyFields(r).length" class="reply-body">
              <div v-for="f in replyFields(r)" :key="f.key" :class="{ wide: f.wide }">
                <dt>{{ T(f.key) }}</dt>
                <dd>{{ r[f.key] }}</dd>
              </div>
            </dl>
            <p v-else class="muted">—</p>
          </article>
        </section>

        <!-- §6 현업 답변 — business · admin 편집 -->
        <section class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">
              6. {{ T('sec_answer') }}
              <small v-if="issue.business_answered_on">({{ issue.business_answered_on }})</small>
            </h2>
            <button
              v-if="editable('business_answer_md') && mdEditing !== 'business_answer_md'"
              type="button"
              class="btn btn-sm btn-link"
              @click="startMd('business_answer_md')"
            >
              {{ bodyOf('business_answer_md') ? T('edit') : T('write_answer') }}
            </button>
          </div>
          <template v-if="mdEditing === 'business_answer_md'">
            <label class="field date-field">
              <span>{{ T('answered_on') }}</span>
              <input v-model="mdDate" type="date" class="form-control form-control-sm" />
            </label>
            <div class="md-pair">
              <label class="field">
                <span>KO</span>
                <textarea v-model="mdDraft.ko" class="form-control md-edit" rows="6"></textarea>
              </label>
              <label class="field">
                <span>ID</span>
                <textarea v-model="mdDraft.id" class="form-control md-edit" rows="6"></textarea>
              </label>
            </div>
            <div class="actions">
              <button
                type="button"
                class="btn btn-outline-secondary btn-sm"
                @click="mdEditing = null"
              >
                {{ T('cancel') }}
              </button>
              <button
                type="button"
                class="btn btn-primary btn-sm"
                :disabled="saving"
                @click="saveMd"
              >
                {{ T('save') }}
              </button>
            </div>
          </template>
          <pre v-else-if="bodyOf('business_answer_md')" class="md">{{
            md(bodyOf('business_answer_md'))
          }}</pre>
          <p v-else class="muted">{{ T('no_answer') }}</p>
        </section>

        <!-- §7 검증 이력 — business · admin 추가 -->
        <section class="asm-panel sec">
          <div class="sec-head">
            <h2 class="asm-title">7. {{ T('sec_verif') }}</h2>
            <button
              v-if="canAdd(role, 'verifications') && !verifyOpen"
              type="button"
              class="btn btn-sm btn-outline-primary"
              @click="verifyOpen = true"
            >
              {{ T('add_verif') }}
            </button>
          </div>

          <form v-if="verifyOpen" class="sub-form" @submit.prevent="submitVerification">
            <div class="grid">
              <label class="field">
                <span>{{ T('date') }}</span>
                <input
                  v-model="verifyDraft.verified_on"
                  type="date"
                  class="form-control form-control-sm"
                  required
                />
              </label>
              <label class="field">
                <span>{{ T('result') }}</span>
                <input v-model="verifyDraft.result" class="form-control form-control-sm" required />
              </label>
              <label class="field wide">
                <span>{{ T('content') }}</span>
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
                {{ T('cancel') }}
              </button>
              <button type="submit" class="btn btn-primary btn-sm" :disabled="saving">
                {{ T('submit') }}
              </button>
            </div>
          </form>

          <p v-if="!sortedVerifications.length" class="muted">{{ T('no_verif') }}</p>
          <table v-else class="table asm-table verif">
            <thead>
              <tr>
                <th>{{ T('date') }}</th>
                <th>{{ T('result') }}</th>
                <th>{{ T('content') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="v in sortedVerifications" :key="v.id">
                <td class="nowrap">{{ v.verified_on }}</td>
                <td class="nowrap">{{ v.result }}</td>
                <td class="wrap">{{ v.note }}</td>
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
              {{ T('log') }} <small>({{ statusLog.length }})</small>
            </h2>
            <span>{{ logOpen ? T('collapse') : T('expand') }}</span>
          </button>
          <table v-if="logOpen && statusLog.length" class="table asm-table mt-2">
            <thead>
              <tr>
                <th>{{ T('ts') }}</th>
                <th>{{ T('column') }}</th>
                <th>{{ T('before') }}</th>
                <th>{{ T('after') }}</th>
                <th>{{ T('by') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="l in statusLog" :key="l.id">
                <td class="nowrap">{{ fmtTs(l.changed_at) }}</td>
                <td class="nowrap">{{ l.column_name }}</td>
                <td class="wrap">{{ VF(l.column_name, l.old_value) ?? '—' }}</td>
                <td class="wrap">{{ VF(l.column_name, l.new_value) ?? '—' }}</td>
                <td class="nowrap muted">{{ l.changed_by ?? '—' }}</td>
              </tr>
            </tbody>
          </table>
          <p v-else-if="logOpen" class="muted mt-2">{{ T('no_log') }}</p>
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
.props .full-row {
  grid-column: 1 / -1;
}
/* 화면경로 — 한 줄에 전부. 정말 길면 잘라 보이는 대신 그 칸만 가로 스크롤합니다. */
.props .full-row dd {
  overflow-x: auto;
  text-overflow: clip;
}
.paths {
  display: flex;
  gap: 6px;
  align-items: center;
}
.path-chip {
  display: inline-block;
  padding: 2px 8px;
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-sm);
  background: var(--asm-card);
  white-space: nowrap;
}
.mine {
  margin: 0 0 8px;
}
/*
 * 라벨과 값의 구분(2026-09-10 「메뉴와 내용 구분 시인성」) — 라벨은 작은 대문자 느낌의
 * 회색 굵은 글씨, 값은 본문색. 칸마다 옅은 바탕을 깔아 어느 값이 어느 라벨의 것인지 보이게.
 */
.props > div {
  background: var(--asm-muted-20);
  border-left: 3px solid var(--asm-primary-10);
  border-radius: var(--asm-radius-sm);
  padding: 6px 10px;
}
.props dt {
  font-size: 11px;
  color: var(--asm-fg-muted);
  font-weight: 700;
  letter-spacing: 0.02em;
}
/*
 * 값은 한 줄 고정(2026-09-10 요청) — 화면경로처럼 긴 값이 세 줄로 접혀 카드를 늘리던 것을
 * 막습니다. 잘린 부분은 dd 의 title 툴팁으로 봅니다. min-width:0 이 부모에 있어야 격자
 * 칸 안에서 말줄임이 먹습니다.
 */
.props dd {
  margin: 3px 0 0;
  font-size: 13px;
  color: var(--asm-fg);
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
/* 본문 편집은 KO·ID 나란히 — 한쪽만 고치고 다른 쪽을 잊지 않도록(TEXT_PAIRS 와 같은 이유). */
.md-pair {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 10px 16px;
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
.reply-head {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}
.reply h3 {
  font-size: 13px;
  font-weight: 700;
  color: var(--asm-primary);
  margin: 0;
}
/* 짧은 항목은 나란히, 긴 글(.wide)은 전폭 — 세로로 라벨·값이 번갈아 늘어지던 것을 접습니다. */
.reply-body {
  margin: 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 8px 24px;
}
.reply-body .wide {
  grid-column: 1 / -1;
}
.reply dt {
  font-size: 11px;
  font-weight: 700;
  color: var(--asm-fg-muted);
}
.reply dd {
  margin: 2px 0 0;
  font-size: 13px;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
}
/*
 * 테마의 .table td 는 한 줄 고정(목록 화면용)이라 검증 내용처럼 긴 문장이 패널 밖으로
 * 넘쳤습니다(2026-09-10 「글자넘침」). 본문 칸만 접어 씁니다.
 */
.asm-table td.wrap {
  white-space: normal;
  overflow-wrap: anywhere;
}
/* 본문이 두 줄이 되면 일자·결과가 세로 가운데로 떠 보입니다 — 행 전체를 위쪽 정렬(2026-09-10). */
.verif td,
.verif th {
  vertical-align: top;
}
.verif {
  table-layout: auto;
  width: 100%;
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
