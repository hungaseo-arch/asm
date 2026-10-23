<script setup>
/**
 * 핵심문서 — ASM ERP 핵심문서 열람 화면 (2026-10-23 요청).
 *
 * /csr/docs        목록(카드) — 문서 12종 한눈에
 * /csr/docs/:docNo 하위 페이지 — 왼쪽 문서 목록 + 오른쪽 PDF 뷰어
 *
 * PDF 는 브라우저 내장 뷰어를 <iframe> 으로 띄웁니다(별도 라이브러리 없음 — 초기 청크 한도).
 * 휴대폰 브라우저는 iframe 안에서 PDF 를 못 그리는 경우가 많아 「새 창 · 내려받기」 버튼을
 * 항상 함께 둡니다. 헤더 언어 토글이 인니어면 PDF 도 인니어판(DOC-xx.id.pdf)으로 바뀝니다.
 */
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useCsrLang } from '../composables/useCsrLang'
import { CORE_DOCS, coreDocFileName, coreDocUrl } from '../coreDocs'

const { tp: t, lang } = useCsrLang()
const route = useRoute()
const router = useRouter()

const docNo = computed(() => String(route.params.docNo ?? '').toUpperCase())
const active = computed(() => CORE_DOCS.find((d) => d.no === docNo.value) ?? null)
/** 주소에 번호가 있는데 목록에 없으면 「없는 문서」. */
const missing = computed(() => !!docNo.value && !active.value)

const open = (doc) => router.push({ name: 'csr-docs', params: { docNo: doc.no } })
</script>

<template>
  <DefaultLayout>
    <section class="docs">
      <div class="head">
        <div class="page-titles">
          <h1 class="page-title">{{ t(['핵심문서 10종', 'Dokumen Inti']) }}</h1>
          <p class="page-sub mb-0">
            {{
              t([
                `ASM ERP 구축 핵심문서 (DOC-01 ~ DOC-${CORE_DOCS.length})`,
                `Dokumen inti pembangunan ASM ERP (DOC-01 – DOC-${CORE_DOCS.length})`,
              ])
            }}
          </p>
        </div>
        <button
          v-if="docNo"
          type="button"
          class="btn btn-sm btn-link"
          @click="router.push({ name: 'csr-docs' })"
        >
          ← {{ t(['전체 목록', 'Semua dokumen']) }}
        </button>
      </div>

      <!-- 목록 (index) -->
      <div v-if="!docNo" class="grid">
        <button
          v-for="d in CORE_DOCS"
          :key="d.no"
          type="button"
          class="asm-panel card-doc"
          @click="open(d)"
        >
          <span class="no">{{ d.no }}</span>
          <b class="title">{{ t(d.title) }}</b>
          <small class="en">{{ d.en }}</small>
          <span class="desc">{{ t(d.desc) }}</span>
          <span class="meta">{{ d.version }} · {{ d.date }}</span>
        </button>
      </div>

      <div v-else-if="missing" class="asm-panel empty">
        {{ t(['없는 문서 번호입니다.', 'Nomor dokumen tidak ditemukan.']) }}
        <code>{{ docNo }}</code>
      </div>

      <!-- 하위 페이지 (viewer) -->
      <div v-else class="viewer">
        <nav class="asm-panel side" :aria-label="t(['문서 목록', 'Daftar dokumen'])">
          <button
            v-for="d in CORE_DOCS"
            :key="d.no"
            type="button"
            class="side-item"
            :class="{ 'side-item--on': d.no === active.no }"
            :aria-current="d.no === active.no ? 'page' : undefined"
            @click="open(d)"
          >
            <span class="no">{{ d.no }}</span>
            <span class="side-title">{{ t(d.title) }}</span>
          </button>
        </nav>

        <div class="main">
          <div class="doc-head">
            <div class="min-w-0">
              <span class="no">{{ active.no }}</span>
              <h2 class="doc-title">{{ t(active.title) }}</h2>
              <p class="desc mb-0">{{ t(active.desc) }}</p>
              <small class="meta"
                >{{ active.en }} · {{ active.version }} · {{ t(['기준일', 'Tanggal']) }}
                {{ active.date }}</small
              >
            </div>
            <div class="actions">
              <a
                class="btn btn-sm btn-outline-secondary"
                :href="coreDocUrl(active, lang)"
                target="_blank"
                rel="noopener"
              >
                {{ t(['새 창', 'Tab baru']) }} ↗
              </a>
              <a
                class="btn btn-sm btn-primary"
                :href="coreDocUrl(active, lang)"
                :download="coreDocFileName(active, lang)"
              >
                {{ t(['PDF 내려받기', 'Unduh PDF']) }}
              </a>
            </div>
          </div>
          <div class="asm-panel stage">
            <iframe
              :key="`${active.no}-${lang}`"
              :src="coreDocUrl(active, lang)"
              class="sheet"
              :title="t(active.title)"
            ></iframe>
          </div>
        </div>
      </div>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.docs {
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
.no {
  font-size: 11px;
  font-weight: 700;
  color: var(--asm-primary);
  letter-spacing: 0.03em;
}
.desc {
  font-size: 13px;
  color: var(--asm-fg-muted);
}
.meta {
  font-size: 12px;
  color: var(--asm-fg-muted);
}

/* 목록 카드 */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 12px;
}
.card-doc {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 16px;
  text-align: left;
  border: 1px solid var(--asm-border);
  background: var(--asm-card);
  color: var(--asm-fg);
  cursor: pointer;
  transition:
    border-color 0.15s,
    box-shadow 0.15s;
}
.card-doc:hover {
  border-color: var(--asm-primary);
}
.card-doc:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--asm-primary-40);
}
.card-doc .title {
  font-size: 15px;
}
.card-doc .en {
  font-size: 12px;
  color: var(--asm-fg-muted);
}
.card-doc .desc {
  flex: 1;
  margin-top: 4px;
}
.card-doc .meta {
  margin-top: 8px;
}

.empty {
  padding: 24px;
  font-size: 14px;
}

/* 하위 페이지 — 왼쪽 목록 + 오른쪽 뷰어 */
.viewer {
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  gap: 16px;
  align-items: start;
}
.side {
  display: flex;
  flex-direction: column;
  padding: 8px;
  gap: 2px;
  position: sticky;
  /* 고정 헤더(액센트 바 + 56px) 아래에 멈추도록 — 16px 만 두면 스크롤 시 헤더 밑으로 숨었습니다. */
  top: calc(var(--asm-header-offset) + 16px);
}
.side-item {
  display: flex;
  flex-direction: column;
  gap: 1px;
  text-align: left;
  border: 0;
  background: transparent;
  padding: 7px 10px;
  border-radius: var(--asm-radius-md);
  color: var(--asm-fg);
  font-size: 13px;
}
.side-item:hover {
  background: var(--asm-secondary);
}
.side-item--on,
.side-item--on:hover {
  background: var(--asm-primary-10);
  color: var(--asm-primary);
  font-weight: 700;
}
.main {
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-width: 0;
}
.doc-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
}
.doc-title {
  font-size: 18px;
  font-weight: 700;
  margin: 2px 0 4px;
}
.actions {
  display: flex;
  gap: 8px;
  flex: none;
}
.stage {
  padding: 0;
  overflow: hidden;
}
.sheet {
  display: block;
  width: 100%;
  height: calc(100vh - 220px);
  min-height: 520px;
  border: 0;
  background: #fff;
}

@media (max-width: 991.98px) {
  .viewer {
    grid-template-columns: minmax(0, 1fr);
  }
  /* 좁은 화면 — 목록은 가로로 흐르는 칩 줄로 */
  .side {
    position: static;
    flex-direction: row;
    overflow-x: auto;
  }
  .side-item {
    flex: none;
  }
  .side-title {
    display: none;
  }
  .doc-head {
    flex-direction: column;
  }
}
</style>
