<script setup lang="ts">
import { ChevronsUpDown } from 'lucide-vue-next'

withDefaults(
  defineProps<{
    label: string
    active: boolean
    asc: boolean
    align?: 'left' | 'right' | 'center'
    sticky?: 'first' | 'second'
  }>(),
  { align: 'left' },
)

defineEmits<{ (event: 'sort'): void }>()
</script>

<template>
  <th
    scope="col"
    :class="[
      align === 'right' ? 'text-end' : align === 'center' ? 'text-center' : '',
      sticky ? `asm-sticky-col is-${sticky}` : '',
    ]"
    :aria-sort="active ? (asc ? 'ascending' : 'descending') : 'none'"
  >
    <button
      type="button"
      class="sort-button"
      :class="{
        active,
        'justify-content-end': align === 'right',
        'justify-content-center': align === 'center',
      }"
      @click="$emit('sort')"
    >
      {{ label }}
      <ChevronsUpDown :size="13" aria-hidden="true" />
      <span class="visually-hidden">
        {{ active ? (asc ? '오름차순 정렬됨' : '내림차순 정렬됨') : '정렬 안 됨' }}
      </span>
    </button>
  </th>
</template>

<style scoped>
.sort-button {
  width: 100%;
  height: 40px;
  padding: 0;
  border: 0;
  background: transparent;
  color: inherit;
  text-transform: inherit;
  letter-spacing: inherit;
  font-size: inherit;
  font-weight: inherit;
  display: flex;
  align-items: center;
  gap: 5px;
}
.sort-button.active { color: var(--asm-primary); }
</style>
