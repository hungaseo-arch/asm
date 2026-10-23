/**
 * ASM ERP 핵심문서 목록 (Core documents / Dokumen inti) — 2026-10-23 요청.
 *
 * 원본은 Google Drive 「ASM_ERP_핵심문서_10종」 폴더의 hwpx 입니다. 한컴오피스로 PDF 를
 * 뽑아 public/csr/docs/DOC-xx.pdf 에 넣었습니다 — 문서가 개정되면 PDF 를 바꿔 끼우고
 * 여기 version · date 만 고치면 됩니다. 파일명은 URL 인코딩 문제를 피하려고 영문 번호로 두고,
 * 내려받을 때 이름(file)만 원본 한글 이름을 씁니다.
 */
export const CORE_DOCS = [
  {
    no: 'DOC-01',
    file: 'ASM_01_구축범위정의서',
    title: ['구축 범위 정의서', 'Definisi Ruang Lingkup'],
    en: 'Scope Definition',
    version: 'v1.2.3',
    date: '2026-10-21',
    desc: [
      '업무·기능·데이터·보안·운영 범위와 제외 범위를 합의하는 최상위 기준 문서.',
      'Dokumen acuan tertinggi yang menyepakati ruang lingkup bisnis, fungsi, data, keamanan, operasi, serta yang dikecualikan.',
    ],
  },
  {
    no: 'DOC-02',
    file: 'ASM_02_업무프로세스정의서_TO-BE',
    title: ['업무 프로세스 정의서 (TO-BE)', 'Definisi Proses Bisnis (TO-BE)'],
    en: 'Business Process Definition',
    version: 'v1.2.3',
    date: '2026-10-21',
    desc: [
      '메뉴 6개 대목차별 처리 흐름 · 담당 역할 · 통제 포인트 · 현재 갭과 TO-BE 반영.',
      'Alur proses, peran, titik kontrol, gap saat ini, dan TO-BE untuk 6 menu utama.',
    ],
  },
  {
    no: 'DOC-03',
    file: 'ASM_03_기능요구사항정의서_FRS',
    title: ['기능 요구사항 정의서 (FRS)', 'Spesifikasi Kebutuhan Fungsional'],
    en: 'Functional Requirement Specification',
    version: 'v1.3.1',
    date: '2026-09-03',
    desc: [
      '기능 요구사항 42건(Must 35 · Should 7)과 비기능 요구사항 8건 — ID · 우선순위 · 인수기준.',
      '42 kebutuhan fungsional (Must 35 · Should 7) dan 8 non-fungsional — ID, prioritas, kriteria penerimaan.',
    ],
  },
  {
    no: 'DOC-04',
    file: 'ASM_04_Master_Transaction구분정의서',
    title: ['Master / Transaction 구분 정의서', 'Definisi Data Induk dan Transaksi'],
    en: 'Master–Transaction Data Definition',
    version: 'v1.2.2',
    date: '2026-09-03',
    desc: [
      '기준정보와 거래 데이터를 구분하고 속성 · 오너 · 통제 · 참조 · 스냅샷 · 품질 규칙을 정의.',
      'Memisahkan data induk dan transaksi; atribut, pemilik, kontrol, referensi, snapshot, aturan kualitas.',
    ],
  },
  {
    no: 'DOC-05',
    file: 'ASM_05_DB설계생략_후속전제서',
    title: ['DB 설계 생략 및 후속 전제서', 'Penundaan Desain DB'],
    en: 'DB Design Deferral & Interface Premise',
    version: 'v1.2.2',
    date: '2026-09-03',
    desc: [
      '물리 DB/ERD 설계 생략 결정과 범위, 착수 전 고정할 논리 계약 · DB 설계 게이트 · 미확정 항목.',
      'Keputusan menunda desain DB fisik/ERD, kontrak logis yang wajib dikunci, gerbang desain DB, item belum pasti.',
    ],
  },
  {
    no: 'DOC-06',
    file: 'ASM_06_권한및승인설계서',
    title: ['권한 및 승인 설계서', 'Desain Hak Akses dan Persetujuan'],
    en: 'Authorization & Approval Design',
    version: 'v1.2.3',
    date: '2026-10-21',
    desc: [
      'RBAC · C1~C4 권한 모델, 역할별 책임, 직무분리(SoD), 승인 Workflow, Export · 감사 · 비상권한 통제.',
      'Model RBAC · C1–C4, tanggung jawab peran, SoD, alur persetujuan, kontrol ekspor, audit, akses darurat.',
    ],
  },
  {
    no: 'DOC-07',
    file: 'ASM_07_화면설계서_스토리보드',
    title: ['화면 설계서 및 스토리보드', 'Desain Layar dan Storyboard'],
    en: 'Screen Design & Storyboard',
    version: 'v1.2.2',
    date: '2026-09-03',
    desc: [
      '현행 화면 26종 구조, 공통 레이아웃, 대표 화면 4종 현행/TO-BE, 신규 화면 7종, 디자인 기준.',
      '26 layar saat ini, tata letak umum, 4 layar utama (saat ini/TO-BE), 7 layar baru, standar desain.',
    ],
  },
  {
    no: 'DOC-08',
    file: 'ASM_08_개발기술문서',
    title: ['개발 기술문서', 'Dokumen Teknis Pengembangan'],
    en: 'Technical Development Guide',
    version: 'v1.2.3',
    date: '2026-10-21',
    desc: [
      '목표 아키텍처, API 표준, 오류 코드, Frontend / Backend 표준, Git · 배포 · 품질 게이트, 테스트 전략.',
      'Arsitektur target, standar API, kode galat, standar Frontend/Backend, Git, deploy, quality gate, strategi uji.',
    ],
  },
  {
    no: 'DOC-09',
    file: 'ASM_09_개발우선순위_로드맵',
    title: ['개발 우선순위 및 실행 로드맵', 'Prioritas dan Peta Jalan'],
    en: 'Development Priority & Roadmap',
    version: 'v1.2.2',
    date: '2026-09-03',
    desc: [
      'P0~P3 우선순위, Gate 0 → Release A~E → Go-Live 단계, Backlog 상위 15건, 리스크 대응.',
      'Prioritas P0–P3, tahap Gate 0 → Release A–E → Go-Live, 15 backlog teratas, penanganan risiko.',
    ],
  },
  {
    no: 'DOC-10',
    file: 'ASM_10_재고매출미수금_자동연계구조설계서',
    title: ['재고·매출·미수금 자동연계 구조 설계서', 'Keterkaitan Persediaan–Penjualan–Piutang'],
    en: 'Stock–Sales–AR Auto-Linkage Design',
    version: 'v1.2.2',
    date: '2026-09-03',
    desc: [
      '전표 상태 변경이 재고 · 매출 · 미수금에 정확히 한 번 반영되는 원장 구조 · 정합 규칙 · E2E 테스트.',
      'Struktur buku besar agar perubahan dokumen tercatat tepat sekali ke stok, penjualan, piutang; aturan rekonsiliasi, uji E2E.',
    ],
  },
  {
    no: 'DOC-11',
    file: 'ASM_11_아키텍처결정기록_ADR',
    title: ['아키텍처 결정 기록 (ADR)', 'Catatan Keputusan Arsitektur'],
    en: 'Architecture Decision Records',
    version: 'v1.3',
    date: '2026-09-03',
    desc: [
      '확정 · 제안 · 미결 아키텍처 결정 12건을 arc42 §9 형식(맥락 · 대안 · 결정 · 결과)으로 기록.',
      '12 keputusan arsitektur (final · usulan · tertunda) dalam format arc42 §9.',
    ],
  },
  {
    no: 'DOC-12',
    file: 'ASM_12_용어집',
    title: ['용어집', 'Daftar Istilah'],
    en: 'Glossary',
    version: 'v1.3.2',
    date: '2026-10-21',
    desc: [
      '업무 · 기술 · 세무 · 보안 용어를 한국어 · 영어 · 인도네시아어 3열로 정의.',
      'Istilah bisnis, teknis, pajak, dan keamanan dalam 3 kolom: Korea · Inggris · Indonesia.',
    ],
  },
]

/**
 * public/ 자산은 vite base(/asm/) 아래에 놓입니다 — 하위 경로 배포에서도 맞게.
 * 인니어판은 DOC-xx.id.pdf (2026-10-23 — 한국어 원본 hwpx 를 번역해 같은 양식으로 뽑은 PDF).
 */
export const coreDocUrl = (doc, lang, set = DOC_SETS.docs) =>
  `${import.meta.env.BASE_URL}csr/${set.dir}/${doc.no}${set.bilingual && lang === 'id' ? '.id' : ''}.pdf`
/** 내려받을 때 파일 이름 — 원본 한글 이름, 인니어판은 _ID 를 붙입니다. */
export const coreDocFileName = (doc, lang, set = DOC_SETS.docs) =>
  `${doc.file}${set.bilingual && lang === 'id' ? '_ID' : ''}.pdf`

/**
 * 판매서류 표준양식 5종 (Standard sales forms / Formulir standar) — 2026-10-23 요청.
 *
 * 원본은 Google Drive 「ASM_사내문서/01_ASM_필수문서5종/표준양식_PDF」. 양식 자체가
 * 한국어·인니어 겸용이라 언어별 PDF 가 따로 없습니다(bilingual: false — 토글과 무관하게
 * FORM-xx.pdf 하나). 개정되면 PDF 를 바꿔 끼우고 date 만 고칩니다.
 */
const FORM_DATE = '2026-10-23'
export const SALES_FORMS = [
  {
    no: 'FORM-01',
    file: '01_QUOTATION_20261023',
    title: ['견적서', 'Penawaran Harga'],
    en: 'Quotation',
    version: '',
    date: FORM_DATE,
    desc: [
      '고객 문의에 품목 · 단가 · 조건을 제시하는 첫 판매서류.',
      'Dokumen penjualan pertama: item, harga, dan syarat untuk permintaan pelanggan.',
    ],
  },
  {
    no: 'FORM-02',
    file: '02_SALES_ORDER_20261023',
    title: ['판매주문서 (SO)', 'Sales Order (SO)'],
    en: 'Sales Order',
    version: '',
    date: FORM_DATE,
    desc: [
      '고객 확정 주문을 수량 · 단가 · 납기로 확정하는 내부 기준 문서.',
      'Dokumen acuan internal pesanan pelanggan yang sudah pasti: jumlah, harga, jadwal kirim.',
    ],
  },
  {
    no: 'FORM-03',
    file: '03_DELIVERY_ORDER_20261023',
    title: ['출고지시서 (DO)', 'Delivery Order (DO)'],
    en: 'Delivery Order',
    version: '',
    date: FORM_DATE,
    desc: [
      'SO 를 근거로 창고에 출고를 지시하는 문서.',
      'Perintah pengeluaran barang ke gudang berdasarkan SO.',
    ],
  },
  {
    no: 'FORM-04',
    file: '04_DELIVERY_NOTE_20261023',
    title: ['납품서 (DN)', 'Surat Jalan (DN)'],
    en: 'Delivery Note',
    version: '',
    date: FORM_DATE,
    desc: [
      '물품과 함께 가서 고객이 인수 서명하는 납품 확인 문서.',
      'Menyertai barang dan ditandatangani pelanggan sebagai bukti terima.',
    ],
  },
  {
    no: 'FORM-05',
    file: '05_INVOICE_20261023',
    title: ['청구서 (Invoice)', 'Faktur (Invoice)'],
    en: 'Invoice',
    version: '',
    date: FORM_DATE,
    desc: [
      '납품 완료분에 대금을 청구하는 문서.',
      'Penagihan pembayaran atas barang yang sudah dikirim.',
    ],
  },
]

/**
 * 문서 묶음 — 화면(CsrCoreDocsPage) 하나가 라우트 meta.docSet 으로 골라 씁니다.
 * dir 은 public/csr/ 아래 폴더, bilingual 이면 인니어 화면에서 .id.pdf · _ID 이름을 씁니다.
 */
export const DOC_SETS = {
  docs: {
    route: 'csr-docs',
    dir: 'docs',
    bilingual: true,
    items: CORE_DOCS,
    title: ['핵심문서', 'Dokumen Inti'],
    sub: [
      `ASM ERP 구축 핵심문서 (DOC-01 ~ DOC-${CORE_DOCS.length})`,
      `Dokumen inti pembangunan ASM ERP (DOC-01 – DOC-${CORE_DOCS.length})`,
    ],
  },
  forms: {
    route: 'csr-forms',
    dir: 'forms',
    bilingual: false,
    items: SALES_FORMS,
    title: ['판매서류 표준양식', 'Formulir Standar Penjualan'],
    sub: [
      `견적서 → SO → DO → DN → Invoice (${SALES_FORMS.length}종 · 한국어·인니어 겸용)`,
      `Penawaran → SO → DO → DN → Invoice (${SALES_FORMS.length} formulir · dwibahasa)`,
    ],
  },
}
