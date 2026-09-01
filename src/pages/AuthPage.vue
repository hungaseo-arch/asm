<script setup lang="ts">
/**
 * 로그인 / 가입 / 이메일 인증 화면.
 *
 * 이식 시 반드시 유지해야 하는 4가지 규칙 (React 원본 주석과 동일한 계약):
 *  1. 3-상태 세션 판정 — 세션 확인(loading)이 끝나기 전에는 판단하지 않는다.
 *     "로딩"을 "비로그인"으로 취급하면 로그인 직후 첫 렌더에서 다시 튕긴다.
 *  2. 역방향 가드 — 이미 로그인된 사용자는 이 화면에 머무르지 않는다.
 *  3. 성공 시 라우터로 이동한다. window.location.reload() 금지 —
 *     SPA에서 reload는 이 로그인 라우트를 다시 그릴 뿐이다.
 *     Bearer 토큰은 lib/auth.ts 가 이미 저장해 두었다.
 *  4. 외부 인증(verify-code)은 Better Auth 엔드포인트가 아니므로 클라이언트
 *     세션이 자동 갱신되지 않는다. 화면을 떠나기 전에 세션을 refetch 한다.
 */
import { computed, onUnmounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { authClient } from '@/lib/auth'
import { apiFetch } from '@/lib/api'
import { normalizeApiError, readResponseBody } from '@/lib/api-error'
import { useSessionStore } from '@/stores/session'

const route = useRoute()
const router = useRouter()
const session = useSessionStore()

const mode = ref<'signin' | 'signup'>('signin')
const name = ref('')
const email = ref('')
const password = ref('')
const verificationCode = ref('')
const pendingVerificationEmail = ref('')
const resendAvailableAt = ref(0)
const now = ref(Date.now())
const submitting = ref(false)

let timer: number | undefined
function startCountdown() {
  window.clearInterval(timer)
  timer = window.setInterval(() => {
    now.value = Date.now()
    if (now.value >= resendAvailableAt.value) window.clearInterval(timer)
  }, 1000)
}
onUnmounted(() => window.clearInterval(timer))

const verificationEmail = computed(
  () =>
    pendingVerificationEmail.value ||
    (!session.isEmailVerified ? (session.user?.email ?? '') : ''),
)
const resendWaitSeconds = computed(() =>
  Math.max(0, Math.ceil((resendAvailableAt.value - now.value) / 1000)),
)

const redirectTarget = computed(() => (route.query.redirect as string | undefined) ?? '/')

async function onSubmit() {
  submitting.value = true
  try {
    const result =
      mode.value === 'signup'
        ? await authClient.signUp.email({ name: name.value, email: email.value, password: password.value })
        : await authClient.signIn.email({ email: email.value, password: password.value })

    if (result.error) {
      throw new Error(result.error.message ?? 'Authentication failed')
    }

    if (mode.value === 'signup') {
      await sendVerificationCode()
      pendingVerificationEmail.value = email.value
      toast.success('인증 코드를 발송했습니다')
      return
    }

    toast.success('로그인되었습니다')
    // (3) 라우터로 이동 — reload 금지
    void router.replace(redirectTarget.value)
  } catch (error) {
    toast.error(error instanceof Error ? error.message : 'Authentication failed')
  } finally {
    submitting.value = false
  }
}

async function sendVerificationCode() {
  const response = await apiFetch('/email-verification/send-code', { method: 'POST', auth: true })
  if (!response.ok) {
    const body = await readResponseBody(response)
    const retryAfterSeconds =
      body && typeof body === 'object' && 'data' in body
        ? Number((body.data as { retryAfterSeconds?: unknown } | null)?.retryAfterSeconds ?? 0)
        : 0
    if (retryAfterSeconds > 0) {
      now.value = Date.now()
      resendAvailableAt.value = Date.now() + retryAfterSeconds * 1000
      startCountdown()
    }
    throw new Error(normalizeApiError(body).message)
  }
  now.value = Date.now()
  resendAvailableAt.value = Date.now() + 60 * 1000
  startCountdown()
}

async function onVerifyCode() {
  submitting.value = true
  try {
    const response = await apiFetch('/email-verification/verify-code', {
      method: 'POST',
      auth: true,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ code: verificationCode.value }),
    })
    if (!response.ok) {
      throw new Error(normalizeApiError(await readResponseBody(response)).message)
    }

    // (4) 화면을 떠나기 전에 세션 갱신
    await session.refetch()

    toast.success('이메일 인증이 완료되었습니다')
    void router.replace(redirectTarget.value)
  } catch (error) {
    toast.error(error instanceof Error ? error.message : 'Verification failed')
  } finally {
    submitting.value = false
  }
}

async function onResendCode() {
  submitting.value = true
  try {
    await sendVerificationCode()
    toast.success('인증 코드를 다시 보냈습니다')
  } catch (error) {
    toast.error(error instanceof Error ? error.message : 'Failed to resend code')
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <!-- (1) 로딩: 세션 확인이 끝나기 전에는 판단하지 않습니다. -->
  <div v-if="session.isPending" class="auth-screen">
    <div class="spinner-border text-primary" role="status">
      <span class="visually-hidden">확인 중…</span>
    </div>
  </div>

  <!-- 이메일 인증 코드 입력 -->
  <div v-else-if="verificationEmail" class="auth-screen">
    <div class="asm-panel auth-card">
      <div class="asm-accent-line"></div>
      <div class="card-head">
        <div class="brand-mark">A</div>
        <h1>이메일 인증</h1>
        <p><b>{{ verificationEmail }}</b> 으로 보낸 6자리 코드를 입력하세요.</p>
      </div>
      <form class="card-body-form" @submit.prevent="onVerifyCode">
        <label class="d-block mb-3">
          <span class="form-label">인증 코드 (Verification code)</span>
          <input
            v-model="verificationCode"
            class="form-control code-input"
            inputmode="numeric"
            maxlength="6"
            placeholder="000000"
            required
          />
        </label>
        <button class="btn btn-primary w-100" type="submit" :disabled="submitting">
          인증 완료
        </button>
        <button
          class="btn btn-link w-100 mt-2"
          type="button"
          :disabled="submitting || resendWaitSeconds > 0"
          @click="onResendCode"
        >
          {{ resendWaitSeconds > 0 ? `${resendWaitSeconds}초 후 재발송 가능` : '인증 코드 재발송' }}
        </button>
      </form>
    </div>
  </div>

  <!-- 로그인 / 가입 -->
  <div v-else class="auth-screen">
    <div class="asm-panel auth-card">
      <div class="asm-accent-line"></div>
      <div class="card-head">
        <div class="brand-mark">A</div>
        <h1>ASM</h1>
        <p>Ascendo Management System</p>
      </div>

      <div class="mode-tabs" role="tablist">
        <button
          type="button" role="tab" :aria-selected="mode === 'signin'"
          :class="{ active: mode === 'signin' }" @click="mode = 'signin'"
        >
          로그인
        </button>
        <button
          type="button" role="tab" :aria-selected="mode === 'signup'"
          :class="{ active: mode === 'signup' }" @click="mode = 'signup'"
        >
          가입
        </button>
      </div>

      <form class="card-body-form" @submit.prevent="onSubmit">
        <label v-if="mode === 'signup'" class="d-block mb-3">
          <span class="form-label">이름 (Name / Nama)</span>
          <input v-model="name" class="form-control" autocomplete="name" required />
        </label>
        <label class="d-block mb-3">
          <span class="form-label">이메일 (Email)</span>
          <input v-model="email" type="email" class="form-control" autocomplete="email" required />
        </label>
        <label class="d-block mb-3">
          <span class="form-label">비밀번호 (Password / Kata sandi)</span>
          <input
            v-model="password" type="password" class="form-control"
            :autocomplete="mode === 'signup' ? 'new-password' : 'current-password'"
            minlength="8" required
          />
        </label>
        <button class="btn btn-primary w-100" type="submit" :disabled="submitting">
          {{ mode === 'signup' ? '가입하기' : '로그인' }}
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.auth-screen {
  min-height: 100vh;
  display: grid;
  place-items: center;
  background: var(--asm-page-bg);
  padding: 24px 16px;
}
.auth-card { width: min(420px, 100%); overflow: hidden; }
.asm-accent-line { height: var(--asm-accent-h); background: var(--asm-primary); }
.card-head { padding: 24px 24px 12px; text-align: center; }
.brand-mark {
  width: 44px;
  height: 44px;
  margin: 0 auto 12px;
  background: var(--asm-primary);
  color: var(--asm-primary-fg);
  border-radius: var(--asm-radius-lg);
  display: grid;
  place-items: center;
  font-weight: 800;
  font-size: 22px;
}
.card-head h1 { font-size: 20px; margin: 0 0 4px; letter-spacing: 0.04em; font-weight: 600; }
.card-head p { font-size: 12px; color: var(--asm-fg-muted); margin: 0; }
.card-body-form { padding: 8px 24px 24px; }

.mode-tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px;
  margin: 16px 24px 4px;
  background: var(--asm-muted);
  border-radius: var(--asm-radius-lg);
  padding: 4px;
}
.mode-tabs button {
  border: 0;
  background: transparent;
  border-radius: var(--asm-radius-md);
  height: 32px;
  font-size: 13px;
  font-weight: 600;
  color: var(--asm-fg-muted);
}
.mode-tabs button.active {
  background: var(--asm-bg);
  color: var(--asm-primary);
  box-shadow: var(--asm-shadow-xs);
}

.code-input {
  text-align: center;
  letter-spacing: 0.5em;
  font-family: var(--bs-font-monospace);
  font-size: 20px;
}
</style>
