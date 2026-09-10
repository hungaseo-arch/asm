import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { getDb, unwrap } from '../api/neon'
import { isConfigured } from '../config'

/** 목록에 필요한 열만 가져옵니다 — 본문(findings_md 등)은 상세에서만 씁니다. */
const LIST_COLUMNS = [
  'id',
  'issue_no',
  'title_ko',
  'title_id',
  'menu_main',
  'menu_sub',
  'it_status',
  'it_decision',
  'verification_result',
  'go_live_category',
  'it_pic',
  'priority',
  'it_reply_summary_ko',
  'it_reply_summary_id',
  'target_release_on',
  'is_archived',
].join(',')

const EMPTY_FILTERS = {
  search: '',
  itStatus: 'All',
  verification: 'All',
  menuMain: 'All',
  menuSub: 'All',
  priority: 'All',
  goLive: 'All',
  pic: 'All',
  showArchived: false, // 작업지시서 §5-2 — 아카이브는 기본 숨김
  excludeVerified: false, // 「IT부서용」 프리셋 전용 — 끝난 건을 목록에서 뺍니다
}

/**
 * 이슈 목록 (Issues / Isu)
 *
 * 정렬은 issue_no 오름차순이 기본입니다(§5-2). issue_no 는 '01'·'48'·'CSR-202609-001' 이
 * 섞인 텍스트라 DB 정렬만으로는 자연스러운 순서가 나오지 않아 클라이언트에서 다시 정렬합니다
 * — 63건 규모라 비용이 문제되지 않고, 서버 정렬에 맞추려고 컬럼을 추가하는 것보다 낫습니다.
 */
export const useCsrIssuesStore = defineStore('csr-issues', () => {
  const rows = ref([])
  const loading = ref(false)
  const error = ref('')
  const filters = ref({ ...EMPTY_FILTERS })
  /** 화면 언어 — 기본은 현지(인도네시아어), 토글로 한국어 (작업지시서 §1). */
  const lang = ref('id')

  async function load() {
    if (!isConfigured()) {
      error.value = 'Neon 접속 정보가 설정되지 않았습니다'
      return
    }
    loading.value = true
    error.value = ''
    try {
      rows.value = unwrap(await getDb().from('csr_issues').select(LIST_COLUMNS)) ?? []
    } catch (e) {
      error.value = e.message
      rows.value = []
    } finally {
      loading.value = false
    }
  }

  /** '01' < '02' < … < '60' < 'CSR-202609-001' 순서로 정렬합니다. */
  const issueNoRank = (no) => {
    const n = Number(no)
    return Number.isFinite(n) ? [0, n, ''] : [1, 0, String(no)]
  }

  const uniqueValues = (key) => [...new Set(rows.value.map((r) => r[key]).filter(Boolean))].sort()

  const options = computed(() => ({
    menuMain: uniqueValues('menu_main'),
    menuSub: uniqueValues('menu_sub'),
    priority: uniqueValues('priority'),
    goLive: uniqueValues('go_live_category'),
    pic: uniqueValues('it_pic'),
    itStatus: uniqueValues('it_status'),
    verification: uniqueValues('verification_result'),
  }))

  const filtered = computed(() => {
    const f = filters.value
    const q = f.search.trim().toLowerCase()

    const out = rows.value.filter((r) => {
      if (!f.showArchived && r.is_archived) return false
      if (f.excludeVerified && r.it_status === 'Verified') return false
      if (f.itStatus !== 'All' && r.it_status !== f.itStatus) return false
      if (f.verification !== 'All' && r.verification_result !== f.verification) return false
      if (f.menuMain !== 'All' && r.menu_main !== f.menuMain) return false
      if (f.menuSub !== 'All' && r.menu_sub !== f.menuSub) return false
      if (f.priority !== 'All' && r.priority !== f.priority) return false
      if (f.goLive !== 'All' && r.go_live_category !== f.goLive) return false
      if (f.pic !== 'All' && r.it_pic !== f.pic) return false
      if (q) {
        const hay = `${r.issue_no} ${r.title_ko ?? ''} ${r.title_id ?? ''}`.toLowerCase()
        if (!hay.includes(q)) return false
      }
      return true
    })

    return out.sort((a, b) => {
      const x = issueNoRank(a.issue_no)
      const y = issueNoRank(b.issue_no)
      return x[0] - y[0] || x[1] - y[1] || x[2].localeCompare(y[2])
    })
  })

  /** 프리셋 (작업지시서 §5-2) — 필터를 조합해 자주 쓰는 두 가지를 한 번에 겁니다. */
  function applyPreset(name) {
    reset()
    if (name === 'it') {
      // 「IT부서용」 — Verified 를 뺀 나머지. 아직 손이 필요한 건만 봅니다.
      filters.value.excludeVerified = true
    } else if (name === 'pending') {
      // 「검증 대기」 — IT 가 완료했다고 회신한 건.
      filters.value.itStatus = 'Completed'
    }
  }

  function reset() {
    filters.value = { ...EMPTY_FILTERS }
  }

  const counts = computed(() => {
    const live = rows.value.filter((r) => !r.is_archived)
    const by = (s) => live.filter((r) => r.it_status === s).length
    return {
      total: live.length,
      open: by('Open'),
      ongoing: by('Ongoing'),
      completed: by('Completed'),
      verified: by('Verified'),
      archived: rows.value.length - live.length,
    }
  })

  return {
    rows,
    loading,
    error,
    filters,
    lang,
    options,
    filtered,
    counts,
    load,
    reset,
    applyPreset,
  }
})
