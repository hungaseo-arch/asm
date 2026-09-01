import { apiUrl } from '@/api/api-base'
import { notifyApiError } from '@/api/api-error'
import { getAuthToken, setAuthToken } from '@/api/auth'
export async function apiFetch(path, init) {
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
export async function apiGet(path, init) {
  const response = await apiFetch(path, init)
  if (!response.ok) return null
  const payload = await response.json().catch(() => null)
  return payload?.ok ? payload.data : null
}
/** JSON body를 보내는 POST/PUT/PATCH/DELETE 헬퍼 */
export async function apiSend(path, body, init) {
  const response = await apiFetch(path, {
    method: init?.method ?? 'POST',
    headers: { 'Content-Type': 'application/json', ...init?.headers },
    body: JSON.stringify(body),
    ...init,
  })
  if (!response.ok) return null
  const payload = await response.json().catch(() => null)
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
  const payload = await response.json()
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
