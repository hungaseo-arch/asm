import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useSessionStore } from '@/stores/session'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/purchase-po',
  },
  {
    path: '/purchase-po',
    name: 'purchase-po',
    component: () => import('@/pages/PurchasePoPage.vue'),
    // meta.requiresAuth 를 true 로 바꾸면 로그인 필수 화면이 됩니다.
    meta: { requiresAuth: false, title: 'Purchase PO' },
  },
  {
    // 이전 React 클라이언트의 경로 호환
    path: '/vendor-po',
    redirect: '/purchase-po',
  },
  {
    path: '/inventory-list',
    name: 'inventory-list',
    component: () => import('@/pages/InventoryListPage.vue'),
    meta: { requiresAuth: false, title: 'Inventory List' },
  },
  {
    path: '/auth',
    name: 'auth',
    component: () => import('@/pages/AuthPage.vue'),
    meta: { guestOnly: true, title: '로그인' },
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/pages/NotFoundPage.vue'),
    meta: { title: '404' },
  },
]

export const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 }),
})

router.beforeEach(async (to) => {
  const session = useSessionStore()

  if (to.meta.requiresAuth || to.meta.guestOnly) {
    // 세션 확정 전에 판정하면 로그인 직후 화면이 되돌아갑니다.
    await session.ensureResolved()
  }

  if (to.meta.requiresAuth && !session.isAuthenticated) {
    return { name: 'auth', query: { redirect: to.fullPath }, replace: true }
  }

  // 이미 로그인 + 이메일 인증까지 끝난 사용자는 로그인 화면에 머물지 않습니다.
  if (to.meta.guestOnly && session.isAuthenticated && session.isEmailVerified) {
    return { path: '/', replace: true }
  }

  return true
})

router.afterEach((to) => {
  const title = to.meta.title as string | undefined
  document.title = title ? `${title} · ASM` : 'ASM · Ascendo Management System'
})

export default router
