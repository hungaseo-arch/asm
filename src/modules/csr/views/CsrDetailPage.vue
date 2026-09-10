<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getDb, unwrap } from '../api/neon'
import { useCsrSessionStore } from '../stores/session'
import { useCsrIssuesStore } from '../stores/issues'
import { STATUS_TONE, isConfigured } from '../config'
import DefaultLayout from '@/layouts/DefaultLayout.vue'

const route = useRoute()
const router = useRouter()
const session = useCsrSessionStore()
const issues = useCsrIssuesStore()

const issue = ref(null)
const replies = ref([])
const verifications = ref([])
const attachments = ref([])
const loading = ref(true)
const error = ref('')

/**
 * 아카이브된 건과 살아 있는 건이 같은 번호를 쓸 수 있습니다(48·50·52). 번호만으로는
 * 한 건을 특정할 수 없어, 두 건이 잡히면 살아 있는 쪽을 먼저 보여 줍니다.
 */
async function load() {
  if (!isConfigured()) {
    error.value = 'Neon 접속 정보가 설정되지 않았습니다'
    loading.value = false
    return
  }
  loading.value = true
  error.value = ''
  try {
    const db = getDb()
    const rows = unwrap(
      await db.from('csr_issues').select('*').eq('issue_no', route.params.issueNo),
    )
    issue.value = rows?.find((r) => !r.is_archived) ?? rows?.[0] ?? null
    if (!issue.value) {
      error.value = '해당 개선요청을 찾을 수 없습니다'
      return
    }
    const id = issue.value.id
    replies.value = unwrap(await db.from('csr_it_replies').select('*').eq('issue_id', id)) ?? []
    verifications.value =
      unwrap(await db.from('csr_verifications').select('*').eq('issue_id', id)) ?? []
    attachments.value =
      unwrap(await db.from('csr_attachments').select('*').eq('issue_id', id)) ?? []
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await session.refresh()
  if (session.isAuthenticated && !session.isUnregistered) await load()
  else loading.value = false
})
watch(() => route.params.issueNo, load)

const lang = computed(() => issues.lang)
const pick = (ko, id) => (lang.value === 'id' ? (id ?? ko) : (ko ?? id))

/** 최신 회신이 위로 — 회차가 쌓이면 아래로 스크롤해서 찾게 됩니다. */
const sortedReplies = computed(() =>
  [...replies.value].sort((a, b) => String(b.replied_on).localeCompare(String(a.replied_on))),
)
const sortedVerifications = computed(() =>
  [...verifications.value].sort((a, b) =>
    String(b.verified_on).localeCompare(String(a.verified_on)),
  ),
)

/** Drive 썸네일 — uc?export=view 는 대용량·권한 문제가 있어 쓰지 않습니다(작업지시서 §8). */
const thumb = (fileId) => `https://drive.google.com/thumbnail?id=${fileId}&sz=w1200`
</script>

<template>
  <DefaultLayout>
    <section class="csr-detail">
      <button type="button" class="btn btn-sm btn-link back" @click="router.push('/csr')">
        ← 목록으로
      </button>

      <div v-if="loading" class="asm-panel state">불러오는 중…</div>
      <div v-else-if="error" class="asm-panel state err">{{ error }}</div>
      <div v-else-if="!session.isAuthenticated" class="asm-panel state">로그인이 필요합니다</div>

      <template v-else-if="issue">
        <!-- 속성 카드 (작업지시서 §5-2 상단) -->
        <header class="asm-panel head">
          <div class="head-top">
            <span class="issue-no">{{ issue.issue_no }}</span>
            <span
              class="asm-badge"
              :class="`asm-badge--${STATUS_TONE[issue.it_status] ?? 'neutral'}`"
            >
              {{ issue.it_status }}
            </span>
            <span v-if="issue.is_archived" class="asm-badge asm-badge--neutral">삭제됨</span>
            <a
              v-if="issue.notion_url"
              :href="issue.notion_url"
              target="_blank"
              rel="noopener"
              class="notion-link"
            >
              Notion 원본 ↗
            </a>
          </div>
          <h1>{{ pick(issue.title_ko, issue.title_id) }}</h1>

          <dl class="props">
            <div>
              <dt>화면경로</dt>
              <dd>{{ issue.path_menu ?? '—' }}</dd>
            </div>
            <div>
              <dt>유형</dt>
              <dd>{{ issue.issue_type ?? '—' }}</dd>
            </div>
            <div>
              <dt>중요도</dt>
              <dd>{{ issue.priority ?? '—' }}</dd>
            </div>
            <div>
              <dt>오픈구분</dt>
              <dd>{{ issue.go_live_category ?? '—' }}</dd>
            </div>
            <div>
              <dt>요청부서</dt>
              <dd>{{ issue.request_dept ?? '—' }}</dd>
            </div>
            <div>
              <dt>요청일</dt>
              <dd>{{ issue.requested_on ?? '—' }}</dd>
            </div>
            <div>
              <dt>담당자</dt>
              <dd>{{ issue.it_pic ?? '—' }}</dd>
            </div>
            <div>
              <dt>목표배포일</dt>
              <dd>{{ issue.target_release_on ?? '—' }}</dd>
            </div>
            <div>
              <dt>IT수용여부</dt>
              <dd>{{ issue.it_decision ?? '—' }}</dd>
            </div>
            <div>
              <dt>현업검증</dt>
              <dd>{{ issue.verification_result ?? '—' }}</dd>
            </div>
            <div>
              <dt>최종검증일</dt>
              <dd>{{ issue.verified_on ?? '—' }}</dd>
            </div>
            <div>
              <dt>관련이슈</dt>
              <dd>{{ issue.related_issues ?? '—' }}</dd>
            </div>
          </dl>
        </header>

        <!-- §1 캡쳐 -->
        <section class="asm-panel sec">
          <h2 class="asm-title">1. 캡쳐 · Screen Shot</h2>
          <p v-if="!attachments.length" class="muted">
            첨부가 없습니다. (Notion 이관분은 Apps Script 업로드 프록시 준비 후 옮깁니다)
          </p>
          <div v-else class="gallery">
            <a
              v-for="a in attachments"
              :key="a.id"
              :href="`https://drive.google.com/file/d/${a.drive_file_id}/view`"
              target="_blank"
              rel="noopener"
            >
              <img :src="thumb(a.drive_file_id)" :alt="a.caption ?? a.file_name ?? ''" />
            </a>
          </div>
        </section>

        <section v-if="issue.findings_md" class="asm-panel sec">
          <h2 class="asm-title">2. 현상 · Findings</h2>
          <pre class="md">{{ issue.findings_md }}</pre>
        </section>

        <section v-if="issue.recommendation_md" class="asm-panel sec">
          <h2 class="asm-title">3. 개선 의견 · Recommendation</h2>
          <pre class="md">{{ issue.recommendation_md }}</pre>
        </section>

        <section class="asm-panel sec">
          <h2 class="asm-title">4. 수용기준</h2>
          <pre class="md">{{ pick(issue.acceptance_ko, issue.acceptance_id) ?? '—' }}</pre>
        </section>

        <!-- §5 IT부서 회신 (회차별) -->
        <section class="asm-panel sec">
          <h2 class="asm-title">5. IT부서 회신 · Balasan Tim IT</h2>
          <p v-if="!sortedReplies.length" class="muted">아직 회신이 없습니다.</p>
          <article v-for="r in sortedReplies" :key="r.id" class="reply">
            <h3>{{ r.replied_on }}</h3>
            <dl>
              <div>
                <dt>수용 여부</dt>
                <dd>{{ r.decision ?? '—' }}</dd>
              </div>
              <div>
                <dt>개선 내역</dt>
                <dd>{{ r.fix_plan ?? '—' }}</dd>
              </div>
              <div>
                <dt>추가 설명</dt>
                <dd>{{ r.note ?? '—' }}</dd>
              </div>
              <div>
                <dt>의사결정 사항</dt>
                <dd>{{ r.needs_decision ?? '—' }}</dd>
              </div>
              <div>
                <dt>담당자 · 목표 배포일</dt>
                <dd>{{ r.pic_and_target ?? '—' }}</dd>
              </div>
            </dl>
          </article>
        </section>

        <section v-if="issue.business_answer_md" class="asm-panel sec">
          <h2 class="asm-title">
            6. 현업 답변 · Tanggapan Tim Bisnis
            <small v-if="issue.business_answered_on">({{ issue.business_answered_on }})</small>
          </h2>
          <pre class="md">{{ issue.business_answer_md }}</pre>
        </section>

        <!-- §7 검증 이력 -->
        <section class="asm-panel sec">
          <h2 class="asm-title">7. 검증 이력 · Riwayat Verifikasi</h2>
          <p v-if="!sortedVerifications.length" class="muted">검증 이력이 없습니다.</p>
          <table v-else class="table asm-table">
            <thead>
              <tr>
                <th>일자</th>
                <th>결과</th>
                <th>내용</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="v in sortedVerifications" :key="v.id">
                <td class="nowrap">{{ v.verified_on }}</td>
                <td class="nowrap">{{ v.result }}</td>
                <td>{{ v.note }}</td>
              </tr>
            </tbody>
          </table>
        </section>
      </template>
    </section>
  </DefaultLayout>
</template>

<style scoped>
.csr-detail {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.back {
  align-self: flex-start;
  padding-left: 0;
}
.state {
  padding: 24px;
}
.err {
  color: var(--asm-danger);
}
.muted {
  color: var(--asm-fg-muted);
  font-size: 12px;
  margin: 0;
}
.head {
  padding: 20px 24px;
}
.head-top {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.issue-no {
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}
.notion-link {
  margin-left: auto;
  font-size: 12px;
}
.head h1 {
  font-size: 20px;
  font-weight: 700;
  margin: 8px 0 16px;
  line-height: 1.4;
}
/* 속성은 두 줄짜리 정의 목록을 격자로 흘립니다 — 항목이 12개라 표로 두면 세로로 길어집니다. */
.props {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 12px 24px;
  margin: 0;
}
.props div {
  min-width: 0;
}
.props dt {
  font-size: 11px;
  color: var(--asm-fg-muted);
  font-weight: 500;
}
.props dd {
  margin: 2px 0 0;
  font-size: 13px;
  overflow-wrap: anywhere;
}
.sec {
  padding: 20px 24px;
}
.sec > h2 {
  margin: 0 0 12px;
}
.sec small {
  font-weight: 500;
  color: var(--asm-fg-muted);
}
/*
 * 본문은 Notion 마크다운 원문입니다. 렌더러를 붙이면 의존성이 하나 더 늘고(§9 승인 대상)
 * 원문과 화면이 어긋날 여지가 생겨, 줄바꿈만 지켜 그대로 보여 줍니다.
 */
.md {
  margin: 0;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  font-family: inherit;
  font-size: 13px;
  line-height: 1.7;
}
.reply {
  border-top: 1px solid var(--asm-border);
  padding-top: 12px;
  margin-top: 12px;
}
.reply:first-of-type {
  border-top: 0;
  padding-top: 0;
  margin-top: 0;
}
.reply h3 {
  font-size: 13px;
  font-weight: 700;
  color: var(--asm-primary);
  margin: 0 0 8px;
}
.reply dl {
  margin: 0;
  display: grid;
  gap: 8px;
}
.reply dt {
  font-size: 11px;
  color: var(--asm-fg-muted);
}
.reply dd {
  margin: 2px 0 0;
  font-size: 13px;
  overflow-wrap: anywhere;
}
.gallery {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}
.gallery img {
  max-height: 200px;
  border: 1px solid var(--asm-border);
  border-radius: var(--asm-radius-md);
}
.nowrap {
  white-space: nowrap;
}
</style>
