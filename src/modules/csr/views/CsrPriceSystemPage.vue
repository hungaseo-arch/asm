<script setup>
/**
 * ASM 가격 분류 체계 — 제품 가격 항목의 To-Be 정의 (2026-11-11 서종환 결정).
 *
 * 자료실 정적 문서입니다(DB 미사용, 로그인 없이 열림). 「상태 기준」 화면과 같은 방식으로
 * 문단마다 [한국어, 인도네시아어] 쌍을 적고 토글 언어 한쪽만 보여 줍니다 — 한쪽을 고치면 다른 쪽도 같이 고치십시오.
 * 인니어는 Claude 번역(검수 서종환).
 *
 * 근거 : 2026-11-10 ASM 가격 입력 확인(대상 520개 품목), 2026-11-11 「00_WH MASTER DATA (for IT-ASM)」 대조,
 * CSR 122(Landed Cost・WH Price 추가)・138(SO 매입원가 미등록).
 */
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useCsrLang } from '../composables/useCsrLang'

const { tp: t } = useCsrLang()
/** 백틱으로 감싼 조각은 <code> 로 */
const parts = (s) => s.split('`').map((x, i) => ({ code: i % 2 === 1, text: x }))

const TITLE = ['ASM 가격 분류 체계 (To-Be)', 'Klasifikasi Harga ASM (To-Be)']
const META = [
  '결정일 2026-11-11 · 결정 서종환 · 대상 IT팀(개발), 구매팀・재무팀・영업부(데이터)',
  'Tanggal keputusan 2026-11-11 · Diputuskan oleh Seo Jonghwan · Untuk tim IT (pengembangan), tim Pembelian・Keuangan・Sales (data)',
]

const PURPOSE = [
  [
    'ASM 제품 가격을 구매가・수입원가・창고기준원가・회계원가・판매가로 구분하고, 각 값의 화면명・DB 필드・입력 주체・사용처를 하나로 정의',
    'Membedakan harga produk ASM menjadi harga beli・landed cost・harga gudang (WH Price)・biaya akuntansi・harga jual, serta menetapkan nama layar・field DB・penanggung jawab input・penggunaan untuk setiap nilai',
  ],
  [
    '현재 마스터 가격은 `buy_price`・`sell_price`・`usd_price` 3종뿐이고, Landed Cost・WH Price 항목이 없어 견적 마진을 Finance 원가(`finance_buy_unit_cost_idr`)로 계산 중',
    'Saat ini master hanya memiliki 3 harga `buy_price`・`sell_price`・`usd_price`; belum ada Landed Cost・WH Price sehingga margin penawaran dihitung dengan biaya Finance (`finance_buy_unit_cost_idr`)',
  ],
]

const COLS = {
  cls: ['분류', 'Klasifikasi'],
  label: ['ASM 화면 표시명', 'Nama di layar ASM'],
  field: ['DB 필드', 'Field DB'],
  state: ['상태', 'Status'],
  unit: ['단위・기준', 'Satuan・dasar'],
  input: ['입력・갱신', 'Input・pembaruan'],
  use: ['사용처', 'Penggunaan'],
}

/** state : keep(기존) / new(신설) / merge(통합) */
const PRICE_ROWS = [
  {
    cls: ['① 구매가 (수입)', '① Harga beli (impor)'],
    label: 'USD Price',
    field: 'usd_price',
    state: 'keep',
    unit: ['USD, FOB', 'USD, FOB'],
    input: [
      '구매팀 — 최근 확정 Vendor PO 단가',
      'Tim Pembelian — harga Vendor PO terakhir yang dikonfirmasi',
    ],
    use: ['Purchase > Vendor PO 단가 기본값', 'Purchase > Vendor PO, harga default'],
  },
  {
    cls: ['① 구매가 (로컬)', '① Harga beli (lokal)'],
    label: 'Buy Price',
    field: 'buy_price',
    state: 'keep',
    unit: ['IDR, VAT 별도', 'IDR, tanpa PPN'],
    input: [
      '구매팀 — 최근 확정 Vendor PO 단가',
      'Tim Pembelian — harga Vendor PO terakhir yang dikonfirmasi',
    ],
    use: ['Purchase > Vendor PO 단가 기본값', 'Purchase > Vendor PO, harga default'],
  },
  {
    cls: ['② 수입원가', '② Biaya impor'],
    label: 'Landed Cost',
    field: 'landed_cost_idr',
    state: 'new',
    unit: ['IDR, VAT 별도, 실제 환율', 'IDR, tanpa PPN, kurs aktual'],
    input: [
      '자동 계산 — FOB × 환율 + Import Cost(운임・보험・관세・통관비) 배부',
      'Hitung otomatis — FOB × kurs + alokasi Import Cost (freight・asuransi・bea・clearance)',
    ],
    use: ['실적 원가 참고, WH Price 검증', 'Referensi biaya aktual, verifikasi WH Price'],
  },
  {
    cls: ['③ 창고기준원가', '③ Harga gudang'],
    label: 'WH Price',
    field: 'wh_price_idr',
    state: 'new',
    unit: ['IDR, VAT 별도, 관리환율 18,500', 'IDR, tanpa PPN, kurs manajemen 18.500'],
    input: [
      '월 1회 「00_WH MASTER DATA (for IT-ASM)」 Excel 업로드, Article No. 매칭',
      'Upload Excel 「00_WH MASTER DATA (for IT-ASM)」 1x per bulan, dicocokkan dengan Article No.',
    ],
    use: [
      'Sales > Quotation・Customer PO・Sales Order 마진 기준',
      'Dasar margin Sales > Quotation・Customer PO・Sales Order',
    ],
    key: true,
  },
  {
    cls: ['④ 회계원가', '④ Biaya akuntansi'],
    label: 'Finance Cost',
    field: 'finance_buy_unit_cost_idr + finance_close_date',
    state: 'keep',
    unit: ['IDR, 월마감', 'IDR, tutup buku bulanan'],
    input: [
      '재무팀 — Master Data > Monthly Closing 업로드',
      'Tim Keuangan — upload Master Data > Monthly Closing',
    ],
    use: [
      '회계 실적・매출총이익 보고 (견적 마진에는 쓰지 않음)',
      'Laporan aktual akuntansi・laba kotor (tidak dipakai untuk margin penawaran)',
    ],
  },
  {
    cls: ['⑤ 판매 기준단가', '⑤ Harga jual dasar'],
    label: 'Base Sales Price',
    field: 'base_sales_unit_price',
    state: 'keep',
    unit: ['IDR, VAT 별도', 'IDR, tanpa PPN'],
    input: ['영업부', 'Sales'],
    use: ['Sales > Quotation 품목 기준단가', 'Harga dasar item Sales > Quotation'],
  },
  {
    cls: ['⑤-1 마스터 판매가', '⑤-1 Harga jual master'],
    label: 'Sell Price',
    field: 'sell_price',
    state: 'merge',
    unit: ['IDR', 'IDR'],
    input: ['⑤와 같은 값으로 맞춤', 'Disamakan dengan nilai ⑤'],
    use: ['Products 목록 표시만', 'Hanya tampilan daftar Products'],
  },
  {
    cls: ['⑥ 할인', '⑥ Diskon'],
    label: [
      '고객 할인율・직위 할인율・수정 가능 범위',
      'Diskon pelanggan・diskon jabatan・rentang edit',
    ],
    field:
      'ref_dc_rate_per_customer, position_dc_rate, min_edit_dc_rate・max_edit_dc_rate, combine_rate',
    state: 'keep',
    unit: ['%', '%'],
    input: ['영업 관리', 'Manajemen Sales'],
    use: ['Sales > Quotation 할인 계산', 'Perhitungan diskon Sales > Quotation'],
  },
]

const STATE = {
  keep: { label: ['기존', 'Sudah ada'], tone: 'neutral' },
  new: { label: ['신설', 'Baru'], tone: 'info' },
  merge: { label: ['⑤로 통합', 'Gabung ke ⑤'], tone: 'warning' },
}

const TXN_COLS = { stage: ['단계', 'Tahap'], screen: ['화면', 'Layar'], field: ['필드', 'Field'] }
const TXN_ROWS = [
  {
    stage: ['입고・수입', 'Penerimaan・impor'],
    screen: 'Purchase > Receipt・Import Shipment',
    field: 'fob_unit_price_usd, fob_unit_price_idr, cif_unit_cost_idr, unit_cost_idr',
  },
  {
    stage: ['부대비용', 'Biaya tambahan'],
    screen: 'Purchase > Import Cost',
    field: [
      '운임・보험・통관비 → ② Landed Cost 원천',
      'Freight・asuransi・clearance → sumber ② Landed Cost',
    ],
  },
  {
    stage: ['재고 단가', 'Biaya stok'],
    screen: 'Inventory > Inventory List',
    field: 'current_unit_cost',
  },
]

const RULES = [
  [
    '견적 마진 = (기준단가 × 수량 − 할인 − WH Price × 수량) ÷ 판매금액. 현재 원가로 쓰는 `finance_buy_unit_cost_idr`를 `wh_price_idr`로 변경',
    'Margin penawaran = (harga dasar × qty − diskon − WH Price × qty) ÷ nilai jual. Ganti biaya yang dipakai sekarang `finance_buy_unit_cost_idr` menjadi `wh_price_idr`',
  ],
  [
    'WH Price 0 또는 미등록 품목은 견적 화면에서 「WH Price 미등록」 경고 표시, 원가 0으로 계산 금지',
    'Item dengan WH Price 0 atau belum terdaftar menampilkan peringatan 「WH Price belum terdaftar」 di layar penawaran; dilarang menghitung dengan biaya 0',
  ],
  [
    'WH Price 업로드는 Article No. 기준 매칭, 적용일과 변경 이력(변경 전 값・변경자・일시) 보관',
    'Upload WH Price dicocokkan berdasarkan Article No.; simpan tanggal berlaku dan riwayat perubahan (nilai sebelumnya・pengubah・waktu)',
  ],
  [
    'Finance Cost는 변경하지 않음 — 월마감 실적 원가로만 사용',
    'Finance Cost tidak diubah — hanya dipakai sebagai biaya aktual tutup buku bulanan',
  ],
  [
    'Sell Price와 Base Sales Price를 하나로 통합(정리 전까지 Products 화면에 두 값 병기)',
    'Gabungkan Sell Price dan Base Sales Price menjadi satu (sampai selesai, tampilkan kedua nilai di layar Products)',
  ],
  [
    'Products 화면・목록・Excel 출력에 ①〜⑤ 전 항목 표시, 단위 IDR 소수점 없음(USD Price 제외)',
    'Tampilkan semua item ①〜⑤ di layar Products・daftar・ekspor Excel; satuan IDR tanpa desimal (kecuali USD Price)',
  ],
]

const STATUS_NOW = [
  [
    '2026-11-10 기준 거래・재고 품목 520개 중 구매가 미등록 146개, Finance 원가 미등록 40개, 판매 기준단가 미등록 221개, Sell Price 미등록 118개',
    'Per 2026-11-10, dari 520 item transaksi・stok: harga beli belum terdaftar 146, biaya Finance 40, harga jual dasar 221, Sell Price 118',
  ],
  [
    'WH MASTER(2026-11-11, 457행)와 ASM Finance 원가 비교 — 376개 중 346개가 WH Price가 높음, 중앙값 +8.7%. 기준 변경 시 견적 마진이 낮아짐',
    'Perbandingan WH MASTER (2026-11-11, 457 baris) dengan biaya Finance ASM — 346 dari 376 item WH Price lebih tinggi, median +8,7%. Margin penawaran akan turun setelah dasar diganti',
  ],
  [
    'WH MASTER 업로드 전 정리 필요 : Article No. 오류・중복(No 67・71・99・106・109・113), Article No. 공란 2개, ASM 거래품목 144개 누락',
    'Perlu dirapikan sebelum upload WH MASTER : Article No. salah・ganda (No 67・71・99・106・109・113), 2 Article No. kosong, 144 item transaksi ASM belum ada',
  ],
]

const RELATED = [
  [
    'CSR 122 — 제품 마스터 가격구분 Landed Cost・WH Price 추가',
    'CSR 122 — Tambah jenis harga Landed Cost dan WH Price di master produk',
  ],
  [
    'CSR 137 — 고객주문 마진분석・승인 절차',
    'CSR 137 — Analisis margin・persetujuan pesanan pelanggan',
  ],
  [
    'CSR 138 — SO 매입원가 미등록・직전 월 원가 적용',
    'CSR 138 — Harga pokok di SO belum terdaftar・memakai biaya bulan sebelumnya',
  ],
  [
    '후보 D — 제품 마스터 구매가 미등록 (140개)',
    'Kandidat D — Harga beli master produk belum terdaftar (140 item)',
  ],
  ['후보 E — 판매가 미등록・이원화', 'Kandidat E — Harga jual belum terdaftar・ganda'],
]

const H = {
  s1: ['1. 목적', '1. Tujuan'],
  s2: ['2. 가격 분류', '2. Klasifikasi harga'],
  s3: [
    '3. 거래 단계에서 생기는 원가 (참고, 마스터 항목 아님)',
    '3. Biaya yang muncul di tahap transaksi (referensi, bukan item master)',
  ],
  s4: ['4. 견적 원가 기준 — WH Price', '4. Dasar biaya penawaran — WH Price'],
  s4p: [
    '견적・고객주문・SO 마진은 ③ 창고기준원가(WH Price)로 계산 (2026-11-11 결정)',
    'Margin penawaran・pesanan pelanggan・SO dihitung dengan ③ harga gudang (WH Price) (diputuskan 2026-11-11)',
  ],
  s5: ['5. 개발 규칙 (IT팀)', '5. Aturan pengembangan (tim IT)'],
  s6: ['6. 현재 데이터 현황', '6. Kondisi data saat ini'],
  s7: ['7. 관련 CSR', '7. CSR terkait'],
}
</script>

<template>
  <DefaultLayout>
    <section class="guide">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">Price Classification</h1>
          <p class="page-sub mb-0">{{ t(['ASM 가격 분류 체계', 'Klasifikasi harga ASM']) }}</p>
        </div>
        <router-link to="/csr" class="btn btn-sm btn-link">
          {{ t(['개선요청 목록', 'Daftar permintaan']) }}
        </router-link>
      </div>

      <article class="asm-panel doc">
        <h2 class="asm-title">{{ t(TITLE) }}</h2>
        <p class="meta">{{ t(META) }}</p>

        <h3>{{ t(H.s1) }}</h3>
        <ul>
          <li v-for="(it, i) in PURPOSE" :key="i">
            <template v-for="(seg, k) in parts(t(it))" :key="k"
              ><code v-if="seg.code">{{ seg.text }}</code
              ><template v-else>{{ seg.text }}</template></template
            >
          </li>
        </ul>

        <h3>{{ t(H.s2) }}</h3>
        <div class="table-scroll">
          <table class="table asm-table price">
            <thead>
              <tr>
                <th v-for="c in COLS" :key="c[0]">{{ t(c) }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="r in PRICE_ROWS" :key="r.field" :class="{ 'row-key': r.key }">
                <td class="nowrap strong">{{ t(r.cls) }}</td>
                <td>{{ Array.isArray(r.label) ? t(r.label) : r.label }}</td>
                <td class="wrap">
                  <code>{{ r.field }}</code>
                </td>
                <td class="nowrap">
                  <span class="asm-badge" :class="`asm-badge--${STATE[r.state].tone}`">{{
                    t(STATE[r.state].label)
                  }}</span>
                </td>
                <td class="wrap">{{ t(r.unit) }}</td>
                <td class="wrap">{{ t(r.input) }}</td>
                <td class="wrap">{{ t(r.use) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p class="note">
          {{
            t([
              '신설 필드명(landed_cost_idr・wh_price_idr)은 예시 — IT팀이 실제 명명 규칙에 맞춰 확정',
              'Nama field baru (landed_cost_idr・wh_price_idr) hanya contoh — tim IT menetapkan sesuai aturan penamaan',
            ])
          }}
        </p>

        <h3>{{ t(H.s3) }}</h3>
        <div class="table-scroll">
          <table class="table asm-table">
            <thead>
              <tr>
                <th v-for="c in TXN_COLS" :key="c[0]">{{ t(c) }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="r in TXN_ROWS" :key="r.screen">
                <td class="nowrap">{{ t(r.stage) }}</td>
                <td>{{ r.screen }}</td>
                <td class="wrap">
                  <code v-if="!Array.isArray(r.field)">{{ r.field }}</code>
                  <template v-else>{{ t(r.field) }}</template>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <h3>{{ t(H.s4) }}</h3>
        <p class="callout">{{ t(H.s4p) }}</p>

        <h3>{{ t(H.s5) }}</h3>
        <ol>
          <li v-for="(it, i) in RULES" :key="i">
            <template v-for="(seg, k) in parts(t(it))" :key="k"
              ><code v-if="seg.code">{{ seg.text }}</code
              ><template v-else>{{ seg.text }}</template></template
            >
          </li>
        </ol>

        <h3>{{ t(H.s6) }}</h3>
        <ul>
          <li v-for="(it, i) in STATUS_NOW" :key="i">{{ t(it) }}</li>
        </ul>

        <h3>{{ t(H.s7) }}</h3>
        <ul>
          <li v-for="(it, i) in RELATED" :key="i">{{ t(it) }}</li>
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
  margin: 0 0 4px;
}
.doc h3 {
  font-size: 15px;
  font-weight: 700;
  margin: 22px 0 8px;
}
.doc ul,
.doc ol {
  margin: 0 0 4px;
  padding-left: 20px;
}
.doc code {
  font-size: 12.5px;
  background: var(--asm-muted-20);
  padding: 1px 5px;
  border-radius: var(--asm-radius-sm);
}
.meta,
.note {
  color: var(--asm-fg-muted);
  font-size: 13px;
  margin: 0 0 8px;
}
.table-scroll {
  overflow-x: auto;
}
.price {
  min-width: 980px;
}
th,
td {
  vertical-align: top;
}
td.wrap {
  white-space: normal;
  overflow-wrap: anywhere;
}
td.nowrap {
  white-space: nowrap;
}
td.strong {
  font-weight: 600;
}
tr.row-key td {
  background: var(--asm-primary-5);
}
.callout {
  background: var(--asm-primary-5);
  border-radius: var(--asm-radius-sm);
  padding: 8px 12px;
  margin: 0;
  font-weight: 600;
}
</style>
