<script setup>
/**
 * CSR 상태 기준 — 「작업지시서: 상태 명칭 표준화(IT상태 × 현업검증)」(2026-09-10) 본문.
 *
 * 대시보드 교차표 제목 옆 링크에서 들어옵니다. 원문은 docs/csr/작업지시서_상태명칭표준화.md —
 * 두 곳을 같이 고칩니다. 정적 문서라 DB·세션을 쓰지 않습니다(로그인 없이도 열림).
 * §3 표의 배지는 지금 화면이 쓰는 톤(config.STATUS_TONE · RESULT_TONE)으로 그려
 * 문서와 화면의 색이 어긋나지 않게 합니다.
 */
import { useRouter } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { STATUS_TONE } from '../config'
import { toneOf } from '../i18n'

const router = useRouter()

const IT_STATUS = [
  ['OPEN', '접수', 'OPEN', 'Terbuka', '개선요청 접수됨, IT부서 착수 전(검토·우선순위 대기)'],
  ['ONGOING', '진행 중', 'ONGOING', 'Dalam Proses', 'IT부서가 개발·수정 진행 중, 일부 배포 가능'],
  ['COMPLETED', '조치 완료', 'COMPLETED', 'Selesai', 'IT부서 기준 조치·배포 완료, 현업 검증 대기'],
  [
    'VERIFIED',
    '검증 완료',
    'VERIFIED',
    'Terverifikasi',
    '현업 검증 통과로 최종 종결 (전환 권한: 총괄팀)',
  ],
]
const VERIFY_STATUS = [
  ['PENDING', '미검증', 'PENDING', 'Menunggu Verifikasi', '현업 검증 전 대기 상태'],
  ['NOT_APPLIED', '미조치', 'NOT APPLIED', 'Belum Diterapkan', '검증 결과 실서버에 반영 없음'],
  ['PARTIAL', '부분조치', 'PARTIAL', 'Sebagian Diterapkan', '일부만 반영, 잔여 항목 있음'],
  ['ACCEPTED', '조치확인', 'ACCEPTED', 'Diterima', '요청대로 반영됨을 현업이 확인'],
  [
    'REJECTED',
    'COMPLETED 부적정',
    'REJECTED',
    'Ditolak',
    'IT 완료 처리했으나 검증 불합격, 재작업 대상',
  ],
]
// 코드 → 화면 값. IT상태는 코드가 곧 저장값(첫 글자만 대문자), 현업검증은 한국어 값이 저장값.
const itValue = (code) => code[0] + code.slice(1).toLowerCase()
</script>

<template>
  <DefaultLayout>
    <section class="guide">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">Status Guide</h1>
          <p class="page-sub mb-0">Standar status · 상태 명칭 표준화 작업지시서</p>
        </div>
        <div class="d-flex gap-2 align-items-center">
          <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr/dashboard')">
            ← Dasbor · 대시보드
          </button>
          <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr')">
            Daftar · 목록
          </button>
        </div>
      </div>

      <article class="asm-panel doc">
        <h2 class="asm-title">작업지시서 — ASM CSR 상태 명칭 표준화 (IT상태 × 현업검증)</h2>

        <h3>1. 목적</h3>
        <ul>
          <li>
            CSR 목업 사이트(<code>/csr</code>, <code>/csr/nn</code>, 교차집계 표)의 상태 명칭을 현지
            직원과 공용 가능한 영문 코드로 통일
          </li>
          <li>
            배지·필터·표 헤더는 영문 코드 표시, 범례(legend)에서 한국어·인도네시아어·설명 병기
          </li>
        </ul>

        <h3>2. 대상 범위</h3>
        <ul>
          <li>CSR 목록 페이지(<code>/csr</code>) — 상태 배지, 필터 드롭다운, 「검증 대기」 필터</li>
          <li>CSR 상세 페이지(<code>/csr/nn</code>) — 상태 표시, 검증 이력 입력 셀렉트</li>
          <li>교차집계 표 「IT상태 × 현업검증」 — 행/열 헤더 배지</li>
          <li>
            상태 정의를 담는 상수 파일 1곳으로 집중(예: <code>src/constants/csrStatus.js</code>) —
            화면별 하드코딩 금지
          </li>
        </ul>

        <h3>3. 상태 정의 (단일 상수로 관리)</h3>

        <h4>3-1. IT상태 (세로축, IT부서 관리) — <code>itStatus</code></h4>
        <div class="table-scroll">
          <table class="table asm-table def">
            <thead>
              <tr>
                <th>code</th>
                <th>ko</th>
                <th>en</th>
                <th>id</th>
                <th>description</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="[code, ko, en, idn, desc] in IT_STATUS" :key="code">
                <td class="nowrap">
                  <span class="asm-badge" :class="`asm-badge--${STATUS_TONE[itValue(code)]}`">
                    {{ code }}
                  </span>
                </td>
                <td class="nowrap">{{ ko }}</td>
                <td class="nowrap">{{ en }}</td>
                <td class="nowrap">{{ idn }}</td>
                <td class="wrap">{{ desc }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <h4>3-2. 현업검증 (가로축, 총괄팀 관리) — <code>verifyStatus</code></h4>
        <div class="table-scroll">
          <table class="table asm-table def">
            <thead>
              <tr>
                <th>code</th>
                <th>ko</th>
                <th>en</th>
                <th>id</th>
                <th>description</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="[code, ko, en, idn, desc] in VERIFY_STATUS" :key="code">
                <td class="nowrap">
                  <span
                    class="asm-badge"
                    :class="`asm-badge--${toneOf('verification_result', ko)}`"
                  >
                    {{ code }}
                  </span>
                </td>
                <td class="nowrap">{{ ko }}</td>
                <td class="nowrap">{{ en }}</td>
                <td class="nowrap">{{ idn }}</td>
                <td class="wrap">{{ desc }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <h4>3-3. 배지 색상 (기존 톤 유지)</h4>
        <ul>
          <li>itStatus: OPEN 빨강 · ONGOING 파랑 · COMPLETED 초록 · VERIFIED 남색/회청</li>
          <li>
            verifyStatus: PENDING 회색 · NOT_APPLIED 빨강 · PARTIAL 노랑 · ACCEPTED 초록 · REJECTED
            빨강(테두리 강조)
          </li>
        </ul>

        <h3>4. 구현 요구사항</h3>
        <ul>
          <li>
            기존 한국어 값 → 신규 code 매핑 함수 작성(<code>mapLegacyVerifyStatus</code>), 저장
            데이터는 code로 통일
            <ul>
              <li>
                미검증→PENDING, 미조치→NOT_APPLIED, 부분조치→PARTIAL, 조치확인→ACCEPTED, COMPLETED
                부적정→REJECTED
              </li>
            </ul>
          </li>
          <li>배지 라벨 = <code>en</code>, 마우스오버 툴팁 = <code>ko / id — description</code></li>
          <li>
            교차집계 표 상단 또는 하단에 범례 섹션 추가 — 두 축 각각 4열
            표(한국어·영문·인도네시아어·설명)
          </li>
          <li>
            필터 옵션 라벨 = <code>en (ko)</code> 형식, 「검증 대기」 필터 정의 유지:
            <code>itStatus = COMPLETED AND verifyStatus ≠ ACCEPTED/REJECTED 미확정 상태</code> →
            실제로는 <code>itStatus = COMPLETED AND itStatus ≠ VERIFIED</code> 기존 로직 그대로
          </li>
          <li>
            전환 규칙 안내 문구를 범례 하단에 표기(3개 언어)
            <ul>
              <li>COMPLETED + ACCEPTED → VERIFIED 전환(총괄팀)</li>
              <li>COMPLETED + REJECTED → ONGOING으로 되돌림(IT부서)</li>
            </ul>
          </li>
          <li>
            데이터 정의(Neon 스키마·노션 동기화 로직)는 변경하지 않음 — 표시 계층만 수정, 필요 시
            매핑 함수로 흡수
          </li>
        </ul>

        <h3>5. 제외 사항</h3>
        <ul>
          <li>노션 CSR DB 속성명 변경 금지</li>
          <li>IT상태 코드값(OPEN/ONGOING/COMPLETED/VERIFIED) 변경 금지</li>
          <li>디자인 개편 금지 — 명칭·범례·툴팁만 추가</li>
        </ul>

        <h3>6. 완료 기준</h3>
        <ul>
          <li><code>/csr</code> 목록 60건 전부 신규 코드 배지로 표시, 한국어 배지 잔존 0건</li>
          <li>교차집계 표 합계 60건 및 각 셀 수치가 변경 전과 동일</li>
          <li>필터·검증 이력 셀렉트에서 5개 verifyStatus 모두 선택·저장 가능</li>
          <li>범례 표 2개(IT상태 4행·현업검증 5행) 및 전환 규칙 문구 3개 언어 표시 확인</li>
          <li>변경 파일 목록과 스크린샷(목록·상세·교차표) 첨부하여 보고</li>
        </ul>
      </article>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.guide {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.doc {
  padding: 20px 24px;
  font-size: 14px;
  line-height: 1.6;
}
.doc h2 {
  margin: 0 0 16px;
}
.doc h3 {
  font-size: 15px;
  font-weight: 700;
  margin: 20px 0 8px;
}
.doc h4 {
  font-size: 13px;
  font-weight: 700;
  color: var(--asm-fg-muted);
  margin: 14px 0 6px;
}
.doc ul {
  margin: 0 0 4px;
  padding-left: 20px;
}
.doc ul ul {
  margin-top: 2px;
}
.doc code {
  font-size: 12.5px;
  background: var(--asm-muted-20);
  padding: 1px 5px;
  border-radius: var(--asm-radius-sm);
}
.table-scroll {
  overflow-x: auto;
}
.def th,
.def td {
  vertical-align: top;
}
.def td.wrap {
  white-space: normal;
  overflow-wrap: anywhere;
  min-width: 260px;
}
</style>
