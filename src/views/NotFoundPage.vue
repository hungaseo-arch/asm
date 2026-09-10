<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
const route = useRoute()
onMounted(() => {
  console.error('404 Error: 존재하지 않는 경로 접근:', route.fullPath)
})
</script>

<template>
  <!-- 심볼 워터마크 — 가이드 4-4: 오류 화면은 지정 사용처입니다(우하단 잘림 배치, 6%). -->
  <div class="not-found asm-motif">
    <div class="text-center">
      <p class="asm-eyebrow mb-2">ASM · ASCENDO MANAGEMENT SYSTEM</p>
      <h1>404</h1>
      <p class="lead-text">요청하신 페이지를 찾을 수 없습니다.</p>
      <RouterLink class="btn btn-primary mt-3" to="/">Purchase PO로 이동</RouterLink>
    </div>
  </div>
</template>

<style scoped>
.not-found {
  min-height: 100vh;
  display: grid;
  place-items: center;
  background: var(--asm-page-bg);
  padding: 24px;
}
h1 {
  font-size: 56px;
  font-weight: 700;
  margin: 0 0 6px;
  color: var(--asm-primary);
}
.lead-text {
  color: var(--asm-fg-muted);
  margin: 0;
}
</style>
