<script setup>
import { useBodyScrollLock } from '@/composables/useBodyScrollLock'
import { useEscapeToClose } from '@/composables/useEscapeToClose'
import ListCellValue from '@/components/common/ListCellValue.vue'
const props = defineProps({
  screen: { type: Object, required: true },
  row: { type: Object, required: true },
})
const emit = defineEmits(['close'])
useBodyScrollLock()
useEscapeToClose(() => emit('close'))
</script>

<template>
  <!--
    행 상세 모달 — 표에는 핵심 열만 보이므로(가로 스크롤 방지, 2026-09-04), 나머지
    전체 열은 행을 클릭하면 여기서 한 번에 보여줍니다. 서식·배지·마크 표기는
    ListCellValue.vue 를 표와 그대로 공유해 값이 어긋나지 않습니다.
  -->
  <div class="asm-overlay justify-content-center align-items-center p-3">
    <button
      type="button"
      class="asm-overlay__scrim"
      aria-label="닫기"
      @click="emit('close')"
    ></button>
    <div class="dialog" role="dialog" aria-modal="true" aria-labelledby="detail-title">
      <header>
        <div class="lh-sm">
          <p class="asm-eyebrow mb-1">{{ screen.cardTitle }}</p>
          <h2 id="detail-title">{{ row[screen.columns[0]?.key] ?? screen.title }}</h2>
        </div>
        <button
          type="button"
          class="asm-icon-btn is-borderless"
          aria-label="닫기"
          @click="emit('close')"
        >
          <X :size="18" />
        </button>
      </header>
      <div class="dialog-body">
        <dl>
          <template v-for="column in screen.columns" :key="column.key">
            <dt>{{ column.label }}</dt>
            <dd>
              <ListCellValue :column="column" :value="row[column.key]" :row="row" />
            </dd>
          </template>
        </dl>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 일반 모달 규격 — 가이드 8-5: 최대폭 560px · radius-xl · shadow-lg · 상단 4px 블루 액센트 */
.dialog {
  position: relative;
  width: min(560px, 100%);
  max-height: calc(100vh - 32px);
  background: var(--asm-card);
  border-radius: var(--asm-radius-xl);
  border-top: 4px solid var(--asm-primary);
  box-shadow: var(--asm-shadow-lg);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
.dialog > header {
  min-height: 76px;
  padding: 16px 24px;
  border-bottom: 1px solid var(--asm-border);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}
.dialog > header h2 {
  margin: 0;
  font-size: 18px;
}
.dialog-body {
  padding: 24px;
  overflow-y: auto;
}
dl {
  margin: 0;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px 24px;
}
dt {
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: var(--asm-fg-muted);
  margin-bottom: 4px;
}
dd {
  margin: 0;
  font-size: 14px;
  color: var(--asm-fg);
  word-break: break-word;
}
@media (max-width: 480px) {
  dl {
    grid-template-columns: 1fr;
  }
}
</style>
