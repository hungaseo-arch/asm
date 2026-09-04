<script setup>
import { ref } from 'vue'
import { storeToRefs } from 'pinia'
import { toast } from 'vue-sonner'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import PoFilterPanel from '@/components/purchase-po/PoFilterPanel.vue'
import PoTable from '@/components/purchase-po/PoTable.vue'
import PoDetailDrawer from '@/components/purchase-po/PoDetailDrawer.vue'
import NewPoDialog from '@/components/purchase-po/NewPoDialog.vue'
import { usePurchasePoStore } from '@/stores/purchase-po'
import { provideSidebarSummary } from '@/composables/useSummaryCards'
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
// 요약 카드는 본문이 아니라 좌측 레일(AppSummaryRail)에 렌더링합니다 (2026-09-04 이동).
provideSidebarSummary(() => [
  {
    label: 'Total purchase POs',
    value: formatInt(filtered.value.length),
    note: 'Current filtered result',
    tone: 'default',
  },
  {
    label: 'Pending approval',
    value: formatInt(pendingApprovalCount.value),
    note: 'Manager action required',
    tone: 'warning',
  },
  {
    label: 'Confirmed IDR value',
    value: formatIdrShort(confirmedIdrTotal.value),
    note: 'Tax basis shown per PO',
    tone: 'success',
  },
  {
    label: 'Production risk',
    value: formatInt(productionRiskCount.value),
    note: 'Below 50.0% completion',
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
        <h1 class="visually-hidden">Purchase PO</h1>
        <p class="page-sub mb-0">Pesanan Pembelian · 자사 구매발주서 관리</p>
      </div>
      <button type="button" class="btn btn-sm btn-primary" @click="showNewDialog = true">
        <Plus :size="15" />
        New purchase PO
      </button>
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

@media (max-width: 767.98px) {
  .page-heading {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
