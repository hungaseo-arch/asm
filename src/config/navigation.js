import { CORE_DOCS, SALES_FORMS } from '@/modules/csr/coreDocs'
import { REPORT_COUNT } from '@/modules/csr/reportDesign'

/**
 * 아이콘은 plugins/icons.js 에서 전역 등록한 컴포넌트 '이름'으로 지정합니다
 * (Font Awesome 전환 후 값 import 가 필요 없어졌습니다).
 */

/**
 * 경로 접두사 일치 판정 (Path prefix match / Pencocokan awalan path)
 *
 * 세그먼트 경계까지 일치해야 합니다. 단순 startsWith 를 쓰면 '/csr' 이 '/csr-admin' 같은
 * 경로에도 걸립니다.
 */
export const matchPath = (path, prefix) => path === prefix || path.startsWith(`${prefix}/`)

/**
 * 메뉴 (Menu / Menu) — 2026-10-23 개편.
 *
 * 매일 쓰는 화면(대시보드·개선요청)만 상단에 두고, 가끔 찾아보는 참고 화면(상태 기준 · 흐름도 · 핵심문서 · 표준양식)은
 * 「자료실」 드롭다운으로 묶었습니다. 관리 화면은 admin 만 쓰므로 계정 메뉴로 옮겼습니다
 * (adminItem — AppTopbar 가 identity.role === 'admin' 일 때만 보여 줍니다).
 * badge 는 라벨 옆 숫자 — 핵심문서 개수를 라벨에 박아 두면(「10종」) 문서가 늘 때 어긋납니다.
 */
export const navItems = [
  { label: '대시보드', labelId: 'Dasbor', icon: 'LayoutDashboard', to: '/csr/dashboard' },
  { label: '개선요청', labelId: 'Permintaan', icon: 'ClipboardList', to: '/csr' },
  {
    label: '자료실',
    labelId: 'Referensi',
    icon: 'FolderOpen',
    children: [
      { label: '상태 기준', labelId: 'Standar status', icon: 'Info', to: '/csr/status-guide' },
      { label: '업무 흐름도', labelId: 'Alur kerja', icon: 'Workflow', to: '/csr/flow' },
      {
        label: '핵심문서',
        labelId: 'Dokumen inti',
        icon: 'FileText',
        to: '/csr/docs',
        badge: CORE_DOCS.length,
      },
      {
        label: '판매서류 표준양식',
        labelId: 'Formulir standar',
        icon: 'ClipboardCheck',
        to: '/csr/forms',
        badge: SALES_FORMS.length,
      },
    ],
  },
  {
    // 문서개발 — 개발 중인 문서 시안을 모아 둡니다(2026-10-28 · 작업지시서 ASM-CSR-2026-1028-01).
    label: '문서개발',
    labelId: 'Pengembangan dokumen',
    icon: 'Ruler',
    children: [
      {
        label: '보고서 양식안',
        labelId: 'Rancangan laporan',
        icon: 'FileSpreadsheet',
        to: '/csr/reports',
        badge: REPORT_COUNT,
      },
    ],
  },
]

export const adminItem = { label: '관리', labelId: 'Administrasi', icon: 'UserCog', to: '/csr/admin' }

/**
 * 지금 경로에 해당하는 메뉴 항목 하나 — 가장 긴 접두가 이깁니다. '/csr' 과 '/csr/dashboard'
 * 처럼 접두가 겹치는 항목이 둘 다 켜지지 않게 합니다. 관리 화면도 후보에 넣어야
 * /csr/admin 에서 「개선요청」이 켜지지 않습니다.
 */
const leaves = [...navItems.flatMap((it) => it.children ?? [it]), adminItem]
export const activeLeaf = (path) =>
  leaves
    .filter((it) => matchPath(path, it.to))
    .sort((x, y) => y.to.length - x.to.length)[0] ?? null

/**
 * 메뉴 라벨 — 표시 언어 쪽(2026-09-14 「메뉴 버튼도 한국어/인니어 분리」).
 * labelId 가 없으면 label 로 대신합니다.
 */
export const navLabel = (entry, lang) =>
  (lang === 'id' ? (entry?.labelId ?? entry?.label) : entry?.label) ?? ''

export const APP_VERSION = 'v1.0 · 01 Sep 2026'
