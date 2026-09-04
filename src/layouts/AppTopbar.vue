<script setup>
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { APP_USER, matchPath, topNav } from '@/config/navigation'
defineEmits(['open-sidebar'])
const route = useRoute()
const router = useRouter()
const isActive = (item) => {
  const prefixes = item.match ?? (item.to ? [item.to] : [])
  return prefixes.some((prefix) => matchPath(route.path, prefix))
}
function openItem(item) {
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
      <img src="/img/ascendo-logo-horizontal.png" alt="ASCENDO" class="brand-logo" />
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
/*
 * 가이드 7-2 좌측 — 로고. 좌우 패딩 20px.
 * 현재 화면 제목은 좌측 사이드바의 활성 항목 강조와 내용이 겹쳐 헤더에는 두지
 * 않습니다(2026-09-04 반영) — 문서의 h1 은 본문(page-heading)이 대신 맡습니다.
 */
.brand {
  grid-column: 1;
  height: 100%;
  padding: 0 20px;
  display: flex;
  gap: 10px;
  align-items: center;
  min-width: 0;
}
/*
 * 로고 — ASCENDO BI 가로형 로고 원본(public/img/ascendo-logo-horizontal.png,
 * 640×127 PNG). 가이드 7-2 규격(Full Color 가로형, 높이 28px)대로 원본 그대로
 * 표시합니다(BS 07 — 형태·비율·색 변형 금지). 로고 자체에 회사명이 있어 별도
 * "ASM" 문구는 두지 않습니다.
 */
.brand-logo {
  height: 28px;
  width: auto;
  flex: none;
}

/*
 * 가이드 7-2 — 14px / weight 500 / 패딩 6px 12px / radius-md / 항목 간 4px.
 * 헤더가 3열 그리드(auto 1fr auto)라 이 nav 는 가운데 열 전체(남는 공간)를 차지하고,
 * justify-content:center 로 그 안에서 메뉴 자체를 중앙 정렬합니다(2026-09-04 반영).
 */
.topnav {
  grid-column: 2;
  justify-content: center;
  align-items: center;
  gap: 4px;
  min-width: 0;
}
.topnav .nav-item {
  height: 36px;
  border: 0;
  background: transparent;
  padding: 6px 12px;
  border-radius: var(--asm-radius-md);
  color: var(--asm-nav-fg);
  font-size: 13px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  transition:
    background-color 0.15s,
    color 0.15s;
}
/* 비활성 hover — 배경 secondary(가이드 7-2) */
.topnav .nav-item:hover {
  background: var(--asm-secondary);
}
/* 활성 대분류는 accent-10 배경 + primary 글자 + 700 (가이드 7-2) */
.topnav .nav-item.active,
.topnav .nav-item.active:hover {
  background: var(--asm-primary-10);
  color: var(--asm-primary);
  font-weight: 700;
}

/*
 * 헤더 3열 그리드의 우측 열(auto) — grid-column 을 이름으로 고정해 두었기 때문에,
 * 모바일에서 가운데 열(.topnav)이 display:none 이 되어도 이 열이 가운데로 당겨지지
 * 않고 항상 3번째 칸(우측)에 남습니다.
 */
.top-actions {
  grid-column: 3;
  height: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 20px;
}
.notif-dot {
  position: absolute;
  width: 8px;
  height: 8px;
  background: var(--asm-danger);
  border-radius: 50%;
  top: 6px;
  right: 6px;
  border: 1px solid var(--asm-card);
}
.profile {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--asm-fg);
}
/* 가이드 7-2 사용자 아바타 — accent 10% 배경 + primary 글자 */
.profile .avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: var(--asm-primary-soft);
  color: var(--asm-primary-soft-fg);
  font-weight: 700;
  display: grid;
  place-items: center;
  flex: none;
}
.profile b {
  display: block;
  font-size: 13px;
}
.profile small {
  display: block;
  font-size: 11px;
  color: var(--asm-fg-muted);
}

@media (max-width: 991.98px) {
  .brand {
    padding: 0 12px;
    gap: 8px;
    min-width: 0;
    flex: 1;
  }
  .top-actions {
    padding: 0 16px;
    gap: 8px;
  }
}
</style>
