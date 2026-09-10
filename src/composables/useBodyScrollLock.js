import { onBeforeUnmount, onMounted, toValue, watch } from 'vue'

/*
 * 동시에 열린 오버레이 수를 셉니다 (Lock count / Jumlah kunci).
 *
 * 드로어 위에 상세 모달이 겹치는 경우처럼 잠금이 두 번 걸릴 수 있는데, 각자 "이전 값"을
 * 따로 기억하면 안쪽 것이 닫힐 때 이미 hidden 인 값을 되돌려 배경이 계속 잠깁니다.
 * 마지막 하나가 닫힐 때만 원래 값으로 되돌립니다.
 */
let locks = 0
let previousOverflow = ''

function lock() {
  if (locks === 0) {
    previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
  }
  locks += 1
}
function unlock() {
  if (locks === 0) return
  locks -= 1
  if (locks === 0) document.body.style.overflow = previousOverflow
}

/**
 * 드로어·다이얼로그가 열려 있는 동안 배경 스크롤을 잠급니다.
 * (Body scroll lock / Kunci gulir latar)
 *
 * @param {import('vue').MaybeRefOrGetter<boolean>} [active]
 *   생략하면 컴포넌트가 살아 있는 동안 잠급니다 — `v-if` 로 통째로 여닫는 모달용입니다.
 *   반응형 조건을 넘기면 그 값이 참인 동안만 잠급니다 — 늘 마운트된 채 열림 상태만
 *   바뀌는 드로어(AppSidebar·AppSummaryRail)는 이쪽을 씁니다.
 */
export function useBodyScrollLock(active) {
  if (active === undefined) {
    onMounted(lock)
    onBeforeUnmount(unlock)
    return
  }

  let locked = false
  const apply = (on) => {
    if (on === locked) return
    locked = on
    if (on) lock()
    else unlock()
  }
  watch(() => toValue(active), apply, { immediate: true })
  // 잠근 채로 사라지면 배경이 영영 잠깁니다.
  onBeforeUnmount(() => apply(false))
}
