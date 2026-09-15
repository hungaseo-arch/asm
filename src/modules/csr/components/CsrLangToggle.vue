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
      <!--
        태극기 — Wikimedia Commons 의 공개 도메인 원본(Flag_of_South_Korea.svg) 좌표를
        그대로 옮겼습니다. viewBox 만 원본과 같은 -72 -48 144 96(3:2, 중심이 원점)입니다.
        태극 지름 = 세로의 1/2 · 괘 길이 = 세로의 1/4 · 효 두께 4 · 효 간격 2 · 기울기 33.69°
        4괘: 건(☰) 좌상 · 곤(☷) 우하 · 감(☵) 우상 · 리(☲) 좌하.
      -->
      <svg viewBox="-72 -48 144 96" aria-hidden="true">
        <path fill="#fff" d="M-72-48v96H72v-96z" />
        <g stroke="#000" stroke-width="4">
          <!-- ↘ 대각선: 좌상 건(☰) · 우하 곤(☷) -->
          <path
            transform="rotate(33.69006752598)"
            d="M-50-12v24m6 0v-24m6 0v24m76 0V1m0-2v-11m6 0v11m0 2v11m6 0V1m0-2v-11"
          />
          <!-- ↗ 대각선: 좌하 리(☲) · 우상 감(☵) -->
          <path
            transform="rotate(-33.69006752598)"
            d="M-50-12v24m6 0V1m0-2v-11m6 0v24m76 0V1m0-2v-11m6 0v24m6 0V1m0-2v-11"
          />
        </g>
        <g transform="rotate(33.69006752598)">
          <path fill="#cd2e3a" d="M12 0a18 18 0 11-36 0 24 24 0 1148 0" />
          <path fill="#0047a0" d="M-24 0a24 24 0 1048 0A12 12 0 100 0a12 12 0 11-24 0" />
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
