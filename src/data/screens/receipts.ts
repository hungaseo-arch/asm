import type { ScreenDef } from '@/types/list-screen'

/**
 * Receipt — Receipt Main · Penerimaan Barang · 입고 (검수 기준)
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/receipts` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const receiptsScreen: ScreenDef = {
  "slug": "receipts",
  "group": "Purchasing",
  "navLabel": "Receipt",
  "title": "Receipt",
  "subtitle": "Receipt Main · Penerimaan Barang · 입고 (검수 기준)",
  "cardTitle": "All Receipts",
  "searchPlaceholder": "PO no, Supplier, Warehouse",
  "primaryAction": "＋ NEW",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    }
  ],
  "columns": [
    {
      "key": "sup",
      "label": "SUPPLIER",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "no",
      "label": "RECEIPT NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "rdt",
      "label": "RECEIPT DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "pono",
      "label": "PO NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "arr",
      "label": "ACT. ARRIVAL",
      "align": "center",
      "format": "date"
    },
    {
      "key": "psq",
      "label": "PPC/SHP QTY",
      "align": "right",
      "format": "int"
    },
    {
      "key": "qty",
      "label": "QTY",
      "align": "right",
      "format": "int"
    },
    {
      "key": "amt",
      "label": "AMOUNT",
      "align": "right",
      "format": "currency",
      "currencyKey": "cur"
    },
    {
      "key": "st",
      "label": "STATUS",
      "align": "center",
      "format": "badge"
    }
  ],
  "totalKeys": [
    "psq",
    "qty"
  ],
  "totalLabelSpan": 3,
  "pageSize": 15,
  "rows": [
    {
      "sup": "PT. ARAMI JAYA",
      "no": "RC-202608-200",
      "rdt": "2026-08-21",
      "pono": "AJ-20260703-001",
      "arr": "2026-07-15",
      "psq": 400,
      "qty": 392,
      "amt": 1088970801,
      "cur": "IDR",
      "st": "PENDING"
    },
    {
      "sup": "HUA IN GLOBAL (SHANGHAI) CO., LTD",
      "no": "RC-202609-201",
      "rdt": "2026-07-28",
      "pono": "HI-20260927-002",
      "arr": "2026-08-16",
      "psq": 200,
      "qty": 200,
      "amt": 102042,
      "cur": "USD",
      "st": "RECEIVED"
    },
    {
      "sup": "PT. ARAMI JAYA",
      "no": "RC-202609-202",
      "rdt": "2026-07-14",
      "pono": "AJ-20260927-003",
      "arr": "2026-08-07",
      "psq": 200,
      "qty": 192,
      "amt": 1208195134,
      "cur": "IDR",
      "st": "PENDING"
    },
    {
      "sup": "PT. DIAMOND FAJAR JAYA",
      "no": "RC-202609-203",
      "rdt": "2026-08-04",
      "pono": "DF-20260925-004",
      "arr": "2026-07-17",
      "psq": 800,
      "qty": 792,
      "amt": 660973084,
      "cur": "IDR",
      "st": "COMPLETED"
    },
    {
      "sup": "HUBEI AULICE TYRE CO.,LTD",
      "no": "RC-202609-204",
      "rdt": "2026-07-24",
      "pono": "HA-20260923-005",
      "arr": "2026-08-05",
      "psq": 400,
      "qty": 400,
      "amt": 65290,
      "cur": "USD",
      "st": "COMPLETED"
    },
    {
      "sup": "PT. DIAMOND FAJAR JAYA",
      "no": "RC-202609-205",
      "rdt": "2026-08-20",
      "pono": "DF-20260909-006",
      "arr": "2026-08-16",
      "psq": 200,
      "qty": 200,
      "amt": 1241123900,
      "cur": "IDR",
      "st": "PENDING"
    },
    {
      "sup": "DONGYING RUNGOLD TYRE CO., LTD",
      "no": "RC-202608-206",
      "rdt": "2026-08-19",
      "pono": "DR-20260918-007",
      "arr": "2026-08-04",
      "psq": 200,
      "qty": 200,
      "amt": 81319,
      "cur": "USD",
      "st": "PARTIAL"
    },
    {
      "sup": "PT. ARAMI JAYA",
      "no": "RC-202609-207",
      "rdt": "2026-08-24",
      "pono": "AJ-20260826-008",
      "arr": "2026-08-08",
      "psq": 800,
      "qty": 800,
      "amt": 1273390299,
      "cur": "IDR",
      "st": "COMPLETED"
    },
    {
      "sup": "TECHKING TIRES LIMITED",
      "no": "RC-202609-208",
      "rdt": "2026-08-20",
      "pono": "TT-20260819-009",
      "arr": "2026-08-05",
      "psq": 400,
      "qty": 400,
      "amt": 149539,
      "cur": "USD",
      "st": "RECEIVED"
    },
    {
      "sup": "DONGYING RUNGOLD TYRE CO., LTD",
      "no": "RC-202609-209",
      "rdt": "2026-08-25",
      "pono": "DR-20260923-001",
      "arr": "2026-07-26",
      "psq": 800,
      "qty": 800,
      "amt": 117365,
      "cur": "USD",
      "st": "PENDING"
    },
    {
      "sup": "HUBEI AULICE TYRE CO.,LTD",
      "no": "RC-202607-210",
      "rdt": "2026-07-30",
      "pono": "HA-20260919-002",
      "arr": "2026-08-14",
      "psq": 200,
      "qty": 192,
      "amt": 83547,
      "cur": "USD",
      "st": "PENDING"
    },
    {
      "sup": "TECHKING TIRES LIMITED",
      "no": "RC-202607-211",
      "rdt": "2026-08-06",
      "pono": "TT-20260809-003",
      "arr": "2026-07-31",
      "psq": 800,
      "qty": 800,
      "amt": 82298,
      "cur": "USD",
      "st": "COMPLETED"
    },
    {
      "sup": "DONGYING RUNGOLD TYRE CO., LTD",
      "no": "RC-202608-212",
      "rdt": "2026-08-05",
      "pono": "DR-20260820-004",
      "arr": "2026-08-20",
      "psq": 400,
      "qty": 392,
      "amt": 112921,
      "cur": "USD",
      "st": "PENDING"
    },
    {
      "sup": "PT. ARAMI JAYA",
      "no": "RC-202609-213",
      "rdt": "2026-08-22",
      "pono": "AJ-20260716-005",
      "arr": "2026-08-10",
      "psq": 800,
      "qty": 792,
      "amt": 414788747,
      "cur": "IDR",
      "st": "PARTIAL"
    },
    {
      "sup": "PT. MULTISTRADA ARAH SARANA",
      "no": "RC-202608-214",
      "rdt": "2026-08-27",
      "pono": "MA-20260911-006",
      "arr": "2026-08-30",
      "psq": 200,
      "qty": 192,
      "amt": 1071671027,
      "cur": "IDR",
      "st": "RECEIVED"
    }
  ]
}
