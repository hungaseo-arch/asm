<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import ListScreen from '@/components/common/ListScreen.vue'
import { screenBySlug } from '@/config/screens'
const route = useRoute()
const screen = ref(null)
/** 라우트 meta.screen 슬러그로 화면 정의를 지연 로딩합니다. */
watch(
  () => route.meta.screen,
  async (slug) => {
    if (!slug) return
    screen.value = null
    const entry = screenBySlug(slug)
    if (entry) screen.value = await entry.load()
  },
  { immediate: true },
)
</script>

<template>
  <DefaultLayout>
    <ListScreen v-if="screen" :screen="screen" />
    <p v-else class="loading">불러오는 중…</p>
  </DefaultLayout>
</template>

<style scoped>
.loading {
  color: var(--asm-fg-muted);
  font-size: 13px;
  padding: 48px 0;
}
</style>
