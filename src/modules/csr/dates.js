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
/** 타임스탬프 → 'YYYY-MM-DD' — 변경 이력은 시각이 의미 없어 날짜만 씁니다(2026-10-23 요청). */
export const fmtDate = (ts) => fmtTs(ts).slice(0, 10)

/**
 * 변경 이력의 이전·이후 값 — 날짜 컬럼(verified_on 등)은 '2026-10-18T00:00:00' 처럼
 * 시각이 붙어 오고 좁은 칸에서 「202 / 6-10- / 18」 로 쪼개졌습니다. 날짜로 보이는 값은
 * 'YYYY-MM-DD' 로 줄이고(isDateValue → 표에서 nowrap), 나머지는 그대로 둡니다.
 */
const DATE_RE = /^\d{4}-\d{2}-\d{2}(?:[T ][\d:.]+(?:Z|[+-]\d{2}:?\d{2})?)?$/
export const isDateValue = (v) => typeof v === 'string' && DATE_RE.test(v.trim())
export const logValue = (v) => (isDateValue(v) ? v.trim().slice(0, 10) : v)
