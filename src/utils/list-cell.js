import {
  formatAmount,
  formatDate,
  formatDecimal,
  formatInt,
  formatPercent,
  formatSigned,
  formatWeight,
} from '@/utils/format'

/**
 * 열 서식(column.format)에 따라 원시값을 표시용 문자열로 바꿉니다.
 * ListScreen.vue(표)와 ListCellValue.vue(표·상세 모달 공용 셀)가 함께 씁니다 —
 * 두 곳에서 같은 서식 규칙이 어긋나지 않도록 단일 진실 공급원으로 뺐습니다.
 */
export function displayColumnValue(column, value, row) {
  if (value === undefined || value === null || value === '') return '—'
  const numeric = Number(value)
  switch (column.format) {
    case 'int':
      return formatInt(numeric)
    case 'signed':
      return formatSigned(numeric)
    case 'price':
      return formatDecimal(numeric)
    case 'percent':
      return formatPercent(numeric)
    case 'weight':
      return formatWeight(numeric)
    case 'currency': {
      // 행마다 통화가 다른 화면(PPC·Receipt 등)은 같은 행의 통화 열을 씁니다.
      const rowCurrency = column.currencyKey ? String(row?.[column.currencyKey] ?? '') : ''
      const currency =
        (rowCurrency === 'IDR' || rowCurrency === 'USD' ? rowCurrency : null) ??
        column.currency ??
        'USD'
      return formatAmount(currency, numeric)
    }
    case 'date':
      return formatDate(String(value))
    default:
      return String(value)
  }
}
