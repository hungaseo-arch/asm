import axios, {
  type AxiosError,
  type AxiosInstance,
  type AxiosRequestConfig,
  type InternalAxiosRequestConfig,
} from 'axios'
import { API_BASE_URL } from '@/api/api-base'
import { clearAuthToken, getAuthToken, setAuthToken } from '@/api/auth'

/**
 * ASM API 클라이언트 (작업지시서 §4)
 *
 * 계약 4가지를 이 파일 한 곳에서만 구현합니다. 컴포넌트에서 axios·fetch 직접 호출 금지.
 *  1) 모든 엔드포인트는 트레일링 슬래시(/)로 끝난다 — 누락 시 Django 가 301 리다이렉트하며
 *     POST 본문이 유실된다.
 *  2) 경로 규칙 `/api/<도메인>/<리소스>_<동작>/` — buildPath() 로 조립한다.
 *  3) 요청·응답 필드는 snake_case 그대로 사용한다 (camelCase 변환 금지).
 *  4) 401 → `POST /api/refresh/` 로 갱신 후 원요청 1회 재시도, 재실패 시 `/auth` 로 이동.
 */

/** 서버(DRF)와 공유하는 응답 계약 */
export type ApiSuccess<T> = { ok: true; data: T }
export type ApiFailure = { ok: false; error: { code: string; message: string } }
export type ApiResponse<T> = ApiSuccess<T> | ApiFailure

/** 목록 조회 공통 쿼리 파라미터 (§4-4) */
export type ListQuery = {
  keyword?: string
  start_date?: string
  end_date?: string
  page?: number
  limit?: number
}

type RetriableConfig = InternalAxiosRequestConfig & { _retried?: boolean }

/** `/api/basic/warehouse_list/` 처럼 도메인·리소스·동작으로 경로를 조립합니다. */
export function buildPath(domain: string, resourceAction: string): string {
  return withTrailingSlash(`/api/${domain}/${resourceAction}`)
}

/** 쿼리스트링을 제외한 경로 끝에 슬래시를 강제합니다 (§4-1). */
export function withTrailingSlash(path: string): string {
  const [base, query] = path.split('?')
  const normalized = base.endsWith('/') ? base : `${base}/`
  return query ? `${normalized}?${query}` : normalized
}

export const apiClient: AxiosInstance = axios.create({
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
let refreshing: Promise<string | null> | null = null

async function refreshAccessToken(): Promise<string | null> {
  refreshing ??= axios
    .post<{ access?: string }>(`${API_BASE_URL}/api/refresh/`, {}, { withCredentials: true })
    .then((response) => response.data?.access ?? null)
    .catch(() => null)
    .finally(() => {
      refreshing = null
    })
  return refreshing
}

apiClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const config = error.config as RetriableConfig | undefined
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
export async function apiGet<T>(path: string, params?: ListQuery | Record<string, unknown>) {
  const { data } = await apiClient.get<ApiResponse<T>>(path, { params })
  return data.ok ? data.data : null
}

/** JSON body 를 보내는 POST/PUT/PATCH/DELETE 헬퍼 */
export async function apiSend<T>(path: string, body?: unknown, config?: AxiosRequestConfig) {
  const { data } = await apiClient.request<ApiResponse<T>>({
    url: path,
    method: config?.method ?? 'POST',
    data: body,
    ...config,
  })
  return data.ok ? data.data : null
}

export default apiClient
