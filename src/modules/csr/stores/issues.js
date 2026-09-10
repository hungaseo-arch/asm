import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { getDb, unwrap } from '../api/neon'
import { isConfigured } from '../config'
import { PENDING_VERIFICATION, VERIFY_CODES, mapLegacyVerifyStatus } from '../status'
import { useIdentityStore } from '@/stores/identity'

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
  /**
   * 화면 언어 — 기본은 현지(인도네시아어), 토글로 한국어 (작업지시서 §1).
   * 진실은 identity 스토어에 있습니다(헤더도 같은 언어를 써야 하므로). 여기서는 읽고 쓰는
   * 통로만 둡니다 — v-model="issues.lang" 이 그대로 동작합니다.
   */
  const identity = useIdentityStore()
  const lang = computed({ get: () => identity.lang, set: (v) => identity.setLang(v) })

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
    // 현업검증은 코드 5종 고정(status.js) — 데이터에서 뽑으면 종전 표기와 코드가 섞여 두 줄이 됩니다.
    verification: VERIFY_CODES,
  }))

  /**
   * 열 정렬(2026-09-10 요청). key 가 null 이면 기본(이슈번호 순). 같은 열을 다시 누르면
   * 방향이 뒤집히고, 세 번째에는 기본으로 돌아갑니다 — 정렬을 풀 별도 버튼이 없어도 되게.
   */
  const sort = ref({ key: null, dir: 'asc' })
  function toggleSort(key) {
    if (sort.value.key !== key) sort.value = { key, dir: 'asc' }
    else if (sort.value.dir === 'asc') sort.value = { key, dir: 'desc' }
    else sort.value = { key: null, dir: 'asc' }
  }

  const filtered = computed(() => {
    const f = filters.value
    const q = f.search.trim().toLowerCase()

    const out = rows.value.filter((r) => {
      if (!f.showArchived && r.is_archived) return false
      if (f.excludeVerified && r.it_status === 'Verified') return false
      if (f.itStatus !== 'All' && r.it_status !== f.itStatus) return false
      if (
        f.verification !== 'All' &&
        mapLegacyVerifyStatus(r.verification_result) !== f.verification
      )
        return false
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

    const byNo = (a, b) => {
      const x = issueNoRank(a.issue_no)
      const y = issueNoRank(b.issue_no)
      return x[0] - y[0] || x[1] - y[1] || x[2].localeCompare(y[2])
    }
    const { key, dir } = sort.value
    if (!key) return out.sort(byNo)
    // 빈 값은 방향과 무관하게 맨 뒤 — '목표배포일 없음' 이 위로 올라오면 정렬한 의미가 없습니다.
    const sign = dir === 'asc' ? 1 : -1
    return out.sort((a, b) => {
      const av = a[key] ?? ''
      const bv = b[key] ?? ''
      if (av === '' && bv === '') return byNo(a, b)
      if (av === '') return 1
      if (bv === '') return -1
      const c =
        key === 'issue_no'
          ? byNo(a, b)
          : String(av).localeCompare(String(bv), undefined, { numeric: true })
      return c * sign || byNo(a, b)
    })
  })

  /** 프리셋 (작업지시서 §5-2) — 필터를 조합해 자주 쓰는 두 가지를 한 번에 겁니다. */
  function applyPreset(name) {
    reset()
    if (name === 'it') {
      // 「IT부서용」 — Verified 를 뺀 나머지. 아직 손이 필요한 건만 봅니다.
      filters.value.excludeVerified = true
    } else if (name === 'pending') {
      // 「검증 대기」 — 정의는 status.js 의 PENDING_VERIFICATION 한 곳(작업지시서 v1.1 §C-2).
      filters.value.itStatus = PENDING_VERIFICATION.itStatus
    }
  }

  function reset() {
    filters.value = { ...EMPTY_FILTERS }
  }

  /**
   * 상세에서 저장한 행을 목록에도 반영 — 목록으로 돌아왔을 때 값이 어긋나지 않게(작업지시서 v1.1 §B-3).
   * 목록 컬럼만 골라 넣습니다(본문 컬럼은 목록 행에 없어도 됩니다).
   */
  function replaceRow(row) {
    if (!row?.id) return
    const i = rows.value.findIndex((r) => r.id === row.id)
    if (i >= 0) rows.value[i] = { ...rows.value[i], ...row }
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
    sort,
    toggleSort,
    counts,
    load,
    reset,
    applyPreset,
    replaceRow,
  }
})
