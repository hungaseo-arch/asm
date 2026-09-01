<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { Bell, Menu } from 'lucide-vue-next'
import { toast } from 'vue-sonner'
import { APP_USER, topNav } from '@/config/navigation'

defineEmits<{ (event: 'open-sidebar'): void }>()

const route = useRoute()
const router = useRouter()

const isActive = (item: { to?: string; match?: string[] }) => {
  const prefixes = item.match ?? (item.to ? [item.to] : [])
  return prefixes.some((prefix) => route.path.startsWith(prefix))
}

function openItem(item: { label: string; to?: string }) {
  if (item.to) {
    void router.push(item.to)
    return
  }
  toast.info(`${item.label} 워크스페이스는 현재 범위에 포함되지 않습니다`)
}
</script>

<template>
  <header class="menu-header">
    <!-- 브랜드 (Brand) -->
    <div class="brand">
      <button
        type="button"
        class="asm-icon-btn is-borderless d-lg-none"
        aria-label="메뉴 열기"
        @click="$emit('open-sidebar')"
      >
        <Menu :size="20" />
      </button>
      <div class="brand-mark">A</div>
      <div class="lh-sm">
        <strong class="d-block">ASM</strong>
        <span class="d-none d-sm-block text-secondary">Ascendo Management System</span>
      </div>
    </div>

    <!-- 상단 메뉴 -->
    <nav class="topnav d-none d-lg-flex" aria-label="Primary">
      <button
        v-for="item in topNav"
        :key="item.label"
        type="button"
        class="nav-item"
        :class="{ active: isActive(item) }"
        @click="openItem(item)"
      >
        {{ item.label }}
      </button>
    </nav>

    <!-- 우측 액션 -->
    <div class="top-actions">
      <button type="button" class="asm-icon-btn is-borderless position-relative" aria-label="알림">
        <Bell :size="18" />
        <i class="notif-dot" aria-hidden="true"></i>
      </button>

      <!-- 로그인 기능 비활성 — 표시 전용 사용자 (config/navigation.ts APP_USER) -->
      <div class="profile">
        <span class="avatar">{{ APP_USER.initials }}</span>
        <span class="d-none d-md-block text-start lh-sm">
          <b>{{ APP_USER.name }}</b>
          <small>{{ APP_USER.role }}</small>
        </span>
      </div>
    </div>
  </header>
</template>

<style scoped>
.brand {
  width: var(--asm-sidebar-w);
  height: 100%;
  padding: 0 16px;
  display: flex;
  gap: 8px;
  align-items: center;
  border-right: 1px solid var(--asm-border);
  flex: none;
}
.brand-mark {
  width: 32px;
  height: 32px;
  background: var(--asm-primary);
  color: var(--asm-primary-fg);
  border-radius: var(--asm-radius-lg);
  display: grid;
  place-items: center;
  font-weight: 800;
  font-size: 16px;
}
.brand strong { font-size: 16px; letter-spacing: 0.04em; }
.brand span { font-size: 10px; white-space: nowrap; }

/* 가이드 6-2 — 14px / weight 500 / 좌우 패딩 12px */
.topnav { align-items: center; margin-left: 16px; gap: 4px; }
.topnav .nav-item {
  height: 36px;
  border: 0;
  background: transparent;
  padding: 0 12px;
  border-radius: var(--asm-radius-md);
  color: var(--asm-fg-muted);
  font-size: 14px;
  font-weight: 500;
  transition: background-color 0.15s, color 0.15s;
}
.topnav .nav-item:hover { color: var(--asm-primary); background: var(--asm-muted); }
/* 활성 대분류는 네이비 배경 + 흰 글자 (가이드 6-2 · P1) */
.topnav .nav-item.active,
.topnav .nav-item.active:hover {
  background: var(--asm-primary);
  color: var(--asm-primary-fg);
  font-weight: 600;
}

.top-actions {
  margin-left: auto;
  height: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 24px;
}
.notif-dot {
  position: absolute;
  width: 8px;
  height: 8px;
  background: var(--bs-danger);
  border-radius: 50%;
  top: 6px;
  right: 6px;
  border: 1px solid var(--asm-bg);
}
.profile { display: flex; align-items: center; gap: 8px; color: var(--asm-fg); }
.profile .avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--asm-secondary);
  color: var(--asm-primary);
  font-weight: 700;
  display: grid;
  place-items: center;
  flex: none;
}
.profile b { display: block; font-size: 13px; }
.profile small { display: block; font-size: 11px; color: var(--asm-fg-muted); }

@media (max-width: 991.98px) {
  .brand { width: auto; border-right: 0; padding: 0 12px; }
  .top-actions { padding: 0 16px; gap: 8px; }
}
</style>
