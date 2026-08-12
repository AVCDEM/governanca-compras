-- ============================================================
-- GOVERNANÇA EM COMPRAS — Camada de Autenticação (Auth)
-- ------------------------------------------------------------
-- Rode no SQL Editor do Supabase (projeto novo), APÓS já ter
-- rodado o 01_tabelas.sql.
--
-- O que este script faz:
--  1) Prepara a tabela 'usuarios' para se ligar ao cofre de
--     autenticação do Supabase (auth.users), pelo e-mail.
--  2) Adiciona o controle de "trocar senha no primeiro acesso".
--  3) Cria a função que, ao logar, devolve os dados do usuário
--     (nível e área) de forma segura.
-- ============================================================

-- 1) Coluna que liga o usuário ao cofre de autenticação (auth.users.id)
alter table usuarios add column if not exists auth_id uuid;

-- 2) Controle de primeiro acesso (trocar senha)
alter table usuarios add column if not exists precisa_trocar_senha boolean default true;

-- Índice para busca rápida por auth_id
create index if not exists idx_usuarios_auth on usuarios(auth_id);

-- ------------------------------------------------------------
-- 3) Função que devolve o perfil do usuário logado (seguro)
--    O sistema chama isto após o login para saber nível e área.
--    SECURITY DEFINER: roda com permissão elevada, mas só
--    devolve os dados do próprio usuário autenticado.
-- ------------------------------------------------------------
create or replace function meu_perfil()
returns table (
  id bigint,
  email text,
  nome text,
  nivel text,
  area text,
  subsecretaria text,
  superintendencia text,
  diretoria text,
  precisa_trocar_senha boolean
)
language sql
security definer
set search_path = public
as $$
  select u.id, u.email, u.nome, u.nivel, u.area,
         u.subsecretaria, u.superintendencia, u.diretoria, u.precisa_trocar_senha
  from usuarios u
  where u.auth_id = auth.uid()
     or lower(u.email) = lower(auth.jwt() ->> 'email')
  limit 1;
$$;

-- Permitir que usuários autenticados chamem a função
grant execute on function meu_perfil() to authenticated;

-- ------------------------------------------------------------
-- 4) Gatilho: quando alguém troca a senha (primeiro acesso),
--    o sistema atualiza 'precisa_trocar_senha' via chamada própria.
--    (Tratado no código do sistema; sem gatilho automático aqui.)
-- ============================================================
-- Fim. Próximo passo: vincular usuários ao Auth (roteiro à parte).
-- ============================================================
