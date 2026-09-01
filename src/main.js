import { createApp } from 'vue'
import { createPinia } from 'pinia'
// 스타일 순서 중요: Bootstrap → ASM 테마(오버라이드) → vue-sonner
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/js/dist/dropdown'
import '@/assets/asm-theme.css'
// vue-sonner 1.x 는 컴포넌트에 스타일이 포함되어 별도 CSS import 가 필요 없습니다.
import App from './App.vue'
import icons from '@/plugins/icons'
import router from './router'
import { syncAuthTokenFromUrl } from '@/api/api'
async function bootstrap() {
  // OAuth 리다이렉트로 돌아온 login_token 을 세션 토큰으로 승격시킨 뒤 마운트합니다.
  await syncAuthTokenFromUrl().catch(() => false)
  const app = createApp(App)
  app.use(createPinia())
  app.use(icons)
  app.use(router)
  app.mount('#app')
}
void bootstrap()
