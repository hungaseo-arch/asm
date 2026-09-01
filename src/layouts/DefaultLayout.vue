<script setup>
import { ref } from 'vue'
import AppTopbar from './AppTopbar.vue'
import AppSidebar from './AppSidebar.vue'
const sidebarOpen = ref(false)
</script>

<template>
  <div class="asm-app">
    <div class="asm-accent-bar"></div>
    <AppTopbar @open-sidebar="sidebarOpen = true" />

    <div class="asm-shell">
      <AppSidebar :open="sidebarOpen" @close="sidebarOpen = false" />
      <main class="asm-content">
        <div class="asm-content-inner">
          <slot />
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
  padding-top: calc(var(--asm-topbar-h) + var(--asm-accent-h));
  min-height: 100vh;
}
.asm-content {
  margin-left: var(--asm-sidebar-w);
  min-width: 0;
  flex: 1;
  padding: 24px;
}
.asm-content-inner {
  max-width: 1200px;
  margin: 0 auto;
}

@media (max-width: 991.98px) {
  .asm-content {
    margin-left: 0;
    padding: 18px 16px;
  }
}
</style>
