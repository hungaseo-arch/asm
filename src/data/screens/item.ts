import type { ScreenDef } from '@/types/list-screen'

/**
 * Item Master — Master Barang · 품목 마스터
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/item` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const itemScreen: ScreenDef = {
  "slug": "item",
  "group": "Master Data",
  "navLabel": "Item",
  "title": "Item Master",
  "subtitle": "Master Barang · 품목 마스터",
  "cardTitle": "Item Master List",
  "searchPlaceholder": "Item code, Size, Pattern, Brand",
  "primaryAction": "＋ NEW ITEM",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "ITEM CODE",
      "key": "code"
    },
    {
      "label": "CATEGORY",
      "key": "cat"
    },
    {
      "label": "BRAND",
      "key": "brand"
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
      "label": "PR / TL",
      "key": "pr"
    },
    {
      "label": "WEIGHT",
      "key": "wt"
    },
    {
      "label": "HS CODE",
      "key": "hs"
    },
    {
      "label": "UOM",
      "key": "uom"
    },
    {
      "label": "STD COST (USD)",
      "key": "cost"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "code",
      "label": "ITEM CODE",
      "align": "left",
      "format": "code"
    },
    {
      "key": "cat",
      "label": "CATEGORY",
      "align": "center",
      "format": "text"
    },
    {
      "key": "brand",
      "label": "BRAND",
      "align": "left",
      "format": "text"
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
      "key": "pr",
      "label": "PR / TL",
      "align": "center",
      "format": "text"
    },
    {
      "key": "wt",
      "label": "WEIGHT",
      "align": "right",
      "format": "weight"
    },
    {
      "key": "hs",
      "label": "HS CODE",
      "align": "left",
      "format": "code"
    },
    {
      "key": "uom",
      "label": "UOM",
      "align": "center",
      "format": "text"
    },
    {
      "key": "cost",
      "label": "STD COST (USD)",
      "align": "right",
      "format": "price"
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
  "pageSize": 15,
  "rows": [
    {
      "code": "IND-9122",
      "cat": "TB-B",
      "brand": "Techking",
      "size": "26.5R25",
      "patt": "R-1",
      "pr": "18PR",
      "wt": 141.3,
      "hs": "4011.80.00",
      "uom": "EA",
      "cost": 2296.54,
      "st": "ACTIVE"
    },
    {
      "code": "TB-R-1112",
      "cat": "TB-B",
      "brand": "Arami",
      "size": "1100R20",
      "patt": "AS-668",
      "pr": "20PR",
      "wt": 244.1,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 1808.83,
      "st": "ACTIVE"
    },
    {
      "code": "TB-B-5115",
      "cat": "AGR",
      "brand": "Ascendo",
      "size": "750-16",
      "patt": "E3/L3",
      "pr": "40PR",
      "wt": 330.3,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 1136.41,
      "st": "ACTIVE"
    },
    {
      "code": "OTR-6627",
      "cat": "TB-B",
      "brand": "Techking",
      "size": "26.5R25",
      "patt": "AS-682",
      "pr": "20PR",
      "wt": 379.5,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 1665.85,
      "st": "INACTIVE"
    },
    {
      "code": "OTR-3994",
      "cat": "OTR",
      "brand": "Ascendo",
      "size": "750-16",
      "patt": "FL-01",
      "pr": "40PR",
      "wt": 220.3,
      "hs": "4011.80.00",
      "uom": "EA",
      "cost": 1286.6,
      "st": "ACTIVE"
    },
    {
      "code": "TB-B-6633",
      "cat": "TB-B",
      "brand": "Techking",
      "size": "1200R24",
      "patt": "AS-682",
      "pr": "12PR",
      "wt": 385.1,
      "hs": "4011.80.00",
      "uom": "EA",
      "cost": 743.07,
      "st": "INACTIVE"
    },
    {
      "code": "IND-6359",
      "cat": "OTR",
      "brand": "Ascendo",
      "size": "1100R20",
      "patt": "ETSM",
      "pr": "14PR",
      "wt": 354,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 1387.22,
      "st": "ACTIVE"
    },
    {
      "code": "TB-R-2178",
      "cat": "IND",
      "brand": "Ascendo",
      "size": "750-16",
      "patt": "AS-661",
      "pr": "**",
      "wt": 223,
      "hs": "4011.90.00",
      "uom": "EA",
      "cost": 1574.35,
      "st": "INACTIVE"
    },
    {
      "code": "AGR-4466",
      "cat": "OTR",
      "brand": "Solideal",
      "size": "1000R20",
      "patt": "E3/L3",
      "pr": "20PR",
      "wt": 272.5,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 484.28,
      "st": "INACTIVE"
    },
    {
      "code": "OTR-1108",
      "cat": "TB-B",
      "brand": "Arami",
      "size": "18.4-34",
      "patt": "AS-668",
      "pr": "16PR",
      "wt": 75,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 2072.9,
      "st": "INACTIVE"
    },
    {
      "code": "TB-R-2857",
      "cat": "OTR",
      "brand": "Ascendo",
      "size": "18.4-34",
      "patt": "AS-682",
      "pr": "18PR",
      "wt": 411.1,
      "hs": "4011.90.00",
      "uom": "EA",
      "cost": 453.87,
      "st": "ACTIVE"
    },
    {
      "code": "AGR-5344",
      "cat": "TB-B",
      "brand": "Ascendo",
      "size": "18.4-34",
      "patt": "FL-01",
      "pr": "16PR",
      "wt": 98.6,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 129.97,
      "st": "ACTIVE"
    },
    {
      "code": "OTR-7039",
      "cat": "AGR",
      "brand": "Techking",
      "size": "18.4-34",
      "patt": "AS-668",
      "pr": "20PR",
      "wt": 21.3,
      "hs": "4011.80.00",
      "uom": "EA",
      "cost": 1416.46,
      "st": "ACTIVE"
    },
    {
      "code": "AGR-1920",
      "cat": "OTR",
      "brand": "Arami",
      "size": "29.5R25",
      "patt": "AS-668",
      "pr": "—",
      "wt": 276.5,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 512.49,
      "st": "INACTIVE"
    },
    {
      "code": "TB-R-9408",
      "cat": "OTR",
      "brand": "Ascendo",
      "size": "26.5R25",
      "patt": "E3",
      "pr": "14PR",
      "wt": 215.8,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 1017.37,
      "st": "INACTIVE"
    },
    {
      "code": "OTR-9536",
      "cat": "AGR",
      "brand": "Arami",
      "size": "26.5R25",
      "patt": "AS-108",
      "pr": "18PR",
      "wt": 340,
      "hs": "4011.90.00",
      "uom": "EA",
      "cost": 486.51,
      "st": "ACTIVE"
    },
    {
      "code": "TB-B-5688",
      "cat": "TB-B",
      "brand": "Arami",
      "size": "700-12",
      "patt": "AS-682",
      "pr": "12PR",
      "wt": 292.1,
      "hs": "4011.90.00",
      "uom": "EA",
      "cost": 184.14,
      "st": "ACTIVE"
    },
    {
      "code": "AGR-2635",
      "cat": "TB-R",
      "brand": "Ascendo",
      "size": "1000R20",
      "patt": "E4",
      "pr": "**",
      "wt": 300.9,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 1735.88,
      "st": "ACTIVE"
    },
    {
      "code": "IND-8778",
      "cat": "OTR",
      "brand": "Arami",
      "size": "26.5R25",
      "patt": "AS-108",
      "pr": "16PR",
      "wt": 149.6,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 262.83,
      "st": "ACTIVE"
    },
    {
      "code": "OTR-2635",
      "cat": "TB-R",
      "brand": "Ascendo",
      "size": "1000R20",
      "patt": "AS-668",
      "pr": "20PR",
      "wt": 139.7,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 1532.07,
      "st": "ACTIVE"
    },
    {
      "code": "AGR-1946",
      "cat": "IND",
      "brand": "Techking",
      "size": "1100R20",
      "patt": "E3/L3",
      "pr": "16PR",
      "wt": 355.8,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 769.37,
      "st": "ACTIVE"
    },
    {
      "code": "TB-R-3960",
      "cat": "OTR",
      "brand": "Arami",
      "size": "26.5R25",
      "patt": "E4",
      "pr": "—",
      "wt": 179.7,
      "hs": "4011.90.00",
      "uom": "EA",
      "cost": 2319.47,
      "st": "ACTIVE"
    },
    {
      "code": "AGR-8614",
      "cat": "TB-B",
      "brand": "Techking",
      "size": "700-12",
      "patt": "FL-01",
      "pr": "40PR",
      "wt": 217.3,
      "hs": "4011.20.10",
      "uom": "EA",
      "cost": 1291.73,
      "st": "INACTIVE"
    },
    {
      "code": "OTR-9156",
      "cat": "OTR",
      "brand": "Solideal",
      "size": "23.5R25",
      "patt": "AS-668",
      "pr": "14PR",
      "wt": 325.1,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 78.86,
      "st": "INACTIVE"
    },
    {
      "code": "TB-R-6237",
      "cat": "OTR",
      "brand": "Ascendo",
      "size": "23.5R25",
      "patt": "E4",
      "pr": "40PR",
      "wt": 63,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 1337.35,
      "st": "ACTIVE"
    },
    {
      "code": "TB-R-6761",
      "cat": "AGR",
      "brand": "Ascendo",
      "size": "1100R20",
      "patt": "AS-108",
      "pr": "16PR",
      "wt": 30.2,
      "hs": "4011.90.00",
      "uom": "EA",
      "cost": 2102.49,
      "st": "ACTIVE"
    },
    {
      "code": "TB-R-5947",
      "cat": "IND",
      "brand": "Techking",
      "size": "26.5R25",
      "patt": "AS-668",
      "pr": "16PR",
      "wt": 39.3,
      "hs": "4011.70.00",
      "uom": "EA",
      "cost": 640.02,
      "st": "ACTIVE"
    },
    {
      "code": "TB-R-1918",
      "cat": "OTR",
      "brand": "Ascendo",
      "size": "700-12",
      "patt": "ETSM",
      "pr": "18PR",
      "wt": 147.6,
      "hs": "4011.80.00",
      "uom": "EA",
      "cost": 647.7,
      "st": "ACTIVE"
    }
  ]
}
