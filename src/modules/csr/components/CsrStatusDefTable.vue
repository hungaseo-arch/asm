<script setup>
/**
 * 상태 정의 표 — Code · 이름 · 설명 3열. IT상태·현업검증 둘 다 같은 모양이라
 * CsrStatusLegend · CsrStatusGuidePage 가 4곳에서 손으로 반복하던 표를 하나로 모읍니다.
 */
import { descOf, nameOf } from '../status'

defineProps({
  rows: { type: Array, required: true },
  lang: { type: String, default: 'id' },
  codeLabel: { type: String, default: 'Code' },
  nameLabel: { type: String, required: true },
  descLabel: { type: String, required: true },
  /** 설명 칸 최소 폭 — 상태 기준 문서 페이지처럼 넓은 본문에서 너무 좁게 접히는 것을 막습니다. */
  wrapMinWidth: { type: String, default: '' },
})
</script>

<template>
  <table class="table asm-table">
    <thead>
      <tr>
        <th>{{ codeLabel }}</th>
        <th>{{ nameLabel }}</th>
        <th>{{ descLabel }}</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="s in rows" :key="s.code ?? s.value">
        <td class="nowrap">
          <span class="asm-badge" :class="`asm-badge--${s.tone}`">{{ s.code }}</span>
        </td>
        <td class="nowrap">{{ nameOf(s, lang) }}</td>
        <td class="wrap" :style="wrapMinWidth ? { minWidth: wrapMinWidth } : null">
          {{ descOf(s, lang) }}
        </td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
table {
  margin-bottom: 4px;
}
th,
td {
  vertical-align: top;
}
td.wrap {
  white-space: normal;
  overflow-wrap: anywhere;
}
</style>
