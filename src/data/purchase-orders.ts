import type { PurchaseOrder } from '@/types/purchase-po'

/**
 * 프로토타입 시드 데이터 (Seed data / Data awal).
 * 운영 전환 시 이 파일을 삭제하고 `usePurchaseOrders()` 의 fetch 분기만
 * 실제 API(`GET /api/purchase-orders`)로 바꾸면 화면 코드는 그대로 동작합니다.
 */
export const seedPurchaseOrders: PurchaseOrder[] = [
  { id: 1, poNo: 'PO-20260828-014', supplier: 'PT. ARAMI JAYA', type: 'Local', poDate: '2026-08-28', targetDate: '2026-09-12', currency: 'IDR', amount: 1225526558, taxBasis: 'Tax included', allocated: 720, completed: 540, totalQty: 816, status: 'In production', paymentTerm: 'TOP 30 days', buyer: 'A. Pratama' },
  { id: 2, poNo: 'PO-20260827-013', supplier: 'AULICE TYRE CO., LTD.', type: 'Import', poDate: '2026-08-27', targetDate: '2026-10-04', currency: 'USD', amount: 108800, taxBasis: 'DPP / Tax excluded', allocated: 816, completed: 816, totalQty: 816, status: 'Confirmed', paymentTerm: 'T/T 30% / 70%', buyer: 'M. Rizky' },
  { id: 3, poNo: 'PO-20260825-012', supplier: 'JK TYRE & INDUSTRIES LTD.', type: 'Import', poDate: '2026-08-25', targetDate: '2026-10-16', currency: 'USD', amount: 76450.5, taxBasis: 'DPP / Tax excluded', allocated: 420, completed: 168, totalQty: 600, status: 'In production', paymentTerm: 'L/C at sight', buyer: 'M. Rizky' },
  { id: 4, poNo: 'PO-20260822-011', supplier: 'PT. KARET MAKMUR', type: 'Local', poDate: '2026-08-22', targetDate: '2026-09-08', currency: 'IDR', amount: 487650000, taxBasis: 'Tax included', allocated: 300, completed: 0, totalQty: 500, status: 'Pending approval', paymentTerm: 'TOP 45 days', buyer: 'D. Saputra' },
  { id: 5, poNo: 'PO-20260820-010', supplier: 'QINGDAO DOUBLESTAR', type: 'Import', poDate: '2026-08-20', targetDate: '2026-10-01', currency: 'USD', amount: 92540, taxBasis: 'DPP / Tax excluded', allocated: 500, completed: 350, totalQty: 500, status: 'Confirmed', paymentTerm: 'T/T 20% / 80%', buyer: 'A. Pratama' },
  { id: 6, poNo: 'PO-20260818-009', supplier: 'PT. SUMBER BAN', type: 'Local', poDate: '2026-08-18', targetDate: '2026-09-02', currency: 'IDR', amount: 318400000, taxBasis: 'Tax included', allocated: 240, completed: 240, totalQty: 240, status: 'Confirmed', paymentTerm: 'CBD', buyer: 'D. Saputra' },
  { id: 7, poNo: 'PO-20260815-008', supplier: 'SAILUN GROUP CO., LTD.', type: 'Import', poDate: '2026-08-15', targetDate: '2026-09-28', currency: 'USD', amount: 134250, taxBasis: 'DPP / Tax excluded', allocated: 640, completed: 192, totalQty: 800, status: 'In production', paymentTerm: 'T/T 30% / 70%', buyer: 'M. Rizky' },
  { id: 8, poNo: 'PO-20260812-007', supplier: 'PT. MULTI KARET', type: 'Local', poDate: '2026-08-12', targetDate: '2026-08-29', currency: 'IDR', amount: 198750000, taxBasis: 'Tax included', allocated: 180, completed: 180, totalQty: 180, status: 'Confirmed', paymentTerm: 'TOP 30 days', buyer: 'A. Pratama' },
  { id: 9, poNo: 'PO-20260808-006', supplier: 'TRIANGLE TYRE CO., LTD.', type: 'Import', poDate: '2026-08-08', targetDate: '2026-09-22', currency: 'USD', amount: 69320, taxBasis: 'DPP / Tax excluded', allocated: 200, completed: 0, totalQty: 400, status: 'Pending approval', paymentTerm: 'L/C at sight', buyer: 'M. Rizky' },
  { id: 10, poNo: 'PO-20260805-005', supplier: 'PT. NUSANTARA RUBBER', type: 'Local', poDate: '2026-08-05', targetDate: '2026-08-24', currency: 'IDR', amount: 256000000, taxBasis: 'Tax included', allocated: 320, completed: 320, totalQty: 320, status: 'Confirmed', paymentTerm: 'TOP 14 days', buyer: 'D. Saputra' },
  { id: 11, poNo: 'PO-20260803-004', supplier: 'LINGLONG TIRE', type: 'Import', poDate: '2026-08-03', targetDate: '2026-09-18', currency: 'USD', amount: 118960, taxBasis: 'DPP / Tax excluded', allocated: 510, completed: 255, totalQty: 600, status: 'In production', paymentTerm: 'T/T 30% / 70%', buyer: 'A. Pratama' },
  { id: 12, poNo: 'PO-20260801-003', supplier: 'PT. SENTOSA BAN', type: 'Local', poDate: '2026-08-01', targetDate: '2026-08-20', currency: 'IDR', amount: 144500000, taxBasis: 'Tax included', allocated: 0, completed: 0, totalQty: 200, status: 'Draft', paymentTerm: 'CBD', buyer: 'D. Saputra' },
]
