# Critique: dashboard (src/modules/csr/views/CsrDashboardPage.vue)

⚠️ DEGRADED: single-context (delegated read-only run; source-only review, no browser/detector, no snapshot persisted)

**총점 27/40 · 등급 Acceptable(20–27, 상단) · P0 0 · P1 2 · P2 7 · P3 4**
모드: Operate (업무 대시보드). 근거: CsrDashboardPage.vue, PRODUCT.md, DESIGN.md, asm-theme.css 토큰 확인. 렌더 확인과 detector는 미수행.

## 휴리스틱 점수

| # | 항목 | 점수 | 핵심 |
|---|---|---|---|
| 1 | 시스템 상태 가시성 | 3 | 로딩·권한·빈 상태 분기는 있음. 로딩 실패(에러) 상태 없음 |
| 2 | 현실 일치 | 3 | 상태 코드+이중언어 부제. L136 한국어만 |
| 3 | 사용자 통제 | 2 | 숫자·카드에서 목록으로 못 간다. 행 클릭만 가능 |
| 4 | 일관성·표준 | 2 | 이 화면 한정 글자 크기 덮어쓰기, 알약 count-pill, 숫자 가운데 정렬 |
| 5 | 오류 예방 | 3 | 읽기 전용 화면. 위험 낮음 |
| 6 | 인식 우선 | 3 | 배지 사용. 2번째 목록의 4열 의미가 헤더 없이 달라짐 |
| 7 | 유연성·효율 | 2 | 필터·드릴다운 없음. 10건 페이저뿐 |
| 8 | 미니멀 디자인 | 3 | 5카드·교차표·2목록·담당자표, 구성 군더더기 적음 |
| 9 | 오류 복구 | 2 | 로드 실패 시 안내·재시도 없음 |
| 10 | 도움말 | 4 | 「상태 기준」 링크, 툴팁은 배지에 위임 |
| **합계** | | **27/40** | Acceptable |

## 잘된 점
- 5개 KPI 카드와 교차표, 대기·미회신 두 목록, 담당자표 순으로 요약에서 상세로 흐르는 구성이 PRODUCT.md의 「현재 상태와 이력을 한 곳에서」에 맞는다.
- 상태를 CsrStatusBadge(코드+라벨)로 전달해 색 단독 의존을 피했다(Principle 2).
- 행 `role=button`+`tabindex`+Enter/Space 처리로 키보드 접근 가능(L218-226). 포커스 링도 토큰(`--asm-primary-40`) 사용(L487-489). HEX 직접 기입 없음.

## 우선순위 이슈

### P1
- **[P1] L136 「설정이 필요합니다」 한국어 단독**. 인니어 병기 없음. 같은 파일의 L142는 `t()`로 양쪽 제공하므로 L136만 어긋난다. Principle 1 위반(두 언어 동등).
  - 추천: `$impeccable clarify` (문구 `t('설정이 필요합니다','Konfigurasi diperlukan')`)
  - 공유 자원: 아니오 (이 파일 한정)
- **[P1] L147-165, L192-203 숫자가 막다른 길**. KPI 카드와 교차표의 셀 수치를 눌러도 목록(필터 적용)으로 이동하지 못한다. 현업 사용자의 주 업무가 목록 조회·필터인데 대시보드가 거기로 이어지지 않는다. 목록의 「검증 대기」 프리셋(itStatus=Completed)이 이미 있으므로 라우트 쿼리 연결이 가능하다.
  - 추천: `$impeccable layout` 후 `$impeccable harden` (카드·셀을 링크화, 키보드 포커스 포함)
  - 공유 자원: 예 (목록 화면의 쿼리 프리셋 계약, 라우터)

### P2
- **[P2] L335-356 공유 타이포 토큰을 화면 안에서 덮어씀**. page-title 18px(DESIGN 20px), `.asm-title` 1.0625rem(DESIGN 1.125rem), KPI 값 22px(L387-390, DESIGN 26px). 다른 화면과 위계가 어긋난다. 2026-10-09 사용자 요청 이력이 주석에 있으므로 의도 확인이 먼저다.
  - 추천: `$impeccable typeset` (DESIGN.md를 바꿀지 코드를 되돌릴지 결정)
  - 공유 자원: 예 (`.asm-title`, `.asm-kpi-*`, `.page-title`는 asm-theme.css 소유)
- **[P2] L392-403 KPI 톤을 좌측 3px 선 하나로만 표시**. Triple Status Rule(글자·soft 배경·테두리 3종) 불일치. `tone-info`와 `tone-primary`는 완전히 같은 규칙(L395-403)이라 중복. Open 카드에 danger(빨강) 선이 붙을 수 있다면(STATUS_TONE 확인 필요) 에러처럼 읽힌다.
  - 추천: `$impeccable colorize` (톤 매핑 재정리)
  - 공유 자원: 예 (STATUS_TONE in config.js)
- **[P2] L432-439 `.count-pill`이 9999px 알약**. DESIGN은 알약형을 역할 pill·스크롤바 썸에만 허용하고 모서리는 4/6/8px. 배지 규격(4px)으로 맞춘다.
  - 추천: `$impeccable polish`
  - 공유 자원: 아니오 (scoped). 다른 화면에 같은 클래스가 있으면 공유 후보
- **[P2] L445-449 수치를 가운데 정렬**. Tabular Rule은 숫자 열 우측 정렬. 주석(L443)에 2026-09-10 요청 이력이 있어 의도적. 교차표에서는 열 폭이 배지 폭에 맞춰 가운데가 자연스러우나 담당자표(L309-326)는 우측 정렬이 읽기 쉽다.
  - 추천: `$impeccable layout`
  - 공유 자원: 예 (`.table th.num`는 asm-theme.css)
- **[P2] L180 교차표 좌상단 빈 `<th>`, L184 열 헤더**. 접근 이름이 없고 `scope` 지정도 없다. 스크린리더가 행·열 관계를 못 읽는다.
  - 추천: `$impeccable harden` (빈 th에 sr-only 라벨, `scope="col|row"`)
  - 공유 자원: 아니오
- **[P2] L233, L279 `aria-label="pagination"` 영어 고정**. 이중언어 동등 위반. 페이지 표시 `1 / 3`(L243)에는 `aria-live`도 없다.
  - 추천: `$impeccable clarify`
  - 공유 자원: 아니오 (페이저가 다른 목록 화면과 같다면 공통 컴포넌트화 후보)
- **[P2] L227-231 vs L273-277 목록 4열의 의미가 두 목록에서 다름**. 첫 목록은 담당자(`it_pic`), 둘째는 우선순위(`priority`)를 같은 `.pic` 클래스·같은 위치에 표시하며 열 머리글이 없다. 둘째 목록은 값이 비면 빈칸(L276 `?? ''`). 이름이 `pic`인 것도 혼선 원인.
  - 추천: `$impeccable clarify` (작은 라벨 또는 아이콘/툴팁, 빈 값은 「—」)
  - 공유 자원: 아니오
- **[P2] L128-165 위계: 사용자의 「지금 할 일」보다 분석표가 먼저**. 현업 검증 대기(L211)와 IT 미회신(L257)은 행동이 필요한 목록인데 교차표(L168) 뒤에 온다. 2026-09-10 요청으로 이미 한 번 조정한 이력이 있으나, 정보 우선순위는 카드 → 목록 → 교차표가 Operate 모드에 맞다.
  - 추천: `$impeccable layout`
  - 공유 자원: 아니오

### P3
- **[P3] L130 h1 「Dashboard」 영문 고정**, 한·인니는 부제(L131)로만. 영문이 주인이고 두 언어가 부차 취급이다. 다른 CSR 화면 제목 패턴과 맞는지 확인(공통 패턴이면 유지).
  - 추천: `$impeccable clarify` · 공유 자원: 예 (헤드라인 패턴이 CSR 화면 공통일 가능성)
- **[P3] L172-174 「상태 기준 ↗」**. 화살표 ↗는 외부 링크 관례인데 내부 라우트. h2 안의 링크라 제목 이름에 링크 문구가 섞인다.
  - 추천: `$impeccable polish` · 공유 자원: 아니오
- **[P3] L193, L321-322 0 값을 빈 칸으로 표시**. 「0건」인지 「미집계」인지 구분 불가. `–` 또는 `0`(muted) 권장.
  - 추천: `$impeccable polish` · 공유 자원: 아니오
- **[P3] L101, L230 담당자 미지정을 `'—'` 로 표기**하고 설명 없음. 「미지정 / Belum ditentukan」 병기 필요. 또한 L93의 `/미회신|Belum Ada Balasan/` 정규식은 화면 문구가 아닌 데이터 값에 의존해 취약(로직 쪽 점검 대상).
  - 추천: `$impeccable harden` · 공유 자원: 예 (미회신 판정은 status.js 같은 단일 정의로 옮기는 것이 이상적)

## 인물 점검
- **현업 담당자(한국·인니)**: 검증 대기 목록은 찾지만 KPI의 「Completed 12」를 눌러도 아무 일이 없다(P1). 인니 사용자에게 L136, 페이저 aria, h1이 한쪽 언어 노출.
- **IT 부서**: 담당자별 표에서 본인 행을 찾아도 거기서 목록으로 이동 불가. 미회신 목록의 우선순위 열 의미 불명(P2).
- **admin**: 모니터링 용도. 로드 실패 시 안내가 없어 빈 화면과 구분 어려움(휴리스틱 9).
- **320px 모바일**: `.two-col`, `.pic-cols`는 `min(380px,100%)`로 접힘, 표는 스크롤 허용. 큰 결함 없음(렌더 미검증).

## 공유 자원 요약
수정 시 다른 화면에 영향: asm-theme.css의 `.asm-title`·`.asm-kpi-*`·`.table th.num`, config.js의 STATUS_TONE, status.js(미회신 판정 이관 시), 목록 화면 프리셋 쿼리, CsrStatusBadge. 이 파일 한정: L136, L233/279, L432 count-pill, L180 th, L227-277 목록 4열.

## 한계
렌더·detector·뷰포트 확인을 하지 않았고, STATUS_TONE 값(config.js)은 읽지 않았다. 색 대비와 실제 배치는 미검증.
