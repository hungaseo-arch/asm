<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import AppTopbar from './AppTopbar.vue'
import AppSidebar from './AppSidebar.vue'
import AppSummaryRail from './AppSummaryRail.vue'
import { APP_VERSION } from '@/config/navigation'
import { useBodyScrollLock } from '@/composables/useBodyScrollLock'
/**
 * 좌·우 레일은 둘 다 드로어(off-canvas)입니다 — 고정 배치를 걷어냈습니다.
 *
 * 예전에는 데스크톱에서 양쪽이 각각 220px 를 늘 차지해, 1,366px 화면에서 본문에 남는
 * 폭이 900px 남짓이었습니다. 목록 표가 화면의 대부분인 ASM 에서는 그만큼 열이 잘리고
 * 가로 스크롤이 생깁니다. 필요할 때만 열어 쓰도록 바꾸고 본문에 폭을 전부 돌려줍니다.
 * 한 번에 하나만 열립니다 — 좁은 화면에서 양쪽이 동시에 덮이면 본문이 사라집니다.
 */
const menuOpen = ref(false)
const summaryOpen = ref(false)
function openMenu() {
  summaryOpen.value = false
  menuOpen.value = true
}
function openSummary() {
  menuOpen.value = false
  summaryOpen.value = true
}
/*
 * 드로어가 열려 있는 동안 배경(본문)은 스크롤을 잠급니다 — 가림막을 덮어 둔 채 뒤쪽
 * 목록이 같이 움직이면 닫고 났을 때 보던 자리를 잃습니다. 모달과 같은 규칙입니다.
 */
useBodyScrollLock(() => menuOpen.value || summaryOpen.value)
/**
 * Esc 로 열린 드로어를 닫습니다. 두 드로어가 각자 리스너를 달면 닫혀 있는 쪽까지
 * 매번 반응하므로(모달의 Esc 와도 겹칩니다) 여기 한 곳에서만 처리합니다.
 */
function onKeydown(event) {
  if (event.key !== 'Escape') return
  if (!menuOpen.value && !summaryOpen.value) return
  menuOpen.value = false
  summaryOpen.value = false
}
onMounted(() => document.addEventListener('keydown', onKeydown))
onBeforeUnmount(() => document.removeEventListener('keydown', onKeydown))
/*
 * 화면을 옮기면 열려 있던 드로어는 닫습니다. 특히 요약 드로어는 화면마다 카드가 달라
 * (요약이 없는 화면도 있습니다) 열린 채로 두면 다음 화면에서 엉뚱한 시점에 다시 나타납니다.
 */
const route = useRoute()
watch(
  () => route.path,
  () => {
    menuOpen.value = false
    summaryOpen.value = false
  },
)
</script>

<template>
  <!-- BI 기준 — 헤더 위에 4px 블루 액센트 바(전 매체 공통 브랜드 요소, 가이드 7-1). -->
  <div class="asm-app">
    <div class="asm-accent-bar" aria-hidden="true"></div>
    <AppTopbar @open-sidebar="openMenu" @open-summary="openSummary" />

    <!--
      좌: 요약 드로어(AppSummaryRail) · 우: 메뉴 드로어(AppSidebar).
      둘 다 흐름 밖(fixed)이라 본문은 화면 폭을 그대로 씁니다.
    -->
    <div class="asm-shell">
      <AppSummaryRail :open="summaryOpen" @close="summaryOpen = false" />
      <main class="asm-content">
        <div class="asm-content-inner">
          <slot />
          <!-- 푸터 — 가이드 7-1: 상단선 1px · 12px muted · © PT ASCENDO INTERNASIONAL -->
          <footer class="asm-footer">
            <span>© PT ASCENDO INTERNASIONAL</span>
            <small>ASM · {{ APP_VERSION }}</small>
          </footer>
        </div>
      </main>
      <AppSidebar :open="menuOpen" @close="menuOpen = false" />
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
   * 흐름 밖에 있는 고정(fixed) 드로어만 별도로 --asm-header-offset 만큼 내려서 맞춥니다.
   */
  min-height: 100vh;
}
/*
 * 본문 — 가이드 7-1/7-5 여백(데스크톱 24px · 모바일 16px). 좌·우 레일이 드로어가 되면서
 * 자리를 비워둘 필요가 없어져 margin 을 걷어냈습니다(본문이 화면 폭 전체를 씁니다).
 */
.asm-content {
  min-width: 0;
  flex: 1;
  padding: 24px;
}
/*
 * 목록 화면은 가이드 7-1 대로 full-width(1,200px 제한은 폼·상세 전용)입니다. 드로어
 * 전환으로 얻은 폭을 다시 1,200px 로 묶으면 표의 가로 스크롤이 그대로 남습니다.
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
