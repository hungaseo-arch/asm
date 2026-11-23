# Impeccable Audit: detail (src/modules/csr/views/CsrDetailPage.vue)

**점수: 13/20 (Acceptable, 의미 있는 작업 필요)** · P0 0 · P1 2 · P2 7 · P3 4
기준: PRODUCT.md(320px 비깨짐, AA 4.5:1, 이중언어 동등) + DESIGN.md(No-Raw-Hex, Tabular, Weight Ladder, 4/6/8 radius). 읽기 전용, 코드 수정 없음.
방법: 전체 1746줄 정독(script 일부는 grep) + `impeccable detect`(regex만 실행, 요소 규칙 미실행 = 과소집계). 렌더 검증은 하지 않았다.

| # | 차원 | 점수 | 핵심 |
|---|------|------|------|
| 1 | Accessibility | 2 | 라이트박스 포커스 트랩 없음, 상태/오류 영역 live region 없음, 값 잘림이 title 툴팁에만 의존 |
| 2 | Performance | 3 | lazy img + width/height 지정 양호. 템플릿 인라인 배열/filter 재생성만 경미 |
| 3 | Theming | 3 | 거의 전부 토큰 사용. 라이트박스 HEX 3곳·rgb 1곳 |
| 4 | Responsive | 2 | 표 2개 가로 스크롤 래퍼 없음, 속성 격자가 320px에서도 2열+말줄임 |
| 5 | Implementation Integrity | 3 | 디자인 시스템과 대체로 정합. 좌측 띠 장식·tabular/날짜 규칙 일부 이탈 |

## Implementation Integrity Verdict
Pass(조건부). 토큰(`--asm-*`)·3단 radius·flat-at-rest·섹션 제목(.asm-title)·상태 배지 컴포넌트를 일관되게 쓴다. 감지기 anti-pattern 0건, advisory 1건(L1676). 이탈은 아래 P2/P3.

## 발견 사항

### P1
**[P1] 표 2개에 가로 스크롤 래퍼 없음 (검증 이력 · 상태 변경 로그)**
- 위치: CsrDetailPage.vue:1191-1224(`table.verif`), 1240-1263(로그 표), CSS 1606-1618
- 문제: 셀이 `.nowrap`(셀 기본도 한 줄 고정)인 4~5열 표가 `.table-responsive` 없이 패널 안에 직접 놓임. 320px에서 패널 밖으로 넘치거나 페이지 가로 스크롤 발생 가능. DESIGN.md "표는 가로 스크롤 허용"이 이 화면에서는 구현되지 않음. (테마에 `.asm-table` 규칙 없음 확인; 실제 넘침은 렌더 확인 필요)
- 기준: WCAG 1.4.10 Reflow, PRODUCT 320px 요건
- 추천: `$impeccable adapt` (표를 `overflow-x:auto` 래퍼로 감싸기), 이후 `$impeccable polish`
- 공유 자원: 아님(컴포넌트 내). 단 래퍼 클래스를 테마에 둘 경우 공유

**[P1] 속성 격자 값이 한 줄 말줄임 + 2열 고정이라 좁은 화면에서 정보 손실**
- 위치: CsrDetailPage.vue:1363-1373, 1425-1432(`.props dd` nowrap/ellipsis), 743(title만 제공)
- 문제: 576px 미만에서도 2열 유지, 값은 `text-overflow: ellipsis`. 전체 값은 `title` 툴팁뿐이라 터치·키보드 사용자는 잘린 값을 볼 수 없음. 한·인니 이중언어 값(길이 큰 인니어)에서 더 심함. 화면경로(1381)만 스크롤.
- 기준: WCAG 1.4.10, 1.3.1(정보 접근), PRODUCT 원칙 1·5
- 추천: `$impeccable adapt` (576px 미만 1열, dd 줄바꿈 허용 또는 펼침), `$impeccable layout`
- 공유 자원: 아님

### P2
**[P2] 라이트박스: aria-modal인데 포커스 트랩·배경 스크롤 잠금 없음**
- 위치: 1269-1301, script 662-679(초기 포커스·복귀·Esc는 구현됨), CSS 1672-1683
- 문제: Tab이 모달 밖 페이지로 빠짐. body 스크롤 잠금 없음(overscroll-behavior만). `max-height:92vh`는 모바일 주소창에서 dvh 권장.
- 기준: WCAG 2.4.3, ARIA modal 패턴
- 추천: `$impeccable harden`
- 공유: 아님

**[P2] 라이트박스 raw 색상: `#fff` ×3, `rgb(0 0 0 / 0.72)`**
- 위치: CSS 1676, 1696, 1703, 1714
- 문제: No-Raw-Hex 위반. DESIGN.md Scrim은 `rgb(51 51 51 / 0.5)`인데 0.72 검정으로 다름. 감지기 advisory와 일치.
- 추천: `$impeccable extract` (스크림 토큰 `--asm-scrim` 추가 후 참조), `$impeccable polish`
- 공유 자원: 공유 (토큰은 `src/assets/asm-theme.css`에 먼저 추가해야 함, 컴포넌트에서 단독 수정 금지)

**[P2] 로딩·오류 상태에 live region 없음**
- 위치: 704-706 (`.state`, `.err`)
- 문제: 스크린리더에 로딩 완료/오류가 안 알려짐. 오류는 danger 글자색만, 아이콘·라벨 보조 없음(원칙 2: 색만으로 전달 금지). 저장 오류·업로드 결과의 알림 영역도 이 파일에서 확인되지 않음(전역 토스트 가능성, 미확인).
- 기준: WCAG 4.1.3
- 추천: `$impeccable harden`
- 공유: 아님

**[P2] 필수 입력 표시 누락**
- 위치: 985-992(replied_on), 1136-1143(verified_on), 1147(result `required`)
- 문제: `required`는 있으나 DESIGN.md 규정의 danger색 `*` 라벨 표시가 없음. 오류 문구도 브라우저 기본.
- 기준: WCAG 3.3.2, DESIGN Label 규칙
- 추천: `$impeccable clarify`, `$impeccable harden`
- 공유: 아님(`.field` 공용 마커를 테마로 올리면 공유)

**[P2] 날짜 값이 Tabular Rule과 불일치**
- 위치: 1044(`.reply h3` 날짜), 1202/1252(`.nowrap` 날짜 셀), 1067, CSS 1566-1571, 1731
- 문제: 날짜 셀에 `tabular-nums`·가운데 정렬·muted 없음(`.issue-no`만 tabular). DESIGN.md "날짜 열은 가운데·한 줄·tabular".
- 추천: `$impeccable typeset`
- 공유: 아님. 기존 `.date` 셀 클래스가 테마에 있으면 재사용 가능(공유 자원 활용)

**[P2] 속성·회신 칸의 좌측 3px 블루 띠 장식**
- 위치: CSS 1408-1413, 1580-1585
- 문제: DESIGN.md "좌측 3px 블루 세로선은 섹션 제목 하나뿐"인데 칸마다 `border-left:3px solid primary-10`을 반복(16개 칸 + 회신마다). 블루 사용량 증가와 One Voice 약화. `--asm-muted-20`(#f7f7f7)은 DESIGN.md 팔레트에 없는 토큰.
- 추천: `$impeccable quieter`, `$impeccable document` (muted-20 토큰 문서화)
- 공유: 토큰 문서화 쪽은 공유(`DESIGN.md`·`asm-theme.css`)

**[P2] `.head` 패딩이 좁은 화면에서 줄지 않음 · 헤더 줄 줄바꿈**
- 위치: CSS 1339-1341(20px 24px 고정), `.sec`만 767px 미만에서 16px(1498-1502)
- 문제: 320px에서 상단 카드 가용폭 손실. `.top-row`(1312)는 wrap 없이 범례와 뒤로가기가 한 줄이라 좁은 폭에서 겹칠 수 있음(범례 컴포넌트 폭 미확인).
- 추천: `$impeccable adapt`
- 공유: 아님

**[P2] 접기 버튼 안에 h2 포함, aria-controls 없음**
- 위치: 1229-1239
- 문제: `<button>` 안 `<h2>`는 HTML 콘텐츠 모델 위반(헤딩 탐색 시 버튼이 아닌 제목으로 잡힘). `aria-expanded`는 있으나 대상 연결 없음. 버튼 글자 12px muted로 조작 가능성이 약함.
- 추천: `$impeccable harden`
- 공유: 아님

### P3
- **[P3] Weight Ladder 이탈 소지**: `.props dt`·`.reply dt` 700(1417, 1591). 규정은 컨트롤 라벨 500. 의도된 구분이면 DESIGN.md에 반영. 추천 `$impeccable typeset`. 공유 아님.
- **[P3] 커스텀 버튼 포커스 링 미통일**: `.shot-open`(1662), `.log-toggle`(1734)은 3px #99c0e8 링 규칙이 `.btn`에만 적용될 가능성. 렌더 확인 후 `$impeccable polish`. 테마에 공통 규칙을 넣으면 공유.
- **[P3] 본문 `pre.md`에 lang 속성 없음**: ko/id 선택 본문이라 `:lang="lang"` 부여 권장(1960·953·1111). `$impeccable harden`.
- **[P3] 템플릿 내 인라인 배열·filter**: L905 v-for 리터럴, 764/796의 `FIELDS.filter(editable)`이 렌더마다 재생성. 규모 작아 영향 미미. `$impeccable optimize`.

## 패턴 및 체계적 이슈
- 좁은 화면 대응이 패널 패딩(.sec)에만 있고 표·격자·헤더로 확장되지 않음 (P1 2건 + P2 1건 공통 원인).
- 토큰 규율은 높으나 오버레이(라이트박스)만 예외. 공유 토큰 추가 필요.
- 이중언어 동등은 양호(KO/ID 쌍 편집, lang 속성). 단 읽기 영역의 lang은 누락.

## 긍정 사항
- 라이트박스: `role=dialog`·`aria-modal`·`aria-label`, 열 때 닫기 버튼 포커스, 닫을 때 트리거 복귀, Esc 처리.
- 이미지: width/height + `loading="lazy"`, 실패 시 대체 문구, alt 제공.
- 표·카드가 `<table><thead>`, `<dl>`, `<figure>/<figcaption>`, 단일 h1→h2→h3로 시맨틱 정확. 폼은 모두 `<label>` 감싸기.
- 권한 밖 필드 숨김(원칙 4), `min(240px,100%)` 격자로 자동 접힘, `:disabled` 저장 중 처리.
- 감지기 anti-pattern 0건, 평상시 그림자 없음, radius 3단 준수.

## 추천 실행 순서
1. **[P1] `$impeccable adapt`**: 표 래퍼, 속성 격자 1열/줄바꿈, `.head` 패딩, top-row wrap
2. **[P2] `$impeccable extract`**: `--asm-scrim` 토큰(공유, asm-theme.css) 후 라이트박스 치환
3. **[P2] `$impeccable harden`**: 라이트박스 포커스 트랩·스크롤 잠금, live region, 필수 표시, 접기 버튼 구조
4. **[P2] `$impeccable typeset`**: 날짜 tabular/가운데, 라벨 weight
5. **[P2] `$impeccable quieter`**: 칸 좌측 띠 정리(필요 시 `$impeccable document`로 muted-20 문서화)
6. **`$impeccable polish`**: 마무리, 재감사로 점수 확인

공유 자원 요약: 공유 = `--asm-scrim` 신설, `--asm-muted-20` 문서화, 포커스 링 공통 규칙(해당 시). 나머지는 이 파일 단독 수정 가능.
