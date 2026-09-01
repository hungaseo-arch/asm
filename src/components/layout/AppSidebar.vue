<script setup lang="ts">
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ChevronRight, LayoutDashboard, X } from 'lucide-vue-next'
import { toast } from 'vue-sonner'
import { APP_VERSION, navGroups, type NavGroup, type NavItem } from '@/config/navigation'

defineProps<{ open: boolean }>()
const emit = defineEmits<{ (event: 'close'): void }>()

const route = useRoute()
const router = useRouter()

/** 사용자가 직접 토글한 그룹만 기록합니다. 미기록 그룹은 현재 화면 기준으로 펼칩니다. */
const toggled = ref<Record<string, boolean>>({})

const isActive = (item: NavItem) => Boolean(item.to && route.path.startsWith(item.to))

function isOpen(group: NavGroup) {
  return toggled.value[group.label] ?? group.items.some(isActive)
}

function toggleGroup(group: NavGroup) {
  toggled.value = { ...toggled.value, [group.label]: !isOpen(group) }
}

function openItem(item: NavItem) {
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
    <div class="sidebar-head">
      <span>WORKSPACE</span>
      <button
        type="button"
        class="asm-icon-btn is-sm is-borderless d-lg-none"
        aria-label="메뉴 닫기"
        @click="emit('close')"
      >
        <X :size="18" />
      </button>
    </div>

    <button
      type="button"
      class="sub-item mb-1"
      @click="toast.info('대시보드는 현재 범위에 포함되지 않습니다')"
    >
      <LayoutDashboard :size="17" />
      <span>Dashboard</span>
    </button>

    <div v-for="group in navGroups" :key="group.label" class="nav-group">
      <button
        type="button"
        class="group-head"
        :aria-expanded="isOpen(group)"
        @click="toggleGroup(group)"
      >
        <span>{{ group.label }}</span>
        <ChevronRight :size="14" class="caret" :class="{ 'is-open': isOpen(group) }" />
      </button>
      <template v-if="isOpen(group)">
        <button
          v-for="item in group.items"
          :key="item.label"
          type="button"
          class="sub-item"
          :class="{ 'is-active': isActive(item) }"
          @click="openItem(item)"
        >
          <component :is="item.icon" :size="17" />
          <span class="flex-grow-1">{{ item.label }}</span>
          <em v-if="item.badge">{{ item.badge }}</em>
        </button>
      </template>
    </div>

    <div class="sidebar-foot">
      <span>ASM Production</span>
      <small>{{ APP_VERSION }}</small>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  position: fixed;
  top: calc(var(--asm-topbar-h) + var(--asm-accent-h));
  bottom: 0;
  left: 0;
  padding: 16px 12px;
  overflow-y: auto;
  z-index: 1020;
  display: flex;
  flex-direction: column;
}
/* 가이드 6-3 그룹 구분자 — 12px · muted-foreground · 대문자 · letter-spacing .08em */
.sidebar-head,
.nav-group .group-head {
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--asm-fg-muted);
}
.sidebar-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 8px 8px;
}
.nav-group { margin-top: 16px; }
.nav-group .group-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  width: 100%;
  border: 0;
  background: transparent;
  padding: 4px 8px;
  margin-bottom: 4px;
  border-radius: var(--asm-radius-md);
  text-align: left;
}
.nav-group .group-head:hover { background: var(--asm-secondary); color: var(--asm-primary); }
.nav-group .group-head:focus-visible {
  outline: 3px solid rgb(0 64 133 / 0.2);
  outline-offset: 1px;
}
.caret { flex: none; transition: transform 0.15s; }
.caret.is-open { transform: rotate(90deg); }
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
  border-top: 1px solid var(--asm-border);
  padding: 16px 8px 0;
  color: var(--asm-fg-muted);
}
.sidebar-foot span { display: block; font-size: 12px; font-weight: 600; }
.sidebar-foot small { display: block; font-size: 11px; margin-top: 4px; }

.sidebar-scrim {
  position: fixed;
  inset: calc(var(--asm-topbar-h) + var(--asm-accent-h)) 0 0;
  border: 0;
  padding: 0;
  background: rgb(8 18 31 / 0.38);
  z-index: 1015;
}
</style>
