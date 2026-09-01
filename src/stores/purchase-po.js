import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { seedPurchaseOrders } from '@/data/purchase-orders'
const DEFAULT_FROM_DATE = '2026-08-01'
const DEFAULT_TO_DATE = '2026-09-01'
export const usePurchasePoStore = defineStore('purchase-po', () => {
  // ── 상태 (State / Status) ────────────────────────────────────────────────
  const orders = ref([...seedPurchaseOrders])
  const loading = ref(false)
  const search = ref('')
  const status = ref('All')
  const type = ref('All')
  const currency = ref('All')
  const fromDate = ref(DEFAULT_FROM_DATE)
  const toDate = ref(DEFAULT_TO_DATE)
  const pageSize = ref(10)
  const page = ref(1)
  const sortKey = ref('poDate')
  const sortAsc = ref(false)
  // ── 파생값 (Derived / Turunan) ──────────────────────────────────────────
  const filtered = computed(() => {
    const needle = search.value.trim().toLowerCase()
    const result = orders.value.filter((order) => {
      const haystack = `${order.poNo} ${order.supplier} ${order.buyer}`.toLowerCase()
      return (
        (!needle || haystack.includes(needle)) &&
        (status.value === 'All' || order.status === status.value) &&
        (type.value === 'All' || order.type === type.value) &&
        (currency.value === 'All' || order.currency === currency.value) &&
        (!fromDate.value || order.poDate >= fromDate.value) &&
        (!toDate.value || order.poDate <= toDate.value)
      )
    })
    const direction = sortAsc.value ? 1 : -1
    return [...result].sort((a, b) => {
      const av = a[sortKey.value]
      const bv = b[sortKey.value]
      if (typeof av === 'number' && typeof bv === 'number') return (av - bv) * direction
      return String(av).localeCompare(String(bv)) * direction
    })
  })
  const pageCount = computed(() => Math.max(1, Math.ceil(filtered.value.length / pageSize.value)))
  const safePage = computed(() => Math.min(page.value, pageCount.value))
  const rows = computed(() =>
    filtered.value.slice((safePage.value - 1) * pageSize.value, safePage.value * pageSize.value),
  )
  const rangeStart = computed(() =>
    filtered.value.length ? (safePage.value - 1) * pageSize.value + 1 : 0,
  )
  const rangeEnd = computed(() => Math.min(safePage.value * pageSize.value, filtered.value.length))
  /** 승인 대기 건수 (Pending approval count) */
  const pendingApprovalCount = computed(
    () => filtered.value.filter((order) => order.status === 'Pending approval').length,
  )
  /** Draft 제외 IDR 확정 금액 합계 */
  const confirmedIdrTotal = computed(() =>
    filtered.value
      .filter((order) => order.currency === 'IDR' && order.status !== 'Draft')
      .reduce((sum, order) => sum + order.amount, 0),
  )
  /** 생산 진행 중 · 완성률 50% 미만 = 생산 리스크 */
  const productionRiskCount = computed(
    () =>
      filtered.value.filter(
        (order) =>
          order.status === 'In production' &&
          order.totalQty > 0 &&
          order.completed / order.totalQty < 0.5,
      ).length,
  )
  // ── 액션 (Actions / Tindakan) ───────────────────────────────────────────
  function resetFilters() {
    search.value = ''
    status.value = 'All'
    type.value = 'All'
    currency.value = 'All'
    fromDate.value = DEFAULT_FROM_DATE
    toDate.value = DEFAULT_TO_DATE
    page.value = 1
  }
  function toggleSort(key) {
    if (sortKey.value === key) {
      sortAsc.value = !sortAsc.value
    } else {
      sortKey.value = key
      sortAsc.value = true
    }
    page.value = 1
  }
  function goToPage(next) {
    page.value = Math.min(Math.max(1, next), pageCount.value)
  }
  function addOrder(input) {
    const sequence = orders.value.length + 3
    const nextOrder = {
      id: Math.max(...orders.value.map((order) => order.id)) + 1,
      poNo: `PO-20260901-${String(sequence).padStart(3, '0')}`,
      supplier: input.supplier,
      type: input.type,
      poDate: '2026-09-01',
      targetDate: input.targetDate,
      currency: input.currency,
      amount: input.amount,
      taxBasis: input.currency === 'IDR' ? 'Tax included' : 'DPP / Tax excluded',
      allocated: 0,
      completed: 0,
      totalQty: 0,
      status: 'Draft',
      paymentTerm: input.type === 'Import' ? 'T/T 30% / 70%' : 'TOP 30 days',
      buyer: 'Current user',
    }
    orders.value = [nextOrder, ...orders.value]
    page.value = 1
    return nextOrder
  }
  /** 다음 자동 채번 (Auto PO number / Nomor PO otomatis) */
  const nextPoNo = computed(() => `PO-20260901-${String(orders.value.length + 3).padStart(3, '0')}`)
  return {
    orders,
    loading,
    search,
    status,
    type,
    currency,
    fromDate,
    toDate,
    pageSize,
    page,
    sortKey,
    sortAsc,
    filtered,
    pageCount,
    safePage,
    rows,
    rangeStart,
    rangeEnd,
    pendingApprovalCount,
    confirmedIdrTotal,
    productionRiskCount,
    nextPoNo,
    resetFilters,
    toggleSort,
    goToPage,
    addOrder,
  }
})
