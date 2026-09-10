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
