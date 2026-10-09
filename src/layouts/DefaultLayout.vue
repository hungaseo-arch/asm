<script setup>
import AppTopbar from './AppTopbar.vue'
</script>

<template>
  <!-- BI 기준 — 헤더 위에 4px 블루 액센트 바(전 매체 공통 브랜드 요소, 가이드 7-1). -->
  <div class="asm-app">
    <a href="#asm-main" class="asm-skip-link">본문 바로가기</a>
    <div class="asm-accent-bar" aria-hidden="true"></div>
    <AppTopbar />

    <div class="asm-shell">
      <main id="asm-main" class="asm-content" tabindex="-1">
        <div class="asm-content-inner">
          <slot />
          <!-- 푸터 — 가이드 7-1: 상단선 1px · 12px muted · Copyright © ASEOA -->
          <footer class="asm-footer">
            <span>Copyright © ASEOA</span>
          </footer>
        </div>
      </main>
    </div>
  </div>
</template>

<style scoped>
.asm-app {
  min-height: 100vh;
  background: var(--asm-page-bg);
  color: var(--asm-fg);
}
.asm-shell {
  display: flex;
  min-height: 100vh;
}
/* 스킵 링크 — 평소엔 화면 밖, 키보드 포커스 시에만 좌상단에 노출. */
.asm-skip-link {
  position: absolute;
  top: -40px;
  left: 8px;
  z-index: 2000;
  padding: 8px 16px;
  background: var(--asm-card);
  color: var(--asm-primary);
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-md);
  font-size: 13px;
  font-weight: 600;
  transition: top 0.15s;
}
.asm-skip-link:focus-visible {
  top: 8px;
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
.asm-content:focus-visible {
  outline: none;
}
/*
 * 본문 — 가이드 7-1/7-5 여백(데스크톱 24px · 모바일 16px).
 */
.asm-content {
  min-width: 0;
  flex: 1;
  padding: 24px;
}
/*
 * 목록 화면은 가이드 7-1 대로 full-width(1,200px 제한은 폼·상세 전용)입니다.
 */
.asm-content-inner {
  margin: 0 auto;
}

@media (max-width: 991.98px) {
  .asm-content {
    padding: 16px;
  }
}
</style>
