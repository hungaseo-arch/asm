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
  { label: 'Purchasing', to: '/purchase-po', match: ['/purchase-po', '/purchasing'] },
  { label: 'Sales', to: '/sales/quotation', match: ['/sales'] },
  { label: 'Inventory', to: '/inventory-list', match: ['/inventory'] },
  { label: 'Partners', to: '/partners/customer', match: ['/partners'] },
  { label: 'Master Data', to: '/master/item', match: ['/master'] },
  { label: 'Settings', to: '/settings/user', match: ['/settings'] },
] satisfies Array<{ label: string; to?: string; match?: string[] }>

/**
 * 좌측 사이드바 (Sidebar / Bilah sisi)
 * 메뉴 구성은 운영 ASM(asm.ascendotyre.com)의 6개 대분류를 그대로 따릅니다.
 */
export const navGroups: NavGroup[] = [
  {
    label: 'I. PURCHASING',
    items: [
      { label: 'Purchase PO', icon: ShoppingCart, to: '/purchase-po' },
      { label: 'PPC', icon: Factory, to: '/purchasing/ppc' },
      { label: 'Shipment', icon: Ship, to: '/purchasing/shipment' },
      { label: 'Customs', icon: ClipboardCheck, to: '/purchasing/customs' },
      { label: 'Receipt', icon: PackageCheck, to: '/purchasing/receipts' },
      { label: 'Receipt(WH)', icon: Warehouse, to: '/purchasing/receipts-wh' },
      { label: 'Import Cost', icon: FileText, to: '/purchasing/import-cost' },
      { label: 'Vendor Return', icon: Undo2, to: '/purchasing/vendor-return' },
      { label: 'Credit Note', icon: ReceiptText, to: '/purchasing/credit-note' },
    ],
  },
  {
    label: 'II. SALES',
    items: [
      { label: 'Quotation', icon: FileSpreadsheet, to: '/sales/quotation' },
      { label: 'Customer PO', icon: ClipboardList, to: '/sales/customer-po' },
      { label: 'SO', icon: FileCheck, to: '/sales/so' },
      { label: 'Delivery Order', icon: Truck, to: '/sales/delivery-order' },
      { label: 'Delivery Note', icon: FileText, to: '/sales/delivery-note' },
      { label: 'Delivery Note (WH)', icon: Warehouse },
    ],
  },
  {
    label: 'III. INVENTORY',
    items: [
      { label: 'Inventory List', icon: Boxes, to: '/inventory-list' },
      { label: 'Stock Movement', icon: ArrowLeftRight, to: '/inventory/stock-movement' },
      { label: 'Stock Adjustment', icon: SlidersHorizontal, to: '/inventory/stock-adjustment' },
      { label: 'Stock Transfer', icon: Repeat, to: '/inventory/stock-transfer' },
      { label: 'Stock Opname', icon: ClipboardCheck, to: '/inventory/stock-opname' },
    ],
  },
  {
    label: 'IV. PARTNERS',
    items: [
      { label: 'Customers', icon: Users, to: '/partners/customer' },
      { label: 'Suppliers', icon: Building2, to: '/partners/vendor' },
    ],
  },
  {
    label: 'V. MASTER DATA',
    items: [
      { label: 'Item', icon: Package, to: '/master/item' },
      { label: 'Brand / Pattern', icon: Tag, to: '/master/brand-pattern' },
      { label: 'Warehouse', icon: Warehouse, to: '/master/warehouse' },
      { label: 'Currency', icon: CircleDollarSign },
    ],
  },
  {
    label: 'VI. SETTINGS',
    items: [
      { label: 'User', icon: UserCog, to: '/settings/user' },
      { label: 'Role / Permission', icon: ShieldCheck, to: '/settings/role-permission' },
      { label: 'Approval Matrix', icon: Workflow, to: '/settings/approval-matrix' },
    ],
  },
]

/**
 * 상단바 표시용 사용자 (Display user / Pengguna tampilan)
 * 로그인 기능이 꺼져 있어 세션 대신 이 값을 표시합니다.
 */
export const APP_USER = { name: 'Seo Hunga', initials: 'SH', role: 'General Manager' }

export const APP_VERSION = 'v1.0 · 01 Sep 2026'
