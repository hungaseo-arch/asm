import type { ScreenDef } from '@/types/list-screen'

/**
 * Delivery Note — Bukti Terima Barang · 납품확인서
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/delivery-note` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const deliveryNoteScreen: ScreenDef = {
  "slug": "delivery-note",
  "group": "Sales",
  "navLabel": "Delivery Note",
  "title": "Delivery Note",
  "subtitle": "Bukti Terima Barang · 납품확인서",
  "cardTitle": "Delivery Note List",
  "searchPlaceholder": "Customer, DN no, DO no, Received by",
  "primaryAction": "＋ NEW DN",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "DN NO.",
      "key": "no"
    },
    {
      "label": "DN DATE",
      "key": "dt"
    },
    {
      "label": "DO NO.",
      "key": "dono"
    },
    {
      "label": "CUSTOMER",
      "key": "cust"
    },
    {
      "label": "QTY",
      "key": "qty"
    },
    {
      "label": "AMOUNT",
      "key": "amt"
    },
    {
      "label": "RECEIVED BY",
      "key": "rcv"
    },
    {
      "label": "RECEIVED DATE",
      "key": "rdt"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "no",
      "label": "DN NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "dt",
      "label": "DN DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "dono",
      "label": "DO NO.",
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
      "currency": "USD"
    },
    {
      "key": "rcv",
      "label": "RECEIVED BY",
      "align": "center",
      "format": "text"
    },
    {
      "key": "rdt",
      "label": "RECEIVED DATE",
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
    "qty",
    "amt"
  ],
  "totalLabelSpan": 5,
  "pageSize": 15,
  "rows": [
    {
      "no": "DN-2608-500",
      "dt": "2026-08-26",
      "dono": "DO-2608-406",
      "cust": "PT Cipta Kridatama",
      "qty": 12,
      "amt": 55325,
      "rcv": "Sdr. Nanang",
      "rdt": "2026-08-19",
      "st": "DELIVERED"
    },
    {
      "no": "DN-2608-501",
      "dt": "2026-08-15",
      "dono": "DO-2608-412",
      "cust": "PT Kaltim Prima Coal",
      "qty": 12,
      "amt": 68723,
      "rcv": "Sdr. Bagus",
      "rdt": "2026-08-15",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-502",
      "dt": "2026-08-30",
      "dono": "DO-2608-400",
      "cust": "PT Kaltim Prima Coal",
      "qty": 96,
      "amt": 15740,
      "rcv": "Sdr. Nanang",
      "rdt": "2026-08-14",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-503",
      "dt": "2026-08-11",
      "dono": "DO-2608-408",
      "cust": "PT Cipta Kridatama",
      "qty": 48,
      "amt": 92434,
      "rcv": "Sdr. Nanang",
      "rdt": "2026-08-09",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-504",
      "dt": "2026-08-19",
      "dono": "DO-2608-409",
      "cust": "PT Bukit Makmur Mandiri",
      "qty": 36,
      "amt": 37247,
      "rcv": "Sdr. Bagus",
      "rdt": "2026-08-31",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-505",
      "dt": "2026-08-06",
      "dono": "DO-2608-407",
      "cust": "PT Pamapersada Nusantara",
      "qty": 24,
      "amt": 151767,
      "rcv": "Sdr. Nanang",
      "rdt": "2026-08-18",
      "st": "DELIVERED"
    },
    {
      "no": "DN-2608-506",
      "dt": "2026-08-10",
      "dono": "DO-2608-416",
      "cust": "PT Thiess Contractors Indonesia",
      "qty": 36,
      "amt": 157468,
      "rcv": "Sdr. Nanang",
      "rdt": "2026-08-23",
      "st": "RECEIVED"
    },
    {
      "no": "DN-2608-507",
      "dt": "2026-09-01",
      "dono": "DO-2608-409",
      "cust": "PT Pamapersada Nusantara",
      "qty": 96,
      "amt": 95682,
      "rcv": "Sdr. Iwan",
      "rdt": "2026-08-30",
      "st": "PENDING"
    },
    {
      "no": "DN-2608-508",
      "dt": "2026-08-21",
      "dono": "DO-2608-400",
      "cust": "PT Cipta Kridatama",
      "qty": 36,
      "amt": 15177,
      "rcv": "Sdr. Iwan",
      "rdt": "2026-08-28",
      "st": "RECEIVED"
    },
    {
      "no": "DN-2608-509",
      "dt": "2026-09-01",
      "dono": "DO-2608-405",
      "cust": "PT Pamapersada Nusantara",
      "qty": 96,
      "amt": 155247,
      "rcv": "Sdr. Bagus",
      "rdt": "2026-08-15",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-510",
      "dt": "2026-08-18",
      "dono": "DO-2608-408",
      "cust": "PT Kaltim Prima Coal",
      "qty": 36,
      "amt": 116992,
      "rcv": "Sdri. Rina",
      "rdt": "2026-08-07",
      "st": "DELIVERED"
    },
    {
      "no": "DN-2608-511",
      "dt": "2026-08-11",
      "dono": "DO-2608-401",
      "cust": "PT Kaltim Prima Coal",
      "qty": 12,
      "amt": 27848,
      "rcv": "Sdr. Nanang",
      "rdt": "2026-08-24",
      "st": "PENDING"
    },
    {
      "no": "DN-2608-512",
      "dt": "2026-08-29",
      "dono": "DO-2608-405",
      "cust": "PT Berau Coal",
      "qty": 24,
      "amt": 127153,
      "rcv": "Sdr. Hendra",
      "rdt": "2026-08-20",
      "st": "RECEIVED"
    },
    {
      "no": "DN-2608-513",
      "dt": "2026-08-24",
      "dono": "DO-2608-402",
      "cust": "PT Kaltim Prima Coal",
      "qty": 48,
      "amt": 11523,
      "rcv": "Sdr. Iwan",
      "rdt": "2026-08-07",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-514",
      "dt": "2026-08-15",
      "dono": "DO-2608-416",
      "cust": "PT Bukit Makmur Mandiri",
      "qty": 24,
      "amt": 158148,
      "rcv": "Sdr. Bagus",
      "rdt": "2026-08-31",
      "st": "DELIVERED"
    },
    {
      "no": "DN-2608-515",
      "dt": "2026-08-16",
      "dono": "DO-2608-401",
      "cust": "PT Ulima Nitra",
      "qty": 96,
      "amt": 40959,
      "rcv": "Sdr. Hendra",
      "rdt": "2026-08-29",
      "st": "PARTIAL"
    },
    {
      "no": "DN-2608-516",
      "dt": "2026-08-21",
      "dono": "DO-2608-406",
      "cust": "PT Putra Perkasa Abadi",
      "qty": 24,
      "amt": 122061,
      "rcv": "Sdr. Bagus",
      "rdt": "2026-08-30",
      "st": "RECEIVED"
    }
  ]
}
