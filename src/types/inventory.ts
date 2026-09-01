import type { BadgeTone } from '@/types/purchase-po'

export type { BadgeTone }

/** 재고 상태 (Stock status / Status persediaan) */
export type StockStatus = 'ok' | 'low' | 'out' | 'hold'

export type InventorySortKey =
  | 'wh'
  | 'cat'
  | 'brand'
  | 'size'
  | 'code'
  | 'qty'
  | 'cost'
  | 'value'
  | 'aging'

export type InventoryItem = {
  id: number
  /** 창고 (Warehouse / Gudang) */
  wh: string
  /** 카테고리 (Category / Kategori) — OTR · TB-R · TB-B · IND · AGR */
  cat: string
  /** 브랜드 (Brand / Merek) */
  brand: string
  /** 규격 (Size / Ukuran) — 콤마를 넣지 않습니다. 예) 1200R24 */
  size: string
  /** 패턴 (Pattern / Pola) */
  pattern: string
  /** 품번 (Item code / Kode barang) */
  code: string
  /** PR / TL 구분 */
  pr: string
  /** 재고 수량 (Stock qty / Jumlah stok) */
  qty: number
  /** 예약 수량 (Reserved / Dipesan) */
  rsv: number
  /** 단가 — CIF 원가 기준 USD (Unit cost / Harga satuan) */
  cost: number
  /** 재고 경과일 (Aging / Umur stok) */
  aging: number
  status: StockStatus
}

/** 장기재고 판정 기준일 (Aged stock threshold) */
export const AGED_STOCK_DAYS = 365

export const STATUS_LABEL: Record<StockStatus, string> = {
  ok: 'Normal',
  low: 'Below Buffer',
  out: 'Out of Stock',
  hold: 'Hold',
}

export const statusTone: Record<StockStatus, BadgeTone> = {
  ok: 'success',
  low: 'warning',
  out: 'danger',
  hold: 'neutral',
}

export const STOCK_STATUSES: StockStatus[] = ['ok', 'low', 'out', 'hold']

/** 가용 재고 = 재고 − 예약 (Available / Tersedia) */
export const availableOf = (item: InventoryItem) => item.qty - item.rsv

/** 재고 금액 = 수량 × 단가 (Stock value / Nilai persediaan) */
export const valueOf = (item: InventoryItem) => item.qty * item.cost
