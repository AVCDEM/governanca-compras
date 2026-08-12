-- ============================================================
-- COMPLEMENTO — Adicionar nível "diretoria"
-- ------------------------------------------------------------
-- Rode este ÚNICO script no SQL Editor. Ele:
--  1) adiciona o campo 'diretoria' em processos e usuarios;
--  2) atualiza a função meu_perfil() para devolver a diretoria.
-- (Junta o 06_diretoria.sql + a atualização da função do 04_auth.)
-- Seguro rodar mesmo que parte já exista (usa "if not exists" /
-- "create or replace").
-- ============================================================

-- 1) campos de diretoria
alter table processos add column if not exists diretoria text;
alter table usuarios  add column if not exists diretoria text;

create index if not exists idx_processos_diretoria on processos(diretoria);
create index if not exists idx_processos_super      on processos(superintendencia);
create index if not exists idx_processos_sub        on processos(subsecretaria);

-- 2) atualizar a função de perfil para incluir a diretoria
-- (apaga a versão antiga primeiro, pois o formato de retorno mudou)
drop function if exists meu_perfil();

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

grant execute on function meu_perfil() to authenticated;

-- ============================================================
-- Pronto. Processos e usuários agora têm 'diretoria', e o
-- perfil do usuário logado devolve esse campo.
-- ============================================================
