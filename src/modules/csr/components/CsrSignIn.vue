<script setup>
import { ref } from 'vue'
import { useCsrSessionStore } from '../stores/session'

const session = useCsrSessionStore()
const email = ref('')
const password = ref('')
const busy = ref(false)

async function submit() {
  if (busy.value) return
  busy.value = true
  try {
    await session.signIn(email.value.trim(), password.value)
  } finally {
    busy.value = false
    password.value = ''
  }
}
</script>

<template>
  <!--
    CSR 전용 로그인 (작업지시서 §5-1 — 로그인 전 /csr 직접 진입 시 로그인 화면)

    운영 화면의 AuthPage.vue 와 별개입니다. 그쪽은 실서버 세션(현재 비활성)을 쓰고,
    이쪽은 Neon Auth 를 씁니다 — 인증 주체가 다르므로 화면도 나눕니다.
  -->
  <form class="asm-panel signin" @submit.prevent="submit">
    <h2 class="asm-title">로그인 · Masuk</h2>
    <p class="lead">
      CSR 사용자로 등록된 계정으로만 개선요청을 볼 수 있습니다.<br />
      <span class="id">Hanya akun terdaftar yang dapat melihat permintaan perbaikan.</span>
    </p>

    <label class="field">
      <span>이메일 · Email</span>
      <input
        v-model="email"
        type="email"
        class="form-control"
        autocomplete="username"
        required
        :disabled="busy"
      />
    </label>

    <label class="field">
      <span>비밀번호 · Kata sandi</span>
      <input
        v-model="password"
        type="password"
        class="form-control"
        autocomplete="current-password"
        required
        :disabled="busy"
      />
    </label>

    <!-- 로그인 실패 사유는 서버 문구를 그대로 보여 줍니다 — 임의로 바꾸면 원인 파악이 어렵습니다. -->
    <p v-if="session.error" class="err" role="alert">{{ session.error }}</p>

    <button type="submit" class="btn btn-primary" :disabled="busy">
      {{ busy ? '확인 중…' : '로그인' }}
    </button>

    <!--
      가입 링크를 두지 않습니다. 계정은 관리자가 Neon 콘솔에서 만들고 csr_user_roles 에
      등록해야 쓸 수 있습니다(작업지시서 §6). Neon Auth 가 아직 가입 제한을 지원하지 않아
      가입 자체는 막을 수 없지만, 등록되지 않은 계정은 아무것도 보지 못합니다.
    -->
    <p class="note">계정이 필요하면 관리자에게 요청하십시오.</p>
  </form>
</template>

<style scoped>
.signin {
  padding: 24px;
  max-width: 420px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.lead {
  margin: 0;
  font-size: 13px;
  color: var(--asm-fg-muted);
  line-height: 1.6;
}
.id {
  font-style: italic;
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
.err {
  margin: 0;
  font-size: 12px;
  color: var(--asm-danger);
}
.note {
  margin: 0;
  font-size: 11px;
  color: var(--asm-fg-muted);
}
</style>
