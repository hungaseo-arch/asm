import type { ScreenDef } from '@/types/list-screen'

/**
 * User — Pengguna · 사용자 계정 관리
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/search-staff` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 * 개선의견서 이슈 21 — DEPARTMENT 를 표준 코드(SALES / FINANCE / WAREHOUSE / ACCOUNTING / GENERAL)로 정비했습니다.
 * 구매(Purchasing)는 표준 코드 목록에 없어 GENERAL 로 배정했습니다 — 코드 확정 시 조정 필요.
 */
export const searchStaffScreen: ScreenDef = {
  "slug": "search-staff",
  "group": "Settings",
  "navLabel": "Search Staff",
  "title": "Search Staff",
  "subtitle": "Pengguna · 직원 계정 관리",
  "cardTitle": "Staff List",
  "searchPlaceholder": "User ID, Name, Department, Role",
  "primaryAction": "＋ NEW USER",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "USER ID",
      "key": "uid"
    },
    {
      "label": "NAME",
      "key": "nm"
    },
    {
      "label": "DEPARTMENT",
      "key": "dept"
    },
    {
      "label": "POSITION",
      "key": "pos"
    },
    {
      "label": "EMAIL",
      "key": "mail"
    },
    {
      "label": "ROLE",
      "key": "role"
    },
    {
      "label": "LAST LOGIN",
      "key": "last"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "uid",
      "label": "USER ID",
      "align": "left",
      "format": "code"
    },
    {
      "key": "nm",
      "label": "NAME",
      "align": "left",
      "format": "text"
    },
    {
      "key": "dept",
      "label": "DEPARTMENT",
      "align": "left",
      "format": "text"
    },
    {
      "key": "pos",
      "label": "POSITION",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "mail",
      "label": "EMAIL",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "role",
      "label": "ROLE",
      "align": "center",
      "format": "text"
    },
    {
      "key": "last",
      "label": "LAST LOGIN",
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
  "totalKeys": [],
  "totalLabelSpan": 1,
  "pageSize": 15,
  "rows": [
    {
      "uid": "seo",
      "nm": "Seo Jonghwan",
      "dept": "GENERAL",
      "pos": "General Manager",
      "mail": "seo@ascendotyre.com",
      "role": "ADMIN",
      "last": "2026-08-13",
      "st": "ACTIVE"
    },
    {
      "uid": "hery",
      "nm": "Hery",
      "dept": "SALES",
      "pos": "Sales Rep — Surabaya",
      "mail": "hery@ascendotyre.com",
      "role": "SALES",
      "last": "2026-08-22",
      "st": "ACTIVE"
    },
    {
      "uid": "hanif",
      "nm": "Hanif",
      "dept": "SALES",
      "pos": "Sales Rep — Central/East Java",
      "mail": "hanif@ascendotyre.com",
      "role": "SALES",
      "last": "2026-08-20",
      "st": "ACTIVE"
    },
    {
      "uid": "eri",
      "nm": "Eri",
      "dept": "SALES",
      "pos": "Sales Rep — Jakarta",
      "mail": "eri@ascendotyre.com",
      "role": "SALES",
      "last": "2026-08-23",
      "st": "ACTIVE"
    },
    {
      "uid": "arif",
      "nm": "Arif",
      "dept": "SALES",
      "pos": "Sales Rep — West Kalimantan",
      "mail": "arif@ascendotyre.com",
      "role": "SALES",
      "last": "2026-08-26",
      "st": "ACTIVE"
    },
    {
      "uid": "rizki",
      "nm": "Rizki",
      "dept": "SALES",
      "pos": "Field Team",
      "mail": "rizki@ascendotyre.com",
      "role": "SALES",
      "last": "2026-08-23",
      "st": "ACTIVE"
    },
    {
      "uid": "firman",
      "nm": "Firman",
      "dept": "WAREHOUSE",
      "pos": "Warehouse Staff",
      "mail": "firman@ascendotyre.com",
      "role": "WAREHOUSE",
      "last": "2026-08-17",
      "st": "ACTIVE"
    },
    {
      "uid": "komang",
      "nm": "Komang",
      "dept": "FINANCE",
      "pos": "Finance Staff",
      "mail": "komang@ascendotyre.com",
      "role": "FINANCE",
      "last": "2026-08-28",
      "st": "ACTIVE"
    },
    {
      "uid": "purch01",
      "nm": "Andi Pratama",
      "dept": "GENERAL",
      "pos": "Import Staff",
      "mail": "purch01@ascendotyre.com",
      "role": "PURCHASING",
      "last": "2026-08-29",
      "st": "ACTIVE"
    },
    {
      "uid": "acc01",
      "nm": "Sri Wahyuni",
      "dept": "FINANCE",
      "pos": "Accounting Staff",
      "mail": "acc01@ascendotyre.com",
      "role": "FINANCE",
      "last": "2026-08-24",
      "st": "ACTIVE"
    },
    {
      "uid": "audit01",
      "nm": "External Auditor",
      "dept": "GENERAL",
      "pos": "Read-only Access",
      "mail": "audit01@ascendotyre.com",
      "role": "VIEWER",
      "last": "2026-08-24",
      "st": "INACTIVE"
    }
  ]
}
