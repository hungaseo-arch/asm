/**
 * 날짜 — 서버(현지) 시간대는 WIB(Asia/Jakarta, UTC+7)입니다 (작업지시서 v1.1 §G).
 * 브라우저 로컬(한국 UTC+9)로 오늘을 잡으면 자정 전후 두 시간 동안 현지보다 하루 앞선 날짜가
 * 기본값으로 들어갑니다. 검증·회신 일자의 기본값은 전부 여기서 만듭니다.
 */
export const WIB = 'Asia/Jakarta'

/** 오늘(WIB) — 'YYYY-MM-DD'. en-CA 로케일이 ISO 순서로 찍습니다. */
export function todayWib(now = new Date()) {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone: WIB,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(now)
}

/** 타임스탬프 → 'YYYY-MM-DD HH:MM' — 상세·관리 화면의 로그 표가 함께 씁니다. */
export const fmtTs = (ts) => (ts ? String(ts).replace('T', ' ').slice(0, 16) : '')
