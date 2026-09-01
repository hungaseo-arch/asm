import type { ScreenDef } from '@/types/list-screen'

/**
 * Warehouse — Gudang · 창고 마스터
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/warehouses` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 * 개선의견서 이슈 20 — TYPE 만으로는 구분이 불명확하여 자가창고(OWN)·위탁(3PL) 열을 추가했습니다.
 */
export const warehousesScreen: ScreenDef = {
  "slug": "warehouses",
  "group": "Master Data",
  "navLabel": "Warehouses",
  "title": "Warehouses",
  "subtitle": "Gudang · 창고 마스터",
  "cardTitle": "Warehouse List",
  "searchPlaceholder": "WH code, Warehouse name, City, PIC",
  "primaryAction": "＋ NEW WAREHOUSE",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "WH CODE",
      "key": "code"
    },
    {
      "label": "WAREHOUSE NAME",
      "key": "nm"
    },
    {
      "label": "TYPE",
      "key": "typ"
    },
    {
      "label": "CITY",
      "key": "city"
    },
    {
      "label": "ADDRESS",
      "key": "addr"
    },
    {
      "label": "PIC",
      "key": "pic"
    },
    {
      "label": "CAPACITY (EA)",
      "key": "cap"
    },
    {
      "label": "CURRENT (EA)",
      "key": "cur"
    },
    {
      "label": "UTIL.",
      "key": "util"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "code",
      "label": "WH CODE",
      "align": "left",
      "format": "code"
    },
    {
      "key": "nm",
      "label": "WAREHOUSE NAME",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "typ",
      "label": "TYPE",
      "align": "center",
      "format": "text"
    },
    {
      "key": "own",
      "label": "OWNERSHIP",
      "align": "center",
      "format": "text"
    },
    {
      "key": "city",
      "label": "CITY",
      "align": "left",
      "format": "text"
    },
    {
      "key": "addr",
      "label": "ADDRESS",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "pic",
      "label": "PIC",
      "align": "center",
      "format": "text"
    },
    {
      "key": "cap",
      "label": "CAPACITY (EA)",
      "align": "right",
      "format": "int"
    },
    {
      "key": "cur",
      "label": "CURRENT (EA)",
      "align": "right",
      "format": "int"
    },
    {
      "key": "util",
      "label": "UTIL.",
      "align": "right",
      "format": "percent"
    },
    {
      "key": "st",
      "label": "STATUS",
      "align": "center",
      "format": "badge"
    }
  ],
  "totalKeys": [
    "cap",
    "cur"
  ],
  "totalLabelSpan": 7,
  "pageSize": 15,
  "rows": [
    {
      "code": "WH-CKR",
      "nm": "Cikarang Main Warehouse",
      "typ": "Main",
      "city": "Cikarang",
      "addr": "Jl. Jababeka Raya Blok F, Kawasan Industri",
      "pic": "Firman",
      "cap": 12000,
      "cur": 8420,
      "util": 70.2,
      "st": "ACTIVE",
      "own": "OWN"
    },
    {
      "code": "WH-SBY",
      "nm": "Surabaya Branch Warehouse",
      "typ": "Branch",
      "city": "Surabaya",
      "addr": "Jl. Margomulyo Indah No. 12",
      "pic": "Hery",
      "cap": 6000,
      "cur": 4130,
      "util": 68.8,
      "st": "ACTIVE",
      "own": "OWN"
    },
    {
      "code": "WH-SMG",
      "nm": "Semarang Branch Warehouse",
      "typ": "Branch",
      "city": "Semarang",
      "addr": "Jl. Raya Kaligawe KM 5",
      "pic": "Hanif",
      "cap": 4500,
      "cur": 2680,
      "util": 59.6,
      "st": "ACTIVE",
      "own": "3PL"
    },
    {
      "code": "WH-BPP",
      "nm": "Balikpapan Branch Warehouse",
      "typ": "Branch",
      "city": "Balikpapan",
      "addr": "Jl. Mulawarman No. 88, Manggar",
      "pic": "Arif",
      "cap": 3500,
      "cur": 1940,
      "util": 55.4,
      "st": "ACTIVE",
      "own": "OWN"
    },
    {
      "code": "WH-PLB",
      "nm": "Palembang Branch Warehouse",
      "typ": "Branch",
      "city": "Palembang",
      "addr": "Jl. Soekarno Hatta KM 9",
      "pic": "Rizki",
      "cap": 3000,
      "cur": 860,
      "util": 28.7,
      "st": "ACTIVE",
      "own": "OWN"
    },
    {
      "code": "WH-TRN",
      "nm": "Transit / In-Transit Stock",
      "typ": "Transit",
      "city": "—",
      "addr": "Dalam perjalanan antar gudang",
      "pic": "—",
      "cap": 2000,
      "cur": 320,
      "util": 16,
      "st": "ACTIVE",
      "own": "3PL"
    },
    {
      "code": "WH-QAR",
      "nm": "Quarantine / Defect Area",
      "typ": "Quarantine",
      "city": "Cikarang",
      "addr": "Jl. Jababeka Raya Blok F (Zona B)",
      "pic": "Firman",
      "cap": 800,
      "cur": 214,
      "util": 26.8,
      "st": "ACTIVE",
      "own": "OWN"
    },
    {
      "code": "WH-OLD",
      "nm": "Jakarta Old Warehouse",
      "typ": "Branch",
      "city": "Jakarta",
      "addr": "Jl. Daan Mogot KM 12",
      "pic": "—",
      "cap": 2500,
      "cur": 0,
      "util": 0,
      "st": "INACTIVE",
      "own": "OWN"
    }
  ]
}
