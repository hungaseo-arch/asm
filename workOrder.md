# workOrder.md — asm-web-vue 작업 지시서

> 대상: VSCode Claude (Claude Code)
> 프로젝트 경로: `D:\asm-web-vue`
> 목적: **PT ASCENDO 실서버 ASM(https://asm.ascendotyre.com)과 동일한 기술스택·구조로 로컬 프론트엔드를 정비하고 화면을 개발한다.**
> 작성일: 2026-09-01 / 근거: 실서버 런타임 실측(번들·DOM·네트워크 응답 헤더 분석)

---

## 0. 최우선 작업 (Step 0 — 반드시 먼저 수행)

코드를 한 줄이라도 작성하기 전에 아래를 실행하고 **차이 보고서**를 먼저 제출할 것.

1. `package.json`, `vite.config.*`, `src/` 트리, `src/router/`, `src/stores/`, `src/api|services/` 를 읽는다.
2. 아래 §2 "확정 스택"과 로컬 현황을 표로 대조한다. (일치 / 불일치 / 누락)
3. 불일치 항목별로 **수정안 + 영향 범위**를 제시하고 승인을 받은 뒤 변경한다.
4. 승인 없이 `package.json` 의존성 추가·삭제, 라우트 경로 변경, API 경로 변경을 하지 않는다.

---

## 1. 실서버 기술스택 분석 결과 (근거)

| 구분 | 확인 내용 | 근거 |
|---|---|---|
| 프레임워크 | Vue **3.5.41** (Composition API, SFC) | `#app.__vue_app__.version` |
| 빌드 | **Vite** (단일 번들 `assets/index-*.js` 2,391 KB / `index-*.css` 351 KB, `vite.svg` favicon) | 정적 자산 해시 패턴 |
| 상태관리 | **Pinia** (스토어: `user`, `toast`, `creditNote`) | `$pinia.state` |
| 라우팅 | **Vue Router** — History 모드, base `/`, 등록 라우트 **83개** | `$router.getRoutes()` |
| HTTP | **axios** (JWT `Bearer` 헤더, 리프레시 인터셉터) | 번들 문자열 `axios` / `Bearer` / `/api/refresh/` |
| UI/CSS | **Bootstrap 5** (`--bs-*` CSS 변수 전량, `navbar-expand-lg`·`d-flex`·`me-4` 등 유틸리티 클래스) + **SFC scoped CSS**(고유 `data-v-` 85종, 1,475개 셀렉터) | CSS 번들 파싱 + DOM 클래스 |
| 아이콘 | Font Awesome | 번들 문자열 |
| 검증 | yup 계열 스키마 | 번들 문자열 |
| 엑셀 | **SheetJS(xlsx)** — 목록 엑셀 내보내기 | 번들 문자열 + `/api/product/product_excel_list` |
| 미사용(확인됨) | TypeScript 흔적 없음 / Nuxt·SSR 아님 / Element Plus·Vuetify·Tailwind·jQuery·차트 라이브러리 없음 | 번들 시그니처 전수 검사 |
| 백엔드 | **Django REST Framework** (JWT) | `/api/me/` 401 응답 `{"detail":"Authentication credentials were not provided."}`, `Allow: OPTIONS, GET`, `Vary: Accept` = DRF 표준 시그니처 |
| 웹서버 | **nginx/1.30.3**, 프론트·API **동일 오리진**(`/api/` 프록시) | 응답 헤더 `Server` |
| 보안 헤더 | `X-Frame-Options: DENY`, `X-Content-Type-Options`, `Referrer-Policy`, COOP 적용 | 응답 헤더 |

> 참고: 실서버 SPA는 코드 스플리팅이 적용되지 않아 초기 번들이 2.4 MB입니다. 로컬 프로젝트에서는 §6 성능 규칙을 따릅니다.

---

## 2. 확정 스택 (로컬 프로젝트가 반드시 맞춰야 할 기준)

```
Vue 3.5.x          — Composition API + <script setup>, SFC
Vite 5.x 이상       — 개발 서버 + 빌드
Vue Router 4.x     — createWebHistory('/')
Pinia 2.x          — 전역 상태
axios 1.x          — 단일 인스턴스 + 인터셉터
Bootstrap 5.3.x    — CSS 프레임워크 (SCSS 커스터마이즈)
@fortawesome/*     — 아이콘
yup                — 폼 검증 스키마
xlsx (SheetJS)     — 엑셀 내보내기
JavaScript         — TypeScript 도입 금지 (실서버 미사용)
```

**추가 금지 라이브러리**: Tailwind, Element Plus, Vuetify, Ant Design, jQuery, Moment.js, Nuxt.
**추가 시 승인 필요**: 상기 목록 외 모든 신규 의존성.

---

## 3. 디렉토리 구조 규칙

```
src/
├── api/            # 도메인별 API 모듈 (purchase.js, sales.js, basic.js ...)
│   └── client.js   # axios 인스턴스 + 인터셉터 (단일 진입점)
├── assets/
│   └── scss/       # _variables.scss (Bootstrap 오버라이드), main.scss
├── components/
│   ├── common/     # BaseTable, BaseModal, Pagination, SearchFilter, ToastHost
│   └── <domain>/   # 도메인 전용 컴포넌트
├── composables/    # usePagination, useSearchFilter, useExcelExport ...
├── layouts/        # DefaultLayout(네비게이션 포함), AuthLayout
├── router/         # index.js + 도메인별 라우트 분할
├── stores/         # user.js, toast.js, <domain>.js
├── utils/          # format.js(숫자·통화·날짜), constants.js
└── views/          # 라우트 단위 페이지 (실서버 라우트명과 1:1)
```

- 컴포넌트 파일명 **PascalCase**, composable **camelCase(use*)**, 그 외 **kebab-case**.
- 페이지 컴포넌트는 반드시 `views/` 하위, 재사용 단위만 `components/`.

---

## 4. API 연동 규약 (DRF 기준 — 반드시 준수)

1. **모든 엔드포인트는 후행 슬래시(`/`)로 끝난다.** 누락 시 Django가 301 리다이렉트하며 POST 바디가 유실된다.
2. 경로 규칙: `/api/<도메인>/<리소스>_<동작>/`
   - 도메인: `purchase`, `sales`, `product`, `customer`, `vendor`, `basic`, `common`, `location`, `ppc`
   - 동작 접미사: `_list`, `_retrieve`, `_create`, `_update`, `_delete`, `_excel_list`, `_duplicate_check`
   - 실측 예: `/api/basic/warehouse_list/`, `/api/product/product_duplicate_check/`, `/api/purchase/vendor_return/vendor_return_list_for_credit_note/`
3. **요청·응답 필드는 snake_case.** 프론트에서 camelCase로 변환하지 않는다(실서버 컨벤션 유지).
4. 목록 조회 공통 쿼리 파라미터: `keyword`, `start_date`, `end_date`, `page`, `limit`(기본 10).
5. 인증: `Authorization: Bearer <access>` → 401 발생 시 `POST /api/refresh/` 로 갱신 후 원요청 1회 재시도, 재실패 시 `/auth` 로 이동.
6. 사용자 정보: `GET /api/me/` → `user` 스토어에 적재. 권한 없는 메뉴는 `/no-access-menu`, 접근 거부는 `/forbidden`.
7. axios 인스턴스는 `src/api/client.js` **단 하나**만 둔다. 컴포넌트에서 `fetch`·`axios` 직접 호출 금지.
8. 개발 서버는 `vite.config.js`의 `server.proxy`로 `/api` → 백엔드로 프록시한다(동일 오리진 유지, CORS 회피).

---

## 5. 라우팅 규칙

- **실서버 경로명을 그대로 사용한다.** 임의 변경 금지. 주요 경로(실측):

| 구분 | 경로 |
|---|---|
| Purchasing | `/purchase-order`, `/vendor-po`(`/create/import`·`/create/local`·`/detail/import/:id`·`/detail/local/:id`), `/ppc`, `/shipment`, `/customs`, `/receipts`, `/receipts-wh`, `/import-cost`, `/vendor-return`, `/credit-note` |
| Sales | `/quotation`, `/sales-order`, `/delivery-order`, `/delivery-note`, `/delivery-note-wh` |
| Inventory | `/inventory-list`, `/inventory-adjust`, `/inventory-monthly-closing-create` |
| Partners | `/customer`, `/vendor`, `/carrier` |
| Master Data | `/warehouse`, `/location`, `/search-employee` |
| 기타 | `/dashboard`, `/report`, `/finance-cost-list`, `/finance-cost-upload`, `/setting`, `/auth`, `/change-password`, `/forbidden`, `/no-access-menu`, `/:pathMatch(.*)*` |

- 목록/상세/등록 3단 패턴: `/<resource>`, `/<resource>/:id`, `/<resource>/create`.
- 선행 문서를 선택해 생성하는 화면은 `-target` 패턴을 유지한다(예: `/sales-order-target`, `/delivery-order-target-create/:id`).
- 라우트 가드에서 토큰 유효성과 메뉴 권한을 함께 검사한다.

---

## 6. 코딩 규칙

- `<script setup>` + Composition API 고정. Options API 신규 작성 금지.
- 스타일은 `<style scoped>` 원칙. 전역 스타일은 `assets/scss/main.scss` 에만 추가.
- Bootstrap 색상·간격은 **SCSS 변수 오버라이드**로 조정하고, 컴포넌트에서 `!important` 사용 금지.
- 상태: 화면 로컬 상태는 `ref`/`reactive`, 화면 간 공유만 Pinia.
- 목록 화면은 `BaseTable` + `Pagination` + `SearchFilter` 조합을 재사용한다(화면마다 테이블 재작성 금지).
- **성능**: 라우트는 전량 `() => import(...)` 동적 임포트로 지연 로딩하고, `xlsx`는 내보내기 실행 시점에 동적 로드한다. 빌드 후 초기 청크 500 KB(gzip 전) 초과 시 보고할 것.
- 주석·커밋 메시지는 한국어. 커밋은 `feat|fix|refactor|style|docs: <내용>` 형식.

---

## 7. 화면 표기 규칙 (업무 규칙 — 예외 없음)

- 천 단위 콤마(`,`), 소수점 마침표(`.`). **인도네시아식 표기(1.234,56) 사용 금지.**
- 수량(EA/PCS/SET): 정수 — `1,200 EA`
- 단가(FOB/CIF/C&F/EXW): 소수점 둘째 자리 — `USD 84.25/EA`
- 퍼센트: 소수점 첫째 자리 고정 — `12.5%`, `3.0%`
- 중량: 소수점 첫째 자리 — `62.5 kg`
- 통화는 코드를 금액 앞에 — `USD 12,500` / `IDR 185,000,000`
- 외부 출력 문서(견적서·인보이스·정산서)는 전체 자리수 우선, 단위 병기 — `IDR 1,250,000,000 (1.25 miliar)`
- 콤마 미적용: 연도, 타이어 규격·품번(`1200R24`, `26.5R25`), 문서번호, 전화번호
- 표의 숫자는 **우측 정렬**, 동일 열은 소수 자리수 통일
- 상기 규칙은 `src/utils/format.js` 에 `formatQty`, `formatPrice`, `formatPercent`, `formatWeight`, `formatCurrency` 로 단일 구현하고, 컴포넌트에서 직접 `toLocaleString()` 호출 금지.

---

## 8. 디자인 기준

- 레이아웃·컴포넌트 골격은 Bootstrap 5 기본 구조 유지(실서버 호환).
- 색상 토큰은 사내 가이드(연한 배경 · 60-30-10)를 SCSS 변수로 오버라이드:

```scss
$body-bg:    #F0F0F0;  // 배경 60%
$primary:    #E3F2FD;  // 주요 요소 30% (Soft Blue)
$light:      #ECEFF1;  // 보조 배경 (Pastel Blue-Grey)
$success:    #E8F5E9;  // 강조 10% (Sage Green)
$body-color: #546E7A;  // 텍스트·경계선
```

- 연한 배경 위 텍스트는 `#546E7A` 로 WCAG 명도 대비를 확보한다.
- 기존 삼탄 TMS HTML 시안이 있는 화면은 해당 시안의 정보 구조(헤더·필터·테이블 순서)를 따른다.

---

## 9. 금지 사항

1. 실서버(`asm.ascendotyre.com`)에 대한 쓰기 요청(등록·수정·삭제) 코드 실행 금지. 개발은 로컬/스테이징 API로만.
2. 실서버 계정 정보, 토큰, `.env` 값을 소스나 커밋에 포함 금지. `.env.local` 사용 + `.gitignore` 확인.
3. 라우트 경로·API 경로·필드명(snake_case) 임의 변경 금지 — 백엔드 계약 위반.
4. 승인 없는 의존성 추가, 대규모 리팩터링, 파일 대량 이동 금지.

---

## 10. 완료 검증 체크리스트 (작업 종료 시 자가 점검 후 보고)

- [ ] `npm run build` 성공, 콘솔 에러·경고 0건
- [ ] `npm run dev` 에서 대상 화면 정상 렌더링, 브라우저 콘솔 에러 0건
- [ ] API 호출 전량 후행 슬래시 포함, `client.js` 경유
- [ ] 401 → refresh → 재시도 흐름 동작 확인
- [ ] 숫자·통화 표기가 §7 규칙과 일치(수량 정수 / 단가 2자리 / % 1자리)
- [ ] 목록 화면: 검색·페이지네이션·엑셀 내보내기 동작
- [ ] 반응형 1280px / 1920px 확인, 가로 스크롤 없음
- [ ] 변경 파일 목록과 사유를 요약 보고
