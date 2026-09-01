<script setup>
import { ref } from 'vue'
import { storeToRefs } from 'pinia'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import SummaryCard from '@/components/common/SummaryCard.vue'
import PoFilterPanel from '@/components/purchase-po/PoFilterPanel.vue'
import PoTable from '@/components/purchase-po/PoTable.vue'
import PoDetailDrawer from '@/components/purchase-po/PoDetailDrawer.vue'
import NewPoDialog from '@/components/purchase-po/NewPoDialog.vue'
import { usePurchasePoStore } from '@/stores/purchase-po'
import { formatIdrShort, formatInt } from '@/utils/format'
const store = usePurchasePoStore()
const { filtered, pendingApprovalCount, confirmedIdrTotal, productionRiskCount, nextPoNo } =
  storeToRefs(store)
const selected = ref(null)
const showNewDialog = ref(false)
function createOrder(input) {
  const created = store.addOrder(input)
  showNewDialog.value = false
  toast.success(`${created.poNo} 임시저장(Draft)으로 생성되었습니다`)
}
</script>

<template>
  <DefaultLayout>
    <!-- 경로 (Breadcrumb) -->
    <nav class="breadcrumb-bar" aria-label="breadcrumb">
      <span>Purchasing</span>
      <ChevronRight :size="14" />
      <b>Purchase PO</b>
    </nav>

    <!-- 화면 제목 -->
    <section class="page-heading">
      <div>
        <p class="asm-eyebrow mb-1">PURCHASE ORDER MANAGEMENT</p>
        <h1>Purchase PO</h1>
      </div>
      <button type="button" class="btn btn-primary" @click="showNewDialog = true">
        <Plus :size="17" />
        New purchase PO
      </button>
    </section>

    <!-- 요약 카드 (Summary / Ringkasan) -->
    <section class="summary-grid" aria-label="Purchase order summary">
      <SummaryCard
        label="Total purchase POs"
        :value="formatInt(filtered.length)"
        note="Current filtered result"
        icon="ShoppingCart"
      />
      <SummaryCard
        label="Pending approval"
        :value="formatInt(pendingApprovalCount)"
        note="Manager action required"
        tone="warning"
        icon="ClipboardCheck"
      />
      <SummaryCard
        label="Confirmed IDR value"
        :value="formatIdrShort(confirmedIdrTotal)"
        note="Tax basis shown per PO"
        tone="success"
        icon="CircleDollarSign"
      />
      <SummaryCard
        label="Production risk"
        :value="formatInt(productionRiskCount)"
        note="Below 50.0% completion"
        tone="danger"
        icon="Factory"
      />
    </section>

    <PoFilterPanel />
    <PoTable @select="selected = $event" />

    <PoDetailDrawer v-if="selected" :order="selected" @close="selected = null" />
    <NewPoDialog
      v-if="showNewDialog"
      :auto-po-no="nextPoNo"
      @close="showNewDialog = false"
      @submit="createOrder"
    />
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
.breadcrumb-bar b {
  color: var(--asm-fg);
}

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

.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 16px;
}

@media (max-width: 1150px) {
  .summary-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
@media (max-width: 767.98px) {
  .page-heading {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
