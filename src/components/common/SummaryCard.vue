<script setup lang="ts">
import type { Component } from 'vue'

withDefaults(
  defineProps<{
    label: string
    value: string
    note: string
    icon: Component
    tone?: 'default' | 'warning' | 'success' | 'danger'
  }>(),
  { tone: 'default' },
)
</script>

<template>
  <article class="asm-panel summary-card" :class="`tone-${tone}`">
    <div class="d-flex flex-column">
      <span class="label">{{ label }}</span>
      <strong class="value">{{ value }}</strong>
      <small class="note">{{ note }}</small>
    </div>
    <i class="icon-box">
      <component :is="icon" :size="19" />
    </i>
  </article>
</template>

<style scoped>
.summary-card {
  padding: 16px;
  display: flex;
  justify-content: space-between;
  gap: 12px;
  min-height: 104px;
  height: 100%;
}
.label { color: var(--asm-fg-muted); font-size: 12px; font-weight: 600; }
.value {
  font-size: 22px;
  line-height: 1.2;
  margin: 8px 0 4px;
  font-variant-numeric: tabular-nums;
}
.note { color: var(--asm-fg-muted); font-size: 11px; }
.icon-box {
  width: 36px;
  height: 36px;
  border-radius: var(--asm-radius-lg);
  background: var(--asm-secondary);
  color: var(--asm-primary);
  display: grid;
  place-items: center;
  flex: none;
}
.tone-warning .icon-box { background: var(--asm-warning-bg); color: var(--asm-warning-fg); }
.tone-success .icon-box { background: var(--asm-success-bg); color: var(--asm-success-fg); }
.tone-danger .icon-box { background: var(--asm-danger-bg); color: var(--asm-danger-fg); }
</style>
