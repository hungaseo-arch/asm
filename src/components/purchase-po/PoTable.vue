<script setup>
import { storeToRefs } from 'pinia'
import { useExcelExport } from '@/composables/useExcelExport'
import AsmBadge from '@/components/common/AsmBadge.vue'
import SortableHeader from '@/components/common/SortableHeader.vue'
import { usePurchasePoStore } from '@/stores/purchase-po'
import { formatAmount, formatDate, formatInt, formatPercent } from '@/utils/format'
import { statusTone } from '@/types/purchase-po'
const emit = defineEmits(['select'])
const store = usePurchasePoStore()
const { rows, filtered, pageSize, sortKey, sortAsc, safePage, pageCount, rangeStart, rangeEnd } =
  storeToRefs(store)
const percentOf = (part, total) => (total ? (part / total) * 100 : 0)
const { exportRows } = useExcelExport()
/** 현재 필터 결과를 엑셀로 내보냅니다 (지시서 §2 SheetJS · 실행 시점 동적 로딩). */
function exportExcel() {
  const headers = [
    'PO No.',
    'Supplier',
    'Type',
    'PO Date',
    'Target Date',
    'Currency',
    'Amount',
    'Tax Basis',
    'Allocated',
    'Completed',
    'Total Qty',
    'Status',
  ]
  void exportRows(
    'purchase-po',
    headers,
    filtered.value.map((order) => [
      order.poNo,
      order.supplier,
      order.type,
      order.poDate,
      order.targetDate,
      order.currency,
      order.amount,
      order.taxBasis,
      order.allocated,
      order.completed,
      order.totalQty,
      order.status,
    ]),
    'Purchase PO',
  )
}
</script>

<template>
  <section class="asm-panel table-panel">
    <!-- 툴바 (Toolbar / Bilah alat) -->
    <div class="table-toolbar">
      <h2>Purchase orders</h2>
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
            <SortableHeader
              label="PO No."
              sticky="first"
              :active="sortKey === 'poNo'"
              :asc="sortAsc"
              @sort="store.toggleSort('poNo')"
            />
            <SortableHeader
              label="Supplier"
              sticky="second"
              :active="sortKey === 'supplier'"
              :asc="sortAsc"
              @sort="store.toggleSort('supplier')"
            />
            <th scope="col">Type</th>
            <SortableHeader
              label="PO date"
              :active="sortKey === 'poDate'"
              :asc="sortAsc"
              @sort="store.toggleSort('poDate')"
            />
            <th scope="col">Target date</th>
            <th scope="col">Currency</th>
            <SortableHeader
              label="Amount"
              align="right"
              :active="sortKey === 'amount'"
              :asc="sortAsc"
              @sort="store.toggleSort('amount')"
            />
            <th scope="col">Tax basis</th>
            <th scope="col">PO ↔ PPC reconciliation</th>
            <SortableHeader
              label="Status"
              :active="sortKey === 'status'"
              :asc="sortAsc"
              @sort="store.toggleSort('status')"
            />
            <th scope="col"><span class="visually-hidden">Actions</span></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in rows" :key="order.id" @dblclick="emit('select', order)">
            <td class="asm-sticky-col is-first">
              <button type="button" class="asm-link" @click="emit('select', order)">
                {{ order.poNo }}
              </button>
            </td>
            <td class="asm-sticky-col is-second">
              <b class="supplier-name asm-ellipsis" :title="order.supplier">{{ order.supplier }}</b>
              <small class="buyer-name asm-ellipsis" :title="order.buyer">{{ order.buyer }}</small>
            </td>
            <td>
              <AsmBadge :tone="order.type === 'Import' ? 'info' : 'success'">{{
                order.type
              }}</AsmBadge>
            </td>
            <td class="date">{{ formatDate(order.poDate) }}</td>
            <td class="date">{{ formatDate(order.targetDate) }}</td>
            <td>
              <span class="asm-currency">{{ order.currency }}</span>
            </td>
            <td class="num">{{ formatAmount(order.currency, order.amount) }}</td>
            <td>
              <span class="tax-basis">{{ order.taxBasis }}</span>
            </td>
            <td>
              <div class="reconcile">
                <div class="d-flex justify-content-between">
                  <span>
                    Allocated {{ formatInt(order.allocated) }} / {{ formatInt(order.totalQty) }} EA
                  </span>
                  <b>{{ formatPercent(percentOf(order.allocated, order.totalQty)) }}</b>
                </div>
                <div class="asm-progress">
                  <span :style="{ width: `${percentOf(order.allocated, order.totalQty)}%` }"></span>
                </div>
                <small>
                  Completed {{ formatInt(order.completed) }} EA · Remaining
                  {{ formatInt(order.totalQty - order.completed) }} EA ({{
                    formatPercent(percentOf(order.completed, order.totalQty))
                  }})
                </small>
              </div>
            </td>
            <td>
              <AsmBadge :tone="statusTone[order.status]" dot>{{ order.status }}</AsmBadge>
            </td>
            <td>
              <button
                type="button"
                class="asm-icon-btn is-sm"
                :aria-label="`${order.poNo} 상세 열기`"
                @click="emit('select', order)"
              >
                <MoreHorizontal :size="17" />
              </button>
            </td>
          </tr>
          <tr v-if="!rows.length">
            <td colspan="11" class="empty-row">선택한 조건에 해당하는 발주가 없습니다.</td>
          </tr>
        </tbody>
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
.table-toolbar h2 {
  font-size: 15px;
  margin: 0;
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
}

.table-scroll {
  overflow: auto;
  max-height: calc(100vh - 424px);
  min-height: 288px;
  overscroll-behavior: contain;
}
.table-scroll table {
  min-width: 1450px;
}

.supplier-name,
.buyer-name {
  max-width: 200px;
}
.supplier-name {
  font-weight: 600;
}
.buyer-name {
  font-size: 11px;
  color: var(--asm-fg-muted);
  margin-top: 2px;
}

.tax-basis {
  display: inline-flex;
  align-items: center;
  background: var(--asm-muted);
  color: var(--asm-fg-muted);
  padding: 4px 8px;
  border-radius: var(--asm-radius-sm);
  font-size: 11px;
  font-weight: 600;
}

.reconcile {
  width: 232px;
}
.reconcile > div:first-child {
  font-size: 11px;
  color: var(--asm-fg-muted);
}
.reconcile b {
  font-variant-numeric: tabular-nums;
}
.reconcile .asm-progress {
  margin-top: 4px;
}
.reconcile small {
  display: block;
  font-size: 11px;
  color: var(--asm-fg-muted);
  margin-top: 4px;
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
