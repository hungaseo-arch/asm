/**
 * 아이콘은 plugins/icons.js 에서 전역 등록한 컴포넌트 '이름'으로 지정합니다
 * (Font Awesome 전환 후 값 import 가 필요 없어졌습니다).
 */

/**
 * 경로 접두사 일치 판정 (Path prefix match / Pencocokan awalan path)
 *
 * 세그먼트 경계까지 일치해야 합니다. 단순 startsWith 를 쓰면 '/vendor' 가 '/vendor-po' 에도
 * 걸려 Purchasing 과 Partners 가 동시에 활성으로 표시됩니다 (가이드 6-2 · 활성 대분류 인지).
 */
export const matchPath = (path, prefix) => path === prefix || path.startsWith(`${prefix}/`)

/**
 * 메뉴 (Menu / Menu)
 *
 * 대분류 1개 = 사이드바 목록 1개로 1:1 대응합니다. 상단 헤더가 대분류(1단)를 보여주므로
 * 사이드바는 '현재 대분류의 하위메뉴(2단)'만 평면으로 나열합니다 — 사이드바에 그룹 헤더를
 * 두면 헤더의 대분류와 같은 정보가 두 번 나옵니다.
 *
 * 각 그룹의 `nav` 가 곧 헤더 항목이고, `nav.match` 는 활성 판정용 경로 접두사입니다.
 * 한 경로는 반드시 한 그룹에만 속해야 합니다 — 두 그룹의 match 에 겹쳐 넣으면 헤더의
 * 대분류 두 개가 동시에 켜집니다.
 *
 * 메뉴 구성·명칭은 개선의견서(ASM 실서버 테스트 결과)의 목차를 따릅니다.
 * 운영 하위메뉴는 25종 — Purchasing 9 · Sales 6 · Inventory 2 · Partners 2 ·
 * Master Data 4 · Settings 2 (문서 정합성 리포트 A-5). Payment Plan 은 신설 요청 화면이라
 * 25종에 포함하지 않고 NEW 배지로 구분합니다.
 * 라우트가 아직 없는 항목(Delivery Note (Warehouse) 등)은 안내 토스트만 표시합니다.
 */
export const navGroups = [
  {
    /*
     * CSR(개선요청) — 2026-09-14 요청으로 첫 번째 대분류. 운영 ASM 메뉴가 아니라 이 목업 사이트의 주 기능이라
     * 맨 앞에 둡니다. 경로 /csr 이하 전부가 이 그룹입니다(상세 /csr/:issueNo 포함).
     */
    key: 'csr',
    label: 'CSR (개선요청)',
    labelId: 'CSR (Permintaan Perbaikan)',
    nav: {
      label: 'CSR (개선요청)',
      labelId: 'CSR (Permintaan Perbaikan)',
      to: '/csr/dashboard',
      match: ['/csr'],
    },
    items: [
      { label: 'Dashboard', labelId: 'Dasbor', icon: 'LayoutDashboard', to: '/csr/dashboard' },
      { label: '개선요청 목록', labelId: 'Daftar permintaan', icon: 'ClipboardList', to: '/csr' },
      { label: '공지', labelId: 'Pengumuman', icon: 'Bell', to: '/csr/notices' },
      { label: '상태 기준', labelId: 'Standar status', icon: 'Info', to: '/csr/status-guide' },
      {
        label: '업무 Flow Diagram',
        labelId: 'Diagram Alur Kerja',
        icon: 'Workflow',
        to: '/csr/flow',
      },
      { label: '관리 (admin)', labelId: 'Administrasi (admin)', icon: 'UserCog', to: '/csr/admin' },
    ],
  },
  {
    key: 'purchasing',
    label: 'I. PURCHASING',
    nav: {
      label: 'Purchasing',
      to: '/vendor-po',
      match: [
        '/vendor-po',
        '/purchase-order',
        '/ppc',
        '/payment-plan',
        '/shipment',
        '/customs',
        '/receipts',
        '/receipts-wh',
        '/import-cost',
        '/vendor-return',
        '/credit-note',
      ],
    },
    items: [
      { label: 'Purchase PO', icon: 'ShoppingCart', to: '/vendor-po' },
      { label: 'PPC (Production Plan)', icon: 'Factory', to: '/ppc' },
      { label: 'Payment Plan', icon: 'CircleDollarSign', to: '/payment-plan', badge: 'NEW' },
      { label: 'Shipment', icon: 'Ship', to: '/shipment' },
      { label: 'Customs', icon: 'ClipboardCheck', to: '/customs' },
      { label: 'Receipt', icon: 'PackageCheck', to: '/receipts' },
      { label: 'Receipt (Warehouse)', icon: 'Warehouse', to: '/receipts-wh' },
      { label: 'Import Cost', icon: 'FileText', to: '/import-cost' },
      { label: 'Vendor Return', icon: 'Undo2', to: '/vendor-return' },
      { label: 'Credit Note', icon: 'ReceiptText', to: '/credit-note' },
    ],
  },
  {
    key: 'sales',
    label: 'II. SALES',
    nav: {
      label: 'Sales',
      to: '/quotation',
      match: ['/quotation', '/customer-po', '/sales-order', '/delivery-order', '/delivery-note'],
    },
    items: [
      { label: 'Quotation', icon: 'FileSpreadsheet', to: '/quotation' },
      { label: 'Customer PO', icon: 'ClipboardList', to: '/customer-po' },
      { label: 'SO', icon: 'FileCheck', to: '/sales-order' },
      { label: 'Delivery Order', icon: 'Truck', to: '/delivery-order' },
      { label: 'Delivery Note', icon: 'FileText', to: '/delivery-note' },
      { label: 'Delivery Note (Warehouse)', icon: 'Warehouse' },
    ],
  },
  {
    key: 'inventory',
    label: 'III. INVENTORY',
    // 시안 화면(/stock-*, /inventory-adjust)은 MOCK-UP 대분류로 옮겼습니다.
    nav: {
      label: 'Inventory',
      to: '/inventory-list',
      match: ['/inventory-list', '/inventory-monthly-closing'],
    },
    items: [
      { label: 'Inventory List', icon: 'Boxes', to: '/inventory-list' },
      {
        label: 'Inventory Monthly Closing',
        icon: 'ClipboardCheck',
        to: '/inventory-monthly-closing',
      },
    ],
  },
  {
    key: 'partners',
    label: 'IV. PARTNERS',
    nav: { label: 'Partners', to: '/customer', match: ['/customer', '/vendor', '/carrier'] },
    items: [
      { label: 'Customers', icon: 'Users', to: '/customer' },
      { label: 'Suppliers', icon: 'Building2', to: '/vendor' },
    ],
  },
  {
    key: 'master-data',
    label: 'V. MASTER DATA',
    // 시안 화면(/brand-pattern)은 MOCK-UP 대분류로 옮겼습니다.
    nav: {
      label: 'Master Data',
      to: '/product',
      match: ['/product', '/warehouse', '/location', '/monthly-closed-data'],
    },
    items: [
      { label: 'Products', icon: 'Package', to: '/product' },
      { label: 'Warehouses', icon: 'Warehouse', to: '/warehouse' },
      { label: 'Monthly Closed Data List', icon: 'FileSpreadsheet', to: '/monthly-closed-data' },
      { label: 'Upload Monthly Closing Data', icon: 'Repeat' },
    ],
  },
  {
    key: 'settings',
    label: 'VI. SETTINGS',
    // 참고 화면(/role-permission, /approval-matrix)은 참고 대분류로 옮겼습니다.
    // 참고(권한 가이드라인 화면)·MOCK-UP(시안) 대분류를 이 그룹의 하위메뉴로 옮겼습니다(2026-09-14 요청) —
    // 헤더가 운영 6종 + CSR 로 정리됩니다. 시안·참고가 필요 없어지면 아래 항목만 지우면 됩니다.
    nav: {
      label: 'Settings',
      to: '/search-employee',
      match: [
        '/search-employee',
        '/setting',
        '/change-password',
        '/role-permission',
        '/approval-matrix',
        '/stock-movement',
        '/inventory-adjust',
        '/stock-transfer',
        '/stock-opname',
        '/brand-pattern',
      ],
    },
    items: [
      { label: 'Search Staff', icon: 'UserCog', to: '/search-employee' },
      { label: 'Change Password', icon: 'Repeat' },
      // 참고 (문서 기준) — 「ASM 권한 가이드라인 v3.0」을 화면으로 옮긴 자료
      {
        label: '참고 · Role / Permission',
        labelId: 'Referensi · Role / Permission',
        icon: 'ShieldCheck',
        to: '/role-permission',
      },
      {
        label: '참고 · Approval Matrix',
        labelId: 'Referensi · Approval Matrix',
        icon: 'Workflow',
        to: '/approval-matrix',
      },
      // MOCK-UP (시안) — 운영 ASM 에 없는 시안 화면
      { label: 'MOCK-UP · Stock Movement', icon: 'ArrowLeftRight', to: '/stock-movement' },
      { label: 'MOCK-UP · Stock Adjustment', icon: 'SlidersHorizontal', to: '/inventory-adjust' },
      { label: 'MOCK-UP · Stock Transfer', icon: 'Repeat', to: '/stock-transfer' },
      { label: 'MOCK-UP · Stock Opname', icon: 'ClipboardCheck', to: '/stock-opname' },
      { label: 'MOCK-UP · Brand / Pattern', icon: 'Tag', to: '/brand-pattern' },
    ],
  },
]
/**
 * 상단 메뉴 (Top navigation / Navigasi atas)
 *
 * navGroups 에서 파생시킵니다 — 대분류 목록을 따로 두면 사이드바와 어긋날 수 있습니다.
 * 헤더 항목을 추가·삭제하려면 navGroups 의 그룹을 추가·삭제하십시오.
 */
export const topNav = navGroups.map((group) => ({ key: group.key, ...group.nav }))

/**
 * 메뉴 라벨 — 표시 언어 쪽(2026-09-14 「메뉴 버튼도 한국어/인니어 분리」).
 * 운영 메뉴는 영문 한 가지라 labelId 가 없고, 한국어가 들어간 항목에만 labelId 를 답니다.
 */
export const navLabel = (entry, lang) =>
  (lang === 'id' ? (entry?.labelId ?? entry?.label) : entry?.label) ?? ''

/** 현재 경로가 속한 그룹. 헤더의 활성 대분류이자 사이드바가 보여줄 목록입니다. */
export function findNavGroup(path) {
  return navGroups.find((group) => group.nav.match.some((prefix) => matchPath(path, prefix)))
}

/**
 * 현재 경로의 하위메뉴 항목 (Current menu item / Item menu saat ini)
 *
 * 가이드 7-2 는 헤더 좌측을 "로고 → 세로 구분선 → 화면 제목"으로 규정합니다. 화면 제목은
 * 곧 지금 열려 있는 하위메뉴의 이름이므로 메뉴 정의에서 그대로 끌어옵니다 — 화면마다
 * 제목을 따로 적어두면 메뉴 이름과 어긋납니다.
 */
export function findNavItem(path) {
  return findNavGroup(path)?.items.find((item) => item.to && matchPath(path, item.to))
}

export const APP_USER = { name: 'Seo Jonghwan', initials: 'SH', role: 'General Manager' }
export const APP_VERSION = 'v1.0 · 01 Sep 2026'
