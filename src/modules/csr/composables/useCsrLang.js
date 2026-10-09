import { computed, unref } from 'vue'
import { useIdentityStore } from '@/stores/identity'

/**
 * 화면 언어 토글 공통 헬퍼 — 여러 화면·컴포넌트에 흩어져 있던
 * `(ko, id) => lang.value === 'id' ? id : ko` 를 한 곳으로 모읍니다.
 *
 * source 를 안 주면 identity 스토어(헤더 토글)를 그대로 따릅니다. prop 으로 lang 을
 * 받는 컴포넌트(CsrStatusLegend 등)는 `useCsrLang(() => props.lang)` 처럼 넘기십시오.
 */
export function useCsrLang(source) {
  const identity = useIdentityStore()
  const lang = source ? computed(() => unref(typeof source === 'function' ? source() : source)) : computed(() => identity.lang)
  /** 두 문자열 중 토글 언어 쪽. */
  const t = (ko, id) => (lang.value === 'id' ? id : ko)
  /** [ko, id] 쌍에서 토글 언어 쪽(문단이 많은 화면 — Flow·StatusGuide). */
  const tp = (pair) => (lang.value === 'id' ? pair[1] : pair[0])
  return { lang, t, tp }
}
