<script setup lang="ts">
import { computed, ref } from 'vue'
import {
  Boxes,
  ChevronRight,
  CircleDollarSign,
  Hourglass,
  Plus,
  Printer,
  TriangleAlert,
} from 'lucide-vue-next'
import { storeToRefs } from 'pinia'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import SummaryCard from '@/components/common/SummaryCard.vue'
import InventoryFilterPanel from '@/components/inventory/InventoryFilterPanel.vue'
import InventoryTable from '@/components/inventory/InventoryTable.vue'
import { useInventoryStore } from '@/stores/inventory'
import { formatAmount, formatDate, formatInt, formatQty } from '@/utils/format'
import { AGED_STOCK_DAYS } from '@/types/inventory'

const store = useInventoryStore()
const { totalQty, totalValue, belowBufferCount, agedCount } = storeToRefs(store)

const table = ref<InstanceType<typeof InventoryTable> | null>(null)

/** 기준일 (As of / Per tanggal) — 서버 마감 시각 연동 전까지는 오늘 날짜 */
const asOf = computed(() => formatDate(new Date().toISOString().slice(0, 10)))

function printPage() {
  window.print()
}
</script>

<template>
  <DefaultLayout>
    <!-- 경로 (Breadcrumb) -->
    <nav class="breadcrumb-bar" aria-label="breadcrumb">
      <span>Inventory</span>
      <ChevronRight :size="14" />
      <b>Inventory List</b>
    </nav>

    <!-- 화면 제목 -->
    <section class="page-heading">
      <div>
        <p class="asm-eyebrow mb-1">INVENTORY MANAGEMENT</p>
        <h1>Inventory List</h1>
        <p class="page-sub mb-0">Daftar Persediaan · 재고 현황 · 기준일 {{ asOf }}</p>
      </div>
      <div class="page-actions">
        <button type="button" class="btn btn-outline-primary" @click="printPage">
          <Printer :size="16" />
          Print
        </button>
        <button type="button" class="btn btn-secondary" @click="table?.exportExcel()">
          <Boxes :size="16" />
          Excel
        </button>
        <button
          type="button"
          class="btn btn-primary"
          @click="toast.info('Stock Adjustment 화면은 현재 범위에 포함되지 않습니다')"
        >
          <Plus :size="17" />
          Stock adjustment
        </button>
      </div>
    </section>

    <!-- 요약 카드 (Summary / Ringkasan) -->
    <section class="summary-grid" aria-label="Inventory summary">
      <SummaryCard
        label="Total stock qty"
        :value="formatQty(totalQty)"
        note="All warehouses"
        :icon="Boxes"
      />
      <SummaryCard
        label="Stock value"
        :value="formatAmount('USD', totalValue)"
        note="CIF cost basis"
        tone="success"
        :icon="CircleDollarSign"
      />
      <SummaryCard
        label="Below buffer"
        :value="`${formatInt(belowBufferCount)} SKU`"
        note="Reorder review required"
        tone="warning"
        :icon="TriangleAlert"
      />
      <SummaryCard
        label="Aged stock"
        :value="`${formatInt(agedCount)} SKU`"
        :note="`Over ${formatInt(AGED_STOCK_DAYS)} days`"
        tone="danger"
        :icon="Hourglass"
      />
    </section>

    <InventoryFilterPanel />
    <InventoryTable ref="table" />
  </DefaultLayout>
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

.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 16px;
}

@media (max-width: 1150px) {
  .summary-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 767.98px) {
  .page-heading { flex-direction: column; align-items: flex-start; }
}
</style>
