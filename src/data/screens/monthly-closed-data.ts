import type { ScreenDef } from '@/types/list-screen'

/**
 * Monthly Closed Data List — 월마감 이력 조회 (업무프로세스맵 V. 기준정보)
 * 마감 데이터 소유자는 재무(R8)이며, 업로드 원본과 마감 확정 시각을 함께 남깁니다.
 * 운영 전환 시 rows 를 `GET /api/monthly-closed-data` 결과로 교체하십시오.
 */
export const monthlyClosedDataScreen: ScreenDef = {
  "slug": "monthly-closed-data",
  "group": "Master Data",
  "navLabel": "Monthly Closed Data List",
  "title": "Monthly Closed Data List",
  "subtitle": "Daftar Tutup Buku Bulanan · 월마감 이력 조회",
  "cardTitle": "Closed Data List",
  "searchPlaceholder": "Period, File, Status",
  "primaryAction": "＋ UPLOAD CLOSING DATA",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "PERIOD",
      "key": "period"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "period",
      "label": "PERIOD",
      "align": "left",
      "format": "code"
    },
    {
      "key": "sku",
      "label": "SKU COUNT",
      "align": "right",
      "format": "int"
    },
    {
      "key": "qty",
      "label": "TOTAL QTY (EA)",
      "align": "right",
      "format": "int"
    },
    {
      "key": "val",
      "label": "TOTAL VALUE",
      "align": "right",
      "format": "currency",
      "currency": "USD"
    },
    {
      "key": "file",
      "label": "SOURCE FILE",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "up",
      "label": "UPLOADED AT",
      "align": "center",
      "format": "date"
    },
    {
      "key": "at",
      "label": "CLOSED AT",
      "align": "center",
      "format": "date"
    },
    {
      "key": "by",
      "label": "CLOSED BY",
      "align": "center",
      "format": "text"
    },
    {
      "key": "st",
      "label": "STATUS",
      "align": "center",
      "format": "badge"
    }
  ],
  "totalKeys": [],
  "totalLabelSpan": 1,
  "pageSize": 10,
  "rows": [
    {
      "period": "202601",
      "sku": 1244,
      "qty": 166454,
      "val": 23876000,
      "file": "ASM_CLOSING_202601.xlsx",
      "up": "2026-02-03",
      "at": "2026-02-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202602",
      "sku": 1250,
      "qty": 168294,
      "val": 24194000,
      "file": "ASM_CLOSING_202602.xlsx",
      "up": "2026-03-03",
      "at": "2026-03-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202603",
      "sku": 1256,
      "qty": 170134,
      "val": 24512000,
      "file": "ASM_CLOSING_202603.xlsx",
      "up": "2026-04-03",
      "at": "2026-04-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202604",
      "sku": 1262,
      "qty": 171974,
      "val": 24830000,
      "file": "ASM_CLOSING_202604.xlsx",
      "up": "2026-05-03",
      "at": "2026-05-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202605",
      "sku": 1268,
      "qty": 173814,
      "val": 25148000,
      "file": "ASM_CLOSING_202605.xlsx",
      "up": "2026-06-03",
      "at": "2026-06-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202606",
      "sku": 1274,
      "qty": 175654,
      "val": 25466000,
      "file": "ASM_CLOSING_202606.xlsx",
      "up": "2026-07-03",
      "at": "2026-07-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202607",
      "sku": 1280,
      "qty": 177494,
      "val": 25784000,
      "file": "ASM_CLOSING_202607.xlsx",
      "up": "2026-08-03",
      "at": "2026-08-05",
      "by": "Song Juyeon",
      "st": "POSTED"
    },
    {
      "period": "202608",
      "sku": 1286,
      "qty": 179334,
      "val": 26102000,
      "file": "ASM_CLOSING_202608.xlsx",
      "up": "2026-09-03",
      "at": "",
      "by": "",
      "st": "DRAFT"
    }
  ]
}
