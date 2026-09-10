<script setup>
import { ref } from 'vue'
import { useSidebarSummary } from '@/composables/useSummaryCards'
import { useDrawerFocus } from '@/composables/useDrawerFocus'
import SummaryCard from '@/components/common/SummaryCard.vue'
const props = defineProps({ open: { type: Boolean, default: false } })
const emit = defineEmits(['close'])
const { cards } = useSidebarSummary()

const closeButton = ref(null)
useDrawerFocus(() => props.open, closeButton)
</script>

<template>
  <!--
    요약 드로어 (Summary drawer / Laci ringkasan)

    화면(PurchasePoPage·ListScreen 등)이 useSummaryCards.js 에 등록한 카드를 그대로
    받아 그립니다. 요약이 없는 화면(로그인·404 등)에서는 통째로 렌더되지 않습니다.
    좌측에서 슬라이드해 나오며, 본문 자리를 상시 차지하지 않습니다.
  -->
  <template v-if="cards.length">
    <button
      v-if="open"
      type="button"
      class="drawer-scrim"
      aria-label="요약 닫기"
      @click="emit('close')"
    ></button>

    <aside class="summary-rail" :class="{ 'is-open': open }" aria-label="요약">
      <header class="rail-head">
        <span class="asm-eyebrow">Summary</span>
        <button
          ref="closeButton"
          type="button"
          class="asm-icon-btn is-sm is-borderless"
          aria-label="요약 닫기"
          @click="emit('close')"
        >
          <X :size="18" />
        </button>
      </header>

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
</template>

<style scoped>
/*
 * 드로어 — 닫힌 상태는 화면 밖 좌측으로 밀어 둡니다(display:none 이 아니라 transform 을
 * 쓰는 이유는 열고 닫을 때 슬라이드가 보여야 하기 때문입니다). 폭·배경은 우측 메뉴
 * 드로어(.sidebar, asm-theme.css)와 같은 토큰을 씁니다.
 */
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
  /*
   * 닫힌 드로어는 visibility 로 함께 감춥니다 — transform 만으로 밀어두면 화면 밖에
   * 있어도 Tab 키가 안쪽 닫기 버튼을 훑습니다. 감추기는 슬라이드가 끝난 뒤 적용합니다.
   */
  visibility: hidden;
  transform: translateX(-100%);
  transition:
    transform 0.2s,
    visibility 0s 0.2s;
}
.summary-rail.is-open {
  visibility: visible;
  transform: none;
  /* 가이드 6-3 — 떠 있는 요소에만 그림자 */
  box-shadow: var(--asm-shadow-lg);
  transition:
    transform 0.2s,
    visibility 0s;
}
.rail-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  padding: 0 4px 4px 8px;
}

/* 가이드 8-5 — 오버레이 rgb(51 51 51 / .5) */
.drawer-scrim {
  position: fixed;
  inset: var(--asm-header-offset) 0 0;
  border: 0;
  padding: 0;
  background: var(--asm-scrim);
  z-index: 1015;
}

/* 열고 닫는 애니메이션을 끄는 설정을 존중합니다. */
@media (prefers-reduced-motion: reduce) {
  .summary-rail,
  .summary-rail.is-open {
    transition: none;
  }
}
</style>
