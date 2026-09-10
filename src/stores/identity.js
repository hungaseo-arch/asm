import { computed, ref } from 'vue'
import { defineStore } from 'pinia'

/**
 * 헤더에 보일 '지금 누구인가' (Identity / Identitas)
 *
 * 헤더(AppTopbar)는 모든 화면에 실리는 전역 요소라 Neon 클라이언트를 끌어오면 안 됩니다 —
 * 초기 청크에 better-auth·postgrest 가 통째로 들어갑니다(workOrder.md §6 500 KB 한도).
 * 그래서 CSR 세션 스토어가 로그인·역할 조회를 마친 뒤 **이름·소속·이메일만** 여기 올리고,
 * 헤더는 이 가벼운 스토어만 읽습니다. 인증 상태의 진실은 여전히 CSR 세션 쪽입니다.
 *
 * 세션이 없으면 표시 전용 자리표시자(APP_USER)로 돌아갑니다 — 운영 화면은 로그인이
 * 비활성이라(router/index.js) 그때는 보여 줄 실제 사용자가 없습니다.
 */
export const useIdentityStore = defineStore('identity', () => {
  const name = ref(null)
  const email = ref(null)
  const role = ref(null)
  const department = ref(null)

  const isSignedIn = computed(() => Boolean(email.value))

  /**
   * 표시 언어 — CSR 국기 토글의 진실. 헤더 계정 메뉴의 문구까지 같은 언어여야 해서
   * (2026-09-10 「한국어·인니어 혼용」) Neon 을 모르는 이 스토어에 둡니다. 새로고침해도
   * 유지되도록 localStorage 에 적어 둡니다 — 값은 'id' | 'ko' 둘뿐입니다.
   */
  const lang = ref(readLang())
  function setLang(v) {
    lang.value = v === 'ko' ? 'ko' : 'id'
    try {
      localStorage.setItem(LANG_KEY, lang.value)
    } catch {
      // 사생활 모드 등에서 저장이 막혀도 화면 언어는 바뀌어야 합니다.
    }
  }

  /**
   * 헤더 계정 메뉴가 부를 동작. CSR 세션 스토어가 로그인 뒤 등록합니다 — 헤더가 Neon 을
   * import 하지 않고도 로그아웃할 수 있게 하는 우회로입니다.
   */
  const actions = ref({ signOut: null })
  const setActions = (a) => (actions.value = { ...actions.value, ...a })

  /**
   * 「비밀번호 변경」 요청 비트. 다이얼로그는 CSR 화면 안에 있으므로(Neon 청크) 헤더는
   * 비트만 올리고, CSR 화면이 그것을 보고 다이얼로그를 엽니다.
   */
  const passwordRequested = ref(false)
  const requestPasswordChange = () => (passwordRequested.value = true)
  const consumePasswordRequest = () => {
    const was = passwordRequested.value
    passwordRequested.value = false
    return was
  }

  /**
   * 표시용 — 세션이 있으면 그 사람. 없으면 「로그인」 자리만 둡니다. 전에는 APP_USER
   * (Seo Jonghwan) 를 보여 줬는데 로그아웃 뒤에도 이름이 남아 헷갈렸습니다(2026-09-10).
   */
  const display = computed(() => {
    if (!isSignedIn.value) {
      return {
        name: lang.value === 'id' ? 'Masuk' : '로그인',
        initials: '?',
        role: '',
        email: null,
        placeholder: true,
      }
    }
    const shown = name.value || email.value
    return {
      name: shown,
      initials: initialsOf(shown),
      // 소속이 있으면 소속(sales_admin 등), 없으면 권한 등급(admin 등)을 pill 에 씁니다.
      role: department.value || role.value || '',
      email: email.value,
      placeholder: false,
    }
  })

  function set({ name: n, email: e, role: r, department: d }) {
    name.value = n ?? null
    email.value = e ?? null
    role.value = r ?? null
    department.value = d ?? null
  }
  function clear() {
    set({})
  }

  return {
    lang,
    setLang,
    name,
    email,
    role,
    department,
    isSignedIn,
    display,
    set,
    clear,
    actions,
    setActions,
    passwordRequested,
    requestPasswordChange,
    consumePasswordRequest,
  }
})

const LANG_KEY = 'csr.lang'
function readLang() {
  try {
    return localStorage.getItem(LANG_KEY) === 'ko' ? 'ko' : 'id'
  } catch {
    return 'id'
  }
}

/** "Seo Jonghwan" → "SJ", "Lia" → "L", "jhseo@…" → "J" */
function initialsOf(text) {
  const words = String(text).split('@')[0].trim().split(/\s+/).filter(Boolean)
  const letters = words.slice(0, 2).map((w) => w[0].toUpperCase())
  return letters.join('') || '?'
}
