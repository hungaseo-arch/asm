/**
 * PT ASCENDO 사내 숫자 표기 표준 (Number formatting standard / Standar penulisan angka)
 *
 * 원칙: 모든 언어의 문서·화면에 영미식 표기를 일관 적용한다.
 *   - 천 단위 구분 = 콤마(,) / 소수점 = 마침표(.)
 *   - 인도네시아식 표기(1.234,56)는 사용하지 않는다 → locale 은 항상 'en-US'
 *
 * 자리수 규칙
 *   - 기본 정수 + 천 단위 콤마 ........ 1,250,000
 *   - 퍼센트(%) 소수점 1자리 .......... 12.5% / 3.0%
 *   - 단가(FOB·CIF·C&F·EXW) 2자리 ..... USD 84.25/EA
 *   - 중량 1자리 ...................... 62.5 kg
 *   - 수량(EA·PCS·SET) 정수 ........... 1,200 EA
 *
 * 통화: 코드는 금액 앞에 표기 (USD 12,500 / IDR 185,000,000)
 * IDR 대금액: juta / miliar / triliun 단위, 소수점 2자리
 *   - 대외 문서(견적서·인보이스·계약서·공문)는 전체 자리수 + 괄호 병기 필수
 *     IDR 1,250,000,000 (1.25 miliar)
 *   - 사내 화면 요약은 단위 표기만 사용 가능
 */

export const NUMBER_LOCALE = 'en-US'

export type Currency = 'IDR' | 'USD'

/** 정수 + 천 단위 콤마. 예) 1,250,000 */
export function formatInt(value: number): string {
  return new Intl.NumberFormat(NUMBER_LOCALE, { maximumFractionDigits: 0 }).format(value)
}

/** 수량 — 항상 정수. 예) 1,200 EA */
export function formatQty(value: number, unit = 'EA'): string {
  return `${formatInt(value)}${unit ? ` ${unit}` : ''}`
}

/** 소수점 고정 자리수 — 통화 코드가 열 제목에 있는 표에서 사용. 예) 84.25 */
export function formatDecimal(value: number, digits = 2): string {
  return new Intl.NumberFormat(NUMBER_LOCALE, {
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  }).format(value)
}

/** 증감 — 양수에 + 를 붙인 정수. 예) +120 / -35 */
export function formatSigned(value: number): string {
  return `${value > 0 ? '+' : ''}${formatInt(value)}`
}

/** 퍼센트 — 소수점 1자리 고정. 예) 12.5% / 3.0% */
export function formatPercent(value: number): string {
  return `${new Intl.NumberFormat(NUMBER_LOCALE, {
    minimumFractionDigits: 1,
    maximumFractionDigits: 1,
  }).format(value)}%`
}

/** 중량 — 소수점 1자리. 예) 62.5 kg */
export function formatWeight(value: number, unit: 'kg' | 'ton' = 'kg'): string {
  return `${new Intl.NumberFormat(NUMBER_LOCALE, {
    minimumFractionDigits: 1,
    maximumFractionDigits: 1,
  }).format(value)} ${unit}`
}

/** 구매단가 — 소수점 2자리. 예) USD 84.25/EA */
export function formatUnitPrice(currency: Currency, value: number, unit = 'EA'): string {
  const amount = new Intl.NumberFormat(NUMBER_LOCALE, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value)
  return `${currency} ${amount}${unit ? `/${unit}` : ''}`
}

/**
 * 금액 — 통화 코드 선행 표기.
 * IDR 은 소수점 없음, USD 는 소수점 2자리.
 * 예) IDR 185,000,000 · USD 108,800.00
 */
export function formatAmount(currency: Currency, value: number): string {
  const digits = currency === 'IDR' ? 0 : 2
  const amount = new Intl.NumberFormat(NUMBER_LOCALE, {
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  }).format(value)
  return `${currency} ${amount}`
}

/**
 * IDR 대금액 단위 표기 (juta / miliar / triliun), 소수점 2자리.
 * 예) IDR 1.25 miliar · IDR 850.50 juta
 * 사내 화면 요약 전용. 대외 문서에는 formatIdrFull() 을 사용할 것.
 */
export function formatIdrShort(value: number): string {
  const scale = (divisor: number, unit: string) =>
    `IDR ${new Intl.NumberFormat(NUMBER_LOCALE, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value / divisor)} ${unit}`

  if (Math.abs(value) >= 1_000_000_000_000) return scale(1_000_000_000_000, 'triliun')
  if (Math.abs(value) >= 1_000_000_000) return scale(1_000_000_000, 'miliar')
  if (Math.abs(value) >= 1_000_000) return scale(1_000_000, 'juta')
  return formatAmount('IDR', value)
}

/**
 * 대외 발송 문서용 IDR 표기 — 전체 자리수 먼저, 단위 표기 괄호 병기.
 * 소수점 오독 방지를 위한 필수 규칙.
 * 예) IDR 1,250,000,000 (1.25 miliar)
 */
export function formatIdrFull(value: number): string {
  const full = formatAmount('IDR', value)
  if (Math.abs(value) < 1_000_000) return full
  return `${full} (${formatIdrShort(value).replace('IDR ', '')})`
}

/**
 * 날짜 — YYYY-MM-DD (ISO 8601) 고정. 예) 2026-08-28
 * 디자인 가이드 8-2 및 개선의견서 이슈 15 에 따라 브라우저 언어 설정과 무관하게
 * 항상 동일한 순서로 표기합니다. 연도에는 콤마를 쓰지 않습니다.
 */
export function formatDate(value: string): string {
  if (!value) return '-'
  const date = new Date(`${value}T00:00:00`)
  if (Number.isNaN(date.getTime())) return '-'
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${date.getFullYear()}-${month}-${day}`
}

/** 입력창용 — 타이핑 중 천 단위 콤마를 유지하며 소수점 2자리까지 허용 */
export function groupAmountInput(raw: string): string {
  const digits = raw.replace(/[^\d.]/g, '')
  const [whole, decimal] = digits.split('.')
  const grouped = whole ? formatInt(Number(whole)) : ''
  return decimal === undefined ? grouped : `${grouped}.${decimal.slice(0, 2)}`
}

/** 콤마가 들어간 입력값을 숫자로 되돌립니다. */
export function parseAmountInput(raw: string): number {
  return Number(raw.split(',').join(''))
}
