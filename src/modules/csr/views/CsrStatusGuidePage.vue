<script setup>
/**
 * CSR 상태 기준 — 「작업지시서: 상태 명칭 표준화(IT상태 × 현업검증)」(2026-09-10) 본문.
 *
 * 대시보드 교차표 제목 옆 링크에서 들어옵니다. 원문은 docs/csr/작업지시서_상태명칭표준화.md —
 * 두 곳을 같이 고칩니다. 정적 문서라 DB 를 쓰지 않습니다(로그인 없이도 열림).
 *
 * 본문은 **토글 언어 한쪽만** 보여 줍니다(2026-09-11 「범례 분리」 · 2026-09-14 「작업지시서 페이지도 분리」).
 * 그래서 문단마다 [한국어, 인도네시아어] 쌍으로 적어 둡니다 — 한쪽을 고치면 다른 쪽도 같이 고치십시오.
 * 인니어는 Claude 번역(검수 서종환). §3 표는 status.js 의 정의를 그대로 그려 문서와 화면이 어긋나지 않게 합니다.
 */
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useIdentityStore } from '@/stores/identity'
import { IT_STATUS, VERIFY_STATUS, descOf, nameOf } from '../status'

const router = useRouter()
const identity = useIdentityStore()
const lang = computed(() => identity.lang)
/** [ko, id] 쌍에서 토글 언어 쪽. */
const t = (pair) => (lang.value === 'id' ? pair[1] : pair[0])
/** 백틱으로 감싼 조각은 <code> 로 — 문장마다 태그를 섞지 않으려고 문자열 한 줄로 적습니다. */
const parts = (s) => s.split('`').map((x, i) => ({ code: i % 2 === 1, text: x }))

// 표 4행·5행 — 정의는 status.js(작업지시서 v1.1 §C: 상수 1곳). On Hold · N/A 는 표준 4단계가 아니라 제외.
const IT_ROWS = IT_STATUS.filter((s) =>
  ['Open', 'Ongoing', 'Completed', 'Verified'].includes(s.value),
)

const TITLE = [
  '작업지시서 — ASM CSR 상태 명칭 표준화 (IT상태 × 현업검증)',
  'Instruksi Kerja — Standardisasi Nama Status CSR ASM (Status IT × Hasil Verifikasi)',
]

/** §1 · §2 — 표 앞 절 */
const HEAD_SECTIONS = [
  {
    h: ['1. 목적', '1. Tujuan'],
    items: [
      {
        t: [
          'CSR 목업 사이트(`/csr`, `/csr/nn`, 교차집계 표)의 상태 명칭을 현지 직원과 공용 가능한 영문 코드로 통일',
          'Menyeragamkan nama status pada situs mock-up CSR (`/csr`, `/csr/nn`, tabel silang) menjadi kode bahasa Inggris yang dapat dipakai bersama staf lokal',
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
  {
    h: ['2. 대상 범위', '2. Ruang Lingkup'],
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
]

/** §3 소제목 · 색상 규칙 */
const SEC3 = {
  h: ['3. 상태 정의 (단일 상수로 관리)', '3. Definisi Status (dikelola sebagai satu konstanta)'],
  h31: [
    '3-1. IT상태 (세로축, IT부서 관리) — `itStatus`',
    '3-1. Status IT (sumbu vertikal, dikelola Tim IT) — `itStatus`',
  ],
  h32: [
    '3-2. 현업검증 (가로축, 총괄팀 관리) — `verifyStatus`',
    '3-2. Hasil Verifikasi (sumbu horizontal, dikelola Tim Umum) — `verifyStatus`',
  ],
  h33: ['3-3. 배지 색상 (기존 톤 유지)', '3-3. Warna Badge (mempertahankan tone yang ada)'],
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
  cols: {
    code: ['Code', 'Code'],
    name: ['한국어', 'Bahasa Indonesia'],
    desc: ['설명', 'Keterangan'],
  },
}

/** §4 · §5 · §6 — 표 뒤 절 */
const TAIL_SECTIONS = [
  {
    h: ['4. 구현 요구사항', '4. Persyaratan Implementasi'],
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
          '필터 옵션 라벨 = `en (ko)` 형식, 「검증 대기」 필터 정의 유지: `itStatus = COMPLETED AND verifyStatus ≠ ACCEPTED/REJECTED 미확정 상태` → 실제로는 `itStatus = COMPLETED AND itStatus ≠ VERIFIED` 기존 로직 그대로',
          'Label opsi filter = format `en (ko)`; definisi filter 「menunggu verifikasi」 tetap: `itStatus = COMPLETED AND verifyStatus ≠ ACCEPTED/REJECTED (belum pasti)` → pada praktiknya logika lama `itStatus = COMPLETED AND itStatus ≠ VERIFIED` dipertahankan',
        ],
      },
      {
        t: [
          '전환 규칙 안내 문구를 범례 하단에 표기(3개 언어)',
          'Cantumkan keterangan aturan transisi di bawah legenda (3 bahasa)',
        ],
        sub: [
          [
            'COMPLETED + ACCEPTED → VERIFIED 전환(총괄팀)',
            'COMPLETED + ACCEPTED → beralih ke VERIFIED (Tim Umum)',
          ],
          [
            'COMPLETED + REJECTED → ONGOING 으로 되돌림(IT부서)',
            'COMPLETED + REJECTED → dikembalikan ke ONGOING (Tim IT)',
          ],
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
    h: ['5. 제외 사항', '5. Di Luar Lingkup'],
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
          '디자인 개편 금지 — 명칭·범례·툴팁만 추가',
          'Dilarang mengubah desain — hanya menambah nama · legenda · tooltip',
        ],
      },
    ],
  },
  {
    h: ['6. 완료 기준', '6. Kriteria Selesai'],
    items: [
      {
        t: [
          '`/csr` 목록 60건 전부 신규 코드 배지로 표시, 한국어 배지 잔존 0건',
          'Seluruh 60 item pada daftar `/csr` tampil dengan badge kode baru, badge bahasa Korea tersisa 0',
        ],
      },
      {
        t: [
          '교차집계 표 합계 60건 및 각 셀 수치가 변경 전과 동일',
          'Total tabel silang 60 item dan angka tiap sel sama seperti sebelum perubahan',
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
          '범례 표 2개(IT상태 4행·현업검증 5행) 및 전환 규칙 문구 3개 언어 표시 확인',
          'Dua tabel legenda (Status IT 4 baris · Hasil Verifikasi 5 baris) dan keterangan aturan transisi dalam 3 bahasa tampil',
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
    <section class="guide">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">Status Guide</h1>
          <p class="page-sub mb-0">
            {{ t(['상태 명칭 표준화 작업지시서', 'Instruksi kerja standardisasi nama status']) }}
          </p>
        </div>
        <div class="d-flex gap-2 align-items-center">
          <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr/dashboard')">
            ← {{ t(['대시보드', 'Dasbor']) }}
          </button>
          <button type="button" class="btn btn-sm btn-link" @click="router.push('/csr')">
            {{ t(['개선요청 목록', 'Daftar permintaan']) }}
          </button>
        </div>
      </div>

      <article class="asm-panel doc">
        <h2 class="asm-title">{{ t(TITLE) }}</h2>

        <!-- §1 · §2 -->
        <template v-for="sec in HEAD_SECTIONS" :key="sec.h[0]">
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

        <!-- §3 — 표는 status.js 정의, 이름·설명은 토글 언어 -->
        <h3>{{ t(SEC3.h) }}</h3>

        <h4>
          <template v-for="(seg, k) in parts(t(SEC3.h31))" :key="k"
            ><code v-if="seg.code">{{ seg.text }}</code
            ><template v-else>{{ seg.text }}</template></template
          >
        </h4>
        <div class="table-scroll">
          <table class="table asm-table def">
            <thead>
              <tr>
                <th>{{ t(SEC3.cols.code) }}</th>
                <th>{{ t(SEC3.cols.name) }}</th>
                <th>{{ t(SEC3.cols.desc) }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="s in IT_ROWS" :key="s.value">
                <td class="nowrap">
                  <span class="asm-badge" :class="`asm-badge--${s.tone}`">{{ s.code }}</span>
                </td>
                <td class="nowrap">{{ nameOf(s, lang) }}</td>
                <td class="wrap">{{ descOf(s, lang) }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <h4>
          <template v-for="(seg, k) in parts(t(SEC3.h32))" :key="k"
            ><code v-if="seg.code">{{ seg.text }}</code
            ><template v-else>{{ seg.text }}</template></template
          >
        </h4>
        <div class="table-scroll">
          <table class="table asm-table def">
            <thead>
              <tr>
                <th>{{ t(SEC3.cols.code) }}</th>
                <th>{{ t(SEC3.cols.name) }}</th>
                <th>{{ t(SEC3.cols.desc) }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="s in VERIFY_STATUS" :key="s.code">
                <td class="nowrap">
                  <span class="asm-badge" :class="`asm-badge--${s.tone}`">{{ s.code }}</span>
                </td>
                <td class="nowrap">{{ nameOf(s, lang) }}</td>
                <td class="wrap">{{ descOf(s, lang) }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <h4>{{ t(SEC3.h33) }}</h4>
        <ul>
          <li v-for="(it, i) in SEC3.tones" :key="i">{{ t(it.t) }}</li>
        </ul>

        <!-- §4 · §5 · §6 -->
        <template v-for="sec in TAIL_SECTIONS" :key="sec.h[0]">
          <h3>{{ t(sec.h) }}</h3>
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
        </template>
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
