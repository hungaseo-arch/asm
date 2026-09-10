<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { APP_USER, findNavItem, matchPath, topNav } from '@/config/navigation'
import { useSidebarSummary } from '@/composables/useSummaryCards'
const emit = defineEmits(['open-sidebar', 'open-summary'])
/** 요약 드로어는 이번 화면이 요약 카드를 등록했을 때만 열 수 있습니다. */
const { cards } = useSidebarSummary()
const route = useRoute()
const router = useRouter()

/*
 * 브랜드 메뉴 (Brand menu / Menu merek)
 *
 * 요약·알림을 헤더에 아이콘으로 늘어놓지 않고 로고 클릭 한 곳으로 모읍니다 —
 * 헤더 좌측이 시그니처 하나로 정리되고(가이드 7-2 "좌측 : 시그니처 로고"), 4-2 가
 * 금지하는 "로고 영역에 겹치는 아이콘·배지"도 자연히 사라집니다.
 * 앱의 다른 오버레이와 같은 방식으로 Vue 상태로만 제어합니다(Bootstrap JS 미사용).
 */
const brandMenuOpen = ref(false)
const brandMenu = ref(null)
/** 알림 미확인 여부 — 백엔드가 없어 표시 전용입니다(예전 벨 아이콘의 빨간 점과 동일). */
const hasUnread = ref(true)
function onPointerdown(event) {
  if (!brandMenuOpen.value) return
  if (brandMenu.value?.contains(event.target)) return
  brandMenuOpen.value = false
}
function onKeydown(event) {
  if (event.key === 'Escape') brandMenuOpen.value = false
}
onMounted(() => {
  document.addEventListener('pointerdown', onPointerdown)
  document.addEventListener('keydown', onKeydown)
})
onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', onPointerdown)
  document.removeEventListener('keydown', onKeydown)
})
// 화면을 옮기면 열려 있던 메뉴는 닫습니다.
watch(
  () => route.path,
  () => (brandMenuOpen.value = false),
)
function openSummary() {
  brandMenuOpen.value = false
  emit('open-summary')
}
function openNotifications() {
  brandMenuOpen.value = false
  // 한 번 열어 본 뒤에도 빨간 점이 남아 있으면 '읽지 않음'이라는 표시가 뜻을 잃습니다.
  hasUnread.value = false
  toast.info('알림 화면은 프론트엔드 범위에 포함되지 않습니다')
}
const isActive = (item) => {
  const prefixes = item.match ?? (item.to ? [item.to] : [])
  return prefixes.some((prefix) => matchPath(route.path, prefix))
}
/** 가이드 7-2 좌측 — 로고 뒤 세로 구분선에 이어 붙는 화면 제목(현재 하위메뉴 이름). */
const pageTitle = computed(() => findNavItem(route.path)?.label ?? '')
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
      <!--
        시그니처 로고가 곧 브랜드 메뉴 버튼입니다 — 요약·알림은 여기서 열립니다.
        가이드 4-1 — 시그니처(가로형)는 높이 28px. 640px 미만에서는 워드마크를 숨기고
        심볼 단독형으로 교체합니다(최소 크기 80px 미만에서는 심볼만 쓴다는 4-2 규정).
        BS 07 비율 왜곡 금지 — height 만 지정하고 width 는 auto 로 둡니다.
        로고에는 테두리·그림자·배지를 얹지 않습니다(BS 07 · 4-2) — 미확인 알림 표시는
        메뉴 안 항목에 둡니다.
      -->
      <div ref="brandMenu" class="brand-menu">
        <button
          type="button"
          class="brand-trigger"
          aria-haspopup="menu"
          :aria-expanded="brandMenuOpen"
          aria-label="브랜드 메뉴 (요약 · 알림)"
          @click="brandMenuOpen = !brandMenuOpen"
        >
          <img src="/img/ascendo-logo-horizontal.png" alt="ASCENDO" class="brand-logo" />
          <img src="/img/ascendo-symbol.png" alt="ASCENDO" class="brand-symbol" />
        </button>

        <!-- 드롭다운 규격 — 가이드 7-2: White 배경 · 1px 테두리 · radius-md · shadow-md -->
        <div v-if="brandMenuOpen" class="dropdown-menu show" role="menu">
          <button
            v-if="cards.length"
            type="button"
            class="dropdown-item"
            role="menuitem"
            @click="openSummary"
          >
            <LayoutDashboard :size="15" />
            요약 (Summary)
          </button>
          <button type="button" class="dropdown-item" role="menuitem" @click="openNotifications">
            <Bell :size="15" />
            알림 (Notifications)
            <i v-if="hasUnread" class="unread-dot" aria-label="미확인 알림 있음"></i>
          </button>
        </div>
      </div>

      <!-- 가이드 7-2 좌측 — 세로 구분선(1×24px) 뒤 화면 제목 14px / 500 -->
      <span v-if="pageTitle" class="page-title d-none d-md-block">{{ pageTitle }}</span>
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

    <!-- 우측 액션 — 알림은 로고(브랜드 메뉴) 안으로 옮겼습니다. -->
    <div class="top-actions">
      <!--
        가이드 7-2 우측 배치 순서 — 역할 pill(28px · Blue 10% 배경 · Blue 12px/700) →
        사용자 아바타(28px 원형) → 이름. 역할을 흐린 보조 텍스트로 두던 것을 8-4 의
        pill 규격으로 올렸습니다. 같은 절이 규정하는 상태 버튼·로그아웃 아이콘은 이
        프론트엔드에 백엔드 세션이 없어(로그인 비활성, router/index.js) 두지 않습니다.
        로그인 기능 비활성 — 표시 전용 사용자 (config/navigation.js APP_USER)

        역할 pill 은 1,400px 이상에서만 내보냅니다(xxl) — 대분류가 8개라 그 아래에서는
        pill 폭(약 140px)만큼 가운데 열이 모자라 상단 메뉴가 잘렸습니다. 역할은 화면
        이동에 쓰이지 않는 보조 정보라 좁은 화면에서 먼저 접습니다.
      -->
      <span class="asm-pill d-none d-xxl-inline-flex">{{ APP_USER.role }}</span>
      <div class="profile">
        <span class="avatar">{{ APP_USER.initials }}</span>
        <b class="d-none d-md-block">{{ APP_USER.name }}</b>
      </div>

      <!-- 메뉴 드로어 토글 — 드로어가 오른쪽에서 나오므로 버튼도 헤더 맨 오른쪽입니다. -->
      <button
        type="button"
        class="asm-icon-btn"
        aria-label="메뉴 열기"
        title="메뉴 (Menu)"
        @click="$emit('open-sidebar')"
      >
        <Menu :size="18" />
      </button>
    </div>
  </header>
</template>

<style scoped>
/*
 * 가이드 7-2 좌측 — 로고 → 세로 구분선 → 화면 제목. 좌우 패딩 20px.
 * 메뉴(사이드바)가 화면 우측으로 옮겨간 뒤로 활성 항목이 시선에서 멀어져, 지금 보고
 * 있는 화면 이름이 어디에도 보이지 않았습니다. 가이드 규정대로 헤더 좌측에 되돌립니다.
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
/* 심볼 단독형 — 가이드 4-1a/4-2: 640px 미만에서만 표시(아래 미디어 쿼리에서 교체) */
.brand-symbol {
  height: 28px;
  width: auto;
  flex: none;
  display: none;
}

/* 드롭다운을 로고 바로 아래에 띄우기 위한 기준 컨테이너 */
.brand-menu {
  position: relative;
  flex: none;
  display: flex;
  align-items: center;
}
/*
 * 로고 버튼 — 로고에 테두리·그림자를 더하지 않습니다(BS 07). 클릭 가능하다는 신호는
 * 커서와 hover 배경(가이드 7-2 의 헤더 요소 hover = secondary)으로만 줍니다.
 * 로고 사방에는 4-2 최소 공간규정(0.05a ≈ 7px)만큼 패딩을 둬, hover 배경이 로고에
 * 붙어 보이지 않게 합니다.
 */
.brand-trigger {
  display: flex;
  align-items: center;
  border: 0;
  background: transparent;
  padding: 6px 8px;
  margin-left: -8px; /* 패딩만큼 되돌려 로고 왼쪽 끝은 헤더 여백 20px 에 맞춥니다 */
  border-radius: var(--asm-radius-md);
  cursor: pointer;
  transition: background-color 0.15s;
}
.brand-trigger:hover,
.brand-trigger[aria-expanded='true'] {
  background: var(--asm-secondary);
}
.brand-trigger:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}

/* 드롭다운 위치 — 헤더 아래 6px. 색·테두리·그림자는 전역 .dropdown-menu(가이드 7-2). */
.brand-menu .dropdown-menu {
  display: block;
  position: absolute;
  top: calc(100% + 6px);
  left: 0;
  margin: 0;
}
.brand-menu .dropdown-item {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  border: 0;
  background: transparent;
  text-align: left;
  white-space: nowrap;
}
/* 미확인 알림 — 로고가 아니라 메뉴 항목에 붙입니다(가이드 4-2 "알림 배지는 로고 밖"). */
.unread-dot {
  width: 8px;
  height: 8px;
  margin-left: auto;
  background: var(--asm-danger);
  border-radius: 50%;
  flex: none;
}

/*
 * 화면 제목 — 가이드 7-2: 14px / 500, 앞에 세로 구분선(1×24px).
 * 구분선은 border-left 로 그려 로고 영역(BS 02 최소 공간규정)을 침범하지 않도록
 * 12px 씩 띄웁니다.
 */
.page-title {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--asm-fg);
  border-left: 1px solid var(--asm-border);
  padding-left: 12px;
  margin-left: 2px;
  line-height: 24px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/*
 * 가이드 7-2 — 14px / weight 500 / 패딩 6px 12px / radius-md / 항목 간 4px.
 * 헤더가 3열 그리드(auto 1fr auto)라 이 nav 는 가운데 열 전체(남는 공간)를 차지하고,
 * justify-content:center 로 그 안에서 메뉴 자체를 중앙 정렬합니다(2026-09-04 반영).
 */
.topnav {
  grid-column: 2;
  justify-content: center;
  /*
   * safe center — 항목이 넘칠 때는 중앙 정렬을 포기하고 시작(왼쪽)에 붙입니다.
   * 그냥 center 로 두면 넘친 만큼이 양쪽으로 밀려나, 왼쪽으로 밀린 첫 대분류는
   * 스크롤로도 되돌릴 수 없어 잘린 채 남습니다(1,280px 에서 'PURCHASING' 이 잘리던
   * 증상). 미지원 브라우저는 바로 위 center 로 떨어집니다.
   */
  justify-content: safe center;
  align-items: center;
  gap: 4px;
  min-width: 0;
  /*
   * 대분류가 8개라 좁은 화면(1,366px 이하)에서는 "MASTER DATA"·"MOCK-UP" 같은 두 단어
   * 항목이 두 줄로 접혀 헤더 56px 규격(가이드 7-2)을 깨뜨렸습니다. 접히는 대신 가로로
   * 흐르게 두고, 넘칠 때만 스크롤합니다.
   */
  overflow-x: auto;
  scrollbar-width: none;
}
.topnav::-webkit-scrollbar {
  display: none;
}
.topnav .nav-item {
  height: 36px;
  flex: none;
  white-space: nowrap;
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
  font-size: 13px;
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
/*
 * 가이드 7-5 모바일(< 640px) — 워드마크를 숨기고 심볼 단독형으로 교체합니다.
 * 가로형 시그니처는 폭 140px 안팎이라 이 구간에서 4-2 의 최소 크기(80px)와 여백을
 * 동시에 지키기 어렵습니다.
 */
@media (max-width: 639.98px) {
  .brand-logo {
    display: none;
  }
  .brand-symbol {
    display: block;
  }
}
</style>
