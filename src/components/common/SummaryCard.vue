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
  <!-- KPI 카드 — 가이드 8-3. 라벨·값·증감 3단 구조는 전역 .asm-kpi-* 규격을 씁니다. -->
  <article class="asm-panel summary-card" :class="`tone-${tone}`">
    <span class="asm-kpi-label">{{ label }}</span>
    <strong class="asm-kpi-value">{{ value }}</strong>
    <small v-if="note" class="asm-kpi-delta note">{{ note }}</small>
  </article>
</template>

<style scoped>
/*
 * 좌측 요약 레일(AppSummaryRail.vue, 폭 220px)에 세로로 쌓이는 카드입니다(2026-09-04
 * 이동). 예전에는 4장을 가로 그리드로 나란히 두던 시절 카드끼리 높이를 맞추려고
 * height:100% 를 썼는데, 세로 스택에서는 그게 카드를 뷰포트 높이만큼 늘려버려 아래에
 * 빈 여백만 남깁니다 — 지우고 내용물 높이에 맞춥니다.
 *
 * 카드 패딩은 가이드 8-3 의 20×24px 대신 12×14px 을 씁니다 — 레일 폭이 220px 라
 * 규정값을 쓰면 내용 폭이 172px 밖에 남지 않아 금액이 줄바꿈됩니다(의도적 축소).
 */
.summary-card {
  padding: 12px 14px;
  display: flex;
  flex-direction: column;
}
/*
 * 값은 가이드 8-3 의 26px 대신 20px — 위와 같은 이유(레일 폭)입니다.
 * 굵기·tabular-nums·라벨 12px·증감 12px 은 규정 그대로 .asm-kpi-* 에서 옵니다.
 */
.asm-kpi-value {
  font-size: 20px;
  line-height: 1.3;
  margin: 0 0 2px;
  overflow-wrap: anywhere;
}
.note {
  color: var(--asm-fg-muted);
}

/*
 * 톤 (Tone / Nada) — 가이드 3-3 상태색. 이전에는 tone 을 클래스로만 붙이고 스타일이
 * 없어서, "주의 필요" 카드가 일반 카드와 똑같이 보였습니다. 카드 좌측 3px 상태색 띠와
 * 증감 문구 색으로 구분합니다(값 자체는 fg 유지 — 가이드 8-3 "강조 KPI만 Blue").
 */
.tone-success {
  border-left: 3px solid var(--asm-success);
}
.tone-warning {
  border-left: 3px solid var(--asm-warning);
}
.tone-danger {
  border-left: 3px solid var(--asm-danger);
}
.tone-success .note {
  color: var(--asm-success);
}
.tone-warning .note {
  color: var(--asm-warning);
}
.tone-danger .note {
  color: var(--asm-danger);
}
</style>
