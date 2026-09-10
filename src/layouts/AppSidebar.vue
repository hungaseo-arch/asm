<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { findNavGroup, matchPath, navGroups, topNav } from '@/config/navigation'
import { useDrawerFocus } from '@/composables/useDrawerFocus'
const props = defineProps({ open: { type: Boolean, default: false } })
const emit = defineEmits(['close'])
const route = useRoute()
const router = useRouter()
const isActive = (item) => Boolean(item.to && matchPath(route.path, item.to))

const closeButton = ref(null)
useDrawerFocus(() => props.open, closeButton)

/**
 * 펼쳐 볼 대분류 (Browsed group / Grup yang dibuka)
 *
 * 기본값은 현재 화면이 속한 대분류입니다. 헤더의 상단 메뉴는 992px 미만에서 숨겨지므로
 * (AppTopbar.vue 의 d-none d-lg-flex) 그 구간에서는 드로어가 유일한 이동 수단인데,
 * 하위메뉴만 나열하면 지금 대분류 밖으로 나갈 방법이 없었습니다. 아래 대분류 줄에서
 * 고른 그룹의 하위메뉴를 보여주되, '고르기'만으로 화면을 옮기지는 않습니다 — 화면이
 * 바뀌면 드로어가 닫혀(DefaultLayout.vue) 하위메뉴를 볼 새가 없기 때문입니다.
 */
const browsedKey = ref(null)
const group = computed(
  () => navGroups.find((item) => item.key === browsedKey.value) ?? findNavGroup(route.path),
)
const items = computed(() => group.value?.items ?? [])
// 드로어를 새로 열거나 화면이 바뀌면 다시 '현재 대분류'에서 시작합니다.
watch([() => props.open, () => route.path], () => (browsedKey.value = null))

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
    class="drawer-scrim"
    aria-label="메뉴 닫기"
    @click="emit('close')"
  ></button>

  <aside class="sidebar" :class="{ 'is-open': open }">
    <!-- 닫기 — 드로어가 화면 우측에서 나오므로 좌상단에 둡니다. -->
    <button
      ref="closeButton"
      type="button"
      class="asm-icon-btn is-sm is-borderless sidebar-close"
      aria-label="메뉴 닫기"
      @click="emit('close')"
    >
      <X :size="18" />
    </button>

    <!--
      대분류(1단) — 헤더의 상단 메뉴가 보이지 않는 좁은 화면에서만 나옵니다. 데스크톱에서
      같이 내보내면 헤더와 같은 정보가 두 번 나옵니다.
    -->
    <nav class="group-nav d-lg-none" aria-label="대분류">
      <button
        v-for="item in topNav"
        :key="item.key"
        type="button"
        class="group-chip"
        :class="{ 'is-active': group?.key === item.key }"
        :aria-current="group?.key === item.key ? 'true' : undefined"
        @click="browsedKey = item.key"
      >
        {{ item.label }}
      </button>
    </nav>

    <!-- 고른 대분류의 하위메뉴(2단)만 평면으로 나열합니다. -->
    <nav class="nav-list" :aria-label="group?.nav.label">
      <!-- 그룹 라벨 — 가이드 7-3(BI 목차 킥커). 헤더의 활성 대분류와 짝을 이룹니다. -->
      <span v-if="group" class="group-label">{{ group.label }}</span>
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
  </aside>
</template>

<style scoped>
/*
 * 메뉴 드로어 — 화면 우측에서 슬라이드해 나옵니다. 폭·배경·활성 표시는 asm-theme.css
 * 의 .sidebar 규칙(가이드 7-3)을 그대로 쓰고, 여기서는 위치와 열림/닫힘만 다룹니다.
 * 열림 상태(transform·그림자)도 화면 폭과 무관하게 늘 적용되도록 테마 쪽에서 미디어
 * 쿼리를 걷어냈습니다.
 */
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
.sidebar-close {
  align-self: flex-start;
  margin-bottom: 8px;
}
/* 그룹 라벨이 첫 줄이라 상단 여백은 라벨 쪽(padding-top 16px)이 만듭니다. */
.nav-list {
  margin-top: 0;
}
.nav-list .group-label:first-child {
  padding-top: 4px;
}
/*
 * 대분류 줄 — 항목이 8개라 세로로 쌓으면 하위메뉴가 화면 밖으로 밀립니다. 칩으로 접어
 * 두 줄 안에 담고, 아래 하위메뉴와는 구분선으로 나눕니다.
 */
.group-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 0 4px 12px;
  border-bottom: 1px solid var(--asm-sidebar-border);
}
.group-chip {
  border: 1px solid var(--asm-border);
  background: transparent;
  color: var(--asm-nav-fg);
  border-radius: var(--asm-radius-sm);
  padding: 4px 8px;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.03em;
  text-transform: uppercase;
}
/* 활성 대분류는 헤더의 상단 메뉴와 같은 표시(가이드 7-2 — accent 10% + primary + 700) */
.group-chip.is-active {
  background: var(--asm-primary-10);
  border-color: var(--asm-primary-40);
  color: var(--asm-primary);
  font-weight: 700;
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
/*
 * 회사 표기(© PT ASCENDO INTERNASIONAL)·버전은 가이드 7-1 골격대로 본문 하단 푸터
 * (DefaultLayout.vue)로 옮겼습니다 — 사이드바 하단에 두면 인쇄물에 나가지 않고,
 * 좁은 화면에서는 메뉴 드로어를 열어야만 보였습니다.
 */
/* 가이드 8-5 — 오버레이 rgb(51 51 51 / .5) */
.drawer-scrim {
  position: fixed;
  inset: var(--asm-header-offset) 0 0;
  border: 0;
  padding: 0;
  background: var(--asm-scrim);
  z-index: 1015;
}
</style>
