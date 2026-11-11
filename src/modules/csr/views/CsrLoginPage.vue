<script setup>
/**
 * CSR 로그인 화면 (/csr/login) — 2026-11-11 「조회 공개, 입력・수정만 로그인」.
 *
 * 목록・대시보드가 로그인 없이 열리므로 로그인 폼을 따로 둡니다. 헤더의 「로그인」 버튼이
 * 지금 화면 경로를 `next` 로 넘기고, 로그인하면 그 화면으로 돌아갑니다.
 */
import { onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import CsrSignIn from '../components/CsrSignIn.vue'
import { useCsrSessionStore } from '../stores/session'

const route = useRoute()
const router = useRouter()
const session = useCsrSessionStore()

/** 같은 사이트 안 경로만 받습니다(외부 주소로 튕기는 것 방지). */
const nextPath = () => {
  const n = String(route.query.next ?? '')
  return n.startsWith('/csr') && !n.startsWith('/csr/login') ? n : '/csr'
}
const goBack = () => router.replace(nextPath())

onMounted(async () => {
  await session.refresh()
  if (session.isAuthenticated) goBack()
})
watch(
  () => session.isAuthenticated,
  (v) => v && goBack(),
)
</script>

<template>
  <DefaultLayout>
    <section class="login">
      <CsrSignIn />
    </section>
  </DefaultLayout>
</template>

<style scoped>
.login {
  display: flex;
  justify-content: center;
  padding-top: 24px;
}
</style>
