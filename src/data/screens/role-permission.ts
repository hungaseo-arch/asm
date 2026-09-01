import type { ScreenDef } from '@/types/list-screen'

/**
 * Role / Permission — Peran & Hak Akses · 권한 매트릭스
 * 화면 시안(asm-mockup)에서 옮긴 예시 데이터입니다. 운영 전환 시 rows 를
 * `GET /api/role-permission` 결과로 교체하면 나머지 로직은 그대로 동작합니다.
 */
export const rolePermissionScreen: ScreenDef = {
  "slug": "role-permission",
  "group": "Settings",
  "navLabel": "Role / Permission",
  "title": "Role / Permission",
  "subtitle": "Peran & Hak Akses · 권한 매트릭스",
  "cardTitle": "Role / Permission List",
  "searchPlaceholder": "Role code, Role name, Module",
  "primaryAction": "＋ NEW ROLE",
  "searchFields": [
    {
      "label": "Keyword",
      "key": "all"
    },
    {
      "label": "ROLE CODE",
      "key": "rc"
    },
    {
      "label": "ROLE NAME",
      "key": "rn"
    },
    {
      "label": "MODULE",
      "key": "mod"
    },
    {
      "label": "VIEW",
      "key": "v"
    },
    {
      "label": "CREATE",
      "key": "c"
    },
    {
      "label": "EDIT",
      "key": "e"
    },
    {
      "label": "DELETE",
      "key": "dl"
    },
    {
      "label": "APPROVE",
      "key": "ap"
    },
    {
      "label": "EXPORT",
      "key": "ex"
    },
    {
      "label": "USERS",
      "key": "cnt"
    }
  ],
  "columns": [
    {
      "key": "rc",
      "label": "ROLE CODE",
      "align": "left",
      "format": "code"
    },
    {
      "key": "rn",
      "label": "ROLE NAME",
      "align": "left",
      "format": "text",
      "ellipsis": true
    },
    {
      "key": "mod",
      "label": "MODULE",
      "align": "left",
      "format": "text"
    },
    {
      "key": "v",
      "label": "VIEW",
      "align": "center",
      "format": "mark"
    },
    {
      "key": "c",
      "label": "CREATE",
      "align": "center",
      "format": "mark"
    },
    {
      "key": "e",
      "label": "EDIT",
      "align": "center",
      "format": "mark"
    },
    {
      "key": "dl",
      "label": "DELETE",
      "align": "center",
      "format": "mark"
    },
    {
      "key": "ap",
      "label": "APPROVE",
      "align": "center",
      "format": "mark"
    },
    {
      "key": "ex",
      "label": "EXPORT",
      "align": "center",
      "format": "mark"
    },
    {
      "key": "cnt",
      "label": "USERS",
      "align": "right",
      "format": "int"
    }
  ],
  "totalKeys": [],
  "totalLabelSpan": 1,
  "pageSize": 15,
  "rows": [
    {
      "rc": "ADMIN",
      "rn": "System Administrator",
      "mod": "All Modules",
      "v": 1,
      "c": 1,
      "e": 1,
      "dl": 1,
      "ap": 1,
      "ex": 1,
      "cnt": 1
    },
    {
      "rc": "SALES",
      "rn": "Sales Representative",
      "mod": "Sales",
      "v": 1,
      "c": 1,
      "e": 1,
      "dl": 0,
      "ap": 0,
      "ex": 1,
      "cnt": 5
    },
    {
      "rc": "SALES",
      "rn": "Sales Representative",
      "mod": "Inventory",
      "v": 1,
      "c": 0,
      "e": 0,
      "dl": 0,
      "ap": 0,
      "ex": 0,
      "cnt": 5
    },
    {
      "rc": "SALES",
      "rn": "Sales Representative",
      "mod": "Partners",
      "v": 1,
      "c": 1,
      "e": 1,
      "dl": 0,
      "ap": 0,
      "ex": 0,
      "cnt": 5
    },
    {
      "rc": "PURCHASING",
      "rn": "Purchasing / Import Staff",
      "mod": "Purchasing",
      "v": 1,
      "c": 1,
      "e": 1,
      "dl": 0,
      "ap": 0,
      "ex": 1,
      "cnt": 1
    },
    {
      "rc": "PURCHASING",
      "rn": "Purchasing / Import Staff",
      "mod": "Inventory",
      "v": 1,
      "c": 0,
      "e": 0,
      "dl": 0,
      "ap": 0,
      "ex": 1,
      "cnt": 1
    },
    {
      "rc": "WAREHOUSE",
      "rn": "Warehouse Staff",
      "mod": "Inventory",
      "v": 1,
      "c": 1,
      "e": 1,
      "dl": 0,
      "ap": 0,
      "ex": 1,
      "cnt": 1
    },
    {
      "rc": "WAREHOUSE",
      "rn": "Warehouse Staff",
      "mod": "Sales",
      "v": 1,
      "c": 0,
      "e": 1,
      "dl": 0,
      "ap": 0,
      "ex": 0,
      "cnt": 1
    },
    {
      "rc": "FINANCE",
      "rn": "Finance / Accounting",
      "mod": "Sales",
      "v": 1,
      "c": 0,
      "e": 0,
      "dl": 0,
      "ap": 1,
      "ex": 1,
      "cnt": 2
    },
    {
      "rc": "FINANCE",
      "rn": "Finance / Accounting",
      "mod": "Purchasing",
      "v": 1,
      "c": 0,
      "e": 0,
      "dl": 0,
      "ap": 1,
      "ex": 1,
      "cnt": 2
    },
    {
      "rc": "MANAGER",
      "rn": "Department Manager",
      "mod": "All Modules",
      "v": 1,
      "c": 1,
      "e": 1,
      "dl": 0,
      "ap": 1,
      "ex": 1,
      "cnt": 0
    },
    {
      "rc": "VIEWER",
      "rn": "Read-only / Auditor",
      "mod": "All Modules",
      "v": 1,
      "c": 0,
      "e": 0,
      "dl": 0,
      "ap": 0,
      "ex": 1,
      "cnt": 1
    }
  ]
}
