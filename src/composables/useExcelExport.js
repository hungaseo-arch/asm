import { toast } from 'vue-sonner'
import { formatInt } from '@/utils/format'
export function useExcelExport() {
  async function exportRows(fileBase, headers, rows, sheetName = 'Sheet1') {
    const XLSX = await import('xlsx')
    const sheet = XLSX.utils.aoa_to_sheet([headers, ...rows])
    const book = XLSX.utils.book_new()
    // 시트명은 31자 제한 + 일부 특수문자 사용 불가
    XLSX.utils.book_append_sheet(book, sheet, sheetName.slice(0, 31).replace(/[[\]:*?/\\]/g, '_'))
    XLSX.writeFile(book, `${fileBase}-${new Date().toISOString().slice(0, 10)}.xlsx`)
    toast.success(`${formatInt(rows.length)}건이 엑셀로 내보내졌습니다`)
  }
  return { exportRows }
}
