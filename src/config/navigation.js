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
    nav: {
      label: 'Settings',
      to: '/search-employee',
      match: ['/search-employee', '/setting', '/change-password', '/csr'],
    },
    items: [
      { label: 'Search Staff', icon: 'UserCog', to: '/search-employee' },
      { label: 'Change Password', icon: 'Repeat' },
      // 개선요청(CSR) — Notion 이관분. 별도 지시서를 따르는 독립 모듈입니다.
      { label: 'CSR (개선요청)', icon: 'ClipboardList', to: '/csr' },
    ],
  },
  {
    /*
     * 운영 ASM 메뉴가 아니라 「ASM 권한 가이드라인 v3.0」을 화면으로 옮긴 참고 자료입니다.
     * (문서 정합성 리포트 A-5 — 운영 하위메뉴는 25종으로 고정)
     *
     * 임시 대분류 — 실서버 ASM 헤더에는 없는 분류입니다. 사이드바가 2단만 남으면서
     * 이 화면들로 들어갈 경로가 사라지기에 헤더에 자리를 만들었습니다. 운영 6종과
     * 섞이지 않도록 Settings 의 match 에서 빼내 별도 대분류로 분리했습니다.
     * 참고 화면이 필요 없어지면 이 그룹만 통째로 지우면 됩니다.
     */
    key: 'reference',
    label: '참고 (문서 기준)',
    nav: {
      label: '참고',
      to: '/role-permission',
      match: ['/role-permission', '/approval-matrix'],
      temporary: true,
    },
    items: [
      { label: 'Role / Permission', icon: 'ShieldCheck', to: '/role-permission' },
      { label: 'Approval Matrix', icon: 'Workflow', to: '/approval-matrix' },
    ],
  },
  {
    /*
     * 운영 ASM 메뉴에는 없는 시안(Mock-up) 화면입니다. 불필요하면 이 그룹만 지우면 됩니다.
     *
     * 임시 대분류 — 위 '참고'와 같은 이유로 헤더에 자리를 만들었습니다. 시안 화면이
     * Inventory(4종)와 Master Data(1종)에 흩어져 있어 운영 메뉴 25종에 섞이던 것을
     * 두 대분류의 match 에서 빼내 여기로 모았습니다.
     */
    key: 'mockup',
    label: 'MOCK-UP (시안)',
    nav: {
      label: 'MOCK-UP',
      to: '/stock-movement',
      match: [
        '/stock-movement',
        '/inventory-adjust',
        '/stock-transfer',
        '/stock-opname',
        '/brand-pattern',
      ],
      temporary: true,
    },
    items: [
      { label: 'Stock Movement', icon: 'ArrowLeftRight', to: '/stock-movement' },
      { label: 'Stock Adjustment', icon: 'SlidersHorizontal', to: '/inventory-adjust' },
      { label: 'Stock Transfer', icon: 'Repeat', to: '/stock-transfer' },
      { label: 'Stock Opname', icon: 'ClipboardCheck', to: '/stock-opname' },
      { label: 'Brand / Pattern', icon: 'Tag', to: '/brand-pattern' },
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
