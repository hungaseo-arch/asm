/**
 * 아이콘은 plugins/icons.js 에서 전역 등록한 컴포넌트 '이름'으로 지정합니다
 * (Font Awesome 전환 후 값 import 가 필요 없어졌습니다).
 */

/**
 * 경로 접두사 일치 판정 (Path prefix match / Pencocokan awalan path)
 *
 * 세그먼트 경계까지 일치해야 합니다. 단순 startsWith 를 쓰면 '/csr' 이 '/csr-admin' 같은
 * 경로에도 걸립니다.
 */
export const matchPath = (path, prefix) => path === prefix || path.startsWith(`${prefix}/`)

/**
 * 메뉴 (Menu / Menu) — CSR(개선요청) 전용 사이트라 대분류 없이 하위메뉴를 그대로
 * 헤더 상단에 나열합니다(2026-10-09 요청 — 대분류가 하나뿐이라 드롭다운을 걷어냈습니다).
 */
export const navItems = [
  { label: 'Dashboard', labelId: 'Dasbor', icon: 'LayoutDashboard', to: '/csr/dashboard' },
  { label: '개선요청 목록', labelId: 'Daftar permintaan', icon: 'ClipboardList', to: '/csr' },
  { label: '상태 기준', labelId: 'Standar status', icon: 'Info', to: '/csr/status-guide' },
  {
    label: '업무 Flow Diagram',
    labelId: 'Diagram Alur Kerja',
    icon: 'Workflow',
    to: '/csr/flow',
  },
  { label: '관리 (admin)', labelId: 'Administrasi (admin)', icon: 'UserCog', to: '/csr/admin' },
]

/**
 * 메뉴 라벨 — 표시 언어 쪽(2026-09-14 「메뉴 버튼도 한국어/인니어 분리」).
 * 운영 메뉴는 영문 한 가지라 labelId 가 없고, 한국어가 들어간 항목에만 labelId 를 답니다.
 */
export const navLabel = (entry, lang) =>
  (lang === 'id' ? (entry?.labelId ?? entry?.label) : entry?.label) ?? ''

export const APP_VERSION = 'v1.0 · 01 Sep 2026'
