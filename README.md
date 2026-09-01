# ASM Web (Vue 3)

PT ASCENDO INTERNASIONAL — **ASM(Ascendo Management System)** 웹 클라이언트.
기존 React 19 + shadcn/Tailwind 클라이언트(`asm-web/apps/client`)를 **Vue 3 + Vite + Bootstrap 5.3**으로 이관한 결과물입니다.

---

## 1. 기술 스택 (Tech stack / Tumpukan teknologi)

| 항목 | 이전 (React) | 현재 (Vue) |
|---|---|---|
| 프레임워크 | React 19 | **Vue 3.5** (`<script setup>` · JavaScript) |
| 번들러 | rolldown-vite 7 | **Vite 6** |
| HTTP | fetch | **axios** (단일 인스턴스 + JWT 인터셉터) |
| 폼 검증 | zod | **yup** |
| 엑셀 | 수기 CSV | **SheetJS(xlsx)** · 실행 시점 동적 로딩 |
| 라우팅 | react-router-dom 6 | **vue-router 4** |
| 상태관리 | useState / zustand | **Pinia 3** |
| UI | shadcn/ui + Tailwind v4 | **Bootstrap 5.3 + ASM 디자인 토큰** |
| 아이콘 | lucide-react | **Font Awesome** (`@fortawesome/vue-fontawesome`) |
| 토스트 | sonner | **vue-sonner** |
| 인증 | better-auth/react | **better-auth/vue** |

> 서버(`asm-web/apps/server`, Hono + Better Auth)는 **변경하지 않았습니다.** 프레임워크 무관 구조이며 API 계약(`{ ok, data }`)도 그대로 유지합니다.

---

## 2. 실행 방법 (Getting started)

```bash
npm install
cp .env.example .env      # API 주소 설정
npm run dev               # http://localhost:3100
npm run build             # 프로덕션 빌드 → dist/
npm run format            # prettier 정리
npm run preview           # 빌드 결과 확인
```

`/api` 요청은 개발 서버에서 `VITE_DEV_API_TARGET`(기본 `http://localhost:3000`)으로 프록시됩니다.
운영에서는 배포 파이프라인이 `public/app-config.js`에 실제 API 주소를 주입합니다.

---

## 3. 디렉터리 구조

```
src/
├─ api/                      HTTP 계층 (작업지시서 §4)
│  ├─ client.js              axios 단일 인스턴스 — 트레일링 슬래시·Bearer·401 refresh 재시도
│  ├─ api-base.js            API base URL 결정 (빌드타임 > 런타임 > same-origin)
│  ├─ api.js · api-error.js  레거시 fetch 헬퍼 + 서버 오류 정규화
│  └─ auth.js                Better Auth 클라이언트 + Bearer 토큰 저장
├─ assets/asm-theme.css      ASM 디자인 토큰 + Bootstrap 5.3 오버라이드 (단일 진실 원천)
├─ components/
│  ├─ common/                AsmBadge · SummaryCard · SortableHeader · ListScreen · AsmDateInput
│  ├─ purchase-po/           PoFilterPanel · PoTable · PoDetailDrawer · NewPoDialog
│  └─ inventory/             InventoryFilterPanel · InventoryTable
├─ composables/              useBodyScrollLock · useEscapeToClose · useExcelExport
├─ config/
│  ├─ navigation.js          상단/사이드 메뉴 정의 (개선의견서 목차 기준)
│  └─ screens.js             목록 화면 레지스트리 (28종 · 동적 import)
├─ data/                     프로토타입 시드 데이터 (운영 전환 시 삭제)
│  ├─ purchase-orders.js · inventory.js
│  └─ screens/               목록 화면 28종 정의 + 예시 데이터
├─ layouts/                  DefaultLayout · AppTopbar · AppSidebar
├─ plugins/icons.js          Font Awesome 전역 아이콘 등록 (이름 → 아이콘 매핑 단일 지점)
├─ router/index.ts           라우트 (실서버 경로명 사용 · 지시서 §5)
├─ stores/                   purchase-po · inventory · session (Pinia)
├─ types/                    purchase-po.js · inventory.js · list-screen.js (상태·배지 상수)
├─ utils/format.js           사내 숫자 표기 표준 (아래 4항)
└─ views/                    라우트 단위 페이지 (PurchasePoPage · InventoryListPage · ListScreenPage · AuthPage · NotFoundPage)
```

---

## 4. 숫자 표기 규칙 (`src/lib/format.ts`)

사내 표준을 코드로 강제했습니다. **화면에서 숫자를 직접 문자열로 만들지 말고 반드시 이 함수를 사용하세요.**

| 함수 | 용도 | 출력 예시 |
|---|---|---|
| `formatInt` | 기본 정수 + 천 단위 콤마 | `1,250,000` |
| `formatQty` | 수량 (항상 정수) | `1,200 EA` |
| `formatPercent` | 퍼센트 (소수점 1자리 고정) | `12.5%` · `3.0%` |
| `formatWeight` | 중량 (소수점 1자리) | `62.5 kg` |
| `formatUnitPrice` = `formatPrice` | 구매단가 (소수점 2자리) | `USD 84.25/EA` |
| `formatAmount` = `formatCurrency` | 금액 (IDR 정수 / USD 2자리) | `IDR 185,000,000` |
| `formatIdrShort` | 사내 요약용 단위 표기 | `IDR 1.25 miliar` |
| `formatIdrFull` | **대외 문서용** 전체 자리수 + 단위 병기 | `IDR 1,250,000,000 (1.25 miliar)` |
| `formatDecimal` | 통화코드가 열 제목에 있는 표의 소수 | `84.25` |
| `formatSigned` | 증감 (양수에 + 표기) | `+120` · `-35` |
| `formatDate` | YYYY-MM-DD (ISO 8601) | `2026-08-28` |

- 로케일은 **항상 `en-US`** 로 고정 — 인도네시아식 표기(`1.234,56`)는 사용하지 않습니다.
- 견적서·인보이스·계약서 등 대외 발송 문서에는 `formatIdrFull()` 을 사용하십시오 (소수점 오독 방지 필수 규칙).
- 연도·타이어 규격(1200R24)·문서번호에는 콤마를 넣지 않습니다.
- 날짜는 **YYYY-MM-DD 고정** — 브라우저 언어 설정에 따라 표기가 흔들리지 않도록 화면 표시는 `formatDate()`,
  입력은 `components/common/AsmDateInput.vue` 를 사용합니다 (디자인가이드 8-2 · 개선의견서 이슈 15).

> ⚠️ 현재 운영 ASM 화면이 인도네시아식(`756.704.706`)으로 출력되는 건은 이 모듈로 전환하면 함께 해소됩니다.

---

## 5. 디자인 토큰

`src/assets/asm-theme.css` 한 곳에서만 색상을 정의합니다. **컴포넌트에서 HEX 직접 기입 금지** — `var(--asm-*)` / `var(--bs-*)` 참조 원칙.

| 토큰 | 값 | 용도 |
|---|---|---|
| `--asm-primary` | `#00306E` | 브랜드 · 주요 버튼 |
| `--asm-primary-hover` | `#004085` | hover |
| `--asm-fg` / `--asm-fg-muted` | `#08121F` / `#5C646F` | 본문 / 보조 텍스트 |
| `--asm-border` | `#D3D8DE` | 테두리 · 구분선 |
| `--asm-sidebar` / `--asm-sidebar-active` | `#F2F5F9` / `#DEE5EF` | 사이드바 |
| `--asm-page-bg` | `#FFFFFF` | 본문 영역 배경 (가이드 6-1) |
| 상태 배지 | info/success/warning/danger/neutral 5종 | `.asm-badge--*` |

출처: `ASM_디자인가이드_삼탄TMS기준_v1.0.html` (삼탄 TMS 기준). 다크 모드는 1차 적용 범위에서 제외했으나 변수 구조는 확장 가능하게 유지했습니다.

---

## 6. 인증 (Authentication)

`AuthPage.vue` 는 React 원본의 4가지 계약을 그대로 유지합니다.

1. **3-상태 세션 판정** — 세션 확인(loading)이 끝나기 전에 판단하지 않음
2. **역방향 가드** — 이미 로그인된 사용자는 로그인 화면에 머무르지 않음
3. **라우터 이동** — 성공 시 `router.replace()`. `window.location.reload()` 금지
4. **외부 인증 후 세션 갱신** — `verify-code` 후 반드시 세션 refetch

라우트 보호는 `router/index.ts` 의 `meta.requiresAuth` 로 켭니다.

```ts
{ path: '/purchase-po', component: ..., meta: { requiresAuth: true } }
```

---

## 7. 이관 범위 및 잔여 작업

**완료**

- Purchase PO 화면 전체 (요약 카드 · 필터 · 정렬/페이징 테이블 · 상세 드로어 · 신규 등록 다이얼로그 · CSV 내보내기)
- Inventory List 화면 (운영 ASM `asminventorylist.html` 복제 · KPI 4종 · 필터 · 정렬/페이징 테이블 + 합계 행 · CSV/Print)
- 목록 화면 28종 — 메뉴 구성·명칭은 **개선의견서(실서버 테스트 결과)의 목차** 기준.
  Purchasing 9 (Payment Plan 신설) · Sales 5 · Inventory 1 (Monthly Closing 신설) · Partners 2 ·
  Master Data 3 · Settings 1 · 시안 전용 7(MOCK-UP 그룹, 운영 ASM 메뉴 외).
  `ListScreen` 하나가 검색·기간필터·정렬·페이징·합계·CSV 를 처리하고 화면별 컬럼·데이터만 `data/screens/` 에 둡니다
- 레이아웃(상단바 · 접이식 사이드바 · 모바일 오프캔버스), 404, 로그인/가입/이메일 인증
- API·인증 레이어, 숫자 표기 표준 모듈
- 작업지시서(workOrder.md) §2~§7 정합 — JavaScript 전환 · axios 계층 · 실서버 경로 · SheetJS · yup · Font Awesome
- 프로덕션 빌드 통과 (초기 청크 109 KB gzip · 기준 500 KB)

**잔여 작업 (Next steps)**

1. **API 연동** — `stores/purchase-po.ts` 의 시드 데이터를 `GET /api/purchase-orders` 호출로 교체 (화면 코드 수정 불필요)
2. 신규 PO 저장을 `POST /api/purchase-orders` 로 연결 (현재는 클라이언트 상태에만 반영)
3. Inventory 데이터 연동 — `stores/inventory.ts` 시드를 `GET /api/inventory` 로 교체
   (목록 화면 28종은 `data/screens/*.ts` 의 rows 를 각 API 결과로 교체하면 화면 수정 없이 동작)
4. 남은 메뉴 화면 — Delivery Note (Warehouse) · Upload Monthly Closing Data · Change Password (현재는 안내 토스트만 표시)
5. 서버 사이드 페이징/정렬 (데이터 1,000건 초과 시 필요)
6. 로그인 필수화 여부 결정 → `meta.requiresAuth: true` 적용
7. 단위 테스트(Vitest + @vue/test-utils) 도입 — 우선순위: `lib/format.ts`, `stores/*.ts`

**미이관 (의도적 제외)**

- Lovable/Skywork 전용 스캐폴드(`lovable-tagger`, `react-router-dom-proxy`, prerender, CDN 이미지 리라이터)
- 미사용 shadcn/ui 컴포넌트 49종 — Bootstrap 5.3 으로 대체
