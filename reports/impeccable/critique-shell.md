# impeccable critique — shell 영역

**총점 26/40 (Acceptable, 65%)** · P0 0 · P1 3 · P2 11 · P3 10
Method: ⚠️ DEGRADED: single-context (delegated read-only run). 소스 정독 기반, 렌더 캡처·detector 미실행(읽기 전용 위임). 반응형 항목은 코드 추정이며 렌더 검증 필요.
Mode: Operate (사내 업무 도구). 근거: PRODUCT.md, DESIGN.md.
대상: AppTopbar.vue, DefaultLayout.vue, NotFoundPage.vue, CsrSignIn.vue, CsrPasswordDialog.vue, CsrLangToggle.vue, asm-theme.css

## 한 줄 총평
토큰·1px 테두리·블루 단일 액센트·3단 모서리·포커스 링 등 DESIGN.md 시각 규칙은 셸 전반에서 충실하게 지켜진다. 약점은 시각이 아니라 (1) 「두 언어는 동등」 원칙이 aria·404·서버 오류·고정 문구에서 샌다는 점, (2) 로그아웃 상태 진입점과 키보드 메뉴 처리, (3) 브랜드 문구(푸터) 불일치다.

## Nielsen 10 휴리스틱

| # | 항목 | 점수 | 핵심 |
|---|------|------|------|
| 1 | 시스템 상태 가시성 | 3 | 활성 메뉴·aria-current·busy 문구 양호. 로그아웃 상태 표시가 흐림 |
| 2 | 현실 일치 | 2 | 404·aria·고정 제목·서버 오류가 한국어/영어 단일 |
| 3 | 사용자 통제 | 3 | Esc·바깥 클릭·스크림 닫기 있음. 포커스 복귀 없음 |
| 4 | 일관성·표준 | 3 | 토큰 일관. 폰트 굵기 600, 11px, 999px 일탈 |
| 5 | 오류 예방 | 3 | 비밀번호 8자·불일치 안내 있음 |
| 6 | 인식 우선 | 3 | 라벨 명확. 국기만으로 언어 표시 |
| 7 | 유연성·효율 | 2 | 드롭다운 키보드 이동 없음, 포커스 이동 없음 |
| 8 | 미니멀 | 3 | 헤더 정돈. 죽은 CSS·낡은 주석 잔존 |
| 9 | 오류 복구 | 2 | 실패 시 입력 3칸 전부 삭제, 서버 원문 오류 |
| 10 | 도움말 | 2 | 404 복귀 경로 1개, 로그인 실패 후 안내 없음 |
| **합계** | | **26/40** | **Acceptable** |

## 디자인 특이성 판정
ASCENDO BI 규정을 그대로 옮긴 사내 도구 특유의 절제가 있고, 다른 제품이 그대로 쓰기 어려운 요소(국기 토글, 3열 중앙 메뉴, 이중언어 라벨)가 있어 범용 템플릿은 아니다. 다만 404와 로그인은 DESIGN.md가 지정한 심볼 모티프를 일부만 활용한다(로그인에는 없음).

## 잘 된 점
- 헤더 3열 그리드와 구간별 축소(992px 제목, 768px 글자, 640px 심볼 로고 교체)가 겹침을 원인 단위로 해결했다(AppTopbar.vue:310-342, 404-412, 535-542, asm-theme.css:582-593).
- 로고 비율·무효과 규정(BS 07)과 hover 신호 분리가 정확하다(AppTopbar.vue:274-292).
- 스킵 링크, `aria-pressed` 국기 토글, `role=dialog aria-modal aria-labelledby`, `role=alert` 오류 등 기본 접근성 뼈대가 있다.

## 항목

### P1

**[P1-1] 푸터 문구가 브랜드 규정과 다름**
- 위치: src/layouts/DefaultLayout.vue:16-18 (asm-theme.css:602-605 주석, DESIGN.md Layout·PRODUCT.md Brand Commitments)
- 문제: 화면에는 `Copyright © ASEOA`, 규정·CSS 주석은 「© PT ASCENDO INTERNASIONAL」. 가이드 주석(DefaultLayout:16)도 이미 「Copyright © ASEOA」로 적혀 있어 규정과 구현이 어긋난 채 굳었다.
- 추천: `/impeccable clarify` (필요 시 `/impeccable polish`)
- 공유 여부: 비공유 (DefaultLayout 단일, 단 모든 화면에 노출)

**[P1-2] 404 화면이 한국어 단일**
- 위치: src/views/NotFoundPage.vue:14-17
- 문제: 「요청하신 페이지를 찾을 수 없습니다.」, 「CSR 목록으로 이동」이 한국어뿐. 인도네시아 사용자가 오래된 링크로 들어오면 읽을 수 없다. 원칙 1 위반. 버튼 문구는 목적지(`/`)와 「CSR 목록」도 일치하는지 확인 필요. 헤더·언어 토글이 없는 화면이라 스스로 언어를 바꿀 수도 없다.
- 추천: `/impeccable clarify`, `/impeccable harden` (identity.lang 기반 ko/id 병기, 전환 수단 확보)
- 공유 여부: 비공유

**[P1-3] 로그아웃 상태 진입점이 비활성처럼 보이고 AA 미달**
- 위치: src/layouts/AppTopbar.vue:514-518 (+ :25-28, :196-208)
- 문제: 자리표시자 상태(`로그인/Masuk`)에 `opacity: 0.55`를 적용. #333 글자가 약 3:1 안팎으로 떨어져 PRODUCT.md 「AA 4.5:1」 기준에 못 미치고, 유일한 로그인 진입 버튼이 disabled로 읽힌다. 480px 미만(md 미만)에서는 이름이 숨겨져 아바타 이니셜 하나만 남는다.
- 추천: `/impeccable audit`, `/impeccable clarify` (흐림 대신 `.btn-sm` 아웃라인 「로그인 / Masuk」 등 명시적 CTA)
- 공유 여부: 비공유 (단 `.asm-pill.is-placeholder`는 같은 파일 내)

### P2

**[P2-1] 로그인 실패 사유가 서버 원문 그대로, 이중언어 아님**
- 위치: src/modules/csr/components/CsrSignIn.vue:70-71 (주석은 의도적임을 밝힘)
- 문제: 원인 파악을 위해 원문을 쓴 선택은 이해되나, 현지 사용자에게는 영어 원문만 노출될 가능성. 오류 사유 아래에 ko/id 고정 안내(「이메일·비밀번호를 확인하십시오 / Periksa email dan kata sandi」)를 병기하면 둘 다 만족한다.
- 추천: `/impeccable clarify`
- 공유 여부: 비공유

**[P2-2] 비밀번호 변경 실패 시 3개 입력을 모두 지움**
- 위치: src/modules/csr/components/CsrPasswordDialog.vue:48-56 (`finally` 블록)
- 문제: 현재 비밀번호를 오타 냈을 뿐인데 새 비밀번호·확인까지 다시 입력해야 한다. 성공일 때만 비우면 된다. 현지 환경에서 불편이 크다.
- 추천: `/impeccable harden`
- 공유 여부: 비공유

**[P2-3] 비밀번호 변경 오류 문구가 단일 언어/원문**
- 위치: CsrPasswordDialog.vue:44-46, :49-50 (`e.message`)
- 문제: 네트워크 예외 등은 영어 원문 노출. 같은 맥락에서 인도네시아어 라벨 「Konfirmasi」(:116)는 「새 비밀번호 확인」과 대응이 약해 무엇을 확인하는지 모호(`Konfirmasi kata sandi baru` 권장). 제목 「Ubah Kata Sandi」(:71)와 메뉴 「Ubah kata sandi」(AppTopbar.vue:227) 대소문자 불일치.
- 추천: `/impeccable clarify`
- 공유 여부: 비공유

**[P2-4] 모달 포커스 관리 부재 추정**
- 위치: CsrPasswordDialog.vue:62-70 (useBodyScrollLock·useEscapeToClose만 사용)
- 문제: 열릴 때 첫 입력으로 포커스 이동, Tab 순환 가둠, 닫을 때 트리거 복귀가 코드에 없다. 해당 composable에 있는지 미확인. 스크림이 `button`이라 Tab 순서에 끼어 있다(:63-68, `tabindex="-1"` 필요).
- 추천: `/impeccable harden`
- 공유 여부: 비공유 (단 composable 위치가 공유 자원이면 거기서 처리)

**[P2-5] 드롭다운 `role=menu`인데 키보드 규약 없음**
- 위치: AppTopbar.vue:150, :211 (`role="menu"`, `menuitem`), :59-64
- 문제: 열었을 때 첫 항목으로 포커스 이동, 방향키 이동, Esc 후 트리거 복귀가 없다. 스크린리더는 메뉴 모드로 진입해 혼란. 규약을 구현하지 않을 거면 `role`을 빼고 일반 disclosure 패턴으로 두는 편이 낫다. `.dropdown-item:focus`는 배경만 바뀌고 포커스 링이 없다(asm-theme.css:686-689).
- 추천: `/impeccable harden`
- 공유 여부: `.dropdown-item` 포커스 링은 공유 (asm-theme.css), 메뉴 동작은 비공유

**[P2-6] aria·고정 문구의 이중언어 누락**
- 위치: AppTopbar.vue:105 (`aria-label="CSR 대시보드로"`), :134 (`aria-label="Primary"`), :125 (`ASM CSR관리` 고정), DefaultLayout.vue:8 (「본문 바로가기」)
- 문제: 화면 라벨은 ko/id 전환되는데 보조기술 문구와 모듈명은 한 언어로 고정. 툴팁 :107은 「CSR 대시보드 (Dasbor)」로 병기해 이미 선례가 있어 일관성도 흔들린다.
- 추천: `/impeccable clarify`
- 공유 여부: 비공유

**[P2-7] 언어 토글 터치/클릭 영역이 규정(36px) 미만**
- 위치: CsrLangToggle.vue:74-94 (`padding:3px` + 16px 국기 높이 ≈ 24px)
- 문제: DESIGN.md 「컨트롤 높이 36px 이상(Small 30px)」보다 작다. 헤더 내 다른 컨트롤(36px)과도 높이가 맞지 않아 눈에 띄게 작다. 간격 4px라 오터치 위험.
- 추천: `/impeccable layout`, `/impeccable adapt`
- 공유 여부: 비공유

**[P2-8] 언어 상태를 불투명도·테두리로만 전달**
- 위치: CsrLangToggle.vue:81, :95-103
- 문제: 비활성 0.55 / 활성 1.0과 블루 링뿐. PRODUCT 원칙 2(색 아닌 코드·라벨) 취지상 `KO`/`ID` 텍스트 코드나 선택 체크가 없다. 흐린 국기는 대비 기준도 낮다. 한국어 사용자가 인도네시아 국기를 언어로 읽는 것은 그나마 통용되지만, 국기=언어 매핑은 주의 대상.
- 추천: `/impeccable clarify`, `/impeccable polish`
- 공유 여부: 비공유

**[P2-9] 푸터가 화면 하단에 붙지 않고 항상 스크롤 유발**
- 위치: DefaultLayout.vue:27-35 (`.asm-app{min-height:100vh}` + `.asm-shell{min-height:100vh}`)
- 문제: 헤더(60px)가 min-height 계산 밖이라 내용이 짧아도 문서 높이가 100vh+60px가 되어 불필요한 스크롤과 푸터 위치 부유가 생긴다. 모바일 주소창에서는 100vh가 더 어긋난다. `.asm-shell` flex는 사이드바 흔적이라 단일 자식에는 불필요.
- 추천: `/impeccable layout`
- 공유 여부: 비공유

**[P2-10] 320px 폭 헤더 넘침 가능성 (렌더 미검증)**
- 위치: AppTopbar.vue:404-412, :520-542; asm-theme.css:590 (`minmax(max-content,1fr)`)
- 문제: 320px에서 심볼+아이콘 메뉴 3개+국기 2개(24px 컨트롤)+아바타+좌우 패딩 합이 폭을 넘을 수 있다. 열 최소폭이 max-content라 줄어들지 않고 가로 스크롤 가능. PRODUCT 「320px에서 깨지지 않을 것」 요건에 직결. 실제 렌더 확인 필요.
- 추천: `/impeccable adapt`
- 공유 여부: `.menu-header` 그리드는 공유 (asm-theme.css:582-593)

**[P2-11] 전역 `scroll-behavior: smooth`에 reduced-motion 가드 없음**
- 위치: asm-theme.css:187-189 (파일 내 `prefers-reduced-motion` 없음), 전환 0.15s들(AppTopbar:284, 346 등)
- 문제: 앵커·스킵 링크 이동이 부드럽게 스크롤되어 모션 민감 사용자에게 불리하다. 업무 도구 특성상 효과도 작다.
- 추천: `/impeccable harden`
- 공유 여부: **공유** (전역 CSS)

### P3

- **[P3-1] 로그인 화면에 심볼 모티프 없음, Large 버튼 규정 미적용** — CsrSignIn.vue:32, :73. DESIGN.md Shapes는 로그인에 모티프, 버튼 가이드는 「로그인·모달 확정 = Large 40px/700」. 제목 「로그인」과 버튼 「로그인」이 중복되어 제목 위계가 약함. 필수 `*` 표시·비밀번호 표시 토글·로그인 중 `aria-busy` 없음. 추천 `/impeccable polish`, `/impeccable onboard`. 비공유
- **[P3-2] 404 일탈 요소** — NotFoundPage.vue:30-35. 54px 제목은 타이포 위계표에 없는 크기이고, 헤더·로고가 없어 어디의 오류인지 모름. `console.error`(:6)는 사용자 영향 없는 개발 로그. 심볼 `::before`는 position absolute라 정적 콘텐츠 위에 칠해진다(asm-theme.css:645-659, z-index/isolation 없음). 6%라 시각 영향은 미미. 추천 `/impeccable polish`. 모티프 stacking은 **공유** (asm-theme.css), 나머지 비공유
- **[P3-3] 굵기 600·11px·999px 일탈** — AppTopbar.vue:305 (600), :390 (600), :396 (999px), :399-400 (11px/600), DefaultLayout.vue:48 (600). DESIGN.md Weight Ladder(700/500/400)와 「알약형은 역할 pill 한정」 위반. `.nav-badge`는 모서리 4px로. 추천 `/impeccable typeset`. 비공유
- **[P3-4] 컴포넌트 내 HEX/RGB 직접 기입** — CsrLangToggle.vue:27-28, :47-62 (국기 색), :92 (`rgb(0 0 0 / .12)`). 국기 색은 규정 예외로 보이나 No-Raw-Hex 규칙에 예외 명문화 필요. 추천 `/impeccable document`. 비공유
- **[P3-5] 죽은 CSS와 낡은 주석** — AppTopbar.vue:428-431 (`.asm-icon-btn` 종 아이콘 점), :452-454 (`.profile:disabled`), :17-18, :240, :294-298, :316-322 주석의 `auto 1fr auto`·14px/500·1×24px 등이 현재 구현(1fr, 13px)과 불일치. asm-theme.css:703-706 섹션 제목 주석이 엉뚱한 위치. 추천 `/impeccable distill`. 비공유
- **[P3-6] `--asm-danger-hover` 토큰 없음, `#b22424` 직접 기입** — asm-theme.css:316-317, :287 (`focus-shadow-rgb` 숫자 직접). DESIGN.md 토큰 표에는 danger-hover가 있음. 추천 `/impeccable extract`. **공유**
- **[P3-7] `--bs-*` 블록이 HEX 복제** — asm-theme.css:137-165. `--asm-*`와 동기화 주석(:145)에 의존. `var(--asm-*)` 참조로 한 곳에서 관리하면 드리프트가 없다. 추천 `/impeccable extract`. **공유**
- **[P3-8] 토큰 별칭 난립** — asm-theme.css:21-56 (`--asm-bg`/`page-bg`, `primary-5`/`6`, `accent`/`primary-soft`/`primary-10`, `muted-30`이 실제로는 파랑 6% 등). 이름과 값 불일치로 오사용 위험. DESIGN.md 토큰 표와 이름 정렬 필요. 추천 `/impeccable extract`, `/impeccable document`. **공유**
- **[P3-9] 차트 주황 `#e08a00`이 DESIGN 팔레트 밖** — asm-theme.css:100. DESIGN.md에 chart 토큰 설명 없음. Orange(REJECTED 전용)와 혼동 여지. 추천 `/impeccable document`. **공유**
- **[P3-10] 버튼 변종 이름 혼선** — asm-theme.css:289-311. `.btn-secondary`는 블루 틴트인데 `--asm-secondary`는 회색, `btn-outline-primary`와 `btn-outline-secondary`가 동일 정의. 사용처 혼란 가능. 추천 `/impeccable document`. **공유**

## 페르소나 점검

**현업 인도네시아 사용자** — 404 화면에서 한국어만 보고 막힘(P1-2). 로그인 실패 시 영어 원문(P2-1), 비밀번호 변경 실패 시 영어 오류 후 3칸 재입력(P2-2, P2-3). 320px 노트북이 아닌 소형 기기 가정 시 헤더 넘침(P2-10).
**IT 부서 파워유저** — 헤더 메뉴는 링크라 새 탭이 되지만 드롭다운은 방향키·포커스 이동이 없어 키보드로 느림(P2-5). 언어 토글 높이가 작아 클릭이 번거로움(P2-7).
**admin(서종환)** — 푸터 브랜드 문구 불일치가 가장 먼저 눈에 띔(P1-1). 관리 메뉴는 계정 메뉴 안에 숨어 있어 발견성이 낮다(AppTopbar.vue:217-225, admin 전용이라 감수 가능).
**보조기술 사용자** — aria 문구 단일 언어(P2-6), `role=menu` 무규약(P2-5), 모달 포커스(P2-4), 흐린 로그인 버튼(P1-3).

## 공유 자원 요약 (수정 시 영향 범위 큼)
asm-theme.css 관련: P2-5(포커스 링), P2-10(헤더 그리드), P2-11, P3-2(모티프), P3-6, P3-7, P3-8, P3-9, P3-10. 나머지는 해당 파일 단독 수정 가능.

## 권장 실행 순서
1. `/impeccable clarify` — P1-1, P1-2, P2-1, P2-3, P2-6 (문구·이중언어)
2. `/impeccable audit` + `/impeccable harden` — P1-3, P2-2, P2-4, P2-5, P2-11
3. `/impeccable layout` / `/impeccable adapt` — P2-7, P2-9, P2-10 (반드시 렌더 확인)
4. `/impeccable extract` / `document` — P3-6~P3-10 (asm-theme.css 단독 담당 필요, 병렬 수정 금지)
5. `/impeccable polish` — 마감

Questions skipped: delegated run
