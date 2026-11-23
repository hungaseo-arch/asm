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
  <!-- 헤더·언어 토글이 없는 화면이라 로그인 정보와 무관하게 한국어·인도네시아어를 함께 보여 줍니다. -->
  <main class="not-found asm-motif">
    <div class="text-center">
      <p class="asm-eyebrow mb-2">ASM · ASCENDO MANAGEMENT SYSTEM</p>
      <p class="code">404</p>
      <h1 lang="ko">요청하신 페이지를 찾을 수 없습니다.</h1>
      <p class="lead-text" lang="id">Halaman yang diminta tidak ditemukan.</p>
      <RouterLink class="btn btn-primary mt-3" to="/">
        <span lang="ko">CSR 목록으로 이동</span>
        <span aria-hidden="true"> · </span>
        <span lang="id">Ke daftar CSR</span>
      </RouterLink>
    </div>
  </main>
</template>

<style scoped>
.not-found {
  min-height: 100vh;
  display: grid;
  place-items: center;
  background: var(--asm-page-bg);
  padding: 24px;
}
.code {
  font-size: 20px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  margin: 0 0 4px;
  color: var(--asm-primary);
}
h1 {
  font-size: 20px;
  font-weight: 700;
  line-height: 1.3;
  margin: 0 0 4px;
  color: var(--asm-fg);
}
.lead-text {
  color: var(--asm-fg-muted);
  margin: 0;
}
</style>
