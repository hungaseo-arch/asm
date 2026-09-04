<script setup>
import AsmBadge from '@/components/common/AsmBadge.vue'
import { ACCESS_LEVEL, toneOf } from '@/types/list-screen'
import { displayColumnValue } from '@/utils/list-cell'
defineProps({
  column: { type: Object, required: true },
  value: { type: [String, Number], default: '' },
  row: { type: Object, default: () => ({}) },
})
</script>

<template>
  <AsmBadge v-if="column.format === 'badge'" :tone="toneOf(String(value))" dot>
    {{ value }}
  </AsmBadge>
  <span
    v-else-if="column.format === 'access'"
    class="access"
    :class="`access--${ACCESS_LEVEL[String(value)]?.tone ?? 'none'}`"
    :title="ACCESS_LEVEL[String(value)]?.label ?? String(value)"
    >{{ ACCESS_LEVEL[String(value)]?.mark ?? '—' }}</span
  >
  <template v-else-if="column.format === 'mark'">
    <Check v-if="Number(value)" :size="15" class="mark-yes" />
    <Minus v-else :size="15" class="mark-no" />
  </template>
  <template v-else>{{ displayColumnValue(column, value, row) }}</template>
</template>

<style scoped>
/* 권한 수준 기호 — 가이드라인 3장 범례와 동일한 색 체계 */
.access {
  font-size: 14px;
  line-height: 1;
}
.access--full {
  color: var(--asm-primary);
  font-weight: 700;
}
.access--edit {
  color: var(--asm-success-fg);
  font-weight: 700;
}
.access--view {
  color: var(--bs-info);
}
.access--cond {
  color: var(--asm-warning-fg);
  font-weight: 700;
}
.access--none {
  color: var(--asm-border-strong);
}
.mark-yes {
  color: var(--asm-success-fg);
}
.mark-no {
  color: var(--asm-border-strong);
}
</style>
