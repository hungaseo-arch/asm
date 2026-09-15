/**
 * 이슈 쓰기 API (Issue mutations / Mutasi isu)
 *
 * 화면은 여기만 부릅니다. 권한 판정은 하지 않습니다 — 그건 DB 가 합니다
 * (002 RLS 가 행을, 003/006 컬럼 가드가 컬럼을). 거부되면 unwrap 이 `forbidden`
 * 플래그를 단 오류를 던지고, 화면은 그걸 받아 "권한 없음" 문구를 고릅니다.
 *
 * 프론트의 canEditColumn 은 입력창을 잠그는 UX 힌트일 뿐입니다. 개발자 도구로 풀어도
 * 저장은 여기서 DB 로 가고 DB 가 막습니다 — 그래서 여기서 다시 검사하지 않습니다.
 */
import { getDb, unwrap } from './neon'

/**
 * 속성 갱신. 바뀐 컬럼만 보냅니다 — 컬럼 가드는 '실제로 값이 달라진 컬럼' 만 세지만,
 * 폼 전체를 보내면 PostgREST 가 그 전부를 UPDATE 문에 싣고 로그도 지저분해집니다.
 */
export async function updateIssue(id, patch) {
  const rows = unwrap(await getDb().from('csr_issues').update(patch).eq('id', id).select('*'))
  // RLS 로 0행이 갱신되면 오류가 아니라 빈 배열이 옵니다 — 화면에서는 실패로 봐야 합니다.
  if (!rows?.length) {
    const err = new Error('갱신된 행이 없습니다 — 권한이 없거나 대상이 사라졌습니다')
    err.forbidden = true
    throw err
  }
  return rows[0]
}

/** IT부서 회신 1회차 추가 (작업지시서 §5-2 · 5절). */
export async function addReply(issueId, fields, createdBy) {
  return unwrap(
    await getDb()
      .from('csr_it_replies')
      .insert({ issue_id: issueId, ...fields, created_by: createdBy })
      .select('*'),
  )?.[0]
}

/** 검증 이력 1행 추가 (7절). */
export async function addVerification(issueId, fields, createdBy) {
  return unwrap(
    await getDb()
      .from('csr_verifications')
      .insert({ issue_id: issueId, ...fields, created_by: createdBy })
      .select('*'),
  )?.[0]
}

/**
 * 최종 접속 기록 (2026-09-14) — 자기 행의 last_seen_at 만 찍는 SECURITY DEFINER 함수(db/029).
 *
 * 화면은 이게 실패해도 굴러가야 하므로 오류를 던지지 않습니다. 다만 **조용히 삼키지는**
 * 않습니다 — 종전에는 try/catch 로 감쌌는데 PostgREST 클라이언트는 실패를 throw 하지 않고
 * `{ data, error }` 로 돌려주므로 catch 가 한 번도 걸리지 않았고, 그래서 029 미적용 같은
 * 원인이 아무 흔적도 남기지 않은 채 「최종 접속」이 계속 빈칸이었습니다(2026-09-15).
 *
 * 반환값: 찍힌 시각. 미등록 사용자거나 실패하면 null.
 */
export async function touchLastSeen() {
  let res
  try {
    res = await getDb().rpc('csr_touch_last_seen')
  } catch (e) {
    console.warn('[csr] 최종 접속 기록 실패 — 네트워크/인증', e)
    return null
  }
  if (res?.error) {
    // PGRST202 = 함수를 못 찾음(db/029 미적용 또는 Data API 의 스키마 캐시가 아직 모름).
    // 코드·메시지를 한 줄에 펼쳐 찍습니다 — 접힌 Object 를 열어 보지 않아도 원인이 보이게.
    const { code, message, details, hint } = res.error
    console.warn(
      `[csr] 최종 접속 기록 실패 — csr_touch_last_seen() [${code ?? '?'}] ${message ?? ''}` +
        `${details ? ` | details: ${details}` : ''}${hint ? ` | hint: ${hint}` : ''}`,
    )
    return null
  }
  return res?.data ?? null
}

/**
 * 담당자 선택지 — Neon 에 등록된 사용자의 표시 이름(csr_user_roles.display_name).
 * 담당자 값은 등록 사용자와 같아야 하므로(2026-09-11 요청) 자유 입력 대신 이 목록에서 고릅니다.
 */
export async function loadUserNames() {
  const rows =
    unwrap(
      await getDb().from('csr_user_roles').select('display_name,email').order('display_name'),
    ) ?? []
  return [...new Set(rows.map((r) => r.display_name?.trim() || r.email).filter(Boolean))]
}

/** 상태 변경 로그 — 003 트리거가 쌓은 것. 최신이 위. */
export async function loadStatusLog(issueId) {
  return (
    unwrap(
      await getDb()
        .from('csr_status_log')
        .select('*')
        .eq('issue_id', issueId)
        .order('changed_at', { ascending: false }),
    ) ?? []
  )
}

/** 빈 문자열을 NULL 로 — 입력창을 비운 것을 '빈 문자열 저장' 으로 남기지 않습니다. */
export const nullIfBlank = (v) => {
  if (v === null || v === undefined) return null
  const s = String(v).trim()
  return s === '' ? null : s
}
