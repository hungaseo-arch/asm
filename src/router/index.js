import { createRouter, createWebHistory } from 'vue-router'
import { csrRoutes } from '@/modules/csr'
const routes = [
  {
    path: '/',
    redirect: '/csr',
  },
  // CSR 모듈 (작업지시서 §5-1) — 운영 화면과 분리된 독립 모듈입니다.
  ...csrRoutes,
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
// 탭은 폭이 좁아 앞부분만 보입니다 — 화면 이름보다 서비스명(ASM)을 앞에 둡니다.
router.afterEach((to) => {
  const title = to.meta.title
  document.title = title ? `ASM · ${title}` : 'ASM · Ascendo Management System'
})
export default router
