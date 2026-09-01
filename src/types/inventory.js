/** 장기재고 판정 기준일 (Aged stock threshold) */
export const AGED_STOCK_DAYS = 365
export const STATUS_LABEL = {
  ok: 'Normal',
  low: 'Below Buffer',
  out: 'Out of Stock',
  hold: 'Hold',
}
export const statusTone = {
  ok: 'success',
  low: 'warning',
  out: 'danger',
  hold: 'neutral',
}
export const STOCK_STATUSES = ['ok', 'low', 'out', 'hold']
/** 가용 재고 = 재고 − 예약 (Available / Tersedia) */
export const availableOf = (item) => item.qty - item.rsv
/** 재고 금액 = 수량 × 단가 (Stock value / Nilai persediaan) */
export const valueOf = (item) => item.qty * item.cost
