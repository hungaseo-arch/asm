/**
 * 보고서 양식안 (Report design / Rancangan laporan) — 2026-10-28 작업지시서 ASM-CSR-2026-1028-01.
 *
 * 원본은 Google Drive 「직원별요청사항_261027」 폴더의 단독 HTML 과 엑셀 양식 5개입니다.
 * public/csr/reports/ 에 그대로 복사했습니다(HTML 은 </body> 앞 임베드 스크립트 1블록만 추가).
 * 파일명은 URL 인코딩 문제를 피하려고 영문으로 두고, 내려받을 때 이름(xlsxName)만 원본 한글 이름을 씁니다.
 * 값은 HTML 과 같게 둡니다 — HTML 이 개정되면 여기 version · date 도 함께 고칩니다.
 */
export const REPORT_DESIGN = {
  file: 'report-design.html',
  version: 'v1.0',
  date: '2026-10-28',
  title: ['보고서 양식안 (직원별)', 'Rancangan format laporan (per karyawan)'],
  desc: [
    '직원 요청 보고서 13종 · 1면 내부관리용 양식 · ASM 화면 용어 기준',
    '13 laporan permintaan karyawan · format internal 1 halaman · istilah layar ASM',
  ],
}

/** tab 순서 = HTML 의 그룹 탭 순서. */
export const REQUESTERS = [
  {
    key: 'Lestari',
    name: 'Lestari',
    dept: ['구매 (HQ)', 'Pembelian (HO)'],
    reports: ['PUR-01', 'PUR-02', 'PUR-03'],
    xlsx: 'lestari.xlsx',
    xlsxName: 'ASM_구매보고서_엑셀양식_Lestari_261027.xlsx',
  },
  {
    key: 'Lia',
    name: 'Lia Nur Fatimah',
    dept: ['재고·PO (HQ)', 'Stok·PO (HO)'],
    reports: ['INV-01', 'PUR-04'],
    xlsx: 'lia.xlsx',
    xlsxName: 'ASM_재고구매보고서_엑셀양식_Lia_261027.xlsx',
  },
  {
    key: 'Merry',
    name: 'Merry Maharani',
    dept: ['판매 전사 (HQ)', 'Penjualan HO'],
    reports: ['SAL-01', 'SAL-02', 'SAL-03'],
    xlsx: 'merry.xlsx',
    xlsxName: 'ASM_판매보고서_엑셀양식_Merry_261027.xlsx',
  },
  {
    key: 'Sulastri',
    name: 'Sulastri',
    dept: ['SBY 지점', 'Cabang SBY'],
    reports: ['SAL-04', 'FIN-01', 'SAL-05'],
    xlsx: 'sulastri.xlsx',
    xlsxName: 'ASM_지점판매보고서_엑셀양식_Sulastri_261027.xlsx',
  },
  {
    key: 'Resiyan',
    name: 'Resiyan Arisandy',
    dept: ['SMR 지점', 'Cabang SMR'],
    reports: ['SAL-04', 'SAL-05'],
    xlsx: 'resiyan.xlsx',
    xlsxName: 'ASM_지점판매보고서_엑셀양식_Resiyan_261027.xlsx',
  },
]

export const REPORT_COUNT = 13
