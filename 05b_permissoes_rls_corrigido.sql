-- ============================================================
-- GOVERNANÇA EM COMPRAS — RLS por usuário (versão corrigida)
-- Substitui o 05_permissoes_rls.sql. O original fica no repositório
-- para consulta, mas NÃO deve ser executado: ver os 3 problemas abaixo.
-- ============================================================
--
-- O QUE ESTE ARQUIVO CORRIGE EM RELAÇÃO AO 05
--
-- 1) VAZAMENTO DE LEITURA (grave)
--    No 05, "proc_escrita" era FOR ALL. No Postgres, FOR ALL inclui
--    SELECT, e policies permissivas se somam com OR. Como o USING dela
--    só exigia nivel in ('ponto_focal','dcc'), qualquer ponto focal
--    passava por ali e lia TODOS os processos — anulando todo o escopo
--    construído em proc_leitura.
--    Aqui a escrita é dividida em INSERT / UPDATE / DELETE, sem SELECT.
--
-- 2) HISTÓRICO SEM ESCOPO
--    No 05, as tabelas filhas eram "using (true)": qualquer autenticado
--    lia e apagava as etapas, itens, ações e resumos de qualquer
--    processo, inclusive os que nem aparecem na lista dele.
--    Aqui cada filha herda o escopo do processo pai.
--
-- 3) TRÊS TABELAS FICAVAM ABERTAS
--    O 05 não mexia em prazos_fase, modalidades e feriados: elas
--    continuavam com policy public/true/true e permissão de escrita
--    para 'anon'. Aqui viram leitura para autenticados.
--
-- Além disso, a regra de escopo do ponto focal passa a usar
-- ESPECIFICIDADE (diretoria, senão superintendência, senão
-- subsecretaria), igual ao if/else-if do front-end. No 05 eram
-- condições soltas com OR, e o banco entregava mais do que a tela.
--
-- ------------------------------------------------------------
-- PRÉ-REQUISITOS (confira ANTES de rodar)
--   a) O front-end precisa enviar o access_token nas chamadas REST.
--      Sem isso o PostgREST atende como 'anon' e TUDO para de
--      responder. Já corrigido no index.html (sbFetch/sbAuthHeaders),
--      mas essa versão precisa estar publicada.
--   b) Rode antes a consulta de QUEM FICA DE FORA (no fim deste
--      arquivo, comentada) e resolva as pendências.
--
-- ROLLBACK: rode 02_permissoes.sql — reabre tudo em segundos.
-- É seguro rodar este arquivo mais de uma vez (idempotente).
-- ============================================================

begin;

-- 1) RLS ligado em todas as tabelas ---------------------------
alter table processos        enable row level security;
alter table processo_itens   enable row level security;
alter table processo_acoes   enable row level security;
alter table etapas           enable row level security;
alter table atualizacoes     enable row level security;
alter table resumos_semanais enable row level security;
alter table usuarios         enable row level security;
alter table prazos_fase      enable row level security;
alter table modalidades      enable row level security;
alter table feriados         enable row level security;

-- 2) Funções auxiliares --------------------------------------
-- SECURITY DEFINER: consultam 'usuarios' por fora do RLS, senão a
-- policy de usuarios chamaria a si mesma em recursão.

create or replace function usuario_logado()
returns usuarios
language sql stable security definer set search_path = public
as $$
  select * from usuarios
  where (auth_id = auth.uid() or lower(email) = lower(auth.jwt() ->> 'email'))
    and coalesce(ativo, true)
  limit 1;
$$;

-- Um processo é visível para o usuário logado?
-- Espelha exatamente a cascata do front-end (atualizarListas).
create or replace function processo_visivel(p processos)
returns boolean
language sql stable security definer set search_path = public
as $$
  with u as (select * from usuario_logado())
  select coalesce((
    select case
      when u.nivel in ('gabinete','dcc') then true
      when u.nivel = 'subsecretario' then u.subsecretaria is not distinct from p.subsecretaria
      when u.nivel = 'ponto_focal' then
        case
          -- vinculado a uma diretoria de verdade
          when u.diretoria is not null
           and u.diretoria not in ('SUBRAS','SUBVS','SUBASS','SUBGF','SUBR')
            then u.diretoria = p.diretoria
          -- senão, a uma superintendência de verdade
          when u.superintendencia is not null
           and u.superintendencia not in ('SUBRAS','SUBVS','SUBASS','SUBGF','SUBR')
            then u.superintendencia = p.superintendencia
          -- senão, a uma subsecretaria inteira
          when u.subsecretaria is not null then u.subsecretaria = p.subsecretaria
          -- órgão de nível 1 gravado nos campos de baixo
          when u.superintendencia in ('SUBRAS','SUBVS','SUBASS','SUBGF','SUBR')
            then u.superintendencia = p.subsecretaria
          when u.diretoria in ('SUBRAS','SUBVS','SUBASS','SUBGF','SUBR')
            then u.diretoria = p.subsecretaria
          else false
        end
      else false
    end
    from u
  ), false);
$$;

-- O usuário logado pode escrever (cadastrar/editar/excluir)?
create or replace function pode_escrever()
returns boolean
language sql stable security definer set search_path = public
as $$
  select coalesce((select nivel in ('ponto_focal','dcc') from usuario_logado()), false);
$$;

-- Escopo por id de processo, para as tabelas filhas
create or replace function processo_visivel_id(p_id bigint)
returns boolean
language sql stable security definer set search_path = public
as $$
  select exists (select 1 from processos p where p.id = p_id and processo_visivel(p));
$$;

grant execute on function usuario_logado(), processo_visivel(processos),
                          pode_escrever(), processo_visivel_id(bigint)
  to authenticated;

-- 3) Limpar policies antigas ---------------------------------
drop policy if exists abrir_processos    on processos;
drop policy if exists abrir_usuarios     on usuarios;
drop policy if exists abrir_itens        on processo_itens;
drop policy if exists abrir_acoes        on processo_acoes;
drop policy if exists abrir_etapas       on etapas;
drop policy if exists abrir_atualizacoes on atualizacoes;
drop policy if exists abrir_resumos      on resumos_semanais;
drop policy if exists abrir_prazos       on prazos_fase;
drop policy if exists abrir_modalidades  on modalidades;
drop policy if exists abrir_feriados     on feriados;
-- do 05 original
drop policy if exists proc_leitura        on processos;
drop policy if exists proc_escrita        on processos;
drop policy if exists filhas_itens        on processo_itens;
drop policy if exists filhas_acoes        on processo_acoes;
drop policy if exists filhas_etapas       on etapas;
drop policy if exists filhas_atual        on atualizacoes;
drop policy if exists filhas_resumos      on resumos_semanais;
drop policy if exists user_leitura        on usuarios;
drop policy if exists user_update_proprio on usuarios;
-- deste arquivo (idempotência)
drop policy if exists proc_sel on processos;
drop policy if exists proc_ins on processos;
drop policy if exists proc_upd on processos;
drop policy if exists proc_del on processos;
drop policy if exists itens_rw   on processo_itens;
drop policy if exists acoes_rw   on processo_acoes;
drop policy if exists etapas_rw  on etapas;
drop policy if exists atual_rw   on atualizacoes;
drop policy if exists resumos_rw on resumos_semanais;
drop policy if exists ref_prazos      on prazos_fase;
drop policy if exists ref_modalidades on modalidades;
drop policy if exists ref_feriados    on feriados;

-- 4) Concessões: tirar do anon, dar ao authenticated ----------
revoke all on processos, processo_itens, processo_acoes, etapas,
              atualizacoes, resumos_semanais, usuarios,
              prazos_fase, modalidades, feriados
  from anon;

grant select, insert, update, delete
  on processos, processo_itens, processo_acoes, etapas,
     atualizacoes, resumos_semanais
  to authenticated;

grant select, update on usuarios to authenticated;
grant select on prazos_fase, modalidades, feriados to authenticated;

-- 5) PROCESSOS ------------------------------------------------
-- leitura: só o que o escopo do usuário alcança
create policy proc_sel on processos for select to authenticated
  using (processo_visivel(processos));

-- escrita: separada por comando, para NÃO reabrir o SELECT.
-- Escopo: quem escreve também precisa enxergar o processo.
-- Se isto apertar demais (ex.: DCC cadastrando para outra área),
-- troque "processo_visivel(processos)" por "true" nas três abaixo.
create policy proc_ins on processos for insert to authenticated
  with check (pode_escrever() and processo_visivel(processos));

create policy proc_upd on processos for update to authenticated
  using       (pode_escrever() and processo_visivel(processos))
  with check  (pode_escrever() and processo_visivel(processos));

create policy proc_del on processos for delete to authenticated
  using (pode_escrever() and processo_visivel(processos));

-- 6) TABELAS FILHAS: herdam o escopo do processo pai ----------
create policy itens_rw on processo_itens for all to authenticated
  using (processo_visivel_id(processo_id)) with check (processo_visivel_id(processo_id));

create policy acoes_rw on processo_acoes for all to authenticated
  using (processo_visivel_id(processo_id)) with check (processo_visivel_id(processo_id));

create policy etapas_rw on etapas for all to authenticated
  using (processo_visivel_id(processo_id)) with check (processo_visivel_id(processo_id));

create policy atual_rw on atualizacoes for all to authenticated
  using (processo_visivel_id(processo_id)) with check (processo_visivel_id(processo_id));

create policy resumos_rw on resumos_semanais for all to authenticated
  using (processo_visivel_id(processo_id)) with check (processo_visivel_id(processo_id));

-- 7) USUÁRIOS -------------------------------------------------
create policy user_leitura on usuarios for select to authenticated
  using (
    auth_id = auth.uid()
    or lower(email) = lower(auth.jwt() ->> 'email')
    or coalesce((select nivel in ('gabinete','dcc') from usuario_logado()), false)
  );

create policy user_update_proprio on usuarios for update to authenticated
  using      (auth_id = auth.uid() or lower(email) = lower(auth.jwt() ->> 'email'))
  with check (auth_id = auth.uid() or lower(email) = lower(auth.jwt() ->> 'email'));

-- 8) TABELAS DE REFERÊNCIA: leitura para autenticados ---------
create policy ref_prazos      on prazos_fase  for select to authenticated using (true);
create policy ref_modalidades on modalidades  for select to authenticated using (true);
create policy ref_feriados    on feriados     for select to authenticated using (true);

commit;

-- ============================================================
-- CONFERÊNCIA — rode DEPOIS e verifique o resultado
-- ============================================================
-- Nenhuma policy deve aparecer com papel "public" ou com "true"
-- solto em processos/usuarios:
--
--   select tablename, policyname, cmd, roles, qual, with_check
--   from pg_policies where schemaname='public' order by tablename, policyname;
--
-- ============================================================
-- QUEM FICA DE FORA — rode ANTES de aplicar
-- ============================================================
-- select u.email, u.nome, coalesce(u.nivel,'(nulo)') nivel,
--        'sem conta no Auth - nao consegue logar' problema
-- from public.usuarios u
-- left join auth.users a on a.id = u.auth_id or lower(a.email) = lower(u.email)
-- where u.ativo and a.id is null
-- union all
-- select a.email, null::text, null::text, 'loga mas nao tem perfil em public.usuarios'
-- from auth.users a
-- left join public.usuarios u on u.auth_id = a.id or lower(u.email) = lower(a.email)
-- where u.id is null
-- union all
-- select u.email, u.nome, coalesce(u.nivel,'(nulo)'), 'nivel invalido - enxerga zero processos'
-- from public.usuarios u
-- where u.ativo and (u.nivel is null or u.nivel not in ('gabinete','dcc','subsecretario','ponto_focal'))
-- union all
-- select u.email, u.nome, u.nivel, 'ponto_focal sem diretoria e sem superintendencia'
-- from public.usuarios u
-- where u.ativo and u.nivel='ponto_focal'
--   and coalesce(u.diretoria,'')='' and coalesce(u.superintendencia,'')=''
-- union all
-- select u.email, u.nome, u.nivel, 'subsecretario sem subsecretaria'
-- from public.usuarios u
-- where u.ativo and u.nivel='subsecretario' and coalesce(u.subsecretaria,'')=''
-- order by 4, 1;
