<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import {
  Check,
  ChevronLeft,
  ChevronRight,
  Download,
  FilterX,
  Minus,
  Plus,
  Printer,
  Search,
} from 'lucide-vue-next'
import { toast } from 'vue-sonner'
import { useExcelExport } from '@/composables/useExcelExport'
import AsmBadge from '@/components/common/AsmBadge.vue'
import AsmDateInput from '@/components/common/AsmDateInput.vue'
import SortableHeader from '@/components/common/SortableHeader.vue'
import {
  formatAmount,
  formatDate,
  formatDecimal,
  formatInt,
  formatPercent,
  formatSigned,
  formatWeight,
} from '@/utils/format'
import {
  ACCESS_LEVEL,
  toneOf,
  type ScreenColumn,
  type ScreenDef,
  type ScreenRow,
} from '@/types/list-screen'

const props = defineProps<{ screen: ScreenDef }>()

// ── 상태 (State / Status) ─────────────────────────────────────────────────
const PAGE_SIZES = [10, 30, 50, 100]

const keyword = ref('')
const field = ref('all')
/** 기간 필터 (이슈 24) — 화면의 첫 날짜 열을 기준으로 조회합니다. */
const fromDate = ref('')
const toDate = ref('')
const pageSize = ref(PAGE_SIZES.includes(props.screen.pageSize) ? props.screen.pageSize : 10)
const page = ref(1)
const sortKey = ref<string | null>(null)
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
const filtered = computed<ScreenRow[]>(() => {
  const needle = keyword.value.trim().toLowerCase()
  const dateKey = dateColumn.value?.key
  const from = fromDate.value
  const to = toDate.value

  const result = props.screen.rows.filter((row) => {
    if (needle) {
      const values = field.value === 'all' ? Object.values(row) : [row[field.value]]
      if (!values.some((value) => String(value ?? '').toLowerCase().includes(needle))) return false
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
const totals = computed<Record<string, number>>(() => {
  const sums: Record<string, number> = {}
  for (const key of props.screen.totalKeys) {
    sums[key] = filtered.value.reduce((sum, row) => sum + (Number(row[key]) || 0), 0)
  }
  return sums
})

/** 합계 행에서 라벨 뒤에 이어지는 열들 */
const totalCells = computed(() => props.screen.columns.slice(props.screen.totalLabelSpan - 1))

// ── 서식 (Formatting / Format) ────────────────────────────────────────────
function display(
  column: ScreenColumn,
  value: string | number | undefined,
  row?: ScreenRow,
): string {
  if (value === undefined || value === null || value === '') return '—'
  const numeric = Number(value)
  switch (column.format) {
    case 'int':
      return formatInt(numeric)
    case 'signed':
      return formatSigned(numeric)
    case 'price':
      return formatDecimal(numeric)
    case 'percent':
      return formatPercent(numeric)
    case 'weight':
      return formatWeight(numeric)
    case 'currency': {
      // 행마다 통화가 다른 화면(PPC·Receipt 등)은 같은 행의 통화 열을 씁니다.
      const rowCurrency = column.currencyKey ? String(row?.[column.currencyKey] ?? '') : ''
      const currency = (rowCurrency === 'IDR' || rowCurrency === 'USD' ? rowCurrency : null)
        ?? column.currency
        ?? 'USD'
      return formatAmount(currency, numeric)
    }
    case 'date':
      return formatDate(String(value))
    default:
      return String(value)
  }
}

const cellClass = (column: ScreenColumn, index = -1) => [
  column.align === 'right' ? 'num' : '',
  column.align === 'center' ? 'text-center' : '',
  column.format === 'code' ? 'cell-code' : '',
  // 가로 스크롤 시 문서번호·품명 열을 왼쪽에 고정합니다 (이슈 23).
  index === 0 ? 'col-key' : '',
]

// ── 액션 (Actions / Tindakan) ─────────────────────────────────────────────
function toggleSort(key: string) {
  if (sortKey.value === key) {
    sortAsc.value = !sortAsc.value
  } else {
    sortKey.value = key
    sortAsc.value = true
  }
  page.value = 1
}

function goToPage(next: number) {
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
  <!-- 경로 (Breadcrumb) -->
  <nav class="breadcrumb-bar" aria-label="breadcrumb">
    <span>{{ screen.group }}</span>
    <ChevronRight :size="14" />
    <b>{{ screen.navLabel }}</b>
  </nav>

  <!-- 화면 제목 -->
  <section class="page-heading">
    <div>
      <p class="asm-eyebrow mb-1">{{ screen.group }}</p>
      <h1>{{ screen.title }}</h1>
      <p class="page-sub mb-0">{{ screen.subtitle }}</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-outline-primary" @click="printPage">
        <Printer :size="16" />
        Print
      </button>
      <button type="button" class="btn btn-secondary" @click="exportExcel">
        <Download :size="16" />
        Excel
      </button>
      <button
        type="button"
        class="btn btn-primary"
        @click="toast.info(`${primaryLabel} 등록 화면은 준비 중입니다`)"
      >
        <Plus :size="17" />
        {{ primaryLabel }}
      </button>
    </div>
  </section>

  <!-- 검색 바 (Search / Pencarian) -->
  <section class="asm-panel search-panel mb-3" :class="{ 'no-field': screen.searchFields.length <= 1 }">
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
        <AsmDateInput v-model="fromDate" :aria-label="`${dateColumn.label} from`" @update:model-value="page = 1" />
      </label>
      <label>
        <span class="form-label">{{ dateColumn.label }} to</span>
        <AsmDateInput v-model="toDate" :aria-label="`${dateColumn.label} to`" @update:model-value="page = 1" />
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
              v-for="(column, columnIndex) in screen.columns"
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
          <tr v-for="(row, index) in rows" :key="`${screen.slug}-${rangeStart + index}`">
            <td class="num no-col">{{ formatInt(rangeStart + index) }}</td>
            <td
              v-for="(column, columnIndex) in screen.columns"
              :key="column.key"
              :class="cellClass(column, columnIndex)"
              :style="column.width ? { width: column.width } : undefined"
            >
              <AsmBadge v-if="column.format === 'badge'" :tone="toneOf(String(row[column.key]))" dot>
                {{ row[column.key] }}
              </AsmBadge>
              <template v-else-if="column.format === 'access'">
                <span
                  class="access"
                  :class="`access--${ACCESS_LEVEL[String(row[column.key])]?.tone ?? 'none'}`"
                  :title="ACCESS_LEVEL[String(row[column.key])]?.label ?? String(row[column.key])"
                >{{ ACCESS_LEVEL[String(row[column.key])]?.mark ?? '—' }}</span>
              </template>
              <template v-else-if="column.format === 'mark'">
                <Check v-if="Number(row[column.key])" :size="15" class="mark-yes" />
                <Minus v-else :size="15" class="mark-no" />
              </template>
              <span
                v-else-if="column.ellipsis"
                class="asm-ellipsis"
                :title="String(row[column.key] ?? '')"
              >
                {{ display(column, row[column.key], row) }}
              </span>
              <template v-else>{{ display(column, row[column.key], row) }}</template>
            </td>
          </tr>
          <tr v-if="!rows.length">
            <td :colspan="screen.columns.length + 1" class="empty-row">
              조회된 데이터가 없습니다.
            </td>
          </tr>
        </tbody>
        <!-- 합계는 검색 결과 전체 기준입니다. -->
        <tfoot v-if="screen.totalKeys.length">
          <tr>
            <td :colspan="screen.totalLabelSpan">Total ({{ formatInt(filtered.length) }})</td>
            <td
              v-for="column in totalCells"
              :key="column.key"
              :class="cellClass(column)"
            >
              {{ screen.totalKeys.includes(column.key) ? display(column, totals[column.key]) : '' }}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>

    <!-- 페이지네이션 (Pagination / Penomoran halaman) -->
    <div class="pagination-bar">
      <p class="mb-0">
        Showing <b>{{ formatInt(rangeStart) }}</b>–<b>{{ formatInt(rangeEnd) }}</b> of
        <b>{{ formatInt(filtered.length) }}</b>
      </p>
      <div class="d-flex align-items-center gap-2">
        <button
          type="button" class="asm-icon-btn is-sm" :disabled="safePage === 1"
          aria-label="이전 페이지" @click="goToPage(safePage - 1)"
        >
          <ChevronLeft :size="17" />
        </button>
        <span>Page <b>{{ safePage }}</b> of {{ pageCount }}</span>
        <button
          type="button" class="asm-icon-btn is-sm" :disabled="safePage === pageCount"
          aria-label="다음 페이지" @click="goToPage(safePage + 1)"
        >
          <ChevronRight :size="17" />
        </button>
      </div>
    </div>
  </section>
</template>

<style scoped>
.breadcrumb-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--asm-fg-muted);
  font-size: 12px;
  margin-bottom: 16px;
}
.breadcrumb-bar b { color: var(--asm-fg); }

.page-heading {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 24px;
}
/* 가이드 4-2 — 페이지 제목 text-2xl(24px) / weight 700 / letter-spacing -0.01em */
.page-heading h1 {
  font-size: 24px;
  line-height: 32px;
  letter-spacing: -0.01em;
  margin: 0;
  font-weight: 700;
}
.page-sub { font-size: 12px; color: var(--asm-fg-muted); margin-top: 4px; }
.page-actions { display: flex; gap: 8px; flex-wrap: wrap; }

.search-panel {
  padding: 16px;
  display: grid;
  grid-template-columns: minmax(150px, 200px) minmax(220px, 1fr) repeat(2, minmax(140px, 170px)) auto;
  gap: 12px;
  align-items: end;
}
.search-panel.no-field { grid-template-columns: minmax(220px, 1fr) repeat(2, minmax(140px, 170px)) auto; }
.search-panel label { display: block; min-width: 0; margin: 0; }
.field-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--asm-fg-muted);
  pointer-events: none;
}
.reset-btn { align-self: end; }

.table-panel { overflow: hidden; }
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
.table-toolbar h2 { font-size: 15px; margin: 0; }
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
.rows-select select { width: auto; }

.table-scroll {
  overflow: auto;
  max-height: calc(100vh - 400px);
  min-height: 288px;
  overscroll-behavior: contain;
}
.table-scroll table { min-width: 1200px; }

.no-col { width: 56px; color: var(--asm-fg-muted); }

/* 좌측 고정 열 — No + 첫 열(문서번호·품명). 가이드 8-2 · 개선의견서 이슈 23 */
.table-scroll :is(th, td).no-col { position: sticky; left: 0; z-index: 3; background: var(--asm-bg); }
.table-scroll :is(th, td).col-key {
  position: sticky;
  left: 56px;
  z-index: 3;
  min-width: 168px;
  background: var(--asm-bg);
  box-shadow: 5px 0 7px -7px rgb(8 18 31 / 0.3);
}
.table-scroll thead :is(th.no-col, th.col-key) { z-index: 6; background: var(--asm-muted); }
.table-scroll tbody tr:hover :is(td.no-col, td.col-key) { background: var(--asm-muted); }
.cell-code { font-family: var(--bs-font-monospace); font-size: 12px; color: var(--asm-fg); }
.asm-ellipsis { max-width: 260px; }

/* 권한 수준 기호 — 가이드라인 3장 범례와 동일한 색 체계 */
.access { font-size: 14px; line-height: 1; }
.access--full { color: var(--asm-primary); font-weight: 700; }
.access--edit { color: var(--asm-success-fg); font-weight: 700; }
.access--view { color: var(--bs-info); }
.access--cond { color: var(--asm-warning-fg); font-weight: 700; }
.access--none { color: var(--asm-border-strong); }

.mark-yes { color: var(--asm-success-fg); }
.mark-no { color: var(--asm-border-strong); }

tfoot td {
  position: sticky;
  bottom: 0;
  z-index: 2;
  background: var(--asm-muted);
  color: var(--asm-fg);
  font-weight: 700;
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
  .search-panel { grid-template-columns: 1fr; }
  .table-scroll { max-height: none; }
}
@media (max-width: 767.98px) {
  .page-heading { flex-direction: column; align-items: flex-start; }
}
</style>
