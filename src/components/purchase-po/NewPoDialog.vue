<script setup>
import { computed, nextTick, onMounted, ref } from 'vue'
import AsmDateInput from '@/components/common/AsmDateInput.vue'
import * as yup from 'yup'
import { groupAmountInput, parseAmountInput } from '@/utils/format'
import { useBodyScrollLock } from '@/composables/useBodyScrollLock'
import { useEscapeToClose } from '@/composables/useEscapeToClose'
const props = defineProps({ autoPoNo: { type: String, required: true } })
const emit = defineEmits(['close', 'submit'])
useBodyScrollLock()
useEscapeToClose(() => emit('close'))
const supplier = ref('')
const type = ref('Import')
const currency = ref('USD')
const amount = ref('')
const targetDate = ref('')
const errors = ref({})
const formEl = ref(null)
// 가이드 7-5 — 모달이 열리면 첫 입력창에 포커스를 둡니다.
onMounted(() => {
  const fields = formEl.value?.querySelectorAll('.dialog-body input, .dialog-body select')
  Array.from(fields ?? [])
    .find((el) => !el.disabled)
    ?.focus()
})
const errorCount = computed(() => Object.keys(errors.value).length)
const basisNote = computed(() =>
  currency.value === 'IDR'
    ? 'Tax included · IDR 금액은 소수점을 표기하지 않습니다.'
    : 'DPP / Tax excluded · USD 금액은 소수점 둘째 자리까지 표기합니다.',
)
/** 구매 구분을 바꾸면 통화 기본값도 함께 맞춥니다. */
function onTypeChange() {
  currency.value = type.value === 'Import' ? 'USD' : 'IDR'
}
function onAmountInput(event) {
  amount.value = groupAmountInput(event.target.value)
}
/** 신규 발주 입력 검증 스키마 (yup) */
const schema = yup.object({
  supplier: yup.string().trim().required('공급사는 필수 입력 항목입니다.'),
  targetDate: yup
    .string()
    .required('목표일은 필수 입력 항목입니다.')
    .matches(/^d{4}-d{2}-d{2}$/, '목표일은 YYYY-MM-DD 형식으로 입력하세요.'),
  amount: yup
    .number()
    .typeError('0보다 큰 금액을 입력하세요.')
    .positive('0보다 큰 금액을 입력하세요.')
    .required('0보다 큰 금액을 입력하세요.'),
})

function submit() {
  const parsedAmount = parseAmountInput(amount.value)
  const next = {}
  try {
    // 미입력 항목을 한 번에 모으기 위해 abortEarly: false 로 검증합니다.
    schema.validateSync(
      { supplier: supplier.value, targetDate: targetDate.value, amount: parsedAmount || undefined },
      { abortEarly: false },
    )
  } catch (error) {
    for (const item of error.inner ?? []) {
      if (item.path && !next[item.path]) next[item.path] = item.message
    }
  }
  errors.value = next
  if (Object.keys(next).length) {
    // 미입력 항목을 한 번에 표시하고 첫 오류 항목으로 포커스를 옮깁니다 (이슈 25).
    void nextTick(() => {
      formEl.value?.querySelector('.field.is-invalid :is(input, select)')?.focus()
    })
    return
  }
  emit('submit', {
    supplier: supplier.value.trim(),
    type: type.value,
    currency: currency.value,
    amount: parsedAmount,
    targetDate: targetDate.value,
  })
}
</script>

<template>
  <div class="asm-overlay justify-content-center align-items-center p-3">
    <button
      type="button"
      class="asm-overlay__scrim"
      aria-label="닫기"
      @click="emit('close')"
    ></button>

    <form
      ref="formEl"
      class="dialog"
      role="dialog"
      aria-modal="true"
      aria-labelledby="new-po-title"
      @submit.prevent="submit"
    >
      <header>
        <div>
          <p class="asm-eyebrow mb-1">NEW PURCHASE ORDER</p>
          <h2 id="new-po-title">Create purchase PO</h2>
        </div>
        <button
          type="button"
          class="asm-icon-btn is-borderless"
          aria-label="닫기"
          @click="emit('close')"
        >
          <X :size="19" />
        </button>
      </header>

      <div class="dialog-body">
        <div v-if="errorCount" class="error-summary" role="alert">
          <b>필수 항목 {{ errorCount }}개를 확인하세요.</b>
          <span>아래 강조된 항목을 입력해 주세요.</span>
        </div>

        <label class="field">
          <span class="form-label">PO number</span>
          <input :value="props.autoPoNo" class="form-control" disabled />
          <small class="hint">저장 시 자동 채번됩니다</small>
        </label>

        <label class="field" :class="{ 'is-invalid': errors.supplier }">
          <span class="form-label">Supplier <b class="req">*</b></span>
          <input
            v-model="supplier"
            class="form-control"
            placeholder="공급사를 선택하거나 입력하세요"
          />
          <small v-if="errors.supplier" class="error-text">{{ errors.supplier }}</small>
        </label>

        <div class="form-row">
          <label class="field">
            <span class="form-label">Purchase type</span>
            <select v-model="type" class="form-select" @change="onTypeChange">
              <option value="Import">Import</option>
              <option value="Local">Local</option>
            </select>
          </label>
          <label class="field">
            <span class="form-label">Currency</span>
            <select v-model="currency" class="form-select">
              <option value="USD">USD</option>
              <option value="IDR">IDR</option>
            </select>
          </label>
        </div>

        <div class="form-row">
          <label class="field" :class="{ 'is-invalid': errors.amount }">
            <span class="form-label">PO amount <b class="req">*</b></span>
            <div class="amount-input">
              <em>{{ currency }}</em>
              <input
                :value="amount"
                inputmode="decimal"
                class="form-control"
                :placeholder="currency === 'IDR' ? '1,225,526,558' : '108,800.00'"
                @input="onAmountInput"
              />
            </div>
            <small v-if="errors.amount" class="error-text">{{ errors.amount }}</small>
          </label>
          <label class="field" :class="{ 'is-invalid': errors.targetDate }">
            <span class="form-label">Target date <b class="req">*</b></span>
            <AsmDateInput v-model="targetDate" aria-label="Target date" min="2026-09-01" />
            <small v-if="errors.targetDate" class="error-text">{{ errors.targetDate }}</small>
          </label>
        </div>

        <div class="basis-note">
          <b>Amount basis</b>
          <span>{{ basisNote }}</span>
        </div>
      </div>

      <footer>
        <button type="button" class="btn btn-secondary" @click="emit('close')">Cancel</button>
        <button type="submit" class="btn btn-primary">Save as draft</button>
      </footer>
    </form>
  </div>
</template>

<style scoped>
/* 가이드 8-5 — 일반 폼 모달 최대폭 560px · radius-lg · shadow-lg · 상단 4px 블루 액센트 */
.dialog {
  position: relative;
  width: min(560px, 100%);
  max-height: calc(100vh - 32px);
  background: var(--asm-card);
  border-radius: var(--asm-radius-xl);
  border-top: 4px solid var(--asm-primary);
  box-shadow: var(--asm-shadow-lg);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  animation: popIn 0.15s ease-out;
}
.dialog > header {
  min-height: 76px;
  padding: 16px 24px;
  border-bottom: 1px solid var(--asm-border);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}
.dialog > header h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
}
.dialog-body {
  padding: 24px;
  overflow-y: auto;
}
.field {
  display: block;
  margin-bottom: 16px;
}
.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-bottom: 0;
}
.req {
  color: var(--bs-danger);
}
.hint {
  display: block;
  font-size: 11px;
  color: var(--asm-fg-muted);
  margin-top: 4px;
}
.error-text {
  display: block;
  font-size: 11px;
  color: var(--asm-danger-fg);
  margin-top: 4px;
}

/* 가이드 7-2 오류 — 테두리 danger-border + 하단 오류 문구. 별도 링은 쓰지 않습니다. */
.field.is-invalid .form-control,
.field.is-invalid .form-select {
  border-color: var(--asm-danger-border);
}

.error-summary {
  background: var(--asm-danger-bg);
  border-left: 3px solid var(--bs-danger);
  padding: 12px;
  margin-bottom: 16px;
  border-radius: 0 var(--asm-radius-md) var(--asm-radius-md) 0;
}
.error-summary b {
  display: block;
  font-size: 12px;
  color: var(--asm-danger-fg);
}
.error-summary span {
  display: block;
  font-size: 11px;
  color: var(--asm-danger-fg);
  margin-top: 4px;
}

.amount-input {
  position: relative;
}
.amount-input em {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 11px;
  font-style: normal;
  font-weight: 700;
  color: var(--asm-fg-muted);
  z-index: 2;
}
.amount-input .form-control {
  padding-left: 48px;
  font-family: var(--bs-font-monospace);
}

.basis-note {
  background: var(--asm-muted);
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-md);
  padding: 12px;
  margin-top: 16px;
}
.basis-note b {
  display: block;
  font-size: 11px;
}
.basis-note span {
  display: block;
  font-size: 11px;
  color: var(--asm-fg-muted);
  margin-top: 4px;
}

.dialog > footer {
  margin-top: auto;
  min-height: 68px;
  border-top: 1px solid var(--asm-border);
  padding: 16px 24px;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  background: var(--asm-card);
}

@keyframes popIn {
  from {
    transform: translateY(8px);
    opacity: 0.65;
  }
  to {
    transform: none;
    opacity: 1;
  }
}
</style>
