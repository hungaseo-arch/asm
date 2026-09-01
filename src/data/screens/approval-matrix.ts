import type { ScreenDef } from '@/types/list-screen'

/**
 * Approval Matrix — Matriks Persetujuan · 승인 매트릭스
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/approval-matrix` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const approvalMatrixScreen: ScreenDef = {
  "slug": "approval-matrix",
  "group": "Settings",
  "navLabel": "Approval Matrix",
  "title": "Approval Matrix",
  "subtitle": "Matriks Persetujuan · 승인 매트릭스",
  "cardTitle": "Approval Matrix List",
  "searchPlaceholder": "Doc type, Approver, Status",
  "primaryAction": "＋ NEW RULE",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "DOC TYPE",
      "key": "doc"
    },
    {
      "label": "AMOUNT LIMIT",
      "key": "lim"
    },
    {
      "label": "STEP 1",
      "key": "s1"
    },
    {
      "label": "STEP 2",
      "key": "s2"
    },
    {
      "label": "STEP 3",
      "key": "s3"
    },
    {
      "label": "SoD RULE",
      "key": "sod"
    },
    {
      "label": "EFFECTIVE DATE",
      "key": "eff"
    },
    {
      "label": "STATUS",
      "key": "st"
    }
  ],
  "columns": [
    {
      "key": "doc",
      "label": "DOC TYPE",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "lim",
      "label": "AMOUNT LIMIT",
      "align": "right",
      "format": "currency",
      "currency": "USD"
    },
    {
      "key": "s1",
      "label": "STEP 1",
      "align": "center",
      "format": "text"
    },
    {
      "key": "s2",
      "label": "STEP 2",
      "align": "center",
      "format": "text"
    },
    {
      "key": "s3",
      "label": "STEP 3",
      "align": "center",
      "format": "text"
    },
    {
      "key": "sod",
      "label": "SoD RULE",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "eff",
      "label": "EFFECTIVE DATE",
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
      "doc": "Quotation",
      "lim": 50000,
      "s1": "Sales Rep",
      "s2": "Sales Manager",
      "s3": "—",
      "sod": "기안자 승인 불가",
      "eff": "2026-01-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Quotation",
      "lim": 0,
      "s1": "Sales Rep",
      "s2": "Sales Manager",
      "s3": "General Manager",
      "sod": "기안자 승인 불가",
      "eff": "2026-01-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Customer PO",
      "lim": 100000,
      "s1": "Sales Manager",
      "s2": "Finance",
      "s3": "—",
      "sod": "여신한도 초과 시 Finance 필수",
      "eff": "2026-01-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Sales Order",
      "lim": 0,
      "s1": "Sales Manager",
      "s2": "Finance",
      "s3": "General Manager",
      "sod": "재고 미확보 시 반려",
      "eff": "2026-01-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Delivery Order",
      "lim": 0,
      "s1": "Warehouse Staff",
      "s2": "Warehouse Manager",
      "s3": "—",
      "sod": "출고자·승인자 분리",
      "eff": "2026-03-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Purchase PO",
      "lim": 200000,
      "s1": "Purchasing Staff",
      "s2": "Purchasing Manager",
      "s3": "—",
      "sod": "발주자 승인 불가",
      "eff": "2026-01-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Purchase PO",
      "lim": 0,
      "s1": "Purchasing Staff",
      "s2": "Purchasing Manager",
      "s3": "General Manager",
      "sod": "발주자 승인 불가",
      "eff": "2026-01-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Stock Adjustment",
      "lim": 5000,
      "s1": "Warehouse Staff",
      "s2": "Warehouse Manager",
      "s3": "—",
      "sod": "실사자·승인자 분리",
      "eff": "2026-03-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Stock Adjustment",
      "lim": 0,
      "s1": "Warehouse Staff",
      "s2": "Warehouse Manager",
      "s3": "General Manager",
      "sod": "실사자·승인자 분리",
      "eff": "2026-03-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Stock Transfer",
      "lim": 0,
      "s1": "Warehouse Staff",
      "s2": "Warehouse Manager",
      "s3": "—",
      "sod": "출고창고·입고창고 각각 확인",
      "eff": "2026-03-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Credit Note",
      "lim": 0,
      "s1": "Finance",
      "s2": "Finance Manager",
      "s3": "General Manager",
      "sod": "발행자 승인 불가",
      "eff": "2026-05-01",
      "st": "ACTIVE"
    },
    {
      "doc": "Master Data 변경",
      "lim": 0,
      "s1": "해당 부서",
      "s2": "System Administrator",
      "s3": "—",
      "sod": "데이터 오너 승인 필수",
      "eff": "2026-06-01",
      "st": "PENDING"
    }
  ]
}
