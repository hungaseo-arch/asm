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

// ASM web client (Vue 3). The API server (Hono + Better Auth) is unchanged from
// the previous React client, so dev requests to /api are proxied to it.
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
    proxy: {
      '/api': {
        target: process.env.VITE_DEV_API_TARGET ?? 'http://localhost:3000',
        changeOrigin: true,
      },
    },
  },
}))
