import type { ScreenDef } from '@/types/list-screen'

/**
 * Suppliers — Pemasok · 공급사 마스터
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/vendor` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 * 개선의견서 이슈 18 — 원산지는 관세율·FTA 적용 기준이므로 ISO 국가코드를 함께 관리합니다.
 */
export const vendorScreen: ScreenDef = {
  "slug": "vendor",
  "group": "Partners",
  "navLabel": "Suppliers",
  "title": "Suppliers",
  "subtitle": "Pemasok · 공급사 마스터",
  "cardTitle": "All Suppliers",
  "searchPlaceholder": "Supplier name...",
  "primaryAction": "＋ NEW",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "SUPPLIER NAME",
      "key": "nm"
    },
    {
      "label": "COUNTRY",
      "key": "cty"
    },
    {
      "label": "TYPE",
      "key": "typ"
    },
    {
      "label": "ADDRESS",
      "key": "addr"
    },
    {
      "label": "PHONE NO.",
      "key": "tel"
    }
  ],
  "columns": [
    {
      "key": "nm",
      "label": "SUPPLIER NAME",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "cty",
      "label": "COUNTRY",
      "align": "center",
      "format": "text"
    },
    {
      "key": "iso",
      "label": "ISO",
      "align": "center",
      "format": "code"
    },
    {
      "key": "typ",
      "label": "TYPE",
      "align": "center",
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
      "key": "tel",
      "label": "PHONE NO.",
      "align": "left",
      "format": "code"
    }
  ],
  "totalKeys": [],
  "totalLabelSpan": 1,
  "pageSize": 15,
  "rows": [
    {
      "nm": "HUA IN GLOBAL (SHANGHAI) CO., LTD",
      "cty": "CHINA",
      "typ": "IMPORT",
      "addr": "Room 902, Block B Jingting Building, No.1000 Hong Quan Road, Minhang District, Shanghai, China",
      "tel": "-",
      "iso": "CN"
    },
    {
      "nm": "HUBEI AULICE TYRE CO., LTD",
      "cty": "CHINA",
      "typ": "IMPORT",
      "addr": "No. 1 Aulice Road, Zaoyang Industrial Park, Hubei, China",
      "tel": "+86-710-6259-888",
      "iso": "CN"
    },
    {
      "nm": "DONGYING RUNGOLD TYRE CO., LTD",
      "cty": "CHINA",
      "typ": "IMPORT",
      "addr": "Guangrao Economic Development Zone, Dongying, Shandong, China",
      "tel": "+86-546-763-8888",
      "iso": "CN"
    },
    {
      "nm": "TECHKING TIRES LIMITED",
      "cty": "CHINA",
      "typ": "IMPORT",
      "addr": "No. 1 Fuqian Road, Qingdao, Shandong, China",
      "tel": "+86-532-8099-6688",
      "iso": "CN"
    },
    {
      "nm": "CAMSO LOADSTAR (PVT) LTD",
      "cty": "SRI LANKA",
      "typ": "IMPORT",
      "addr": "Ekala, Ja-Ela, Gampaha District, Sri Lanka",
      "tel": "+94-11-223-6000",
      "iso": "LK"
    },
    {
      "nm": "PT. DIAMOND FAJAR JAYA",
      "cty": "INDONESIA",
      "typ": "LOCAL",
      "addr": "Jl. Raya Serang KM 18, Cikupa, Tangerang, Banten",
      "tel": "021-5960-1200",
      "iso": "ID"
    },
    {
      "nm": "PT. ARAMI JAYA",
      "cty": "INDONESIA",
      "typ": "LOCAL",
      "addr": "Jl. Raya Industri No. 22, Cikarang, Bekasi, Jawa Barat",
      "tel": "021-8983-4400",
      "iso": "ID"
    },
    {
      "nm": "PT. MULTISTRADA ARAH SARANA",
      "cty": "INDONESIA",
      "typ": "LOCAL",
      "addr": "Jl. Raya Lemahabang KM 58.3, Cikarang Timur, Bekasi",
      "tel": "021-8983-1234",
      "iso": "ID"
    },
    {
      "nm": "PT. SAMUDERA INDONESIA (FORWARDER)",
      "cty": "INDONESIA",
      "typ": "LOCAL",
      "addr": "Jl. Letjen S. Parman Kav. 35, Jakarta Barat",
      "tel": "021-548-0800",
      "iso": "ID"
    },
    {
      "nm": "PT. AGILITY INTERNATIONAL",
      "cty": "INDONESIA",
      "typ": "LOCAL",
      "addr": "Soewarna Business Park Block E, Soekarno-Hatta Airport",
      "tel": "021-559-1000",
      "iso": "ID"
    }
  ]
}
