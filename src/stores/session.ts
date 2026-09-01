import { computed } from 'vue'
import { defineStore } from 'pinia'
import { authClient, clearAuthToken } from '@/api/auth'

/**
 * 세션 단일 진입점 (Single session source / Sumber sesi tunggal).
 *
 * 계약:
 *  - `user`            로그인한 사용자, 비로그인 시 null
 *  - `isPending`       세션 확인 진행 중 (로딩 UI 용) — "로딩"을 "비로그인"으로
 *                      취급하면 로그인 직후 첫 렌더에서 다시 로그인 화면으로 튕깁니다.
 *  - `isAuthenticated` 라우터 가드가 쓰는 단일 인증 판정
 *  - `signOut()`       Better Auth 로그아웃 + 로컬 Bearer 토큰 삭제
 */
export const useSessionStore = defineStore('session', () => {
  const session = authClient.useSession()

  const user = computed(() => session.value.data?.user ?? null)
  const isPending = computed(() => Boolean(session.value.isPending))
  const isAuthenticated = computed(() => Boolean(user.value))
  const isEmailVerified = computed(() => Boolean(session.value.data?.user?.emailVerified))

  const initials = computed(() => {
    const name = user.value?.name ?? user.value?.email ?? ''
    if (!name) return 'AP'
    return name
      .split(/[\s.@]+/)
      .filter(Boolean)
      .slice(0, 2)
      .map((part: string) => part[0]?.toUpperCase() ?? '')
      .join('')
  })

  /** 세션이 확정될 때까지 대기 — 라우터 가드에서 사용 */
  async function ensureResolved() {
    if (!isPending.value) return
    await new Promise<void>((resolve) => {
      const timer = window.setInterval(() => {
        if (!session.value.isPending) {
          window.clearInterval(timer)
          resolve()
        }
      }, 30)
      // 안전장치: 5초 후 강제 해제
      window.setTimeout(() => {
        window.clearInterval(timer)
        resolve()
      }, 5000)
    })
  }

  async function refetch() {
    await authClient.getSession({ query: { disableCookieCache: true } }).catch(() => undefined)
  }

  async function signOut() {
    await authClient.signOut().catch(() => undefined)
    clearAuthToken()
  }

  return {
    session,
    user,
    isPending,
    isAuthenticated,
    isEmailVerified,
    initials,
    ensureResolved,
    refetch,
    signOut,
  }
})
