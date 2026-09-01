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

/** 상단 메뉴 (Top navigation / Navigasi atas) */
export const topNav = [
  { label: 'Purchasing', to: '/purchase-po' },
  { label: 'Sales' },
  { label: 'Inventory', to: '/inventory-list' },
  { label: 'Partners' },
  { label: 'Master Data' },
] satisfies Array<{ label: string; to?: string }>

/**
 * 좌측 사이드바 (Sidebar / Bilah sisi)
 * 메뉴 구성은 운영 ASM(asm.ascendotyre.com)의 6개 대분류를 그대로 따릅니다.
 */
export const navGroups: NavGroup[] = [
  {
    label: 'I. PURCHASING',
    items: [
      { label: 'Purchase PO', icon: ShoppingCart, to: '/purchase-po' },
      { label: 'PPC (Production Plan)', icon: Factory },
      { label: 'Shipment', icon: Ship },
      { label: 'Customs', icon: ClipboardCheck },
      { label: 'Receipt', icon: PackageCheck },
      { label: 'Receipt (WH)', icon: Warehouse },
      { label: 'Import Cost', icon: FileText },
      { label: 'Vendor Return', icon: Undo2 },
      { label: 'Credit Note', icon: ReceiptText },
    ],
  },
  {
    label: 'II. SALES',
    items: [
      { label: 'Quotation', icon: FileSpreadsheet },
      { label: 'Customer PO', icon: ClipboardList },
      { label: 'SO', icon: FileCheck },
      { label: 'Delivery Order', icon: Truck },
      { label: 'Delivery Note', icon: FileText },
      { label: 'Delivery Note (WH)', icon: Warehouse },
    ],
  },
  {
    label: 'III. INVENTORY',
    items: [
      { label: 'Inventory List', icon: Boxes, to: '/inventory-list' },
      { label: 'Stock Movement', icon: ArrowLeftRight },
      { label: 'Stock Adjustment', icon: SlidersHorizontal },
      { label: 'Stock Transfer', icon: Repeat },
      { label: 'Stock Opname', icon: ClipboardCheck },
    ],
  },
  {
    label: 'IV. PARTNERS',
    items: [
      { label: 'Customer', icon: Users },
      { label: 'Vendor', icon: Building2 },
      { label: 'Forwarder', icon: Ship },
    ],
  },
  {
    label: 'V. MASTER DATA',
    items: [
      { label: 'Item', icon: Package },
      { label: 'Brand / Pattern', icon: Tag },
      { label: 'Warehouse', icon: Warehouse },
      { label: 'Currency', icon: CircleDollarSign },
    ],
  },
  {
    label: 'VI. SETTINGS',
    items: [
      { label: 'User', icon: UserCog },
      { label: 'Role / Permission', icon: ShieldCheck },
      { label: 'Approval Matrix', icon: Workflow },
    ],
  },
]

export const APP_VERSION = 'v1.0 · 01 Sep 2026'
