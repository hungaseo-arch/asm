<script setup>
/**
 * 상태·결정 배지 — List · Detail · Dashboard 가 저마다 그리던
 * `<span class="asm-badge" :class="...">` 블록을 하나로 모읍니다.
 *
 * kind: 'it_status' | 'it_decision' | 'verification_result' — 톤·툴팁·표시 코드는
 * status.js · i18n.js 의 사전 하나에서 옵니다(화면별 하드코딩 금지, 작업지시서 §C-2).
 */
import { computed } from 'vue'
import { STATUS_TONE } from '../config'
import { pickLang, toneOf } from '../i18n'
import { itStatusTitle, verifyCodeOf, verifyTitle } from '../status'

const props = defineProps({
  kind: { type: String, required: true },
  value: { type: String, default: null },
  lang: { type: String, default: 'ko' },
})

const tone = computed(() =>
  props.kind === 'it_status'
    ? (STATUS_TONE[props.value] ?? 'neutral')
    : toneOf(props.kind, props.value),
)
const title = computed(() =>
  props.kind === 'it_status'
    ? itStatusTitle(props.value, props.lang)
    : props.kind === 'verification_result'
      ? verifyTitle(props.value, props.lang)
      : '',
)
/** it_status 는 영문 코드 그대로, 현업검증은 코드(PENDING…), 그 밖(it_decision)은 토글 언어 쪽. */
const text = computed(() =>
  props.kind === 'verification_result'
    ? verifyCodeOf(props.value)
    : props.kind === 'it_status'
      ? props.value
      : pickLang(props.value, props.lang),
)
</script>

<template>
  <span v-if="value" class="asm-badge" :class="`asm-badge--${tone}`" :title="title">
    {{ text }}
  </span>
</template>
