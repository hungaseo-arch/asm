# Impeccable Critique: docs 영역 (CsrCoreDocsPage / CsrFlowPage / CsrStatusGuidePage)

Method: ⚠️ DEGRADED: single-context (delegated read-only run). 코드 수정 없음, 소스 정독 기반, 라이브 렌더·detector 미실행.
Mode: Read (문서·가이드 열람) + 일부 Operate(뷰어 조작).
기준: PRODUCT.md, DESIGN.md (One Voice · Triple Status · No-Raw-Hex · Tabular · Weight Ladder · Flat-At-Rest), 한/인니 이중언어 동등.

## 총점과 등급

**26/40 — Acceptable (Significant improvements needed)**
P0 0 · P1 3 · P2 9 · P3 6

| # | Heuristic | 점수 | 핵심 |
|---|---|---|---|
| 1 | 시스템 상태 가시성 | 2 | Flow: `ready` 상태가 템플릿에서 안 쓰여 로딩 중 빈 2600x900 박스 |
| 2 | 현실 일치 | 2 | StatusGuide가 사용자 문서가 아닌 개발 작업지시서 문구(Neon, 목업, 스크린샷 첨부) |
| 3 | 사용자 통제 | 3 | 목록/뷰어 복귀 링크, 새 창, 내려받기 양호 |
| 4 | 일관성 | 2 | 세 화면의 헤더 링크·탭·활성색 규칙이 제각각, 초록 활성(Flow) |
| 5 | 오류 예방 | 3 | 없는 문서 번호 처리 있음 |
| 6 | 인식 > 회상 | 2 | 좁은 화면에서 문서 목록이 번호(DOC-01)만 남음 |
| 7 | 유연성·효율 | 3 | 줌, 화면 맞춤, 새 창 |
| 8 | 미니멀 디자인 | 3 | 전반 절제됨, StatusGuide §4~6 과잉 |
| 9 | 오류 복구 | 2 | iframe 로드 실패·PDF 미지원 상태 안내 없음(모바일 버튼으로만 우회) |
| 10 | 도움말·문서 | 4 | 영역 자체가 도움말, 캡션·안내문 충실 |
| | **합계** | **26/40** | Acceptable |

디자인 특이성: 장부 책상 톤(플랫, 블루=행동)은 대체로 지켜지나, 이 영역 3화면이 서로 다른 시기에 만들어져 헤더·탭·활성 표현이 통일되지 않음.

## 항목

### P1

**[P1] 모바일/좁은 화면에서 문서 목록이 번호만 남음**
- 위치: `CsrCoreDocsPage.vue:295-297` (`.side-title {display:none}`), 칩 줄 `:287-294`
- 문제: 992px 미만에서 사이드 목록이 칩으로 바뀌며 제목을 숨겨 「DOC-01 DOC-02 …」 12개만 보임. display:none이라 스크린리더 이름에서도 제목이 빠짐. 번호를 외워야 하는 recall 부담.
- 추천: `impeccable adapt` (칩에 짧은 제목 노출 또는 select 드롭다운), `impeccable harden`(접근성 이름)
- 공유 자원: 없음(스코프 style). 단 `.side-item` 패턴은 표준양식(/csr/forms)도 같은 화면이라 두 라우트에 동시 영향.

**[P1] StatusGuide 본문이 사용자 문서가 아니라 개발 작업지시서 원문**
- 위치: `CsrStatusGuidePage.vue:32-228` (§2 대상 범위, §4 구현 요구사항, §5 제외 사항, §6 완료 기준)
- 문제: 대시보드 링크로 들어온 현업·IT 사용자가 읽고 싶은 것은 「각 상태가 무엇이고 누가 언제 바꾸는가」인데, 화면의 절반 이상이 `mapLegacyVerifyStatus`, Neon 스키마, 「스크린샷 첨부하여 보고」 같은 구현 지시. 핵심(§3 상태 정의 표, 전환 규칙)이 중간에 묻혀 있고 전환 규칙(COMPLETED+ACCEPTED→VERIFIED, REJECTED→ONGOING)은 §4 말미 하위 불릿에 숨음. Read 모드의 첫 질문 「무엇을 이해하게 하는가」에 답하지 못함.
- 추천: `impeccable distill` (§3 + 전환 규칙을 앞으로, §4~6 제거 또는 접기), `impeccable clarify`
- 공유 자원: `CsrStatusDefTable.vue`, `status.js`(IT_STATUS/VERIFY_STATUS)는 읽기만. 본문 상수는 이 파일 전용. 원문 `docs/csr/작업지시서_상태명칭표준화.md`와 동기 규칙이 헤더 주석(`:5-6`)에 있어 같이 고쳐야 함.

**[P1] StatusGuide에 낡거나 모순되는 문구**
- 위치: `:198-199`(「60건」), `:216-217`·`:151-152`(「3개 언어 표시」인데 화면은 한 언어씩), `:145-146`(「COMPLETED AND verifyStatus ≠ … → 실제로는 … 기존 로직 그대로」 자기모순), `:187-188`(「디자인 개편 금지」)
- 문제: 작업 당시 기준값이 화면에 박혀 사실 검증 불가, 필터 정의 문장은 읽어도 의미가 확정되지 않음. 신뢰도를 깎음.
- 추천: `impeccable clarify`
- 공유 자원: 없음

### P2

**[P2] Flow: 활성 줌 버튼이 초록(success)**
- 위치: `CsrFlowPage.vue:305-310` (`.zoom-btn--on`)
- 문제: DESIGN.md One Voice(블루는 구조·행동)와 Triple Status(초록=상태 의미) 위반. 「화면 맞춤」 선택 상태가 성공 상태처럼 보임. 같은 줄의 탭은 info 파랑/primary, 줌 배율 pill은 primary-soft로 3가지 선택 표현이 공존.
- 추천: `impeccable colorize` (선택 상태를 primary-10/primary로 통일), `impeccable polish`
- 공유 자원: 토큰 `--asm-success*`는 공유, 규칙 수정은 이 파일 style만

**[P2] Flow: 도면 본문 영어 안내가 도면 아래 맨 끝**
- 위치: `:232-239`
- 문제: 기본이 100%(`:64`)라 2600px 도면의 좌상단만 보이고 가로 스크롤. 「글씨가 작으면 100%로」 안내는 도면 아래라 못 봄. 첫 화면에서 도면 전체 구조를 파악 불가.
- 추천: `impeccable layout` (안내를 툴바 옆으로, 또는 기본 화면 맞춤 + 가독 힌트), `impeccable clarify`
- 공유 자원: 없음

**[P2] Flow: 로딩/실패 상태 없음 (`ready` 미사용)**
- 위치: `:65, :115, :130`(ready 설정만 하고 `<template>`에서 미참조), `:212-228`
- 문제: 도면 전환 시 측정 전까지 이전 크기의 빈 흰 박스. 도면 파일 404 시에도 무표시.
- 추천: `impeccable harden`, `impeccable animate`(최소 페이드), 
- 공유 자원: `public/csr/flow/*.html`(iframe 원본)은 별개 자원

**[P2] Flow: 탭·토글 접근성 의미 누락**
- 위치: `:158-171`(role=tablist인데 tabpanel/aria-controls/화살표 키 없음), `:190-205`(`fit`/`100%` 토글에 aria-pressed 없음)
- 추천: `impeccable harden`
- 공유 자원: 없음

**[P2] Flow: 줌 버튼 터치/클릭 타깃 작음**
- 위치: `:288-296`(min-width 30px, padding 5px 8px, 12px 글자)
- 추천: `impeccable adapt`
- 공유 자원: 없음

**[P2] No-Raw-Hex: `#fff` 직접 사용**
- 위치: `CsrCoreDocsPage.vue:279`, `CsrFlowPage.vue:338`
- 문제: PDF/도면 시트 배경이라 의도는 이해되나 토큰 규칙 위반. 다크 대응 시에도 시트는 흰색 유지해야 하므로 `--asm-sheet-bg` 같은 의미 토큰이 필요.
- 추천: `impeccable extract` (토큰화), `impeccable polish`
- 공유 자원: 토큰 파일(공유 CSS)에 새 토큰 추가 필요 가능

**[P2] Tabular Rule 누락: 날짜·버전·배율 숫자**
- 위치: `CsrCoreDocsPage.vue:67, 99-102`(`.meta` 버전·기준일), `CsrFlowPage.vue:311-320`(`.zoom-now` %), `CsrStatusGuidePage.vue:198-217`(본문 숫자)
- 추천: `impeccable typeset` (font-variant-numeric: tabular-nums)
- 공유 자원: 전역 유틸 클래스가 있으면 그것 사용(확인 필요)

**[P2] StatusGuide §3-3 색상 설명이 글자뿐**
- 위치: `:93-106, :304-307`
- 문제: 「OPEN 빨강 · ONGOING 파랑…」을 글로만 설명. 실제 상태 배지(글자색·soft 배경·테두리 3종)를 보여 주면 한눈에 해결되고 한/인니 번역 분량도 줄어듦.
- 추천: `impeccable clarify`, `impeccable colorize`
- 공유 자원: 상태 배지 컴포넌트/`CsrStatusDefTable.vue`(공유) 재사용 권장

**[P2] StatusGuide: 긴 한 칼럼 문서에 목차·행 길이 제한 없음**
- 위치: `:342-346`(`.doc` max-width 없음, 14px/1.6), `:350-360`(h3 15px, h4 13px muted)
- 문제: 넓은 모니터에서 줄이 100자 이상, §1~§6 점프 수단 없음. h4(13px muted)가 본문(14px)보다 작아 소제목 위계가 역전된 인상.
- 추천: `impeccable layout`, `impeccable typeset`
- 공유 자원: 없음

### P3

- **[P3] 페이지 제목 언어 불일치**: `CsrFlowPage.vue:142` 「Flow Diagram」, `CsrStatusGuidePage.vue:236` 「Status Guide」는 번역 없이 영어 고정, 핵심문서는 `t(set.title)`로 번역. 이중언어 동등 기준에서 제목 처리 규칙 통일 필요. 추천 `impeccable clarify`. 공유 자원 없음.
- **[P3] 헤더 보조 링크 불일치**: 핵심문서 「← 전체 목록」(`:44-52`, button), Flow 「… ↗」(`:152`, a), StatusGuide 「← 대시보드」/「개선요청 목록」(`:241-248`, 화살표가 한쪽만). 복귀 링크 표현 통일. 추천 `impeccable polish`. 공유 자원: `.head`/`.page-titles`/`.btn-link`는 공유 스타일(각 화면이 `.head`를 따로 복제 정의 `:142`, `:250`, `:335`, 레이아웃 컴포넌트화 후보).
- **[P3] 비토큰 radius·크기**: `CsrFlowPage.vue:273, 292`(6px → `--asm-radius-md`), `:317`(9999px → pill 토큰). 추천 `impeccable extract`.
- **[P3] PDF 뷰어 높이**: `CsrCoreDocsPage.vue:276` `calc(100vh - 220px)`는 고정 헤더 오프셋(`--asm-header-offset`)을 반영하지 않아 헤더 포함 시 세로 스크롤이 이중으로 생길 수 있음. 추천 `impeccable layout`.
- **[P3] 카드 12장 목록에 그룹·검색 없음**: `CsrCoreDocsPage.vue:55-69`. 현재 규모면 허용, 문서 증가 시 분류 필요. 추천 `impeccable shape`.
- **[P3] 캡션 11px**: `CsrCoreDocsPage.vue:148-153`(`.no` 11px 700). 가독 하한. 추천 `impeccable typeset`.

## 잘된 점

- 핵심문서: 카드→뷰어 2단 IA, 활성 항목 `aria-current`, 모바일 PDF 한계를 「새 창·내려받기」로 항상 우회(`:104-120`), 언어 토글 시 iframe 재로딩(`:124`).
- Flow: 줌/맞춤 측정 로직의 자기참조 문제를 문서화해 해결, 도면은 영어라는 사실을 숨기지 않고 안내.
- StatusGuide: 표 데이터를 `status.js`에서 직접 그려 문서와 화면이 어긋나지 않게 한 구조, 한/인니 쌍 데이터 구조로 동등성 유지.

## 공유 자원 요약

| 자원 | 영향 |
|---|---|
| `DefaultLayout.vue`, `.asm-panel`, `.page-titles`, `.page-title`, `.page-sub` | 읽기 전용 사용, 수정 시 전 화면 영향 |
| `CsrStatusDefTable.vue`, `../status` | StatusGuide + 다른 화면(범례) 공유 |
| `coreDocs.js` (DOC_SETS) | 핵심문서와 표준양식 라우트 동시 영향 |
| `public/csr/flow/*.html` | Flow iframe 원본 |
| `.head` 중복 정의 | 3개 파일 각자 scoped, 통합하면 공유 컴포넌트 신설 |

## 추천 실행 순서

1. `impeccable distill` + `clarify` : StatusGuide 구조·내용 (P1 2건)
2. `impeccable adapt` : 핵심문서 좁은 화면 목록 (P1)
3. `impeccable colorize` + `harden` : Flow 선택 상태색, 로딩, ARIA
4. `impeccable typeset` / `extract` : tabular-nums, `#fff` 토큰
5. `impeccable polish` : 마감

Questions skipped: delegated run
