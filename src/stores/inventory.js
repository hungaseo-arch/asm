import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { seedInventory } from '@/data/inventory'
import { AGED_STOCK_DAYS, valueOf } from '@/types/inventory'
export const useInventoryStore = defineStore('inventory', () => {
  // ── 상태 (State / Status) ────────────────────────────────────────────────
  const items = ref([...seedInventory])
  const loading = ref(false)
  const search = ref('')
  const warehouse = ref('All')
  const category = ref('All')
  const brand = ref('All')
  const size = ref('')
  const status = ref('All')
  const pageSize = ref(10)
  const page = ref(1)
  const sortKey = ref('qty')
  const sortAsc = ref(false)
  // ── 선택지 (Filter options / Pilihan filter) ────────────────────────────
  const distinct = (key) =>
    computed(() => [...new Set(items.value.map((item) => item[key]))].sort())
  const warehouseOptions = distinct('wh')
  const categoryOptions = distinct('cat')
  const brandOptions = distinct('brand')
  // ── 파생값 (Derived / Turunan) ──────────────────────────────────────────
  const filtered = computed(() => {
    const needle = search.value.trim().toLowerCase()
    const sizeNeedle = size.value.trim().toUpperCase()
    const result = items.value.filter((item) => {
      const haystack = `${item.code} ${item.size} ${item.pattern}`.toLowerCase()
      return (
        (!needle || haystack.includes(needle)) &&
        (warehouse.value === 'All' || item.wh === warehouse.value) &&
        (category.value === 'All' || item.cat === category.value) &&
        (brand.value === 'All' || item.brand === brand.value) &&
        (!sizeNeedle || item.size.toUpperCase().includes(sizeNeedle)) &&
        (status.value === 'All' || item.status === status.value)
      )
    })
    const direction = sortAsc.value ? 1 : -1
    return [...result].sort((a, b) => {
      const av = sortKey.value === 'value' ? valueOf(a) : a[sortKey.value]
      const bv = sortKey.value === 'value' ? valueOf(b) : b[sortKey.value]
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
  // ── 합계·KPI — 현재 필터 결과 전체 기준 (페이지 단위 아님) ──────────────
  const totalQty = computed(() => filtered.value.reduce((sum, item) => sum + item.qty, 0))
  const totalReserved = computed(() => filtered.value.reduce((sum, item) => sum + item.rsv, 0))
  const totalAvailable = computed(() => totalQty.value - totalReserved.value)
  const totalValue = computed(() => filtered.value.reduce((sum, item) => sum + valueOf(item), 0))
  /** 버퍼 미달 + 결품 SKU — 재발주 검토 대상 */
  const belowBufferCount = computed(
    () => filtered.value.filter((item) => item.status === 'low' || item.status === 'out').length,
  )
  /** 장기재고 SKU (365일 초과) */
  const agedCount = computed(
    () => filtered.value.filter((item) => item.aging > AGED_STOCK_DAYS).length,
  )
  // ── 액션 (Actions / Tindakan) ───────────────────────────────────────────
  function resetFilters() {
    search.value = ''
    warehouse.value = 'All'
    category.value = 'All'
    brand.value = 'All'
    size.value = ''
    status.value = 'All'
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
  return {
    items,
    loading,
    search,
    warehouse,
    category,
    brand,
    size,
    status,
    pageSize,
    page,
    sortKey,
    sortAsc,
    warehouseOptions,
    categoryOptions,
    brandOptions,
    filtered,
    pageCount,
    safePage,
    rows,
    rangeStart,
    rangeEnd,
    totalQty,
    totalReserved,
    totalAvailable,
    totalValue,
    belowBufferCount,
    agedCount,
    resetFilters,
    toggleSort,
    goToPage,
  }
})
