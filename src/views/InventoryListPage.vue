<script setup>
import { computed, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import InventoryFilterPanel from '@/components/inventory/InventoryFilterPanel.vue'
import InventoryTable from '@/components/inventory/InventoryTable.vue'
import { useInventoryStore } from '@/stores/inventory'
import { provideSidebarSummary } from '@/composables/useSummaryCards'
import { formatAmount, formatDate, formatInt, formatQty } from '@/utils/format'
import { AGED_STOCK_DAYS } from '@/types/inventory'
const store = useInventoryStore()
const { totalQty, totalValue, belowBufferCount, agedCount } = storeToRefs(store)
const table = ref(null)
/** 기준일 (As of / Per tanggal) — 서버 마감 시각 연동 전까지는 오늘 날짜 */
const asOf = computed(() => formatDate(new Date().toISOString().slice(0, 10)))
function printPage() {
  window.print()
}
// 요약 카드는 본문이 아니라 좌측 레일(AppSummaryRail)에 렌더링합니다 (2026-09-04 이동).
provideSidebarSummary(() => [
  {
    label: 'Total stock qty',
    value: formatQty(totalQty.value),
    note: 'All warehouses',
    tone: 'default',
  },
  {
    label: 'Stock value',
    value: formatAmount('USD', totalValue.value),
    note: 'CIF cost basis',
    tone: 'success',
  },
  {
    label: 'Below buffer',
    value: `${formatInt(belowBufferCount.value)} SKU`,
    note: 'Reorder review required',
    tone: 'warning',
  },
  {
    label: 'Aged stock',
    value: `${formatInt(agedCount.value)} SKU`,
    note: `Over ${formatInt(AGED_STOCK_DAYS)} days`,
    tone: 'danger',
  },
])
</script>

<template>
  <DefaultLayout>
    <!--
      화면 제목은 사이드바 활성 항목과 중복돼 시각적으로 표시하지 않습니다(2026-09-04).
      문서 구조상 h1 은 필요해 스크린리더 전용으로만 남깁니다.
    -->
    <section class="page-heading">
      <div>
        <h1 class="visually-hidden">Inventory List</h1>
        <p class="page-sub mb-0">Daftar Persediaan · 재고 현황 · 기준일 {{ asOf }}</p>
      </div>
      <div class="page-actions">
        <button type="button" class="btn btn-sm btn-outline-primary" @click="printPage">
          <Printer :size="14" />
          Print
        </button>
        <button type="button" class="btn btn-sm btn-secondary" @click="table?.exportExcel()">
          <Boxes :size="14" />
          Excel
        </button>
        <button
          type="button"
          class="btn btn-sm btn-primary"
          @click="toast.info('Stock Adjustment 화면은 현재 범위에 포함되지 않습니다')"
        >
          <Plus :size="15" />
          Stock adjustment
        </button>
      </div>
    </section>

    <InventoryFilterPanel />
    <InventoryTable ref="table" />
  </DefaultLayout>
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
}
.page-actions {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

@media (max-width: 767.98px) {
  .page-heading {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
