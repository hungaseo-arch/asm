import { createAuthClient } from 'better-auth/vue'
import { usernameClient } from 'better-auth/client/plugins'
import { notifyApiError } from '@/lib/api-error'
import { authUrl } from '@/lib/api-base'

const AUTH_TOKEN_KEY = 'better-auth-token'

type AuthResultWithToken = {
  data?: {
    token?: string | null
    user?: unknown
  } | null
} | null

// localStorage를 쓸 수 없는 환경(프라이빗 모드, 파티션된 iframe)에서도 탭 수명
// 동안 Bearer 세션이 유지되도록 메모리 사본을 함께 둡니다. 쓰기가 가능한 곳에서는
// localStorage에도 저장되어 새로고침 후에도 세션이 살아 있습니다.
let inMemoryToken = ''

function readStoredToken(): string {
  try {
    return localStorage.getItem(AUTH_TOKEN_KEY) ?? ''
  } catch {
    return ''
  }
}

function writeStoredToken(token: string) {
  try {
    localStorage.setItem(AUTH_TOKEN_KEY, token)
  } catch {
    // 스토리지 차단됨 — 메모리 사본만 사용
  }
}

function removeStoredToken() {
  try {
    localStorage.removeItem(AUTH_TOKEN_KEY)
  } catch {
    // 스토리지 차단됨 — 아래 메모리 사본 초기화로 충분
  }
}

export function getAuthToken() {
  return inMemoryToken || readStoredToken()
}

export function setAuthToken(token: string) {
  inMemoryToken = token
  writeStoredToken(token)
}

export function clearAuthToken() {
  inMemoryToken = ''
  removeStoredToken()
}

export function syncAuthTokenFromResult(result: AuthResultWithToken) {
  const token = result?.data?.token || getAuthToken()

  if (!token) {
    return { token: '', user: result?.data?.user }
  }

  setAuthToken(token)
  return { token, user: result?.data?.user }
}

export const authClient = createAuthClient({
  baseURL: authUrl(),
  plugins: [usernameClient()],
  fetchOptions: {
    auth: {
      type: 'Bearer',
      token: getAuthToken,
    },
    onResponse: async (context) => {
      const token = context.response.headers.get('set-auth-token')

      if (token) {
        setAuthToken(token)
      }

      // 세션 조회 실패(비로그인·백엔드 미기동)는 화면 진입 때마다 발생하므로
      // 토스트를 띄우지 않습니다. 사용자가 직접 실행한 인증 동작만 알립니다.
      const url = context.response.url ?? ''
      const isSessionProbe = url.includes('/get-session') || url.includes('/session')
      const isUnauthorized = context.response.status === 401

      if (!context.response.ok && !isSessionProbe && !isUnauthorized) {
        await notifyApiError(context.response)
      }
    },
  },
})
