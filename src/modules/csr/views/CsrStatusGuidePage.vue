<script setup>
/**
 * CSR 상태 기준 — 「작업지시서: 상태 명칭 표준화(IT상태 × 현업검증)」(2026-09-10) 본문.
 *
 * 대시보드 교차표 제목 옆 링크에서 들어옵니다. 원문은 docs/csr/작업지시서_상태명칭표준화.md —
 * 원문은 그대로 두고, 이 화면은 읽는 사람 순서(상태 정의 → 전환 규칙 → 작업지시서 상세 접힘)로
 * 재배열하며 낡은 수치(60건)·자기모순 문장은 정리했습니다. 정적 문서라 DB 를 쓰지 않습니다(로그인 없이도 열림).
 *
 * 본문은 **토글 언어 한쪽만** 보여 줍니다(2026-09-11 「범례 분리」 · 2026-09-14 「작업지시서 페이지도 분리」).
 * 그래서 문단마다 [한국어, 인도네시아어] 쌍으로 적어 둡니다 — 한쪽을 고치면 다른 쪽도 같이 고치십시오.
 * 인니어는 Claude 번역(검수 서종환). 상태 정의 표는 status.js 의 정의를 그대로 그려 문서와 화면이 어긋나지 않게 합니다.
 */
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useCsrLang } from '../composables/useCsrLang'
import { IT_STATUS, VERIFY_STATUS } from '../status'
import CsrStatusDefTable from '../components/CsrStatusDefTable.vue'

const { lang, tp: t } = useCsrLang()
/** 백틱으로 감싼 조각은 <code> 로 — 문장마다 태그를 섞지 않으려고 문자열 한 줄로 적습니다. */
const parts = (s) => s.split('`').map((x, i) => ({ code: i % 2 === 1, text: x }))
const plain = (s) => s.replace(/`/g, '')

// 표 4행·5행 — 정의는 status.js(작업지시서 v1.1 §C: 상수 1곳). On Hold · N/A 는 표준 4단계가 아니라 제외.
const IT_ROWS = IT_STATUS.filter((s) =>
  ['Open', 'Ongoing', 'Completed', 'Verified'].includes(s.value),
)

const TITLE = [
  'ASM CSR 상태 기준 (IT상태 × 현업검증)',
  'Standar Status CSR ASM (Status IT × Hasil Verifikasi)',
]

/** 목적 — 표 앞에 짧게 */
const LEAD = [
  {
    h: ['목적', 'Tujuan'],
    items: [
      {
        t: [
          'CSR 화면(`/csr`, `/csr/nn`, 교차집계 표)의 상태 명칭을 현지 직원과 함께 쓸 수 있는 영문 코드로 통일',
          'Menyeragamkan nama status pada layar CSR (`/csr`, `/csr/nn`, tabel silang) menjadi kode bahasa Inggris yang dapat dipakai bersama staf lokal',
        ],
      },
      {
        t: [
          '배지·필터·표 헤더는 영문 코드 표시, 범례(legend)에서 한국어·인도네시아어·설명 병기',
          'Badge · filter · header tabel menampilkan kode bahasa Inggris; nama bahasa Korea · Indonesia dan keterangan disertakan pada legenda',
        ],
      },
    ],
  },
]

/** 상태 정의 소제목 · 색상 규칙 · 전환 규칙 */
const SEC3 = {
  h: ['상태 정의', 'Definisi Status'],
  h31: [
    'IT상태 (세로축, IT부서 관리) — `itStatus`',
    'Status IT (sumbu vertikal, dikelola Tim IT) — `itStatus`',
  ],
  h32: [
    '현업검증 (가로축, 총괄팀 관리) — `verifyStatus`',
    'Hasil Verifikasi (sumbu horizontal, dikelola Tim Umum) — `verifyStatus`',
  ],
  h33: ['배지 색상 (기존 톤 유지)', 'Warna Badge (mempertahankan tone yang ada)'],
  tones: [
    {
      t: [
        'itStatus: OPEN 빨강 · ONGOING 파랑 · COMPLETED 초록 · VERIFIED 남색/회청',
        'itStatus: OPEN merah · ONGOING biru · COMPLETED hijau · VERIFIED biru tua/abu kebiruan',
      ],
    },
    {
      t: [
        'verifyStatus: PENDING 회색 · NOT APPLIED 빨강 · PARTIAL 노랑 · ACCEPTED 초록 · REJECTED 주황 (v1.1 §C-2 에서 주황으로 확정)',
        'verifyStatus: PENDING abu-abu · NOT APPLIED merah · PARTIAL kuning · ACCEPTED hijau · REJECTED oranye (ditetapkan oranye pada v1.1 §C-2)',
      ],
    },
  ],
  trans: {
    h: ['전환 규칙', 'Aturan Transisi'],
    items: [
      [
        'COMPLETED + ACCEPTED → VERIFIED 전환 (총괄팀)',
        'COMPLETED + ACCEPTED → beralih ke VERIFIED (Tim Umum)',
      ],
      [
        'COMPLETED + REJECTED → ONGOING 으로 되돌림 (IT부서)',
        'COMPLETED + REJECTED → dikembalikan ke ONGOING (Tim IT)',
      ],
    ],
  },
  cols: {
    code: ['Code', 'Code'],
    name: ['한국어', 'Bahasa Indonesia'],
    desc: ['설명', 'Keterangan'],
  },
}

/** 작업지시서 상세 — 기본 접힘. §2 대상 범위 · §4 구현 요구사항 · §5 제외 사항 · §6 완료 기준 */
const FOLD_SECTIONS = [
  {
    h: ['대상 범위 (작업지시서 §2)', 'Ruang Lingkup (Instruksi Kerja §2)'],
    items: [
      {
        t: [
          'CSR 목록 페이지(`/csr`) — 상태 배지, 필터 드롭다운, 「검증 대기」 필터',
          'Halaman daftar CSR (`/csr`) — badge status, dropdown filter, filter 「menunggu verifikasi」',
        ],
      },
      {
        t: [
          'CSR 상세 페이지(`/csr/nn`) — 상태 표시, 검증 이력 입력 셀렉트',
          'Halaman detail CSR (`/csr/nn`) — tampilan status, select input riwayat verifikasi',
        ],
      },
      {
        t: [
          '교차집계 표 「IT상태 × 현업검증」 — 행/열 헤더 배지',
          'Tabel silang 「Status IT × Hasil Verifikasi」 — badge header baris/kolom',
        ],
      },
      {
        t: [
          '상태 정의를 담는 상수 파일 1곳으로 집중(예: `src/constants/csrStatus.js`) — 화면별 하드코딩 금지',
          'Definisi status dipusatkan pada satu berkas konstanta (mis. `src/constants/csrStatus.js`) — dilarang hardcode per layar',
        ],
      },
    ],
  },
  {
    h: ['구현 요구사항 (작업지시서 §4)', 'Persyaratan Implementasi (Instruksi Kerja §4)'],
    items: [
      {
        t: [
          '기존 한국어 값 → 신규 code 매핑 함수 작성(`mapLegacyVerifyStatus`), 저장 데이터는 code 로 통일',
          'Buat fungsi pemetaan nilai bahasa Korea lama → kode baru (`mapLegacyVerifyStatus`); data yang disimpan diseragamkan ke kode',
        ],
        sub: [
          [
            '미검증→PENDING, 미조치→NOT APPLIED, 부분조치→PARTIAL, 조치확인→ACCEPTED, COMPLETED 부적정→REJECTED',
            'Belum diverifikasi→PENDING, belum ditindaklanjuti→NOT APPLIED, sebagian→PARTIAL, terkonfirmasi→ACCEPTED, Completed tidak sesuai→REJECTED',
          ],
        ],
      },
      {
        t: [
          '배지 라벨 = `en`, 마우스오버 툴팁 = `ko / id — description`',
          'Label badge = `en`, tooltip saat kursor di atasnya = `ko / id — description`',
        ],
      },
      {
        t: [
          '교차집계 표 상단 또는 하단에 범례 섹션 추가 — 두 축 각각 4열 표(한국어·영문·인도네시아어·설명)',
          'Tambahkan bagian legenda di atas atau di bawah tabel silang — tabel 4 kolom untuk masing-masing sumbu (bahasa Korea · Inggris · Indonesia · keterangan)',
        ],
      },
      {
        t: [
          '필터 옵션 라벨 = `en (ko)` 형식, 「검증 대기」 필터 정의는 기존 그대로: `itStatus = COMPLETED AND itStatus ≠ VERIFIED`',
          'Label opsi filter = format `en (ko)`; definisi filter 「menunggu verifikasi」 tetap seperti semula: `itStatus = COMPLETED AND itStatus ≠ VERIFIED`',
        ],
      },
      {
        t: [
          '전환 규칙 안내 문구를 범례 하단에 표기(위 「전환 규칙」 참조)',
          'Cantumkan keterangan aturan transisi di bawah legenda (lihat 「Aturan Transisi」 di atas)',
        ],
      },
      {
        t: [
          '데이터 정의(Neon 스키마·노션 동기화 로직)는 변경하지 않음 — 표시 계층만 수정, 필요 시 매핑 함수로 흡수',
          'Definisi data (skema Neon · logika sinkronisasi Notion) tidak diubah — hanya lapisan tampilan yang disesuaikan, bila perlu diserap oleh fungsi pemetaan',
        ],
      },
    ],
  },
  {
    h: ['제외 사항 (작업지시서 §5)', 'Di Luar Lingkup (Instruksi Kerja §5)'],
    items: [
      {
        t: ['노션 CSR DB 속성명 변경 금지', 'Dilarang mengubah nama properti DB CSR di Notion'],
      },
      {
        t: [
          'IT상태 코드값(OPEN/ONGOING/COMPLETED/VERIFIED) 변경 금지',
          'Dilarang mengubah nilai kode Status IT (OPEN/ONGOING/COMPLETED/VERIFIED)',
        ],
      },
      {
        t: [
          '화면 구조·스타일은 그대로 두고 명칭·범례·툴팁만 추가',
          'Struktur dan gaya tampilan tidak diubah — hanya menambah nama · legenda · tooltip',
        ],
      },
    ],
  },
  {
    h: ['완료 기준 (작업지시서 §6)', 'Kriteria Selesai (Instruksi Kerja §6)'],
    items: [
      {
        t: [
          '`/csr` 목록 전체 건이 신규 코드 배지로 표시, 한국어 배지 잔존 0건',
          'Semua item pada daftar `/csr` tampil dengan badge kode baru, badge bahasa Korea tersisa 0',
        ],
      },
      {
        t: [
          '교차집계 표 합계(= 목록 전체 건수) 및 각 셀 수치가 변경 전과 동일',
          'Total tabel silang (= jumlah seluruh item daftar) dan angka tiap sel sama seperti sebelum perubahan',
        ],
      },
      {
        t: [
          '필터·검증 이력 셀렉트에서 5개 verifyStatus 모두 선택·저장 가능',
          'Kelima verifyStatus dapat dipilih · disimpan pada filter dan select riwayat verifikasi',
        ],
      },
      {
        t: [
          '범례 표 2개(IT상태 4행·현업검증 5행) 및 전환 규칙 문구 표시 확인',
          'Dua tabel legenda (Status IT 4 baris · Hasil Verifikasi 5 baris) dan keterangan aturan transisi tampil',
        ],
      },
      {
        t: [
          '변경 파일 목록과 스크린샷(목록·상세·교차표) 첨부하여 보고',
          'Laporkan dengan lampiran daftar berkas yang diubah dan tangkapan layar (daftar · detail · tabel silang)',
        ],
      },
    ],
  },
]
</script>

<template>
  <DefaultLayout>
    <section class="guide" :lang="lang">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">Status Guide</h1>
          <p class="page-sub mb-0">
            {{ t(['상태 명칭 표준화 작업지시서', 'Instruksi kerja standardisasi nama status']) }}
          </p>
        </div>
        <div class="d-flex gap-2 align-items-center">
          <router-link to="/csr/dashboard" class="btn btn-sm btn-link">
            ← {{ t(['대시보드', 'Dasbor']) }}
          </router-link>
          <router-link to="/csr" class="btn btn-sm btn-link">
            {{ t(['개선요청 목록', 'Daftar permintaan']) }}
          </router-link>
        </div>
      </div>

      <article class="asm-panel doc">
        <h2 class="asm-title">{{ t(TITLE) }}</h2>

        <template v-for="sec in LEAD" :key="sec.h[0]">
          <h3>{{ t(sec.h) }}</h3>
          <ul>
            <li v-for="(it, i) in sec.items" :key="i">
              <template v-for="(seg, k) in parts(t(it.t))" :key="k"
                ><code v-if="seg.code">{{ seg.text }}</code
                ><template v-else>{{ seg.text }}</template></template
              >
            </li>
          </ul>
        </template>

        <!-- 상태 정의 — 표는 status.js 정의, 이름·설명은 토글 언어 -->
        <h3>{{ t(SEC3.h) }}</h3>

        <h4>
          <template v-for="(seg, k) in parts(t(SEC3.h31))" :key="k"
            ><code v-if="seg.code">{{ seg.text }}</code
            ><template v-else>{{ seg.text }}</template></template
          >
        </h4>
        <div class="table-scroll" tabindex="0" role="region" :aria-label="plain(t(SEC3.h31))">
          <CsrStatusDefTable
            :rows="IT_ROWS"
            :lang="lang"
            :code-label="t(SEC3.cols.code)"
            :name-label="t(SEC3.cols.name)"
            :desc-label="t(SEC3.cols.desc)"
            wrap-min-width="260px"
          />
        </div>

        <h4>
          <template v-for="(seg, k) in parts(t(SEC3.h32))" :key="k"
            ><code v-if="seg.code">{{ seg.text }}</code
            ><template v-else>{{ seg.text }}</template></template
          >
        </h4>
        <div class="table-scroll" tabindex="0" role="region" :aria-label="plain(t(SEC3.h32))">
          <CsrStatusDefTable
            :rows="VERIFY_STATUS"
            :lang="lang"
            :code-label="t(SEC3.cols.code)"
            :name-label="t(SEC3.cols.name)"
            :desc-label="t(SEC3.cols.desc)"
            wrap-min-width="260px"
          />
        </div>

        <h4>{{ t(SEC3.h33) }}</h4>
        <ul>
          <li v-for="(it, i) in SEC3.tones" :key="i">{{ t(it.t) }}</li>
        </ul>

        <h3>{{ t(SEC3.trans.h) }}</h3>
        <ul>
          <li v-for="(it, i) in SEC3.trans.items" :key="i">{{ t(it) }}</li>
        </ul>

        <!-- 작업지시서 상세 — 기본 접힘 -->
        <h3 class="fold-title">{{ t(['작업지시서 상세', 'Rincian Instruksi Kerja']) }}</h3>
        <details v-for="sec in FOLD_SECTIONS" :key="sec.h[0]" class="fold">
          <summary>{{ t(sec.h) }}</summary>
          <ul>
            <li v-for="(it, i) in sec.items" :key="i">
              <template v-for="(seg, k) in parts(t(it.t))" :key="k"
                ><code v-if="seg.code">{{ seg.text }}</code
                ><template v-else>{{ seg.text }}</template></template
              >
              <ul v-if="it.sub">
                <li v-for="(s, j) in it.sub" :key="j">{{ t(s) }}</li>
              </ul>
            </li>
          </ul>
        </details>
      </article>
    </section>
  </DefaultLayout>
</template>

<style scoped>
/* 제목줄과 카드를 같은 960px 열에 넣어 화면 가운데에 둡니다(카드만 960px 이고 제목줄은 전체 폭이라 어긋나던 것). */
.guide {
  display: flex;
  flex-direction: column;
  gap: 16px;
  width: 100%;
  max-width: 960px;
  margin-inline: auto;
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
  font-variant-numeric: tabular-nums;
}
.doc h2 {
  margin: 0 0 16px;
}
.doc h3 {
  font-size: 1.125rem;
  font-weight: 700;
  margin: 24px 0 8px;
}
.doc h4 {
  font-size: 14px;
  font-weight: 700;
  color: var(--asm-fg);
  margin: 16px 0 8px;
}
/* 점(•) 목록은 어디서나 같은 폭(24px)만큼 안쪽으로 들입니다 — 제목·문단보다 한 단계 안. 중첩 목록은 부모를 따릅니다. */
.doc ul {
  margin: 0 0 4px 24px;
  padding-left: 20px;
  max-width: 72ch;
}
.doc ul ul {
  margin: 2px 0 0;
}
.doc code {
  font-family: inherit;
  font-size: 13px;
  color: var(--asm-fg);
  background: var(--asm-muted-20);
  padding: 1px 5px;
  border-radius: var(--asm-radius-sm);
}
.table-scroll:focus-visible,
.fold summary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
.fold-title {
  padding-top: 16px;
  border-top: 1px solid var(--asm-border);
}
.fold {
  border-bottom: 1px solid var(--asm-border);
}
.fold summary {
  cursor: pointer;
  padding: 10px 4px;
  font-weight: 700;
  border-radius: var(--asm-radius-sm);
}
.fold[open] summary {
  color: var(--asm-primary);
}
/* 펼친 본문은 ▼ 마커보다 안쪽으로 들여 요약줄의 하위임을 보입니다(마커 폭 + 요약 안쪽 여백 ≈ 24px).
   목록은 위의 `.doc ul` 이 이미 24px 들이므로 여기서 빼서 이중 들여쓰기를 막습니다. */
.fold > :not(summary):not(ul) {
  margin-left: 24px;
}
.fold ul {
  padding-bottom: 8px;
}
</style>
