<script setup>
import { Toaster } from 'vue-sonner'
</script>

<template>
  <RouterView />
  <!-- theme 을 명시적으로 고정합니다. "system" 일 때만 vue-sonner 가 prefers-color-scheme 을 구독합니다. -->
  <Toaster theme="light" position="top-right" rich-colors close-button />
</template>
