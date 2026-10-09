import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

/**
 * 배포 하위 경로 (Deploy base path).
 * GitHub Pages 는 https://<user>.github.io/<repo>/ 로 서비스되므로 빌드 산출물이
 * `/asm/` 을 기준으로 자산을 참조해야 합니다. 루트 도메인에 배포할 때는 '/' 로 바꾸거나
 * 배포 파이프라인에서 ASM_BASE 환경변수를 지정하십시오.
 */
const BUILD_BASE = process.env.ASM_BASE ?? '/asm/'

export default defineConfig(({ command }) => ({
  base: command === 'build' ? BUILD_BASE : '/',
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    host: '::',
    port: 3100,
  },
}))
