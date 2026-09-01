// 런타임 설정 자리표시자 (Runtime config placeholder / Konfigurasi runtime).
// 배포 파이프라인이 백엔드 배포 후 이 파일을 실제 API base URL로 덮어씁니다.
//   window.__ASM_APP_CONFIG__ = { apiBaseUrl: "https://api.ascendotyre.com" };
window.__ASM_APP_CONFIG__ = window.__ASM_APP_CONFIG__ || {}
// 이전 React 클라이언트와의 호환 (기존 배포 스크립트가 이 키를 씁니다)
window.__SKYBASE_APP_CONFIG__ = window.__SKYBASE_APP_CONFIG__ || {}
