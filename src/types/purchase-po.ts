import type { Currency } from '@/utils/format'

export type { Currency }

/** 발주 상태 (PO status / Status PO) */
export type PoStatus = 'Draft' | 'Pending approval' | 'Confirmed' | 'In production'

/** 구매 구분 — 수입 / 로컬 (Purchase type / Jenis pembelian) */
export type PurchaseType = 'Import' | 'Local'

/** 과세 기준 (Tax basis / Dasar pajak) */
export type TaxBasis = 'Tax included' | 'DPP / Tax excluded'

export type SortKey = 'poNo' | 'supplier' | 'poDate' | 'amount' | 'status'

export type BadgeTone = 'neutral' | 'info' | 'success' | 'warning' | 'danger'

export type PurchaseOrder = {
  id: number
  poNo: string
  supplier: string
  type: PurchaseType
  poDate: string
  targetDate: string
  currency: Currency
  amount: number
  taxBasis: TaxBasis
  allocated: number
  completed: number
  totalQty: number
  status: PoStatus
  paymentTerm: string
  buyer: string
}

export type NewPurchaseOrderInput = {
  supplier: string
  type: PurchaseType
  currency: Currency
  amount: number
  targetDate: string
}

export const statusTone: Record<PoStatus, BadgeTone> = {
  Draft: 'neutral',
  'Pending approval': 'warning',
  Confirmed: 'success',
  'In production': 'info',
}

export const PO_STATUSES: PoStatus[] = ['Draft', 'Pending approval', 'Confirmed', 'In production']
export const PURCHASE_TYPES: PurchaseType[] = ['Import', 'Local']
export const CURRENCIES: Currency[] = ['IDR', 'USD']
