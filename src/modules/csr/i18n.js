/**
 * 표시 언어 (Display language / Bahasa tampilan) — 작업지시서 §1 · §5-1
 *
 * 저장값은 손대지 않습니다. Notion 옵션은 "조치확인 / Terkonfirmasi" 처럼 두 언어를
 * " / " 로 이어 둔 원문이고, §8 은 그 정규화를 금지합니다. 그래서 화면에서만 가릅니다 —
 * 토글이 인니어면 뒤쪽, 한국어면 앞쪽을 보여 줍니다. 구분자가 없는 값(S2 Major · Open)은
 * 그대로 냅니다.
 */
import { DECISION_TONE, RESULT_TONE } from './config'

const SEP = ' / '

const HANGUL = /[가-힣]/
/** "미검증 (Belum diverifikasi)" — 검증 이력 결과가 쓰는 괄호 병기. 한쪽만 한글일 때만 두 언어로 봅니다. */
const PAREN = /^(.+?)[ ]*[(](.+)[)][ ]*$/

export function pickLang(value, lang) {
  if (value === null || value === undefined) return value
  const s = String(value)
  const i = s.indexOf(SEP)
  if (i >= 0) {
    const ko = s.slice(0, i).trim()
    const id = s.slice(i + SEP.length).trim()
    return lang === 'id' ? id || ko : ko || id
  }
  // "한국어 (Indonesia)" 꼴 — "Purchasing (LOCAL)" 처럼 양쪽 다 라틴이면 그대로 둡니다.
  const m = s.match(PAREN)
  if (m && HANGUL.test(m[1]) !== HANGUL.test(m[2])) {
    const [ko, id] = HANGUL.test(m[1]) ? [m[1], m[2]] : [m[2], m[1]]
    return lang === 'id' ? id.trim() : ko.trim()
  }
  return s
}

/** 두 언어 컬럼 쌍(title_ko/title_id 등)에서 하나를 고릅니다 — 비어 있으면 다른 쪽으로. */
export const pickPair = (ko, id, lang) => (lang === 'id' ? (id ?? ko) : (ko ?? id))

/** 화면 라벨. 키는 DB 컬럼명이라 헤더·속성 카드·편집 폼이 같은 사전을 씁니다. */
const LABELS = {
  issue_no: { ko: '이슈번호', id: 'No. Isu' },
  title: { ko: '제목', id: 'Judul' },
  it_status: { ko: 'IT상태', id: 'Status IT' },
  verification_result: { ko: '현업검증', id: 'Hasil Verifikasi' },
  it_decision: { ko: 'IT수용여부', id: 'Keputusan IT' },
  it_pic: { ko: '담당자', id: 'PIC' },
  target_release_on: { ko: '목표배포일', id: 'Tgl. Rilis Target' },
  go_live_category: { ko: '오픈구분', id: 'Kategori Go-Live' },
  it_reply_summary: { ko: '회신요약', id: 'Ringkasan Balasan' },
  menu_main: { ko: '대메뉴', id: 'Menu Utama' },
  menu_sub: { ko: '중메뉴', id: 'Sub Menu' },
  path_menu: { ko: '화면경로', id: 'Path Menu' },
  issue_type: { ko: '유형', id: 'Jenis' },
  priority: { ko: '중요도', id: 'Prioritas' },
  request_dept: { ko: '요청부서', id: 'Divisi Peminta' },
  requested_on: { ko: '요청일', id: 'Tgl. Permintaan' },
  role_split: { ko: '분담', id: 'Pembagian Peran' },
  related_issues: { ko: '관련이슈', id: 'Isu Terkait' },
  verified_on: { ko: '최종검증일', id: 'Tgl. Verifikasi' },
  summary: { ko: '요약', id: 'Ringkasan' },
  acceptance: { ko: '수용기준', id: 'Kriteria Selesai' },
  archived: { ko: '아카이브 표시', id: 'Tampilkan arsip' },
  search: { ko: '이슈번호 · 제목 검색', id: 'Cari no. isu · judul' },
  preset_it: { ko: 'IT부서용', id: 'Untuk Tim IT' },
  preset_pending: { ko: '검증 대기', id: 'Menunggu verifikasi' },
  reset: { ko: '전체', id: 'Semua' },
  list_title: { ko: '개선요청', id: 'Permintaan Perbaikan' },
  empty: { ko: '조건에 맞는 개선요청이 없습니다', id: 'Tidak ada permintaan yang cocok' },
  loading: { ko: '불러오는 중…', id: 'Memuat…' },
}

export const label = (key, lang) => LABELS[key]?.[lang] ?? LABELS[key]?.ko ?? key

/**
 * 정해진 값의 용어 사전 — 검증 이력의 결과(result) · IT 회신의 수용 여부(decision).
 * 저장값은 Notion 원문(한 언어)이라 컬럼을 늘리지 않고 표시만 바꿉니다. 「수용 — Completed」 처럼
 * " — " 로 이어진 값은 조각마다 사전을 적용합니다(Completed 같은 영어 상태값은 그대로).
 * 사전에 없는 값은 그대로 보여 줍니다 — 잘못 바꾸느니 원문이 낫습니다.
 */
const TERMS = [
  ['최초 발견', 'Temuan awal'],
  ['최초 제안', 'Usulan awal'],
  ['최초 접수', 'Diterima pertama kali'],
  ['조치확인', 'Terkonfirmasi'],
  ['부분조치', 'Sebagian'],
  ['미조치', 'Belum ditindaklanjuti'],
  ['미검증', 'Belum diverifikasi'],
  ['Completed 부적정', 'Completed tidak sesuai'],
  ['수용', 'Diterima'],
  ['조건부 수용', 'Diterima Bersyarat'],
  ['결정요청', 'Perlu Keputusan'],
  ['보류', 'Ditunda'],
  ['반려', 'Ditolak'],
  ['미회신', 'Belum Ada Balasan'],
]
const TERM_TO_ID = new Map(TERMS.map(([ko, id]) => [ko, id]))
const TERM_TO_KO = new Map(TERMS.map(([ko, id]) => [id.toLowerCase(), ko]))

/** 결정사항 값의 배지 톤 — kind 는 'it_decision' | 'verification_result'. 모르는 값은 neutral. */
export function toneOf(kind, value) {
  if (!value) return 'neutral'
  const table = kind === 'it_decision' ? DECISION_TONE : RESULT_TONE
  const head = termLang(value, 'ko').split(' — ')[0].trim()
  // 대소문자 무시 — 'Completed 부적정'(DB) 과 'COMPLETED 부적정'(문서·손입력) 을 같은 값으로 봅니다.
  const hit = Object.keys(table).find((k) => k.toLowerCase() === head.toLowerCase())
  return hit ? table[hit] : 'neutral'
}

export function termLang(value, lang) {
  if (value == null) return value
  // "미검증 (Belum diverifikasi)" · "조치확인 / Terkonfirmasi" 꼴은 먼저 한쪽만 남기고
  const base = pickLang(value, lang)
  return String(base)
    .split(' — ')
    .map((part) => {
      const p = part.trim()
      if (lang === 'id') return TERM_TO_ID.get(p) ?? p
      return TERM_TO_KO.get(p.toLowerCase()) ?? p
    })
    .join(' — ')
}

/**
 * 화면경로 한글 토큰 → 실제 ASM 사이트 용어(영어). db/008_path_menu_english.sql 의 표와 같은 순서·같은
 * 내용입니다(긴 토큰 먼저). 저장값은 008 이 고치고, 여기서는 **표시만** 같은 규칙으로 바꿉니다 —
 * 008 이 아직 안 돌아간 DB 에서도 화면은 사이트 메뉴와 같게 보이도록(2026-09-10 요청 3회).
 * 표를 고칠 때는 두 곳을 함께 고치십시오.
 */
export const PATH_TOKENS = [
  [
    'Purchasing > Payment Plan 신설 — PO 연결, 지급조건 · 예정일 · 실제 지급일 · 환율 · 잔액, PPC → 지급 → Shipment 상태 연동, 월별 지급 예정 · 미지급 리포트',
    'Purchasing > Payment Plan (new menu)',
  ],
  ['전 화면 (금액 · 수량 · 단가 표기)', 'All screens (amount · qty · unit price format)'],
  ['전 화면 (목록 · 상세 레이아웃)', 'All screens (list · detail layout)'],
  ['전 입력 화면 (저장 시 검증)', 'All input screens (validation on save)'],
  ['전 화면 날짜 입력란', 'All screens date input'],
  ['전 목록 화면', 'All list screens'],
  ['전 화면', 'All screens'],
  ['로그인 화면', 'Login screen'],
  ['메뉴 트리', 'Menu tree'],
  ['신규·상세 (재고 연동)', 'New·Detail (stock link)'],
  ['신규·상세', 'New·Detail'],
  ['목록·상세', 'List·Detail'],
  ['신규 (창고 선택)', 'New (warehouse selection)'],
  ['신규 (단가 입력)', 'New (unit price input)'],
  ['신규 (품목 입력)', 'New (item input)'],
  ['신규 (품목 행)', 'New (item row)'],
  ['신규 (합계 블록)', 'New (total block)'],
  ['신규 (배송지', 'New (shipping address'],
  ['신규(LOCAL) 공급사 드롭다운', 'New (LOCAL) supplier dropdown'],
  ['신규(LOCAL)', 'New (LOCAL)'],
  ['신규(IMPORT · LOCAL)', 'New (IMPORT · LOCAL)'],
  ['승인 팝업', 'Approval popup'],
  ['출력(GRPO)', 'Print (GRPO)'],
  ['(신설 요청)', '(new menu request)'],
  ['(신설)', '(new menu)'],
  ['(메뉴 권한)', '(menu permission)'],
  ['(Confirm 권한)', '(Confirm permission)'],
  ['등 목록', 'etc. list'],
  ['ACTUAL 탭', 'ACTUAL tab'],
  ['ESTIMATED 탭', 'ESTIMATED tab'],
  ['명칭 변경 확인', 'name change check'],
  ['Est. Delivery Date 정렬', 'Est. Delivery Date sort'],
  ['PO Date · Delivery Date 변경', 'PO Date · Delivery Date change'],
  ['Delivery Note 운송 정보', 'Delivery Note shipping info'],
  ['직원 마스터 DEPARTMENT', 'staff master DEPARTMENT'],
  ['GRPO 출력물', 'GRPO printout'],
  ['신규', 'New'],
  ['상세', 'Detail'],
  ['목록', 'List'],
  ['승인', 'Approve'],
  ['확정', 'Confirm'],
  ['출력', 'Print'],
  ['신설', 'new menu'],
]

export function pathToEnglish(value) {
  if (value == null) return value
  let s = String(value)
  if (!/[가-힣]/.test(s)) return s
  for (const [ko, en] of PATH_TOKENS) s = s.split(ko).join(en)
  return s
}
