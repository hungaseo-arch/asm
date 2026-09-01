<script setup lang="ts">
import { computed } from 'vue'
import { X } from 'lucide-vue-next'
import { toast } from 'vue-sonner'
import AsmBadge from '@/components/common/AsmBadge.vue'
import { formatAmount, formatDate, formatInt, formatPercent } from '@/lib/format'
import { statusTone, type PurchaseOrder } from '@/types/purchase-po'
import { useBodyScrollLock } from '@/composables/useBodyScrollLock'
import { useEscapeToClose } from '@/composables/useEscapeToClose'

const props = defineProps<{ order: PurchaseOrder }>()
const emit = defineEmits<{ (event: 'close'): void }>()

useBodyScrollLock()
useEscapeToClose(() => emit('close'))

const allocation = computed(() =>
  props.order.totalQty ? (props.order.allocated / props.order.totalQty) * 100 : 0,
)
const completion = computed(() =>
  props.order.totalQty ? (props.order.completed / props.order.totalQty) * 100 : 0,
)

/** 배정량 대비 완성 비율 — 진행바 내부 채움 폭 */
const completionOfAllocation = computed(() =>
  allocation.value ? (completion.value / allocation.value) * 100 : 0,
)

const approvalNote = computed(() => {
  if (props.order.status === 'Pending approval') return 'Waiting for manager'
  if (props.order.status === 'Draft') return 'Not submitted'
  return 'Completed'
})
</script>

<template>
  <div class="asm-overlay justify-content-end">
    <button type="button" class="asm-overlay__scrim" aria-label="상세 닫기" @click="emit('close')"></button>

    <aside class="drawer" role="dialog" aria-modal="true" aria-labelledby="drawer-title">
      <header>
        <div>
          <p class="asm-eyebrow mb-1">PURCHASE ORDER</p>
          <h2 id="drawer-title">{{ order.poNo }}</h2>
          <AsmBadge :tone="statusTone[order.status]" dot>{{ order.status }}</AsmBadge>
        </div>
        <button type="button" class="asm-icon-btn is-borderless" aria-label="상세 닫기" @click="emit('close')">
          <X :size="19" />
        </button>
      </header>

      <div class="drawer-body">
        <!-- 요약 (Hero) -->
        <section class="detail-hero">
          <span>{{ order.type }} purchasing</span>
          <h3>{{ order.supplier }}</h3>
          <p class="amount">{{ formatAmount(order.currency, order.amount) }}</p>
          <small>{{ order.taxBasis }} · {{ order.paymentTerm }}</small>
        </section>

        <!-- 문서 정보 -->
        <section class="detail-section">
          <h4>Document information</h4>
          <dl>
            <dt>PO date</dt>
            <dd>{{ formatDate(order.poDate) }}</dd>
            <dt>Target date</dt>
            <dd>{{ formatDate(order.targetDate) }}</dd>
            <dt>Buyer</dt>
            <dd>{{ order.buyer }}</dd>
            <dt>Currency</dt>
            <dd>{{ order.currency }}</dd>
          </dl>
        </section>

        <!-- PO ↔ PPC 대사 -->
        <section class="detail-section">
          <h4>PO ↔ PPC reconciliation</h4>
          <div class="metric-row">
            <div>
              <span>PO quantity</span>
              <b>{{ formatInt(order.totalQty) }} EA</b>
            </div>
            <div>
              <span>Allocated</span>
              <b>{{ formatInt(order.allocated) }} EA</b>
              <small>{{ formatPercent(allocation) }}</small>
            </div>
            <div>
              <span>Completed</span>
              <b>{{ formatInt(order.completed) }} EA</b>
              <small>{{ formatPercent(completion) }}</small>
            </div>
          </div>
          <div class="detail-progress">
            <i :style="{ width: `${allocation}%` }">
              <em :style="{ width: `${completionOfAllocation}%` }"></em>
            </i>
          </div>
          <p class="remaining">
            {{ formatInt(order.totalQty - order.allocated) }} EA not yet allocated ·
            {{ formatInt(order.totalQty - order.completed) }} EA remaining to complete
          </p>
        </section>

        <!-- 워크플로 -->
        <section class="detail-section">
          <h4>Workflow</h4>
          <ol class="timeline">
            <li class="done">
              <i></i>PO created <span>{{ formatDate(order.poDate) }}</span>
            </li>
            <li :class="{ done: order.status !== 'Draft' }">
              <i></i>Approval <span>{{ approvalNote }}</span>
            </li>
            <li :class="{ done: order.allocated > 0 }">
              <i></i>Production allocation <span>{{ formatPercent(allocation) }} allocated</span>
            </li>
            <li :class="{ done: order.totalQty > 0 && order.completed === order.totalQty }">
              <i></i>Production completed <span>{{ formatPercent(completion) }} completed</span>
            </li>
          </ol>
        </section>
      </div>

      <footer>
        <button type="button" class="btn btn-secondary" @click="emit('close')">Close</button>
        <button
          type="button"
          class="btn btn-primary"
          @click="toast.info('수정 기능은 ASM 운영 API 연동 후 활성화됩니다')"
        >
          Edit purchase PO
        </button>
      </footer>
    </aside>
  </div>
</template>

<style scoped>
.drawer {
  position: relative;
  width: min(520px, 100%);
  height: 100%;
  background: var(--asm-bg);
  box-shadow: var(--asm-shadow-lg);
  display: flex;
  flex-direction: column;
  animation: slideIn 0.18s ease-out;
}
.drawer > header {
  min-height: 76px;
  padding: 16px 24px;
  border-bottom: 1px solid var(--asm-border);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}
.drawer > header h2 { margin: 0 0 8px; font-size: 20px; font-weight: 600; }
.drawer-body { padding: 24px; overflow-y: auto; }

.detail-hero {
  background: var(--asm-primary);
  color: var(--asm-primary-fg);
  border-radius: var(--asm-radius-lg);
  padding: 16px;
  margin-bottom: 16px;
}
.detail-hero span { font-size: 11px; opacity: 0.72; text-transform: uppercase; letter-spacing: 0.08em; }
.detail-hero h3 { font-size: 18px; margin: 4px 0 16px; }
.detail-hero .amount {
  font-family: var(--bs-font-monospace);
  font-size: 24px;
  font-weight: 700;
  margin: 0;
}
.detail-hero small { display: block; opacity: 0.75; margin-top: 4px; }

.detail-section {
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-lg);
  padding: 16px;
  margin-bottom: 12px;
}
.detail-section h4 {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  margin: 0 0 12px;
  color: var(--asm-fg-muted);
}
.detail-section dl { display: grid; grid-template-columns: 1fr 1fr; margin: 0; gap: 12px 16px; }
.detail-section dt { font-size: 11px; color: var(--asm-fg-muted); font-weight: 400; }
.detail-section dd { margin: 4px 0 0; font-weight: 600; }

.metric-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
.metric-row > div { background: var(--asm-page-bg); padding: 8px; border-radius: var(--asm-radius-md); }
.metric-row span { display: block; font-size: 11px; color: var(--asm-fg-muted); }
.metric-row b { display: block; font-size: 13px; margin-top: 4px; font-variant-numeric: tabular-nums; }
.metric-row small { display: block; font-size: 11px; color: var(--asm-primary); }

.detail-progress {
  height: 8px;
  background: var(--asm-border-subtle);
  border-radius: 8px;
  overflow: hidden;
  margin-top: 12px;
}
.detail-progress > i { height: 100%; display: block; background: var(--asm-primary-soft); }
.detail-progress em { height: 100%; display: block; background: var(--asm-primary); }
.remaining { font-size: 11px; color: var(--asm-fg-muted); margin: 8px 0 0; }

.timeline { list-style: none; margin: 0; padding: 0; }
.timeline li { position: relative; padding: 0 0 16px 24px; font-size: 12px; font-weight: 600; }
.timeline li:not(:last-child)::after {
  content: '';
  position: absolute;
  left: 6px;
  top: 12px;
  bottom: 0;
  width: 1px;
  background: var(--asm-border);
}
.timeline li > i {
  position: absolute;
  left: 0;
  top: 4px;
  width: 12px;
  height: 12px;
  border: 2px solid var(--asm-border-strong);
  background: var(--asm-bg);
  border-radius: 50%;
}
.timeline li.done > i {
  border-color: var(--asm-primary);
  background: var(--asm-primary);
  box-shadow: inset 0 0 0 2px var(--asm-bg);
}
.timeline li span {
  display: block;
  color: var(--asm-fg-muted);
  font-size: 11px;
  font-weight: 400;
  margin-top: 4px;
}

.drawer > footer {
  margin-top: auto;
  min-height: 68px;
  border-top: 1px solid var(--asm-border);
  padding: 16px 24px;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  background: var(--asm-bg);
}

@keyframes slideIn {
  from { transform: translateX(25px); opacity: 0.75; }
  to { transform: none; opacity: 1; }
}
</style>
