/**
 * 상태 문자열 → 배지 색상 (가이드 3-2)
 * 시안 `asm-common.js` 의 BADGE 매핑을 그대로 옮겼습니다.
 */
export const STATUS_TONE = {
  DRAFT: 'neutral',
  PENDING: 'warning',
  DELAYED: 'warning',
  OPEN: 'warning',
  CONFIRMED: 'info',
  APPROVED: 'info',
  ISSUED: 'info',
  PARTIAL: 'info',
  'IN TRANSIT': 'info',
  COMPLETED: 'success',
  RECEIVED: 'success',
  DELIVERED: 'success',
  CLOSED: 'success',
  ACTIVE: 'success',
  POSTED: 'success',
  CANCELED: 'danger',
  REJECTED: 'danger',
  INACTIVE: 'danger',
  OVERDUE: 'danger',
}
export const toneOf = (status) => STATUS_TONE[status?.toUpperCase()] ?? 'neutral'
/**
 * 권한 수준 표기 (권한 가이드라인 v3.0 · 1장 기호 정의)
 * ● 전체관리 / ◐ 작성·편집 / ○ 조회 / △ 조건부(C1~C4) / × 권한 없음
 */
export const ACCESS_LEVEL = {
  F: { mark: '●', label: '전체관리 (Full Control)', tone: 'full' },
  E: { mark: '◐', label: '작성·편집 (Create / Edit)', tone: 'edit' },
  V: { mark: '○', label: '조회 (View Only)', tone: 'view' },
  C: { mark: '△', label: '조건부 (Conditional C1~C4)', tone: 'cond' },
  N: { mark: '×', label: '권한 없음 (No Access)', tone: 'none' },
}
