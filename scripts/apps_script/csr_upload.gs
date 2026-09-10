/**
 * ASM CSR — 캡쳐 업로드 프록시 (Google Apps Script 웹앱)
 *
 * 왜 이게 필요한가: 브라우저(GitHub Pages)에서 Google Drive 에 바로 올리려면 OAuth 동의 화면과
 * 클라이언트 ID 가 필요합니다. 대신 이 스크립트를 소유자(Drive 폴더 주인) 계정으로 배포해 두면,
 * 앱은 여기에 base64 로 파일을 던지고 스크립트가 소유자 권한으로 Drive 에 씁니다.
 * 작업지시서 §8 — 캡쳐는 Drive 폴더 「내 드라이브/CSR_캡쳐」 에 보관, 화면은 thumbnail 링크로 표시.
 *
 * ── 배포 (한 번만, 폴더 소유자 계정으로) ──────────────────────────────────────
 *   1. https://script.google.com → 새 프로젝트 → 이 파일 내용을 Code.gs 에 붙여넣기
 *   2. (선택) 프로젝트 설정 → 스크립트 속성 → CSR_UPLOAD_TOKEN = 아무 긴 문자열
 *      → 같은 값을 앱의 VITE_CSR_UPLOAD_TOKEN 에 넣습니다. 없으면 토큰 검사를 건너뜁니다.
 *   3. 배포 → 새 배포 → 유형 「웹 앱」
 *        - 실행 사용자: 나(소유자)      ← Drive 쓰기 권한이 여기서 나옵니다
 *        - 액세스 권한: 모든 사용자     ← 앱 사용자는 Google 로그인 없이 호출
 *      → 처음 한 번 권한 승인(Drive 접근) → 「웹 앱 URL」(…/exec) 복사
 *   4. 그 URL 을 로컬 .env 와 GitHub Actions Variables 의 VITE_CSR_UPLOAD_URL 에 등록
 *   5. 코드를 고치면 배포 → 배포 관리 → 새 버전. URL 은 그대로입니다.
 *
 * ── 요청/응답 ───────────────────────────────────────────────────────────────
 *   POST <exec URL>   본문은 text/plain 의 JSON (application/json 이면 CORS preflight 가 생겨
 *                     Apps Script 가 받지 못합니다 — 그래서 text/plain)
 *     { "name": "xxx.png", "mime": "image/png", "data": "<base64>", "issueNo": "01", "token": "..." }
 *   → { "ok": true, "fileId": "...", "name": "...", "size": 12345, "url": "https://drive.google.com/file/d/.../view" }
 *   → { "ok": false, "error": "..." }
 *   GET  <exec URL>   → { "ok": true, "folder": "CSR_캡쳐", "version": "2026-09-10" }  (헬스체크)
 *
 * 파일은 이슈번호별 하위 폴더(예: CSR_캡쳐/01)에 넣고 「링크가 있는 모든 사용자 — 보기」로
 * 공유합니다. 화면의 https://drive.google.com/thumbnail?id=… 가 그 권한을 씁니다.
 * 비공개 캡쳐를 올리면 안 됩니다 — 링크를 아는 사람은 누구나 볼 수 있습니다.
 */

var FOLDER_ID = '1iEalwwo8BOP4HQnO6HQ8H_XYlhnwnGdV' // 내 드라이브/CSR_캡쳐
var MAX_BYTES = 15 * 1024 * 1024 // base64 디코딩 후 15 MB — 캡쳐는 보통 1 MB 미만입니다
var VERSION = '2026-09-10'

function doGet() {
  var folder = DriveApp.getFolderById(FOLDER_ID)
  return json_({ ok: true, folder: folder.getName(), version: VERSION })
}

function doPost(e) {
  try {
    var body = JSON.parse((e && e.postData && e.postData.contents) || '{}')

    var token = PropertiesService.getScriptProperties().getProperty('CSR_UPLOAD_TOKEN')
    if (token && body.token !== token) return json_({ ok: false, error: 'unauthorized' })

    if (!body.data || !body.name) return json_({ ok: false, error: 'name and data are required' })
    var bytes = Utilities.base64Decode(body.data)
    if (bytes.length > MAX_BYTES) return json_({ ok: false, error: 'file too large (>15MB)' })

    var mime = body.mime || 'application/octet-stream'
    if (mime.indexOf('image/') !== 0 && mime !== 'application/pdf')
      return json_({ ok: false, error: 'only images or PDF: ' + mime })

    var root = DriveApp.getFolderById(FOLDER_ID)
    var sub = getOrCreateFolder_(root, safeName_(body.issueNo || '_misc'))
    var file = sub.createFile(Utilities.newBlob(bytes, mime, safeName_(body.name)))
    file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW)

    return json_({
      ok: true,
      fileId: file.getId(),
      name: file.getName(),
      size: file.getSize(),
      url: 'https://drive.google.com/file/d/' + file.getId() + '/view',
    })
  } catch (err) {
    return json_({ ok: false, error: String(err && err.message ? err.message : err) })
  }
}

function getOrCreateFolder_(parent, name) {
  var it = parent.getFoldersByName(name)
  return it.hasNext() ? it.next() : parent.createFolder(name)
}

/**
 * 경로 구분자(슬래시·역슬래시)와 제어문자(코드 32 미만)만 '_' 로 바꿉니다. 한글 파일명은 그대로.
 * 정규식 대신 루프 — 편집기 복사 과정에서 이스케이프가 깨지는 일이 있어 문자 코드로 판정합니다.
 */
function safeName_(s) {
  var str = String(s)
  var out = ''
  for (var i = 0; i < str.length; i++) {
    var code = str.charCodeAt(i)
    var bad = code < 32 || code === 47 || code === 92 // 47 = '/', 92 = 역슬래시
    out += bad ? '_' : str.charAt(i)
  }
  return out.slice(0, 200) || 'file'
}

function json_(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON)
}
