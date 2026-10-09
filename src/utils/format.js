/**
 * PT ASCENDO 사내 숫자 표기 표준 (Number formatting standard / Standar penulisan angka)
 *
 * 원칙: 모든 언어의 문서·화면에 영미식 표기를 일관 적용한다.
 *   - 천 단위 구분 = 콤마(,) / 소수점 = 마침표(.)
 *   - 인도네시아식 표기(1.234,56)는 사용하지 않는다 → locale 은 항상 'en-US'
 */
export const NUMBER_LOCALE = 'en-US'
/** 정수 + 천 단위 콤마. 예) 1,250,000 */
export function formatInt(value) {
  return new Intl.NumberFormat(NUMBER_LOCALE, { maximumFractionDigits: 0 }).format(value)
}
