# Impeccable Audit - shell 영역

- 대상: AppTopbar.vue, DefaultLayout.vue, NotFoundPage.vue, CsrSignIn.vue, CsrPasswordDialog.vue, CsrLangToggle.vue, asm-theme.css
- 방식: 코드 정독 + `impeccable detect`(정규식 엔진, 광고성 안내 5건만, 반입 0건). 렌더 측정은 하지 않음 (아래 P1-3 은 계산 추정)
- 수정 없음 (읽기 전용 진단)

## 점수: 13 / 20 - Acceptable (상당한 보완 필요)

| # | 차원 | 점수 | 핵심 |
|---|------|------|------|
| 1 | 접근성 | 2 | 비밀번호 모달 포커스 관리 없음, 색만으로 상태 전달, 드롭다운 키보드 탐색 없음 |
| 2 | 성능 | 3 | 가볍다. 로고 43KB, 심볼 3.8KB, 외부 자원 없음. 항상 생기는 세로 스크롤만 문제 |
| 3 | 테마 | 3 | 토큰 체계 양호. 소수 HEX 직기입 + 토큰 중복 |
| 4 | 반응형 | 2 | 320px 에서 헤더 폭 초과 추정, 소형 터치 타깃 |
| 5 | 구현 무결성 | 3 | 가이드 정합성 높음. 푸터 문구 불일치, 600 굵기 이탈 |
| | **합계** | **13/20** | **Acceptable** |

## 구현 무결성 판정: Pass (조건부)
ASCENDO BI 토큰(`--asm-*`)을 일관되게 쓰고, 그림자 없음·3단 모서리·3px 포커스 링·스킵 링크·aria-pressed 등 의도가 분명하다. 이탈은 (a) 푸터 문구, (b) weight 600, (c) 일부 HEX 로 한정된다.

## 요약
P0 0 · P1 3 · P2 9 · P3 5. 상위 이슈: 비밀번호 모달 포커스 트랩 부재, 힌트 상태가 색만으로 바뀜, 320px 헤더 폭.

## 상세 (항목: P등급 / 파일:라인 / 문제 / 추천 명령 / 공유 여부)

### P1

1. **P1 비밀번호 모달에 포커스 관리 없음** - `CsrPasswordDialog.vue:62-70`
   `aria-modal="true"` 인데 열릴 때 초기 포커스 이동, Tab 순환 가둠(트랩), 닫을 때 호출 버튼으로 복귀가 없다. 키보드 사용자는 스크림 뒤 페이지로 Tab 이 빠져나간다. 완료 상태(`done`, 73-85)로 바뀔 때도 포커스가 사라진 요소에 남는다. WCAG 2.4.3 / 2.1.2 계열, ARIA 대화상자 패턴.
   추천: `$impeccable harden` / 공유 composable 신설이라면 `$impeccable extract`. 비공유(단 `useEscapeToClose` 류 composable 에 넣으면 다른 모달도 이득).

2. **P1 입력 힌트 상태가 색만으로 전달** - `CsrPasswordDialog.vue:112, 174-182`
   「8자 이상」 글자는 짧을 때 문구 변화 없이 warning 색으로만 바뀐다. 입력창에도 `aria-invalid`/`aria-describedby` 가 없다. PRODUCT 원칙 2, WCAG 1.4.1. `mismatch`(125)는 문구가 있어 양호.
   추천: `$impeccable clarify` + `$impeccable harden`. 비공유.

3. **P1 320px 에서 헤더 폭 초과 가능성 (렌더 미검증, 계산 추정)** - `AppTopbar.vue:181, 419-431, 520-531, 535-542` / `asm-theme.css:590`
   3열 그리드의 좌우 열이 `minmax(max-content, 1fr)`. 320px, CSR 화면 기준 대략: 좌측(심볼 28 + 패딩 24 + 버튼 패딩 16, 약 70) + 가운데 아이콘 메뉴 3개(약 110) + 우측(패딩 32 + 국기 2개 약 68 + `me-1` 4 + 아바타 버튼 약 44 + gap)이 약 340px 이상이라 가로 넘침 위험. PRODUCT 「320px 에서 깨지지 않게」 위반 가능. 실제 폭은 브라우저로 확인 필요.
   추천: `$impeccable adapt`. 비공유 (단 3열 그리드 규칙 자체는 `asm-theme.css:590` 이라 수정 시 공유 영향 확인).

### P2

4. **P2 `scroll-behavior: smooth` 에 reduced-motion 가드 없음** - `asm-theme.css:187-189` (src 전체에 `prefers-reduced-motion` 미사용). 전환(0.15s)은 소규모라 무방하나 smooth 스크롤은 전정 민감 사용자에 영향. 추천 `$impeccable animate`. **공유(전역 CSS)**.

5. **P2 헤더 드롭다운 키보드 탐색 불완전** - `AppTopbar.vue:137-163, 211-232`
   `role="menu"/menuitem` 을 선언했으나 화살표키 이동·열릴 때 포커스 이동·Esc 후 트리거 복귀·포커스 이탈 시 닫힘이 없다. 선언한 ARIA 패턴과 동작 불일치(`role` 을 쓰지 않거나 완전히 구현). 추천 `$impeccable harden`. 비공유.

6. **P2 자리표시자 상태의 opacity 0.55 로 대비 미달** - `AppTopbar.vue:515-518`
   `#333` 글자가 0.55 불투명으로 약 3:1 수준(추정)이라 AA 미달. 게다가 이 버튼은 클릭하면 `/csr/dashboard`(로그인)로 가는 실제 조작 요소(25-28). 추천 `$impeccable colorize` (또는 `polish`). 비공유.

7. **P2 weight 600 사용 - Weight Ladder(700/500/400) 이탈** - `AppTopbar.vue:305, 390, 400` / `DefaultLayout.vue:48`
   특히 `AppTopbar.vue:390` 은 전역 규칙 `asm-theme.css:694`(active = 700)를 덮어써 드롭다운 active 굵기가 두 곳에서 다르다. 추천 `$impeccable typeset`. 비공유.

8. **P2 푸터 문구가 DESIGN/PRODUCT 와 불일치** - `DefaultLayout.vue:18`
   「Copyright © ASEOA」 ↔ DESIGN 레이아웃 절·`asm-theme.css:603-605` 주석의 「© PT ASCENDO INTERNASIONAL」, PRODUCT 「회사명 표기는 PT ASCENDO INTERNASIONAL」. 어느 쪽이 정답인지 사용자 결정 필요(확인 없이 바꾸지 말 것). 추천 `$impeccable clarify`. 비공유(전 화면 노출).

9. **P2 본문이 항상 세로 스크롤을 만듦** - `DefaultLayout.vue:27-35`
   `.asm-app{min-height:100vh}` 안에 액센트 바 4px + 헤더 56px 이 있고, 그 아래 `.asm-shell{min-height:100vh}` 가 또 100vh 라 내용이 짧아도 총 높이 100vh+60px. 푸터도 화면 아래로 밀림. 추천 `$impeccable layout` (shell 의 min-height 를 제거하거나 flex column). 비공유.

10. **P2 404 화면이 한국어 단일** - `NotFoundPage.vue:14-17`
    제목·버튼 모두 한국어만이고 언어 토글도 없다(레이아웃 밖). PRODUCT 원칙 1(두 언어 동등) 위반. 인니 사용자 대상 화면. 추천 `$impeccable clarify`. 비공유.

11. **P2 비밀번호 변경 실패 시 3개 입력값을 모두 비움** - `CsrPasswordDialog.vue:52-56`
    `finally` 가 성공·실패 구분 없이 비워, 현재 비밀번호 오입력 한 번에 세 칸을 다시 쳐야 한다. 또한 완료 메시지 `.ok`(74)는 `role="status"` 가 없어 스크린리더에 안 읽힘. 추천 `$impeccable harden`. 비공유.

12. **P2 언어 토글 버튼이 DESIGN 컨트롤 최소(36px)보다 작음** - `CsrLangToggle.vue:74-94`
    약 32x24px(3px 패딩 + 24x16 SVG + 1px 테두리). WCAG 2.5.8 의 24px 최소는 간신히 충족하나 44px 권장·DESIGN 36px 미달. 비활성 국기는 opacity 0.55 라 상태를 불투명도에만 의존(`aria-pressed` 는 있어 보조기기는 양호). 추천 `$impeccable adapt`. 비공유.

### P3

13. **P3 HEX 직기입 `#b22424`** - `asm-theme.css:316-317`. DESIGN 에 `danger-hover` 토큰이 이미 있는데 변수로 안 만들어 둠. 추천 `$impeccable extract`. **공유(토큰)**.

14. **P3 `--bs-*` 변수에 HEX 20여 개 재기입, `--asm-*` 와 이중 관리** - `asm-theme.css:137-169` (코멘트 145 도 「동일하게 유지할 것」). 한쪽만 바꾸면 어긋남. `--asm-primary-5/6`, `--asm-bg/--asm-page-bg`, `--asm-accent/-primary-10` 등 별칭 중복도 정리 대상. 추천 `$impeccable extract`. **공유**.

15. **P3 DESIGN 타입 램프 밖 글자 크기** (detector 확인) - 11px `AppTopbar.vue:399`(nav-badge), 54px `NotFoundPage.vue:31`. 11px 는 최소 12px 원칙 이하. 추천 `$impeccable typeset`. 비공유. (`asm-theme.css:398` 의 1rem 은 모바일 입력 16px 규정이라 의도된 값 - 오탐 성격)

16. **P3 국기 SVG 의 HEX/2px 모서리/rgb 외곽선** - `CsrLangToggle.vue:27-29, 49-62, 90-92`. 국기 색은 규정상 불가피한 예외이므로 DESIGN 에 예외 명시를 권장. `box-shadow` 활성 링(102)은 Flat-At-Rest 의 예외 해석 필요. 추천 `$impeccable document`. **DESIGN.md 갱신이면 공유**.

17. **P3 사소한 접근성 보강** - `CsrSignIn.vue`: 오류문 `aria-describedby` 연결 없음(71), 비밀번호 표시 토글 없음, 페이지에 h1 없이 h2(33). `AppTopbar.vue:106` 로고 버튼 `aria-label` 이 한국어 단일(title 은 이중). `DefaultLayout.vue:8` 스킵 링크도 한국어 단일. `<footer>` 가 `<main>` 안이라 contentinfo 랜드마크가 아님. 추천 `$impeccable harden`. 비공유.

## 시스템 패턴
- 접근성은 입구(스킵 링크, aria-pressed, role=alert, autocomplete)는 잘 갖췄으나 "인터랙티브 위젯의 키보드/포커스 규약"(모달, 메뉴)이 비어 있다.
- 토큰 규율은 높다. 이탈은 `asm-theme.css` 안(HEX 중복)과 국기 같은 정당한 예외에 집중.
- 두 언어 동등 원칙은 `t()` 경유 화면은 지켜지나, 진입부(404, 스킵 링크, 로고 aria-label)에서 새는 경향.

## 잘 된 점
- 색·모서리·그림자 모두 `--asm-*` 변수 참조. 정지 상태 그림자 없음. 3px 포커스 링 통일(`:focus-visible`).
- 스킵 링크 + `main tabindex=-1`, 언어 토글 `aria-pressed`, 오류 `role="alert"`, `autocomplete` 속성, 이미지 `width/height` 명시(CLS 방지).
- 국기를 인라인 SVG 로 그려 Windows 이모지 문제와 외부 요청을 회피(회선 약한 환경 배려).
- 모바일 입력 16px 규정(`asm-theme.css:395-400`), 심볼 모티프는 404 같은 지정 화면에만 사용.

## 권장 순서
1. P1 `$impeccable harden` - 비밀번호 모달 포커스 트랩/복귀, 힌트 상태 문구·aria, 드롭다운 키보드 규약
2. P1 `$impeccable adapt` - 320px 헤더 실측 후 폭 조정, 국기·메뉴 타깃 크기
3. P2 `$impeccable layout` - shell 100vh 중복 제거
4. P2 `$impeccable typeset` - 600 -> 규정 굵기, 11px/54px 정리
5. P2 `$impeccable clarify` - 푸터 회사명 결정(사용자 확인), 404 이중언어
6. P2/P3 `$impeccable extract` - `danger-hover` 토큰, `--bs-*` 이중 관리 정리 (공유 자원이므로 다른 영역 보고서와 충돌 확인 후 일괄)
7. 마무리 `$impeccable polish`

## 공유 자원 항목 요약 (병합 시 조율 필요)
- `asm-theme.css:187-189` (reduced-motion), `:316-317` (danger-hover 토큰), `:137-169` (bs 변수 이중 관리), DESIGN.md 예외 문서화(P3-16)
- 그 외 항목은 shell 영역 파일 내부에서 닫힘
