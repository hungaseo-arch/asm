<script setup>
/**
 * 상태 범례 (Legend / Legenda) — 작업지시서 v1.1 §C-2
 *
 * 목록·상세 상단 우측의 「범례」 버튼. 누르면 IT상태 4행 + 현업검증 5행을 Code · 이름 · 설명 3열로
 * 펼치고, 아래에 전환 규칙을 둡니다. 이름·설명·규칙은 **토글 언어 한쪽만** 보여 줍니다
 * (2026-09-11 「범례 한국어/인니어 분리」 — 세 언어 병기는 줄이 길고 읽기 어려웠음). 내용은 status.js 하나에서 옵니다.
 * 기본은 접힘 — 매번 보이면 표가 아래로 밀립니다. 바깥 클릭 · Esc 로 닫힘.
 */
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { IT_STATUS, TRANSITION_RULES, VERIFY_STATUS, descOf, nameOf } from '../status'

const props = defineProps({ lang: { type: String, default: 'id' } })
const open = ref(false)
const root = ref(null)
const t = (ko, id) => (props.lang === 'id' ? id : ko)

// 노션 잔존값(On Hold · N/A)은 표준 4단계가 아니라 범례에서 뺍니다.
const itRows = IT_STATUS.filter((s) =>
  ['Open', 'Ongoing', 'Completed', 'Verified'].includes(s.value),
)

function onDoc(e) {
  if (open.value && root.value && !root.value.contains(e.target)) open.value = false
}
function onKey(e) {
  if (e.key === 'Escape') open.value = false
}
onMounted(() => {
  document.addEventListener('click', onDoc)
  document.addEventListener('keydown', onKey)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', onDoc)
  document.removeEventListener('keydown', onKey)
})
</script>

<template>
  <div ref="root" class="legend">
    <button
      type="button"
      class="btn btn-sm btn-outline-secondary"
      :aria-expanded="open"
      @click="open = !open"
    >
      {{ t('범례', 'Legenda') }} {{ open ? '▴' : '▾' }}
    </button>

    <div
      v-if="open"
      class="legend-panel asm-panel"
      role="dialog"
      :aria-label="t('상태 범례', 'Legenda status')"
    >
      <h3>
        {{ t('IT상태', 'Status IT') }}
        <small>it_status · {{ t('IT부서 관리', 'dikelola Tim IT') }}</small>
      </h3>
      <table class="table asm-table">
        <thead>
          <tr>
            <th>Code</th>
            <th>{{ t('한국어', 'Bahasa Indonesia') }}</th>
            <th>{{ t('설명', 'Keterangan') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="s in itRows" :key="s.value">
            <td class="nowrap">
              <span class="asm-badge" :class="`asm-badge--${s.tone}`">{{ s.code }}</span>
            </td>
            <td class="nowrap">{{ nameOf(s, lang) }}</td>
            <td class="wrap">{{ descOf(s, lang) }}</td>
          </tr>
        </tbody>
      </table>

      <h3>
        {{ t('현업검증', 'Hasil Verifikasi') }}
        <small>verification_result · {{ t('총괄팀 관리', 'dikelola Tim Umum') }}</small>
      </h3>
      <table class="table asm-table">
        <thead>
          <tr>
            <th>Code</th>
            <th>{{ t('한국어', 'Bahasa Indonesia') }}</th>
            <th>{{ t('설명', 'Keterangan') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="s in VERIFY_STATUS" :key="s.code">
            <td class="nowrap">
              <span class="asm-badge" :class="`asm-badge--${s.tone}`">{{ s.code }}</span>
            </td>
            <td class="nowrap">{{ nameOf(s, lang) }}</td>
            <td class="wrap">{{ descOf(s, lang) }}</td>
          </tr>
        </tbody>
      </table>

      <h3>{{ t('전환 규칙', 'Aturan transisi') }}</h3>
      <ul class="rules">
        <li v-for="(r, i) in TRANSITION_RULES" :key="i">{{ lang === 'id' ? r.id : r.ko }}</li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
.legend {
  position: relative;
}
.legend-panel {
  position: absolute;
  right: 0;
  top: calc(100% + 6px);
  z-index: 1060;
  width: min(760px, 92vw);
  padding: 14px 16px;
  box-shadow: 0 8px 24px rgb(0 0 0 / 0.12);
  font-size: 13px;
}
.legend-panel h3 {
  font-size: 13px;
  font-weight: 700;
  margin: 8px 0 6px;
}
.legend-panel h3 small {
  font-weight: 500;
  color: var(--asm-fg-muted);
  margin-left: 6px;
}
.legend-panel table {
  margin-bottom: 4px;
}
.legend-panel td.wrap {
  white-space: normal;
  overflow-wrap: anywhere;
}
.rules {
  margin: 0;
  padding-left: 18px;
}
.rules li {
  margin-bottom: 4px;
}
</style>
