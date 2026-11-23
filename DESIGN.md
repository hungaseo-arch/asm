---
name: ASM CSR 관리 (ASM Web Vue)
description: ASCENDO BI 기준의 라이트 전용 업무 화면. 흰 카드·1px 테두리·블루 단일 액센트로 데이터를 읽히게 하는 관리 도구.
colors:
  primary: "#0062c6"
  primary-hover: "#0053a8"
  primary-active: "#00458b"
  primary-on: "#ffffff"
  primary-6: "#f0f6fc"
  primary-10: "#e6eff9"
  primary-15: "#d9e7f6"
  primary-20: "#cce0f4"
  primary-40: "#99c0e8"
  page: "#f5f5f5"
  card: "#ffffff"
  ink: "#333333"
  ink-muted: "#666666"
  surface-subtle: "#f3f3f3"
  line: "#d6d6d6"
  line-subtle: "#ebebeb"
  line-strong: "#999999"
  success: "#1e7b34"
  success-soft: "#e6f4ea"
  success-border: "#a8d5b3"
  warning: "#8a5a00"
  warning-soft: "#fff6e0"
  warning-border: "#f5d580"
  danger: "#c62828"
  danger-soft: "#fce9e9"
  danger-border: "#f0a3a3"
  danger-hover: "#b22424"
  neutral: "#5f5f5f"
  neutral-soft: "#ededed"
  orange: "#b4500a"
  orange-soft: "#fff0e6"
  orange-border: "#f2b08a"
typography:
  page-title:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "20px"
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: "-0.01em"
  section-title:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "1.125rem"
    fontWeight: 700
    lineHeight: "28px"
    letterSpacing: "-0.01em"
  kpi:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "1.625rem"
    fontWeight: 700
    fontFeature: "tnum"
  body:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
    lineHeight: 1.5
  table:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "13px"
    fontWeight: 400
    fontFeature: "tnum"
  label:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "12px"
    fontWeight: 500
  badge:
    fontFamily: "'Noto Sans KR', 'Noto Sans', 'KoPubDotum', 'Malgun Gothic', 'Apple SD Gothic Neo', system-ui, sans-serif"
    fontSize: "12px"
    fontWeight: 700
    letterSpacing: "0.04em"
rounded:
  sm: "4px"
  md: "6px"
  lg: "8px"
  pill: "9999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-on}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: "36px"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  button-primary-active:
    backgroundColor: "{colors.primary-active}"
  button-secondary:
    backgroundColor: "{colors.primary-10}"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: "36px"
  button-outline:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: "36px"
  button-danger:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.primary-on}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: "36px"
  input:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    padding: "6px 12px"
    height: "36px"
  panel:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.lg}"
  badge-status:
    rounded: "{rounded.sm}"
    typography: "{typography.badge}"
    height: "20px"
    padding: "0 8px"
  pill-role:
    backgroundColor: "{colors.primary-10}"
    textColor: "{colors.primary}"
    rounded: "{rounded.pill}"
    height: "28px"
    padding: "0 10px"
  table-head:
    backgroundColor: "{colors.primary-6}"
    textColor: "{colors.ink}"
    padding: "9px 12px"
  table-total-row:
    backgroundColor: "{colors.primary-10}"
    textColor: "{colors.primary}"
---

# Design System: ASM CSR 관리

## Overview

**Creative North Star: "The Ledger Desk" (장부 책상)**

PT ASCENDO 직원이 하루 종일 열어 두고 개선요청(CSR)을 찾고, 상태를 바꾸고, 문서를 확인하는 업무용 화면입니다. 시스템은 ASCENDO BI 가이드(v1.0)에서 곧바로 내려옵니다. 흰 카드가 연회색 바탕 위에 놓이고, 구분은 그림자가 아니라 1px 테두리가 맡고, 블루는 단 하나의 액센트로 헤더 4px 바·표 헤더 밑줄·활성 메뉴·주 버튼에만 나타납니다. 장식보다 읽히는 표와 상태 배지가 먼저입니다.

밀도는 중간에서 높음 쪽입니다. 본문 14px, 표 13px, 행 높이 38px로 한 화면에 많은 행을 담되, 컨트롤은 36px 이상으로 눌리기 쉽게 둡니다. 숫자는 별도 mono 서체 없이 본문 서체에 tabular-nums만 적용해 열을 맞춥니다. 라이트 모드 전용이며 BI에 다크 모드 규정이 없으므로 만들지 않습니다.

**Key Characteristics:**
- 흰 카드(#ffffff) + 1px 테두리(#d6d6d6) + 연회색 바탕(#f5f5f5). 평소 그림자 없음
- 블루(#0062c6) 단일 액센트. 상태색은 글자·soft 배경·테두리 3종 세트
- 모서리 3단(4/6/8px)만 사용. 알약형은 역할 pill 한정
- 서체는 Noto Sans KR 단일 계열, 제목 700 · 본문 400~500
- 컴포넌트에서 HEX 직접 기입 금지, `--asm-*` / `--bs-*` 변수만 참조

## Colors

차분한 중립 회색 위에 블루 한 색이 구조를 그리는 팔레트. 의미가 있는 색(상태)만 색상환의 다른 쪽을 씁니다.

### Primary
- **Ascendo Blue** (#0062c6): 주 버튼, 링크, 액센트 바, 표 헤더 밑줄, 활성 메뉴 글자, 포커스 테두리. 화면 한 장에서 면적 비중은 작게 유지
- **Blue Pressed** (#0053a8 hover / #00458b active): 주 버튼·링크의 상호작용 단계
- **Blue Tints** (6% #f0f6fc · 10% #e6eff9 · 15% #d9e7f6 · 20% #cce0f4 · 40% #99c0e8): 6% 는 표 헤더·행 hover, 10% 는 활성 메뉴·합계행·역할 pill 배경, 15% 는 보조 버튼 hover, 40% 는 3px 포커스 링·info 테두리

### Neutral
- **Page Gray** (#f5f5f5): 페이지 바탕. 흰 카드가 떠오르는 구조의 기준
- **Card White** (#ffffff): 카드·표·입력창·헤더 바탕
- **Ledger Ink** (#333333): 본문·제목·비활성 메뉴 글자(BI Dark Gray). 흐리게 하지 않음
- **Quiet Ink** (#666666): 보조 글자, 부제, KPI 라벨, 날짜 열
- **Rule Gray** (#d6d6d6): 카드·입력·구분선. 내부 약한 구분은 #ebebeb, hover·비활성 마커는 #999999
- **Soft Surface** (#f3f3f3): secondary hover, 비활성 입력, 검색창 바탕

### Status (글자 / soft 배경 / 테두리 3종 세트)
- **Success** #1e7b34 / #e6f4ea / #a8d5b3
- **Warning** #8a5a00 / #fff6e0 / #f5d580
- **Danger** #c62828 / #fce9e9 / #f0a3a3 (hover #b22424)
- **Neutral** #5f5f5f / #ededed / #d6d6d6
- **Info** 은 브랜드 블루를 그대로 재사용
- **Orange** #b4500a / #fff0e6 / #f2b08a: CSR 현업검증 REJECTED 전용. 빨강(danger)과 구분하기 위한 예외

### Named Rules
**The One Voice Rule.** 블루는 구조와 행동을 가리킬 때만 쓴다. 장식 면, 큰 배경 채움, 그라데이션에 쓰지 않는다.

**The Triple Status Rule.** 상태는 반드시 글자색·soft 배경·테두리 3종을 함께 쓴다. 색만으로 상태를 전달하지 않고 라벨 텍스트를 같이 둔다.

**The No-Raw-Hex Rule.** 컴포넌트 안에 HEX를 직접 쓰지 않는다. 필요한 값이 토큰에 없으면 `asm-theme.css` 에 먼저 추가한다.

## Typography

**Display / Body / Label Font:** Noto Sans KR (fallback: Noto Sans, KoPubDotum, Malgun Gothic, Apple SD Gothic Neo, system-ui, sans-serif)
**Mono:** 별도 없음. 본문 서체 + `font-variant-numeric: tabular-nums`

**Character:** 한글 업무 화면에 맞춘 단일 서체. 위계는 크기보다 굵기(700/500/400)와 위치로 만든다. 숫자와 코드는 서체를 바꾸지 않고 자릿수만 맞춘다.

### Hierarchy
- **Page title** (700, 20px, 1.3): 화면 제목. 같은 줄에 14px #666666 부제를 baseline 정렬
- **Section title** (700, 18px, 28px 줄높이): 카드·섹션 제목. 좌측 3px 블루 세로선 + 10px 안쪽 여백. 밑줄·배경 강조 금지
- **KPI value** (700, 26px, tabular-nums): 대시보드 수치. 단위는 12px 400 muted
- **Body** (400, 14px, 1.5): 기본 글자. 모바일 입력창은 16px
- **Table** (400, 13px): 셀. 헤더는 500 12px. 보조 정보(`.sub`)는 12px muted
- **Label** (500, 12px): 폼 라벨. 필수 표시는 danger 색 `*`
- **Eyebrow** (500, 12px, 0.06em, 대문자): 블록 상단 작은 라벨. 블루
- **Badge** (700, 12px, 0.04em, 대문자): 상태 배지

### Named Rules
**The Tabular Rule.** 숫자·PO 번호·코드·날짜는 tabular-nums. 숫자 열은 우측 정렬, 날짜 열은 가운데 정렬에 줄바꿈 금지.

**The Weight Ladder Rule.** 제목 700, 컨트롤 라벨 500, 본문 400. 300 이하나 800 이상은 쓰지 않는다.

## Layout

상단에 4px 블루 액센트 바, 그 아래 56px 흰 헤더가 sticky 로 붙고(총 60px, `--asm-header-offset`), 본문은 연회색 바탕 위 카드 열입니다. 헤더는 3열 그리드(`minmax(max-content,1fr) auto minmax(max-content,1fr)`)로 상단 메뉴를 정중앙에 두며, 좁은 화면에서는 992px 미만에서 제목을, 768px 미만에서 메뉴 글자를 숨겨 한 줄을 유지합니다. 푸터는 12px muted, 상단선 1px, 가운데 정렬로 「© PT ASCENDO INTERNASIONAL」.

간격은 4·8·12·16·24px 계열. 카드 안쪽은 16px 안팎, 카드 사이는 16~24px. 표는 가로 스크롤을 허용하고 헤더는 sticky, 셀은 `white-space: nowrap` 이 기본입니다. 최소 폭 320px.

반응형은 Bootstrap 5.3 기본 브레이크포인트(576/768/992/1200)를 따릅니다. 768px 미만에서 입력 글자는 16px로 올려 iOS 자동 확대를 막습니다.

## Elevation & Depth

평소에는 완전히 평평합니다. 카드·버튼·헤더는 그림자 없이 1px 테두리로만 구분하고, 그림자는 화면 위로 뜨는 요소에만 두 단계로 씁니다. 로고에는 어떤 그림자·효과도 추가하지 않습니다(BI BS 07).

### Shadow Vocabulary
- **Rest** (`box-shadow: none`): 카드, 버튼, 헤더, 표
- **Float** (`0 4px 12px rgb(51 51 51 / 0.12)`): 드롭다운, 토스트
- **Overlay** (`0 12px 32px rgb(51 51 51 / 0.18)`): 모달, 드로어
- **Focus ring** (`0 0 0 3px #99c0e8`): 버튼·입력·아이콘 버튼의 포커스. 입력은 테두리도 primary 로 바뀜
- **Scrim** (`rgb(51 51 51 / 0.5)`): 모달 뒤 오버레이

### Named Rules
**The Flat-At-Rest Rule.** 정지 상태의 요소에 그림자를 쓰지 않는다. 그림자는 "화면 위로 뜬다"는 뜻일 때만.

## Shapes

모서리는 세 단계로 고정합니다. 4px(배지·태그·드롭다운 항목), 6px(버튼·입력·드롭다운 컨테이너·활성 메뉴), 8px(카드·모달·대형 검색창). BI에 xl 단계가 없으므로 xl은 8px과 같습니다. 완전한 알약형(9999px)은 역할·사용자 pill 과 스크롤바 썸에만 허용합니다. 테두리는 항상 1px, 예외는 표 헤더 하단 2px 블루 밑줄과 섹션 제목의 3px 세로선입니다.

심볼 모티프(우하단 6% 투명도 ASCENDO 심볼)는 로그인·빈 상태·오류 화면에서만 쓰고, 데이터 표나 입력 폼 카드에는 얹지 않습니다.

## Components

### Buttons
- **Shape:** 6px 모서리, 그림자 없음, 최소 높이 36px(Small 30px / Large 40px), 아이콘–글자 간격 8px
- **Primary:** 블루 채움 + 흰 글자, 500 weight, 패딩 8×16px. hover #0053a8, active #00458b
- **Secondary:** blue 10% 채움 + 블루 글자. hover 15%
- **Outline:** 흰 배경 + #d6d6d6 테두리 + ink 글자. hover 에서 #f3f3f3 배경 + 블루 글자·테두리
- **Danger:** #c62828 채움 + 흰 글자. hover #b22424
- **Icon button:** 36px 정사각, 1px 테두리, hover 시 블루 테두리·글자. 테두리 없는 변형 `is-borderless`
- **Focus / Disabled:** 3px #99c0e8 링 / 불투명도 0.5, 포인터 차단

### Inputs / Fields
- **Style:** 흰 배경, 1px #d6d6d6, 6px 모서리, 최소 높이 36px, 패딩 6×12px
- **Focus:** 테두리 블루 + 3px #99c0e8 링, 윤곽선 없음
- **Error / Disabled:** 테두리 #c62828 / 불투명도 0.6 + #f3f3f3 바탕
- **Label:** 12px 500, 하단 간격 6px, 필수 `*` 는 danger
- **Search:** 화면 상단 1개 한정. 42px, #f3f3f3 바탕, 8px 모서리, focus 시 흰 바탕

### Tables
- **Header:** blue 6% 배경, 12px 500, sticky, 하단 2px 블루 밑줄, 패딩 9×12px
- **Rows:** 38px, 하단 1px #ebebeb, hover 시 blue 6%
- **Cell types:** `.num` 우측 정렬 tabular, `.date` 가운데·한 줄·muted, `.code` tabular, `.idx` 12px muted, `.sub` 12px muted
- **Total row:** blue 10% 배경 + 블루 글자 + 700

### Status Badge
20px 높이, 4px 모서리, 12px 700 대문자, 자간 0.04em, 글자·soft·테두리 3종 세트. 앞에 6px 점(opacity 0.75)을 둘 수 있음. 변형: info · success · warning · danger · neutral · primary(Verified) · orange(Rejected).

### Panels / Cards
흰 배경, 1px #d6d6d6, 8px 모서리, 그림자 없음. 제목은 좌측 3px 블루 세로선(`.asm-title`). KPI 카드는 12px muted 라벨 위, 26px 700 수치 아래, 증감은 12px(up=success, down=danger).

### Navigation (헤더)
흰 배경 56px, 하단 1px 선, 위에 4px 블루 액센트 바. 활성 대분류는 blue 10% 배경 + 블루 글자 + 700 + 6px 모서리. 비활성 글자는 흐리지 않고 ink 그대로. 드롭다운은 6px 모서리, Float 그림자, 패딩 6px, 항목 4px 모서리·8×12px, hover #f3f3f3, active blue 10% + 블루 + 700.

### Role Pill
28px, 알약형, blue 10% 배경 + 블루 글자, 12px 700. 로그인 사용자·역할 표시에 사용.

## Do's and Don'ts

### Do:
- **Do** 색은 `--asm-*` / `--bs-*` 변수로만 참조하고, 새 값은 `src/assets/asm-theme.css` 에 먼저 추가한다.
- **Do** 카드는 흰 배경 + 1px #d6d6d6 + 8px 모서리로 만들고 연회색 바탕 위에 둔다.
- **Do** 상태 표현은 라벨 텍스트와 글자·soft·테두리 3종 색을 함께 쓴다.
- **Do** 숫자·날짜·코드에 tabular-nums 를 적용하고, 날짜 값은 한 줄(`white-space: nowrap`)로 유지한다.
- **Do** 포커스는 3px #99c0e8 링으로 통일하고, 컨트롤 높이는 36px 이상(Small 30px)으로 둔다.
- **Do** 한 화면에 블루 면적을 작게 유지한다. 주 버튼은 화면당 한 영역에 하나.

### Don't:
- **Don't** 다크 모드를 추가하지 않는다. BI에 규정이 없고 `data-bs-theme="light"` 로 고정되어 있다.
- **Don't** 카드·버튼·헤더에 평상시 그림자를 넣지 않는다. 그림자는 드롭다운·토스트·모달뿐이다.
- **Don't** 로고·심볼을 재채색하거나 그림자·효과를 얹지 않는다(BI BS 07). 워터마크는 6%/10% 투명도 모티프로만.
- **Don't** 숫자·코드용 mono 서체를 따로 추가하지 않는다. Pretendard 등 AsuraDB 기준 서체·청회색 토큰과 섞지 않는다.
- **Don't** 섹션 제목에 밑줄·배경 강조를 쓰지 않는다. 강조는 좌측 3px 블루 세로선 하나뿐이다.
- **Don't** 상태를 색만으로 전달하지 않는다. 빨강(danger)과 주황(orange, REJECTED 전용)을 혼용하지 않는다.
- **Don't** 데이터 표·입력 폼 카드 위에 심볼 모티프를 얹지 않는다.
- **Don't** 4/6/8px 외의 임의 모서리, 9999px 알약형(역할 pill 외)을 만들지 않는다.
