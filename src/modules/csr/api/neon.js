/**
 * Neon 접속 (Neon client / Klien Neon)
 *
 * ── 왜 @neondatabase/neon-js 를 쓰지 않는가 (2026-09-10 실측) ────────────────
 * 처음에는 지시서 §2 대로 `@neondatabase/neon-js`(0.7.0-beta)를 붙였습니다. 두 가지가
 * 걸렸습니다.
 *
 *   1. 메인 엔트리가 `import "@neondatabase/auth/react/adapters"` 를 side-effect 로
 *      실행합니다 — Vue 앱에 React 가 통째로 딸려 들어옵니다.
 *   2. 서브패스만 조합해도 인증이 동작하지 않습니다. 클라이언트가 인증 URL 뒤에
 *      `/adapter` 를 붙이는데(basePath 옵션으로 못 바꿉니다) 배포된 Neon Auth 에는 그
 *      경로가 없습니다:
 *        <auth-url>/get-session          200
 *        <auth-url>/adapter/get-session  404   ← beta 클라이언트가 치는 곳
 *
 * Neon Auth 는 <auth-url> 바로 아래에 **표준 Better Auth 엔드포인트**를 제공합니다
 * (/sign-in/email · /get-session · /token · /.well-known/jwks.json 실측 확인).
 * 그래서 이미 저장소에 있던 `better-auth` 로 직접 붙입니다 — 의존성이 하나 줄고,
 * 서비스가 실제로 여는 경로를 그대로 씁니다.
 *
 * Data API 는 PostgREST 라 `@neondatabase/postgrest-js` 를 그대로 씁니다.
 *
 * 이 모듈은 CSR 라우트에서만 동적으로 import 되므로 초기 청크에 들어가지 않습니다
 * (workOrder.md §6 — 초기 청크 500 KB 제한).
 */
import { createAuthClient } from 'better-auth/client'
import { jwtClient } from 'better-auth/client/plugins'
import { NeonPostgrestClient, fetchWithToken } from '@neondatabase/postgrest-js'
import { AUTH_URL, DATA_API_URL, isConfigured } from '../config'

let authClient = null
let dbClient = null

/**
 * Neon Auth (Better Auth) 클라이언트.
 *
 * basePath 를 비웁니다 — Better Auth 클라이언트는 기본으로 baseURL 뒤에 '/api/auth' 를
 * 붙이지만 Neon 은 엔드포인트를 URL 바로 아래에 둡니다.
 *
 * 앱과 인증 서버가 다른 오리진이라 쿠키가 교차 사이트로 오갑니다 — credentials 를
 * 명시하지 않으면 세션이 붙지 않습니다.
 */
export function getAuth() {
  if (!isConfigured()) return null
  authClient ??= createAuthClient({
    baseURL: AUTH_URL,
    basePath: '',
    plugins: [jwtClient()],
    fetchOptions: { credentials: 'include' },
  })
  return authClient
}

/**
 * Data API 에 실어 보낼 JWT.
 *
 * 세션 쿠키가 아니라 **JWT** 여야 합니다 — Postgres 가 /.well-known/jwks.json 의 키로
 * 검증해 auth.user_id() 를 채우고, 그래야 RLS 정책의 csr_role() 이 역할을 찾습니다.
 *
 * jwt 플러그인이 붙어 있으면 client.token() 을 쓰고, 플러그인 형태가 달라지면
 * 엔드포인트를 직접 부릅니다 — 로그인 자체가 막히는 것보다 낫습니다.
 */
async function getJwt() {
  const client = getAuth()
  if (!client) return null
  try {
    const result = await client.token?.()
    const token = result?.data?.token ?? result?.token ?? null
    if (token) return token
  } catch {
    // 아래 직접 호출로 넘어갑니다.
  }
  try {
    const res = await fetch(`${AUTH_URL}/token`, { credentials: 'include' })
    if (!res.ok) return null
    return (await res.json())?.token ?? null
  } catch {
    return null
  }
}

/**
 * Data API 클라이언트.
 *
 * fetchWithToken 이 요청마다 토큰을 새로 받아 헤더에 넣습니다 — 한 번 캐시해 두면
 * 만료 후 401 이 나므로 매번 lazy 로 가져옵니다.
 */
export function getDb() {
  if (!isConfigured()) return null
  dbClient ??= new NeonPostgrestClient({
    dataApiUrl: DATA_API_URL,
    options: { global: { fetch: fetchWithToken(getJwt) } },
  })
  return dbClient
}

/** 인증 API (signIn / signUp / getSession / signOut). */
export const authApi = () => getAuth()

/**
 * PostgREST 응답을 한 곳에서 풉니다.
 *
 * 오류를 그대로 내보내면 사용자에게 `42501` 같은 코드가 보입니다. DB 가 권한으로 거부한
 * 것인지 다른 문제인지 구분해 화면이 알맞은 문구를 고를 수 있게 합니다.
 */
export function unwrap({ data, error }) {
  if (!error) return data
  // 003_triggers.sql 의 컬럼 가드와 002 의 RLS 가 쓰는 코드입니다.
  if (error.code === '42501') {
    const err = new Error(error.message || '권한이 없습니다')
    err.forbidden = true
    throw err
  }
  const err = new Error(error.message || 'Data API 요청이 실패했습니다')
  err.details = error
  throw err
}
