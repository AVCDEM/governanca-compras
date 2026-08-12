-- ============================================================
-- GOVERNANÇA EM COMPRAS — Liberação de acesso (permissões)
-- ------------------------------------------------------------
-- Rode este script no SQL Editor do Supabase, no projeto novo.
-- Ele libera leitura e escrita nas 7 tabelas para o sistema.
--
-- OBS: por ora liberamos acesso amplo (role 'anon'), para o
-- sistema funcionar já. Quando implementarmos o login (Auth),
-- vamos trocar isso por permissões finas por usuário (RLS).
-- ============================================================

-- Concede leitura e escrita ao papel público (anon) usado pelo sistema
GRANT SELECT, INSERT, UPDATE, DELETE ON public.usuarios          TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.processos         TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.processo_itens    TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.processo_acoes    TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.etapas            TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.atualizacoes      TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.resumos_semanais  TO anon;

-- As tabelas usam colunas de identidade (id gerado automaticamente),
-- então não há sequences separadas para conceder. Mas por segurança,
-- garantimos acesso a eventuais sequences do schema:
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;

-- ------------------------------------------------------------
-- Row Level Security (RLS): o Supabase habilita por padrão em
-- tabelas novas. Para o sistema funcionar agora (antes do Auth),
-- criamos políticas abertas. Serão substituídas por regras por
-- usuário quando implementarmos o login.
-- ------------------------------------------------------------
ALTER TABLE public.usuarios          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.processos         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.processo_itens    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.processo_acoes    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.etapas            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.atualizacoes      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resumos_semanais  ENABLE ROW LEVEL SECURITY;

-- Políticas abertas (temporárias, até o Auth)
DROP POLICY IF EXISTS abrir_usuarios ON public.usuarios;
CREATE POLICY abrir_usuarios ON public.usuarios FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS abrir_processos ON public.processos;
CREATE POLICY abrir_processos ON public.processos FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS abrir_itens ON public.processo_itens;
CREATE POLICY abrir_itens ON public.processo_itens FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS abrir_acoes ON public.processo_acoes;
CREATE POLICY abrir_acoes ON public.processo_acoes FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS abrir_etapas ON public.etapas;
CREATE POLICY abrir_etapas ON public.etapas FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS abrir_atualizacoes ON public.atualizacoes;
CREATE POLICY abrir_atualizacoes ON public.atualizacoes FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS abrir_resumos ON public.resumos_semanais;
CREATE POLICY abrir_resumos ON public.resumos_semanais FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- Pronto. Agora o sistema consegue ler e gravar.
-- Teste o cadastro novamente após rodar este script.
-- ============================================================
