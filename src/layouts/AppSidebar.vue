<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { APP_VERSION, findNavGroup, matchPath } from '@/config/navigation'
defineProps({ open: { type: Boolean, default: false } })
const emit = defineEmits(['close'])
const route = useRoute()
const router = useRouter()
const isActive = (item) => Boolean(item.to && matchPath(route.path, item.to))
/**
 * 대분류(1단)는 상단 헤더가 보여주므로 사이드바에는 두지 않습니다 — 같은 정보를 두 번
 * 내보내면 그룹 헤더 8개가 목록을 늘리기만 합니다. 사이드바는 '현재 대분류의 하위메뉴'만
 * 평면으로 나열합니다.
 */
const group = computed(() => findNavGroup(route.path))
const items = computed(() => group.value?.items ?? [])
function openItem(item) {
  if (item.to) {
    void router.push(item.to)
    emit('close')
    return
  }
  toast.info(`${item.label} 화면은 프론트엔드 범위에 포함되지 않습니다`)
}
</script>

<template>
  <button
    v-if="open"
    type="button"
    class="sidebar-scrim d-lg-none"
    aria-label="메뉴 닫기"
    @click="emit('close')"
  ></button>

  <aside class="sidebar" :class="{ 'is-open': open }">
    <!-- 모바일 전용 닫기 버튼 — 데스크톱에서는 숨김(d-lg-none) -->
    <button
      type="button"
      class="asm-icon-btn is-sm is-borderless sidebar-close d-lg-none"
      aria-label="메뉴 닫기"
      @click="emit('close')"
    >
      <X :size="18" />
    </button>

    <!-- 현재 대분류의 하위메뉴(2단)만 평면으로 나열합니다. -->
    <nav class="nav-list" :aria-label="group?.nav.label">
      <button
        v-for="item in items"
        :key="item.label"
        type="button"
        class="sub-item"
        :class="{ 'is-active': isActive(item) }"
        @click="openItem(item)"
      >
        <span class="flex-grow-1">{{ item.label }}</span>
        <em v-if="item.badge">{{ item.badge }}</em>
      </button>
    </nav>

    <div class="sidebar-foot">
      <span>PT ASCENDO INTERNASIONAL</span>
      <small>ASM · {{ APP_VERSION }}</small>
    </div>
  </aside>
</template>

<style scoped>
/* 메뉴·요약 카드 위치 교체(2026-09-04) — 사이드바(메뉴)를 화면 우측으로 옮깁니다. */
.sidebar {
  position: fixed;
  top: var(--asm-header-offset);
  bottom: 0;
  right: 0;
  padding: 12px 8px;
  overflow-y: auto;
  z-index: 1020;
  display: flex;
  flex-direction: column;
}
/* 모바일 닫기 버튼 — 사이드바 좌상단(레일이 화면 우측에서 슬라이드), 데스크톱에서는 숨김 */
.sidebar-close {
  align-self: flex-start;
  margin-bottom: 8px;
}
.nav-list {
  margin-top: 4px;
}
.sub-item em {
  font-style: normal;
  font-size: 10px;
  letter-spacing: 0.04em;
  color: var(--asm-warning-fg);
  background: var(--asm-warning-bg);
  padding: 2px 4px;
  border-radius: var(--asm-radius-sm);
}
.sidebar-foot {
  margin-top: auto;
  border-top: 1px solid var(--asm-sidebar-border);
  padding: 16px 8px 0;
  color: var(--asm-fg-muted);
}
.sidebar-foot span {
  display: block;
  font-size: 12px;
  font-weight: 600;
}
.sidebar-foot small {
  display: block;
  font-size: 11px;
  margin-top: 4px;
}

.sidebar-scrim {
  position: fixed;
  inset: var(--asm-header-offset) 0 0;
  border: 0;
  padding: 0;
  background: var(--asm-scrim);
  z-index: 1015;
}
</style>
