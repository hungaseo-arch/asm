/**
 * 캡쳐 업로드 (Capture upload / Unggah tangkapan)
 *
 * 흐름: 파일 → base64 → Apps Script 웹앱(scripts/apps_script/csr_upload.gs) → Drive 파일 ID →
 * csr_attachments 행. Drive 에 직접 쓰지 않는 이유는 .gs 머리말 참조(OAuth 동의 화면 회피).
 *
 * 본문을 text/plain 으로 보냅니다 — application/json 이면 브라우저가 preflight(OPTIONS)를 먼저
 * 보내는데 Apps Script 는 OPTIONS 에 답하지 않아 요청이 죽습니다. 단순 요청(text/plain)은
 * preflight 없이 바로 갑니다. 리다이렉트(302 → script.googleusercontent.com)는 fetch 가 따라갑니다.
 */
import { getDb, unwrap } from './neon'
import { UPLOAD_TOKEN, UPLOAD_URL } from '../config'

export const isUploadConfigured = () => Boolean(UPLOAD_URL)

/** 캡쳐로 받는 형식. Apps Script 쪽(.gs)도 같은 제한을 겁니다. */
const ACCEPT = /^image\/|^application\/pdf$/
const MAX_BYTES = 15 * 1024 * 1024

function toBase64(file) {
  return new Promise((resolve, reject) => {
    const r = new FileReader()
    r.onload = () => resolve(String(r.result).split(',')[1] ?? '')
    r.onerror = () => reject(r.error ?? new Error('read failed'))
    r.readAsDataURL(file)
  })
}

/** Drive 에 올리고 { fileId, name, size, url } 를 돌려줍니다. csr_attachments 에는 넣지 않습니다. */
export async function uploadToDrive(file, { issueNo } = {}) {
  if (!UPLOAD_URL) throw new Error('VITE_CSR_UPLOAD_URL 이 설정되지 않았습니다')
  if (!ACCEPT.test(file.type))
    throw new Error(`이미지 또는 PDF 만 올릴 수 있습니다 (${file.type || '?'})`)
  if (file.size > MAX_BYTES) throw new Error('15 MB 를 넘는 파일입니다')

  const data = await toBase64(file)
  const res = await fetch(UPLOAD_URL, {
    method: 'POST',
    // content-type 을 지정하지 않습니다 → text/plain;charset=UTF-8 → preflight 없음
    body: JSON.stringify({ name: file.name, mime: file.type, data, issueNo, token: UPLOAD_TOKEN }),
  })
  let out
  try {
    out = await res.json()
  } catch {
    throw new Error(`업로드 프록시 응답을 읽지 못했습니다 (HTTP ${res.status})`)
  }
  if (!out?.ok) throw new Error(out?.error ?? `업로드 실패 (HTTP ${res.status})`)
  return out
}

/**
 * 캡쳐 한 장을 올리고 csr_attachments 에 등록합니다. 반환은 새 행.
 * 등록 권한은 RLS(business·admin)가 판정합니다 — Drive 에는 올라갔는데 행 INSERT 가 42501 로
 * 거부되면 파일은 Drive 에 남습니다(관리자가 폴더에서 지우면 됩니다). 순서를 뒤집으면 행만
 * 남고 파일이 없는 더 나쁜 상태가 되므로 이 순서를 유지합니다.
 */
export async function uploadCapture(
  file,
  { issueId, issueNo, uploadedBy, caption = null, sortOrder = 0 },
) {
  const drive = await uploadToDrive(file, { issueNo })
  const rows = unwrap(
    await getDb()
      .from('csr_attachments')
      .insert({
        issue_id: issueId,
        drive_file_id: drive.fileId,
        file_name: drive.name,
        caption,
        sort_order: sortOrder,
        uploaded_by: uploadedBy ?? null,
      })
      .select('*'),
  )
  return rows?.[0] ?? null
}

/** 첨부 행 삭제 — admin 만(RLS). Drive 파일은 남습니다(복구 여지). */
export async function removeAttachment(id) {
  unwrap(await getDb().from('csr_attachments').delete().eq('id', id).select('id'))
}
