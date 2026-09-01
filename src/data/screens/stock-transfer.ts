import type { ScreenDef } from '@/types/list-screen'

/**
 * Stock Transfer — Transfer Antar Gudang · 창고 간 이고
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/stock-transfer` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const stockTransferScreen: ScreenDef = {
  "slug": "stock-transfer",
  "group": "Inventory",
  "navLabel": "Stock Transfer",
  "title": "Stock Transfer",
  "subtitle": "Transfer Antar Gudang · 창고 간 이고",
  "cardTitle": "Stock Transfer List",
  "searchPlaceholder": "Trf no, Item code, From WH, To WH",
  "primaryAction": "＋ NEW TRANSFER",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "TRF NO.",
      "key": "no"
    },
    {
      "label": "TRF DATE",
      "key": "dt"
    },
    {
      "label": "FROM WH",
      "key": "fwh"
    },
    {
      "label": "TO WH",
      "key": "twh"
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
      "label": "QTY",
      "key": "qty"
    },
    {
      "label": "VEHICLE NO.",
      "key": "veh"
    },
    {
      "label": "EST ARRIVAL",
      "key": "eta"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "no",
      "label": "TRF NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "dt",
      "label": "TRF DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "fwh",
      "label": "FROM WH",
      "align": "center",
      "format": "text"
    },
    {
      "key": "twh",
      "label": "TO WH",
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
      "key": "qty",
      "label": "QTY",
      "align": "right",
      "format": "int"
    },
    {
      "key": "veh",
      "label": "VEHICLE NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "eta",
      "label": "EST ARRIVAL",
      "align": "center",
      "format": "date"
    },
    {
      "key": "st",
      "label": "STATUS",
      "align": "center",
      "format": "badge"
    }
  ],
  "totalKeys": [
    "qty"
  ],
  "totalLabelSpan": 7,
  "pageSize": 15,
  "rows": [
    {
      "no": "TRF-2608-800",
      "dt": "2026-08-27",
      "fwh": "Surabaya WH",
      "twh": "Cikarang WH",
      "code": "IND-4593",
      "size": "29.5R25",
      "qty": 12,
      "veh": "H 4420 ND",
      "eta": "2026-09-09",
      "st": "ISSUED"
    },
    {
      "no": "TRF-2608-801",
      "dt": "2026-08-14",
      "fwh": "Surabaya WH",
      "twh": "Balikpapan WH",
      "code": "AGR-9885",
      "size": "18.4-34",
      "qty": 48,
      "veh": "L 8871 KP",
      "eta": "2026-09-07",
      "st": "ISSUED"
    },
    {
      "no": "TRF-2608-802",
      "dt": "2026-08-04",
      "fwh": "Semarang WH",
      "twh": "Surabaya WH",
      "code": "TB-B-8901",
      "size": "29.5R25",
      "qty": 24,
      "veh": "B 9123 UYZ",
      "eta": "2026-09-11",
      "st": "ISSUED"
    },
    {
      "no": "TRF-2608-803",
      "dt": "2026-08-04",
      "fwh": "Cikarang WH",
      "twh": "Balikpapan WH",
      "code": "OTR-1718",
      "size": "825-16",
      "qty": 120,
      "veh": "B 9123 UYZ",
      "eta": "2026-09-12",
      "st": "PENDING"
    },
    {
      "no": "TRF-2608-804",
      "dt": "2026-08-05",
      "fwh": "Palembang WH",
      "twh": "Semarang WH",
      "code": "TB-R-5670",
      "size": "700-12",
      "qty": 60,
      "veh": "KT 7712 AL",
      "eta": "2026-09-10",
      "st": "PENDING"
    },
    {
      "no": "TRF-2608-805",
      "dt": "2026-08-04",
      "fwh": "Cikarang WH",
      "twh": "Palembang WH",
      "code": "IND-6331",
      "size": "29.5R25",
      "qty": 12,
      "veh": "H 4420 ND",
      "eta": "2026-09-12",
      "st": "IN TRANSIT"
    },
    {
      "no": "TRF-2608-806",
      "dt": "2026-08-29",
      "fwh": "Surabaya WH",
      "twh": "Cikarang WH",
      "code": "TB-B-8984",
      "size": "700-12",
      "qty": 24,
      "veh": "H 4420 ND",
      "eta": "2026-09-07",
      "st": "ISSUED"
    },
    {
      "no": "TRF-2608-807",
      "dt": "2026-08-06",
      "fwh": "Cikarang WH",
      "twh": "Semarang WH",
      "code": "OTR-6300",
      "size": "18.4-34",
      "qty": 48,
      "veh": "L 8871 KP",
      "eta": "2026-09-03",
      "st": "PENDING"
    },
    {
      "no": "TRF-2608-808",
      "dt": "2026-08-29",
      "fwh": "Cikarang WH",
      "twh": "Balikpapan WH",
      "code": "AGR-6934",
      "size": "700-12",
      "qty": 24,
      "veh": "L 8871 KP",
      "eta": "2026-09-03",
      "st": "IN TRANSIT"
    },
    {
      "no": "TRF-2608-809",
      "dt": "2026-08-20",
      "fwh": "Cikarang WH",
      "twh": "Balikpapan WH",
      "code": "TB-B-7529",
      "size": "29.5R25",
      "qty": 24,
      "veh": "L 8871 KP",
      "eta": "2026-09-13",
      "st": "IN TRANSIT"
    },
    {
      "no": "TRF-2608-810",
      "dt": "2026-08-16",
      "fwh": "Palembang WH",
      "twh": "Surabaya WH",
      "code": "TB-R-4297",
      "size": "750-16",
      "qty": 12,
      "veh": "B 9123 UYZ",
      "eta": "2026-09-03",
      "st": "PENDING"
    },
    {
      "no": "TRF-2608-811",
      "dt": "2026-08-27",
      "fwh": "Semarang WH",
      "twh": "Surabaya WH",
      "code": "TB-B-3799",
      "size": "29.5R25",
      "qty": 24,
      "veh": "L 8871 KP",
      "eta": "2026-09-08",
      "st": "ISSUED"
    },
    {
      "no": "TRF-2608-812",
      "dt": "2026-08-25",
      "fwh": "Semarang WH",
      "twh": "Cikarang WH",
      "code": "OTR-2115",
      "size": "825-16",
      "qty": 60,
      "veh": "B 9123 UYZ",
      "eta": "2026-09-09",
      "st": "CANCELED"
    },
    {
      "no": "TRF-2608-813",
      "dt": "2026-08-24",
      "fwh": "Semarang WH",
      "twh": "Cikarang WH",
      "code": "AGR-9166",
      "size": "1000R20",
      "qty": 12,
      "veh": "KT 7712 AL",
      "eta": "2026-09-09",
      "st": "ISSUED"
    },
    {
      "no": "TRF-2608-814",
      "dt": "2026-09-01",
      "fwh": "Semarang WH",
      "twh": "Palembang WH",
      "code": "TB-B-2442",
      "size": "26.5R25",
      "qty": 48,
      "veh": "L 8871 KP",
      "eta": "2026-09-03",
      "st": "ISSUED"
    }
  ]
}
