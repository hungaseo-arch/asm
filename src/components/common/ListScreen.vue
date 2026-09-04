<script setup>
import { computed, ref, watch } from 'vue'
import { toast } from 'vue-sonner'
import { useExcelExport } from '@/composables/useExcelExport'
import { provideSidebarSummary } from '@/composables/useSummaryCards'
import AsmDateInput from '@/components/common/AsmDateInput.vue'
import SortableHeader from '@/components/common/SortableHeader.vue'
import ListCellValue from '@/components/common/ListCellValue.vue'
import ListRowDetailModal from '@/components/common/ListRowDetailModal.vue'
import { formatInt } from '@/utils/format'
import { displayColumnValue as display } from '@/utils/list-cell'
import { toneOf } from '@/types/list-screen'
const props = defineProps({ screen: { type: Object, required: true } })
// ── 상태 (State / Status) ─────────────────────────────────────────────────
const PAGE_SIZES = [10, 30, 50, 100]
const keyword = ref('')
const field = ref('all')
/** 기간 필터 (이슈 24) — 화면의 첫 날짜 열을 기준으로 조회합니다. */
const fromDate = ref('')
const toDate = ref('')
const pageSize = ref(PAGE_SIZES.includes(props.screen.pageSize) ? props.screen.pageSize : 10)
const page = ref(1)
const sortKey = ref(null)
const sortAsc = ref(true)
// 화면(라우트)이 바뀌면 검색·정렬 상태를 초기화합니다.
watch(
  () => props.screen.slug,
  () => {
    keyword.value = ''
    field.value = 'all'
    fromDate.value = ''
    toDate.value = ''
    pageSize.value = PAGE_SIZES.includes(props.screen.pageSize) ? props.screen.pageSize : 10
    page.value = 1
    sortKey.value = null
    sortAsc.value = true
  },
)
/** 기간 필터 기준 열 — 날짜 열이 없는 화면(마스터 등)에서는 필터를 숨깁니다. */
const dateColumn = computed(() => props.screen.columns.find((column) => column.format === 'date'))
// ── 파생값 (Derived / Turunan) ────────────────────────────────────────────
const filtered = computed(() => {
  const needle = keyword.value.trim().toLowerCase()
  const dateKey = dateColumn.value?.key
  const from = fromDate.value
  const to = toDate.value
  const result = props.screen.rows.filter((row) => {
    if (needle) {
      const values = field.value === 'all' ? Object.values(row) : [row[field.value]]
      if (
        !values.some((value) =>
          String(value ?? '')
            .toLowerCase()
            .includes(needle),
        )
      )
        return false
    }
    // ISO(YYYY-MM-DD) 문자열은 사전순 비교가 날짜순 비교와 같습니다.
    if (dateKey && (from || to)) {
      const value = String(row[dateKey] ?? '')
      if (!value) return false
      if (from && value < from) return false
      if (to && value > to) return false
    }
    return true
  })
  if (!sortKey.value) return result
  const key = sortKey.value
  const direction = sortAsc.value ? 1 : -1
  return [...result].sort((a, b) => {
    const av = a[key]
    const bv = b[key]
    if (typeof av === 'number' && typeof bv === 'number') return (av - bv) * direction
    return String(av).localeCompare(String(bv)) * direction
  })
})
const pageCount = computed(() => Math.max(1, Math.ceil(filtered.value.length / pageSize.value)))
const safePage = computed(() => Math.min(page.value, pageCount.value))
const rows = computed(() =>
  filtered.value.slice((safePage.value - 1) * pageSize.value, safePage.value * pageSize.value),
)
const rangeStart = computed(() =>
  filtered.value.length ? (safePage.value - 1) * pageSize.value + 1 : 0,
)
const rangeEnd = computed(() => Math.min(safePage.value * pageSize.value, filtered.value.length))
/** 합계는 현재 페이지가 아닌 검색 결과 전체 기준입니다. */
const totals = computed(() => {
  const sums = {}
  for (const key of props.screen.totalKeys) {
    sums[key] = filtered.value.reduce((sum, row) => sum + (Number(row[key]) || 0), 0)
  }
  return sums
})
/**
 * 표에 보일 핵심 열 (Core columns / Kolom inti) — 열이 10개가 넘는 화면(제품·창고 등)이
 * 전부 표시되면 가로 스크롤이 생겨 지저분해 보입니다(2026-09-04 반영). 앞쪽 몇 개만
 * 표에 남기고, 나머지는 행을 클릭하면 뜨는 상세 모달(ListRowDetailModal)에서 보여줍니다.
 * 합계 열(totalKeys)과 상태 배지 열은 표의 다른 기능(합계 행·색상 스캔)과 맞물려 있어
 * 앞쪽 순번과 무관하게 항상 포함합니다.
 */
const CORE_COLUMN_LIMIT = 6
const coreColumns = computed(() => {
  // hideInTable 열은 표에서 빠지지만 상세 모달·엑셀에는 그대로 남습니다.
  const eligible = props.screen.columns.filter((column) => !column.hideInTable)
  const core = eligible.slice(0, CORE_COLUMN_LIMIT)
  const coreKeys = new Set(core.map((column) => column.key))
  const mustInclude = eligible.filter(
    (column) =>
      !coreKeys.has(column.key) &&
      (props.screen.totalKeys.includes(column.key) || column.format === 'badge'),
  )
  return [...core, ...mustInclude]
})
/** 합계 행에서 라벨 뒤에 이어지는 열들 — 표에 실제로 보이는 핵심 열 기준입니다. */
const totalCells = computed(() => coreColumns.value.slice(props.screen.totalLabelSpan - 1))
/** 상세 모달에 띄울 행. null 이면 닫힌 상태입니다. */
const selectedRow = ref(null)
/**
 * 요약 카드 (Summary / Ringkasan) — Purchase PO·Inventory 두 전용 화면에만 있던
 * KPI 카드를, 화면마다 이미 갖고 있는 합계 열(totalKeys)·상태 배지 톤 분류를 그대로
 * 재사용해 모든 목록 화면에 공통으로 붙입니다(2026-09-04 반영). 화면별 수작업 KPI
 * 정의 없이도 "건수 · 합계 열마다 1장 · 주의 필요 건수"가 자동으로 채워집니다.
 */
const statusColumn = computed(() =>
  props.screen.columns.find((column) => column.format === 'badge'),
)
const attentionCount = computed(() => {
  const column = statusColumn.value
  if (!column) return 0
  return filtered.value.filter((row) => {
    const tone = toneOf(String(row[column.key] ?? ''))
    return tone === 'warning' || tone === 'danger'
  }).length
})
const summaryCards = computed(() => {
  const cards = [
    {
      label: 'Total records',
      value: formatInt(filtered.value.length),
      note: 'Current filtered result',
      tone: 'default',
    },
  ]
  for (const key of props.screen.totalKeys) {
    const column = props.screen.columns.find((c) => c.key === key)
    if (!column) continue
    cards.push({
      label: column.label,
      value: display(column, totals.value[key]),
      note: 'Sum of filtered rows',
      tone: column.format === 'currency' ? 'success' : 'default',
    })
  }
  if (statusColumn.value) {
    cards.push({
      label: 'Needs attention',
      value: formatInt(attentionCount.value),
      note: `${statusColumn.value.label} pending or at risk`,
      tone: attentionCount.value > 0 ? 'warning' : 'default',
    })
  }
  return cards
})
// 요약 카드는 본문이 아니라 좌측 레일(AppSummaryRail)에 렌더링합니다 (2026-09-04 이동).
provideSidebarSummary(() => summaryCards.value)
// ── 서식 (Formatting / Format) ────────────────────────────────────────────
// display() 는 utils/list-cell.js 의 displayColumnValue 를 그대로 가져다 씁니다
// (import 구문 참고) — 표·상세 모달·요약 카드가 서식 규칙을 공유합니다.
const cellClass = (column, index = -1) => [
  column.align === 'right' ? 'num' : '',
  column.align === 'center' ? 'text-center' : '',
  column.format === 'code' ? 'cell-code' : '',
  // 가로 스크롤 시 문서번호·품명 열을 왼쪽에 고정합니다 (이슈 23).
  index === 0 ? 'col-key' : '',
]
// ── 액션 (Actions / Tindakan) ─────────────────────────────────────────────
function toggleSort(key) {
  if (sortKey.value === key) {
    sortAsc.value = !sortAsc.value
  } else {
    sortKey.value = key
    sortAsc.value = true
  }
  page.value = 1
}
function goToPage(next) {
  page.value = Math.min(Math.max(1, next), pageCount.value)
}
function resetSearch() {
  keyword.value = ''
  field.value = 'all'
  fromDate.value = ''
  toDate.value = ''
  page.value = 1
}
const { exportRows } = useExcelExport()
/** 검색 결과를 엑셀로 내보냅니다 (지시서 §2 SheetJS · 실행 시점 동적 로딩). */
function exportExcel() {
  void exportRows(
    props.screen.slug,
    props.screen.columns.map((column) => column.label),
    filtered.value.map((row) => props.screen.columns.map((column) => row[column.key] ?? '')),
    props.screen.cardTitle,
  )
}
function printPage() {
  window.print()
}
/** 시안의 "＋ NEW QUOTATION" → 아이콘 + "New quotation" */
const primaryLabel = computed(() => {
  const raw = props.screen.primaryAction.replace(/^[＋+]\s*/, '').trim()
  return raw ? raw.charAt(0) + raw.slice(1).toLowerCase() : 'New'
})
</script>

<template>
  <!--
    화면 제목은 헤더·본문 모두에서 시각적으로 표시하지 않습니다 — 좌측 사이드바의
    활성 항목 강조와 중복되기 때문입니다(2026-09-04 반영). 문서 구조상 h1 은 필요해
    스크린리더 전용으로만 남깁니다.
  -->
  <section class="page-heading">
    <div>
      <h1 class="visually-hidden">{{ screen.title }}</h1>
      <p class="page-sub mb-0">{{ screen.subtitle }}</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-sm btn-outline-primary" @click="printPage">
        <Printer :size="14" />
        Print
      </button>
      <button type="button" class="btn btn-sm btn-secondary" @click="exportExcel">
        <Download :size="14" />
        Excel
      </button>
      <button
        type="button"
        class="btn btn-sm btn-primary"
        @click="toast.info(`${primaryLabel} 등록 화면은 준비 중입니다`)"
      >
        <Plus :size="15" />
        {{ primaryLabel }}
      </button>
    </div>
  </section>

  <!-- 검색 바 (Search / Pencarian) -->
  <section
    class="asm-panel search-panel mb-3"
    :class="{ 'no-field': screen.searchFields.length <= 1 }"
  >
    <label v-if="screen.searchFields.length > 1" class="field-select">
      <span class="form-label">Search field</span>
      <select v-model="field" class="form-select" @change="page = 1">
        <option v-for="option in screen.searchFields" :key="option.key" :value="option.key">
          {{ option.label }}
        </option>
      </select>
    </label>

    <label class="field-keyword">
      <span class="form-label">Keyword</span>
      <div class="position-relative">
        <Search :size="16" class="field-icon" />
        <input
          v-model="keyword"
          type="search"
          class="form-control ps-5"
          :placeholder="screen.searchPlaceholder"
          @input="page = 1"
        />
      </div>
    </label>

    <template v-if="dateColumn">
      <label>
        <span class="form-label">{{ dateColumn.label }} from</span>
        <AsmDateInput
          v-model="fromDate"
          :aria-label="`${dateColumn.label} from`"
          @update:model-value="page = 1"
        />
      </label>
      <label>
        <span class="form-label">{{ dateColumn.label }} to</span>
        <AsmDateInput
          v-model="toDate"
          :aria-label="`${dateColumn.label} to`"
          @update:model-value="page = 1"
        />
      </label>
    </template>

    <button type="button" class="btn btn-outline-primary reset-btn" @click="resetSearch">
      <FilterX :size="15" />
      Reset
    </button>
  </section>

  <!-- 목록 (List / Daftar) -->
  <section class="asm-panel table-panel">
    <div class="table-toolbar">
      <div class="d-flex align-items-center gap-2">
        <h2>{{ screen.cardTitle }}</h2>
        <span class="count-pill">{{ formatInt(filtered.length) }}</span>
      </div>
      <div class="d-flex align-items-center gap-2">
        <label class="rows-select mb-0">
          <span>Rows</span>
          <select v-model.number="pageSize" class="form-select form-select-sm" @change="page = 1">
            <option v-for="value in PAGE_SIZES" :key="value" :value="value">{{ value }}</option>
          </select>
        </label>
      </div>
    </div>

    <div class="table-scroll">
      <table class="table table-hover align-middle">
        <thead>
          <tr>
            <th scope="col" class="no-col">No</th>
            <SortableHeader
              v-for="(column, columnIndex) in coreColumns"
              :key="column.key"
              :class="columnIndex === 0 ? 'col-key' : ''"
              :label="column.label"
              :align="column.align"
              :active="sortKey === column.key"
              :asc="sortAsc"
              @sort="toggleSort(column.key)"
            />
          </tr>
        </thead>
        <tbody>
          <!-- 행 클릭 시 전체 열을 담은 상세 모달을 엽니다 (2026-09-04, 표는 핵심 열만). -->
          <tr
            v-for="(row, index) in rows"
            :key="`${screen.slug}-${rangeStart + index}`"
            class="data-row"
            tabindex="0"
            role="button"
            :aria-label="`${row[screen.columns[0]?.key] ?? '행'} 상세 보기`"
            @click="selectedRow = row"
            @keydown.enter="selectedRow = row"
          >
            <td class="num no-col">{{ formatInt(rangeStart + index) }}</td>
            <td
              v-for="(column, columnIndex) in coreColumns"
              :key="column.key"
              :class="cellClass(column, columnIndex)"
              :style="column.width ? { width: column.width } : undefined"
            >
              <span
                v-if="column.ellipsis"
                class="asm-ellipsis"
                :title="String(row[column.key] ?? '')"
              >
                <ListCellValue :column="column" :value="row[column.key]" :row="row" />
              </span>
              <ListCellValue v-else :column="column" :value="row[column.key]" :row="row" />
            </td>
          </tr>
          <tr v-if="!rows.length">
            <td :colspan="coreColumns.length + 1" class="empty-row">조회된 데이터가 없습니다.</td>
          </tr>
        </tbody>
        <!-- 합계는 검색 결과 전체 기준입니다. -->
        <tfoot v-if="screen.totalKeys.length">
          <tr>
            <td :colspan="screen.totalLabelSpan">Total ({{ formatInt(filtered.length) }})</td>
            <td v-for="column in totalCells" :key="column.key" :class="cellClass(column)">
              {{ screen.totalKeys.includes(column.key) ? display(column, totals[column.key]) : '' }}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>

    <!-- 페이지네이션 (Pagination / Penomoran halaman) -->
    <div class="pagination-bar">
      <p class="mb-0">
        Showing <b>{{ formatInt(rangeStart) }}</b
        >–<b>{{ formatInt(rangeEnd) }}</b> of
        <b>{{ formatInt(filtered.length) }}</b>
      </p>
      <div class="d-flex align-items-center gap-2">
        <button
          type="button"
          class="asm-icon-btn is-sm"
          :disabled="safePage === 1"
          aria-label="이전 페이지"
          @click="goToPage(safePage - 1)"
        >
          <ChevronLeft :size="17" />
        </button>
        <span
          >Page <b>{{ safePage }}</b> of {{ pageCount }}</span
        >
        <button
          type="button"
          class="asm-icon-btn is-sm"
          :disabled="safePage === pageCount"
          aria-label="다음 페이지"
          @click="goToPage(safePage + 1)"
        >
          <ChevronRight :size="17" />
        </button>
      </div>
    </div>
  </section>

  <ListRowDetailModal
    v-if="selectedRow"
    :screen="screen"
    :row="selectedRow"
    @close="selectedRow = null"
  />
</template>

<style scoped>
.page-heading {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 16px;
}
.page-sub {
  font-size: 14px;
  color: var(--asm-fg-muted);
  margin-top: 4px;
}
.page-actions {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.search-panel {
  padding: 16px;
  display: grid;
  grid-template-columns:
    minmax(150px, 200px) minmax(220px, 1fr) repeat(2, minmax(140px, 170px))
    auto;
  gap: 12px;
  align-items: end;
}
.search-panel.no-field {
  grid-template-columns: minmax(220px, 1fr) repeat(2, minmax(140px, 170px)) auto;
}
.search-panel label {
  display: block;
  min-width: 0;
  margin: 0;
}
.field-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--asm-fg-muted);
  pointer-events: none;
}
.reset-btn {
  align-self: end;
}

.table-panel {
  overflow: hidden;
}
.table-toolbar {
  min-height: 64px;
  padding: 12px 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--asm-border);
  gap: 16px;
  flex-wrap: wrap;
}
/* 가이드 7-3 — 카드 제목 16px / 600 */
.table-toolbar h2 {
  font-size: 14px;
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.count-pill {
  font-size: 11px;
  color: var(--asm-fg-muted);
  background: var(--asm-muted);
  border-radius: 20px;
  padding: 2px 8px;
}
.rows-select {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--asm-fg-muted);
}
.rows-select select {
  width: auto;
  min-width: 74px;
}

.table-scroll {
  overflow: auto;
  max-height: calc(100vh - 400px);
  min-height: 288px;
  overscroll-behavior: contain;
}
/*
 * 표에는 핵심 열만 보이므로(coreColumns) 컨테이너 폭에 맞춰 자연스럽게 줄어들게
 * 둡니다 — 예전처럼 항상 1200px 를 강제하면 열이 몇 개든 가로 스크롤이 생겼습니다
 * (2026-09-04 제거). 고정 열(sticky) 최소폭이 실제로 넘칠 때만 overflow-x 로 대응합니다.
 */

.no-col {
  width: 56px;
  color: var(--asm-fg-muted);
}

/* 좌측 고정 열 — No + 첫 열(문서번호·품명). 가이드 8-2 · 개선의견서 이슈 23 */
.table-scroll :is(th, td).no-col {
  position: sticky;
  left: 0;
  z-index: 3;
  background: var(--asm-card);
}
.table-scroll :is(th, td).col-key {
  position: sticky;
  left: 56px;
  z-index: 3;
  min-width: 168px;
  background: var(--asm-card);
  box-shadow: var(--asm-sticky-shadow);
}
/* 헤더는 배경을 채우지 않으므로 고정 열도 카드색을 유지합니다 (가이드 8-1) */
.table-scroll thead :is(th.no-col, th.col-key) {
  z-index: 6;
  background: var(--asm-card);
}
.table-scroll tbody tr:hover :is(td.no-col, td.col-key) {
  background: var(--asm-muted-30);
}
/* 합계 라벨은 가로 스크롤 중에도 좌측에 남습니다 */
.table-scroll tfoot td:first-child {
  position: sticky;
  left: 0;
  z-index: 5;
}
.cell-code {
  font-family: var(--bs-font-monospace);
  font-size: 12px;
  color: var(--asm-fg);
}
.asm-ellipsis {
  max-width: 260px;
}
/* 행 클릭 → 상세 모달 (2026-09-04) — 클릭 가능함을 커서·포커스 링으로 드러냅니다. */
.data-row {
  cursor: pointer;
}
.data-row:focus-visible {
  outline: none;
  box-shadow: inset 0 0 0 2px var(--asm-primary);
}

/* 권한 기호(.access)·불리언 마크(.mark-yes/.mark-no) 스타일은 ListCellValue.vue 로 이동했습니다. */

/* 합계 행 — 색·굵기는 asm-theme.css 의 .table tfoot 규칙(가이드 8-1)을 따릅니다. */
tfoot td {
  position: sticky;
  bottom: 0;
  /* 좌측 고정 열(z-index 3)보다 위에 그려야 합계가 가려지지 않습니다 */
  z-index: 4;
  border-top: 1px solid var(--asm-border);
  white-space: nowrap;
}

.empty-row {
  text-align: center;
  color: var(--asm-fg-muted);
  padding: 48px !important;
  height: auto !important;
}

.pagination-bar {
  height: 56px;
  padding: 0 16px;
  border-top: 1px solid var(--asm-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: var(--asm-fg-muted);
  font-size: 12px;
}

@media (max-width: 991.98px) {
  .search-panel {
    grid-template-columns: 1fr;
  }
  .table-scroll {
    max-height: none;
  }
}
@media (max-width: 767.98px) {
  .page-heading {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
