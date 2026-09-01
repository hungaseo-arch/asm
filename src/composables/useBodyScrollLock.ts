import { onBeforeUnmount, onMounted } from 'vue'

/**
 * 드로어·다이얼로그가 열려 있는 동안 배경 스크롤을 잠급니다.
 * (Body scroll lock / Kunci gulir latar)
 */
export function useBodyScrollLock() {
  let previousOverflow = ''

  onMounted(() => {
    previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
  })

  onBeforeUnmount(() => {
    document.body.style.overflow = previousOverflow
  })
}
