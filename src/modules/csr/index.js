/**
 * CSR 모듈 라우트 (작업지시서 §5-1)
 *
 * 화면은 전부 동적 import 입니다 — Neon 클라이언트(better-auth · jose · postgrest)가
 * 딸려 오므로 초기 청크에 들어가면 workOrder.md §6 의 500 KB 한도를 넘깁니다.
 *
 * 운영 화면과 컴포넌트·스토어를 공유하지 않습니다. 수명이 다르기 때문입니다 —
 * 운영 화면은 언젠가 실서버 코드베이스로 들어가지만 CSR 은 이 프로젝트와 함께 끝납니다.
 */
export const csrRoutes = [
  {
    path: '/csr',
    name: 'csr-list',
    component: () => import('./views/CsrListPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 개선요청' },
  },
  {
    path: '/csr/notices',
    name: 'csr-notices',
    component: () => import('./views/CsrNoticesPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 공지' },
  },
  {
    // 이슈번호는 'VIII-6' · 'CSR-202609-001' 처럼 슬래시 없는 임의 문자열입니다.
    // /csr/notices 보다 뒤에 두어야 'notices' 가 이슈번호로 잡히지 않습니다.
    path: '/csr/:issueNo',
    name: 'csr-detail',
    component: () => import('./views/CsrDetailPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 상세' },
  },
]
