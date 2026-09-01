import { onBeforeUnmount, onMounted } from 'vue'
/** Esc 키로 오버레이를 닫습니다 (Escape to close / Tutup dengan Esc). */
export function useEscapeToClose(close) {
  function onKeydown(event) {
    if (event.key === 'Escape') {
      event.stopPropagation()
      close()
    }
  }
  onMounted(() => document.addEventListener('keydown', onKeydown))
  onBeforeUnmount(() => document.removeEventListener('keydown', onKeydown))
}
