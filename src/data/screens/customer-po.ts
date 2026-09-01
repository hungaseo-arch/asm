import type { ScreenDef } from '@/types/list-screen'

/**
 * Customer PO — PO Pelanggan · 고객 발주서 접수·관리
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/customer-po` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const customerPoScreen: ScreenDef = {
  "slug": "customer-po",
  "group": "Sales",
  "navLabel": "Customer PO",
  "title": "Customer PO",
  "subtitle": "PO Pelanggan · 고객 발주서 접수·관리",
  "cardTitle": "Customer PO List",
  "searchPlaceholder": "Customer, PO no, Quote no, Status",
  "primaryAction": "＋ NEW CUSTOMER PO",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "PO NO.",
      "key": "no"
    },
    {
      "label": "PO DATE",
      "key": "dt"
    },
    {
      "label": "CUSTOMER",
      "key": "cust"
    },
    {
      "label": "QUOTE NO.",
      "key": "qno"
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
      "label": "PAYMENT",
      "key": "pay"
    },
    {
      "label": "REQ DELIV. DATE",
      "key": "req"
    },
    {
      "label": "SALES REP",
      "key": "rep"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "no",
      "label": "PO NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "dt",
      "label": "PO DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "cust",
      "label": "CUSTOMER",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "qno",
      "label": "QUOTE NO.",
      "align": "left",
      "format": "code"
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
      "key": "pay",
      "label": "PAYMENT",
      "align": "center",
      "format": "text"
    },
    {
      "key": "req",
      "label": "REQ DELIV. DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "rep",
      "label": "SALES REP",
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
  "totalKeys": [
    "qty",
    "amt"
  ],
  "totalLabelSpan": 5,
  "pageSize": 15,
  "rows": [
    {
      "no": "CPO-2608-200",
      "dt": "2026-08-04",
      "cust": "PT Putra Perkasa Abadi",
      "qno": "QT-2608-107",
      "qty": 24,
      "amt": 51407,
      "pay": "30 Days",
      "req": "2026-11-03",
      "rep": "Hanif",
      "st": "CONFIRMED"
    },
    {
      "no": "CPO-2608-201",
      "dt": "2026-08-24",
      "cust": "PT Berau Coal",
      "qno": "QT-2608-100",
      "qty": 240,
      "amt": 119547,
      "pay": "30 Days",
      "req": "2026-10-08",
      "rep": "Rizki",
      "st": "CONFIRMED"
    },
    {
      "no": "CPO-2608-202",
      "dt": "2026-07-14",
      "cust": "PT Berau Coal",
      "qno": "QT-2608-108",
      "qty": 24,
      "amt": 270394,
      "pay": "45 Days",
      "req": "2026-11-15",
      "rep": "Hery",
      "st": "CANCELED"
    },
    {
      "no": "CPO-2608-203",
      "dt": "2026-07-17",
      "cust": "PT Cipta Kridatama",
      "qno": "QT-2608-122",
      "qty": 480,
      "amt": 103827,
      "pay": "30 Days",
      "req": "2026-10-06",
      "rep": "Arif",
      "st": "PENDING"
    },
    {
      "no": "CPO-2608-204",
      "dt": "2026-08-24",
      "cust": "PT Darma Henwa",
      "qno": "QT-2608-119",
      "qty": 144,
      "amt": 203125,
      "pay": "45 Days",
      "req": "2026-10-16",
      "rep": "Arif",
      "st": "COMPLETED"
    },
    {
      "no": "CPO-2608-205",
      "dt": "2026-08-09",
      "cust": "PT Saptaindra Sejati",
      "qno": "QT-2608-102",
      "qty": 48,
      "amt": 314085,
      "pay": "CBD",
      "req": "2026-10-27",
      "rep": "Hanif",
      "st": "CANCELED"
    },
    {
      "no": "CPO-2608-206",
      "dt": "2026-07-10",
      "cust": "PT Pamapersada Nusantara",
      "qno": "QT-2608-122",
      "qty": 96,
      "amt": 178037,
      "pay": "30 Days",
      "req": "2026-09-19",
      "rep": "Hanif",
      "st": "PENDING"
    },
    {
      "no": "CPO-2608-207",
      "dt": "2026-07-31",
      "cust": "PT Pamapersada Nusantara",
      "qno": "QT-2608-111",
      "qty": 24,
      "amt": 298566,
      "pay": "L/C at sight",
      "req": "2026-10-25",
      "rep": "Rizki",
      "st": "CANCELED"
    },
    {
      "no": "CPO-2608-208",
      "dt": "2026-08-25",
      "cust": "PT Saptaindra Sejati",
      "qno": "QT-2608-110",
      "qty": 144,
      "amt": 131609,
      "pay": "30 Days",
      "req": "2026-11-14",
      "rep": "Rizki",
      "st": "COMPLETED"
    },
    {
      "no": "CPO-2608-209",
      "dt": "2026-08-25",
      "cust": "PT Ulima Nitra",
      "qno": "QT-2608-116",
      "qty": 24,
      "amt": 323537,
      "pay": "CBD",
      "req": "2026-10-28",
      "rep": "Rizki",
      "st": "PARTIAL"
    },
    {
      "no": "CPO-2608-210",
      "dt": "2026-08-27",
      "cust": "PT Darma Henwa",
      "qno": "QT-2608-106",
      "qty": 24,
      "amt": 24177,
      "pay": "45 Days",
      "req": "2026-11-02",
      "rep": "Hery",
      "st": "CONFIRMED"
    },
    {
      "no": "CPO-2608-211",
      "dt": "2026-07-26",
      "cust": "PT Berau Coal",
      "qno": "QT-2608-119",
      "qty": 24,
      "amt": 52738,
      "pay": "60 Days",
      "req": "2026-10-30",
      "rep": "Hery",
      "st": "PENDING"
    },
    {
      "no": "CPO-2608-212",
      "dt": "2026-08-03",
      "cust": "PT Thiess Contractors Indonesia",
      "qno": "QT-2608-111",
      "qty": 480,
      "amt": 333189,
      "pay": "60 Days",
      "req": "2026-11-11",
      "rep": "Rizki",
      "st": "COMPLETED"
    },
    {
      "no": "CPO-2608-213",
      "dt": "2026-07-31",
      "cust": "PT Putra Perkasa Abadi",
      "qno": "QT-2608-110",
      "qty": 48,
      "amt": 193050,
      "pay": "30 Days",
      "req": "2026-11-15",
      "rep": "Rizki",
      "st": "COMPLETED"
    },
    {
      "no": "CPO-2608-214",
      "dt": "2026-08-18",
      "cust": "PT Darma Henwa",
      "qno": "QT-2608-121",
      "qty": 144,
      "amt": 114716,
      "pay": "30 Days",
      "req": "2026-11-13",
      "rep": "Hanif",
      "st": "CONFIRMED"
    },
    {
      "no": "CPO-2608-215",
      "dt": "2026-07-09",
      "cust": "PT Saptaindra Sejati",
      "qno": "QT-2608-123",
      "qty": 480,
      "amt": 242903,
      "pay": "60 Days",
      "req": "2026-09-10",
      "rep": "Eri",
      "st": "COMPLETED"
    },
    {
      "no": "CPO-2608-216",
      "dt": "2026-08-07",
      "cust": "PT Pamapersada Nusantara",
      "qno": "QT-2608-113",
      "qty": 240,
      "amt": 244833,
      "pay": "45 Days",
      "req": "2026-10-12",
      "rep": "Hanif",
      "st": "COMPLETED"
    },
    {
      "no": "CPO-2608-217",
      "dt": "2026-08-19",
      "cust": "PT Saptaindra Sejati",
      "qno": "QT-2608-122",
      "qty": 144,
      "amt": 218053,
      "pay": "CBD",
      "req": "2026-10-06",
      "rep": "Hery",
      "st": "CANCELED"
    },
    {
      "no": "CPO-2608-218",
      "dt": "2026-08-14",
      "cust": "PT Darma Henwa",
      "qno": "QT-2608-104",
      "qty": 240,
      "amt": 317571,
      "pay": "30 Days",
      "req": "2026-10-09",
      "rep": "Arif",
      "st": "PENDING"
    },
    {
      "no": "CPO-2608-219",
      "dt": "2026-07-20",
      "cust": "PT Ulima Nitra",
      "qno": "QT-2608-106",
      "qty": 24,
      "amt": 273414,
      "pay": "L/C at sight",
      "req": "2026-10-28",
      "rep": "Eri",
      "st": "PARTIAL"
    },
    {
      "no": "CPO-2608-220",
      "dt": "2026-07-20",
      "cust": "PT Putra Perkasa Abadi",
      "qno": "QT-2608-111",
      "qty": 96,
      "amt": 51841,
      "pay": "45 Days",
      "req": "2026-10-14",
      "rep": "Eri",
      "st": "PENDING"
    }
  ]
}
