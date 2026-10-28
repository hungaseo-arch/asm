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
    path: '/csr/dashboard',
    name: 'csr-dashboard',
    component: () => import('./views/CsrDashboardPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 대시보드' },
  },
  {
    path: '/csr/admin',
    name: 'csr-admin',
    component: () => import('./views/CsrAdminPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 관리' },
  },
  {
    path: '/csr/status-guide',
    name: 'csr-status-guide',
    component: () => import('./views/CsrStatusGuidePage.vue'),
    meta: { requiresAuth: false, title: 'CSR 상태 기준' },
  },
  {
    path: '/csr/flow',
    name: 'csr-flow',
    component: () => import('./views/CsrFlowPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 업무 Flow Diagram' },
  },
  {
    // 핵심문서 — /csr/docs 는 목록, /csr/docs/DOC-01 같은 하위 페이지는 PDF 뷰어(2026-10-23 요청).
    path: '/csr/docs/:docNo?',
    name: 'csr-docs',
    component: () => import('./views/CsrCoreDocsPage.vue'),
    meta: { requiresAuth: false, title: '핵심문서', docSet: 'docs' },
  },
  {
    // 판매서류 표준양식 5종 — 핵심문서와 같은 화면을 docSet 만 바꿔 씁니다(2026-10-23 요청).
    path: '/csr/forms/:docNo?',
    name: 'csr-forms',
    component: () => import('./views/CsrCoreDocsPage.vue'),
    meta: { requiresAuth: false, title: '판매서류 표준양식', docSet: 'forms' },
  },
  {
    // 보고서 양식안(직원별) — 단독 HTML 을 iframe 으로 띄웁니다(2026-10-28 작업지시서 ASM-CSR-2026-1028-01).
    path: '/csr/reports',
    name: 'csr-reports',
    component: () => import('./views/CsrReportDesignPage.vue'),
    meta: { requiresAuth: false, title: '보고서 양식안' },
  },
  {
    // 공지 화면은 없앴습니다(2026-09-14). 남은 북마크가 이슈번호 'notices' 로 잡혀
    // 「없는 이슈」 화면을 띄우지 않도록 목록으로 돌려보냅니다.
    path: '/csr/notices',
    redirect: '/csr',
  },
  {
    // 이슈번호는 'VIII-6' · 'CSR-202609-001' 처럼 슬래시 없는 임의 문자열입니다.
    // 고정 경로(flow · admin · status-guide · docs · forms · reports)보다 뒤에 두어야 그 이름이 이슈번호로 잡히지 않습니다.
    path: '/csr/:issueNo',
    name: 'csr-detail',
    component: () => import('./views/CsrDetailPage.vue'),
    meta: { requiresAuth: false, title: 'CSR 상세' },
  },
]
