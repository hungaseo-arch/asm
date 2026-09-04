import { onUnmounted, ref, watchEffect } from 'vue'

/**
 * 사이드바 요약 카드 공유 상태 (Shared summary state / Status ringkasan bersama)
 *
 * 요약 레일(AppSummaryRail.vue)과 화면(PurchasePoPage 등)은 DefaultLayout 아래의 형제
 * 컴포넌트라 props·emit 으로 직접 데이터를 주고받을 수 없습니다. 화면이 자신의 요약
 * 카드를 이 모듈 스코프 ref 에 등록하면, 레일은 그대로 읽어 렌더링합니다.
 * (2026-09-04 — 요약 카드를 본문에서 좌측 레일로 이동)
 */
const cards = ref([])

/**
 * 현재 카드의 주인(화면) 토큰.
 *
 * Vue 의 onUnmounted 는 post-flush 큐에서 실행돼 "새 화면 setup → 이전 화면 unmounted"
 * 순서가 됩니다. 그래서 이전 화면이 무조건 비우면 방금 등록된 새 화면 카드까지 지워져,
 * 목록 화면에서 Purchase PO 로 이동하면 레일이 빈 채로 남았습니다(2026-09-04 발견).
 * 주인이 이미 바뀐 뒤에 도착한 늦은 정리 호출은 무시합니다.
 */
let owner = null

/** AppSummaryRail.vue 에서 읽기 전용으로 구독합니다. */
export function useSidebarSummary() {
  return { cards }
}

/**
 * 화면에서 자신의 요약 카드를 등록합니다. getter 가 바뀌면 자동으로 갱신되고,
 * 화면이 사라질 때(다음 화면이 이미 등록했다면 건드리지 않고) 스스로 비웁니다.
 *
 * @param {() => Array} getSummaryCards 카드 배열을 돌려주는 getter
 */
export function provideSidebarSummary(getSummaryCards) {
  const token = Symbol('summary-owner')
  watchEffect(() => {
    cards.value = getSummaryCards()
    owner = token
  })
  onUnmounted(() => {
    if (owner !== token) return
    owner = null
    cards.value = []
  })
}
