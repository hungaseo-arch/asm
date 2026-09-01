import type { ScreenDef } from '@/types/list-screen'

/**
 * Delivery Order — Surat Jalan (DO) · 출하지시서
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/delivery-order` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const deliveryOrderScreen: ScreenDef = {
  "slug": "delivery-order",
  "group": "Sales",
  "navLabel": "Delivery Order",
  "title": "Delivery Order",
  "subtitle": "Surat Jalan (DO) · 출하지시서",
  "cardTitle": "Delivery Order List",
  "searchPlaceholder": "Customer, DO no, SO no, Vehicle no",
  "primaryAction": "＋ NEW DO",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "DO NO.",
      "key": "no"
    },
    {
      "label": "DO DATE",
      "key": "dt"
    },
    {
      "label": "SO NO.",
      "key": "sono"
    },
    {
      "label": "CUSTOMER",
      "key": "cust"
    },
    {
      "label": "WAREHOUSE",
      "key": "wh"
    },
    {
      "label": "QTY",
      "key": "qty"
    },
    {
      "label": "DRIVER",
      "key": "drv"
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
      "label": "DO NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "dt",
      "label": "DO DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "sono",
      "label": "SO NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "cust",
      "label": "CUSTOMER",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "wh",
      "label": "WAREHOUSE",
      "align": "center",
      "format": "text"
    },
    {
      "key": "qty",
      "label": "QTY",
      "align": "right",
      "format": "int"
    },
    {
      "key": "drv",
      "label": "DRIVER",
      "align": "center",
      "format": "text"
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
  "totalLabelSpan": 6,
  "pageSize": 15,
  "rows": [
    {
      "no": "DO-2608-400",
      "dt": "2026-08-16",
      "sono": "SO-2608-300",
      "cust": "PT Ulima Nitra",
      "wh": "Cikarang WH",
      "qty": 24,
      "drv": "Joko",
      "veh": "KT 7712 AL",
      "eta": "2026-09-02",
      "st": "ISSUED"
    },
    {
      "no": "DO-2608-401",
      "dt": "2026-08-30",
      "sono": "SO-2608-314",
      "cust": "PT Darma Henwa",
      "wh": "Balikpapan WH",
      "qty": 120,
      "drv": "Budi",
      "veh": "L 8871 KP",
      "eta": "2026-09-02",
      "st": "IN TRANSIT"
    },
    {
      "no": "DO-2608-402",
      "dt": "2026-08-18",
      "sono": "SO-2608-307",
      "cust": "PT Cipta Kridatama",
      "wh": "Cikarang WH",
      "qty": 36,
      "drv": "Budi",
      "veh": "L 8871 KP",
      "eta": "2026-09-10",
      "st": "PENDING"
    },
    {
      "no": "DO-2608-403",
      "dt": "2026-08-30",
      "sono": "SO-2608-307",
      "cust": "PT Kaltim Prima Coal",
      "wh": "Semarang WH",
      "qty": 96,
      "drv": "Budi",
      "veh": "H 4420 ND",
      "eta": "2026-09-07",
      "st": "IN TRANSIT"
    },
    {
      "no": "DO-2608-404",
      "dt": "2026-08-25",
      "sono": "SO-2608-304",
      "cust": "PT Ulima Nitra",
      "wh": "Semarang WH",
      "qty": 24,
      "drv": "Wayan",
      "veh": "H 4420 ND",
      "eta": "2026-09-05",
      "st": "IN TRANSIT"
    },
    {
      "no": "DO-2608-405",
      "dt": "2026-08-04",
      "sono": "SO-2608-317",
      "cust": "PT Saptaindra Sejati",
      "wh": "Palembang WH",
      "qty": 24,
      "drv": "Slamet",
      "veh": "BG 3390 QN",
      "eta": "2026-09-01",
      "st": "DELIVERED"
    },
    {
      "no": "DO-2608-406",
      "dt": "2026-08-25",
      "sono": "SO-2608-306",
      "cust": "PT Putra Perkasa Abadi",
      "wh": "Palembang WH",
      "qty": 48,
      "drv": "Slamet",
      "veh": "BG 3390 QN",
      "eta": "2026-09-12",
      "st": "ISSUED"
    },
    {
      "no": "DO-2608-407",
      "dt": "2026-08-30",
      "sono": "SO-2608-308",
      "cust": "PT Darma Henwa",
      "wh": "Balikpapan WH",
      "qty": 36,
      "drv": "Budi",
      "veh": "BG 3390 QN",
      "eta": "2026-09-06",
      "st": "PENDING"
    },
    {
      "no": "DO-2608-408",
      "dt": "2026-08-22",
      "sono": "SO-2608-310",
      "cust": "PT Berau Coal",
      "wh": "Balikpapan WH",
      "qty": 120,
      "drv": "Agus",
      "veh": "L 8871 KP",
      "eta": "2026-09-13",
      "st": "CANCELED"
    },
    {
      "no": "DO-2608-409",
      "dt": "2026-08-15",
      "sono": "SO-2608-302",
      "cust": "PT Saptaindra Sejati",
      "wh": "Semarang WH",
      "qty": 48,
      "drv": "Agus",
      "veh": "H 4420 ND",
      "eta": "2026-09-14",
      "st": "ISSUED"
    },
    {
      "no": "DO-2608-410",
      "dt": "2026-08-31",
      "sono": "SO-2608-305",
      "cust": "PT Darma Henwa",
      "wh": "Surabaya WH",
      "qty": 96,
      "drv": "Wayan",
      "veh": "KT 7712 AL",
      "eta": "2026-09-14",
      "st": "CANCELED"
    },
    {
      "no": "DO-2608-411",
      "dt": "2026-08-25",
      "sono": "SO-2608-311",
      "cust": "PT Putra Perkasa Abadi",
      "wh": "Balikpapan WH",
      "qty": 48,
      "drv": "Slamet",
      "veh": "H 4420 ND",
      "eta": "2026-09-12",
      "st": "ISSUED"
    },
    {
      "no": "DO-2608-412",
      "dt": "2026-08-25",
      "sono": "SO-2608-300",
      "cust": "PT Thiess Contractors Indonesia",
      "wh": "Surabaya WH",
      "qty": 120,
      "drv": "Agus",
      "veh": "H 4420 ND",
      "eta": "2026-09-06",
      "st": "PENDING"
    },
    {
      "no": "DO-2608-413",
      "dt": "2026-08-26",
      "sono": "SO-2608-312",
      "cust": "PT Pamapersada Nusantara",
      "wh": "Palembang WH",
      "qty": 120,
      "drv": "Agus",
      "veh": "BG 3390 QN",
      "eta": "2026-09-14",
      "st": "CANCELED"
    },
    {
      "no": "DO-2608-414",
      "dt": "2026-08-26",
      "sono": "SO-2608-305",
      "cust": "PT Darma Henwa",
      "wh": "Semarang WH",
      "qty": 36,
      "drv": "Budi",
      "veh": "L 8871 KP",
      "eta": "2026-09-15",
      "st": "ISSUED"
    },
    {
      "no": "DO-2608-415",
      "dt": "2026-08-06",
      "sono": "SO-2608-310",
      "cust": "PT Putra Perkasa Abadi",
      "wh": "Semarang WH",
      "qty": 12,
      "drv": "Joko",
      "veh": "B 9123 UYZ",
      "eta": "2026-09-04",
      "st": "PENDING"
    },
    {
      "no": "DO-2608-416",
      "dt": "2026-08-13",
      "sono": "SO-2608-305",
      "cust": "PT Bukit Makmur Mandiri",
      "wh": "Palembang WH",
      "qty": 120,
      "drv": "Budi",
      "veh": "BG 3390 QN",
      "eta": "2026-09-14",
      "st": "CANCELED"
    },
    {
      "no": "DO-2608-417",
      "dt": "2026-08-11",
      "sono": "SO-2608-312",
      "cust": "PT Kaltim Prima Coal",
      "wh": "Palembang WH",
      "qty": 120,
      "drv": "Wayan",
      "veh": "KT 7712 AL",
      "eta": "2026-09-13",
      "st": "CANCELED"
    }
  ]
}
