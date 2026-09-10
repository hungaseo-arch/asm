/**
 * 표시 언어 (Display language / Bahasa tampilan) — 작업지시서 §1 · §5-1
 *
 * 저장값은 손대지 않습니다. Notion 옵션은 "조치확인 / Terkonfirmasi" 처럼 두 언어를
 * " / " 로 이어 둔 원문이고, §8 은 그 정규화를 금지합니다. 그래서 화면에서만 가릅니다 —
 * 토글이 인니어면 뒤쪽, 한국어면 앞쪽을 보여 줍니다. 구분자가 없는 값(S2 Major · Open)은
 * 그대로 냅니다.
 */
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
