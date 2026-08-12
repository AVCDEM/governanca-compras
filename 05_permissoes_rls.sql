-- ============================================================
-- GOVERNANÇA EM COMPRAS — Permissões finas (RLS) por usuário
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO (tatinrolrssjervuykej), como ÚLTIMO passo,
-- depois de testar tudo. Substitui as permissões abertas por
-- regras seguras. Reversível: rode o 02_permissoes.sql para reabrir.
--
-- Escopo (igual ao do sistema):
--  - Gabinete e DCC: veem tudo.
--  - Subsecretário: vê a sua subsecretaria.
--  - Ponto focal: vê a diretoria dele; ou a superintendência;
--    ou, se estiver vinculado a uma subsecretaria, a subsecretaria toda.
--
-- ATENÇÃO: rode só com o login por Auth funcionando, senão o
-- sistema para de ler dados (por segurança).
-- ============================================================

-- 1) Ativar RLS nas tabelas (sem isto, políticas não têm efeito)
alter table processos        enable row level security;
alter table processo_itens   enable row level security;
alter table processo_acoes   enable row level security;
alter table etapas           enable row level security;
alter table atualizacoes     enable row level security;
alter table resumos_semanais enable row level security;
alter table usuarios         enable row level security;

-- 2) Função auxiliar: registro do usuário logado
create or replace function usuario_logado()
returns usuarios
language sql stable security definer set search_path = public
as $$
  select * from usuarios
  where auth_id = auth.uid()
     or lower(email) = lower(auth.jwt() ->> 'email')
  limit 1;
$$;

-- 3) Remover políticas abertas temporárias (do 02)
drop policy if exists abrir_processos   on processos;
drop policy if exists abrir_usuarios     on usuarios;
drop policy if exists abrir_itens        on processo_itens;
drop policy if exists abrir_acoes        on processo_acoes;
drop policy if exists abrir_etapas       on etapas;
drop policy if exists abrir_atualizacoes on atualizacoes;
drop policy if exists abrir_resumos      on resumos_semanais;
-- e as que este script cria (idempotência ao rodar de novo)
drop policy if exists proc_leitura on processos;
drop policy if exists proc_escrita on processos;
drop policy if exists filhas_itens  on processo_itens;
drop policy if exists filhas_acoes  on processo_acoes;
drop policy if exists filhas_etapas on etapas;
drop policy if exists filhas_atual  on atualizacoes;
drop policy if exists filhas_resumos on resumos_semanais;
drop policy if exists user_leitura on usuarios;
drop policy if exists user_update_proprio on usuarios;

-- 4) Concessões: tirar do anon, dar ao authenticated
revoke all on processos, processo_itens, processo_acoes, etapas, atualizacoes, resumos_semanais, usuarios from anon;
grant select, insert, update, delete on processos, processo_itens, processo_acoes, etapas, atualizacoes, resumos_semanais, usuarios to authenticated;

-- 5) PROCESSOS: leitura conforme o escopo (bate com o sistema)
create policy proc_leitura on processos for select to authenticated
using (
  exists (
    select 1 from usuarios u
    where (u.auth_id = auth.uid() or lower(u.email) = lower(auth.jwt() ->> 'email'))
      and (
        u.nivel in ('gabinete','dcc')
        or (u.nivel = 'subsecretario' and u.subsecretaria = processos.subsecretaria)
        or (u.nivel = 'ponto_focal' and (
              -- vinculado a uma subsecretaria inteira
              (u.diretoria in ('SUBRAS','SUBVS','SUBASS','SUBGF','SUBR') and u.diretoria = processos.subsecretaria)
              or (u.superintendencia in ('SUBRAS','SUBVS','SUBASS','SUBGF','SUBR') and u.superintendencia = processos.subsecretaria)
              -- vinculado a uma diretoria
              or (u.diretoria is not null and u.diretoria = processos.diretoria)
              -- vinculado a uma superintendência
              or (u.superintendencia is not null and u.superintendencia = processos.superintendencia)
           ))
      )
  )
);

-- PROCESSOS: escrita só para ponto focal e DCC
create policy proc_escrita on processos for all to authenticated
using (
  exists (select 1 from usuarios u
    where (u.auth_id = auth.uid() or lower(u.email) = lower(auth.jwt() ->> 'email'))
      and u.nivel in ('ponto_focal','dcc'))
)
with check (
  exists (select 1 from usuarios u
    where (u.auth_id = auth.uid() or lower(u.email) = lower(auth.jwt() ->> 'email'))
      and u.nivel in ('ponto_focal','dcc'))
);

-- 6) Tabelas filhas: acesso a autenticados (refino por processo pai pode vir depois)
create policy filhas_itens   on processo_itens   for all to authenticated using (true) with check (true);
create policy filhas_acoes   on processo_acoes   for all to authenticated using (true) with check (true);
create policy filhas_etapas  on etapas           for all to authenticated using (true) with check (true);
create policy filhas_atual   on atualizacoes     for all to authenticated using (true) with check (true);
create policy filhas_resumos on resumos_semanais for all to authenticated using (true) with check (true);

-- 7) USUÁRIOS: cada um lê o próprio; DCC/gabinete leem todos
create policy user_leitura on usuarios for select to authenticated
using (
  auth_id = auth.uid()
  or lower(email) = lower(auth.jwt() ->> 'email')
  or exists (select 1 from usuarios u
       where (u.auth_id = auth.uid() or lower(u.email) = lower(auth.jwt() ->> 'email'))
         and u.nivel in ('gabinete','dcc'))
);

-- cada usuário atualiza o próprio registro (ex.: precisa_trocar_senha)
create policy user_update_proprio on usuarios for update to authenticated
using (auth_id = auth.uid() or lower(email) = lower(auth.jwt() ->> 'email'))
with check (auth_id = auth.uid() or lower(email) = lower(auth.jwt() ->> 'email'));

-- ============================================================
-- Fim. Só autenticados acessam, cada um no seu escopo.
-- Para reabrir tudo (se algo der errado): rode o 02_permissoes.sql
-- ============================================================
