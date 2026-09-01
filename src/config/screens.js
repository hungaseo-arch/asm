export const screenRoutes = [
  // ── I. Purchasing ───────────────────────────────────────────────────────
  // Purchase PO 는 전용 화면(/purchase-po)이 있어 여기에 넣지 않습니다.
  {
    slug: 'ppc',
    path: '/ppc',
    title: 'PPC (Production Plan)',
    load: () => import('@/data/screens/ppc').then((m) => m.ppcScreen),
  },
  {
    slug: 'payment-plan',
    path: '/payment-plan',
    title: 'Payment Plan',
    load: () => import('@/data/screens/payment-plan').then((m) => m.paymentPlanScreen),
  },
  {
    slug: 'shipment',
    path: '/shipment',
    title: 'Shipment',
    load: () => import('@/data/screens/shipment').then((m) => m.shipmentScreen),
  },
  {
    slug: 'customs',
    path: '/customs',
    title: 'Customs',
    load: () => import('@/data/screens/customs').then((m) => m.customsScreen),
  },
  {
    slug: 'receipts',
    path: '/receipts',
    title: 'Receipt',
    load: () => import('@/data/screens/receipts').then((m) => m.receiptsScreen),
  },
  {
    slug: 'receipts-wh',
    path: '/receipts-wh',
    title: 'Receipt (Warehouse)',
    load: () => import('@/data/screens/receipts-wh').then((m) => m.receiptsWhScreen),
  },
  {
    slug: 'import-cost',
    path: '/import-cost',
    title: 'Import Cost',
    load: () => import('@/data/screens/import-cost').then((m) => m.importCostScreen),
  },
  {
    slug: 'vendor-return',
    path: '/vendor-return',
    title: 'Vendor Return',
    load: () => import('@/data/screens/vendor-return').then((m) => m.vendorReturnScreen),
  },
  {
    slug: 'credit-note',
    path: '/credit-note',
    title: 'Credit Note',
    load: () => import('@/data/screens/credit-note').then((m) => m.creditNoteScreen),
  },
  // ── II. Sales ───────────────────────────────────────────────────────────
  {
    slug: 'quotation',
    path: '/quotation',
    title: 'Quotation',
    load: () => import('@/data/screens/quotation').then((m) => m.quotationScreen),
  },
  {
    slug: 'customer-po',
    path: '/customer-po',
    title: 'Customer PO',
    load: () => import('@/data/screens/customer-po').then((m) => m.customerPoScreen),
  },
  {
    slug: 'so',
    path: '/sales-order',
    title: 'SO',
    load: () => import('@/data/screens/so').then((m) => m.soScreen),
  },
  {
    slug: 'delivery-order',
    path: '/delivery-order',
    title: 'Delivery Order',
    load: () => import('@/data/screens/delivery-order').then((m) => m.deliveryOrderScreen),
  },
  {
    slug: 'delivery-note',
    path: '/delivery-note',
    title: 'Delivery Note',
    load: () => import('@/data/screens/delivery-note').then((m) => m.deliveryNoteScreen),
  },
  // ── III. Inventory ──────────────────────────────────────────────────────
  // Inventory List 는 전용 화면(/inventory-list)입니다.
  {
    slug: 'inventory-monthly-closing',
    path: '/inventory-monthly-closing',
    title: 'Inventory Monthly Closing',
    load: () =>
      import('@/data/screens/inventory-monthly-closing').then(
        (m) => m.inventoryMonthlyClosingScreen,
      ),
  },
  // ── IV. Partners ────────────────────────────────────────────────────────
  {
    slug: 'customer',
    path: '/customer',
    title: 'Customers',
    load: () => import('@/data/screens/customer').then((m) => m.customerScreen),
  },
  {
    slug: 'vendor',
    path: '/vendor',
    title: 'Suppliers',
    load: () => import('@/data/screens/vendor').then((m) => m.vendorScreen),
  },
  // ── V. Master Data ──────────────────────────────────────────────────────
  {
    slug: 'products',
    path: '/product',
    title: 'Products',
    load: () => import('@/data/screens/products').then((m) => m.productsScreen),
  },
  {
    slug: 'warehouses',
    path: '/warehouse',
    title: 'Warehouses',
    load: () => import('@/data/screens/warehouses').then((m) => m.warehousesScreen),
  },
  {
    slug: 'monthly-closed-data',
    path: '/monthly-closed-data',
    title: 'Monthly Closed Data List',
    load: () => import('@/data/screens/monthly-closed-data').then((m) => m.monthlyClosedDataScreen),
  },
  // ── VI. Settings ────────────────────────────────────────────────────────
  {
    slug: 'search-staff',
    path: '/search-employee',
    title: 'Search Staff',
    load: () => import('@/data/screens/search-staff').then((m) => m.searchStaffScreen),
  },
  {
    slug: 'role-permission',
    path: '/role-permission',
    title: 'Role / Permission',
    load: () => import('@/data/screens/role-permission').then((m) => m.rolePermissionScreen),
  },
  {
    slug: 'approval-matrix',
    path: '/approval-matrix',
    title: 'Approval Matrix',
    load: () => import('@/data/screens/approval-matrix').then((m) => m.approvalMatrixScreen),
  },
  // ── 시안 전용 (Mock-up) — 운영 ASM 메뉴에는 없는 화면입니다.
  //    실 메뉴만 남기려면 아래 6줄과 navigation.ts 의 'MOCK-UP' 그룹을 함께 지우면 됩니다.
  {
    slug: 'stock-movement',
    path: '/stock-movement',
    title: 'Stock Movement',
    load: () => import('@/data/screens/stock-movement').then((m) => m.stockMovementScreen),
  },
  {
    slug: 'stock-adjustment',
    path: '/inventory-adjust',
    title: 'Stock Adjustment',
    load: () => import('@/data/screens/stock-adjustment').then((m) => m.stockAdjustmentScreen),
  },
  {
    slug: 'stock-transfer',
    path: '/stock-transfer',
    title: 'Stock Transfer',
    load: () => import('@/data/screens/stock-transfer').then((m) => m.stockTransferScreen),
  },
  {
    slug: 'stock-opname',
    path: '/stock-opname',
    title: 'Stock Opname',
    load: () => import('@/data/screens/stock-opname').then((m) => m.stockOpnameScreen),
  },
  {
    slug: 'brand-pattern',
    path: '/brand-pattern',
    title: 'Brand / Pattern',
    load: () => import('@/data/screens/brand-pattern').then((m) => m.brandPatternScreen),
  },
]
export const screenBySlug = (slug) => screenRoutes.find((screen) => screen.slug === slug)
