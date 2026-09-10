<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { STATUS_TONE, isConfigured } from '../config'
import { label, pickLang, pickPair } from '../i18n'
import { provideSidebarSummary } from '@/composables/useSummaryCards'
import CsrSignIn from '../components/CsrSignIn.vue'
import CsrPasswordDialog from '../components/CsrPasswordDialog.vue'
import { formatInt } from '@/utils/format'
import DefaultLayout from '@/layouts/DefaultLayout.vue'

const router = useRouter()
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()

onMounted(async () => {
  await session.refresh()
  if (session.isAuthenticated && !session.isUnregistered) await issues.load()
})

const lang = computed(() => issues.lang)
/** 표시 언어에 맞춘 라벨·값. 저장값은 원문 그대로이고 화면에서만 가릅니다(§8). */
const L = (key) => label(key, lang.value)
const V = (value) => pickLang(value, lang.value)

/**
 * 제목 — 화면 언어에 맞는 쪽을 고르고, 앞의 "02. " 번호는 뗍니다. 이슈번호 열이 따로 있어
 * 두 번 보였습니다(2026-09-10 요청). 표시만 바꿉니다. 저장된 제목은 Notion 원문 그대로입니다.
 * 정규식에 백슬래시를 쓰지 않는 이유: 셸 heredoc 을 거치며 유실된 적이 있습니다.
 */
const stripNo = (t) => (t ? String(t).replace(/^[0-9]+[.][ ]*/, '') : t)
const title = (row) => stripNo(pickPair(row.title_ko, row.title_id, lang.value))

// 요약 카드는 헤더의 브랜드 메뉴 → 「요약」 으로 열리는 좌측 드로어에 실립니다.
provideSidebarSummary(() => {
  const id = lang.value === 'id'
  return [
    {
      label: 'Total',
      value: formatInt(issues.counts.total),
      note: id ? 'tanpa arsip' : '아카이브 제외',
    },
    {
      label: 'Open',
      value: formatInt(issues.counts.open),
      tone: 'danger',
      note: id ? 'belum mulai' : '미착수',
    },
    {
      label: 'Ongoing',
      value: formatInt(issues.counts.ongoing),
      tone: 'warning',
      note: id ? 'berjalan' : '진행 중',
    },
    {
      label: 'Completed',
      value: formatInt(issues.counts.completed),
      tone: 'success',
      note: id ? 'menunggu verifikasi' : '검증 대기',
    },
    { label: 'Verified', value: formatInt(issues.counts.verified), note: id ? 'selesai' : '완료' },
  ]
})

const openDetail = (row) => router.push(`/csr/${encodeURIComponent(row.issue_no)}`)

/** 비밀번호 변경 — 최초 비밀번호(ascendo123)를 그대로 쓰지 않도록 눈에 띄는 곳에 둡니다. */
const passwordOpen = ref(false)
</script>

<template>
  <DefaultLayout>
    <section class="csr-list">
      <p class="asm-eyebrow">Manajemen Permintaan Perbaikan · 개선요청 관리</p>

      <!--
        고정 안내 (작업지시서 §5-4a) — 회신 주기를 목록 맨 위에 늘 띄웁니다. 두 언어를 함께
        적으라고 지시서가 문구까지 정해 두었으므로 토글과 무관하게 병기합니다.
      -->
      <div class="asm-footnote notice">
        IT부서 회신 갱신: 매주 금 17:00 WIB / Pembaruan balasan Tim IT: setiap Jumat 17:00 WIB
      </div>

      <!-- 설정 누락 · 미로그인 · 미등록은 각각 다른 안내가 필요합니다. -->
      <div v-if="!isConfigured()" class="asm-panel state">
        <h2 class="asm-title">설정이 필요합니다</h2>
        <p>
          <code>VITE_CSR_DATA_API_URL</code> · <code>VITE_CSR_AUTH_URL</code> 이 비어 있어 Neon 에
          연결할 수 없습니다. <code>.env</code> 를 확인하십시오.
        </p>
      </div>

      <div v-else-if="session.loading" class="asm-panel state">{{ L('loading') }}</div>

      <CsrSignIn v-else-if="!session.isAuthenticated" />

      <!--
        로그인은 됐지만 csr_user_roles 에 없는 상태. RLS 때문에 목록이 통째로 비어 나오는데,
        그냥 '결과 없음' 으로 두면 사용자는 데이터가 없는 줄 압니다.
      -->
      <div v-else-if="session.isUnregistered" class="asm-panel state">
        <h2 class="asm-title">접근 권한이 없습니다 · Tidak memiliki akses</h2>
        <p>
          계정은 확인되었으나 CSR 사용자로 등록되지 않았습니다({{ session.user?.email }}).
          관리자에게 역할 등록을 요청하십시오.
        </p>
        <button
          type="button"
          class="btn btn-sm btn-outline-secondary mt-3"
          @click="session.signOut()"
        >
          다른 계정으로 로그인
        </button>
      </div>

      <template v-else>
        <!-- 툴바 — 프리셋·언어 토글 (작업지시서 §5-2) -->
        <div class="toolbar">
          <div class="d-flex align-items-center gap-2 flex-wrap">
            <input
              v-model="issues.filters.search"
              type="search"
              class="form-control search"
              :placeholder="L('search')"
            />
            <button
              type="button"
              class="btn btn-sm btn-outline-secondary"
              @click="issues.applyPreset('it')"
            >
              {{ L('preset_it') }}
            </button>
            <button
              type="button"
              class="btn btn-sm btn-outline-secondary"
              @click="issues.applyPreset('pending')"
            >
              {{ L('preset_pending') }}
            </button>
            <button type="button" class="btn btn-sm btn-link" @click="issues.reset()">
              {{ L('reset') }}
            </button>
          </div>

          <div class="d-flex align-items-center gap-2">
            <span class="asm-pill">{{ session.role }}</span>
            <button
              type="button"
              class="btn btn-sm btn-link"
              :title="session.user?.email"
              @click="passwordOpen = true"
            >
              {{ lang === 'id' ? 'Ubah kata sandi' : '비밀번호 변경' }}
            </button>
            <button type="button" class="btn btn-sm btn-link" @click="session.signOut()">
              {{ lang === 'id' ? 'Keluar' : '로그아웃' }}
            </button>
            <!-- 언어 토글 — 기본 인도네시아어, 필요할 때 한국어 (작업지시서 §1) -->
            <div class="btn-group btn-group-sm" role="group" aria-label="언어 · Bahasa">
              <button
                type="button"
                class="btn"
                :class="lang === 'id' ? 'btn-primary' : 'btn-outline-secondary'"
                @click="issues.lang = 'id'"
              >
                ID
              </button>
              <button
                type="button"
                class="btn"
                :class="lang === 'ko' ? 'btn-primary' : 'btn-outline-secondary'"
                @click="issues.lang = 'ko'"
              >
                한국어
              </button>
            </div>
          </div>
        </div>

        <section class="asm-panel table-panel">
          <div class="table-toolbar">
            <h2 class="asm-title">{{ L('list_title') }}</h2>
            <span class="count-pill">{{ formatInt(issues.filtered.length) }}</span>
            <label class="archived">
              <input v-model="issues.filters.showArchived" type="checkbox" />
              {{ L('archived') }}
            </label>
          </div>

          <div class="table-scroll">
            <table class="table asm-table">
              <thead>
                <tr>
                  <th>{{ L('issue_no') }}</th>
                  <th>{{ L('title') }}</th>
                  <th>{{ L('it_status') }}</th>
                  <th>{{ L('verification_result') }}</th>
                  <th>{{ L('it_decision') }}</th>
                  <th>{{ L('it_pic') }}</th>
                  <th>{{ L('target_release_on') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="issues.loading">
                  <td colspan="7" class="empty-row">{{ L('loading') }}</td>
                </tr>
                <tr v-else-if="issues.error">
                  <td colspan="7" class="empty-row err">{{ issues.error }}</td>
                </tr>
                <tr v-else-if="!issues.filtered.length">
                  <td colspan="7" class="empty-row">{{ L('empty') }}</td>
                </tr>
                <tr
                  v-for="row in issues.filtered"
                  v-else
                  :key="row.id"
                  class="row-link"
                  :class="{ 'is-archived': row.is_archived }"
                  @click="openDetail(row)"
                >
                  <td class="no-col">{{ row.issue_no }}</td>
                  <!-- 말줄임 — 전체 제목은 title 툴팁으로. 겹침의 원인이던 넘침을 여기서 막습니다. -->
                  <td class="title-col" :title="title(row)">{{ title(row) }}</td>
                  <td>
                    <span
                      class="asm-badge"
                      :class="`asm-badge--${STATUS_TONE[row.it_status] ?? 'neutral'}`"
                    >
                      {{ row.it_status }}
                    </span>
                  </td>
                  <td class="nowrap">{{ V(row.verification_result) }}</td>
                  <td class="nowrap">{{ V(row.it_decision) }}</td>
                  <td class="nowrap">{{ row.it_pic }}</td>
                  <td class="nowrap">{{ row.target_release_on ?? '—' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </template>

      <CsrPasswordDialog v-if="passwordOpen" @close="passwordOpen = false" />
    </section>
  </DefaultLayout>
</template>

<style scoped>
.csr-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.notice {
  font-size: 12px;
}
.state {
  padding: 24px;
}
.state p {
  margin: 8px 0 0;
  color: var(--asm-fg-muted);
}
.err {
  color: var(--asm-danger);
}
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.search {
  width: 260px;
}
.table-toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 16px;
}
.count-pill {
  font-size: 11px;
  font-weight: 700;
  color: var(--asm-primary);
  background: var(--asm-primary-soft);
  padding: 2px 8px;
  border-radius: 9999px;
}
.archived {
  margin-left: auto;
  font-size: 12px;
  color: var(--asm-fg-muted);
  display: flex;
  align-items: center;
  gap: 6px;
}
.table-scroll {
  overflow-x: auto;
}
/*
 * 제목 말줄임 — max-width 만 두면 표 셀은 내용을 자르지 않고 옆 열 위로 흘러 나옵니다
 * (IT상태 배지와 글자가 겹치던 원인, 2026-09-10). overflow·nowrap·ellipsis 세 가지가
 * 함께 있어야 표 셀에서 말줄임이 동작합니다.
 */
.title-col {
  max-width: 420px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.no-col {
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
}
.nowrap {
  white-space: nowrap;
}
.row-link {
  cursor: pointer;
}
/* 아카이브는 표시하더라도 살아 있는 건과 구분되어야 합니다. */
.is-archived {
  opacity: 0.55;
}
.is-archived .no-col::after {
  content: ' (삭제)';
  font-size: 10px;
  color: var(--asm-fg-muted);
}
.empty-row {
  text-align: center;
  color: var(--asm-fg-muted);
  font-size: 12px;
  padding: 48px !important;
}
</style>
