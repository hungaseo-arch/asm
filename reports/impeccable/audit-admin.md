# Impeccable Audit — admin (src/modules/csr/views/CsrAdminPage.vue)

**점수 : 14/20 — Good (약한 차원 보완)**  |  P0 0 · P1 2 · P2 4 · P3 2

| # | 차원 | 점수 | 핵심 |
|---|------|------|------|
| 1 | Accessibility | 2 | 탭 키보드 패턴 미비(roving tabindex·화살표), 비밀번호 평문 입력, window.confirm 2중 |
| 2 | Performance | 3 | 단순 정적 표·애니메이션 없음. 200행 비가상화 정도 |
| 3 | Theming | 4 | 스타일 전부 토큰 var() 사용, 생 HEX 없음 (DESIGN.md No-Raw-Hex 준수) |
| 4 | Responsive | 2 | 사용자 표에 스크롤 래퍼 없음 → 320px 가로 넘침. 행 버튼 터치 타깃 작음 |
| 5 | Implementation Integrity | 3 | 토큰·클래스 체계 일관. 한/인니 문자열 일부가 t() 밖에 하드코딩 |

감사 방식 : 소스 정적 점검(렌더 캡처·detector 실행 안 함). 터치·실기 검증은 미수행.

## Implementation Integrity 판정
통과. `--asm-*` 토큰만 사용, 평상시 그림자 없음, Weight Ladder(500/700) 준수. 결함은 반응형·접근성 구조에 집중.

## 상세 (P등급 · 파일:라인)

### P1
1. **사용자 표 가로 스크롤 래퍼 없음** — `CsrAdminPage.vue:422`. 로그 두 표(521, 570)는 `.table-scroll`로 감쌌으나 사용자 표(7열, `nowrap` 다수)는 미적용 → 좁은 화면에서 패널 밖으로 넘침(PRODUCT.md: 320px 비파손 요건 위반). 추천: `$impeccable adapt`. 공유: 아니오(`.table-scroll`는 scoped 733행, 재사용 시 전역화는 공유).
2. **탭 키보드 조작 불완전(WAI-ARIA tabs)** — `:294-331`. role=tab이나 비활성 탭 `tabindex=-1`·←/→ Home/End 처리 없음, `:aria-selected`는 불린 바인딩이라 `"true"/"false"` 문자열화는 되지만 roving tabindex 부재로 Tab 3회 필요. WCAG 2.1.1/4.1.2 수준 미흡. 추천: `$impeccable harden`. 공유: 아니오(다른 화면 탭과 공통 컴포넌트화하면 공유).

### P2
3. **탭 버튼 포커스 링 미정의** — `:627-643`. `.btn:focus-visible`(asm-theme.css:272)은 `.tabs button`에 적용되지 않음. 브라우저 기본 아웃라인에 의존, DESIGN.md Focus ring(0 0 0 3px primary-40)과 불일치. 추천: `$impeccable polish`. 공유: **공유**(전역 CSS 포커스 규칙 확장 시).
4. **행 액션 버튼 터치 타깃 작음** — `:449-462`. `btn-sm btn-link` 3개가 인접·한 줄(`.ops nowrap`), 높이 약 24–31px, 간격 좁음. 24px 기준은 겨우 충족, 44px 권장 미달. 추천: `$impeccable adapt`. 공유: 아니오.
5. **비밀번호 입력이 `type="text"` 평문** — `:476`. 어깨너머 노출. 관리자가 정해 주는 임시값이라 의도적일 수 있으나 표시/숨김 토글 없음. 추천: `$impeccable harden`. 공유: 아니오.
6. **파괴 동작을 `window.confirm` 2연속으로 처리** — `:179-191`. 문구가 「[확인]/[취소]」 의미를 본문에 설명(혼동 위험), 접근성·스타일 일관성 낮음, 인니어 버전 문구는 "[OK]/[Cancel]"로 브라우저 로케일과 불일치. 추천: `$impeccable clarify`(모달화는 `$impeccable harden`). 공유: 아니오.

### P3
7. **t() 밖 한국어 하드코딩** — `:72, 82, 118, 128, 169, 199, 206`, 힌트 placeholder `:376`. 인니어 사용자에게 한국어 노출(이중언어 원칙). 추천: `$impeccable clarify`. 공유: 아니오.
8. **상태 변경 시 포커스·aria-live 안내 없음** — `:284-285`(로딩/오류), 저장 후 폼 닫힘(165). 스크린리더는 결과를 toast(vue-sonner)에만 의존. 로딩/오류 영역에 `role="status"`/`role="alert"` 부재. 추천: `$impeccable harden`. 공유: 아니오.

## 패턴·구조 이슈
- 표 스크롤 처리가 화면 내 비일관(2/3). 공통 `.table-scroll`를 전역 유틸로 올리는 편이 안전(공유 변경이므로 담당 조율 필요).
- 탭 UI는 로컬 스타일(`.tabs`)이라 다른 CSR 화면과 중복 가능성. 확인 후 공통화 여부 판단.

## 긍정
- 토큰 100% 사용(`--asm-radius-md`, `--asm-fg-muted`, `--asm-primary-10` 등), 탭 role/aria-controls/labelledby 연결, 폼 `label` 래핑·`autocomplete`·`name` 지정, 본인 행 삭제 비활성, 모바일 패딩 축소 미디어쿼리(656행), 역할 가드와 DB 정책 분리 설명.

## 권장 실행 순서
1. [P1] `$impeccable adapt` — 사용자 표 스크롤 래퍼 + 행 버튼 터치 타깃
2. [P1] `$impeccable harden` — 탭 roving tabindex/화살표, 비밀번호 표시 토글, 상태 영역 aria-live, confirm 대체
3. [P2] `$impeccable clarify` — 하드코딩 문자열 t() 이관, 확인 문구
4. [P2] `$impeccable polish` — 탭 포커스 링(전역 CSS 공유 변경 시 별도 조율), 마무리
