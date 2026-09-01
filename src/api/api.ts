import { apiUrl } from '@/api/api-base'
import { notifyApiError } from '@/api/api-error'
import { getAuthToken, setAuthToken } from '@/api/auth'

// 서버(apps/server)와 공유하는 응답 계약 — packages/shared/src/http.ts 와 동일
export type ApiSuccess<T> = { ok: true; data: T }
export type ApiFailure = { ok: false; error: { code: string; message: string } }
export type ApiResponse<T> = ApiSuccess<T> | ApiFailure

export type ApiFetchInit = RequestInit & {
  auth?: boolean
  /** 내부 best-effort 요청은 전역 에러 UI를 끌 수 있습니다. 업무 요청은 기본값(false) 유지. */
  silent?: boolean
}

export async function apiFetch(path: string, init?: ApiFetchInit) {
  const { auth = true, silent = false, ...requestInit } = init ?? {}
  const token = auth ? getAuthToken() : ''

  const response = await fetch(apiUrl(path), {
    ...requestInit,
    headers: {
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...requestInit.headers,
    },
  })

  if (!response.ok && !silent) {
    await notifyApiError(response)
  }

  return response
}

/** ok/data 규약을 지키는 GET 헬퍼 */
export async function apiGet<T>(path: string, init?: ApiFetchInit): Promise<T | null> {
  const response = await apiFetch(path, init)
  if (!response.ok) return null

  const payload = (await response.json().catch(() => null)) as ApiResponse<T> | null
  return payload?.ok ? payload.data : null
}

/** JSON body를 보내는 POST/PUT/PATCH/DELETE 헬퍼 */
export async function apiSend<T>(
  path: string,
  body: unknown,
  init?: ApiFetchInit & { method?: string },
): Promise<T | null> {
  const response = await apiFetch(path, {
    method: init?.method ?? 'POST',
    headers: { 'Content-Type': 'application/json', ...init?.headers },
    body: JSON.stringify(body),
    ...init,
  })
  if (!response.ok) return null

  const payload = (await response.json().catch(() => null)) as ApiResponse<T> | null
  return payload?.ok ? payload.data : null
}

export async function startThirdPartyGoogleAuth(landingPath = window.location.pathname) {
  const response = await apiFetch('/third-party-google-auth/start', {
    method: 'POST',
    auth: false,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      origin: window.location.origin,
      landing_path: landingPath,
    }),
  })
  const payload = (await response.json()) as {
    ok: boolean
    data?: { authUrl?: string; auth_url?: string }
  }
  const url = payload.data?.authUrl ?? payload.data?.auth_url

  if (!response.ok || !url) {
    throw new Error('Third-party Google auth start failed')
  }

  window.location.assign(url)
}

/** OAuth 리다이렉트로 돌아온 URL의 login_token을 세션 토큰으로 승격 */
export async function syncAuthTokenFromUrl() {
  const url = new URL(window.location.href)
  const token = url.searchParams.get('login_token')
  const ts = url.searchParams.get('ts')
  const sig = url.searchParams.get('sig')

  if (!token || !ts || !sig) {
    return false
  }

  const response = await apiFetch('/third-party-google-auth/verify', {
    method: 'POST',
    auth: false,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ path: url.pathname, token, ts, sig }),
  }).catch(() => null)

  if (!response?.ok) {
    return false
  }

  setAuthToken(token)
  url.searchParams.delete('login_token')
  url.searchParams.delete('ts')
  url.searchParams.delete('sig')
  window.history.replaceState(window.history.state, '', `${url.pathname}${url.search}${url.hash}`)
  return true
}
