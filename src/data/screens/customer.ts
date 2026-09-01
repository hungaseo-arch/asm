import type { ScreenDef } from '@/types/list-screen'

/**
 * Customers — Pelanggan · 고객사 마스터
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/customer` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const customerScreen: ScreenDef = {
  "slug": "customer",
  "group": "Partners",
  "navLabel": "Customers",
  "title": "Customers",
  "subtitle": "Pelanggan · 고객사 마스터",
  "cardTitle": "All Customers",
  "searchPlaceholder": "Customer name...",
  "primaryAction": "＋ NEW",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "CUSTOMER NAME",
      "key": "nm"
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
      "label": "PIC NAME",
      "key": "pic"
    },
    {
      "label": "PHONE NO.",
      "key": "tel"
    }
  ],
  "columns": [
    {
      "key": "nm",
      "label": "CUSTOMER NAME",
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
      "key": "addr",
      "label": "ADDRESS",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "pic",
      "label": "PIC NAME",
      "align": "left",
      "format": "text"
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
      "nm": "PT. TRANS MITRA SEJATI",
      "typ": "DISTRIBUTOR",
      "addr": "Pantai Indah Utara 2 Galeri Niaga, Mediterania II L, 8B, Kapuk Muara, Penjaringan, 14460",
      "pic": "Stevie",
      "tel": "021-5566-8821"
    },
    {
      "nm": "PT. BUKIT MAKMUR MANDIRI UTAMA",
      "typ": "END USER",
      "addr": "Jl. TB Simatupang No. 1, Cilandak, Jakarta Selatan, 12560",
      "pic": "Bpk. Suryanto",
      "tel": "021-2997-1000"
    },
    {
      "nm": "PT. PAMAPERSADA NUSANTARA",
      "typ": "END USER",
      "addr": "Jl. Rawa Gelam I No. 9, Kawasan Industri Pulogadung, Jakarta Timur",
      "pic": "Bpk. Herman",
      "tel": "021-4602-2000"
    },
    {
      "nm": "PT. KALTIM PRIMA COAL",
      "typ": "END USER",
      "addr": "Mine Site Sangatta, Kutai Timur, Kalimantan Timur, 75611",
      "pic": "Bpk. Rahmat",
      "tel": "0549-521-000"
    },
    {
      "nm": "PT. SAPTAINDRA SEJATI",
      "typ": "END USER",
      "addr": "TMT 2 Building, Jl. Cilandak KKO No. 1, Jakarta Selatan",
      "pic": "Bpk. Dedi",
      "tel": "021-2997-4000"
    },
    {
      "nm": "PT. THIESS CONTRACTORS INDONESIA",
      "typ": "END USER",
      "addr": "Ratu Prabu 2 Building, Jl. TB Simatupang Kav. 1B, Jakarta",
      "pic": "Mr. Andrew",
      "tel": "021-7883-1000"
    },
    {
      "nm": "CV. SUMBER BAN JAYA",
      "typ": "DEALER",
      "addr": "Jl. Raya Kaligawe KM 6 No. 88, Semarang, 50118",
      "pic": "Bpk. Yanto",
      "tel": "024-658-2211"
    },
    {
      "nm": "UD. MAKMUR TYRE",
      "typ": "DEALER",
      "addr": "Jl. Margomulyo Indah Blok C-12, Surabaya, 60186",
      "pic": "Bpk. Anton",
      "tel": "031-749-3300"
    },
    {
      "nm": "PT. PUTRA PERKASA ABADI",
      "typ": "END USER",
      "addr": "Jl. Kebon Sirih No. 39, Menteng, Jakarta Pusat",
      "pic": "Bpk. Fajar",
      "tel": "021-3193-8800"
    },
    {
      "nm": "PT. CIPTA KRIDATAMA",
      "typ": "END USER",
      "addr": "Jl. Mulawarman No. 12, Balikpapan, Kalimantan Timur",
      "pic": "Bpk. Wawan",
      "tel": "0542-771-200"
    },
    {
      "nm": "PT. ULIMA NITRA",
      "typ": "END USER",
      "addr": "Jl. Soekarno Hatta KM 12, Palembang, Sumatera Selatan",
      "pic": "Bpk. Rudi",
      "tel": "0711-411-800"
    },
    {
      "nm": "PT. BERAU COAL",
      "typ": "END USER",
      "addr": "Jl. Pemuda No. 40, Tanjung Redeb, Berau, Kalimantan Timur",
      "pic": "Bpk. Iskandar",
      "tel": "0554-233-00"
    }
  ]
}
