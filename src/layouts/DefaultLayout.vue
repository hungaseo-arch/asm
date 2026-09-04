<script setup>
import { ref } from 'vue'
import AppTopbar from './AppTopbar.vue'
import AppSidebar from './AppSidebar.vue'
import AppSummaryRail from './AppSummaryRail.vue'
const sidebarOpen = ref(false)
</script>

<template>
  <!-- BI 기준 — 헤더 위에 4px 블루 액센트 바(전 매체 공통 브랜드 요소, 가이드 7-1). -->
  <div class="asm-app">
    <div class="asm-accent-bar" aria-hidden="true"></div>
    <AppTopbar @open-sidebar="sidebarOpen = true" />

    <!-- 메뉴·요약 카드 위치 교체(2026-09-04) — 레일(요약)이 좌측, 사이드바(메뉴)가 우측. -->
    <div class="asm-shell">
      <AppSummaryRail />
      <main class="asm-content">
        <div class="asm-content-inner">
          <slot />
        </div>
      </main>
      <AppSidebar :open="sidebarOpen" @close="sidebarOpen = false" />
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
  /*
   * 액센트 바·헤더는 fixed 가 아니라 sticky 라 문서 흐름 안에서 이미 자기 높이(4+56px)
   * 를 차지합니다. 여기서 또 padding-top 으로 같은 높이를 더하면 그만큼 상단 공백이
   * 두 배가 됩니다 — 이전에 있던 버그였습니다(2026-09-04 발견·제거).
   * 흐름 밖에 있는 고정(.sidebar, position:fixed) 요소만 별도로 --asm-header-offset
   * 만큼 내려서 맞춥니다.
   */
  min-height: 100vh;
}
/*
 * 본문 패딩 — 가이드 5-2/6-1 값(데스크톱 20px·모바일 16px).
 * 좌측은 요약 카드 레일(AppSummaryRail), 우측은 메뉴(AppSidebar) 자리를 각각
 * --asm-sidebar-w 만큼 비웁니다 — 폭이 같아 어느 쪽이 어디에 있든 값은 동일합니다.
 * 둘 다 데스크톱 전용이라 모바일에서는 양쪽 여백을 함께 접습니다.
 */
.asm-content {
  margin-left: var(--asm-sidebar-w);
  margin-right: var(--asm-sidebar-w);
  min-width: 0;
  flex: 1;
  padding: 20px;
}
.asm-content-inner {
  max-width: 1200px;
  margin: 0 auto;
}

@media (max-width: 991.98px) {
  .asm-content {
    margin-left: 0;
    margin-right: 0;
    padding: 16px;
  }
}
</style>
