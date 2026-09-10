/**
 * 알림 미확인 표시 (Unread notices / Pengumuman belum dibaca)
 *
 * 헤더의 종 아이콘은 전역이라 Neon 을 직접 묻지 못합니다. 대신 CSR 화면이 공지를 읽어 온 뒤
 * "이 브라우저에서 마지막으로 본 공지" 와 비교해 localStorage 에 한 비트만 남기고,
 * 헤더는 그 비트만 읽습니다. 다른 기기까지 동기화하는 '읽음' 상태는 필요 이상이라 두지 않습니다.
 */
const SEEN_KEY = 'csr.notices.seen' // 마지막으로 본 공지의 updated_at
const UNREAD_KEY = 'csr.notices.unread' // '1' 이면 헤더에 빨간 점

const safeGet = (k) => {
  try {
    return localStorage.getItem(k)
  } catch {
    return null
  }
}
const safeSet = (k, v) => {
  try {
    localStorage.setItem(k, v)
  } catch {
    /* 사생활 보호 모드 등 — 표시가 안 될 뿐 기능은 그대로입니다. */
  }
}

const latestOf = (rows) =>
  rows.reduce((m, n) => (String(n.updated_at ?? '') > m ? String(n.updated_at) : m), '')

/** 공지 목록을 읽어 온 화면이 부릅니다 — 새 것이 있으면 헤더 점을 켭니다. */
export function noteNotices(rows) {
  const latest = latestOf(rows)
  const seen = safeGet(SEEN_KEY) ?? ''
  safeSet(UNREAD_KEY, latest && latest > seen ? '1' : '0')
}

/** 공지 화면에 들어오면 전부 본 것으로 칩니다. */
export function markNoticesSeen(rows) {
  safeSet(SEEN_KEY, latestOf(rows))
  safeSet(UNREAD_KEY, '0')
}

export const hasUnreadNotices = () => safeGet(UNREAD_KEY) === '1'
