<script setup>
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
import { authClient } from '@/api/auth'
import { apiFetch } from '@/api/api'
import { normalizeApiError, readResponseBody } from '@/api/api-error'
import { useSessionStore } from '@/stores/session'
const route = useRoute()
const router = useRouter()
const session = useSessionStore()
const mode = ref('signin')
const name = ref('')
const email = ref('')
const password = ref('')
const verificationCode = ref('')
const pendingVerificationEmail = ref('')
const resendAvailableAt = ref(0)
const now = ref(Date.now())
const submitting = ref(false)
let timer
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
    pendingVerificationEmail.value || (!session.isEmailVerified ? (session.user?.email ?? '') : ''),
)
const resendWaitSeconds = computed(() =>
  Math.max(0, Math.ceil((resendAvailableAt.value - now.value) / 1000)),
)
const redirectTarget = computed(() => route.query.redirect ?? '/')
async function onSubmit() {
  submitting.value = true
  try {
    const result =
      mode.value === 'signup'
        ? await authClient.signUp.email({
            name: name.value,
            email: email.value,
            password: password.value,
          })
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
        ? Number(body.data?.retryAfterSeconds ?? 0)
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
  <!--
    가이드 7-4 — 명함 앞면(AS 01) 구성 응용. 좌측 45% 는 브랜드 블루 전면 + 중앙 White
    시그니처 + 우하단 심볼 워터마크(White 10%, 가이드 4-4), 우측 55% 는 흰 배경 폼입니다.
    로딩·이메일 인증·로그인 세 상태가 같은 골격을 공유하고 우측 내용만 바뀝니다.
  -->
  <div class="auth-screen">
    <aside class="auth-brand asm-motif asm-motif--invert">
      <!--
        White 반전 시그니처 — 가이드 4-1/BS 06 은 블루 바탕에 White 반전 시그니처를
        규정하지만 원본 벡터(White 반전본)가 아직 없어, 가이드 4-1 각주와 같은 방식으로
        Full Color 원본을 흰 실루엣으로 눕혀 임시 표시합니다. BI 담당 부서에서 White
        반전 원본(AI/SVG)을 받으면 이 img 의 src 만 교체하고 .is-reversed 를 지우면
        됩니다 — 그 전까지는 BS 07 "컬러 임의 변경"에 해당하는 임시 표기입니다.
      -->
      <img
        src="/img/ascendo-logo-horizontal.png"
        alt="ASCENDO"
        class="auth-signature is-reversed"
      />
      <p class="auth-tagline">Ascendo Management System</p>
    </aside>

    <div class="auth-form-col">
      <div class="auth-card">
        <!-- (1) 로딩: 세션 확인이 끝나기 전에는 판단하지 않습니다. -->
        <div v-if="session.isPending" class="auth-loading">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">확인 중…</span>
          </div>
        </div>

        <!-- 이메일 인증 코드 입력 -->
        <template v-else-if="verificationEmail">
          <div class="card-head">
            <h1>이메일 인증</h1>
            <p>
              <b>{{ verificationEmail }}</b> 으로 보낸 6자리 코드를 입력하세요.
            </p>
          </div>
          <form @submit.prevent="onVerifyCode">
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
            <!-- 가이드 8-1 Large — 로그인·모달 확정 버튼은 40px / 700 -->
            <button class="btn btn-primary btn-lg w-100" type="submit" :disabled="submitting">
              인증 완료
            </button>
            <button
              class="btn btn-link w-100 mt-2"
              type="button"
              :disabled="submitting || resendWaitSeconds > 0"
              @click="onResendCode"
            >
              {{
                resendWaitSeconds > 0 ? `${resendWaitSeconds}초 후 재발송 가능` : '인증 코드 재발송'
              }}
            </button>
          </form>
        </template>

        <!-- 로그인 / 가입 -->
        <template v-else>
          <div class="card-head">
            <h1>{{ mode === 'signup' ? '가입' : '로그인' }}</h1>
            <p>ASM 계정으로 계속하세요.</p>
          </div>

          <!-- 밑줄 탭 — 가이드 8-6(40px · 활성 Blue 700 + 하단 2px 블루선) -->
          <div class="asm-tabs mb-4" role="tablist">
            <button
              type="button"
              role="tab"
              class="tab"
              :aria-selected="mode === 'signin'"
              :class="{ 'is-active': mode === 'signin' }"
              @click="mode = 'signin'"
            >
              로그인
            </button>
            <button
              type="button"
              role="tab"
              class="tab"
              :aria-selected="mode === 'signup'"
              :class="{ 'is-active': mode === 'signup' }"
              @click="mode = 'signup'"
            >
              가입
            </button>
          </div>

          <form @submit.prevent="onSubmit">
            <label v-if="mode === 'signup'" class="d-block mb-3">
              <span class="form-label">이름 (Name / Nama)</span>
              <input v-model="name" class="form-control" autocomplete="name" required />
            </label>
            <label class="d-block mb-3">
              <span class="form-label">이메일 (Email)</span>
              <input
                v-model="email"
                type="email"
                class="form-control"
                autocomplete="email"
                required
              />
            </label>
            <label class="d-block mb-3">
              <span class="form-label">비밀번호 (Password / Kata sandi)</span>
              <input
                v-model="password"
                type="password"
                class="form-control"
                :autocomplete="mode === 'signup' ? 'new-password' : 'current-password'"
                minlength="8"
                required
              />
            </label>
            <button class="btn btn-primary btn-lg w-100" type="submit" :disabled="submitting">
              {{ mode === 'signup' ? '가입하기' : '로그인' }}
            </button>
          </form>
        </template>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 가이드 7-4 — 좌 45% Blue · 우 55% White 2분할 */
.auth-screen {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 45% 55%;
  background: var(--asm-card);
}

/*
 * 좌측 브랜드 면 — 브랜드 블루 전면. 워터마크는 .asm-motif--invert(가이드 4-4,
 * 블루 바탕 위 White 10%)가 우하단에 잘리게 깔아 줍니다.
 */
.auth-brand {
  background: var(--asm-primary);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  /* 가이드 6-2 — 로고와 아래 문구 사이 32px */
  gap: 32px;
  padding: 32px;
}
/* 가이드 7-4 — 시그니처 높이 48px. BS 07 비율 왜곡 금지로 width 는 auto. */
.auth-signature {
  height: 48px;
  width: auto;
  position: relative; /* 워터마크(::before) 위로 */
}
/* 임시 White 반전 — BI 원본 White 반전 시그니처를 받으면 이 클래스를 지웁니다. */
.auth-signature.is-reversed {
  filter: brightness(0) invert(1);
}
.auth-tagline {
  position: relative;
  margin: 0;
  color: var(--asm-primary-fg);
  font-size: 14px;
  font-weight: 300; /* 가이드 5-2 — 큰 부제는 Light(300) */
  letter-spacing: 0.06em;
  text-align: center;
}

.auth-form-col {
  display: grid;
  place-items: center;
  padding: 32px 24px;
  background: var(--asm-card);
}
/*
 * 폼 카드 — 가이드 7-4 최대폭 400px. 흰 면 위에 놓이므로 카드 테두리·배경은 두지
 * 않습니다(가이드 8-3 의 카드는 회색 바탕 위에서 떠오르는 용도).
 */
.auth-card {
  width: min(400px, 100%);
}
.auth-loading {
  display: grid;
  place-items: center;
  min-height: 200px;
}
.card-head {
  margin-bottom: 24px;
}
/* 가이드 7-4 — 폼 제목 20px / 700 */
.card-head h1 {
  font-size: 20px;
  margin: 0 0 4px;
}
.card-head p {
  font-size: 12.5px;
  color: var(--asm-fg-muted);
  margin: 0;
}

.code-input {
  text-align: center;
  letter-spacing: 0.5em;
  font-variant-numeric: tabular-nums;
  font-size: 20px;
}

/*
 * 가이드 7-4 모바일 — 상단 Blue 영역(높이 200px) + 하단 폼으로 세로 전환.
 * 기준선은 레이아웃 전반과 같은 Bootstrap lg(991.98px)를 씁니다.
 */
@media (max-width: 991.98px) {
  .auth-screen {
    grid-template-columns: 1fr;
    grid-template-rows: 200px 1fr;
  }
  .auth-brand {
    gap: 16px;
    padding: 24px;
  }
  .auth-form-col {
    padding: 24px 16px 32px;
    align-items: start;
  }
}
</style>
