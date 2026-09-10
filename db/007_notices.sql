-- =============================================================================
-- ASM CSR — 공지(알림) 테이블
--   001~003 적용 후 언제든 실행 가능. 화면: /csr/notices (헤더 종 아이콘)
--
-- ── 왜 필요한가 ─────────────────────────────────────────────────────────────
-- 헤더의 「알림」이 안내 토스트만 띄우고 있었습니다. 관리자가 공지를 써서 전원에게
-- 보이도록 합니다(2026-09-10 요청). 저장은 CSR 과 같은 Neon 이라 같은 RLS 체계를 씁니다 —
-- 읽기는 등록 사용자 전원, 쓰기는 admin 만.
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.csr_notices (
  id          bigserial PRIMARY KEY,
  title       text NOT NULL,
  body_md     text,                                  -- 본문(마크다운 원문 그대로)
  is_pinned   boolean NOT NULL DEFAULT false,        -- 위에 고정
  published_on date NOT NULL DEFAULT (now() AT TIME ZONE 'Asia/Jakarta')::date,
  expires_on  date,                                  -- 지나면 목록에서 접힘(삭제 아님)
  created_by  text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE public.csr_notices IS '관리자 공지. 읽기는 등록 사용자 전원, 쓰기는 admin.';

CREATE INDEX IF NOT EXISTS csr_notices_order_idx
  ON public.csr_notices (is_pinned DESC, published_on DESC, id DESC);

ALTER TABLE public.csr_notices ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS csr_notices_select ON public.csr_notices;
DROP POLICY IF EXISTS csr_notices_write  ON public.csr_notices;

CREATE POLICY csr_notices_select ON public.csr_notices
  FOR SELECT USING (public.csr_role() IS NOT NULL);

CREATE POLICY csr_notices_write ON public.csr_notices
  FOR ALL
  USING (public.csr_role() = 'admin')
  WITH CHECK (public.csr_role() = 'admin');

-- updated_at 자동 갱신 — 공지는 고쳐 쓰는 일이 잦아 '언제 마지막으로 바뀌었나'가 필요합니다.
CREATE OR REPLACE FUNCTION public.csr_notices_touch()
RETURNS trigger LANGUAGE plpgsql AS $fn$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$fn$;
DROP TRIGGER IF EXISTS csr_notices_touch ON public.csr_notices;
CREATE TRIGGER csr_notices_touch BEFORE UPDATE ON public.csr_notices
  FOR EACH ROW EXECUTE FUNCTION public.csr_notices_touch();

-- Data API 권한 — 정책만으로는 PostgREST 가 테이블에 닿지 못합니다(002 와 같은 이유).
DO $grant$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.csr_notices TO authenticated;
    GRANT USAGE, SELECT ON public.csr_notices_id_seq TO authenticated;
  END IF;
END;
$grant$;

-- 작업지시서 §5-4a 의 고정 안내 — 목록 화면에 박아 두던 문구를 공지 체계로 옮깁니다(2026-09-10
-- 「상단으로 일원화」). 고정 공지라 목록 맨 위에 늘 뜨고, 이제 관리자가 문구를 고칠 수 있습니다.
INSERT INTO public.csr_notices (title, body_md, is_pinned, created_by)
SELECT 'IT부서 회신 갱신: 매주 금 17:00 WIB / Pembaruan balasan Tim IT: setiap Jumat 17:00 WIB',
       NULL, true, 'seed'
 WHERE NOT EXISTS (SELECT 1 FROM public.csr_notices WHERE created_by = 'seed');

COMMIT;

-- ─── 확인 ────────────────────────────────────────────────────────────────────
-- ※ 적용 후 Data API 화면에서 Refresh schema cache 를 눌러야 /csr/notices 가 404 를 내지 않습니다.
SELECT relname, relrowsecurity FROM pg_class WHERE relname = 'csr_notices';
SELECT policyname FROM pg_policies WHERE tablename = 'csr_notices' ORDER BY 1;
