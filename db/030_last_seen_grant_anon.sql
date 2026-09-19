-- =============================================================================
-- 최종 접속 RPC 노출 — anonymous GRANT (2026-09-15). 029 적용 후 실행. 재실행 안전.
--
--   ※ 이 파일은 증상의 원인이 아니었습니다. 기록을 위해 경과를 남깁니다.
--
--   증상: 관리 화면 「최종 접속」이 계속 빈칸. 앱 콘솔에
--         PGRST202 "Could not find the function public.csr_touch_last_seen
--         without parameters in the schema cache".
--
--   확인한 것 — DB 쪽은 처음부터 정상이었습니다.
--     · 함수 존재, SECURITY DEFINER, owner = neondb_owner
--     · has_function_privilege('authenticated', ..., 'EXECUTE') = true
--     · 아래 GRANT 로 anonymous 까지 준 뒤에도 PGRST202 그대로
--
--   실제 원인: Neon Data API 의 PostgREST 가 `NOTIFY pgrst, 'reload schema'` 를
--   듣지 않습니다. 콘솔에서 **Data API 를 껐다 켜** 스키마 캐시를 다시 만들게 하니
--   즉시 해소됐습니다. 앞으로 함수(RPC)를 새로 만들면 NOTIFY 로는 부족하고
--   Data API 재시작이 필요합니다 — 이 저장소의 첫 RPC 라 이번에 드러났습니다.
--
--   2026-09-19 갱신: 함수뿐 아니라 **컬럼을 새로 만들 때도** 같습니다(036 의
--   csr_verifications.it_status_at — DB 에는 값이 다 들어갔는데 화면은 계속 빈칸).
--   그리고 이제 콘솔 **Data API 화면에 「Refresh schema cache」 버튼**이 있습니다.
--   껐다 켜지 않아도 이 버튼 한 번이면 됩니다 — 이쪽을 먼저 쓰십시오.
--
--   그래도 이 GRANT 를 남기는 이유: 015 의 csr_actor_id() 도 authenticated ·
--   anonymous 두 역할에 모두 주었습니다. 029 만 authenticated 하나여서 선례와
--   어긋나 있었고, 맞춰 두는 편이 일관됩니다. 열어도 권한이 새지 않습니다 —
--   인자가 없고 대상이 언제나 호출자 자신(csr_actor_id())이라, 로그인 전 세션은
--   csr_actor_id() 가 NULL 이어서 029 본문이 아무것도 갱신하지 않고 NULL 을 돌려줍니다.
-- =============================================================================

GRANT EXECUTE ON FUNCTION public.csr_touch_last_seen() TO anonymous;

-- 참고 — 이 NOTIFY 는 Neon Data API 에 효과가 없었습니다(위 경과). 표준 PostgREST 용.
NOTIFY pgrst, 'reload schema';

-- 확인 — 두 역할 모두 EXECUTE 여야 합니다.
SELECT has_function_privilege('authenticated', 'public.csr_touch_last_seen()', 'EXECUTE') AS auth_exec_ok,
       has_function_privilege('anonymous',     'public.csr_touch_last_seen()', 'EXECUTE') AS anon_exec_ok;
