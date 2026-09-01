// 우선순위: 빌드타임 VITE_API_BASE_URL > 런타임 app-config.js > same-origin
// (정적 클라이언트와 API 서버가 서로 다른 도메인에 있을 때 재빌드 없이 연결)
const runtimeConfig = window.__ASM_APP_CONFIG__ ?? window.__SKYBASE_APP_CONFIG__ ?? {}
const RAW_API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? runtimeConfig.apiBaseUrl ?? ''
export const API_BASE_URL = (RAW_API_BASE_URL || window.location.origin).replace(/\/+$/, '')
export function apiUrl(path) {
  const normalizedPath = path.startsWith('/') ? path : `/${path}`
  const apiPath =
    normalizedPath === '/api' || normalizedPath.startsWith('/api/')
      ? normalizedPath
      : `/api${normalizedPath}`
  return `${API_BASE_URL}${apiPath}`
}
export function authUrl(path = '') {
  const normalizedPath = path ? (path.startsWith('/') ? path : `/${path}`) : ''
  return apiUrl(`/auth${normalizedPath}`)
}
