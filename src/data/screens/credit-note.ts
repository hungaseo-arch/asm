import type { ScreenDef } from '@/types/list-screen'

/**
 * Credit Note — Credit Note Main · Nota Kredit · 반품 대금 정산
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/credit-note` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const creditNoteScreen: ScreenDef = {
  "slug": "credit-note",
  "group": "Purchasing",
  "navLabel": "Credit Note",
  "title": "Credit Note",
  "subtitle": "Credit Note Main · Nota Kredit · 반품 대금 정산",
  "cardTitle": "All Credit Notes",
  "searchPlaceholder": "Return no, Credit note no, Supplier, Receipt no",
  "primaryAction": "",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    }
  ],
  "columns": [
    {
      "key": "no",
      "label": "CREDIT NOTE NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "cdt",
      "label": "C. NOTE DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "rdt",
      "label": "RETURN DATE",
      "align": "center",
      "format": "date"
    },
    {
      "key": "rc",
      "label": "RECEIPT NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "sup",
      "label": "SUPPLIER",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "inv",
      "label": "SJL/INV NO.",
      "align": "left",
      "format": "code"
    },
    {
      "key": "rtq",
      "label": "RTN QTY",
      "align": "right",
      "format": "int"
    },
    {
      "key": "amt",
      "label": "CREDIT AMOUNT",
      "align": "right",
      "format": "currency",
      "currencyKey": "cur"
    },
    {
      "key": "wh",
      "label": "WAREHOUSE",
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
    "rtq"
  ],
  "totalLabelSpan": 4,
  "pageSize": 15,
  "rows": [
    {
      "no": "CN-202608-500",
      "cdt": "2026-08-11",
      "rdt": "2026-08-05",
      "rc": "RC-202607-200",
      "sup": "HUBEI AULICE TYRE CO.,LTD",
      "inv": "INV/78291/2026",
      "rtq": 24,
      "amt": 3876,
      "cur": "USD",
      "wh": "Surabaya WH",
      "st": "COMPLETED"
    },
    {
      "no": "CN-202609-501",
      "cdt": "2026-07-30",
      "rdt": "2026-07-30",
      "rc": "RC-202608-201",
      "sup": "HUA IN GLOBAL (SHANGHAI) CO., LTD",
      "inv": "INV/19671/2026",
      "rtq": 24,
      "amt": 6407,
      "cur": "USD",
      "wh": "Palembang WH",
      "st": "APPROVED"
    },
    {
      "no": "CN-202608-502",
      "cdt": "2026-08-03",
      "rdt": "2026-08-08",
      "rc": "RC-202607-202",
      "sup": "DONGYING RUNGOLD TYRE CO., LTD",
      "inv": "INV/87728/2026",
      "rtq": 12,
      "amt": 4108,
      "cur": "USD",
      "wh": "Semarang WH",
      "st": "COMPLETED"
    },
    {
      "no": "CN-202609-503",
      "cdt": "2026-08-02",
      "rdt": "2026-08-08",
      "rc": "RC-202608-203",
      "sup": "PT. DIAMOND FAJAR JAYA",
      "inv": "INV/77476/2026",
      "rtq": 8,
      "amt": 60525805,
      "cur": "IDR",
      "wh": "Palembang WH",
      "st": "APPROVED"
    },
    {
      "no": "CN-202607-504",
      "cdt": "2026-08-14",
      "rdt": "2026-08-25",
      "rc": "RC-202607-204",
      "sup": "PT. ARAMI JAYA",
      "inv": "INV/67615/2026",
      "rtq": 24,
      "amt": 42607147,
      "cur": "IDR",
      "wh": "Palembang WH",
      "st": "DRAFT"
    },
    {
      "no": "CN-202608-505",
      "cdt": "2026-08-27",
      "rdt": "2026-08-27",
      "rc": "RC-202607-205",
      "sup": "PT. ARAMI JAYA",
      "inv": "INV/95345/2026",
      "rtq": 4,
      "amt": 33400145,
      "cur": "IDR",
      "wh": "Palembang WH",
      "st": "PENDING"
    },
    {
      "no": "CN-202607-506",
      "cdt": "2026-08-11",
      "rdt": "2026-08-01",
      "rc": "RC-202607-206",
      "sup": "DONGYING RUNGOLD TYRE CO., LTD",
      "inv": "INV/80875/2026",
      "rtq": 8,
      "amt": 4335,
      "cur": "USD",
      "wh": "Semarang WH",
      "st": "COMPLETED"
    },
    {
      "no": "CN-202607-507",
      "cdt": "2026-08-07",
      "rdt": "2026-07-23",
      "rc": "RC-202608-207",
      "sup": "HUBEI AULICE TYRE CO.,LTD",
      "inv": "INV/40861/2026",
      "rtq": 12,
      "amt": 3249,
      "cur": "USD",
      "wh": "Semarang WH",
      "st": "APPROVED"
    },
    {
      "no": "CN-202607-508",
      "cdt": "2026-08-11",
      "rdt": "2026-08-20",
      "rc": "RC-202608-208",
      "sup": "PT. MULTISTRADA ARAH SARANA",
      "inv": "INV/94763/2026",
      "rtq": 8,
      "amt": 45998416,
      "cur": "IDR",
      "wh": "Cikarang WH",
      "st": "DRAFT"
    },
    {
      "no": "CN-202609-509",
      "cdt": "2026-07-29",
      "rdt": "2026-08-06",
      "rc": "RC-202608-209",
      "sup": "PT. MULTISTRADA ARAH SARANA",
      "inv": "INV/54105/2026",
      "rtq": 24,
      "amt": 30432680,
      "cur": "IDR",
      "wh": "Cikarang WH",
      "st": "APPROVED"
    },
    {
      "no": "CN-202607-510",
      "cdt": "2026-08-18",
      "rdt": "2026-07-28",
      "rc": "RC-202607-210",
      "sup": "DONGYING RUNGOLD TYRE CO., LTD",
      "inv": "INV/90032/2026",
      "rtq": 8,
      "amt": 2579,
      "cur": "USD",
      "wh": "Balikpapan WH",
      "st": "COMPLETED"
    },
    {
      "no": "CN-202607-511",
      "cdt": "2026-07-30",
      "rdt": "2026-08-15",
      "rc": "RC-202608-211",
      "sup": "PT. MULTISTRADA ARAH SARANA",
      "inv": "INV/99468/2026",
      "rtq": 4,
      "amt": 14510047,
      "cur": "IDR",
      "wh": "Balikpapan WH",
      "st": "APPROVED"
    }
  ]
}
