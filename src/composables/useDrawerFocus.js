import { nextTick, watch } from 'vue'

/**
 * 드로어 포커스 이동 (Drawer focus / Fokus laci)
 *
 * 드로어는 본문 흐름 밖(fixed)에 있고 DOM 순서상 헤더 바로 뒤가 아니라서, 헤더의 열기
 * 버튼을 누른 뒤 Tab 을 치면 드로어가 아니라 본문으로 들어갑니다 — 키보드·스크린리더
 * 사용자에게는 열리지 않은 것과 같습니다. 열리면 드로어 안(닫기 버튼)으로 포커스를
 * 옮기고, 닫히면 열었던 버튼으로 되돌려 줍니다(가이드 8-5 오버레이 규칙).
 *
 * @param {import('vue').MaybeRefOrGetter<boolean>} open 드로어 열림 상태
 * @param {import('vue').Ref<HTMLElement|null>} target 열렸을 때 포커스를 받을 요소
 */
export function useDrawerFocus(open, target) {
  /** 드로어를 연 요소 — 닫은 뒤 포커스를 돌려줄 자리입니다. */
  let opener = null

  watch(open, async (isOpen) => {
    if (isOpen) {
      opener = document.activeElement
      await nextTick()
      target.value?.focus()
      return
    }
    const el = opener
    opener = null
    // 화면이 바뀌며 닫힌 경우 열었던 버튼이 이미 사라졌을 수 있습니다.
    if (el?.isConnected) el.focus()
  })
}
