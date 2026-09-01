<script setup lang="ts">
import type { BadgeTone } from '@/types/purchase-po'

withDefaults(defineProps<{ tone?: BadgeTone; dot?: boolean }>(), {
  tone: 'neutral',
  dot: false,
})
</script>

<template>
  <span class="asm-badge" :class="`asm-badge--${tone}`">
    <i v-if="dot" class="dot" aria-hidden="true"></i>
    <slot />
  </span>
</template>
