import axios from 'axios'
import { API_BASE_URL } from '@/api/api-base'
import { clearAuthToken, getAuthToken, setAuthToken } from '@/api/auth'
/** `/api/basic/warehouse_list/` 처럼 도메인·리소스·동작으로 경로를 조립합니다. */
export function buildPath(domain, resourceAction) {
  return withTrailingSlash(`/api/${domain}/${resourceAction}`)
}
/** 쿼리스트링을 제외한 경로 끝에 슬래시를 강제합니다 (§4-1). */
export function withTrailingSlash(path) {
  const [base, query] = path.split('?')
  const normalized = base.endsWith('/') ? base : `${base}/`
  return query ? `${normalized}?${query}` : normalized
}
export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30_000,
  headers: { Accept: 'application/json' },
})
apiClient.interceptors.request.use((config) => {
  if (config.url) config.url = withTrailingSlash(config.url)
  const token = getAuthToken()
  if (token) config.headers.set('Authorization', `Bearer ${token}`)
  return config
})
/** 동시에 401 이 여러 건 발생해도 갱신 요청은 한 번만 보냅니다. */
let refreshing = null
async function refreshAccessToken() {
  refreshing ??= axios
    .post(`${API_BASE_URL}/api/refresh/`, {}, { withCredentials: true })
    .then((response) => response.data?.access ?? null)
    .catch(() => null)
    .finally(() => {
      refreshing = null
    })
  return refreshing
}
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const config = error.config
    if (error.response?.status !== 401 || !config || config._retried) throw error
    config._retried = true
    const access = await refreshAccessToken()
    if (!access) {
      clearAuthToken()
      if (typeof window !== 'undefined' && !window.location.pathname.endsWith('/auth')) {
        window.location.assign('/auth')
      }
      throw error
    }
    setAuthToken(access)
    return apiClient.request(config)
  },
)
/** `{ ok, data }` 규약을 지키는 GET 헬퍼 */
export async function apiGet(path, params) {
  const { data } = await apiClient.get(path, { params })
  return data.ok ? data.data : null
}
/** JSON body 를 보내는 POST/PUT/PATCH/DELETE 헬퍼 */
export async function apiSend(path, body, config) {
  const { data } = await apiClient.request({
    url: path,
    method: config?.method ?? 'POST',
    data: body,
    ...config,
  })
  return data.ok ? data.data : null
}
export default apiClient
