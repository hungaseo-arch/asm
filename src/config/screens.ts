import type { ScreenDef } from '@/types/list-screen'

/**
 * 목록 화면 레지스트리 (Screen registry / Registri layar)
 *
 * 구성과 순서는 개선의견서(ASM 실서버 테스트 결과)의 메뉴 목차를 따릅니다.
 * 정의는 화면 진입 시 동적 import 로 불러오므로 첫 화면 번들에는 포함되지 않습니다.
 * 새 화면을 추가하려면 `src/data/screens/<slug>.ts` 를 만들고 이 배열에 한 줄만 더합니다.
 */
export type ScreenRoute = {
  slug: string
  path: string
  title: string
  load: () => Promise<ScreenDef>
}

export const screenRoutes: ScreenRoute[] = [
  // ── I. Purchasing ───────────────────────────────────────────────────────
  // Purchase PO 는 전용 화면(/purchase-po)이 있어 여기에 넣지 않습니다.
  { slug: 'ppc', path: '/purchasing/ppc', title: 'PPC (Production Plan)',
    load: () => import('@/data/screens/ppc').then((m) => m.ppcScreen) },
  { slug: 'payment-plan', path: '/purchasing/payment-plan', title: 'Payment Plan',
    load: () => import('@/data/screens/payment-plan').then((m) => m.paymentPlanScreen) },
  { slug: 'shipment', path: '/purchasing/shipment', title: 'Shipment',
    load: () => import('@/data/screens/shipment').then((m) => m.shipmentScreen) },
  { slug: 'customs', path: '/purchasing/customs', title: 'Customs',
    load: () => import('@/data/screens/customs').then((m) => m.customsScreen) },
  { slug: 'receipts', path: '/purchasing/receipts', title: 'Receipt',
    load: () => import('@/data/screens/receipts').then((m) => m.receiptsScreen) },
  { slug: 'receipts-wh', path: '/purchasing/receipts-wh', title: 'Receipt (Warehouse)',
    load: () => import('@/data/screens/receipts-wh').then((m) => m.receiptsWhScreen) },
  { slug: 'import-cost', path: '/purchasing/import-cost', title: 'Import Cost',
    load: () => import('@/data/screens/import-cost').then((m) => m.importCostScreen) },
  { slug: 'vendor-return', path: '/purchasing/vendor-return', title: 'Vendor Return',
    load: () => import('@/data/screens/vendor-return').then((m) => m.vendorReturnScreen) },
  { slug: 'credit-note', path: '/purchasing/credit-note', title: 'Credit Note',
    load: () => import('@/data/screens/credit-note').then((m) => m.creditNoteScreen) },

  // ── II. Sales ───────────────────────────────────────────────────────────
  { slug: 'quotation', path: '/sales/quotation', title: 'Quotation',
    load: () => import('@/data/screens/quotation').then((m) => m.quotationScreen) },
  { slug: 'customer-po', path: '/sales/customer-po', title: 'Customer PO',
    load: () => import('@/data/screens/customer-po').then((m) => m.customerPoScreen) },
  { slug: 'so', path: '/sales/so', title: 'SO',
    load: () => import('@/data/screens/so').then((m) => m.soScreen) },
  { slug: 'delivery-order', path: '/sales/delivery-order', title: 'Delivery Order',
    load: () => import('@/data/screens/delivery-order').then((m) => m.deliveryOrderScreen) },
  { slug: 'delivery-note', path: '/sales/delivery-note', title: 'Delivery Note',
    load: () => import('@/data/screens/delivery-note').then((m) => m.deliveryNoteScreen) },

  // ── III. Inventory ──────────────────────────────────────────────────────
  // Inventory List 는 전용 화면(/inventory-list)입니다.
  { slug: 'inventory-monthly-closing', path: '/inventory/monthly-closing', title: 'Inventory Monthly Closing',
    load: () => import('@/data/screens/inventory-monthly-closing').then((m) => m.inventoryMonthlyClosingScreen) },

  // ── IV. Partners ────────────────────────────────────────────────────────
  { slug: 'customer', path: '/partners/customer', title: 'Customers',
    load: () => import('@/data/screens/customer').then((m) => m.customerScreen) },
  { slug: 'vendor', path: '/partners/vendor', title: 'Suppliers',
    load: () => import('@/data/screens/vendor').then((m) => m.vendorScreen) },

  // ── V. Master Data ──────────────────────────────────────────────────────
  { slug: 'products', path: '/master/products', title: 'Products',
    load: () => import('@/data/screens/products').then((m) => m.productsScreen) },
  { slug: 'warehouses', path: '/master/warehouses', title: 'Warehouses',
    load: () => import('@/data/screens/warehouses').then((m) => m.warehousesScreen) },
  { slug: 'monthly-closed-data', path: '/master/monthly-closed-data', title: 'Monthly Closed Data List',
    load: () => import('@/data/screens/monthly-closed-data').then((m) => m.monthlyClosedDataScreen) },

  // ── VI. Settings ────────────────────────────────────────────────────────
  { slug: 'search-staff', path: '/settings/search-staff', title: 'Search Staff',
    load: () => import('@/data/screens/search-staff').then((m) => m.searchStaffScreen) },

  // ── 시안 전용 (Mock-up) — 운영 ASM 메뉴에는 없는 화면입니다.
  //    실 메뉴만 남기려면 아래 6줄과 navigation.ts 의 'MOCK-UP' 그룹을 함께 지우면 됩니다.
  { slug: 'stock-movement', path: '/inventory/stock-movement', title: 'Stock Movement',
    load: () => import('@/data/screens/stock-movement').then((m) => m.stockMovementScreen) },
  { slug: 'stock-adjustment', path: '/inventory/stock-adjustment', title: 'Stock Adjustment',
    load: () => import('@/data/screens/stock-adjustment').then((m) => m.stockAdjustmentScreen) },
  { slug: 'stock-transfer', path: '/inventory/stock-transfer', title: 'Stock Transfer',
    load: () => import('@/data/screens/stock-transfer').then((m) => m.stockTransferScreen) },
  { slug: 'stock-opname', path: '/inventory/stock-opname', title: 'Stock Opname',
    load: () => import('@/data/screens/stock-opname').then((m) => m.stockOpnameScreen) },
  { slug: 'brand-pattern', path: '/master/brand-pattern', title: 'Brand / Pattern',
    load: () => import('@/data/screens/brand-pattern').then((m) => m.brandPatternScreen) },
  { slug: 'role-permission', path: '/settings/role-permission', title: 'Role / Permission',
    load: () => import('@/data/screens/role-permission').then((m) => m.rolePermissionScreen) },
  { slug: 'approval-matrix', path: '/settings/approval-matrix', title: 'Approval Matrix',
    load: () => import('@/data/screens/approval-matrix').then((m) => m.approvalMatrixScreen) },
]

export const screenBySlug = (slug: string) => screenRoutes.find((screen) => screen.slug === slug)
