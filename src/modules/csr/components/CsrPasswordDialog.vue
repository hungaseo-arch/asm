<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import { authApi } from '../api/neon'
import { useCsrSessionStore } from '../stores/session'
import { useCsrLang } from '../composables/useCsrLang'
import { useBodyScrollLock } from '@/composables/useBodyScrollLock'
import { useEscapeToClose } from '@/composables/useEscapeToClose'

const emit = defineEmits(['close'])
const session = useCsrSessionStore()
const { t } = useCsrLang()
useBodyScrollLock()
useEscapeToClose(() => emit('close'))

const current = ref('')
const next = ref('')
const confirm = ref('')
const busy = ref(false)
const error = ref('')
const done = ref(false)

// 접근성: 열릴 때 첫 입력으로 포커스, Tab 순환 가둠, 닫을 때 호출 버튼으로 복귀.
const dialogEl = ref(null)
const currentEl = ref(null)
const closeEl = ref(null)
let opener = null

onMounted(() => {
  opener = document.activeElement
  currentEl.value?.focus()
})
onBeforeUnmount(() => {
  if (opener && document.contains(opener)) opener.focus()
})

const FOCUSABLE =
  'button:not([disabled]):not([tabindex="-1"]), input:not([disabled]), a[href], [tabindex]:not([tabindex="-1"])'
function trapTab(event) {
  if (event.key !== 'Tab' || !dialogEl.value) return
  const items = [...dialogEl.value.querySelectorAll(FOCUSABLE)]
  if (!items.length) return
  const first = items[0]
  const last = items[items.length - 1]
  const active = document.activeElement
  if (event.shiftKey && (active === first || !dialogEl.value.contains(active))) {
    event.preventDefault()
    last.focus()
  } else if (!event.shiftKey && (active === last || !dialogEl.value.contains(active))) {
    event.preventDefault()
    first.focus()
  }
}

/**
 * 최소 8자만 강제합니다. 초기 비밀번호(ascendo123)를 그대로 두는 것만 막으면 되고,
 * 규칙을 더 걸면 현지 사용자가 로그인 자체를 못 하게 되는 쪽이 더 큰 문제입니다.
 */
const tooShort = computed(() => next.value.length > 0 && next.value.length < 8)
const mismatch = computed(() => confirm.value.length > 0 && next.value !== confirm.value)
const canSubmit = computed(
  () => current.value && next.value.length >= 8 && next.value === confirm.value && !busy.value,
)

async function submit() {
  if (!canSubmit.value) return
  busy.value = true
  error.value = ''
  try {
    const result = await authApi()?.changePassword({
      currentPassword: current.value,
      newPassword: next.value,
      // 다른 기기의 세션까지 끊습니다 — 비밀번호를 바꾸는 이유가 대개 그것입니다.
      revokeOtherSessions: true,
    })
    if (result?.error) {
      error.value =
        result.error.message ?? t('비밀번호를 바꾸지 못했습니다', 'Gagal mengubah kata sandi')
      return
    }
    done.value = true
    current.value = ''
    next.value = ''
    confirm.value = ''
    // 폼이 사라지면 포커스가 body 로 빠지므로 완료 화면의 닫기 버튼으로 옮깁니다.
    await nextTick()
    closeEl.value?.focus()
  } catch (e) {
    error.value = e.message || t('비밀번호를 바꾸지 못했습니다', 'Gagal mengubah kata sandi')
  } finally {
    // 실패해도 입력값은 남겨 둡니다 — 현재 비밀번호 오타만 고치면 다시 시도할 수 있게.
    busy.value = false
  }
}
</script>

<template>
  <!-- 가이드 8-5 — 오버레이 rgb(51 51 51 / .5) -->
  <div class="asm-overlay">
    <button
      type="button"
      class="asm-overlay__scrim"
      tabindex="-1"
      :aria-label="t('닫기', 'Tutup')"
      @click="emit('close')"
    ></button>

    <div
      ref="dialogEl"
      class="asm-panel dialog"
      role="dialog"
      aria-modal="true"
      aria-labelledby="pw-title"
      @keydown="trapTab"
    >
      <h2 id="pw-title" class="asm-title">{{ t('비밀번호 변경', 'Ubah kata sandi') }}</h2>

      <template v-if="done">
        <p class="ok" role="status">
          {{
            t(
              '비밀번호를 바꿨습니다. 다른 기기의 로그인은 해제되었습니다.',
              'Kata sandi telah diubah. Sesi di perangkat lain telah diakhiri.',
            )
          }}
        </p>
        <button ref="closeEl" type="button" class="btn btn-primary" @click="emit('close')">
          {{ t('닫기', 'Tutup') }}
        </button>
      </template>

      <form v-else @submit.prevent="submit">
        <p class="who">{{ session.user?.email }}</p>

        <label class="field">
          <span>{{ t('현재 비밀번호', 'Kata sandi saat ini') }}</span>
          <input
            ref="currentEl"
            v-model="current"
            type="password"
            name="current-password"
            class="form-control"
            autocomplete="current-password"
            required
          />
        </label>

        <label class="field">
          <span>{{ t('새 비밀번호', 'Kata sandi baru') }}</span>
          <input
            v-model="next"
            type="password"
            name="new-password"
            class="form-control"
            autocomplete="new-password"
            required
            :aria-invalid="tooShort"
            aria-describedby="pw-hint"
          />
          <small id="pw-hint" :class="{ warn: tooShort }">
            <svg v-if="tooShort" class="hint-icon" viewBox="0 0 16 16" aria-hidden="true">
              <path d="M8 1.5 15 14H1L8 1.5Z" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" />
              <path d="M8 6.5v4M8 12v.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
            </svg>
            {{
              tooShort
                ? t(
                    `8자 이상 필요합니다 (현재 ${next.length}자)`,
                    `Minimal 8 karakter (sekarang ${next.length})`,
                  )
                : t('8자 이상', 'minimal 8 karakter')
            }}
          </small>
        </label>

        <label class="field">
          <span>{{ t('새 비밀번호 확인', 'Konfirmasi kata sandi baru') }}</span>
          <input
            v-model="confirm"
            type="password"
            name="confirm-password"
            class="form-control"
            autocomplete="new-password"
            required
            :aria-invalid="mismatch"
            :aria-describedby="mismatch ? 'pw-mismatch' : undefined"
          />
          <small v-if="mismatch" id="pw-mismatch" class="warn">
            <svg class="hint-icon" viewBox="0 0 16 16" aria-hidden="true">
              <path d="M8 1.5 15 14H1L8 1.5Z" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" />
              <path d="M8 6.5v4M8 12v.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
            </svg>
            {{ t('두 값이 다릅니다', 'tidak cocok') }}
          </small>
        </label>

        <p v-if="error" class="err" role="alert">{{ error }}</p>

        <div class="actions">
          <button type="button" class="btn btn-outline-secondary" @click="emit('close')">
            {{ t('취소', 'Batal') }}
          </button>
          <button type="submit" class="btn btn-primary" :disabled="!canSubmit" :aria-busy="busy">
            {{ busy ? t('변경 중…', 'Mengubah…') : t('변경', 'Ubah') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.dialog {
  position: relative;
  margin: auto;
  width: min(420px, calc(100vw - 32px));
  max-height: calc(100vh - 64px);
  overflow-y: auto;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.who {
  margin: 0;
  font-size: 12px;
  color: var(--asm-fg-muted);
}
form {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.field {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.field span {
  font-size: 12px;
  font-weight: 500;
}
.field small {
  font-size: 12px;
  color: var(--asm-fg-muted);
}
/* .field small 보다 특정성이 높아야 색이 이깁니다 (!important 금지 — CONTRIBUTING §3) */
.field small.warn,
.field .warn {
  color: var(--asm-warning-fg);
}
.hint-icon {
  width: 12px;
  height: 12px;
  vertical-align: -1px;
  margin-right: 4px;
}
.err {
  margin: 0;
  font-size: 12px;
  color: var(--asm-danger);
}
.ok {
  margin: 0;
  font-size: 13px;
  color: var(--asm-success);
}
.actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
</style>
