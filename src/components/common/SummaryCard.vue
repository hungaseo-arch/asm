<script setup>
defineProps({
  label: { type: String, required: true },
  value: { type: String, required: true },
  note: { type: String, default: '' },
  /** 'default' | 'warning' | 'success' | 'danger' */
  tone: { type: String, default: 'default' },
})
</script>

<template>
  <article class="asm-panel summary-card" :class="`tone-${tone}`">
    <span class="label">{{ label }}</span>
    <strong class="value">{{ value }}</strong>
    <small class="note">{{ note }}</small>
  </article>
</template>

<style scoped>
/*
 * 좌측 요약 레일(AppSummaryRail.vue, 폭 220px)에 세로로 쌓이는 카드입니다(2026-09-04
 * 이동). 예전에는 4장을 가로 그리드로 나란히 두던 시절 카드끼리 높이를 맞추려고
 * height:100% 를 썼는데, 세로 스택에서는 그게 카드를 뷰포트 높이만큼 늘려버려 아래에
 * 빈 여백만 남깁니다 — 지우고 내용물 높이에 맞춥니다.
 */
.summary-card {
  padding: 12px 14px;
  display: flex;
  flex-direction: column;
}
.label {
  color: var(--asm-fg-muted);
  font-size: 11px;
}
.value {
  font-size: 18px;
  font-weight: 700;
  line-height: 1.3;
  margin: 4px 0 2px;
  font-variant-numeric: tabular-nums;
}
.note {
  color: var(--asm-fg-muted);
  font-size: 11px;
}
</style>
