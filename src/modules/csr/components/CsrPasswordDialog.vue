<script setup>
import { computed, ref } from 'vue'
import { authApi } from '../api/neon'
import { useCsrSessionStore } from '../stores/session'
import { useBodyScrollLock } from '@/composables/useBodyScrollLock'
import { useEscapeToClose } from '@/composables/useEscapeToClose'

const emit = defineEmits(['close'])
const session = useCsrSessionStore()
useBodyScrollLock()
useEscapeToClose(() => emit('close'))

const current = ref('')
const next = ref('')
const confirm = ref('')
const busy = ref(false)
const error = ref('')
const done = ref(false)

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
      error.value = result.error.message ?? '비밀번호를 바꾸지 못했습니다'
      return
    }
    done.value = true
  } catch (e) {
    error.value = e.message
  } finally {
    busy.value = false
    current.value = ''
    next.value = ''
    confirm.value = ''
  }
}
</script>

<template>
  <!-- 가이드 8-5 — 오버레이 rgb(51 51 51 / .5) -->
  <div class="asm-overlay">
    <button
      type="button"
      class="asm-overlay__scrim"
      aria-label="닫기"
      @click="emit('close')"
    ></button>

    <div class="asm-panel dialog" role="dialog" aria-modal="true" aria-labelledby="pw-title">
      <h2 id="pw-title" class="asm-title">비밀번호 변경 · Ubah Kata Sandi</h2>

      <template v-if="done">
        <p class="ok">비밀번호를 바꿨습니다. 다른 기기의 로그인은 해제되었습니다.</p>
        <button type="button" class="btn btn-primary" @click="emit('close')">닫기</button>
      </template>

      <form v-else @submit.prevent="submit">
        <p class="who">{{ session.user?.email }}</p>

        <label class="field">
          <span>현재 비밀번호 · Kata sandi saat ini</span>
          <input
            v-model="current"
            type="password"
            class="form-control"
            autocomplete="current-password"
            required
          />
        </label>

        <label class="field">
          <span>새 비밀번호 · Kata sandi baru</span>
          <input
            v-model="next"
            type="password"
            class="form-control"
            autocomplete="new-password"
            required
          />
          <small :class="{ warn: tooShort }">8자 이상 · minimal 8 karakter</small>
        </label>

        <label class="field">
          <span>새 비밀번호 확인 · Konfirmasi</span>
          <input
            v-model="confirm"
            type="password"
            class="form-control"
            autocomplete="new-password"
            required
          />
          <small v-if="mismatch" class="warn">두 값이 다릅니다 · tidak cocok</small>
        </label>

        <p v-if="error" class="err" role="alert">{{ error }}</p>

        <div class="actions">
          <button type="button" class="btn btn-outline-secondary" @click="emit('close')">
            취소
          </button>
          <button type="submit" class="btn btn-primary" :disabled="!canSubmit">
            {{ busy ? '변경 중…' : '변경' }}
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
  font-size: 11px;
  color: var(--asm-fg-muted);
}
/* .field small 보다 특정성이 높아야 색이 이깁니다 (!important 금지 — CONTRIBUTING §3) */
.field small.warn,
.field .warn {
  color: var(--asm-warning-fg);
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
