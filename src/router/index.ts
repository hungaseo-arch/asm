import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { screenRoutes } from '@/config/screens'

/** 화면 시안에서 옮긴 목록 화면들 — 정의만 다르고 컴포넌트는 하나를 공유합니다. */
const listScreenRoutes: RouteRecordRaw[] = screenRoutes.map((screen) => ({
  path: screen.path,
  name: screen.slug,
  component: () => import('@/views/ListScreenPage.vue'),
  meta: { requiresAuth: false, title: screen.title, screen: screen.slug },
}))

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/vendor-po',
  },
  {
    // 작업지시서 §5 — 실서버 경로명(/vendor-po) 사용
    path: '/vendor-po',
    name: 'vendor-po',
    component: () => import('@/views/PurchasePoPage.vue'),
    // meta.requiresAuth 를 true 로 바꾸면 로그인 필수 화면이 됩니다.
    meta: { requiresAuth: false, title: 'Purchase PO' },
  },
  {
    // 이전 경로 호환 (그룹형 경로 → 실서버 경로)
    path: '/purchase-po',
    redirect: '/vendor-po',
  },
  {
    path: '/inventory-list',
    name: 'inventory-list',
    component: () => import('@/views/InventoryListPage.vue'),
    meta: { requiresAuth: false, title: 'Inventory List' },
  },
  ...listScreenRoutes,
  {
    // 로그인 기능 비활성 — 백엔드 없이 화면만 제공합니다.
    // 되살리려면 이 항목을 AuthPage 라우트로 되돌리고 아래 인증 가드를 복구하십시오.
    // (AuthPage.vue · stores/session.ts · lib/auth.ts 는 그대로 두었습니다)
    path: '/auth',
    redirect: '/',
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/views/NotFoundPage.vue'),
    meta: { title: '404' },
  },
]

export const router = createRouter({
  // BASE_URL = vite 의 base. 하위 경로 배포(GitHub Pages 등)에서도 경로가 맞습니다.
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior: () => ({ top: 0 }),
})

router.afterEach((to) => {
  const title = to.meta.title as string | undefined
  document.title = title ? `${title} · ASM` : 'ASM · Ascendo Management System'
})

export default router
