# CONTRIBUTING — ASM Web

이 저장소의 기준 문서는 [workOrder.md](workOrder.md) 입니다. 아래 규칙은 그 지시서를
일상 작업 단위로 옮긴 것이며, **충돌하면 workOrder.md 가 우선**합니다.

구조와 설계 판단 근거는 [ARCHITECTURE.md](ARCHITECTURE.md) 를 보십시오.

---

## 1. 시작하기

```bash
npm install
npm run dev        # http://localhost:3100
npm run build      # 프로덕션 빌드 → dist/
npm run format     # prettier 정리
```

`/api` 요청은 개발 서버가 `VITE_DEV_API_TARGET`(기본 `http://localhost:3000`)으로
프록시합니다. 동일 오리진을 유지해 CORS 를 피하는 구조이므로 이 설정을 우회하지 마십시오.

---

## 2. 승인 없이 하지 않는 것

workOrder.md §9 의 금지 사항입니다. 어기면 되돌리는 비용이 큽니다.

1. **실서버(`asm.ascendotyre.com`)에 쓰기 요청** — 등록·수정·삭제 코드 실행 금지
2. **의존성 추가·삭제** — §2 확정 스택 외 신규 패키지는 승인 대상
3. **라우트 경로 · API 경로 · 필드명 변경** — 백엔드 계약 위반
4. **대규모 리팩터링 · 파일 대량 이동**
5. **`.env` · 토큰 · 계정 정보 커밋** — `import/` 폴더도 커밋 금지

금지 라이브러리: Tailwind · Element Plus · Vuetify · Ant Design · jQuery · Moment.js ·
Nuxt · **TypeScript**.

---

## 3. 코드 규칙

- `<script setup>` + Composition API 고정. Options API 신규 작성 금지
- 스타일은 `<style scoped>` 원칙. 전역은 `assets/asm-theme.css` 에만 추가
- **색상 HEX 직접 기입 금지** — `var(--asm-*)` / `var(--bs-*)` 참조
- 컴포넌트에서 `!important` 사용 금지
- 화면 로컬 상태는 `ref`/`reactive`, 화면 간 공유만 Pinia
- 컴포넌트 PascalCase · composable `use*` camelCase · 그 외 kebab-case
- 페이지 컴포넌트는 반드시 `views/`, 재사용 단위만 `components/`
- 라우트는 전량 `() => import(...)` 지연 로딩. `xlsx` 는 내보내기 실행 시점에 동적 로드

### 숫자·날짜 표기

**컴포넌트에서 `toLocaleString()` 을 직접 부르지 마십시오.** `utils/format.js` 의 함수만
씁니다 — 사내 표기 표준(workOrder.md §7)을 한 곳에서 강제하기 위한 것입니다.

| 대상 | 함수 | 예시 |
|---|---|---|
| 수량 | `formatQty` | `1,200 EA` |
| 단가 | `formatPrice` | `USD 84.25/EA` |
| 퍼센트 | `formatPercent` | `12.5%` |
| 금액 | `formatCurrency` | `IDR 185,000,000` |
| 날짜 | `formatDate` | `2026-08-28` |

- 로케일은 **항상 `en-US`**. 인도네시아식(`1.234,56`) 금지
- 연도 · 타이어 규격(`1200R24`) · 문서번호 · 전화번호에는 콤마를 넣지 않습니다
- 표의 숫자는 우측 정렬, 같은 열은 소수 자리수 통일
- 날짜 입력은 `components/common/AsmDateInput.vue` 사용

### API 호출

- 모든 엔드포인트는 **후행 슬래시로 끝납니다.** 없으면 Django 가 301 리다이렉트하며
  POST 바디가 유실됩니다
- 요청·응답 필드는 **snake_case 그대로.** 프론트에서 camelCase 로 바꾸지 않습니다
- axios 인스턴스는 `api/client.js` **하나뿐**입니다. 컴포넌트에서 `fetch`·`axios` 직접
  호출 금지

---

## 4. 목록 화면을 추가할 때

컴포넌트를 만들지 마십시오. 정의만 추가합니다.

1. `src/data/screens/<slug>.js` 에 컬럼 · 필터 · 합계 규칙 · 행 데이터를 정의
2. `src/config/screens.js` 에 `{ slug, path, title, load }` 등록
3. `src/config/navigation.js` 의 해당 대분류 `items` 에 메뉴 항목 추가

라우트는 `screenRoutes` 에서 파생되므로 `router/index.js` 는 건드리지 않습니다.

이 틀에 맞지 않는 화면(전용 상세 드로어, 특수 편집 등)만 `components/<domain>/` 에
전용 컴포넌트로 만듭니다.

---

## 5. 주석

**한국어로 씁니다.** 무엇을 하는지가 아니라 **왜 그렇게 했는지**를 적으십시오 —
코드를 읽으면 알 수 있는 내용은 주석이 필요 없습니다.

```js
// ✗ 배경 스크롤을 잠근다
// ✓ 가림막을 덮어 둔 채 뒤쪽 목록이 같이 움직이면 닫고 났을 때 보던 자리를 잃습니다
```

기존 파일의 주석 밀도와 어투에 맞추십시오. UI 라벨은 한국어·인도네시아어 병기
(기본 인도네시아어, 토글로 한국어)이며, 개발 주체는 코드·UI 모두
**「IT부서 / Tim IT」** 로 표기합니다 — 「개발사」·「개발부서」 표기는 쓰지 않습니다.

---

## 6. 커밋

`feat|fix|refactor|style|docs|chore|ci: <내용>` 형식, 본문은 한국어.

제목은 무엇을 바꿨는지, 본문은 **왜 필요했는지와 어떤 판단을 했는지**를 적습니다.
지시서 조항을 근거로 삼았다면 조항 번호를 남기십시오.

```
fix: issue_no 유일성을 부분 UNIQUE 로 교체 (Phase 2 선행)

원본 63건 실측 결과, 작업지시서 §4-3 대로 '(삭제)' 접두를 떼면 3쌍이 충돌합니다.
삭제 후 같은 번호가 재발급된 정상 이력이므로 데이터가 아니라 제약을 고칩니다.
```

기본 브랜치는 `main` 이고, 푸시하면 GitHub Actions 가 Pages 로 배포합니다
(`npm run deploy` = `git push origin main`). **푸시 = 배포**임을 잊지 마십시오.

---

## 7. 작업 종료 전 자가 점검

workOrder.md §10 체크리스트입니다. 보고 전에 직접 확인하십시오.

- [ ] `npm run build` 성공, 경고 0건
- [ ] `npm run format` 통과 (또는 `npx prettier --check "src/**/*.{js,vue}"`)
- [ ] `npm run dev` 에서 대상 화면 정상 렌더링, 브라우저 콘솔 에러 0건
- [ ] API 호출 전량 후행 슬래시 포함, `client.js` 경유
- [ ] 숫자·통화 표기가 §7 규칙과 일치 (수량 정수 / 단가 2자리 / % 1자리)
- [ ] 목록 화면: 검색 · 페이지네이션 · 엑셀 내보내기 동작
- [ ] **1,280px / 1,920px 확인, 가로 스크롤 없음**
- [ ] 초기 청크 500 KB(gzip 전) 이하 — 초과 시 보고
- [ ] 변경 파일 목록과 사유를 요약 보고

---

## 8. CSR 모듈 (`/csr`) 작업 시

- `src/modules/csr/` 안에서만 작업합니다. **운영 화면과 컴포넌트·스토어를 공유하지
  않습니다** — 수명이 다르기 때문입니다(ARCHITECTURE.md §5)
- DB 식별자 접두사는 `csr_` 로 통일합니다
- **SQL 은 파일로만 작성하고 직접 적용하지 않습니다.** 적용은 사람이
  [docs/csr/이관절차_콘솔설정.md](docs/csr/이관절차_콘솔설정.md) 절차대로 수행합니다
- `db/*.sql` 은 트랜잭션으로 감싸고 **여러 번 실행해도 안전하게** 작성합니다
  (`IF NOT EXISTS` · `DROP POLICY IF EXISTS`)
- 권한 규칙을 바꿀 때는 **프론트 `CSR_POLICY` 와 DB 트리거를 함께** 고칩니다.
  둘이 어긋나면 UI 는 열려 있는데 저장이 실패합니다
- Notion 원본 값은 **번역·정규화하지 않습니다.** `수용 / Diterima` 같은 옵션 문자열은
  원문 그대로 저장하고, 표시 언어는 프론트에서 처리합니다
- `import/` 는 커밋하지 않습니다 (`.gitignore` 등록됨)
- Drive 이미지 URL 은 `thumbnail?id=` 를 씁니다. `uc?export=view` 는 쓰지 않습니다
- Apps Script POST 는 `Content-Type: text/plain;charset=utf-8` 입니다.
  `application/json` 을 쓰면 CORS preflight 에서 실패합니다

각 Phase 종료 시 `docs/csr/보고_Phase{n}_{YYYYMMDD}.md` 를 남기고 중단합니다 —
보고 없이 다음 Phase 로 넘어가지 않습니다.
