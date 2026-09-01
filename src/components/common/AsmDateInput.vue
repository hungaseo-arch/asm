<script setup>
import { computed } from 'vue'
/**
 * ISO 날짜 입력 (ISO date input / Input tanggal ISO)
 *
 * 브라우저 기본 `input[type=date]` 는 안내문과 표기 순서가 사용자 PC 의 언어 설정을
 * 따라가므로(한국어 PC 에서 "연도-월-일" 노출) 개선의견서 이슈 15 에 따라
 * 언어 설정과 무관하게 YYYY-MM-DD 로 고정 표시되는 입력 컴포넌트를 사용합니다.
 * 디자인 가이드 8-2 의 날짜 표기(ISO 8601) 기준과도 동일합니다.
 */
const props = defineProps({
  modelValue: { type: String, default: '' },
  ariaLabel: { type: String, default: undefined },
  min: { type: String, default: undefined },
})
const emit = defineEmits(['update:modelValue'])
const ISO_PATTERN = /^\d{4}-\d{2}-\d{2}$/
const isInvalid = computed(() => {
  const value = props.modelValue
  if (!value) return false
  if (!ISO_PATTERN.test(value)) return true
  if (props.min && value < props.min) return true
  return Number.isNaN(new Date(`${value}T00:00:00`).getTime())
})
/** 숫자만 받아 YYYY-MM-DD 형태로 하이픈을 자동 삽입합니다. */
function onInput(event) {
  const digits = event.target.value.replace(/\D/g, '').slice(0, 8)
  const parts = [digits.slice(0, 4), digits.slice(4, 6), digits.slice(6, 8)].filter(Boolean)
  emit('update:modelValue', parts.join('-'))
}
</script>

<template>
  <div class="position-relative">
    <CalendarDays :size="15" class="field-icon" />
    <input
      :value="modelValue"
      type="text"
      inputmode="numeric"
      maxlength="10"
      placeholder="YYYY-MM-DD"
      class="form-control ps-5 date-input"
      :class="{ 'is-invalid': isInvalid }"
      :aria-label="ariaLabel"
      :aria-invalid="isInvalid"
      @input="onInput"
    />
  </div>
</template>

<style scoped>
.field-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--asm-fg-muted);
  pointer-events: none;
  z-index: 2;
}
/* 날짜는 자릿수 정렬이 필요하므로 monospace (가이드 4-1) */
.date-input {
  font-family: var(--bs-font-monospace);
  font-variant-numeric: tabular-nums;
}
.date-input.is-invalid {
  border-color: var(--bs-danger);
  box-shadow: 0 0 0 2px rgb(201 0 25 / 0.09);
}
</style>
