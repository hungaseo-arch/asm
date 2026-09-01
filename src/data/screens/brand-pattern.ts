import type { ScreenDef } from '@/types/list-screen'

/**
 * Brand / Pattern — Merek & Pola Tapak · 브랜드·패턴 마스터
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/brand-pattern` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const brandPatternScreen: ScreenDef = {
  "slug": "brand-pattern",
  "group": "Master Data",
  "navLabel": "Brand / Pattern",
  "title": "Brand / Pattern",
  "subtitle": "Merek & Pola Tapak · 브랜드·패턴 마스터",
  "cardTitle": "Brand / Pattern List",
  "searchPlaceholder": "Brand, Pattern, Category, Factory",
  "primaryAction": "＋ NEW PATTERN",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "BRAND",
      "key": "brand"
    },
    {
      "label": "PATTERN",
      "key": "patt"
    },
    {
      "label": "CATEGORY",
      "key": "cat"
    },
    {
      "label": "APPLICATION",
      "key": "app"
    },
    {
      "label": "ORIGIN",
      "key": "org"
    },
    {
      "label": "FACTORY",
      "key": "fac"
    },
    {
      "label": "ITEM COUNT",
      "key": "cnt"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "brand",
      "label": "BRAND",
      "align": "left",
      "format": "text"
    },
    {
      "key": "patt",
      "label": "PATTERN",
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
      "key": "app",
      "label": "APPLICATION",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "org",
      "label": "ORIGIN",
      "align": "center",
      "format": "text"
    },
    {
      "key": "fac",
      "label": "FACTORY",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "cnt",
      "label": "ITEM COUNT",
      "align": "right",
      "format": "int"
    },
    {
      "key": "st",
      "label": "STATUS",
      "align": "center",
      "format": "badge"
    }
  ],
  "totalKeys": [
    "cnt"
  ],
  "totalLabelSpan": 7,
  "pageSize": 15,
  "rows": [
    {
      "brand": "Ascendo",
      "patt": "AS-668",
      "cat": "TB-R",
      "app": "Long haul / on-road",
      "org": "China",
      "fac": "Dongying Rungold Tyre",
      "cnt": 13,
      "st": "INACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "AS-682",
      "cat": "TB-R",
      "app": "Mixed service / on-off road",
      "org": "China",
      "fac": "Dongying Rungold Tyre",
      "cnt": 26,
      "st": "ACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "AS-661",
      "cat": "TB-R",
      "app": "Regional distribution",
      "org": "China",
      "fac": "Dongying Rungold Tyre",
      "cnt": 18,
      "st": "INACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "AS-108",
      "cat": "TB-B",
      "app": "Light truck bias",
      "org": "Indonesia",
      "fac": "PT Arami Jaya",
      "cnt": 34,
      "st": "INACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "E3/L3",
      "cat": "OTR",
      "app": "Loader / dump truck",
      "org": "China",
      "fac": "Techking OEM",
      "cnt": 4,
      "st": "ACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "E4",
      "cat": "OTR",
      "app": "Rigid dump truck (deep tread)",
      "org": "China",
      "fac": "Techking OEM",
      "cnt": 31,
      "st": "ACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "FL-01",
      "cat": "IND",
      "app": "Forklift pneumatic",
      "org": "Indonesia",
      "fac": "PT Arami Jaya",
      "cnt": 42,
      "st": "ACTIVE"
    },
    {
      "brand": "Ascendo",
      "patt": "R-1",
      "cat": "AGR",
      "app": "Tractor rear",
      "org": "China",
      "fac": "Dongying Rungold Tyre",
      "cnt": 7,
      "st": "INACTIVE"
    },
    {
      "brand": "Techking",
      "patt": "ETSM",
      "cat": "OTR",
      "app": "Mining haul / scraper",
      "org": "China",
      "fac": "Techking Tires",
      "cnt": 10,
      "st": "ACTIVE"
    },
    {
      "brand": "Solideal",
      "patt": "SOLID",
      "cat": "IND",
      "app": "Forklift solid / press-on",
      "org": "Sri Lanka",
      "fac": "Camso Loadstar",
      "cnt": 36,
      "st": "ACTIVE"
    },
    {
      "brand": "Arami",
      "patt": "ARM-TB",
      "cat": "TB-B",
      "app": "Bias truck local",
      "org": "Indonesia",
      "fac": "PT Arami Jaya",
      "cnt": 21,
      "st": "ACTIVE"
    },
    {
      "brand": "Arami",
      "patt": "ARM-IT",
      "cat": "IND",
      "app": "Inner tube (ban dalam)",
      "org": "Indonesia",
      "fac": "PT Arami Jaya",
      "cnt": 33,
      "st": "INACTIVE"
    }
  ]
}
