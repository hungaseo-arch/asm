<script setup>
/**
 * 업무 Flow Diagram — 수주(SO) · 입고(Receiving) 스윔레인 도면 (2026-09-14 요청).
 *
 * 원본은 SVG 를 스크립트로 그리는 단독 HTML 두 개입니다(외부 의존 없음).
 * 다시 그리지 않고 public/csr/flow/*.html 을 그대로 <iframe> 에 띄웁니다 —
 * 도면이 갱신되면 파일만 바꿔 끼우면 되고, 이 화면은 손대지 않아도 됩니다.
 *
 * 폭이 2500~2600px 로 고정이라 그냥 넣으면 가로 스크롤만 깁니다. 같은 출처라
 * 불러온 뒤 문서 크기를 재서 「화면 맞춤」 배율을 계산하고 transform 으로 줄입니다.
 * 도면 본문은 영어라 번역 대상이 아닙니다 — 제목 · 안내만 한국어 / 인도네시아어로 갈라 둡니다.
 */
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useIdentityStore } from '@/stores/identity'

const identity = useIdentityStore()
const lang = computed(() => identity.lang)
/** [ko, id] 쌍에서 토글 언어 쪽. */
const t = (pair) => (lang.value === 'id' ? pair[1] : pair[0])

const DIAGRAMS = [
  {
    key: 'so',
    file: 'so.html',
    name: ['수주 (SO Confirm)', 'Penjualan (SO Confirm)'],
    desc: [
      '수주 확정 3단 점검 — ① 재고 수량 → ② 마진 → ③ 여신 한도. 하나라도 걸리면 저장이 막히고 승인으로 넘어갑니다.',
      'Tiga pemeriksaan berurutan saat konfirmasi SO — ① jumlah stok → ② margin → ③ batas kredit. Jika salah satu gagal, penyimpanan diblokir dan masuk ke persetujuan.',
    ],
  },
  {
    key: 'receiving',
    file: 'receiving.html',
    name: ['입고 (Receiving)', 'Penerimaan (Receiving)'],
    desc: [
      '수입은 PO → PPC → 지급계획 → 선적 → 통관(PIB) → 입고, 로컬은 PO → 입고로 3~6단계를 건너뜁니다.',
      'Impor: PO → PPC → rencana bayar → pengapalan → kepabeanan (PIB) → penerimaan. Lokal: PO → penerimaan, tahap 3–6 dilewati.',
    ],
  },
]

const current = ref(DIAGRAMS[0].key)
const active = computed(() => DIAGRAMS.find((d) => d.key === current.value) ?? DIAGRAMS[0])
/** public/ 자산은 vite base(/asm/) 아래에 그대로 놓입니다 — 하위 경로 배포에서도 맞게. */
const src = computed(() => `${import.meta.env.BASE_URL}csr/flow/${active.value.file}`)

const frame = ref(null)
const stage = ref(null)
const natural = ref({ w: 2600, h: 900 })
const zoom = ref(1)
const fit = ref(true) // 처음에는 화면 맞춤 — 2600px 도면을 그냥 두면 가로 스크롤만 보입니다
const ready = ref(false)

/** 화면 맞춤 배율 — 가로만 기준. 원본보다 크게는 늘리지 않습니다. */
const fitZoom = () => {
  const box = stage.value?.clientWidth ?? 0
  if (!box || !natural.value.w) return 1
  return Math.min(1, box / natural.value.w)
}
const applyFit = () => {
  if (fit.value) zoom.value = fitZoom()
}

/**
 * 같은 출처라 도면 크기를 직접 잽니다. 기준은 <svg id="s"> 의 width · height 속성입니다 —
 * 스크립트가 그리고 나서 붙이는 값이라 문서 전체 크기보다 정확합니다. 여백 20px 은 본문 padding.
 * load 직후에는 아직 안 그려져 있을 수 있어 못 재면 잠시 뒤 한 번 더 봅니다(최대 10회 · 1초).
 */
const measure = (tries = 0) => {
  let size = null
  try {
    const doc = frame.value?.contentDocument
    const svg = doc?.getElementById('s')
    const w = Number(svg?.getAttribute('width'))
    const h = Number(svg?.getAttribute('height'))
    if (w > 0 && h > 0) size = { w: w + 20, h: h + 20 }
    else if (doc?.documentElement?.scrollWidth > 0) {
      const el = doc.documentElement
      size = { w: el.scrollWidth, h: el.scrollHeight }
    }
  } catch {
    size = null // 혹시 접근이 막히면 기본값 그대로
  }
  if (!size) {
    if (tries < 10) setTimeout(() => measure(tries + 1), 100)
    return
  }
  natural.value = size
  ready.value = true
  applyFit()
}
const onLoad = () => measure()

const setZoom = (z) => {
  fit.value = false
  zoom.value = Math.min(2, Math.max(0.25, Number(z.toFixed(2))))
}
const setFit = () => {
  fit.value = true
  applyFit()
}

watch(current, () => {
  ready.value = false // 도면이 바뀌면 크기를 다시 잽니다
})

onMounted(() => window.addEventListener('resize', applyFit))
onBeforeUnmount(() => window.removeEventListener('resize', applyFit))
</script>

<template>
  <DefaultLayout>
    <section class="flow">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">Flow Diagram</h1>
          <p class="page-sub mb-0">
            {{
              t([
                'ASM 업무 흐름도 — 수주 · 입고',
                'Diagram alur kerja ASM — penjualan · penerimaan',
              ])
            }}
          </p>
        </div>
        <a class="btn btn-sm btn-link" :href="src" target="_blank" rel="noopener">
          {{ t(['새 창에서 원본 크기', 'Ukuran asli di tab baru']) }} ↗
        </a>
      </div>

      <div class="toolbar">
        <div class="tabs" role="tablist">
          <button
            v-for="d in DIAGRAMS"
            :key="d.key"
            type="button"
            role="tab"
            class="tab"
            :class="{ 'tab--on': d.key === current }"
            :aria-selected="d.key === current"
            @click="current = d.key"
          >
            {{ t(d.name) }}
          </button>
        </div>
        <div class="zoomer">
          <button type="button" class="zoom-btn" @click="setZoom(zoom - 0.15)">−</button>
          <span class="zoom-now">{{ Math.round(zoom * 100) }}%</span>
          <button type="button" class="zoom-btn" @click="setZoom(zoom + 0.15)">＋</button>
          <button
            type="button"
            class="zoom-btn wide"
            :class="{ 'zoom-btn--on': fit }"
            @click="setFit"
          >
            {{ t(['화면 맞춤', 'Sesuaikan layar']) }}
          </button>
          <button
            type="button"
            class="zoom-btn wide"
            :class="{ 'zoom-btn--on': !fit && zoom === 1 }"
            @click="setZoom(1)"
          >
            100%
          </button>
        </div>
      </div>

      <p class="desc">{{ t(active.desc) }}</p>

      <div ref="stage" class="asm-panel stage">
        <div class="canvas" :style="{ height: `${natural.h * zoom}px` }">
          <iframe
            ref="frame"
            :key="active.key"
            :src="src"
            class="sheet"
            :title="t(active.name)"
            :style="{
              width: `${natural.w}px`,
              height: `${natural.h}px`,
              transform: `scale(${zoom})`,
            }"
            @load="onLoad"
          ></iframe>
        </div>
      </div>

      <p class="note">
        {{
          t([
            '도면 본문은 영어입니다. 축소된 상태에서 글씨가 작으면 100% 로 두고 가로로 넘겨 보시거나 새 창에서 여십시오.',
            'Isi diagram berbahasa Inggris. Jika huruf terlalu kecil saat diperkecil, pakai 100% lalu geser ke samping, atau buka di tab baru.',
          ])
        }}
      </p>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.flow {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
/* 탭 — 목록 툴바와 같은 색 규칙(프리셋 파랑)을 씁니다. */
.tabs {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.tab {
  font-size: 12px;
  font-weight: 600;
  padding: 6px 14px;
  border-radius: 6px;
  color: var(--asm-info);
  background: var(--asm-info-soft);
  border: 1px solid var(--asm-info-border);
}
.tab--on {
  color: var(--asm-primary-fg);
  background: var(--asm-primary);
  border-color: var(--asm-primary);
}
.zoomer {
  display: flex;
  align-items: center;
  gap: 6px;
}
.zoom-btn {
  font-size: 12px;
  min-width: 30px;
  padding: 5px 8px;
  border-radius: 6px;
  color: var(--asm-fg-muted);
  background: var(--asm-card);
  border: 1px solid var(--asm-border);
}
.zoom-btn.wide {
  min-width: auto;
}
.zoom-btn:hover {
  color: var(--asm-fg);
  background: var(--asm-secondary);
  border-color: var(--asm-border-strong);
}
.zoom-btn--on {
  color: var(--asm-success);
  background: var(--asm-success-soft);
  border-color: var(--asm-success-border);
  font-weight: 600;
}
.zoom-now {
  font-size: 12px;
  font-weight: 700;
  color: var(--asm-primary);
  background: var(--asm-primary-soft);
  padding: 3px 8px;
  border-radius: 9999px;
  min-width: 46px;
  text-align: center;
}
.desc {
  margin: 0;
  font-size: 13px;
  color: var(--asm-fg-muted);
}
.stage {
  padding: 12px;
  overflow: auto; /* 100% 로 두면 가로로 넘겨 봅니다 */
}
.canvas {
  position: relative;
}
.sheet {
  display: block;
  border: 0;
  transform-origin: top left;
  background: #fff;
}
.note {
  margin: 0;
  font-size: 12px;
  color: var(--asm-fg-muted);
}
</style>
