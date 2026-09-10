<script setup>
import { computed, onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { IT_STATUSES, STATUS_TONE, isConfigured } from '../config'
import { label, pickLang, toneOf } from '../i18n'
import { formatInt } from '@/utils/format'
import CsrSignIn from '../components/CsrSignIn.vue'
import CsrLangToggle from '../components/CsrLangToggle.vue'
import {
  VERIFY_CODES,
  isPendingVerification,
  itStatusTitle,
  mapLegacyVerifyStatus,
  verifyCodeOf,
  verifyTitle,
} from '../status'

/**
 * 대시보드 (작업지시서 §5-2)
 *   카드: 전체 · Open · Ongoing · Completed(검증 대기) · Verified
 *   표 1: IT상태 × 현업검증 교차
 *   목록 1: 오픈 前 필수 잔여 (Verified 가 아닌 것)
 *   목록 2: 미회신 (IT수용여부 = 미회신)
 *   표 2: 담당자별 Open + Ongoing
 *
 * 목록 스토어의 63건을 그대로 집계합니다 — 63건 규모에서 서버 집계를 따로 두면
 * 두 곳의 숫자가 어긋날 여지만 생깁니다. 아카이브(삭제) 3건은 전부 제외합니다.
 */
const router = useRouter()
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()
const lang = computed(() => issues.lang)
const L = (k) => label(k, lang.value)
const V = (v) => pickLang(v, lang.value)
const t = (ko, id) => (lang.value === 'id' ? id : ko)

onMounted(async () => {
  await session.refresh()
  if (session.isAuthenticated && !session.isUnregistered && !issues.rows.length) await issues.load()
})

const live = computed(() => issues.rows.filter((r) => !r.is_archived))

/**
 * 두 목록은 10건씩 끊어 보입니다(2026-09-10 요청). 34건·22건이 한 번에 늘어지면 두 패널의
 * 높이가 달라 화면이 기웁니다. 페이지는 목록마다 따로 셉니다.
 */
const PAGE_SIZE = 10
const page = reactive({ pending: 1, noreply: 1 })
const pageCount = (list) => Math.max(1, Math.ceil(list.length / PAGE_SIZE))
const slicePage = (list, key) => {
  // 필터가 바뀌어 페이지 수가 줄면 마지막 페이지로 되돌립니다.
  if (page[key] > pageCount(list)) page[key] = pageCount(list)
  return list.slice((page[key] - 1) * PAGE_SIZE, page[key] * PAGE_SIZE)
}
const pagedPending = computed(() => slicePage(pendingVerify.value, 'pending'))
const pagedNoReply = computed(() => slicePage(noReply.value, 'noreply'))
const c = computed(() => issues.counts)

/**
 * 현업검증 열 — 코드 5종(status.js) 순서로, 데이터에 있는 것만. 종전 표기("조치확인 / …")와 코드가
 * 섞여 있어도 한 열로 모읍니다(016 적용 전후 모두 같은 표). 모르는 값은 뒤에 원문대로.
 */
const vcode = (r) => mapLegacyVerifyStatus(r.verification_result) ?? r.verification_result ?? ''
const verifValues = computed(() => {
  const present = new Set(live.value.map(vcode).filter(Boolean))
  return [
    ...VERIFY_CODES.filter((c) => present.has(c)),
    ...[...present].filter((v) => !VERIFY_CODES.includes(v)).sort(),
  ]
})
const cross = computed(() => {
  const m = {}
  for (const r of live.value) {
    const k = `${r.it_status}|${vcode(r)}`
    m[k] = (m[k] ?? 0) + 1
  }
  return m
})
const rowTotal = (s) => live.value.filter((r) => r.it_status === s).length
const colTotal = (v) => live.value.filter((r) => vcode(r) === v).length

/**
 * 검증 대기 — IT 가 Completed 로 회신했는데 현업이 아직 Verified 로 닫지 않은 것.
 * 목록 화면의 「검증 대기」 프리셋(itStatus = Completed)과 같은 기준입니다. 「오픈 前 필수
 * 잔여」 자리에 두던 것을 이 목록으로 바꿨습니다(2026-09-10 요청) — 현업이 지금 해야 할 일이
 * 오픈 구분보다 급합니다.
 */
const pendingVerify = computed(() =>
  live.value
    .filter(isPendingVerification) // 정의는 status.js 한 곳(§C-2)
    .sort((a, b) => a.issue_no.localeCompare(b.issue_no, undefined, { numeric: true })),
)
/** IT부서가 아직 답하지 않은 것 */
const noReply = computed(() =>
  live.value
    .filter((r) => /미회신|Belum Ada Balasan/.test(r.it_decision ?? ''))
    .sort((a, b) => a.issue_no.localeCompare(b.issue_no, undefined, { numeric: true })),
)
/** 담당자별 진행 중(Open + Ongoing) — 담당자 미지정은 '—' 로 묶습니다. */
const byPic = computed(() => {
  const m = new Map()
  for (const r of live.value) {
    if (!['Open', 'Ongoing'].includes(r.it_status)) continue
    const k = r.it_pic?.trim() || '—'
    const v = m.get(k) ?? { open: 0, ongoing: 0 }
    v[r.it_status === 'Open' ? 'open' : 'ongoing']++
    m.set(k, v)
  }
  return [...m.entries()]
    .map(([pic, v]) => ({ pic, ...v, total: v.open + v.ongoing }))
    .sort((a, b) => b.total - a.total || a.pic.localeCompare(b.pic))
})

/**
 * 담당자 표를 두 열로(2026-09-10 「우측 공백 활용」). 한 열 최대 520px 라 오른쪽 절반이 비어
 * 있었습니다. 홀수면 왼쪽이 한 줄 더 가집니다 — 합계 큰 순서가 위→아래, 왼→오른쪽으로 흐릅니다.
 */
const byPicCols = computed(() => {
  const rows = byPic.value
  const half = Math.ceil(rows.length / 2)
  return rows.length > 4 ? [rows.slice(0, half), rows.slice(half)] : [rows]
})

const stripNo = (s) => (s ? String(s).replace(/^[0-9]+[.][ ]*/, '') : s)
const title = (r) =>
  stripNo(lang.value === 'id' ? (r.title_id ?? r.title_ko) : (r.title_ko ?? r.title_id))
const open = (r) => router.push(`/csr/${encodeURIComponent(r.issue_no)}`)
</script>

<template>
  <DefaultLayout>
    <section class="dash">
      <div class="headline">
        <div class="page-titles">
          <h1 class="page-title">Dashboard</h1>
          <p class="page-sub mb-0">Dasbor · 대시보드</p>
        </div>
        <div class="d-flex align-items-center gap-2">
          <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr')">
            ← {{ t('개선요청 목록', 'Daftar permintaan') }}
          </button>
          <!-- 언어 토글 — 목록 툴바에서 옮겼습니다(2026-09-10). 대시보드가 로고 클릭 첫 화면이라 여기가 입구. -->
          <CsrLangToggle v-model="issues.lang" />
        </div>
      </div>

      <div v-if="!isConfigured()" class="asm-panel state">설정이 필요합니다</div>
      <div v-else-if="session.loading || issues.loading" class="asm-panel state">
        {{ L('loading') }}
      </div>
      <CsrSignIn v-else-if="!session.isAuthenticated" />
      <div v-else-if="session.isUnregistered" class="asm-panel state">
        {{ t('접근 권한이 없습니다', 'Tidak memiliki akses') }}
      </div>

      <template v-else>
        <!-- 카드 5장 — 가이드 8-3 KPI 규격(.asm-kpi-*) -->
        <div class="cards">
          <article class="asm-panel card">
            <span class="asm-kpi-label">Total</span>
            <strong class="asm-kpi-value">{{ formatInt(c.total) }}</strong>
            <small class="asm-kpi-delta">{{ t('아카이브 제외', 'tanpa arsip') }}</small>
          </article>
          <article
            v-for="s in ['Open', 'Ongoing', 'Completed', 'Verified']"
            :key="s"
            class="asm-panel card"
            :class="`tone-${STATUS_TONE[s]}`"
          >
            <span class="asm-kpi-label">{{ s }}</span>
            <strong class="asm-kpi-value">{{ formatInt(c[s.toLowerCase()]) }}</strong>
            <small v-if="s === 'Completed'" class="asm-kpi-delta">{{
              t('검증 대기', 'menunggu verifikasi')
            }}</small>
          </article>
        </div>

        <!-- 교차표 — IT상태 × 현업검증 -->
        <section class="asm-panel sec">
          <h2 class="asm-title">
            {{ L('it_status') }} × {{ L('verification_result') }}
            <!-- 상태 명칭 표준화 작업지시서(§3 상태 정의·전환 규칙)로 가는 링크 — 2026-09-10 요청 -->
            <RouterLink to="/csr/status-guide" class="guide-link">
              {{ t('상태 기준', 'Standar status') }} ↗
            </RouterLink>
          </h2>
          <div class="table-scroll">
            <table class="table asm-table cross">
              <thead>
                <tr>
                  <th></th>
                  <th v-for="v in verifValues" :key="v" class="nowrap">
                    <span
                      class="asm-badge"
                      :class="`asm-badge--${toneOf('verification_result', v)}`"
                      :title="verifyTitle(v)"
                    >
                      {{ verifyCodeOf(v) }}
                    </span>
                  </th>
                  <th class="nowrap total">{{ t('합계', 'Total') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="s in IT_STATUSES.filter((x) => rowTotal(x))" :key="s">
                  <th class="nowrap">
                    <span
                      class="asm-badge"
                      :class="`asm-badge--${STATUS_TONE[s]}`"
                      :title="itStatusTitle(s)"
                      >{{ s }}</span
                    >
                  </th>
                  <td v-for="v in verifValues" :key="v" class="num">
                    {{ cross[`${s}|${v}`] ?? '' }}
                  </td>
                  <td class="num total">{{ rowTotal(s) }}</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <th>{{ t('합계', 'Total') }}</th>
                  <td v-for="v in verifValues" :key="v" class="num">{{ colTotal(v) }}</td>
                  <td class="num total">{{ c.total }}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </section>

        <div class="two-col">
          <!-- 검증 대기 (Completed · 현업 검증 필요) -->
          <section class="asm-panel sec">
            <h2 class="asm-title">
              {{ t('현업 검증 대기', 'Menunggu verifikasi Tim Bisnis') }}
              <span class="count-pill">{{ formatInt(pendingVerify.length) }}</span>
            </h2>
            <p v-if="!pendingVerify.length" class="muted">{{ t('없음', 'Tidak ada') }}</p>
            <ul v-else class="list">
              <li v-for="r in pagedPending" :key="r.id" @click="open(r)">
                <span class="no">{{ r.issue_no }}</span>
                <span
                  class="asm-badge"
                  :class="`asm-badge--${STATUS_TONE[r.it_status] ?? 'neutral'}`"
                  >{{ r.it_status }}</span
                >
                <span class="ttl" :title="title(r)">{{ title(r) }}</span>
                <span class="pic">{{ r.it_pic ?? '—' }}</span>
              </li>
            </ul>
            <nav v-if="pendingVerify.length > PAGE_SIZE" class="pager" aria-label="pagination">
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :disabled="page.pending <= 1"
                @click="page.pending--"
              >
                ‹
              </button>
              <span>{{ page.pending }} / {{ pageCount(pendingVerify) }}</span>
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :disabled="page.pending >= pageCount(pendingVerify)"
                @click="page.pending++"
              >
                ›
              </button>
            </nav>
          </section>

          <!-- 미회신 -->
          <section class="asm-panel sec">
            <h2 class="asm-title">
              {{ t('IT부서 미회신', 'Belum ada balasan Tim IT') }}
              <span class="count-pill">{{ formatInt(noReply.length) }}</span>
            </h2>
            <p v-if="!noReply.length" class="muted">{{ t('없음', 'Tidak ada') }}</p>
            <ul v-else class="list">
              <li v-for="r in pagedNoReply" :key="r.id" @click="open(r)">
                <span class="no">{{ r.issue_no }}</span>
                <span
                  class="asm-badge"
                  :class="`asm-badge--${STATUS_TONE[r.it_status] ?? 'neutral'}`"
                  >{{ r.it_status }}</span
                >
                <span class="ttl" :title="title(r)">{{ title(r) }}</span>
                <span class="pic">{{ V(r.priority) ?? '' }}</span>
              </li>
            </ul>
            <nav v-if="noReply.length > PAGE_SIZE" class="pager" aria-label="pagination">
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :disabled="page.noreply <= 1"
                @click="page.noreply--"
              >
                ‹
              </button>
              <span>{{ page.noreply }} / {{ pageCount(noReply) }}</span>
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :disabled="page.noreply >= pageCount(noReply)"
                @click="page.noreply++"
              >
                ›
              </button>
            </nav>
          </section>
        </div>

        <!-- 담당자별 Open + Ongoing -->
        <section class="asm-panel sec">
          <h2 class="asm-title">
            {{ t('담당자별 진행 중', 'Berjalan per PIC') }} <small>Open + Ongoing</small>
          </h2>
          <div class="pic-cols">
            <table v-for="(col, i) in byPicCols" :key="i" class="table asm-table pic-table">
              <thead>
                <tr>
                  <th>{{ L('it_pic') }}</th>
                  <th class="num">Open</th>
                  <th class="num">Ongoing</th>
                  <th class="num total">{{ t('합계', 'Total') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="p in col" :key="p.pic">
                  <td>{{ p.pic }}</td>
                  <td class="num">{{ p.open || '' }}</td>
                  <td class="num">{{ p.ongoing || '' }}</td>
                  <td class="num total">{{ p.total }}</td>
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
.dash {
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
.muted {
  color: var(--asm-fg-muted);
  font-size: 12px;
  margin: 0;
}
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 12px;
}
.card {
  padding: 14px 16px;
  display: flex;
  flex-direction: column;
}
.card .asm-kpi-value {
  font-size: 24px;
  line-height: 1.3;
}
/* 톤 — 가이드 3-3 상태색을 좌측 3px 띠로 */
.tone-danger {
  border-left: 3px solid var(--asm-danger);
}
.tone-info {
  border-left: 3px solid var(--asm-primary);
}
.tone-success {
  border-left: 3px solid var(--asm-success);
}
.tone-primary {
  border-left: 3px solid var(--asm-primary);
}
.sec {
  padding: 20px 24px;
}
.sec > h2 {
  margin: 0 0 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}
.guide-link {
  margin-left: auto;
  font-size: 12px;
  font-weight: 600;
  text-decoration: none;
}
.guide-link:hover {
  text-decoration: underline;
}
.sec small {
  font-weight: 500;
  color: var(--asm-fg-muted);
}
.count-pill {
  font-size: 11px;
  font-weight: 700;
  color: var(--asm-primary);
  background: var(--asm-primary-soft);
  padding: 2px 8px;
  border-radius: 9999px;
}
.table-scroll {
  overflow-x: auto;
}
/* 숫자 칸은 가로 가운데(2026-09-10 요청) — 열 폭이 넓어 오른쪽 정렬이면 헤더와 멀어 보였습니다. */
.num {
  text-align: center;
  font-variant-numeric: tabular-nums;
}
.total {
  font-weight: 700;
}
.nowrap {
  white-space: nowrap;
}
.cross th:first-child {
  white-space: nowrap;
}
.two-col {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
  gap: 16px;
}
.list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
}
.list li {
  display: grid;
  grid-template-columns: auto auto 1fr auto;
  align-items: center;
  gap: 10px;
  padding: 8px 4px;
  border-top: 1px solid var(--asm-border);
  cursor: pointer;
  font-size: 13px;
}
.list li:first-child {
  border-top: 0;
}
.list li:hover {
  background: var(--asm-primary-6);
}
.list .no {
  font-variant-numeric: tabular-nums;
  font-weight: 700;
  min-width: 2.2em;
}
.list .ttl {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.list .pic {
  font-size: 12px;
  color: var(--asm-fg-muted);
  white-space: nowrap;
}
.pager {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 10px;
  font-size: 12px;
  color: var(--asm-fg-muted);
  font-variant-numeric: tabular-nums;
}
/* 두 열 — 좁은 화면(두 표가 나란히 못 서는 폭)에서는 자동으로 한 열로 접힙니다. */
.pic-cols {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
  gap: 0 32px;
  align-items: start;
}
.pic-table {
  margin: 0;
}
</style>
