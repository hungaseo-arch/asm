<script setup>
/**
 * 표시 언어 토글 — 국기 아이콘 (2026-09-10 요청)
 *
 * 이모지 국기(🇮🇩 🇰🇷)를 쓰지 않는 이유: Windows 의 Segoe UI Emoji 에는 국기 글리프가 없어
 * 지역 표시 문자 "ID" "KR" 로만 찍힙니다 — 현지 사무실 PC 가 대부분 Windows 입니다.
 * 그래서 인라인 SVG 로 그립니다. 외부 이미지 요청도, 새 의존성도 없습니다.
 */
const props = defineProps({ modelValue: { type: String, default: 'id' } })
const emit = defineEmits(['update:modelValue'])
const pick = (v) => emit('update:modelValue', v)
</script>

<template>
  <div class="lang-toggle" role="group" aria-label="언어 · Bahasa">
    <button
      type="button"
      class="flag"
      :class="{ active: props.modelValue === 'id' }"
      :aria-pressed="props.modelValue === 'id'"
      aria-label="Bahasa Indonesia"
      title="Bahasa Indonesia"
      @click="pick('id')"
    >
      <!-- 인도네시아 — 위 빨강 · 아래 흰색 (2:3) -->
      <svg viewBox="0 0 30 20" aria-hidden="true">
        <rect width="30" height="10" fill="#ce1126" />
        <rect y="10" width="30" height="10" fill="#fff" />
      </svg>
    </button>
    <button
      type="button"
      class="flag"
      :class="{ active: props.modelValue === 'ko' }"
      :aria-pressed="props.modelValue === 'ko'"
      aria-label="한국어"
      title="한국어"
      @click="pick('ko')"
    >
      <!-- 태극기 — 태극(빨강 위·파랑 아래)과 건곤감리 4괘를 단순화해 그렸습니다. -->
      <svg viewBox="0 0 30 20" aria-hidden="true">
        <rect width="30" height="20" fill="#fff" />
        <g transform="translate(15 10)">
          <path d="M-5 0A5 5 0 0 1 5 0A2.5 2.5 0 0 1 0 0A2.5 2.5 0 0 0 -5 0Z" fill="#cd2e3a" />
          <path d="M5 0A5 5 0 0 1 -5 0A2.5 2.5 0 0 0 0 0A2.5 2.5 0 0 1 5 0Z" fill="#0047a0" />
        </g>
        <g fill="#000" transform="translate(15 10) rotate(-33.7)">
          <g transform="translate(-9 0)">
            <rect x="-2.5" y="-2.1" width="5" height="0.9" />
            <rect x="-2.5" y="-0.45" width="5" height="0.9" />
            <rect x="-2.5" y="1.2" width="5" height="0.9" />
          </g>
          <g transform="translate(9 0)">
            <rect x="-2.5" y="-2.1" width="2.2" height="0.9" />
            <rect x="0.3" y="-2.1" width="2.2" height="0.9" />
            <rect x="-2.5" y="-0.45" width="2.2" height="0.9" />
            <rect x="0.3" y="-0.45" width="2.2" height="0.9" />
            <rect x="-2.5" y="1.2" width="2.2" height="0.9" />
            <rect x="0.3" y="1.2" width="2.2" height="0.9" />
          </g>
        </g>
        <g fill="#000" transform="translate(15 10) rotate(33.7)">
          <g transform="translate(-9 0)">
            <rect x="-2.5" y="-2.1" width="2.2" height="0.9" />
            <rect x="0.3" y="-2.1" width="2.2" height="0.9" />
            <rect x="-2.5" y="-0.45" width="5" height="0.9" />
            <rect x="-2.5" y="1.2" width="2.2" height="0.9" />
            <rect x="0.3" y="1.2" width="2.2" height="0.9" />
          </g>
          <g transform="translate(9 0)">
            <rect x="-2.5" y="-2.1" width="5" height="0.9" />
            <rect x="-2.5" y="-0.45" width="2.2" height="0.9" />
            <rect x="0.3" y="-0.45" width="2.2" height="0.9" />
            <rect x="-2.5" y="1.2" width="5" height="0.9" />
          </g>
        </g>
      </svg>
    </button>
  </div>
</template>

<style scoped>
.lang-toggle {
  display: inline-flex;
  gap: 4px;
}
.flag {
  border: 1px solid var(--asm-border);
  background: var(--asm-card);
  padding: 3px;
  border-radius: var(--asm-radius-sm);
  line-height: 0;
  cursor: pointer;
  opacity: 0.55;
  transition:
    opacity 0.15s,
    box-shadow 0.15s;
}
.flag svg {
  width: 24px;
  height: 16px;
  display: block;
  border-radius: 2px;
  /* 흰 바탕 국기가 카드에 묻히지 않게 얇은 테두리를 줍니다. */
  outline: 1px solid rgb(0 0 0 / 0.12);
  outline-offset: -1px;
}
.flag:hover {
  opacity: 0.85;
}
/* 활성 국기는 또렷하게 + 블루 링 (가이드 7-2 활성 표시와 같은 색) */
.flag.active {
  opacity: 1;
  border-color: var(--asm-primary);
  box-shadow: 0 0 0 2px var(--asm-primary-10);
}
.flag:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
</style>
