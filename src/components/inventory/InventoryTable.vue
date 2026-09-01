<script setup lang="ts">
import { ChevronLeft, ChevronRight, Download } from 'lucide-vue-next'
import { storeToRefs } from 'pinia'
import { toast } from 'vue-sonner'
import AsmBadge from '@/components/common/AsmBadge.vue'
import SortableHeader from '@/components/common/SortableHeader.vue'
import { useInventoryStore } from '@/stores/inventory'
import { formatAmount, formatInt } from '@/lib/format'
import {
  AGED_STOCK_DAYS,
  availableOf,
  statusTone,
  STATUS_LABEL,
  valueOf,
} from '@/types/inventory'

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

function escapeCsv(value: string | number) {
  return `"${String(value).split('"').join('""')}"`
}

/** 현재 필터 결과를 CSV로 내보냅니다 (Excel 호환 · UTF-8 BOM 포함). */
function exportCsv() {
  const headers = [
    'Warehouse', 'Category', 'Brand', 'Size', 'Pattern', 'Item Code', 'PR/TL',
    'Stock', 'Reserved', 'Available', 'Unit Cost (USD)', 'Stock Value (USD)', 'Aging', 'Status',
  ]
  const lines = filtered.value.map((item) =>
    [
      item.wh, item.cat, item.brand, item.size, item.pattern, item.code, item.pr,
      item.qty, item.rsv, availableOf(item), item.cost.toFixed(2), valueOf(item).toFixed(2),
      item.aging, STATUS_LABEL[item.status],
    ]
      .map(escapeCsv)
      .join(','),
  )

  const csv = [headers.map(escapeCsv).join(','), ...lines].join('\n')
  const blob = new Blob([`﻿${csv}`], { type: 'text/csv;charset=utf-8' })
  const url = URL.createObjectURL(blob)
  const anchor = document.createElement('a')
  anchor.href = url
  anchor.download = `inventory-list-${new Date().toISOString().slice(0, 10)}.csv`
  anchor.click()
  URL.revokeObjectURL(url)
  toast.success(`${formatInt(filtered.value.length)}건의 재고가 내보내졌습니다`)
}

defineExpose({ exportCsv })
</script>

<template>
  <section class="asm-panel table-panel">
    <!-- 툴바 (Toolbar / Bilah alat) -->
    <div class="table-toolbar">
      <h2>Inventory</h2>
      <div class="d-flex align-items-center gap-2">
        <label class="rows-select mb-0">
          <span>Rows</span>
          <select v-model.number="pageSize" class="form-select form-select-sm" @change="store.page = 1">
            <option v-for="value in [10, 30, 50, 100]" :key="value" :value="value">{{ value }}</option>
          </select>
        </label>
        <button type="button" class="btn btn-outline-primary btn-sm" @click="exportCsv">
          <Download :size="16" />
          Export CSV
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
              label="Warehouse" :active="sortKey === 'wh'" :asc="sortAsc"
              @sort="store.toggleSort('wh')"
            />
            <SortableHeader
              label="Category" :active="sortKey === 'cat'" :asc="sortAsc"
              @sort="store.toggleSort('cat')"
            />
            <SortableHeader
              label="Brand" :active="sortKey === 'brand'" :asc="sortAsc"
              @sort="store.toggleSort('brand')"
            />
            <SortableHeader
              label="Size" :active="sortKey === 'size'" :asc="sortAsc"
              @sort="store.toggleSort('size')"
            />
            <th scope="col">Pattern</th>
            <SortableHeader
              label="Item code" :active="sortKey === 'code'" :asc="sortAsc"
              @sort="store.toggleSort('code')"
            />
            <th scope="col">PR / TL</th>
            <SortableHeader
              label="Stock (EA)" align="right" :active="sortKey === 'qty'" :asc="sortAsc"
              @sort="store.toggleSort('qty')"
            />
            <th scope="col" class="text-end">Reserved</th>
            <th scope="col" class="text-end">Available</th>
            <SortableHeader
              label="Unit cost" align="right" :active="sortKey === 'cost'" :asc="sortAsc"
              @sort="store.toggleSort('cost')"
            />
            <SortableHeader
              label="Stock value" align="right" :active="sortKey === 'value'" :asc="sortAsc"
              @sort="store.toggleSort('value')"
            />
            <SortableHeader
              label="Aging (days)" align="right" :active="sortKey === 'aging'" :asc="sortAsc"
              @sort="store.toggleSort('aging')"
            />
            <th scope="col">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in rows" :key="item.id">
            <td class="num no-col">{{ formatInt(rangeStart + index) }}</td>
            <td>{{ item.wh }}</td>
            <td><span class="cat-tag">{{ item.cat }}</span></td>
            <td>{{ item.brand }}</td>
            <!-- 규격에는 콤마를 넣지 않습니다 (사내 표기 규칙) -->
            <td><b>{{ item.size }}</b></td>
            <td>{{ item.pattern }}</td>
            <td><span class="item-code">{{ item.code }}</span></td>
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
              <AsmBadge :tone="statusTone[item.status]" dot>{{ STATUS_LABEL[item.status] }}</AsmBadge>
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
        Showing <b>{{ formatInt(rangeStart) }}</b>–<b>{{ formatInt(rangeEnd) }}</b> of
        <b>{{ formatInt(filtered.length) }}</b>
      </p>
      <div class="d-flex align-items-center gap-2">
        <button
          type="button" class="asm-icon-btn is-sm" :disabled="safePage === 1"
          aria-label="이전 페이지" @click="store.goToPage(safePage - 1)"
        >
          <ChevronLeft :size="17" />
        </button>
        <span>Page <b>{{ safePage }}</b> of {{ pageCount }}</span>
        <button
          type="button" class="asm-icon-btn is-sm" :disabled="safePage === pageCount"
          aria-label="다음 페이지" @click="store.goToPage(safePage + 1)"
        >
          <ChevronRight :size="17" />
        </button>
      </div>
    </div>
  </section>
</template>

<style scoped>
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
  max-height: calc(100vh - 424px);
  min-height: 288px;
  overscroll-behavior: contain;
}
.table-scroll table { min-width: 1560px; }

.no-col { width: 56px; color: var(--asm-fg-muted); }

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
.cat-tag { background: var(--asm-muted); color: var(--asm-fg-muted); }
.item-code {
  border: 1px solid var(--asm-border);
  background: var(--asm-surface-subtle);
  color: var(--asm-fg);
  font-family: var(--bs-font-monospace);
}

/* 장기재고(365일 초과) 경과일 강조 */
.is-aged { color: var(--asm-danger-fg); }

/* 합계 행 — 스크롤 시 하단 고정 */
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

@media (max-width: 1150px) {
  .table-scroll { max-height: calc(100vh - 528px); }
}
@media (max-width: 991.98px) {
  .table-scroll { max-height: none; }
}
</style>
