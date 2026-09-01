import {
  ArrowLeftRight,
  Boxes,
  Building2,
  CircleDollarSign,
  ClipboardCheck,
  ClipboardList,
  FileCheck,
  FileSpreadsheet,
  FileText,
  Factory,
  Package,
  PackageCheck,
  ReceiptText,
  Repeat,
  ShieldCheck,
  Ship,
  ShoppingCart,
  SlidersHorizontal,
  Tag,
  Truck,
  Undo2,
  UserCog,
  Users,
  Warehouse,
  Workflow,
} from 'lucide-vue-next'
import type { Component } from 'vue'

export type NavItem = {
  label: string
  icon: Component
  /** 라우트가 준비된 항목만 to 를 갖습니다. 없으면 "준비 중" 안내. */
  to?: string
  badge?: string
}

export type NavGroup = {
  label: string
  items: NavItem[]
}

/**
 * 상단 메뉴 (Top navigation / Navigasi atas)
 * `match` 는 활성 표시 판정용 경로 접두사입니다 (하위 화면에서도 대분류가 켜지도록).
 */
export const topNav = [
  {
    label: 'Purchasing',
    to: '/vendor-po',
    match: ['/vendor-po', '/purchase-order', '/ppc', '/payment-plan', '/shipment', '/customs',
      '/receipts', '/receipts-wh', '/import-cost', '/vendor-return', '/credit-note'],
  },
  {
    label: 'Sales',
    to: '/quotation',
    match: ['/quotation', '/customer-po', '/sales-order', '/delivery-order', '/delivery-note'],
  },
  {
    label: 'Inventory',
    to: '/inventory-list',
    match: ['/inventory-list', '/inventory-monthly-closing', '/inventory-adjust',
      '/stock-movement', '/stock-transfer', '/stock-opname'],
  },
  { label: 'Partners', to: '/customer', match: ['/customer', '/vendor', '/carrier'] },
  {
    label: 'Master Data',
    to: '/product',
    match: ['/product', '/warehouse', '/location', '/monthly-closed-data', '/brand-pattern'],
  },
  {
    label: 'Settings',
    to: '/search-employee',
    match: ['/search-employee', '/role-permission', '/approval-matrix', '/setting', '/change-password'],
  },
] satisfies Array<{ label: string; to?: string; match?: string[] }>

/**
 * 좌측 사이드바 (Sidebar / Bilah sisi)
 * 메뉴 구성·명칭은 개선의견서(ASM 실서버 테스트 결과)의 목차를 따릅니다.
 * 라우트가 아직 없는 항목(Delivery Note (Warehouse) 등)은 안내 토스트만 표시합니다.
 */
export const navGroups: NavGroup[] = [
  {
    label: 'I. PURCHASING',
    items: [
      { label: 'Purchase PO', icon: ShoppingCart, to: '/vendor-po' },
      { label: 'PPC (Production Plan)', icon: Factory, to: '/ppc' },
      { label: 'Payment Plan', icon: CircleDollarSign, to: '/payment-plan', badge: 'NEW' },
      { label: 'Shipment', icon: Ship, to: '/shipment' },
      { label: 'Customs', icon: ClipboardCheck, to: '/customs' },
      { label: 'Receipt', icon: PackageCheck, to: '/receipts' },
      { label: 'Receipt (Warehouse)', icon: Warehouse, to: '/receipts-wh' },
      { label: 'Import Cost', icon: FileText, to: '/import-cost' },
      { label: 'Vendor Return', icon: Undo2, to: '/vendor-return' },
      { label: 'Credit Note', icon: ReceiptText, to: '/credit-note' },
    ],
  },
  {
    label: 'II. SALES',
    items: [
      { label: 'Quotation', icon: FileSpreadsheet, to: '/quotation' },
      { label: 'Customer PO', icon: ClipboardList, to: '/customer-po' },
      { label: 'SO', icon: FileCheck, to: '/sales-order' },
      { label: 'Delivery Order', icon: Truck, to: '/delivery-order' },
      { label: 'Delivery Note', icon: FileText, to: '/delivery-note' },
      { label: 'Delivery Note (Warehouse)', icon: Warehouse },
    ],
  },
  {
    label: 'III. INVENTORY',
    items: [
      { label: 'Inventory List', icon: Boxes, to: '/inventory-list' },
      { label: 'Inventory Monthly Closing', icon: ClipboardCheck, to: '/inventory-monthly-closing' },
    ],
  },
  {
    label: 'IV. PARTNERS',
    items: [
      { label: 'Customers', icon: Users, to: '/customer' },
      { label: 'Suppliers', icon: Building2, to: '/vendor' },
    ],
  },
  {
    label: 'V. MASTER DATA',
    items: [
      { label: 'Products', icon: Package, to: '/product' },
      { label: 'Warehouses', icon: Warehouse, to: '/warehouse' },
      { label: 'Monthly Closed Data List', icon: FileSpreadsheet, to: '/monthly-closed-data' },
      { label: 'Upload Monthly Closing Data', icon: Repeat },
    ],
  },
  {
    label: 'VI. SETTINGS',
    items: [
      { label: 'Search Staff', icon: UserCog, to: '/search-employee' },
      // 권한 가이드라인 v3.0 기준 화면 (3장 권한 매트릭스 · 6장 승인 매트릭스)
      { label: 'Role / Permission', icon: ShieldCheck, to: '/role-permission' },
      { label: 'Approval Matrix', icon: Workflow, to: '/approval-matrix' },
      { label: 'Change Password', icon: Repeat },
    ],
  },
  {
    // 운영 ASM 메뉴에는 없는 시안(Mock-up) 화면입니다. 불필요하면 이 그룹만 지우면 됩니다.
    label: 'MOCK-UP (시안)',
    items: [
      { label: 'Stock Movement', icon: ArrowLeftRight, to: '/stock-movement' },
      { label: 'Stock Adjustment', icon: SlidersHorizontal, to: '/inventory-adjust' },
      { label: 'Stock Transfer', icon: Repeat, to: '/stock-transfer' },
      { label: 'Stock Opname', icon: ClipboardCheck, to: '/stock-opname' },
      { label: 'Brand / Pattern', icon: Tag, to: '/brand-pattern' },
    ],
  },
]

export const APP_USER = { name: 'Seo Jonghwan', initials: 'SH', role: 'General Manager' }

export const APP_VERSION = 'v1.0 · 01 Sep 2026'
