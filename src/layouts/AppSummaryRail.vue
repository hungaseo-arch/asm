<script setup>
import { useSidebarSummary } from '@/composables/useSummaryCards'
import SummaryCard from '@/components/common/SummaryCard.vue'
const { cards } = useSidebarSummary()
</script>

<template>
  <!--
    요약 카드 전용 레일 — 메뉴(사이드바)와 같은 폭(--asm-sidebar-w, 220px)으로 화면
    좌측에 고정합니다(2026-09-04, 메뉴와 위치 교체). 화면(PurchasePoPage 등)이
    useSummaryCards.js 에 등록한 카드를 그대로 받아 그리고, 요약이 없는 화면
    (로그인·404 등)에서는 통째로 렌더되지 않습니다.
  -->
  <aside v-if="cards.length" class="summary-rail">
    <SummaryCard
      v-for="card in cards"
      :key="card.label"
      :label="card.label"
      :value="card.value"
      :note="card.note"
      :tone="card.tone"
    />
  </aside>
</template>

<style scoped>
.summary-rail {
  position: fixed;
  top: var(--asm-header-offset);
  left: 0;
  bottom: 0;
  width: var(--asm-sidebar-w);
  padding: 12px 8px;
  overflow-y: auto;
  z-index: 1020;
  display: flex;
  flex-direction: column;
  gap: 8px;
  background: var(--asm-sidebar);
  border-right: 1px solid var(--asm-sidebar-border);
}

/* 좌측 사이드바처럼 데스크톱 전용 — 좁은 화면에서는 숨깁니다(드로어는 만들지 않음). */
@media (max-width: 991.98px) {
  .summary-rail {
    display: none;
  }
}
</style>
