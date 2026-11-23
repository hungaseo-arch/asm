# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

PT ASCENDO의 사내 사용자 3부류. 한국과 인도네시아 양쪽에 있으며 대부분 데스크톱 브라우저로 하루 종일 열어 두고 쓴다.

- **현업·총괄팀 (한국·인니)** : 개선요청(CSR)을 등록하고, IT 처리 결과를 현업검증(PENDING → ACCEPTED / REJECTED 등)으로 마무리한다. 목록 조회·필터가 주 업무
- **IT 부서** : IT상태(Open → Ongoing → Completed) 갱신, 담당자·목표배포일·IT수용여부·회신 요약 작성
- **admin (서종환)** : 전체 관리, 사용자·권한, 번역 검수, 대시보드 확인

모바일 조회는 거의 없을 것으로 판단하지만, 구색은 갖춰 320px 폭에서 깨지지 않게 한다.

## Product Purpose

ASM(Ascendo Management System) 안의 CSR 모듈. 노션 등에 흩어져 있던 개선요청을 한 곳에서 한국어·인도네시아어 이중언어로 등록하고, IT 처리부터 현업검증까지 하나의 흐름으로 추적한다.

성공 기준 : 누락·중복 없이 모든 건이 종결 상태에 도달하고, 현업·IT 어느 쪽도 다른 도구 없이 현재 상태와 이력을 확인할 수 있다.

## Positioning

개선요청의 상태가 IT상태와 현업검증이라는 두 축으로 나뉘어 있고, 각 전환에 역할별 편집 규칙(컬럼 가드)이 걸려 있는 사내 전용 추적 도구. 범용 이슈 트래커가 아니라 ASM의 현업-IT 협업 규칙을 그대로 담은 모듈이다.

## Operating Context

- 역할 : admin, business(현업·총괄팀), it_dept. 권한은 DB 정책과 화면 규칙이 함께 강제
- 상태 코드 : IT상태 4단계(Open · Ongoing · Completed · Verified), 현업검증 5종(PENDING · NOT APPLIED · PARTIAL · ACCEPTED · REJECTED). 코드 변경 금지
- 구성 화면 : 목록, 상세, 대시보드, 업무 Flow Diagram, 상태 가이드, 핵심문서·자료실, 관리
- 기술 : Vue 3 + Vite + Bootstrap 5.3, Better Auth 로그인, Neon(PostgREST) 데이터, GitHub Pages 배포. `main` 푸시가 곧 배포
- 운영 문서 : `docs/csr/` (작업지시서, 완료보고, 정합성 검증), `CHANGELOG.md`

## Capabilities and Constraints

- 모든 화면 문구와 상태명은 한국어·인도네시아어를 동등하게 제공한다. 어느 한쪽이 부차적이지 않다
- 상태 코드(영문)는 배지에 그대로 쓰고, 설명은 툴팁·범례에서 ko / id 로 제공한다
- 라이트 모드 전용(ASCENDO BI에 다크 모드 규정 없음)
- 데이터 쓰기는 역할별 컬럼 가드를 통과해야 하며 화면은 이를 거울처럼 반영한다
- 인도네시아 현지 사용자의 회선·PC 환경이 좋지 않을 수 있어 외부 자원·무거운 자산은 최소화한다(미확인 가정, 필요 시 확인)

## Brand Commitments

ASCENDO BI 디자인 가이드 v1.0(2026-09-02)을 따른다. 시각 규정은 [DESIGN.md](DESIGN.md)와 `src/assets/asm-theme.css`가 소유한다. 회사명 표기는 「PT ASCENDO INTERNASIONAL」, 심볼·시그니처는 재채색·효과 추가 금지.

## Evidence on Hand

- 실제 운영 데이터 : 개선요청 100건 이상, 검증 이력, IT 회신, 캡쳐 첨부
- 실제 문서 : `docs/csr/` 작업지시서·보고서, 스크린샷 `docs/csr/shots/`
- 없는 것 : 사용성 테스트 결과, 접속 환경(회선·기기) 통계. 임의로 만들지 않는다

## Product Principles

1. 두 언어는 동등하다. 한쪽 언어만 보이는 상태를 만들지 않는다
2. 상태는 색이 아니라 코드와 라벨로 전달한다. 색은 보조
3. 표와 목록의 읽기 속도가 화려함보다 먼저다
4. 권한이 없는 편집은 숨기거나 비활성으로 보이게 하고, 서버 규칙과 화면 규칙을 어긋나게 두지 않는다
5. 데스크톱이 주 화면이며 모바일은 조회가 깨지지 않는 선까지만 보장한다

## Accessibility & Inclusion

- 한·인니 이중언어 동등 제공
- 상태 배지·텍스트 대비는 가이드 기준(AA 4.5:1 이상)을 유지하고 색만으로 상태를 전달하지 않는다
- 모바일은 최소 폭 320px에서 레이아웃이 깨지지 않을 것
