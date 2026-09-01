import type { ScreenDef } from '@/types/list-screen'

/**
 * Stock Movement — Mutasi Stok · 재고 입출고 내역
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/stock-movement` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const stockMovementScreen: ScreenDef = {
  "slug": "stock-movement",
  "group": "Inventory",
  "navLabel": "Stock Movement",
  "title": "Stock Movement",
  "subtitle": "Mutasi Stok · 재고 입출고 내역",
  "cardTitle": "Stock Movement List",
  "searchPlaceholder": "Doc no, Item code, Size, Warehouse",
  "primaryAction": "",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "DATE",
      "key": "dt"
    },
    {
      "label": "DOC NO.",
      "key": "doc"
    },
    {
      "label": "TYPE",
      "key": "typ"
    },
    {
      "label": "WAREHOUSE",
      "key": "wh"
    },
    {
      "label": "ITEM CODE",
      "key": "code"
    },
    {
      "label": "SIZE",
      "key": "size"
    },
    {
      "label": "PATTERN",
      "key": "patt"
    },
    {
      "label": "IN",
      "key": "inq"
    },
    {
      "label": "OUT",
      "key": "outq"
    },
    {
      "label": "BALANCE",
      "key": "bal"
    },
    {
      "label": "REMARK",
      "key": "rmk"
    }
  ],
  "columns": [
    {
      "key": "dt",
      "label": "DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "doc",
      "label": "DOC NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "typ",
      "label": "TYPE",
      "align": "center",
      "format": "badge"
    },
    {
      "key": "wh",
      "label": "WAREHOUSE",
      "align": "center",
      "format": "text"
    },
    {
      "key": "code",
      "label": "ITEM CODE",
      "align": "left",
      "format": "code"
    },
    {
      "key": "size",
      "label": "SIZE",
      "align": "left",
      "format": "text"
    },
    {
      "key": "patt",
      "label": "PATTERN",
      "align": "left",
      "format": "text"
    },
    {
      "key": "inq",
      "label": "IN",
      "align": "right",
      "format": "int"
    },
    {
      "key": "outq",
      "label": "OUT",
      "align": "right",
      "format": "int"
    },
    {
      "key": "bal",
      "label": "BALANCE",
      "align": "right",
      "format": "int"
    },
    {
      "key": "rmk",
      "label": "REMARK",
      "align": "left",
      "format": "text",
      "ellipsis": true
    }
  ],
  "totalKeys": [
    "inq",
    "outq"
  ],
  "totalLabelSpan": 8,
  "pageSize": 15,
  "rows": [
    {
      "dt": "2026-08-11",
      "doc": "RC-2608-600",
      "typ": "RECEIVED",
      "wh": "Balikpapan WH",
      "code": "OTR-7267",
      "size": "825-16",
      "patt": "ETSM",
      "inq": 120,
      "outq": 0,
      "bal": 365,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-26",
      "doc": "DN-2608-601",
      "typ": "POSTED",
      "wh": "Balikpapan WH",
      "code": "TB-B-4213",
      "size": "1100R20",
      "patt": "AS-668",
      "inq": 0,
      "outq": 12,
      "bal": 500,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-18",
      "doc": "RC-2608-602",
      "typ": "RECEIVED",
      "wh": "Cikarang WH",
      "code": "TB-B-8195",
      "size": "700-12",
      "patt": "AS-682",
      "inq": 120,
      "outq": 0,
      "bal": 489,
      "rmk": "Adjustment"
    },
    {
      "dt": "2026-07-30",
      "doc": "DN-2608-603",
      "typ": "POSTED",
      "wh": "Cikarang WH",
      "code": "TB-B-2861",
      "size": "1000R20",
      "patt": "AS-668",
      "inq": 0,
      "outq": 36,
      "bal": 515,
      "rmk": "Import container"
    },
    {
      "dt": "2026-08-21",
      "doc": "DN-2608-604",
      "typ": "DELIVERED",
      "wh": "Cikarang WH",
      "code": "TB-R-3942",
      "size": "1200R24",
      "patt": "R-1",
      "inq": 0,
      "outq": 24,
      "bal": 511,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-07-23",
      "doc": "DN-2608-605",
      "typ": "DELIVERED",
      "wh": "Cikarang WH",
      "code": "TB-B-7538",
      "size": "750-16",
      "patt": "FL-01",
      "inq": 0,
      "outq": 48,
      "bal": 738,
      "rmk": "—"
    },
    {
      "dt": "2026-08-22",
      "doc": "DN-2608-606",
      "typ": "DELIVERED",
      "wh": "Palembang WH",
      "code": "TB-R-4638",
      "size": "29.5R25",
      "patt": "E4",
      "inq": 0,
      "outq": 24,
      "bal": 800,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-17",
      "doc": "RC-2608-607",
      "typ": "RECEIVED",
      "wh": "Semarang WH",
      "code": "OTR-4220",
      "size": "23.5R25",
      "patt": "ETSM",
      "inq": 24,
      "outq": 0,
      "bal": 879,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-16",
      "doc": "DN-2608-608",
      "typ": "DELIVERED",
      "wh": "Cikarang WH",
      "code": "OTR-5161",
      "size": "750-16",
      "patt": "E4",
      "inq": 0,
      "outq": 36,
      "bal": 417,
      "rmk": "Transfer masuk"
    },
    {
      "dt": "2026-08-16",
      "doc": "DN-2608-609",
      "typ": "DELIVERED",
      "wh": "Balikpapan WH",
      "code": "TB-B-1780",
      "size": "1200R24",
      "patt": "E3/L3",
      "inq": 0,
      "outq": 48,
      "bal": 795,
      "rmk": "—"
    },
    {
      "dt": "2026-08-15",
      "doc": "DN-2608-610",
      "typ": "POSTED",
      "wh": "Balikpapan WH",
      "code": "TB-B-8159",
      "size": "700-12",
      "patt": "R-1",
      "inq": 0,
      "outq": 36,
      "bal": 428,
      "rmk": "Transfer masuk"
    },
    {
      "dt": "2026-07-22",
      "doc": "DN-2608-611",
      "typ": "DELIVERED",
      "wh": "Balikpapan WH",
      "code": "TB-R-7529",
      "size": "1000R20",
      "patt": "FL-01",
      "inq": 0,
      "outq": 12,
      "bal": 773,
      "rmk": "Import container"
    },
    {
      "dt": "2026-07-29",
      "doc": "DN-2608-612",
      "typ": "DELIVERED",
      "wh": "Surabaya WH",
      "code": "TB-R-1117",
      "size": "29.5R25",
      "patt": "AS-661",
      "inq": 0,
      "outq": 48,
      "bal": 134,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-23",
      "doc": "DN-2608-613",
      "typ": "POSTED",
      "wh": "Balikpapan WH",
      "code": "TB-B-2774",
      "size": "750-16",
      "patt": "AS-668",
      "inq": 0,
      "outq": 36,
      "bal": 440,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-17",
      "doc": "DN-2608-614",
      "typ": "POSTED",
      "wh": "Balikpapan WH",
      "code": "IND-5750",
      "size": "750-16",
      "patt": "E3",
      "inq": 0,
      "outq": 24,
      "bal": 49,
      "rmk": "Import container"
    },
    {
      "dt": "2026-08-11",
      "doc": "DN-2608-615",
      "typ": "POSTED",
      "wh": "Balikpapan WH",
      "code": "OTR-6427",
      "size": "29.5R25",
      "patt": "AS-682",
      "inq": 0,
      "outq": 12,
      "bal": 321,
      "rmk": "Import container"
    },
    {
      "dt": "2026-07-27",
      "doc": "RC-2608-616",
      "typ": "RECEIVED",
      "wh": "Surabaya WH",
      "code": "OTR-9533",
      "size": "1000R20",
      "patt": "R-1",
      "inq": 0,
      "outq": 0,
      "bal": 473,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-19",
      "doc": "RC-2608-617",
      "typ": "RECEIVED",
      "wh": "Cikarang WH",
      "code": "AGR-8903",
      "size": "23.5R25",
      "patt": "R-1",
      "inq": 0,
      "outq": 0,
      "bal": 147,
      "rmk": "Transfer masuk"
    },
    {
      "dt": "2026-07-30",
      "doc": "DN-2608-618",
      "typ": "DELIVERED",
      "wh": "Surabaya WH",
      "code": "AGR-9293",
      "size": "825-16",
      "patt": "E3/L3",
      "inq": 0,
      "outq": 12,
      "bal": 676,
      "rmk": "Import container"
    },
    {
      "dt": "2026-08-23",
      "doc": "RC-2608-619",
      "typ": "RECEIVED",
      "wh": "Palembang WH",
      "code": "IND-6039",
      "size": "18.4-34",
      "patt": "E3",
      "inq": 240,
      "outq": 0,
      "bal": 39,
      "rmk": "Penjualan"
    },
    {
      "dt": "2026-08-14",
      "doc": "DN-2608-620",
      "typ": "DELIVERED",
      "wh": "Semarang WH",
      "code": "TB-B-5694",
      "size": "18.4-34",
      "patt": "AS-682",
      "inq": 0,
      "outq": 36,
      "bal": 715,
      "rmk": "Transfer masuk"
    },
    {
      "dt": "2026-08-11",
      "doc": "DN-2608-621",
      "typ": "POSTED",
      "wh": "Cikarang WH",
      "code": "OTR-8654",
      "size": "18.4-34",
      "patt": "R-1",
      "inq": 0,
      "outq": 48,
      "bal": 79,
      "rmk": "Transfer masuk"
    },
    {
      "dt": "2026-08-22",
      "doc": "DN-2608-622",
      "typ": "POSTED",
      "wh": "Palembang WH",
      "code": "TB-R-4096",
      "size": "26.5R25",
      "patt": "E4",
      "inq": 0,
      "outq": 24,
      "bal": 365,
      "rmk": "Transfer masuk"
    },
    {
      "dt": "2026-08-10",
      "doc": "DN-2608-623",
      "typ": "POSTED",
      "wh": "Balikpapan WH",
      "code": "IND-5507",
      "size": "18.4-34",
      "patt": "AS-108",
      "inq": 0,
      "outq": 24,
      "bal": 594,
      "rmk": "Adjustment"
    },
    {
      "dt": "2026-08-06",
      "doc": "RC-2608-624",
      "typ": "RECEIVED",
      "wh": "Balikpapan WH",
      "code": "OTR-9577",
      "size": "1200R24",
      "patt": "AS-661",
      "inq": 48,
      "outq": 0,
      "bal": 244,
      "rmk": "—"
    },
    {
      "dt": "2026-08-18",
      "doc": "DN-2608-625",
      "typ": "DELIVERED",
      "wh": "Semarang WH",
      "code": "OTR-5127",
      "size": "23.5R25",
      "patt": "E4",
      "inq": 0,
      "outq": 36,
      "bal": 250,
      "rmk": "Import container"
    }
  ]
}
