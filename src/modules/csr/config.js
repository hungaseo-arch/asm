/**
 * CSR 모듈 설정 (CSR module config / Konfigurasi modul CSR)
 *
 * 모듈 식별자는 여기 한 곳에서만 정합니다(작업지시서 C-2). 라우트·테이블 접두사·정책
 * 상수가 전부 `csr` 로 통일되어 있습니다 — 원본 Notion DB 「ASM 개선요청 관리 (CSR)」와
 * 이슈번호 체계 CSR-YYYYMM-nnn 에 맞춘 것입니다.
 */
export const MODULE_SLUG = 'csr'

/**
 * 접속 정보 (Endpoints / Titik akhir)
 *
 * 비밀값이 아닙니다 — 공개 엔드포인트이고 실제 접근 통제는 JWT + RLS 가 합니다.
 * 값이 비어 있으면 화면이 '설정 필요' 안내를 띄우고 조회를 시도하지 않습니다.
 */
export const DATA_API_URL = import.meta.env.VITE_CSR_DATA_API_URL ?? ''
export const AUTH_URL = import.meta.env.VITE_CSR_AUTH_URL ?? ''
export const UPLOAD_URL = import.meta.env.VITE_CSR_UPLOAD_URL ?? ''

export const isConfigured = () => Boolean(DATA_API_URL && AUTH_URL)

/** 역할 (Roles / Peran) — db/001_schema.sql 의 CHECK 제약과 같은 값입니다. */
export const ROLES = ['admin', 'it_dept', 'business']

/** IT상태 (Status) — db/001_schema.sql 의 CHECK 제약과 같은 순서입니다. */
export const IT_STATUSES = ['Open', 'Ongoing', 'Completed', 'Verified', 'On Hold', 'N/A']

/**
 * 선택 항목 (Notion 옵션 문자열 그대로 — 작업지시서 §8: 번역·정규화 금지)
 *
 * DB 컬럼은 text 라 무엇이든 들어가지만, 화면에서는 이관된 값과 같은 문자열만 고르게 해
 * 필터·집계가 갈라지지 않게 합니다. 새 옵션이 필요하면 여기와 Notion 양쪽에 더합니다.
 */
export const OPTIONS = {
  it_decision: [
    '수용 / Diterima',
    '조건부 수용 / Diterima Bersyarat',
    '결정요청 / Perlu Keputusan',
    '보류 / Ditunda',
    '반려 / Ditolak',
    '미회신 / Belum Ada Balasan',
  ],
  verification_result: [
    '조치확인 / Terkonfirmasi',
    '부분조치 / Sebagian',
    '미조치 / Belum Ditindaklanjuti',
    '미검증 / Belum Diverifikasi',
    'Completed 부적정 / Completed Tidak Sesuai',
  ],
  go_live_category: [
    '오픈 前 필수 / Wajib Sebelum Go-Live',
    '오픈 後 / Setelah Go-Live',
    '미정 / Belum Ditentukan',
  ],
  priority: ['S1 Blocker', 'S2 Major', 'S3 Minor', 'S4 Enhancement'],
  issue_type: [
    '오류 / Bug',
    '개선 / Perbaikan',
    '신규기능 / Fitur Baru',
    '데이터정비 / Perapian Data',
    '정책결정 / Keputusan Kebijakan',
  ],
  role_split: ['개발부서 / Tim Pengembang', '현업 / Tim Bisnis', '공동 / Bersama'],
  request_dept: [
    '총괄팀 / Tim Umum',
    '현지 사용자 / Pengguna Lokal',
    '구매 / Pembelian',
    '창고 / Gudang',
    '영업 / Penjualan',
    '재무 / Keuangan',
    '인사 / HRD',
  ],
  menu_main: [
    'Purchasing',
    'Sales',
    'Inventory',
    'Partners',
    'Master Data',
    'Settings',
    '공통 / Umum',
    '업무요건 / Kebutuhan Bisnis',
  ],
}

/**
 * 상태 배지 색 (작업지시서 §5-5 — Notion 색과 동일)
 * asm-theme.css 의 .asm-badge--* 톤을 그대로 씁니다.
 */
export const STATUS_TONE = {
  Open: 'danger',
  Ongoing: 'info',
  Completed: 'success',
  Verified: 'primary',
  'On Hold': 'warning',
  'N/A': 'neutral',
}

/**
 * 편집 권한 (작업지시서 §5-3)
 *
 * ⚠️ 이것은 **화면 표시용**입니다. 실제 차단은 DB 가 합니다 —
 * db/002_rls_policies.sql 의 RLS 가 '행'을, db/003_triggers.sql 의
 * csr_issues_column_guard 트리거가 '컬럼'을 판정합니다.
 *
 * 여기 규칙과 DB 트리거가 어긋나면 UI 는 열려 있는데 저장이 42501 로 실패합니다.
 * 한쪽을 고치면 반드시 다른 쪽도 고치십시오.
 */
const IT_ONLY_COLUMNS = [
  'it_status',
  'it_pic',
  'target_release_on',
  'it_reply_summary_ko',
  'it_reply_summary_id',
]

export const CSR_POLICY = {
  it_dept: {
    editable: IT_ONLY_COLUMNS,
    canAdd: ['it_replies'],
  },
  business: {
    // IT 전용 5개를 제외한 전 컬럼. it_status 만 예외적으로 Completed → Verified 허용.
    deny: IT_ONLY_COLUMNS,
    statusTransition: { Completed: ['Verified'] },
    canAdd: ['issues', 'verifications', 'attachments'],
  },
  admin: {
    editable: '*',
    canAdd: '*',
  },
}

/** 시스템이 관리하는 컬럼 — 화면에서 편집 대상으로 내보내지 않습니다. */
const SYSTEM_COLUMNS = ['id', 'created_at', 'updated_at', 'updated_by']

/**
 * 이 역할이 이 컬럼을 편집할 수 있는가 (표시용 판정).
 * DB 트리거와 같은 규칙이라 둘이 어긋나지 않도록 한 함수로 모았습니다.
 */
export function canEditColumn(role, column, { from, to } = {}) {
  if (!role) return false
  if (SYSTEM_COLUMNS.includes(column)) return role === 'admin'
  if (role === 'admin') return true

  if (role === 'it_dept') return IT_ONLY_COLUMNS.includes(column)

  if (role === 'business') {
    if (column === 'it_status') {
      // 검증을 마친 현업이 Completed 를 Verified 로 닫는 경우만 허용합니다.
      if (from === undefined) return true // 전이 여부를 아직 모를 때는 열어 둡니다
      return from === 'Completed' && to === 'Verified'
    }
    return !IT_ONLY_COLUMNS.includes(column)
  }
  return false
}

/** 이 역할이 이 자식 레코드를 추가할 수 있는가. */
export function canAdd(role, what) {
  const policy = CSR_POLICY[role]
  if (!policy) return false
  return policy.canAdd === '*' || policy.canAdd.includes(what)
}
