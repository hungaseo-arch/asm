<script setup>
defineProps({
  tone: { type: String, default: 'neutral' },
  dot: { type: Boolean, default: false },
})
</script>

<template>
  <span class="asm-badge" :class="`asm-badge--${tone}`">
    <i v-if="dot" class="dot" aria-hidden="true"></i>
    <slot />
  </span>
</template>
