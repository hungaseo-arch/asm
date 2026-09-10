<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { matchPath, navGroups, topNav } from '@/config/navigation'
import { useSidebarSummary } from '@/composables/useSummaryCards'
import { useIdentityStore } from '@/stores/identity'
import { hasUnreadNotices } from '@/modules/csr/notices'
const emit = defineEmits(['open-sidebar', 'open-summary'])
/** 요약 드로어는 이번 화면이 요약 카드를 등록했을 때만 열 수 있습니다. */
const { cards } = useSidebarSummary()
const route = useRoute()
const router = useRouter()
/**
 * 헤더에 보일 사람 — CSR 세션이 있으면 그 계정, 없으면 표시 전용 자리표시자.
 * Neon 클라이언트를 여기서 직접 부르지 않습니다(초기 청크 500 KB 한도) — 세션 스토어가
 * stores/identity.js 에 이름·소속만 올려 두고 헤더는 그것만 읽습니다.
 */
const identity = useIdentityStore()
const who = computed(() => identity.display)
/** 계정 메뉴 문구 — CSR 국기 토글과 같은 언어 하나만(2026-09-10 「한국어·인니어 혼용」). */
const t = (ko, id) => (identity.lang === 'id' ? id : ko)
/** 로그아웃 상태의 계정 버튼은 로그인 화면(/csr)으로 가는 문입니다. */
function onAccountClick() {
  if (who.value.placeholder) router.push('/csr/dashboard')
  else accountOpen.value = !accountOpen.value
}
/** 종의 빨간 점 — CSR 화면이 localStorage 에 남긴 비트만 읽습니다(Neon 을 직접 묻지 않음). */
const unread = computed(() => {
  void route.path // 화면이 바뀔 때마다 다시 읽습니다
  return hasUnreadNotices()
})

const isActive = (item) => {
  const prefixes = item.match ?? (item.to ? [item.to] : [])
  return prefixes.some((prefix) => matchPath(route.path, prefix))
}

/*
 * 대분류 드롭다운 (Top-nav dropdown / Menu tarik-turun)
 *
 * 2026-09-10 요청 순서: 대분류 클릭 → 우측 드로어(하위메뉴) → **드롭다운**으로 교체.
 * 드로어는 본문을 가리고 두 번 움직여야 했습니다(열기 → 고르기). 드롭다운은 대분류 바로
 * 아래에 하위메뉴가 펼쳐져 한 번에 고릅니다. 우측 드로어(AppSidebar)는 992px 미만에서
 * 대분류가 숨겨질 때 ☰ 로만 씁니다.
 *
 * 열림은 클릭 토글, 하나가 열려 있으면 다른 대분류에 올리기만 해도 옮겨 갑니다(메뉴바
 * 관례). 바깥 클릭·Esc·화면 이동에 닫힙니다 — 계정 메뉴와 같은 리스너를 씁니다.
 */
const navOpen = ref(null) // 열린 대분류 key
const navRef = ref(null)
/*
 * 드롭다운은 position:fixed — .topnav 가 overflow-x:auto(좁은 폭 스크롤용)라 absolute 로 두면
 * 잘려 보이지 않습니다(2026-09-10 실측). 헤더가 sticky 라 버튼 자리는 스크롤해도 그대로이므로
 * 열 때 버튼 위치를 한 번 재면 됩니다.
 */
const navPos = ref({ left: 0, top: 0 })
function place(button) {
  const r = button.getBoundingClientRect()
  navPos.value = { left: r.left, top: r.bottom + 6 }
}
const groupItems = (key) => navGroups.find((g) => g.key === key)?.items ?? []
function toggleGroup(item, event) {
  place(event.currentTarget)
  navOpen.value = navOpen.value === item.key ? null : item.key
}
function hoverGroup(item, event) {
  if (!navOpen.value || navOpen.value === item.key) return
  place(event.currentTarget.querySelector('.nav-item'))
  navOpen.value = item.key
}
function goItem(sub) {
  navOpen.value = null
  router.push(sub.to)
}
const isItemActive = (sub) => matchPath(route.path, sub.to)

/*
 * 계정 메뉴 (Account menu / Menu akun) — 아바타를 누르면 열립니다(2026-09-10 요청).
 * 역할·비밀번호 변경·로그아웃을 목록 툴바에서 이곳으로 옮겼습니다. Vue 상태로만 제어하고
 * (Bootstrap JS 미사용), 바깥 클릭·Esc·화면 이동 시 닫습니다.
 * 로그아웃은 identity.actions 를 통해 CSR 세션 스토어에 위임합니다 — 헤더가 Neon 을
 * import 하지 않기 위해서입니다.
 */
const accountOpen = ref(false)
const accountMenu = ref(null)
function onPointerdown(event) {
  if (accountOpen.value && !accountMenu.value?.contains(event.target)) accountOpen.value = false
  if (navOpen.value && !navRef.value?.contains(event.target)) navOpen.value = null
}
function onKeydown(event) {
  if (event.key === 'Escape') {
    accountOpen.value = false
    navOpen.value = null
  }
}
onMounted(() => {
  document.addEventListener('pointerdown', onPointerdown)
  document.addEventListener('keydown', onKeydown)
})
onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', onPointerdown)
  document.removeEventListener('keydown', onKeydown)
})
watch(
  () => route.path,
  () => {
    accountOpen.value = false
    navOpen.value = null
  },
)
function changePassword() {
  accountOpen.value = false
  identity.requestPasswordChange()
  // 다이얼로그는 CSR 화면 안에 있습니다 — 다른 화면이면 CSR 로 옮긴 뒤 열립니다.
  if (!route.path.startsWith('/csr')) router.push('/csr')
}
async function signOut() {
  accountOpen.value = false
  await identity.actions.signOut?.()
  if (route.path.startsWith('/csr')) router.replace('/csr')
}
</script>

<template>
  <header class="menu-header">
    <!-- 브랜드 (Brand) -->
    <div class="brand">
      <!--
        로고 클릭 = CSR 대시보드로 직행(2026-09-10 요청 — 처음엔 목록이었다가 대시보드로 변경). 요약·알림은 우측 액션으로
        옮겼습니다 — 로고 영역에 아이콘·배지를 겹치지 않는다는 가이드 4-2 는 그대로 지킵니다.
        가이드 4-1 — 시그니처(가로형)는 높이 28px. 640px 미만에서는 워드마크를 숨기고
        심볼 단독형으로 교체합니다. BS 07 비율 왜곡 금지 — height 만 지정, width 는 auto.
      -->
      <button
        type="button"
        class="brand-trigger"
        aria-label="CSR 대시보드로"
        title="CSR 대시보드 (Dasbor)"
        @click="router.push('/csr/dashboard')"
      >
        <img src="/img/ascendo-logo-horizontal.png" alt="ASCENDO" class="brand-logo" />
        <img src="/img/ascendo-symbol.png" alt="ASCENDO" class="brand-symbol" />
      </button>

      <!-- 화면 제목은 본문 상단으로 옮겼습니다(DefaultLayout, 2026-09-10 요청) — 헤더는 로고·대분류·계정만. -->
    </div>

    <!-- 상단 메뉴 — 대분류. 클릭하면 바로 아래에 하위메뉴 드롭다운이 펼쳐집니다. -->
    <nav ref="navRef" class="topnav d-none d-lg-flex" aria-label="Primary">
      <div
        v-for="item in topNav"
        :key="item.key"
        class="nav-group"
        @mouseenter="hoverGroup(item, $event)"
      >
        <button
          type="button"
          class="nav-item"
          :class="{ active: isActive(item), open: navOpen === item.key }"
          aria-haspopup="menu"
          :aria-expanded="navOpen === item.key"
          @click="toggleGroup(item, $event)"
        >
          {{ item.label }}
        </button>
        <!-- 드롭다운 규격 — 계정 메뉴와 같음(가이드 7-2: White · 1px 테두리 · radius-md · shadow-md) -->
        <div
          v-if="navOpen === item.key"
          class="dropdown-menu nav-dropdown show"
          role="menu"
          :style="{ left: navPos.left + 'px', top: navPos.top + 'px' }"
        >
          <button
            v-for="sub in groupItems(item.key)"
            :key="sub.label"
            type="button"
            class="dropdown-item"
            :class="{ 'is-active': isItemActive(sub) }"
            role="menuitem"
            @click="goItem(sub)"
          >
            <span class="flex-grow-1">{{ sub.label }}</span>
            <em v-if="sub.badge">{{ sub.badge }}</em>
          </button>
        </div>
      </div>
    </nav>

    <!-- 우측 액션 -->
    <div class="top-actions">
      <!-- 요약 — 이번 화면이 카드를 등록했을 때만. 좌측 요약 드로어를 엽니다. -->
      <button
        v-if="cards.length"
        type="button"
        class="asm-icon-btn is-borderless"
        aria-label="요약 열기"
        title="요약 (Summary)"
        @click="$emit('open-summary')"
      >
        <LayoutDashboard :size="18" />
      </button>
      <!-- 알림 — CSR 공지 화면. 관리자가 쓰고 전원이 봅니다. -->
      <button
        type="button"
        class="asm-icon-btn is-borderless"
        aria-label="알림"
        title="알림 (Notifications)"
        @click="router.push('/csr/notices')"
      >
        <Bell :size="18" />
        <i v-if="unread" class="unread-dot" aria-label="새 공지 있음"></i>
      </button>

      <!--
        가이드 7-2 우측 배치 — 역할 pill → 아바타 → 이름. CSR 로그인이 있으면 그 계정의
        이름·소속을, 없으면 자리표시자를 보여 줍니다(identity.display.placeholder).
        역할 pill 은 1,400px 이상에서만(xxl) — 대분류 8개와 자리를 다투기 때문입니다.
      -->
      <span
        v-if="who.role"
        class="asm-pill d-none d-xxl-inline-flex"
        :class="{ 'is-placeholder': who.placeholder }"
      >
        {{ who.role }}
      </span>
      <div ref="accountMenu" class="account">
        <button
          type="button"
          class="profile"
          :class="{ 'is-placeholder': who.placeholder }"
          :title="who.email ?? ''"
          :aria-haspopup="who.placeholder ? undefined : 'menu'"
          :aria-expanded="accountOpen"
          @click="onAccountClick"
        >
          <span class="avatar">{{ who.initials }}</span>
          <b class="d-none d-md-block">{{ who.name }}</b>
        </button>

        <!-- 드롭다운 규격 — 가이드 7-2: White 배경 · 1px 테두리 · radius-md · shadow-md -->
        <div v-if="accountOpen" class="dropdown-menu dropdown-menu-end show" role="menu">
          <div class="account-head">
            <b>{{ who.name }}</b>
            <small>{{ who.email }}</small>
            <span v-if="who.role" class="asm-pill">{{ who.role }}</span>
          </div>
          <button type="button" class="dropdown-item" role="menuitem" @click="changePassword">
            {{ t('비밀번호 변경', 'Ubah kata sandi') }}
          </button>
          <button type="button" class="dropdown-item" role="menuitem" @click="signOut">
            {{ t('로그아웃', 'Keluar') }}
          </button>
        </div>
      </div>

      <!--
        메뉴 드로어 토글 — 992px 이상에서는 대분류 드롭다운이 있어 없앴습니다.
        992px 미만에서는 상단 대분류가 숨겨져 이 버튼이 유일한 진입로라 남깁니다.
      -->
      <button
        type="button"
        class="asm-icon-btn d-lg-none"
        aria-label="메뉴 열기"
        title="메뉴 (Menu)"
        @click="$emit('open-sidebar', null)"
      >
        <Menu :size="18" />
      </button>
    </div>
  </header>
</template>

<style scoped>
/*
 * 가이드 7-2 좌측 — 로고 → 세로 구분선 → 화면 제목. 좌우 패딩 20px.
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
 * 표시합니다(BS 07 — 형태·비율·색 변형 금지).
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
/*
 * 로고 버튼 — 로고에 테두리·그림자를 더하지 않습니다(BS 07). 클릭 가능하다는 신호는
 * 커서와 hover 배경(가이드 7-2 의 헤더 요소 hover = secondary)으로만 줍니다.
 * 로고 사방에는 4-2 최소 공간규정(0.05a ≈ 7px)만큼 패딩을 둬, hover 배경이 로고에
 * 붙어 보이지 않게 합니다.
 */
.brand-trigger {
  display: flex;
  align-items: center;
  flex: none;
  border: 0;
  background: transparent;
  padding: 6px 8px;
  margin-left: -8px; /* 패딩만큼 되돌려 로고 왼쪽 끝은 헤더 여백 20px 에 맞춥니다 */
  border-radius: var(--asm-radius-md);
  cursor: pointer;
  transition: background-color 0.15s;
}
.brand-trigger:hover {
  background: var(--asm-secondary);
}
.brand-trigger:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}

/*
 * 화면 제목 — 가이드 7-2: 14px / 500, 앞에 세로 구분선(1×24px).
 * 구분선은 border-left 로 그려 로고 영역(BS 02 최소 공간규정)을 침범하지 않도록
 * 12px 씩 띄웁니다.
 */

/*
 * 가이드 7-2 — 14px / weight 500 / 패딩 6px 12px / radius-md / 항목 간 4px.
 * 헤더가 3열 그리드(auto 1fr auto)라 이 nav 는 가운데 열 전체(남는 공간)를 차지하고,
 * justify-content:center 로 그 안에서 메뉴 자체를 중앙 정렬합니다.
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
  /* 대분류 8개가 두 줄로 접혀 헤더 56px 을 깨뜨리지 않도록 가로로 흐르게 둡니다. */
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
.topnav .nav-item:hover,
.topnav .nav-item.open {
  background: var(--asm-secondary);
}
.nav-group {
  position: relative;
  flex: none;
}
/*
 * 대분류 드롭다운 — 대분류 바로 아래, 왼쪽 정렬(위치는 스크립트가 fixed 좌표로 넣습니다).
 * 항목은 드로어의 .sub-item 과 같은 13px · hover secondary · 활성 primary-10.
 */
.nav-dropdown {
  display: block;
  position: fixed;
  margin: 0;
  z-index: 1050;
  min-width: 240px;
  padding: 6px;
}
.nav-dropdown .dropdown-item {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  border: 0;
  background: transparent;
  text-align: left;
  padding: 8px 10px;
  border-radius: var(--asm-radius-sm);
  font-size: 13px;
  color: var(--asm-fg);
  white-space: nowrap;
}
.nav-dropdown .dropdown-item:hover {
  background: var(--asm-secondary);
}
.nav-dropdown .dropdown-item.is-active {
  background: var(--asm-primary-10);
  color: var(--asm-primary);
  font-weight: 700;
}
.nav-dropdown .dropdown-item em {
  font-style: normal;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.06em;
  color: var(--asm-primary);
  background: var(--asm-primary-10);
  padding: 1px 5px;
  border-radius: var(--asm-radius-sm);
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
  gap: 8px;
  padding: 0 20px;
}
/* 미확인 공지 — 종 아이콘 모서리의 8px 점(가이드 4-2: 배지는 로고 밖). */
.top-actions .asm-icon-btn {
  position: relative;
}
.unread-dot {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 8px;
  height: 8px;
  background: var(--asm-danger);
  border-radius: 50%;
}
.account {
  position: relative;
  margin-left: 4px;
}
/* 아바타 버튼 — 테두리 없이 hover 배경만 (가이드 7-2 헤더 요소 hover = secondary) */
.profile {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--asm-fg);
  border: 0;
  background: transparent;
  padding: 4px 8px 4px 4px;
  border-radius: var(--asm-radius-md);
  cursor: pointer;
}
.profile:not(:disabled):hover,
.profile[aria-expanded='true'] {
  background: var(--asm-secondary);
}
.profile:disabled {
  cursor: default;
}
.profile:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
.account .dropdown-menu {
  display: block;
  position: absolute;
  top: calc(100% + 6px);
  right: 0;
  left: auto;
  margin: 0;
  min-width: 240px;
}
.account .dropdown-item {
  display: block;
  width: 100%;
  border: 0;
  background: transparent;
  text-align: left;
  white-space: nowrap;
}
.account-head {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 6px 12px 10px;
  border-bottom: 1px solid var(--asm-border);
  margin-bottom: 6px;
}
.account-head b {
  font-size: 13px;
}
.account-head small {
  font-size: 11px;
  color: var(--asm-fg-muted);
  overflow-wrap: anywhere;
}
.account-head .asm-pill {
  align-self: flex-start;
  margin-top: 4px;
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
  font-size: 12px;
}
.profile b {
  font-size: 13px;
  white-space: nowrap;
}
/* 자리표시자(로그인 없음)는 흐리게 — 실제 사람으로 오해하지 않도록. */
.profile.is-placeholder,
.asm-pill.is-placeholder {
  opacity: 0.55;
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
    gap: 6px;
  }
}
/*
 * 가이드 7-5 모바일(< 640px) — 워드마크를 숨기고 심볼 단독형으로 교체합니다.
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
