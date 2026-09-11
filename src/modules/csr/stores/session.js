import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { authApi, getDb, unwrap } from '../api/neon'
import { AUTH_URL, isConfigured } from '../config'
import { useIdentityStore } from '@/stores/identity'

/**
 * CSR 세션 (Session / Sesi)
 *
 * 로그인 여부와 **역할**을 함께 들고 있습니다. 둘은 다른 곳에서 옵니다 —
 * 로그인은 Neon Auth 가, 역할은 `csr_user_roles` 테이블이 압니다.
 *
 * Neon Auth 는 현재 가입 제한을 지원하지 않아 누구나 계정을 만들 수 있습니다.
 * 그래서 '로그인했다'는 것만으로는 아무 의미가 없고, csr_user_roles 에 등록되어
 * 역할을 받은 사용자만 실제로 데이터를 봅니다(RLS 정책이 csr_role() IS NOT NULL).
 * 등록되지 않은 사용자에게는 목록이 통째로 비어 나오므로, 빈 목록과 구분해
 * 안내를 띄우려고 역할을 별도로 조회합니다.
 */
export const useCsrSessionStore = defineStore('csr-session', () => {
  const identity = useIdentityStore()
  // 헤더 계정 메뉴에서 로그아웃할 수 있도록 동작을 넘겨 둡니다.
  identity.setActions({ signOut: () => signOut() })
  const user = ref(null)
  const role = ref(null)
  const profile = ref(null) // csr_user_roles 행 (display_name · department)
  const loading = ref(true)
  const error = ref('')

  const isAuthenticated = computed(() => Boolean(user.value))
  /** 로그인은 됐지만 csr_user_roles 에 없는 상태 — 안내가 필요한 유일한 경우입니다. */
  const isUnregistered = computed(() => Boolean(user.value) && !role.value)
  const isAdmin = computed(() => role.value === 'admin')

  async function refresh() {
    if (!isConfigured()) {
      loading.value = false
      error.value =
        'Neon 접속 정보(VITE_CSR_DATA_API_URL · VITE_CSR_AUTH_URL)가 설정되지 않았습니다'
      return
    }

    loading.value = true
    error.value = ''
    try {
      const session = await authApi()?.getSession()
      // Better Auth 는 { data, error } 또는 세션 객체를 직접 돌려줍니다 — 둘 다 받습니다.
      user.value = session?.data?.user ?? session?.user ?? null

      if (!user.value) {
        role.value = null
        profile.value = null
        identity.clear()
        return
      }

      /*
       * 역할 조회 — 반드시 내 user_id 로 좁힙니다. business·it_dept 는 RLS 가 자기 행만
       * 보여 주지만 admin 은 전원이 보여, 조건 없이 첫 행을 집으면 남의 이름(Alya)이
       * 헤더에 올라갔습니다(2026-09-10 「계정과 이름 불일치」).
       * 등록되지 않았으면 0행이 돌아옵니다 — 오류가 아니라 정상적인 '미등록' 상태입니다.
       */
      const lookup = async () =>
        unwrap(
          await getDb()
            .from('csr_user_roles')
            .select('role,email,display_name,department')
            .eq('user_id', user.value.id),
        )
      let rows = await lookup()
      if (!rows?.length) {
        // 0건이면 한 번 더 — JWT 가 한 박자 늦게 붙거나(그러면 RLS 가 전부 가립니다) 관리자가
        // 그 순간 행을 고치는 중이면 잠깐 0건이 되어 '미등록' 화면이 떴습니다(2026-09-10).
        await new Promise((r) => setTimeout(r, 700))
        rows = await lookup()
      }
      profile.value = rows?.[0] ?? null
      role.value = profile.value?.role ?? null
      // 헤더가 읽는 가벼운 정체성 — 미등록 계정도 이메일은 보여 줍니다.
      identity.set({
        name: profile.value?.display_name ?? user.value.name ?? null,
        email: user.value.email,
        role: role.value,
        department: profile.value?.department ?? null,
      })
    } catch (e) {
      error.value = e.message
      user.value = null
      role.value = null
      profile.value = null
      identity.clear()
    } finally {
      loading.value = false
    }
  }

  async function signIn(email, password) {
    error.value = ''
    const result = await authApi()?.signIn?.email({ email, password })
    if (result?.error) {
      error.value = result.error.message ?? '로그인에 실패했습니다'
      return false
    }
    await refresh()
    return isAuthenticated.value
  }

  async function signOut() {
    /*
     * 옵셔널 호출 금지(2026-09-11 「로그아웃이 안 됨」): authApi()?.signOut?.() 은 프로덕션 빌드에서
     * signOut.call(client) 이 되고, better-auth 프록시는 .call 을 API 경로로 읽어 클라이언트를 첫 인자로
     * 넘깁니다 → GET /fetch-options/method/to-upper-case 404, 실제 sign-out 은 나가지 않았습니다.
     * 개발 서버(변환 없음)에서는 정상이라 배포 뒤에야 드러났습니다.
     */
    const client = authApi()
    if (client) {
      try {
        await client.signOut()
      } catch {
        // 서버 sign-out 이 실패해도 아래 직접 호출로 한 번 더 시도합니다.
      }
      // 쿠키가 남아 있으면 새로고침 때 다시 로그인되므로 엔드포인트를 직접 한 번 더 부릅니다.
      try {
        await fetch(`${AUTH_URL}/sign-out`, {
          method: 'POST',
          credentials: 'include',
          headers: { 'content-type': 'application/json' },
          body: '{}',
        })
      } catch {
        // 네트워크 오류 — 로컬 상태는 아래에서 비웁니다.
      }
    }
    user.value = null
    role.value = null
    profile.value = null
    identity.clear()
  }

  return {
    user,
    role,
    profile,
    loading,
    error,
    isAuthenticated,
    isUnregistered,
    isAdmin,
    refresh,
    signIn,
    signOut,
  }
})
