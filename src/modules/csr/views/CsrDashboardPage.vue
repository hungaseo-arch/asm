<script setup>
import { computed, onMounted, reactive } from 'vue'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { IT_STATUSES, STATUS_TONE, isConfigured } from '../config'
import { issueTitle, label, pickLang } from '../i18n'
import { formatInt } from '@/utils/format'
import CsrSignIn from '../components/CsrSignIn.vue'
import CsrStatusBadge from '../components/CsrStatusBadge.vue'
import { useCsrLang } from '../composables/useCsrLang'
import { VERIFY_CODES, isPendingVerification, mapLegacyVerifyStatus } from '../status'

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
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()
const { lang, t } = useCsrLang()
const L = (k) => label(k, lang.value)
const V = (v) => pickLang(v, lang.value)

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
// 필터가 바뀌어 페이지 수가 줄면 마지막 페이지로 보정합니다(상태를 바꾸지 않는 계산값).
const pageNow = (list, key) => Math.min(page[key], pageCount(list))
const slicePage = (list, key) => {
  const p = pageNow(list, key)
  return list.slice((p - 1) * PAGE_SIZE, p * PAGE_SIZE)
}
const pagedPending = computed(() => slicePage(pendingVerify.value, 'pending'))
const pagedNoReply = computed(() => slicePage(noReply.value, 'noreply'))
const step = (list, key, d) => {
  page[key] = pageNow(list, key) + d
}
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

const title = (r) => issueTitle(r, lang.value)
const issueTo = (r) => `/csr/${encodeURIComponent(r.issue_no)}`
const UNASSIGNED = '—'

/**
 * 숫자 → 목록 이동. 목록 화면이 이미 읽는 쿼리(itStatus · verification · pic)만 씁니다.
 * 목록은 진입 시 쿼리에 있는 키만 덮어쓰므로 목록에 남아 있던 다른 필터는 유지됩니다.
 */
const listTo = (q = {}) => ({ path: '/csr', query: q })
const known = (v) => VERIFY_CODES.includes(v)
</script>

<template>
  <DefaultLayout>
    <section class="dash">
      <div class="headline">
        <div class="page-titles">
          <h1 class="page-title">Dashboard</h1>
          <p class="page-sub mb-0">{{ t('대시보드', 'Dasbor') }}</p>
        </div>
        <!-- 언어 토글은 헤더로 옮겼습니다(2026-09-14, CSR 전체 페이지 공통). -->
      </div>

      <div v-if="!isConfigured()" class="asm-panel state" role="status">
        {{ t('설정이 필요합니다', 'Konfigurasi diperlukan') }}
      </div>
      <div v-else-if="session.loading || issues.loading" class="asm-panel state" role="status">
        {{ L('loading') }}
      </div>
      <CsrSignIn v-else-if="!session.isAuthenticated" />
      <div v-else-if="session.isUnregistered" class="asm-panel state" role="status">
        {{ t('접근 권한이 없습니다', 'Tidak memiliki akses') }}
      </div>
      <div v-else-if="issues.error" class="asm-panel state" role="alert">
        {{ t('목록을 불러오지 못했습니다', 'Gagal memuat daftar') }}
      </div>

      <template v-else>
        <!-- 카드 5장 — 가이드 8-3 KPI 규격(.asm-kpi-*) -->
        <div class="cards">
          <article class="asm-panel card">
            <span class="asm-kpi-label">Total</span>
            <RouterLink
              :to="listTo()"
              class="asm-kpi-value stat-link"
              :aria-label="`Total ${c.total} — ${t('목록 보기', 'Lihat daftar')}`"
              >{{ formatInt(c.total) }}</RouterLink
            >
            <small class="asm-kpi-delta">{{ t('아카이브 제외', 'tanpa arsip') }}</small>
          </article>
          <article
            v-for="s in ['Open', 'Ongoing', 'Completed', 'Verified']"
            :key="s"
            class="asm-panel card"
            :class="`tone-${STATUS_TONE[s]}`"
          >
            <span class="asm-kpi-label">{{ s }}</span>
            <RouterLink
              :to="listTo({ itStatus: s })"
              class="asm-kpi-value stat-link"
              :aria-label="`${s} ${c[s.toLowerCase()]} — ${t('목록 보기', 'Lihat daftar')}`"
              >{{ formatInt(c[s.toLowerCase()]) }}</RouterLink
            >
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
              <caption class="sr-only">
                {{ L('it_status') }} × {{ L('verification_result') }}
              </caption>
              <thead>
                <tr>
                  <th scope="col"><span class="sr-only">{{ L('it_status') }}</span></th>
                  <th v-for="v in verifValues" :key="v" scope="col" class="nowrap num">
                    <CsrStatusBadge kind="verification_result" :value="v" :lang="lang" />
                  </th>
                  <th scope="col" class="nowrap num total">{{ t('합계', 'Total') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="s in IT_STATUSES.filter((x) => rowTotal(x))" :key="s">
                  <th scope="row" class="nowrap">
                    <CsrStatusBadge kind="it_status" :value="s" :lang="lang" />
                  </th>
                  <td v-for="v in verifValues" :key="v" class="num">
                    <RouterLink
                      v-if="cross[`${s}|${v}`] && known(v)"
                      :to="listTo({ itStatus: s, verification: v })"
                      class="cell-link"
                      >{{ cross[`${s}|${v}`] }}</RouterLink
                    >
                    <template v-else>{{ cross[`${s}|${v}`] ?? '' }}</template>
                  </td>
                  <td class="num total">
                    <RouterLink :to="listTo({ itStatus: s })" class="cell-link">{{
                      rowTotal(s)
                    }}</RouterLink>
                  </td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <th scope="row">{{ t('합계', 'Total') }}</th>
                  <td v-for="v in verifValues" :key="v" class="num">
                    <RouterLink v-if="known(v)" :to="listTo({ verification: v })" class="cell-link">{{
                      colTotal(v)
                    }}</RouterLink>
                    <template v-else>{{ colTotal(v) }}</template>
                  </td>
                  <td class="num total">
                    <RouterLink :to="listTo()" class="cell-link">{{ c.total }}</RouterLink>
                  </td>
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
              <li v-for="r in pagedPending" :key="r.id">
                <RouterLink :to="issueTo(r)" class="no row-link">{{ r.issue_no }}</RouterLink>
                <CsrStatusBadge kind="it_status" :value="r.it_status" :lang="lang" />
                <span class="ttl" :title="title(r)">{{ title(r) }}</span>
                <span class="pic"
                  ><span class="sr-only">{{ L('it_pic') }}: </span>{{ r.it_pic ?? UNASSIGNED }}</span
                >
              </li>
            </ul>
            <nav
              v-if="pendingVerify.length > PAGE_SIZE"
              class="pager"
              :aria-label="t('현업 검증 대기 페이지', 'Halaman menunggu verifikasi')"
            >
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :aria-label="t('이전 페이지', 'Halaman sebelumnya')"
                :disabled="pageNow(pendingVerify, 'pending') <= 1"
                @click="step(pendingVerify, 'pending', -1)"
              >
                ‹
              </button>
              <span aria-live="polite"
                >{{ pageNow(pendingVerify, 'pending') }} / {{ pageCount(pendingVerify) }}</span
              >
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :aria-label="t('다음 페이지', 'Halaman berikutnya')"
                :disabled="pageNow(pendingVerify, 'pending') >= pageCount(pendingVerify)"
                @click="step(pendingVerify, 'pending', 1)"
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
              <li v-for="r in pagedNoReply" :key="r.id">
                <RouterLink :to="issueTo(r)" class="no row-link">{{ r.issue_no }}</RouterLink>
                <CsrStatusBadge kind="it_status" :value="r.it_status" :lang="lang" />
                <span class="ttl" :title="title(r)">{{ title(r) }}</span>
                <span class="pic"
                  ><span class="sr-only">{{ L('priority') }}: </span>{{ V(r.priority) ?? '' }}</span
                >
              </li>
            </ul>
            <nav
              v-if="noReply.length > PAGE_SIZE"
              class="pager"
              :aria-label="t('IT부서 미회신 페이지', 'Halaman belum ada balasan Tim IT')"
            >
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :aria-label="t('이전 페이지', 'Halaman sebelumnya')"
                :disabled="pageNow(noReply, 'noreply') <= 1"
                @click="step(noReply, 'noreply', -1)"
              >
                ‹
              </button>
              <span aria-live="polite"
                >{{ pageNow(noReply, 'noreply') }} / {{ pageCount(noReply) }}</span
              >
              <button
                type="button"
                class="btn btn-sm btn-outline-secondary"
                :aria-label="t('다음 페이지', 'Halaman berikutnya')"
                :disabled="pageNow(noReply, 'noreply') >= pageCount(noReply)"
                @click="step(noReply, 'noreply', 1)"
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
              <caption class="sr-only">
                {{ t('담당자별 진행 중', 'Berjalan per PIC') }}
              </caption>
              <thead>
                <tr>
                  <th scope="col">{{ L('it_pic') }}</th>
                  <th scope="col" class="num">Open</th>
                  <th scope="col" class="num">Ongoing</th>
                  <th scope="col" class="num total">{{ t('합계', 'Total') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="p in col" :key="p.pic">
                  <th scope="row" class="pic-name">
                    {{ p.pic === UNASSIGNED ? t('미지정', 'Belum ditentukan') : p.pic }}
                  </th>
                  <td class="num">
                    <RouterLink
                      v-if="p.open && p.pic !== UNASSIGNED"
                      :to="listTo({ pic: p.pic, itStatus: 'Open' })"
                      class="cell-link"
                      >{{ p.open }}</RouterLink
                    >
                    <template v-else>{{ p.open || '' }}</template>
                  </td>
                  <td class="num">
                    <RouterLink
                      v-if="p.ongoing && p.pic !== UNASSIGNED"
                      :to="listTo({ pic: p.pic, itStatus: 'Ongoing' })"
                      class="cell-link"
                      >{{ p.ongoing }}</RouterLink
                    >
                    <template v-else>{{ p.ongoing || '' }}</template>
                  </td>
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
/* 메인화면(대시보드) 글자크기 축소 (2026-10-09 요청, 2단계) — 이 화면 안에서만 적용 */
.page-title {
  font-size: 18px;
}
.page-sub {
  font-size: 14px;
}
.asm-title {
  font-size: 1.0625rem;
}
.asm-kpi-label {
  font-size: 12px;
}
.asm-badge {
  font-size: 12px;
}
.table {
  font-size: 13px;
}
.table thead th {
  font-size: 12px;
}

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
  font-size: 22px;
  line-height: 1.3;
}
/* 톤 — Triple Status Rule: 글자색 · soft 배경 · 테두리 3종을 함께 씁니다(좌측 띠 폐지). */
.tone-danger {
  color: var(--asm-danger-fg);
  background: var(--asm-danger-bg);
  border-color: var(--asm-danger-border);
}
.tone-info,
.tone-primary {
  color: var(--asm-info-fg);
  background: var(--asm-info-bg);
  border-color: var(--asm-info-border);
}
.tone-success {
  color: var(--asm-success-fg);
  background: var(--asm-success-bg);
  border-color: var(--asm-success-border);
}
.card .asm-kpi-label,
.card .asm-kpi-delta {
  color: inherit;
}
.stat-link {
  display: block;
  color: inherit;
  text-decoration: none;
}
.stat-link:hover,
.cell-link:hover {
  text-decoration: underline;
}
.stat-link:focus-visible,
.cell-link:focus-visible {
  outline: 2px solid var(--asm-primary);
  outline-offset: 2px;
}
.cell-link {
  display: inline-block;
  min-width: 1.5em;
  color: inherit;
  text-decoration: none;
  font-weight: inherit;
}
.pic-name {
  font-weight: 400;
  text-align: left;
}
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
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
  font-size: 12px;
  font-weight: 700;
  color: var(--asm-primary);
  background: var(--asm-primary-soft);
  padding: 2px 8px;
  border-radius: 4px;
}
.table-scroll {
  overflow-x: auto;
}
/* 숫자 칸은 가로 가운데(2026-09-10 요청) — 열 폭이 넓어 오른쪽 정렬이면 헤더와 멀어 보였습니다. */
/* th.num 은 asm-theme.css 의 ".table th.num"(동일 우선순위)과 맞붙으므로 선택자를 명시해 헤더도 가운데 정렬로 맞춥니다. */
.num,
.table th.num {
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
  grid-template-columns: repeat(auto-fit, minmax(min(380px, 100%), 1fr));
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
  grid-template-columns: auto auto minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  padding: 8px 4px;
  border-top: 1px solid var(--asm-border);
  position: relative;
  font-size: 13px;
}
.list li:first-child {
  border-top: 0;
}
.list li:hover {
  background: var(--asm-primary-6);
}
/* 행 전체를 번호 링크의 클릭 영역으로 확장(stretched link). 실제 href 라 새 탭·링크 목록에서도 동작합니다. */
.list .row-link {
  color: inherit;
  text-decoration: none;
}
.list .row-link::after {
  content: '';
  position: absolute;
  inset: 0;
}
.list li:has(.row-link:focus-visible) {
  outline: 2px solid var(--asm-primary);
  outline-offset: -2px;
}
.list .row-link:focus-visible {
  outline: none;
}
.list .no {
  font-variant-numeric: tabular-nums;
  font-weight: 700;
  min-width: 2.2em;
}
/* 320px — 번호·배지·담당자를 윗줄에, 제목은 아랫줄 전체 폭에 두 줄까지 보여 줍니다. */
@media (max-width: 520px) {
  .list li {
    grid-template-columns: auto auto minmax(0, 1fr);
    grid-template-areas:
      'no badge pic'
      'ttl ttl ttl';
    row-gap: 4px;
  }
  .list li > .no {
    grid-area: no;
  }
  .list li > :nth-child(2) {
    grid-area: badge;
  }
  .list li > .pic {
    grid-area: pic;
    justify-self: end;
    white-space: normal;
    text-align: right;
  }
  .list li > .ttl {
    grid-area: ttl;
    white-space: normal;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
  }
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
  grid-template-columns: repeat(auto-fit, minmax(min(380px, 100%), 1fr));
  gap: 0 32px;
  align-items: start;
}
.pic-table {
  margin: 0;
}
</style>
