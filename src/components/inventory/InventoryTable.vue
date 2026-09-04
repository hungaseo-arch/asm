<script setup>
import { storeToRefs } from 'pinia'
import { useExcelExport } from '@/composables/useExcelExport'
import AsmBadge from '@/components/common/AsmBadge.vue'
import SortableHeader from '@/components/common/SortableHeader.vue'
import { useInventoryStore } from '@/stores/inventory'
import { formatAmount, formatInt } from '@/utils/format'
import { AGED_STOCK_DAYS, availableOf, statusTone, STATUS_LABEL, valueOf } from '@/types/inventory'
const store = useInventoryStore()
const {
  rows,
  filtered,
  pageSize,
  sortKey,
  sortAsc,
  safePage,
  pageCount,
  rangeStart,
  rangeEnd,
  totalQty,
  totalReserved,
  totalAvailable,
  totalValue,
} = storeToRefs(store)
const { exportRows } = useExcelExport()
/** 현재 필터 결과를 엑셀로 내보냅니다 (지시서 §2 SheetJS · 실행 시점 동적 로딩). */
function exportExcel() {
  const headers = [
    'Item Code',
    'Warehouse',
    'Category',
    'Brand',
    'Size',
    'Pattern',
    'PR/TL',
    'Stock',
    'Reserved',
    'Available',
    'Unit Cost (USD)',
    'Stock Value (USD)',
    'Aging',
    'Status',
  ]
  void exportRows(
    'inventory-list',
    headers,
    filtered.value.map((item) => [
      item.code,
      item.wh,
      item.cat,
      item.brand,
      item.size,
      item.pattern,
      item.pr,
      item.qty,
      item.rsv,
      availableOf(item),
      item.cost,
      valueOf(item),
      item.aging,
      STATUS_LABEL[item.status],
    ]),
    'Inventory List',
  )
}
defineExpose({ exportExcel })
</script>

<template>
  <section class="asm-panel table-panel">
    <!-- 툴바 (Toolbar / Bilah alat) -->
    <div class="table-toolbar">
      <h2>Inventory</h2>
      <div class="d-flex align-items-center gap-2">
        <label class="rows-select mb-0">
          <span>Rows</span>
          <select
            v-model.number="pageSize"
            class="form-select form-select-sm"
            @change="store.page = 1"
          >
            <option v-for="value in [10, 30, 50, 100]" :key="value" :value="value">
              {{ value }}
            </option>
          </select>
        </label>
        <button type="button" class="btn btn-outline-primary btn-sm" @click="exportExcel">
          <Download :size="16" />
          Export Excel
        </button>
      </div>
    </div>

    <!-- 표 (Table / Tabel) -->
    <div class="table-scroll">
      <table class="table table-hover align-middle">
        <thead>
          <tr>
            <th scope="col" class="no-col">No</th>
            <SortableHeader
              class="col-key"
              label="Item code"
              :active="sortKey === 'code'"
              :asc="sortAsc"
              @sort="store.toggleSort('code')"
            />
            <SortableHeader
              label="Warehouse"
              :active="sortKey === 'wh'"
              :asc="sortAsc"
              @sort="store.toggleSort('wh')"
            />
            <SortableHeader
              label="Category"
              :active="sortKey === 'cat'"
              :asc="sortAsc"
              @sort="store.toggleSort('cat')"
            />
            <SortableHeader
              label="Brand"
              :active="sortKey === 'brand'"
              :asc="sortAsc"
              @sort="store.toggleSort('brand')"
            />
            <SortableHeader
              label="Size"
              :active="sortKey === 'size'"
              :asc="sortAsc"
              @sort="store.toggleSort('size')"
            />
            <th scope="col">Pattern</th>
            <th scope="col">PR / TL</th>
            <SortableHeader
              label="Stock (EA)"
              align="right"
              :active="sortKey === 'qty'"
              :asc="sortAsc"
              @sort="store.toggleSort('qty')"
            />
            <th scope="col" class="text-end">Reserved</th>
            <th scope="col" class="text-end">Available</th>
            <SortableHeader
              label="Unit cost"
              align="right"
              :active="sortKey === 'cost'"
              :asc="sortAsc"
              @sort="store.toggleSort('cost')"
            />
            <SortableHeader
              label="Stock value"
              align="right"
              :active="sortKey === 'value'"
              :asc="sortAsc"
              @sort="store.toggleSort('value')"
            />
            <SortableHeader
              label="Aging (days)"
              align="right"
              :active="sortKey === 'aging'"
              :asc="sortAsc"
              @sort="store.toggleSort('aging')"
            />
            <th scope="col">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in rows" :key="item.id">
            <td class="num no-col">{{ formatInt(rangeStart + index) }}</td>
            <td class="col-key">
              <span class="item-code">{{ item.code }}</span>
            </td>
            <td>{{ item.wh }}</td>
            <td>
              <span class="cat-tag">{{ item.cat }}</span>
            </td>
            <td class="brand-cell">{{ item.brand }}</td>
            <!-- 규격에는 콤마를 넣지 않습니다 (사내 표기 규칙) -->
            <td>
              <b>{{ item.size }}</b>
            </td>
            <td>{{ item.pattern }}</td>
            <td>{{ item.pr }}</td>
            <td class="num">{{ formatInt(item.qty) }}</td>
            <td class="num">{{ formatInt(item.rsv) }}</td>
            <td class="num">{{ formatInt(availableOf(item)) }}</td>
            <td class="num">{{ formatAmount('USD', item.cost) }}</td>
            <td class="num">{{ formatAmount('USD', valueOf(item)) }}</td>
            <td class="num" :class="{ 'is-aged': item.aging > AGED_STOCK_DAYS }">
              {{ formatInt(item.aging) }}
            </td>
            <td>
              <AsmBadge :tone="statusTone[item.status]" dot>{{
                STATUS_LABEL[item.status]
              }}</AsmBadge>
            </td>
          </tr>
          <tr v-if="!rows.length">
            <td colspan="15" class="empty-row">선택한 조건에 해당하는 재고가 없습니다.</td>
          </tr>
        </tbody>
        <!-- 합계는 현재 페이지가 아닌 필터 결과 전체 기준입니다. -->
        <tfoot>
          <tr>
            <td colspan="8">Total ({{ formatInt(filtered.length) }} SKU)</td>
            <td class="num">{{ formatInt(totalQty) }}</td>
            <td class="num">{{ formatInt(totalReserved) }}</td>
            <td class="num">{{ formatInt(totalAvailable) }}</td>
            <td class="num">—</td>
            <td class="num">{{ formatAmount('USD', totalValue) }}</td>
            <td class="num">—</td>
            <td></td>
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
          @click="store.goToPage(safePage - 1)"
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
          @click="store.goToPage(safePage + 1)"
        >
          <ChevronRight :size="17" />
        </button>
      </div>
    </div>
  </section>
</template>

<style scoped>
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
  max-height: calc(100vh - 424px);
  min-height: 288px;
  overscroll-behavior: contain;
}
.table-scroll table {
  min-width: 1560px;
}

.no-col {
  width: 56px;
  color: var(--asm-fg-muted);
}

/* 좌측 고정 열 — No + 품번. 가이드 8-2 · 개선의견서 이슈 23 */
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

.cat-tag,
.item-code {
  display: inline-flex;
  align-items: center;
  height: 20px;
  padding: 0 8px;
  border-radius: var(--asm-radius-sm);
  font-size: 11px;
  font-weight: 600;
}
.cat-tag {
  background: var(--asm-muted);
  color: var(--asm-fg-muted);
}
.brand-cell {
  text-transform: uppercase;
}
.item-code {
  border: 1px solid var(--asm-border);
  background: var(--asm-surface-subtle);
  color: var(--asm-fg);
  font-family: var(--bs-font-monospace);
}

/* 장기재고(365일 초과) 경과일 강조 */
.is-aged {
  color: var(--asm-danger-fg);
}

/* 합계 행 — 스크롤 시 하단 고정. 색·굵기는 asm-theme.css 의 .table tfoot(가이드 8-1). */
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

@media (max-width: 1150px) {
  .table-scroll {
    max-height: calc(100vh - 528px);
  }
}
@media (max-width: 991.98px) {
  .table-scroll {
    max-height: none;
  }
}
</style>
