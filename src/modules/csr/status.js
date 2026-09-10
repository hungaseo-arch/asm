/**
 * CSR 상태 정의 — 단일 상수 (작업지시서 v1.1 §C · 상태 명칭 표준화 §2)
 *
 * IT상태(it_status)와 현업검증(verification_result)의 코드·한국어·인니어·설명·배지 톤을 여기서만
 * 정합니다. 화면(목록·상세·대시보드·범례·상태 기준 페이지)은 전부 이 파일을 읽습니다 — 화면별
 * 하드코딩 금지. DB 제약(db/016)과 코드 값이 같아야 합니다.
 *
 * 저장값
 *   it_status           : 'Open' | 'Ongoing' | 'Completed' | 'Verified' | 'On Hold' | 'N/A'  (변경 금지)
 *   verification_result : 'PENDING' | 'NOT APPLIED' | 'PARTIAL' | 'ACCEPTED' | 'REJECTED'   (016 이후)
 * 016 적용 전 DB 나 노션에서 온 종전 표기("조치확인 / Terkonfirmasi" 꼴)는 mapLegacyVerifyStatus 로
 * 코드에 맞춰 읽습니다 — 표시 계층은 두 형태를 모두 받아들입니다.
 */

/** 현업검증 5종 — 순서는 진행 단계 순(범례·셀렉트 순서). */
export const VERIFY_STATUS = [
  {
    code: 'PENDING',
    ko: '미검증',
    id: 'Menunggu Verifikasi',
    desc: '현업 검증 전 대기 상태',
    tone: 'neutral',
    legacy: ['미검증', 'Belum diverifikasi'],
  },
  {
    code: 'NOT APPLIED',
    ko: '미조치',
    id: 'Belum Diterapkan',
    desc: '검증 결과 실서버에 반영 없음',
    tone: 'danger',
    legacy: ['미조치', 'Belum ditindaklanjuti'],
  },
  {
    code: 'PARTIAL',
    ko: '부분조치',
    id: 'Sebagian Diterapkan',
    desc: '일부만 반영, 잔여 항목 있음',
    tone: 'warning',
    legacy: ['부분조치', 'Sebagian'],
  },
  {
    code: 'ACCEPTED',
    ko: '조치확인',
    id: 'Diterima',
    desc: '요청대로 반영됨을 현업이 확인',
    tone: 'success',
    legacy: ['조치확인', 'Terkonfirmasi'],
  },
  {
    code: 'REJECTED',
    ko: 'COMPLETED 부적정',
    id: 'Ditolak',
    desc: 'IT 완료 처리했으나 검증 불합격, 재작업 대상',
    tone: 'orange',
    legacy: ['Completed 부적정', 'Completed tidak sesuai'],
  },
]
export const VERIFY_CODES = VERIFY_STATUS.map((s) => s.code)

/**
 * 검증 이력의 기록성 값 — 결과가 아니라 「처음 발견·제안·접수했다」는 표시. 코드로는 PENDING 이 되고
 * (016), 화면은 legacy 값을 곁들여 보여 줍니다.
 */
export const INITIAL_LEGACY = [
  '최초 발견',
  'Temuan awal',
  '최초 제안',
  'Usulan awal',
  '최초 접수',
  'Diterima pertama kali',
]

/** IT상태 — 저장값(value)은 v1.0 그대로, 표시 코드(code)는 대문자. On Hold · N/A 는 노션 잔존값. */
export const IT_STATUS = [
  {
    value: 'Open',
    code: 'OPEN',
    ko: '접수',
    id: 'Terbuka',
    desc: '개선요청 접수됨, IT부서 착수 전(검토·우선순위 대기)',
    tone: 'danger',
  },
  {
    value: 'Ongoing',
    code: 'ONGOING',
    ko: '진행 중',
    id: 'Dalam Proses',
    desc: 'IT부서가 개발·수정 진행 중, 일부 배포 가능',
    tone: 'info',
  },
  {
    value: 'Completed',
    code: 'COMPLETED',
    ko: '조치 완료',
    id: 'Selesai',
    desc: 'IT부서 기준 조치·배포 완료, 현업 검증 대기',
    tone: 'success',
  },
  {
    value: 'Verified',
    code: 'VERIFIED',
    ko: '검증 완료',
    id: 'Terverifikasi',
    desc: '현업 검증 통과로 최종 종결 (전환 권한: 총괄팀)',
    tone: 'primary',
  },
  {
    value: 'On Hold',
    code: 'ON HOLD',
    ko: '보류',
    id: 'Ditunda',
    desc: '진행 보류',
    tone: 'warning',
  },
  {
    value: 'N/A',
    code: 'N/A',
    ko: '해당 없음',
    id: 'Tidak Berlaku',
    desc: '대상 아님',
    tone: 'neutral',
  },
]
export const IT_STATUSES = IT_STATUS.map((s) => s.value)
export const STATUS_TONE = Object.fromEntries(IT_STATUS.map((s) => [s.value, s.tone]))

const norm = (s) =>
  String(s ?? '')
    .trim()
    .toLowerCase()

/**
 * 종전 표기 → 코드 (작업지시서 §4 mapLegacyVerifyStatus).
 * 받는 형태: 'ACCEPTED' · 'NOT_APPLIED' · '조치확인 / Terkonfirmasi' · 'Terkonfirmasi' ·
 * '미검증 (Belum diverifikasi)' · 'COMPLETED 부적정' · '최초 발견'(→ PENDING). 모르는 값은 null.
 */
export function mapLegacyVerifyStatus(value) {
  const v = norm(value)
  if (!v) return null
  for (const s of VERIFY_STATUS) {
    if (v === s.code.toLowerCase() || v === s.code.toLowerCase().replace(' ', '_')) return s.code
  }
  // 종전 표기는 "KO / ID" · "KO (ID)" · 한쪽만 — 앞부분 일치로 봅니다. REJECTED 를 먼저(‘Completed…’ 가 다른 것과 겹치지 않도록).
  const ordered = [...VERIFY_STATUS].sort((a, b) =>
    a.code === 'REJECTED' ? -1 : b.code === 'REJECTED' ? 1 : 0,
  )
  for (const s of ordered) {
    if (s.legacy.some((t) => v.startsWith(t.toLowerCase()))) return s.code
  }
  if (INITIAL_LEGACY.some((t) => v.startsWith(t.toLowerCase()))) return 'PENDING'
  return null
}

/** 값(코드 또는 종전 표기)의 정의 행. 모르면 null. */
export const verifyMeta = (value) => {
  const code = mapLegacyVerifyStatus(value)
  return code ? VERIFY_STATUS.find((s) => s.code === code) : null
}
/** 화면에 찍는 코드 — 모르는 값은 원문 그대로(잘못 바꾸느니 원문). */
export const verifyCodeOf = (value) =>
  mapLegacyVerifyStatus(value) ?? (value == null ? null : String(value))
/** 셀렉트 라벨 — "PENDING · 미검증 · Menunggu Verifikasi" (작업지시서 §C-2). */
export const verifyLabel = (code) => {
  const s = VERIFY_STATUS.find((x) => x.code === code)
  return s ? `${s.code} · ${s.ko} · ${s.id}` : code
}
/** 필터 옵션 라벨 — "PENDING (미검증)" 꼴 (§C-2 en (ko)). */
export const verifyFilterLabel = (code, lang) => {
  const s = VERIFY_STATUS.find((x) => x.code === code)
  return s ? `${s.code} (${lang === 'id' ? s.id : s.ko})` : code
}
/** 배지 툴팁 — "미검증 / Menunggu Verifikasi — 설명". */
export const verifyTitle = (value) => {
  const s = verifyMeta(value)
  return s ? `${s.ko} / ${s.id} — ${s.desc}` : ''
}
/** 기록성 값인가(최초 발견 등) — §7 표에서 코드 옆에 원문을 곁들일지. */
export const isInitialLegacy = (value) => {
  const v = norm(value)
  return Boolean(v) && INITIAL_LEGACY.some((t) => v.startsWith(t.toLowerCase()))
}

export const itStatusMeta = (value) => IT_STATUS.find((s) => s.value === value) ?? null
export const itStatusTitle = (value) => {
  const s = itStatusMeta(value)
  return s ? `${s.ko} / ${s.id} — ${s.desc}` : ''
}

/**
 * 「검증 대기」 정의 — IT 가 Completed 로 회신했고 현업이 아직 Verified 로 닫지 않은 건.
 * 목록 프리셋 · 대시보드 목록 · 카드가 모두 이 함수를 씁니다(§C-2 코드 상수 분리).
 */
export const PENDING_VERIFICATION = { itStatus: 'Completed' }
export const isPendingVerification = (row) => row?.it_status === PENDING_VERIFICATION.itStatus

/** 코드 ↔ 노션 옵션명 — 향후 재동기화용. 노션 옵션명 자체는 바꾸지 않습니다(§C-2). */
export const NOTION_VERIFY_OPTION = {
  PENDING: '미검증 / Belum Diverifikasi',
  'NOT APPLIED': '미조치 / Belum Ditindaklanjuti',
  PARTIAL: '부분조치 / Sebagian',
  ACCEPTED: '조치확인 / Terkonfirmasi',
  REJECTED: 'Completed 부적정 / Completed Tidak Sesuai',
}

/** 전환 규칙 안내 — 범례 하단, 3개 언어. */
export const TRANSITION_RULES = [
  {
    ko: 'COMPLETED + ACCEPTED → VERIFIED 전환 (총괄팀)',
    en: 'COMPLETED + ACCEPTED → VERIFIED (business / admin)',
    id: 'COMPLETED + ACCEPTED → VERIFIED (Tim Umum)',
  },
  {
    ko: 'COMPLETED + REJECTED → ONGOING 으로 되돌림 (IT부서)',
    en: 'COMPLETED + REJECTED → back to ONGOING (IT department)',
    id: 'COMPLETED + REJECTED → kembali ke ONGOING (Tim IT)',
  },
]
