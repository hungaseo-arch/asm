import type { Currency } from '@/lib/format'
import type { BadgeTone } from '@/types/purchase-po'

/**
 * 목록 화면 정의 (List screen definition / Definisi layar daftar)
 *
 * 화면 시안(asm-mockup)의 `ASM.grid({ columns, rows })` 계약을 그대로 옮긴 구조입니다.
 * 컬럼과 데이터만 선언하면 검색·정렬·페이징·합계·CSV 는 ListScreen 이 처리합니다.
 */

/** 셀 서식 — 숫자 표기는 전부 lib/format.ts 를 거칩니다. */
export type CellFormat =
  | 'text'
  | 'code' /* 문서번호·품번 — monospace */
  | 'int' /* 정수 + 천 단위 콤마 */
  | 'signed' /* 증감 — 양수에 + 표기 */
  | 'price' /* 소수점 2자리 */
  | 'percent'
  | 'weight'
  | 'currency' /* 통화 코드 선행 */
  | 'date'
  | 'badge' /* 상태 배지 */
  | 'mark' /* 권한 O/X */

export type ScreenColumn = {
  key: string
  label: string
  align: 'left' | 'right' | 'center'
  format: CellFormat
  currency?: Currency
  ellipsis?: boolean
  width?: string
}

export type ScreenRow = Record<string, string | number>

export type ScreenDef = {
  /** URL 슬러그 (예: quotation → /sales/quotation) */
  slug: string
  /** 상단 메뉴 대분류 (Sales · Inventory · Master Data · Settings) */
  group: string
  /** 사이드바 표시명 */
  navLabel: string
  title: string
  /** 인니어 · 한국어 병기 부제 */
  subtitle: string
  cardTitle: string
  searchPlaceholder: string
  /** 시안의 "＋ NEW ..." 버튼 라벨 */
  primaryAction: string
  /** 검색 대상 열 — key 'all' 은 전체 열 검색 */
  searchFields: Array<{ label: string; key: string }>
  columns: ScreenColumn[]
  /** 합계를 내는 열 */
  totalKeys: string[]
  /** 합계 행에서 "Total" 라벨이 차지하는 열 수 */
  totalLabelSpan: number
  pageSize: number
  rows: ScreenRow[]
}

/**
 * 상태 문자열 → 배지 색상 (가이드 3-2)
 * 시안 `asm-common.js` 의 BADGE 매핑을 그대로 옮겼습니다.
 */
export const STATUS_TONE: Record<string, BadgeTone> = {
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

export const toneOf = (status: string): BadgeTone => STATUS_TONE[status?.toUpperCase()] ?? 'neutral'
