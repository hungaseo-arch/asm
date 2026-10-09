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

const app = createApp(App)
app.use(createPinia())
app.use(icons)
app.use(router)
app.mount('#app')
