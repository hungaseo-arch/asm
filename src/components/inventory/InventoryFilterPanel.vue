<script setup>
import { storeToRefs } from 'pinia'
import { useInventoryStore } from '@/stores/inventory'
import { STATUS_LABEL, STOCK_STATUSES } from '@/types/inventory'
const store = useInventoryStore()
const { search, warehouse, category, brand, size, status, filtered } = storeToRefs(store)
const { warehouseOptions, categoryOptions, brandOptions } = storeToRefs(store)
/** 필터를 바꾸면 항상 1페이지로 되돌립니다. */
function onFilterChange() {
  store.page = 1
}
</script>

<template>
  <section class="asm-panel filter-panel mb-3">
    <div class="panel-title">
      <div class="d-flex align-items-center gap-2">
        <SlidersHorizontal :size="17" />
        <b>Filters</b>
        <span class="count-pill">{{ filtered.length }} SKU</span>
      </div>
      <button type="button" class="btn btn-link text-button" @click="store.resetFilters()">
        <FilterX :size="15" />
        Reset all
      </button>
    </div>

    <div class="filters">
      <label class="search-field">
        <span class="form-label">Search</span>
        <div class="position-relative">
          <Search :size="16" class="field-icon" />
          <input
            v-model="search"
            type="search"
            class="form-control ps-5"
            placeholder="Item code, size, pattern"
            @input="onFilterChange"
          />
        </div>
      </label>

      <label>
        <span class="form-label">Warehouse / Gudang</span>
        <select v-model="warehouse" class="form-select" @change="onFilterChange">
          <option value="All">All</option>
          <option v-for="option in warehouseOptions" :key="option" :value="option">
            {{ option }}
          </option>
        </select>
      </label>

      <label>
        <span class="form-label">Category / Kategori</span>
        <select v-model="category" class="form-select" @change="onFilterChange">
          <option value="All">All</option>
          <option v-for="option in categoryOptions" :key="option" :value="option">
            {{ option }}
          </option>
        </select>
      </label>

      <label>
        <span class="form-label">Brand / Merek</span>
        <select v-model="brand" class="form-select" @change="onFilterChange">
          <option value="All">All</option>
          <option v-for="option in brandOptions" :key="option" :value="option">{{ option }}</option>
        </select>
      </label>

      <label>
        <span class="form-label">Size / Ukuran</span>
        <div class="position-relative">
          <Ruler :size="15" class="field-icon" />
          <!-- 규격에는 콤마를 쓰지 않습니다 (사내 표기 규칙) -->
          <input
            v-model="size"
            type="text"
            class="form-control ps-5"
            placeholder="1200R24"
            @input="onFilterChange"
          />
        </div>
      </label>

      <label>
        <span class="form-label">Status</span>
        <select v-model="status" class="form-select" @change="onFilterChange">
          <option value="All">All</option>
          <option v-for="option in STOCK_STATUSES" :key="option" :value="option">
            {{ STATUS_LABEL[option] }}
          </option>
        </select>
      </label>
    </div>
  </section>
</template>

<style scoped>
.filter-panel {
  padding: 16px;
}
.panel-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}
.panel-title b {
  font-size: 13px;
}
.count-pill {
  font-size: 11px;
  color: var(--asm-fg-muted);
  background: var(--asm-muted);
  border-radius: 20px;
  padding: 2px 8px;
}
.text-button {
  color: var(--asm-primary);
  display: inline-flex;
  gap: 4px;
  align-items: center;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 8px;
  min-height: auto;
  text-decoration: none;
  border-radius: var(--asm-radius-md);
}
.text-button:hover {
  background: var(--asm-muted);
}

.filters {
  display: grid;
  grid-template-columns: minmax(208px, 1.7fr) repeat(5, minmax(120px, 1fr));
  gap: 12px;
}
.filters label {
  display: block;
  min-width: 0;
  margin: 0;
}
.field-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--asm-fg-muted);
  pointer-events: none;
}

@media (max-width: 1150px) {
  .filters {
    grid-template-columns: repeat(3, 1fr);
  }
  .search-field {
    grid-column: span 3;
  }
}
@media (max-width: 767.98px) {
  .filters {
    grid-template-columns: repeat(2, 1fr);
  }
  .search-field {
    grid-column: span 2;
  }
}
</style>
