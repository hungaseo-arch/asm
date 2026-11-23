# Impeccable Audit — docs 영역 (읽기 전용 진단)

대상: `src/modules/csr/views/CsrCoreDocsPage.vue` · `CsrFlowPage.vue` · `CsrStatusGuidePage.vue`
기준: PRODUCT.md / DESIGN.md (The Ledger Desk) · 모드: Operate(Core Docs, Flow) / Read(Status Guide)
detector 결과: 어드바이저리 3건(폰트 크기 off-ramp). 코드는 수정하지 않았다.

## 점수: 13 / 20 — Acceptable (상당한 보완 필요)

| # | 차원 | 점수 | 핵심 |
|---|------|------|------|
| 1 | Accessibility | 2 | 좁은 화면 칩에 접근 가능한 이름 없음, tablist ARIA 불완전, 스크롤 영역 키보드 불가 |
| 2 | Performance | 3 | iframe 3종뿐, 무거운 애니메이션 없음. 측정 재시도 타이머 정리 누락 |
| 3 | Theming | 3 | 토큰 사용 양호. raw `#fff` 2건, 9999px pill, 성공색 오용 |
| 4 | Responsive | 2 | Flow 는 축소 시 글씨 판독 불가, 터치 타깃 약 28px, 가이드 본문 줄 길이 무제한 |
| 5 | Implementation Integrity | 3 | 토큰·이중언어 구조 일관. 가이드 본문이 작업지시서 원문 그대로라 사용자 문서로는 부적합 |
| | **합계** | **13/20** | **Acceptable** |

P0 0 · P1 3 · P2 8 · P3 5

## Implementation Integrity 판정: 조건부 통과
- 색은 `--asm-*` 토큰만 사용하고 카드·그림자 규칙을 지킨다. 그림자는 focus ring 한 곳뿐이다. 언어 쌍 `t([ko,id])` 패턴과 `tabular` 규칙 의존도도 일관된다.
- 어긋나는 곳: raw `#fff` 2건(Core L279, Flow L338), 9999px pill(Flow L317), 성공 초록을 「활성 토글」에 사용(Flow L305-310), 임의 폰트 크기 11·15·12.5px.

## 발견 사항

### P1 (WCAG AA 위반 · 과업 곤란)

**[P1] 좁은 화면에서 문서 칩의 이름이 사라짐** — 공유: 아니오
- 위치: `CsrCoreDocsPage.vue:295-297` (`.side-title{display:none}`), 버튼 L79-90
- 문제: 991px 이하에서 제목 span 이 `display:none` 이라 버튼 접근 이름과 화면 표시가 `DOC-01` 번호뿐이다. 스크린리더와 모바일 사용자는 어떤 문서인지 알 수 없다. WCAG 2.4.6, 4.1.2.
- 추천: `$impeccable adapt` (aria-label/title 추가, 칩에 짧은 제목 표시)

**[P1] 도면 탭의 ARIA 탭 패턴이 불완전함** — 공유: 아니오
- 위치: `CsrFlowPage.vue:158-171`
- 문제: `role=tablist/tab` 만 있고 `tabpanel`, `aria-controls`, 방향키 이동, roving tabindex 가 없다. 보조기기가 탭으로 안내하지만 동작은 일반 버튼이라 오히려 오해를 준다. `.tab` 에는 `:focus-visible` 도 없다(L269-277). WCAG 4.1.2, 2.4.7.
- 추천: `$impeccable harden` (탭 패턴을 완성하거나 role 을 제거하고 `aria-pressed` 버튼 그룹으로 전환)

**[P1] 확대한 도면 영역이 키보드로 스크롤되지 않음** — 공유: 아니오
- 위치: `CsrFlowPage.vue:211, 326-329` (`.stage{overflow:auto}`, `tabindex` 없음)
- 문제: 100% 배율에서 도면은 2600px 로 가로 스크롤이 필수인데, 스크롤 컨테이너가 포커스를 받지 못한다. iframe 내부로 포커스를 옮기기 전에는 키보드 사용자가 도면을 볼 수 없다. WCAG 2.1.1.
- 추천: `$impeccable harden` (`tabindex="0"` + `role="region"` + aria-label, 또는 iframe 에 포커스 이동 안내)

### P2

**[P2] Flow 축소 시 도면 글씨가 판독 불가, 좁은 폭에서 사실상 사용 불능** — 공유: 아니오
- 위치: `CsrFlowPage.vue:67-72, 211-229`
- 문제: 폭 2600px 도면을 1000px 안팎 컨테이너에 맞추면 약 38%, 320px 에서는 10% 안팎이다. 본문 안내(L232-239)가 한계를 인정하고 있다. 가로 100% 스크롤 시 줌이 `0.25` 하한(L122)에 걸린다.
- 추천: `$impeccable adapt` (모바일은 새 창 열기를 기본 동선으로, 최소 배율·ResizeObserver 적용)

**[P2] 줌 컨트롤의 상태·이름이 보조기기에 전달되지 않음** — 공유: 아니오
- 위치: `CsrFlowPage.vue:172-206`
- 문제: 「화면 맞춤」 「100%」 토글에 `aria-pressed` 가 없고, 배율 값(`zoom-now`)에 `aria-live` 가 없다. 「−」 「＋」 는 전각 문자라 이름은 aria-label 로 해결되지만 포커스 링은 없다. 버튼 높이 약 28px 라 AA(24px)는 통과하나 44px 권장에는 못 미친다.
- 추천: `$impeccable harden`

**[P2] 포커스 표시 누락(사이드 항목)** — 공유: 확인 필요(전역 `.btn:focus-visible` 은 L272 에 있으나 비-`.btn` 버튼에는 적용되지 않음)
- 위치: `CsrCoreDocsPage.vue:226-246` (`.side-item`), Flow `.tab` `.zoom-btn`(L269, L288)
- 문제: `.card-doc` 만 `:focus-visible` 이 있고 나머지 커스텀 버튼은 UA 기본에 의존한다. DESIGN 의 focus ring(`0 0 0 3px primary-40`)과 불일치.
- 추천: `$impeccable polish` — 공유 CSS 에 공통 규칙을 두는 방식이 유리하다

**[P2] 카드가 `<button>` + `router.push` 로 이동** — 공유: 아니오
- 위치: `CsrCoreDocsPage.vue:56-68, 79-90`
- 문제: 페이지 이동인데 링크가 아니라 새 탭 열기, 우클릭 복사, 링크 목록 탐색이 불가하다. `aria-current` 도 버튼에 붙어 있다.
- 추천: `$impeccable harden` (`router-link` 로 교체)

**[P2] 활성 줌 버튼에 성공(초록) 색 사용 + 9999px pill** — 공유: 아니오 (규칙 위반)
- 위치: `CsrFlowPage.vue:305-310` (`--asm-success*`), `:317` (`border-radius: 9999px`)
- 문제: DESIGN 의 「Triple Status」 에서 초록은 성공 상태 전용이고, 「Don't 9999px 알약(역할 pill 외)」 규칙에 어긋난다. 탭 활성은 primary 인데 줌 활성은 초록이라 같은 화면 안에서 활성 표현이 둘이다.
- 추천: `$impeccable colorize` (활성=primary-10/primary 로 통일), 모서리는 `var(--asm-radius-md)`

**[P2] 모국어 `lang` 속성 없음** — 공유: 예(전역 레이아웃 · useCsrLang 영향)
- 위치: `CsrStatusGuidePage.vue:231-326` 외 3개 페이지 전체
- 문제: 토글로 인도네시아어 본문이 나와도 요소 `lang` 이 바뀌지 않는다(`useCsrLang.js` 에서 `documentElement.lang` 설정 흔적 없음). 스크린리더 발음 오류. WCAG 3.1.1/3.1.2.
- 추천: `$impeccable harden` (공유 composable 또는 DefaultLayout 한 곳에서 처리)

**[P2] 가이드 본문 줄 길이 무제한 · 표 스크롤 영역 포커스 불가** — 공유: 아니오
- 위치: `CsrStatusGuidePage.vue:342-346` (`.doc` max-width 없음), `:374-376` (`.table-scroll`)
- 문제: Read 모드인데 데스크톱 전폭(100자 이상)으로 흐른다. `.table-scroll` 도 `tabindex` 가 없다.
- 추천: `$impeccable layout` (본문 `max-width: ~72ch`), 스크롤 영역은 harden

**[P2] 가이드가 「작업지시서」 원문 그대로 — 사용자 문서로는 부적합** — 공유: 아니오
- 위치: `CsrStatusGuidePage.vue:26-228`
- 문제: 「목업 사이트」 「스크린샷 첨부하여 보고」 「60건 전부 신규 코드」 같은 구현 지시·완료 기준이 일반 사용자에게 노출된다. 시점이 지난 수치(60건)는 오해 소지가 있다.
- 추천: `$impeccable clarify` 또는 `$impeccable distill` (§1·§3·전환 규칙만 남기는 안)

### P3

- **[P3] raw HEX `#fff`** — `CsrCoreDocsPage.vue:279`, `CsrFlowPage.vue:338`. No-Raw-Hex 규칙. iframe 바탕이라 `var(--asm-card)` 로 교체. `$impeccable polish` · 공유: 아니오(토큰 이미 존재)
- **[P3] 폰트 크기 off-ramp** — Core L149(11px)·L191(15px), Guide L351(15px)·L369(12.5px). detector 어드바이저리. DESIGN 타이포 단계로 정렬하거나 단계를 추가. `$impeccable typeset` · 공유: 단계 추가 시 DESIGN.md/asm-theme.css 공유
- **[P3] 임의 모서리 6px 리터럴** — `CsrFlowPage.vue:273, 291`. `--asm-radius-md` 로. `$impeccable polish` · 공유: 아니오
- **[P3] `measure` 재시도 `setTimeout` 이 언마운트 후에도 남음, `resize` 무디바운스** — `CsrFlowPage.vue:111, 133`. 영향은 미미. `$impeccable optimize` · 공유: 아니오
- **[P3] 코드 인라인 4회 복붙** — `CsrStatusGuidePage.vue:259-262, 271-274, 288-291, 314-317` 동일 템플릿. 하위 컴포넌트로 추출. `$impeccable distill` · 공유: 아니오. 또한 `<code>` 가 Bootstrap 기본 mono 스택이라 DESIGN 의 「mono 서체 추가 금지」와 충돌 소지가 있어 확인 필요

## 패턴 · 시스템 이슈
- 커스텀 `<button>` 4종 이상에서 포커스 링 누락 → 공유 CSS 에 `button:focus-visible` 공통 규칙 필요(공유 자원).
- 스크롤 컨테이너 3곳(`.stage`, `.table-scroll`, 칩 줄 `.side`)에 키보드 접근 없음.
- 언어 토글이 `lang` 속성에 반영되지 않음(공유).

## 잘된 점
- 모든 색이 토큰 기반, 카드는 평평하고 그림자는 focus 에만 사용.
- `aria-current`, `aria-label`(nav, 줌 아이콘 버튼), iframe `title`, `rel="noopener"` 적용.
- PDF 가 모바일에서 안 뜨는 경우를 대비한 「새 창·내려받기」 상시 제공.
- sticky 사이드가 `--asm-header-offset` 을 참조해 헤더 아래에 정확히 멈춤.
- Flow 의 `?v=__BUILD_ID__` 캐시 무효화, 도면 크기 측정 실패 대비 폴백.

## 권장 실행 순서
1. [P1] `$impeccable harden` — Flow 탭·스크롤 영역·줌 컨트롤, Core 칩 이름, `lang` 속성
2. [P1] `$impeccable adapt` — Core 좁은 화면 칩, Flow 모바일 동선
3. [P2] `$impeccable colorize` — 줌 활성 색·pill 정리
4. [P2] `$impeccable layout` — 가이드 본문 max-width
5. [P2] `$impeccable clarify` / `distill` — 가이드 내용 정리
6. [P3] `$impeccable typeset` — 폰트 단계
7. 마무리 `$impeccable polish`
