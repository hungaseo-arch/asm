<script setup>
/**
 * 보고서 양식안 (직원별) — 2026-10-28 작업지시서 ASM-CSR-2026-1028-01.
 *
 * 원본은 탭 · 한/인니 토글을 스스로 가진 단독 HTML 입니다. 다시 그리지 않고
 * public/csr/reports/report-design.html 을 그대로 <iframe> 에 띄웁니다(흐름도 화면과 같은 방식).
 * 본문이 A4(210mm) 고정 폭이라 흐름도의 확대/축소는 가져오지 않았습니다.
 *
 * HTML 끝의 임베드 스크립트가 받는 것 · 보내는 것:
 * - `?embed=1&lang=` — 자체 언어 토글을 숨기고 처음 언어를 맞춥니다.
 * - `{type:'asm-lang'}` 메시지 — 헤더에서 언어를 바꾸면 다시 불러오지 않고 본문만 바꿉니다.
 * - `{type:'asm-report-height'}` 메시지 — 본문 높이. iframe 을 그만큼 늘려 스크롤이 이중으로 생기지 않게 합니다.
 */
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useCsrLang } from '../composables/useCsrLang'
import { REPORT_DESIGN, REQUESTERS } from '../reportDesign'

const { lang, tp: t } = useCsrLang()

const BASE = `${import.meta.env.BASE_URL}csr/reports/`
const MIN_HEIGHT = 900

/**
 * 요청자별 첫 탭 번호(HTML 의 `#tab{n}`) — 전체 개요 0 · Lestari 1~4 · Lia 5~6 · Merry 7~9 ·
 * Sulastri 10~12 · Resiyan 13~14. HTML 은 불러올 때만 해시를 읽습니다.
 */
const FIRST_TAB = { ALL: 0, Lestari: 1, Lia: 5, Merry: 7, Sulastri: 10, Resiyan: 13 }

/**
 * 처음 불러올 때의 언어만 src 에 넣습니다. lang 을 그대로 넣으면 토글할 때마다
 * iframe 이 다시 불려 보던 탭이 첫 탭으로 돌아갑니다 — 이후 언어는 메시지로 보냅니다.
 * `?v=` 는 빌드 스탬프(public/ 은 해시가 안 붙습니다).
 */
const startLang = ref(lang.value)
const startTab = ref(0)
const reloads = ref(0)
const src = computed(
  () =>
    `${BASE}${REPORT_DESIGN.file}?embed=1&lang=${startLang.value}&v=${__BUILD_ID__}#tab${startTab.value}`,
)
/** 새 창 링크 — 자체 토글이 보이는 단독 화면. */
const standalone = computed(
  () => `${BASE}${REPORT_DESIGN.file}?lang=${lang.value}&v=${__BUILD_ID__}`,
)

const frame = ref(null)
const height = ref(MIN_HEIGHT)
const current = ref('ALL')

/**
 * 요청자 칩 — 같은 출처라 iframe 안 그룹 탭 버튼을 직접 누릅니다(보던 위치 · 언어 유지).
 * 버튼을 못 찾으면 해시를 바꿔 다시 불러옵니다.
 */
const openGroup = (key) => {
  current.value = key
  try {
    const btn = frame.value?.contentDocument?.querySelector(`.gtabs button[data-g="${key}"]`)
    if (btn) {
      btn.click()
      return
    }
  } catch {
    // 접근이 막히면 아래에서 다시 불러옵니다
  }
  startLang.value = lang.value
  startTab.value = FIRST_TAB[key] ?? 0
  reloads.value += 1
}

const onMessage = (e) => {
  if (e.source !== frame.value?.contentWindow) return
  if (e.data?.type === 'asm-report-height' && e.data.h > 0) {
    height.value = Math.max(MIN_HEIGHT, Math.ceil(e.data.h))
  }
}

watch(lang, (l) => {
  frame.value?.contentWindow?.postMessage({ type: 'asm-lang', lang: l }, '*')
})

onMounted(() => window.addEventListener('message', onMessage))
onBeforeUnmount(() => window.removeEventListener('message', onMessage))
</script>

<template>
  <DefaultLayout>
    <section class="reports">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">{{ t(REPORT_DESIGN.title) }}</h1>
          <p class="page-sub mb-0">
            {{ t(REPORT_DESIGN.desc) }}
            <span class="ver">{{ REPORT_DESIGN.version }} · {{ REPORT_DESIGN.date }}</span>
          </p>
        </div>
        <a class="btn btn-sm btn-link" :href="standalone" target="_blank" rel="noopener">
          {{ t(['새 창에서 열기', 'Buka di tab baru']) }} ↗
        </a>
      </div>

      <div class="chips" role="group" :aria-label="t(['요청자', 'Pemohon'])">
        <button
          type="button"
          class="chip"
          :class="{ 'chip--on': current === 'ALL' }"
          :aria-pressed="current === 'ALL'"
          @click="openGroup('ALL')"
        >
          <b>{{ t(['전체 개요', 'Ikhtisar']) }}</b>
        </button>
        <button
          v-for="r in REQUESTERS"
          :key="r.key"
          type="button"
          class="chip"
          :class="{ 'chip--on': current === r.key }"
          :aria-pressed="current === r.key"
          @click="openGroup(r.key)"
        >
          <b>{{ r.name }}</b>
          <span class="dept">{{ t(r.dept) }}</span>
        </button>
      </div>

      <div class="asm-panel stage">
        <iframe
          ref="frame"
          :key="reloads"
          :src="src"
          class="sheet"
          :title="t(REPORT_DESIGN.title)"
          :style="{ height: `${height}px` }"
        ></iframe>
      </div>

      <p class="note">
        {{
          t([
            '인쇄(⌘P / Ctrl+P)하면 보고 있는 탭과 상관없이 15면 전체가 출력됩니다. 한 면만 필요하면 새 창에서 연 뒤 인쇄 범위를 지정하십시오.',
            'Cetak (⌘P / Ctrl+P) akan mencetak seluruh 15 halaman, apa pun tab yang sedang dibuka. Jika hanya perlu satu halaman, buka di tab baru lalu atur rentang cetak.',
          ])
        }}
      </p>

      <div class="asm-panel downloads">
        <h2 class="sub-title">{{ t(['엑셀 다운로드 양식', 'Format Excel untuk diunduh']) }}</h2>
        <table class="table asm-table mb-0">
          <thead>
            <tr>
              <th>{{ t(['요청자', 'Pemohon']) }}</th>
              <th>{{ t(['부서', 'Departemen']) }}</th>
              <th>{{ t(['보고서', 'Laporan']) }}</th>
              <th>{{ t(['파일', 'File']) }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="r in REQUESTERS" :key="r.key">
              <td class="who">{{ r.name }}</td>
              <td>{{ t(r.dept) }}</td>
              <td class="codes">{{ r.reports.join(' · ') }}</td>
              <td>
                <a :href="`${BASE}xlsx/${r.xlsx}`" :download="r.xlsxName">
                  <FileSpreadsheet :size="13" class="me-1" />{{ r.xlsxName }}
                </a>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.reports {
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
.ver {
  margin-left: 8px;
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
}
/* 칩 — 흐름도 탭과 같은 색 규칙(프리셋 파랑). */
.chips {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.chip {
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
  font-size: 12px;
  padding: 6px 12px;
  border-radius: 6px;
  color: var(--asm-info);
  background: var(--asm-info-soft);
  border: 1px solid var(--asm-info-border);
}
.chip b {
  font-weight: 600;
}
.chip .dept {
  opacity: 0.8;
}
.chip--on {
  color: var(--asm-primary-fg);
  background: var(--asm-primary);
  border-color: var(--asm-primary);
}
.chip:focus-visible {
  outline: 0;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
.stage {
  padding: 0;
  overflow-x: auto; /* A4 고정 폭 — 좁은 창에서는 가로로 넘겨 봅니다 */
}
.sheet {
  display: block;
  width: 100%;
  min-width: 840px;
  border: 0;
  background: #fff;
}
.note {
  margin: 0;
  font-size: 12px;
  color: var(--asm-fg-muted);
}
.downloads {
  padding: 16px;
  overflow-x: auto;
}
.sub-title {
  font-size: 14px;
  font-weight: 700;
  margin: 0 0 12px;
}
.who {
  font-weight: 600;
  white-space: nowrap;
}
.codes {
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
}
</style>
