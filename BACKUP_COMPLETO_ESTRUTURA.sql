-- ============================================================
-- BACKUP COMPLETO — GOVERNANÇA EM COMPRAS (SES-MG)
-- Todos os SQLs do projeto, na ordem oficial de execução.
-- Recria o banco do zero: tabelas, funções, políticas, dados base.
-- Gerado em: 2026-08-12
-- ============================================================


-- ####################################################################
-- ARQUIVO: 01_tabelas.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Estrutura de dados (Camada 1: Tabelas)
-- Sistema de Planejamento Anual de Contratações — SES-MG
-- ------------------------------------------------------------
-- Rode este script no SQL Editor do Supabase.
-- Ele cria as 7 tabelas principais e suas ligações.
-- O Auth e as permissões (RLS) virão numa camada separada.
-- ============================================================

-- ------------------------------------------------------------
-- 1) USUÁRIOS — quem acessa o sistema e o que cada um enxerga
-- ------------------------------------------------------------
create table if not exists usuarios (
  id           bigint generated always as identity primary key,
  email        text unique not null,
  nome         text,
  nivel        text not null check (nivel in ('gabinete','subsecretario','ponto_focal','dcc')),
  area         text,           -- área/superintendência do ponto focal
  subsecretaria text,          -- sub/assessoria a que pertence
  superintendencia text,
  ativo        boolean default true,
  criado_em    timestamptz default now()
);

-- ------------------------------------------------------------
-- 2) PROCESSOS — o coração do sistema
-- ------------------------------------------------------------
create table if not exists processos (
  id             bigint generated always as identity primary key,
  codigo         text unique,          -- PAC-2026-0001
  objeto         text not null,
  num_sei        text,
  modalidade     text,
  valor          numeric(16,2),
  area_demandante text,
  subsecretaria  text,
  superintendencia text,
  prazo_final    text,                 -- mês/ano desejado (texto, pois às vezes é "2º semestre")
  prioritario    boolean default false,
  etapa_atual    text,                 -- fase corrente (espelho da etapa ativa)
  status         text,                 -- em andamento, em atraso, concluído...
  natureza       text,                 -- recorrente / extraordinária
  ano            int default 2026,
  ativo          boolean default true,
  criado_em      timestamptz default now(),
  atualizado_em  timestamptz default now()
);

-- ------------------------------------------------------------
-- 3) ITENS DO PROCESSO — um processo pode ter vários itens
-- ------------------------------------------------------------
create table if not exists processo_itens (
  id             bigint generated always as identity primary key,
  processo_id    bigint not null references processos(id) on delete cascade,
  descricao      text not null,
  num_catmas     text,
  quantidade     numeric(14,2),
  valor_unitario numeric(16,2),
  criado_em      timestamptz default now()
);

-- ------------------------------------------------------------
-- 4) AÇÕES ORÇAMENTÁRIAS — pode haver mais de uma por processo
-- ------------------------------------------------------------
create table if not exists processo_acoes (
  id           bigint generated always as identity primary key,
  processo_id  bigint not null references processos(id) on delete cascade,
  codigo_acao  text not null,
  descricao    text,
  criado_em    timestamptz default now()
);

-- ------------------------------------------------------------
-- 5) ETAPAS / MARCOS — as fases de cada processo
--    Cada etapa é feita numa coordenação e tem versão (vai-e-volta)
-- ------------------------------------------------------------
create table if not exists etapas (
  id             bigint generated always as identity primary key,
  processo_id    bigint not null references processos(id) on delete cascade,
  fase           text not null,        -- 'ETP em elaboração', 'TR em análise', etc.
  coordenacao    text,                 -- CAP / COA / CL / CFCO / CAE (quem faz esta etapa)
  versao         int default 1,        -- incrementa a cada ida-e-volta
  data_pactuada  date,
  data_conclusao date,
  status         text default 'nao_iniciado', -- nao_iniciado, em_andamento, concluido, em_atraso
  ordem          int,                  -- ordem da fase no fluxo (1..N)
  criado_em      timestamptz default now()
);

-- ------------------------------------------------------------
-- 6) ATUALIZAÇÕES — cada registro feito numa etapa (histórico)
--    É daqui que sai a contagem de "idas e voltas do TR"
-- ------------------------------------------------------------
create table if not exists atualizacoes (
  id             bigint generated always as identity primary key,
  processo_id    bigint not null references processos(id) on delete cascade,
  etapa_id       bigint references etapas(id) on delete set null,
  tipo           text,                 -- avanco, impedimento, ajuste, retorno
  observacao     text,
  data_prevista  date,
  data_conclusao date,
  nova_tendencia date,
  versao         int,                  -- versão da etapa no momento do registro
  autor_email    text,
  sinalizar_para text,                 -- 'gabinete,dcc' (lista simples)
  criado_em      timestamptz default now()
);

-- ------------------------------------------------------------
-- 7) RESUMOS SEMANAIS — o "diário de bordo" de cada processo
-- ------------------------------------------------------------
create table if not exists resumos_semanais (
  id            bigint generated always as identity primary key,
  processo_id   bigint not null references processos(id) on delete cascade,
  semana_inicio date,
  semana_fim    date,
  texto         text not null,
  autor_email   text,
  criado_em     timestamptz default now()
);

-- ------------------------------------------------------------
-- ÍNDICES — para as consultas ficarem rápidas
-- ------------------------------------------------------------
create index if not exists idx_itens_processo    on processo_itens(processo_id);
create index if not exists idx_acoes_processo     on processo_acoes(processo_id);
create index if not exists idx_etapas_processo    on etapas(processo_id);
create index if not exists idx_etapas_coord       on etapas(coordenacao);
create index if not exists idx_atualiz_processo   on atualizacoes(processo_id);
create index if not exists idx_atualiz_etapa      on atualizacoes(etapa_id);
create index if not exists idx_resumos_processo   on resumos_semanais(processo_id);
create index if not exists idx_processos_ano      on processos(ano);
create index if not exists idx_processos_prio     on processos(prioritario);

-- ============================================================
-- Fim da Camada 1. Após rodar, confira em "Table Editor"
-- que as 7 tabelas apareceram.
-- ============================================================


-- ####################################################################
-- ARQUIVO: 02_permissoes.sql
-- ####################################################################

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


-- ####################################################################
-- ARQUIVO: 04_auth.sql
-- ####################################################################

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


-- ####################################################################
-- ARQUIVO: 06_diretoria_completo.sql
-- ####################################################################

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


-- ####################################################################
-- ARQUIVO: 07_prazos.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Tabelas de prazos (calculadora)
-- ------------------------------------------------------------
-- Rode no SQL Editor do Supabase (projeto novo).
-- Cria a estrutura para a futura calculadora de prazos:
-- cada modalidade tem um nº de dias previsto para cada fase.
-- Isso alimentará o cálculo do "projetado" na v2.
--
-- Por ora só a estrutura (vazia). Você preenche os dias por
-- fase/modalidade quando quiser (na mão, com calma).
-- ============================================================

-- ------------------------------------------------------------
-- 1) MODALIDADES — os tipos de contratação
-- ------------------------------------------------------------
create table if not exists modalidades (
  id        bigint generated always as identity primary key,
  sigla     text unique not null,      -- ex.: PE, PE-RP, DISP, INEX, ADESAO, COTEP
  nome      text not null,             -- ex.: Pregão eletrônico
  ativo     boolean default true,
  criado_em timestamptz default now()
);

-- ------------------------------------------------------------
-- 2) PRAZOS POR FASE — dias previstos de cada fase, por modalidade
--    (é aqui que você define "TR em elaboração leva X dias no PE")
-- ------------------------------------------------------------
create table if not exists prazos_fase (
  id            bigint generated always as identity primary key,
  modalidade_id bigint not null references modalidades(id) on delete cascade,
  fase          text not null,          -- mesma nomenclatura das etapas
                                          -- ('ETP em elaboração', 'TR em análise'...)
  dias_uteis    int not null default 0,  -- nº de dias úteis previstos para a fase
  ordem         int,                     -- ordem da fase no fluxo
  criado_em     timestamptz default now(),
  unique (modalidade_id, fase)
);

-- ------------------------------------------------------------
-- 3) FERIADOS — para o cálculo pular dias não úteis (v2)
-- ------------------------------------------------------------
create table if not exists feriados (
  id        bigint generated always as identity primary key,
  data      date unique not null,
  descricao text,
  criado_em timestamptz default now()
);

-- índices
create index if not exists idx_prazos_modalidade on prazos_fase(modalidade_id);

-- Permissões (mesmo padrão temporário aberto das demais tabelas)
grant select, insert, update, delete on modalidades, prazos_fase, feriados to anon;
grant usage, select on all sequences in schema public to anon;

alter table modalidades enable row level security;
alter table prazos_fase enable row level security;
alter table feriados    enable row level security;

drop policy if exists abrir_modalidades on modalidades;
create policy abrir_modalidades on modalidades for all using (true) with check (true);
drop policy if exists abrir_prazos on prazos_fase;
create policy abrir_prazos on prazos_fase for all using (true) with check (true);
drop policy if exists abrir_feriados on feriados;
create policy abrir_feriados on feriados for all using (true) with check (true);

-- ============================================================
-- Pronto. A "tomada" da calculadora está instalada.
-- Quando quiser, cadastramos as modalidades e os dias por fase,
-- e construímos o cálculo do projetado (v2).
-- ============================================================


-- ####################################################################
-- ARQUIVO: 08_modalidades_prazos.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Modalidades e prazos por fase
-- ------------------------------------------------------------
-- Rode APÓS o 07_prazos.sql. Popula as modalidades e os dias
-- de cada fase (prioritário e normal), na ordem correta.
-- Seguro rodar mais de uma vez (recria e reinsere).
--
-- OBS: recria as tabelas modalidades e prazos_fase para garantir
-- a estrutura correta (caso exista uma versão antiga no banco,
-- ex.: do sistema anterior).
-- ============================================================

-- recriar as tabelas com a estrutura certa (apaga versões antigas)
drop table if exists prazos_fase cascade;
drop table if exists modalidades cascade;

create table modalidades (
  id        bigint generated always as identity primary key,
  sigla     text unique not null,
  nome      text not null,
  ativo     boolean default true,
  criado_em timestamptz default now()
);

create table prazos_fase (
  id               bigint generated always as identity primary key,
  modalidade_id    bigint not null references modalidades(id) on delete cascade,
  fase             text not null,
  dias_prioritario int,
  dias_normal      int,
  ordem            int,
  criado_em        timestamptz default now(),
  unique (modalidade_id, fase)
);

create index if not exists idx_prazos_modalidade on prazos_fase(modalidade_id);

-- permissões (padrão temporário aberto, igual às demais)
grant select, insert, update, delete on modalidades, prazos_fase to anon;
grant usage, select on all sequences in schema public to anon;
alter table modalidades enable row level security;
alter table prazos_fase enable row level security;
drop policy if exists abrir_modalidades on modalidades;
create policy abrir_modalidades on modalidades for all using (true) with check (true);
drop policy if exists abrir_prazos on prazos_fase;
create policy abrir_prazos on prazos_fase for all using (true) with check (true);

-- inserir modalidades
insert into modalidades (sigla, nome, ativo) values
  ('DISP','Dispensa',true),
  ('INEX','Inexigibilidade',true),
  ('PE','Pregão Eletrônico',true),
  ('PE-RP','Pregão Eletrônico para Registro de Preços',true),
  ('COTEP','COTEP',true),
  ('CONC','Concorrência',true),
  ('ADESAO','Adesão',true);

-- inserir as fases/prazos de cada modalidade
-- Dispensa (DISP)
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em elaboração', 15, 15, 1 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em análise', 10, 15, 2 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em elaboração', 15, 20, 3 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em análise', 15, 20, 4 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Pesquisa de preços', 10, 10, 5 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Conferência processual', 28, 28, 6 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Saneamento de ressalvas jurídicas', 15, 15, 7 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Homologação', 11, 15, 8 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Parado/Sem previsão', null, null, 9 from modalidades where sigla='DISP';

-- Inexigibilidade (INEX)
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em elaboração', 15, 15, 1 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em análise', 10, 15, 2 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em elaboração', 15, 20, 3 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em análise', 15, 20, 4 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Pesquisa de preços', 10, 10, 5 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Conferência processual', 28, 28, 6 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Saneamento de ressalvas jurídicas', 15, 15, 7 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Homologação', 11, 15, 8 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Parado/Sem previsão', null, null, 9 from modalidades where sigla='INEX';

-- Pregão (PE)
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em elaboração', 15, 15, 1 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em análise', 10, 15, 2 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em elaboração', 15, 20, 3 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em análise', 15, 20, 4 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Pesquisa de preços', 25, 25, 5 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Conferência processual', 33, 33, 6 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Saneamento de ressalvas jurídicas', 15, 15, 7 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Edital', 9, 9, 8 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Sessão pública', 64, 64, 9 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Homologação', 9, 9, 10 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Parado/Sem previsão', null, null, 11 from modalidades where sigla='PE';

-- Pregão Eletrônico para Registro de Preços (PE-RP)
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em elaboração', 15, 15, 1 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em análise', 10, 15, 2 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em elaboração', 15, 20, 3 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Gestão SEPLAG', 23, 23, 4 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em análise', 15, 20, 5 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Pesquisa de preços', 25, 25, 6 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Conferência processual', 33, 33, 7 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Saneamento de ressalvas jurídicas', 15, 15, 8 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Edital', 9, 9, 9 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Sessão pública', 64, 64, 10 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Homologação', 9, 9, 11 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Parado/Sem previsão', null, null, 12 from modalidades where sigla='PE-RP';

-- COTEP (COTEP)
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em elaboração', 15, 15, 1 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em análise', 10, 15, 2 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em elaboração', 15, 20, 3 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em análise', 15, 20, 4 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Pesquisa de preços', 36, 36, 5 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Conferência processual', 28, 28, 6 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Saneamento de ressalvas jurídicas', 18, 18, 7 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Cotação Eletrônica de Preços', 7, 7, 8 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Sessão pública', 41, 41, 9 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Homologação', 5, 10, 10 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Parado/Sem previsão', null, null, 11 from modalidades where sigla='COTEP';

-- Concorrência (CONC)
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em elaboração', 15, 15, 1 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'ETP em análise', 10, 15, 2 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em elaboração', 15, 20, 3 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'TR em análise', 15, 20, 4 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Pesquisa de preços', 25, 25, 5 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Conferência processual', 33, 33, 6 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Saneamento de ressalvas jurídicas', 15, 15, 7 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Edital', 9, 9, 8 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Cadastro de propostas', 30, 30, 9 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Sessão pública', 64, 64, 10 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Homologação', 9, 9, 11 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_prioritario, dias_normal, ordem) select id, 'Parado/Sem previsão', null, null, 12 from modalidades where sigla='CONC';

-- ============================================================
-- Pronto. Modalidades e prazos cadastrados.
-- ============================================================

-- ####################################################################
-- ARQUIVO: 09_usuarios_vinculo.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Vínculo dos usuários (nível + área)
-- ------------------------------------------------------------
-- Rode DEPOIS de criar os acessos no Authentication.
-- Insere/atualiza cada usuário na tabela 'usuarios' com seu
-- nível e área (subsecretaria/superintendência/diretoria).
-- Marca todos para trocar a senha no primeiro acesso.
-- ============================================================

insert into public.usuarios (email, nome, nivel, subsecretaria, superintendencia, diretoria, precisa_trocar_senha, ativo) values
  ('joao.gontijo@saude.mg.gov.br','João Vítor Gontijo','dcc','AEST',null,null,true,true),
  ('carolina.ribeiro@saude.mg.gov.br','Carolina Ribeiro','ponto_focal','AEST',null,null,true,true),
  ('maria.gusmao@saude.mg.gov.br','Maria Isabela Gusmão','ponto_focal','ASCOM',null,null,true,true),
  ('fernanda.xavier@saude.mg.gov.br','Fernanda Maria Xavier','ponto_focal','ASCOM',null,null,true,true),
  ('elisa.paschoal@saude.mg.gov.br','Elisa Paschoal','ponto_focal','ASPAR',null,null,true,true),
  ('eliana.mascarenhas@saude.mg.gov.br','Eliana Mascarenhas','ponto_focal','ASPAR',null,null,true,true),
  ('vander.oliveira@saude.mg.gov.br','Vander Oliveira','ponto_focal','ATI',null,null,true,true),
  ('evandro.lana@saude.mg.gov.br','Evandro Thiago Lana','ponto_focal','ATI',null,null,true,true),
  ('fausniel.brandao@saude.mg.gov.br','Fausniel Brandão','ponto_focal','ATI',null,null,true,true),
  ('luis.santos@saude.mg.gov.br','Luis Guilherme Santos','ponto_focal','SUBASS',null,null,true,true),
  ('ana.trindade@saude.mg.gov.br','Ana Paula Trindade','ponto_focal','SUBASS',null,null,true,true),
  ('subass@saude.mg.gov.br','SUBASS','subsecretario','SUBASS',null,null,true,true),
  ('claudiane.silva@saude.mg.gov.br','Claudiane Silva','ponto_focal','SUBASS','SAF',null,true,true),
  ('edvania.oliveira@saude.mg.gov.br','Edvania Ramos de Oliveira','ponto_focal','SUBASS','SAF',null,true,true),
  ('amanda.neves@saude.mg.gov.br','Amanda Carolliny Neves','ponto_focal','SUBASS','SRA',null,true,true),
  ('stiferson.alencar@saude.mg.gov.br','Stiferson Almino Alencar','ponto_focal','SUBASS','SRA',null,true,true),
  ('daianna.rodrigues@saude.mg.gov.br','Daianna Rodrigues','ponto_focal','SUBASS','SJUD',null,true,true),
  ('aline.lara@saude.mg.gov.br','Aline Lara','ponto_focal','SUBASS','SJUD',null,true,true),
  ('suelen.novy@saude.mg.gov.br','Suelen Novy Santos','ponto_focal','SUBGF',null,null,true,true),
  ('lorena.stefany.santos@saude.mg.gov.br','Lorena Stefany','ponto_focal','SUBGF',null,null,true,true),
  ('subgf@saude.mg.gov.br','SUBGF','subsecretario','SUBGF',null,null,true,true),
  ('matheus.melo@saude.mg.gov.br','Matheus Gomes de Melo','ponto_focal','SUBGF','SPF',null,true,true),
  ('jacqueline.bueno@saude.mg.gov.br','Jacqueline Martins Bueno','ponto_focal','SUBGF','SPF',null,true,true),
  ('yuri.moura@saude.mg.gov.br','Yuri de Aguiar Moura','ponto_focal','SUBGF','SGDP',null,true,true),
  ('eduardo.resende@saude.mg.gov.br','Eduardo Alberto Silva Resende','ponto_focal','SUBGF','SGDP',null,true,true),
  ('natalia.cardoso@saude.mg.gov.br','Natália Cristina Cardoso','ponto_focal','SUBGF','SILC',null,true,true),
  ('waldineia.paz@saude.mg.gov.br','Waldineia Dias Paz','ponto_focal','SUBGF','SILC',null,true,true),
  ('subras@saude.mg.gov.br','SUBRAS','subsecretario','SUBRAS',null,null,true,true),
  ('augusto.ananias@saude.mg.gov.br','Augusto Ananias','ponto_focal','SUBRAS','SAPS',null,true,true),
  ('lilian.kirita@saude.mg.gov.br','Lilian Kirita','ponto_focal','SUBRAS','SAPS',null,true,true),
  ('fernanda.santos@saude.mg.gov.br','Fernanda Santos Pereira','ponto_focal','SUBRAS','SAE',null,true,true),
  ('bruno.furtado@saude.mg.gov.br','Bruno Crispim Furtado','ponto_focal','SUBRAS','SAE',null,true,true),
  ('audileia.santos@saude.mg.gov.br','Audiléia Alves da Paixão Santos','ponto_focal','SUBRAS','SPAH',null,true,true),
  ('elisa.fonseca@saude.mg.gov.br','Ana Elisa Machado da Fonseca','ponto_focal','SUBRAS','SPAH',null,true,true),
  ('ronan.ribeiro@saude.mg.gov.br','Ronan Ribeiro','ponto_focal','SUBVS',null,null,true,true),
  ('rita.barros@saude.mg.gov.br','Rita Narciso de Barros','ponto_focal','SUBVS',null,null,true,true),
  ('subvs@saude.mg.gov.br','SUBVS','subsecretario','SUBVS',null,null,true,true),
  ('dc@saude.mg.gov.br','DCC','dcc','SUBGF','SILC','DCC',true,true),
  ('dlog@saude.mg.gov.br','DLOG','ponto_focal','SUBGF','SILC','DLOG',true,true),
  ('dpat@saude.mg.gov.br','DPAT','ponto_focal','SUBGF','SILC','DPAT',true,true),
  ('gabinete@saude.mg.gov.br','GAB','gabinete','GAB',null,null,true,true),
  ('paulo.falcao@saude.mg.gov.br','Paulo Falcão','dcc','AEST',null,null,true,true)
on conflict (email) do update set
  nome=excluded.nome, nivel=excluded.nivel,
  subsecretaria=excluded.subsecretaria,
  superintendencia=excluded.superintendencia,
  diretoria=excluded.diretoria,
  ativo=true;

-- ============================================================
-- Pronto. 42 usuários vinculados.
-- ============================================================


-- ####################################################################
-- ARQUIVO: 10_criar_acessos.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Criar acessos em lote (Auth) — v2
-- ------------------------------------------------------------
-- Versão corrigida: usa "where not exists" em vez de
-- "on conflict" (a tabela auth.users não aceita on conflict email).
-- Rode no SQL Editor. Cria os acessos com senha 'Mudar@2026'.
-- Seguro rodar de novo: só insere quem ainda não existe.
-- ============================================================

create extension if not exists pgcrypto;

-- 1) criar os usuários que ainda não existem
insert into auth.users
  (instance_id, id, aud, role, email, encrypted_password,
   email_confirmed_at, created_at, updated_at,
   raw_app_meta_data, raw_user_meta_data,
   confirmation_token, recovery_token, email_change_token_new, email_change)
select
  '00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated',
  e.email, crypt('Mudar@2026', gen_salt('bf')), now(), now(), now(),
  '{"provider":"email","providers":["email"]}', '{}', '', '', '', ''
from (values
    ('joao.gontijo@saude.mg.gov.br'),
    ('carolina.ribeiro@saude.mg.gov.br'),
    ('maria.gusmao@saude.mg.gov.br'),
    ('fernanda.xavier@saude.mg.gov.br'),
    ('elisa.paschoal@saude.mg.gov.br'),
    ('eliana.mascarenhas@saude.mg.gov.br'),
    ('vander.oliveira@saude.mg.gov.br'),
    ('evandro.lana@saude.mg.gov.br'),
    ('fausniel.brandao@saude.mg.gov.br'),
    ('luis.santos@saude.mg.gov.br'),
    ('ana.trindade@saude.mg.gov.br'),
    ('subass@saude.mg.gov.br'),
    ('claudiane.silva@saude.mg.gov.br'),
    ('edvania.oliveira@saude.mg.gov.br'),
    ('amanda.neves@saude.mg.gov.br'),
    ('stiferson.alencar@saude.mg.gov.br'),
    ('daianna.rodrigues@saude.mg.gov.br'),
    ('aline.lara@saude.mg.gov.br'),
    ('suelen.novy@saude.mg.gov.br'),
    ('lorena.stefany.santos@saude.mg.gov.br'),
    ('subgf@saude.mg.gov.br'),
    ('matheus.melo@saude.mg.gov.br'),
    ('jacqueline.bueno@saude.mg.gov.br'),
    ('yuri.moura@saude.mg.gov.br'),
    ('eduardo.resende@saude.mg.gov.br'),
    ('natalia.cardoso@saude.mg.gov.br'),
    ('waldineia.paz@saude.mg.gov.br'),
    ('subras@saude.mg.gov.br'),
    ('augusto.ananias@saude.mg.gov.br'),
    ('lilian.kirita@saude.mg.gov.br'),
    ('fernanda.santos@saude.mg.gov.br'),
    ('bruno.furtado@saude.mg.gov.br'),
    ('audileia.santos@saude.mg.gov.br'),
    ('elisa.fonseca@saude.mg.gov.br'),
    ('ronan.ribeiro@saude.mg.gov.br'),
    ('rita.barros@saude.mg.gov.br'),
    ('subvs@saude.mg.gov.br'),
    ('dc@saude.mg.gov.br'),
    ('dlog@saude.mg.gov.br'),
    ('dpat@saude.mg.gov.br'),
    ('gabinete@saude.mg.gov.br'),
    ('paulo.falcao@saude.mg.gov.br')
) as e(email)
where not exists (
  select 1 from auth.users u where u.email = e.email
);

-- 2) criar as identidades (necessário para login por e-mail)
insert into auth.identities
  (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
select
  gen_random_uuid(), u.id, u.id::text,
  json_build_object('sub', u.id::text, 'email', u.email),
  'email', now(), now(), now()
from auth.users u
where u.email in (
    'joao.gontijo@saude.mg.gov.br',
    'carolina.ribeiro@saude.mg.gov.br',
    'maria.gusmao@saude.mg.gov.br',
    'fernanda.xavier@saude.mg.gov.br',
    'elisa.paschoal@saude.mg.gov.br',
    'eliana.mascarenhas@saude.mg.gov.br',
    'vander.oliveira@saude.mg.gov.br',
    'evandro.lana@saude.mg.gov.br',
    'fausniel.brandao@saude.mg.gov.br',
    'luis.santos@saude.mg.gov.br',
    'ana.trindade@saude.mg.gov.br',
    'subass@saude.mg.gov.br',
    'claudiane.silva@saude.mg.gov.br',
    'edvania.oliveira@saude.mg.gov.br',
    'amanda.neves@saude.mg.gov.br',
    'stiferson.alencar@saude.mg.gov.br',
    'daianna.rodrigues@saude.mg.gov.br',
    'aline.lara@saude.mg.gov.br',
    'suelen.novy@saude.mg.gov.br',
    'lorena.stefany.santos@saude.mg.gov.br',
    'subgf@saude.mg.gov.br',
    'matheus.melo@saude.mg.gov.br',
    'jacqueline.bueno@saude.mg.gov.br',
    'yuri.moura@saude.mg.gov.br',
    'eduardo.resende@saude.mg.gov.br',
    'natalia.cardoso@saude.mg.gov.br',
    'waldineia.paz@saude.mg.gov.br',
    'subras@saude.mg.gov.br',
    'augusto.ananias@saude.mg.gov.br',
    'lilian.kirita@saude.mg.gov.br',
    'fernanda.santos@saude.mg.gov.br',
    'bruno.furtado@saude.mg.gov.br',
    'audileia.santos@saude.mg.gov.br',
    'elisa.fonseca@saude.mg.gov.br',
    'ronan.ribeiro@saude.mg.gov.br',
    'rita.barros@saude.mg.gov.br',
    'subvs@saude.mg.gov.br',
    'dc@saude.mg.gov.br',
    'dlog@saude.mg.gov.br',
    'dpat@saude.mg.gov.br',
    'gabinete@saude.mg.gov.br',
    'paulo.falcao@saude.mg.gov.br'
)
and not exists (
  select 1 from auth.identities i where i.user_id = u.id and i.provider='email'
);

-- ============================================================
-- Pronto. Depois rode o 09_usuarios_vinculo.sql.
-- ============================================================


-- ####################################################################
-- ARQUIVO: 11_campo_contrato.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Campo "tem contrato?"
-- ------------------------------------------------------------
-- Rode no SQL Editor (PROJETO CERTO: tatinrolrssjervuykej).
-- Adiciona o campo que indica se o processo tem contrato.
-- ============================================================

alter table processos add column if not exists tem_contrato boolean default false;

-- ============================================================
-- Pronto. Campo 'tem_contrato' adicionado (padrão: false/não).
-- ============================================================


-- ####################################################################
-- ARQUIVO: 12_inserir_processos.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Inserir os 178 processos reais (v2)
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO (tatinrolrssjervuykej).
-- Cada processo entra com suas etapas; a etapa ATUAL fica
-- 'em_andamento', as anteriores 'concluida', as futuras 'nao_iniciada'.
-- Processos com prazo vencido => status 'em_atraso'.
-- Idempotente: remove processo de mesmo num_sei antes de inserir.
-- ============================================================

do $$
declare v_pid bigint;
begin

  -- LIMPEZA INICIAL: começar do zero (remove processos de teste e
  -- qualquer tentativa anterior). As tabelas filhas (etapas, itens,
  -- ações, atualizações, resumos) são apagadas junto.
  delete from atualizacoes;
  delete from resumos_semanais;
  delete from etapas;
  delete from processo_itens;
  delete from processo_acoes;
  delete from processos;

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0001', '1320.01.0001763/2024-15', 'Equipamentos Médico Assistenciais para os setores essenciais do Hospital Regional de Teófilo Otoni - HRTO e do Hospital Regional de Governador Valadares - HRGV', 'Pregão Eletrônico para Registro de Preços', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'f-jur', 'em_atraso', false, false, '2025-12-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0002', '1320.01.0071200/2024-32', 'Aquisição de medicamento do Componente Especializado da Assistência Farmacêutica (PENICILAMINA )', 'Dispensa', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'Conferência processual', 'em_atraso', false, true, '2025-01-08', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0003', '1320.01.0144621/2021-63', 'Aquisição de medicamentos e congêneres importados', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-pp', 'em_atraso', false, false, '2026-03-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0004', '1320.01.0053784/2023-11', 'Serviços de Impressão Gráfica', 'Pregão Eletrônico', 'SUBRAS', 'SAPS', 'DPSPE', 'DPSPE', 'Conferência processual', 'em_atraso', false, true, '2025-08-18', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0005', '1320.01.0182632/2023-20', 'Porta corta fogo para o Serviço de Verificação de Óbitos', 'COTEP', 'SUBVS', 'SVE', null, 'SVE', 'f-hom', 'em_atraso', false, false, '2024-12-27', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0006', '1320.01.0090942/2024-13', 'Aquisição camisetas promocionais, crachás e cordões para idenstificação dos conselheiros', 'COTEP', 'ASPAR', null, null, null, 'Cadastro de propostas', 'em_atraso', false, false, '2025-02-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0007', '1320.01.0069474/2024-74', 'Compra de cortina de ar e projetor refletores que serão instalados na antecâmara', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'Conferência processual', 'em_atraso', false, true, '2025-02-04', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0008', '1320.01.0026199/2024-37', 'Aquisição de materiais de consumo para adaptações da estrutura que compõe o Almoxarifado Central da SES/MG', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'Conferência processual', 'em_atraso', false, false, '2025-04-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0009', '1320.01.0106616/2024-26', 'Manutenção, reparos, adaptação e conservação em equipamentos para indústria gráfica', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-pp', 'em_atraso', false, false, '2025-05-19', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0010', '1320.01.0089459/2024-90', 'Aquisição de inseticida', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVDTI', 'DVDTI', 'f-pp', 'em_atraso', false, false, '2025-10-08', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0011', '1320.01.0110553/2023-42', 'Aquisição de "Termômetros e Testes para Identificação de Vírus Respiratório - SVE/SubVS"', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', null, 'SVE', 'Edital', 'em_atraso', false, false, '2025-07-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0012', '1320.01.0102933/2022-48', 'Serviços gráficos', 'Pregão Eletrônico', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-02-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0013', '1320.01.0023461/2024-49', 'Aquisição de "Preservativos masculinos e gel lubrificante íntimo"', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVCC', 'DVCC', 'Edital', 'em_atraso', false, false, '2024-11-08', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0014', '1320.01.0052284/2024-59', 'Aquisição de Bombas de Insulina e Insumos Diabetes', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-pp', 'em_atraso', false, false, '2025-12-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0015', '1320.01.0142536/2023-92', 'Aquisição de Equipamentos Médico Assistenciais de Diagnóstico por Imagem do Hospital Regional de Teófilo Otoni (1)', 'Pregão Eletrônico', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2025-08-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0016', '1320.01.0037333/2024-22', 'Locação de estação diagnóstica de trabalho', 'Pregão Eletrônico', 'SUBVS', 'SVS', 'DVSS', 'DVSS', 'f-tr-a', 'em_atraso', false, true, '2026-07-17', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0017', '1320.01.0026996/2024-52', 'Aquisição de embalagens', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-hom', 'em_atraso', false, false, '2026-04-15', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0018', '1320.01.0170446/2024-15', 'Aquisição de equipamentos médico assistenciais de diagnóstico por imagem do Hospital Regional de Teófilo Otoni', 'Pregão Eletrônico para Registro de Preços', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'f-jur', 'em_atraso', false, false, '2025-05-06', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0019', '1320.01.0121317/2024-23', 'Serviço (com fornecimento de material) de aplicação de película (insulfilm) nas janelas de vidro e remoção de películas em duas pequenas salas no mezanino do Almoxarifado Central', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-pp', 'em_atraso', false, false, '2025-04-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0020', '1320.01.0138911/2024-91', 'Contratação de serviços e a locação de software relacionado à estruturação de ambiente de interconectividade e à integração de dados da saúde e demais órgãos do Sistema Único de Saúde – SUS,', 'Pregão Eletrônico', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-03-27', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0021', '1320.01.0159118/2023-33', 'Contratação da prestação de serviços de confecção de persianas de tela solar sob medida e o serviço de instalação de persianas', 'Pregão Eletrônico', 'SUBR', null, null, null, 'f-tr-a', 'em_atraso', false, true, '2025-09-02', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0022', '1320.01.0163695/2023-32', 'Contratação de empresa para prestação de serviços de organização e execução de eventos institucionais e corporativos', 'Pregão Eletrônico', 'ASCOM', null, null, null, 'f-parado', 'em_atraso', false, false, '2025-11-06', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0023', '1320.01.0025237/2025-12', 'Serviços de impressão gráfica sem dedicação exclusiva de mão de obra.', 'COTEP', 'AEST', null, null, null, 'f-hom', 'em_atraso', false, false, '2025-03-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0024', '1320.01.0151672/2024-88', 'Compra estadual de fantasias do Zé Gotinha', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', null, 'SVE', 'Sessão pública', 'em_atraso', false, true, '2025-08-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0025', '1320.01.0028164/2025-38', 'Compra de termômetros', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', null, 'SVE', 'f-tr-a', 'em_atraso', false, false, '2025-04-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0026', '1320.01.0006080/2024-50', 'Contratação de serviços de engenharia complementar no âmbito da Secretaria de Estado de Saúde de Minas Gerais', 'Concorrência', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-tr-a', 'em_atraso', false, true, '2025-07-21', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cadastro de propostas', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0027', '1320.01.0188724/2023-48', 'Concessao de uso de bem publico imovel para o Hospital Regional de Conselheiro Lafaiete', 'Concorrência', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2026-06-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cadastro de propostas', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0028', '1300.01.0003601/2024-80', 'Fornecimento e distribuição de energia', 'Inexigibilidade', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'Conferência processual', 'em_atraso', false, true, '2025-04-25', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0029', '1320.01.0138105/2024-28', 'Aquisição de kit de materiais - serviço de impressão', 'Pregão Eletrônico', 'SUBVS', null, null, null, 'f-jur', 'em_atraso', false, false, '2026-02-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0030', '1320.01.0074610/2024-15', 'Curso de Aperfeiçoamento e Qualificação em Saúde Bucal', 'Dispensa', 'SUBRAS', 'SAPS', 'DPAPS', 'DPAPS', 'f-tr-a', 'em_atraso', false, false, '2025-03-07', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0031', '1300.01.0001031/2024-18', 'Fornecimento e distribuição de energia', 'Inexigibilidade', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'Conferência processual', 'em_atraso', false, true, '2025-05-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0032', '1320.01.0153007/2024-30', 'SERVICO ESPECIALIZADO TELEATENDIMENTO E TELEDIAGNOSTICO PRE-HOSPITALAR NA LINHA DE CUIDADOS DA SINDROME CORONARIA AGUDA', 'Dispensa', 'SUBRAS', 'SPAH', null, 'SPAH', 'Conferência processual', 'em_atraso', false, true, '2026-07-06', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0033', '1320.01.0100393/2024-43', 'Contratação de materiais permanentes que serão utilizados para compor o mobiliário do Almoxarifado Central', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-pp', 'em_atraso', false, false, '2025-04-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0034', '1320.01.0004597/2025-27', 'SERVIÇOS DE CONSULTORIA NA ÁREA DE SAÚDE', 'Inexigibilidade', 'SUBVS', 'SVS', null, 'SVS', 'Conferência processual', 'em_atraso', false, true, '2025-10-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0035', '1320.01.0049427/2024-83', 'Serviço UTI Terrestre', 'Pregão Eletrônico', 'SUBASS', 'SRA', 'DRAUE', 'DRAUE', 'f-pp', 'em_atraso', false, false, '2026-06-25', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0036', '1320.01.0019081/2025-63', 'Contratação da Empresa Brasileira de Correios e Telégrafos para a prestação de serviços postais em regime de monopólio', 'Inexigibilidade', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'Conferência processual', 'em_atraso', false, true, '2025-09-17', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0037', '1320.01.0003733/2025-75', 'Serviços especializados em revisão de contas hospitalares', 'Pregão Eletrônico', 'SUBASS', 'SRA', 'DRAUE', 'DRAUE', 'Conferência processual', 'em_atraso', false, true, '2026-06-09', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0038', '1320.01.0038457/2025-32', 'Aquisição de kit materiais cievs - materiais', 'Pregão Eletrônico', 'SUBVS', null, null, null, 'f-pp', 'em_andamento', false, false, '2026-08-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0039', '1320.01.0052151/2025-58', 'MEDICAMENTOS - ATENDIMENTO JUDICIAL I', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-etp-a', 'em_atraso', false, false, '2025-05-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0040', '1320.01.0159791/2024-95', 'Crachás de identificação e seus acessórios, cordas e porta cartões', 'COTEP', 'SUBGF', 'SGDP', 'DRH', 'DRH', 'f-tr-a', 'em_atraso', false, false, '2025-05-09', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0041', '1320.01.0139196/2024-59', 'Locação de imóvel - SRS Div', 'Inexigibilidade', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-07-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0042', '1320.01.0199384/2024-24', 'Digitalização dos documentos funcionais da Secretaria de Estado de Saúde', 'Pregão Eletrônico', 'SUBGF', 'SGDP', 'DRH', 'DRH', 'f-etp-a', 'em_atraso', false, false, '2025-05-21', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0043', '5140.01.0001859/2025-23', 'Disponibilização de hospedagem e processamento do Sistema SES RESOLVE, de propriedade da SES, em ambiente dedicado, incluindo o serviço de instalação em baixa plataforma no Data Center da PRODEMGE.', 'Dispensa', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-09-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0044', '1320.01.0075146/2023-96', 'Coletes para função específica', 'Pregão Eletrônico', 'SUBVS', null, null, null, 'f-tr-a', 'em_atraso', false, false, '2025-05-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0045', '1320.01.0057950/2025-43', 'COMPRA ESTADUAL DE MEDICAMENTOS DO ELENCO COMPLEMENTAR', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-etp-a', 'em_atraso', true, false, '2025-05-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0046', '1320.01.0147430/2024-65', 'Locação de imóvel - SRS Ponte Nova', 'Inexigibilidade', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-07-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0047', '1320.01.0053537/2025-78', 'Contratação dos serviços de psicoterapia e psiquiatria de forma virtual para atendimento aos agentes públicos da SES/MG.', 'Inexigibilidade', 'SUBGF', 'SGDP', 'DPDH', 'DPDH', 'f-hom', 'em_atraso', false, false, '2025-09-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0048', '1320.01.0145954/2024-50', 'Locação do imóvel para abrigar a Farmácia de Minas, Farmácia Judicial e Rede de Frio', 'Inexigibilidade', 'SUBR', null, null, null, 'f-hom', 'em_atraso', false, true, '2025-07-02', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0049', '1320.01.0072755/2025-45', 'Serviços contínuos de guarda e gerenciamento de documentos de arquivo', 'Dispensa', 'SUBGF', 'SILC', 'DPAT', 'DPAT', 'Conferência processual', 'em_atraso', false, true, '2025-08-12', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0050', '5140.01.0006476/2024-12', 'Hospedagem e processamento do Sistema SIGAF', 'Dispensa', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-02-19', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0051', '1320.01.0047800/2025-68', 'Serviços de Operação Logística Integrada para Gestão de Estoque, Distribuição e Gestão de Transporte', 'Dispensa', 'SUBGF', 'SILC', null, 'SILC', 'f-pp', 'em_atraso', false, false, '2026-06-17', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0052', '1320.01.0148880/2024-06', 'Contratação da prestação de serviços de calibração de equipamentos e instrumentos de precisão', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'Conferência processual', 'em_atraso', false, true, '2025-09-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0053', '1320.01.0084020/2025-82', 'Aquisição do medicamentos CLICLOSPORINA CÁPSULA', 'Dispensa', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-parado', 'em_atraso', false, false, '2025-08-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0054', '1320.01.0072445/2025-73', 'Prestação de serviços de manutenção preventiva e corretiva em grupos geradores, incluindo a reposição/substituição de peças e componentes originais', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-jur', 'em_atraso', false, false, '2026-07-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0055', '1320.01.0093135/2025-66', 'Compra Estadual insumos de saúde do Componente Básico da Assistência Farmacêutica (CBAF) e arboviroses', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-tr-a', 'em_atraso', false, false, '2025-07-01', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0056', '1320.01.0042337/2025-32', 'Aquisição de ferramentas manuais e elétricas e equipamentos', 'Pregão Eletrônico para Registro de Preços', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-tr-a', 'em_atraso', false, false, '2026-07-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0057', '1320.01.0075617/2025-80', 'Serviço de manutenção de equipamentos de gráfica', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-etp-a', 'em_atraso', false, false, '2025-09-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0058', '1300.01.0003099/2025-51', 'Fornecimento e distribuição de energia elétrica em média tensão Hospital Regional de Conselheiro Lafaiete', 'Inexigibilidade', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'Conferência processual', 'em_atraso', false, true, '2025-10-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0059', '1320.01.0093583/2025-95', 'Serviços de aprimoramento e capacitação de servidora da Secretaria de Estado de Saúde de Minas Gerais mediante o pagamento de 01 (uma) bolsa de estudos, no percentual de 80%, na pós-graduação lato sensu em Inovação, Estratégia e Gestão Pública Avançada', 'Inexigibilidade', 'SUBGF', 'SGDP', 'DPDH', 'DPDH', 'Conferência processual', 'em_atraso', false, true, '2026-07-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0060', '1320.01.0035886/2025-94', 'Compra estadual de insumos necessários a continuidade do serviço de acupuntura na atenção primária a saúde', 'Pregão Eletrônico para Registro de Preços', 'SUBRAS', 'SAPS', 'DPSPE', 'DPSPE', 'f-tr-a', 'em_atraso', false, false, '2026-07-06', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0061', '1320.01.0099731/2025-66', 'Aquisição de boton/pin do personagem Zé Gotinha e camisetas promocionais  sob a forma de entrega integral visando atender o 1º Seminário de Vigilância Epidemiológica de Minas Gerais', 'COTEP', 'SUBVS', 'SVE', null, 'SVE', 'f-hom', 'em_atraso', false, false, '2025-08-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0062', '1320.01.0122898/2024-16', 'Aquisição de tiras reagentes com doação de analisador portátil para medição de hemoglobina e hematócrito', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', null, null, null, 'f-jur', 'em_atraso', false, false, '2025-08-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0063', '1320.01.0106811/2025-93', 'Aquisição DE VEÍCULOS ADAPTADOS PARA COMPOR FROTA DE VEÍCULOS DAS SECRETÁRIAS MUNICIPAIS DE SAÚDE, A FIM DE ATENDER DE FORMA COMPARTILHADA AS NECESSIDADES DOS MUNICÍPIOS CONSORCIADOS AO CISARP', 'Adesão', 'ASPAR', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-11-24', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0064', '1300.01.0003369/2024-39', 'Fornecimento e distribuição de energia', 'Inexigibilidade', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'Conferência processual', 'em_atraso', false, true, '2025-02-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0065', '1320.01.0103745/2025-37', 'I Congresso Nacional da Atenção Especializada', 'Inexigibilidade', 'SUBRAS', 'SAPS', 'DPSPE', 'DPSPE', 'f-pp', 'em_atraso', false, false, '2025-07-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0066', '1320.01.0110255/2025-31', 'COMPRA ESTADUAL – MEDICAMENTOS I (CBAF)', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-tr-a', 'em_atraso', false, false, '2025-08-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0067', '1320.01.0115877/2025-42', 'COMPRA ESTADUAL – MEDICAMENTOS IV (CBAF)', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-tr-a', 'em_atraso', false, false, '2025-08-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0068', '1320.01.0104568/2025-29', 'serviços de aprimoramento e capacitação de servidores(as) da Secretaria de Estado de Saúde de Minas Gerais mediante o pagamento de 78 (setenta e oito) inscrições no 14º Congresso Brasileiro de Saúde Coletiva (Abrascão', 'Inexigibilidade', 'SUBGF', 'SGDP', 'DPDH', 'DPDH', 'f-hom', 'em_atraso', false, false, '2025-10-29', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0069', '1320.01.0116517/2024-31', 'Serviços de Operação Logística Integrada para Gestão de Estoque, Distribuição e Gestão de Transporte', 'Dispensa', 'SUBGF', 'SILC', null, 'SILC', 'f-jur', 'em_atraso', false, false, '2025-10-08', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0070', '1320.01.0057195/2024-61', 'Serviços de locação de equipamentos respiratórios Bilevel Positive Airway Pressure- BIPAP', 'Pregão Eletrônico', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'Conferência processual', 'em_atraso', false, true, '2025-12-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0071', '1320.01.0091836/2024-28', 'Aquisição de "Kit enxoval"', 'Pregão Eletrônico para Registro de Preços', 'SUBRAS', 'SAPS', 'DGIC', 'DGIC', 'f-hom', 'em_atraso', false, false, '2025-03-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0072', '1320.01.0107760/2025-78', 'Serviços Especializados em Inteligência de Dados - ICOLAB', 'Dispensa', 'ATI', null, null, null, 'f-pp', 'em_atraso', false, false, '2026-07-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0073', '1320.01.0118764/2025-81', 'Contratação de empresa especializada em tecnologia da informação para prestação de serviços de licenciamento de software', 'Pregão Eletrônico', 'ATI', null, null, null, 'f-pp', 'em_atraso', false, false, '2026-07-09', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0074', '1300.01.0002129/2025-51', 'Fornecimento e distribuição de energia elétrica em média tensão para o Hospital Regional de Governador Valadares.', 'Inexigibilidade', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'Conferência processual', 'em_atraso', false, true, '2025-10-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0075', '1320.01.0075816/2025-42', 'Contratação da prestação de serviços de manutenção preventiva e corretiva em grupos geradores, incluindo a reposição/substituição de peças e componentes originais conforme especificações', 'Dispensa', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-jur', 'em_atraso', false, false, '2025-09-26', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0076', '1320.01.0119098/2025-84', 'Compra de Câmara de Conservação para uso médico-Hospitalar', 'Pregão Eletrônico para Registro de Preços', 'SUBGF', null, null, null, 'f-parado', 'em_atraso', false, false, '2026-05-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0077', '1320.01.0115328/2025-24', 'Aquisição de Material Médico/Hospitalar (seringas, agulhas e equipos)', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', null, 'SVE', 'f-parado', 'em_atraso', false, false, '2026-05-25', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0078', '1320.01.0095544/2025-13', 'Contratação de inscrições para congressos Instituto Negócios Públicos', 'Inexigibilidade', 'SUBGF', 'SILC', 'DCC', 'DCC', 'f-hom', 'em_atraso', false, false, '2025-08-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0079', '1320.01.0119554/2025-91', 'Aquisição de fraldas, absorventes e roupas íntimas descartáveis', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-jur', 'em_atraso', false, false, '2026-06-09', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0080', '1320.01.0051535/2025-06', 'Fornecimento e distribuição de energia elétrica em média tensão.', 'Inexigibilidade', 'SUBR', null, null, null, 'f-parado', 'em_atraso', false, false, '2026-02-09', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0081', '1320.01.0130727/2025-90', 'Contratação de inscrições para o 12º Encontro Nacional de Obras Públicas ENOP', 'Inexigibilidade', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-hom', 'em_andamento', false, false, null, 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0082', '1320.01.0136398/2025-39', 'Prestação de Serviços Tecnicos Especializados de Monitoramento de Obras', 'Concorrência', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-parado', 'em_atraso', false, true, '2026-06-26', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cadastro de propostas', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0083', '1320.01.0053328/2025-95', '60º Congresso da Sociedade Brasileira de Medicina Tropical (MEDTROP 2025)', 'Inexigibilidade', 'SUBVS', 'SVE', null, 'SVE', 'f-hom', 'em_andamento', false, false, null, 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0084', '1320.01.0134440/2025-40', 'Aquisição de insumos para o fortalecimento da vigilância em saúde ambiental', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVAST', 'DVAST', 'f-pp', 'em_andamento', false, false, '2026-08-07', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0085', '1320.01.0142469/2025-52', 'Contratação de empresa para a prestação de serviço de adequação da Central de Material Esterilizado (CME) do HR Div', 'COTEP', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-hom', 'em_atraso', false, false, '2025-11-04', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0086', '1320.01.0130532/2025-20', '2º Simpósio Nacional One Cursos', 'Inexigibilidade', 'SUBGF', 'SILC', 'DPAT', 'DPAT', 'f-hom', 'em_atraso', false, false, '2025-11-12', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0087', '1320.01.0144849/2025-06', 'SERVIÇO AUDITORIA VISANDO CERTIFICAÇÃO ISO', 'COTEP', 'SUBVS', 'SVS', null, 'SVS', 'f-pp', 'em_atraso', false, false, '2026-06-15', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0088', '1320.01.0116424/2025-17', 'COMPRA ESTADUAL – MEDICAMENTOS III (CBAF)', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-tr-a', 'em_atraso', false, false, '2025-10-15', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0089', '1320.01.0157239/2025-29', 'serviços de tele consultoria', 'Dispensa', 'SUBASS', 'SRA', 'DRAUE', 'DRAUE', 'f-pp', 'em_atraso', false, false, '2026-05-27', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0090', '1320.01.0181974/2025-29', 'Serviço de consultas remotas em psicologia e psiquiatria, vigilância de alto risco e assessoria em saúde mental', 'Pregão Eletrônico', 'SUBGF', 'SGDP', 'DPDH', 'DPDH', 'f-parado', 'em_atraso', false, true, '2026-05-27', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0091', '1320.01.0174846/2025-37', 'Assinatura de Plataformas Digitais de Suporte à Tomada de Decisão Baseada em Evidências', 'Inexigibilidade', 'SUBASS', null, null, null, 'f-etp-a', 'em_atraso', false, true, '2026-01-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0092', '1320.01.0139090/2025-08', 'Credenciamento de Consórcio Intermunicipal de Saúde', 'Credenciamento', 'SUBASS', null, null, null, 'f-etp-a', 'em_atraso', true, true, '2026-01-15', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0093', '1320.01.0129941/2025-69', 'Agulhas descartáveis', 'COTEP', 'SUBVS', 'SVE', null, 'SVE', 'f-pp', 'em_atraso', false, false, '2026-03-19', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0094', '1320.01.0179610/2025-31', 'Concessão HR Governador Valadares', 'Concorrência', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Sessão pública', 'em_atraso', true, true, '2026-04-15', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cadastro de propostas', 9, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0095', '1320.01.0202817/2025-62', 'Materiais para obra de reforma para CORE/MG', 'COTEP', 'SUBASS', null, null, null, 'f-tr-a', 'em_atraso', true, false, '2026-03-18', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0096', '1320.01.0002411/2026-70', 'Instrui processo para contratacao do Servico Medico Auxiliar - CORE/MG', 'Credenciamento', 'SUBASS', null, null, null, 'f-etp-a', 'em_atraso', true, true, '2026-02-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0097', '1320.01.0194226/2025-92', 'Preservativo masculino e gel lubrificante íntimo', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVCC', 'DVCC', 'f-pp', 'em_atraso', false, false, '2026-07-06', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0098', '5140.01.0005502/2025-20', 'Desenvolvimento e manutenção do Sistema Integrado de Gerenciamento da Assistência Farmacêutica (SIGAF)', 'Dispensa', 'ATI', null, null, null, 'f-pp', 'em_atraso', false, false, '2026-07-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0099', '1320.01.0003457/2026-55', 'Contratação de serviços de análise de processos de solicitação de medicamentos', null, 'SUBASS', 'SAF', null, 'SAF', 'f-etp-a', 'em_atraso', false, true, '2026-03-04', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0100', '1320.01.0020435/2026-71', 'Aquisição de equipamentos de áudio, vídeo e comunicação, destinados ao atendimento das atividades institucionais do Conselho Estadual de Saúde', 'COTEP', 'ASPAR', null, null, null, 'f-pp', 'em_atraso', false, false, '2026-07-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0101', '1320.01.0030068/2026-37', 'Contratação de empresa especializada na coleta, transporte, tratamento e destinação final ambientalmente adequada de resíduos de serviços de saúde (RSS)', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DPAT', 'DPAT', 'f-etp-a', 'em_atraso', false, true, '2026-05-18', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0102', '1320.01.0018641/2026-09', 'Locação de imóvel comercial destinado à instalação e funcionamento do Almoxarifado', 'Inexigibilidade', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-tr-a', 'em_atraso', false, true, '2026-06-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0103', '1320.01.0037263/2026-63', 'Locação de empilhadeiras', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-tr-e', 'em_atraso', false, true, '2026-07-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0104', '5140.01.0001007/2026-35', 'Desenvolvimento e manutenção do Sistema Visa Digital', 'Dispensa', 'ATI', null, null, null, 'f-pp', 'em_andamento', false, false, '2026-08-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0105', '1320.01.0189960/2025-38', 'Materiais de campanha como camisetas customizadas, banners, bottoms, canecas', 'COTEP', 'SUBGF', 'SGDP', 'DPDH', 'DPDH', 'f-tr-a', 'em_atraso', false, false, '2026-07-07', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0106', '1320.01.0184932/2025-91', 'Transporte de Carga via Rodoviário - Correios', 'Dispensa', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-pp', 'em_atraso', false, false, '2026-06-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0107', '1320.01.0027705/2026-12', 'COMPRA ESTADUAL MEDICAMENTOS II (ELENCO COMPLEMENTAR)', 'Pregão Eletrônico para Registro de Preços', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-tr-a', 'em_atraso', true, false, '2026-05-07', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0108', '1320.01.0048694/2026-80', 'Compra de agulhas descartáveis', 'COTEP', 'SUBVS', 'SVE', null, 'SVE', 'f-pp', 'em_atraso', false, false, '2026-05-27', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0109', '1320.01.0180880/2024-82', 'Processo Locação imovel SRS Patos de Minas', 'Inexigibilidade', 'SUBGF', null, null, null, 'f-pp', 'em_atraso', false, false, '2026-07-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0110', '1320.01.0125635/2025-28', 'Aquisição de ovitrampas', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVDTI', 'DVDTI', 'f-etp-a', 'em_atraso', false, false, '2026-05-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0111', '1320.01.0053418/2026-87', 'Aquisição de películas para embalagens para o Almoxarifado Central', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-pp', 'em_andamento', false, false, '2026-07-29', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0112', '1320.01.0035095/2026-11', 'COMPRA CENTRAL - LICENÇAS MICROSOFT', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-07-17', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0113', '1320.01.0026384/2026-80', 'Locação de sistema de senha e equipamentos para atendimento as farmácias de Minas', 'Pregão Eletrônico', 'ATI', null, null, null, 'f-etp-a', 'em_atraso', true, true, '2026-06-10', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0114', '1320.01.0064567/2026-55', 'Itens para montagem e implantação de armadilhas Ovitrampas', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVDTI', 'DVDTI', 'f-tr-a', 'em_atraso', false, true, '2026-06-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0115', '1320.01.0064813/2026-09', 'Aquisição de Bomba Elétrica, Válvula e Bomba Motorizada', 'Pregão Eletrônico para Registro de Preços', 'SUBVS', 'SVE', 'DVDTI', 'DVDTI', 'f-tr-a', 'em_atraso', false, true, '2026-06-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Gestão SEPLAG', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0116', '5140.01.0005702/2025-52', 'SES- INF-5520.00 - Servicos de Rede', 'Dispensa', 'ATI', null, null, null, 'f-tr-a', 'em_atraso', false, true, '2026-06-26', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0117', '1320.01.0202633/2025-83', 'Congresso MEDTROP 2026', 'Inexigibilidade', 'SUBVS', 'SVE', null, 'SVE', 'f-pp', 'em_andamento', false, false, '2026-07-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0118', '1320.01.0057777/2026-55', 'Monitoramento remoto por CFTV e controle de acesso da Unidade Integrada de Saúde (Farmácia de Minas) da Superintendência Regional de Belo Horizonte', 'Dispensa', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'f-tr-a', 'em_atraso', false, true, '2026-06-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0119', '1320.01.0077510/2026-85', 'Contratação do serviço de Auditoria visando Certificação ABNT NBR ISO 9001:2015 do escopo: "inspeção sanitária de boas práticas de fabricação em indústria farmacêutica"', 'COTEP', 'SUBVS', 'SVS', null, 'SVS', 'f-tr-a', 'em_atraso', false, true, '2026-07-02', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0120', '1320.01.0065156/2026-60', 'Fornecimento e distribuição de energia elétrica em média tensão para atender à nova sede da Superintendência Regional de Saúde de Manhuaçu', 'Inexigibilidade', 'SUBR', null, null, null, 'f-tr-a', 'em_atraso', false, true, '2026-07-07', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0121', '1320.01.0076527/2026-48', '10º Congresso Brasileiro de Ciências Sociais e Humanas em Saúde', 'Inexigibilidade', 'SUBGF', 'SGDP', 'DPDH', 'DPDH', 'f-pp', 'em_atraso', false, false, '2026-07-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0122', '1320.01.0092066/2025-23', 'Mudança da sede da Superintendência Regional de Saúde de Patos de Minas/MG', 'Pregão Eletrônico', 'SUBR', null, null, null, 'f-etp-a', 'em_andamento', false, false, '2026-07-31', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0123', '1320.01.0186493/2025-42', 'Locação de Imóvel URS Pouso Alegre', 'Inexigibilidade', 'SUBR', null, null, null, 'f-tr-a', 'em_andamento', false, true, '2026-07-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0124', '1320.01.0182543/2025-89', 'Locação de Imóvel URS Leopoldina', 'Inexigibilidade', 'SUBR', null, null, null, 'f-tr-a', 'em_andamento', false, true, '2026-07-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0125', '1320.01.0119716/2023-88', 'Contrato para prestação de serviços de despacho aduaneiro e desembaraço alfandegário', 'Pregão Eletrônico', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'f-pp', 'em_atraso', false, false, '2025-03-20', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0126', '1320.01.0032276/2025-79', 'Aquisição de mesa cirúrgica', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0127', '1320.01.0032476/2025-14', 'Aquisição de 07 (sete) Focos Cirúrgicos de Teto para serem incorporados ao parque tecnológico do Hospital Regional de Teófilo Otoni', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'f-hom', 'em_atraso', false, false, '2025-05-23', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0128', '1320.01.0148072/2025-91', 'Serviços de assinatura de ferramenta de pesquisa e comparação de preços praticados pela Administração Pública, sem dedicação exclusiva de mão de obra', 'Inexigibilidade', 'SUBGF', 'SILC', 'DCC', 'DCC', 'Conferência processual', 'em_atraso', false, true, '2026-01-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0129', '1320.01.0114348/2020-18', 'Prestação do serviço de assinatura de ferramenta de pesquisa e comparação de preços praticados pela Administração 
Pública(Banco de Preços)', 'Inexigibilidade', 'SUBGF', 'SILC', 'DCC', 'DCC', 'f-parado', 'em_atraso', false, false, '2026-01-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0130', '1320.01.0072551/2026-21', 'Auxilio a regional Manhuaçu ( cotação de contratação de empresa de mudança)', null, 'SUBR', null, null, null, 'f-pp', 'em_atraso', false, false, '2026-07-03', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0131', '1320.01.0019332/2025-76', 'Aquisição de três equipamentos de hemodinâmica para serem incorporados aos parques tecnológicos dos Hospitais Regionais de Teófilo Otoni e de Governador Valadares', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'f-hom', 'em_atraso', false, true, '2025-02-26', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0132', '1320.01.0034812/2025-89', 'Compra de 04 (quatro) ARCOS CIRURGICOS, para serem incorporados ao parque tecnológico do Hospital Regional de Teófilo Otoni', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2025-08-07', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0133', '1320.01.0034845/2025-71', 'Adesão à Ata de Registro de Preços 319/2024 (108239840), visando à aquisição de 05 (cinco) aparelho(s) de Raio X para atender às necessidades desta Diretoria de Estruturação Hospitalar de Urgência e Emergência.', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2025-09-17', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0134', '1320.01.0148880/2024-07', 'Contratação da prestação de serviços de calibração de equipamentos e instrumentos de precisão', 'COTEP', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'Cadastro de propostas', 'em_atraso', false, true, '2025-08-28', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0135', '1320.01.0130532/2025-21', '2º Simpósio Nacional One Cursos', 'Inexigibilidade', 'SUBGF', 'SILC', 'DPAT', 'DPAT', 'f-hom', 'em_andamento', false, false, null, 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0136', '1320.01.0138158/2025-49', 'Ressonância magnética', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2026-03-25', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0137', '1320.01.0012600/2026-59', 'Contratação de licenças de Software de Desingn gráfico, com direito de atualização e suporte', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-05-29', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0138', '1320.01.0041601/2026-16', 'Compra Central- Atendimento Judicial-Medicamentos I', 'Adesão', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-parado', 'em_atraso', false, false, '2026-04-10', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0139', '1320.01.0046040/2026-55', 'Compra Central de Medicamentos  VII', 'Adesão', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-parado', 'em_atraso', false, false, '2026-04-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0140', '1320.01.0042431/2026-13', 'Compra Central - Medicamentos VI', 'Adesão', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-parado', 'em_atraso', false, false, '2026-04-10', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0141', '1320.01.0045668/2026-11', 'Compra Central de Medicamentos IX', 'Adesão', 'SUBASS', 'SAF', 'DPAM', 'DPAM', 'f-parado', 'em_atraso', false, false, '2026-04-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0142', '1320.01.0042877/2026-96', 'Compra Central de Medicamentos VII', 'Adesão', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-parado', 'em_atraso', false, false, '2026-04-10', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0143', '1320.01.0044056/2026-79', 'Compra Central de Medicamentos IX', 'Adesão', 'SUBASS', 'SJUD', 'DCDJ', 'DCDJ', 'f-parado', 'em_atraso', false, false, '2026-04-10', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0144', '1320.01.0165345/2025-96', 'Serviço de Manutenção Preventiva e Corretiva em Grupo Motor Gerador', 'Dispensa', 'SUBGF', 'SILC', 'DIFE', 'DIFE', 'Conferência processual', 'em_atraso', false, true, '2026-04-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 9, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0145', '1320.01.0047324/2026-16', 'Material Médico Hospitalar- Diversos II 2026', 'Adesão', 'SUBVS', null, null, null, 'f-parado', 'em_atraso', false, false, '2026-04-17', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0146', '1320.01.0083451/2026-19', 'Estabilizadores e Nobreaks', 'Adesão', 'SUBGF', null, null, null, 'f-parado', 'em_atraso', false, false, '2026-06-26', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'em_andamento', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0147', '1320.01.0085725/2025-25', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0148', '1320.01.0088599/2025-27', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0149', '1320.01.0086877/2025-58', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0150', '1320.01.0088600/2025-97', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0151', '1320.01.0085751/2025-02', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0152', '1320.01.0090197/2025-46', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0153', '1320.01.0085858/2025-23', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0154', '1320.01.0086212/2025-68', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0155', '1320.01.0078070/2025-03', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-13', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0156', '1320.01.0065901/2025-27', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-06-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0157', '1320.01.0165369/2024-33', 'Compra central de passagens aéreas e rodoviárias', 'Adesão', 'SUBGF', 'SILC', 'DLOG', 'DLOG', 'Conferência processual', 'em_atraso', false, true, '2025-05-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0158', '1320.01.0067214/2025-78', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-05-21', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0159', '1320.01.0066205/2025-64', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-05-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0160', '1320.01.0002777/2025-85', 'Prestação de serviços de certificação digital para pessoa física e/ou jurídica', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-02-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0161', '1320.01.0019955/2025-36', 'Outsourcing de impressão', 'Pregão Eletrônico', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-02-25', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0162', '1320.01.0037713/2025-41', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-04-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0163', '1320.01.0043403/2025-59', 'Adesão ao RP de manutenção da SEPLAG', 'Adesão', 'SUBGF', null, null, null, 'Conferência processual', 'em_atraso', true, true, '2025-04-16', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0164', '1320.01.0023056/2021-32', 'Concessão de uso de imóvel para o Hospital Mário Penna', 'Concorrência', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2025-03-14', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Edital', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cadastro de propostas', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 11, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 12, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0165', '1320.01.0077940/2025-21', 'Compra Central de Serviço Móvel Pessoal (SMP)', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-07-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0166', '1320.01.0080933/2025-11', 'Prestação de serviços de lava jato', 'COTEP', 'SUBR', null, null, null, 'f-tr-e', 'em_atraso', false, true, '2025-06-26', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0167', '1320.01.0097822/2025-05', 'Prestação de serviços de lava jato', 'COTEP', 'SUBR', null, null, null, 'f-tr-e', 'em_atraso', false, true, '2025-08-05', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0168', '1320.01.0160894/2024-93', 'Manutenção corretiva e preventiva em elevadores, com fornecimento de peças', 'COTEP', 'SUBR', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-09-19', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0169', '1320.01.0118143/2025-67', 'Prestação de serviços de lavagem de veículos sem dedicação exclusiva de mão de obra', 'COTEP', 'SUBR', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-01-21', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0170', '1320.01.0147201/2025-37', 'Prestação de serviços de lavagem de veículos, sem dedicação exclusiva de mão de obra, nos carros oficiais ou locados que atendem a Superintendência Regional de Saúde de Pouso Alegre', 'COTEP', 'SUBR', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-01-22', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0171', '1320.01.0113325/2024-79', 'Prestação de serviços especializado em manutenção de dois elevadores tipo plataforma vertical', 'COTEP', 'SUBR', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-01-09', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0172', '1320.01.0147588/2025-64', 'COMPRA CENTRAL - LICENÇAS MICROSOFT', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-11-18', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0173', '1320.01.0111467/2025-93', 'COMPRA CENTRAL - SERVIÇOS DE INFRAESTRUTURA DE TIC', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2025-11-18', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0174', '1320.01.0128786/2025-20', 'COMPRA CENTRAL - SERVIÇOS DE INFRAESTRUTURA DE TIC', 'Adesão', 'ATI', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-02-19', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0175', '1320.01.0150658/2025-12', 'Ventiladores pulmonares', 'Adesão', 'SUBRAS', 'SPAH', 'DEHUE', 'DEHUE', 'Conferência processual', 'em_atraso', false, true, '2026-03-10', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0176', '1320.01.0143286/2025-12', 'Dedetização', 'COTEP', 'SUBR', null, null, null, 'Conferência processual', 'em_atraso', false, true, '2026-01-30', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Conferência processual', 6, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Cotação Eletrônica de Preços', 8, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Sessão pública', 9, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação', 10, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 11, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0177', '1320.01.0199400/2025-74', 'Cabeamento estruturado e lógico', 'Adesão', 'SUBASS', 'SRA', null, 'SRA', 'Conferência processual', 'em_atraso', false, true, '2026-01-19', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

  insert into processos (codigo, num_sei, objeto, modalidade, subsecretaria, superintendencia, diretoria, area_demandante, etapa_atual, status, prioritario, tem_contrato, prazo_final, ano, ativo)
  values ('PAC-2026-0178', '1320.01.0000507/2026-68', 'Renovação dos licenciamentos de software e do suporte técnico especializado hiperconvergente', 'Adesão', 'ATI', null, null, null, 'f-tr-e', 'em_atraso', false, true, '2026-06-11', 2026, true)
  returning id into v_pid;
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em elaboração', 1, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'ETP em análise', 2, 'concluida', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em elaboração', 3, 'em_andamento', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'TR em análise', 4, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Pesquisa de preços', 5, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Saneamento de ressalvas jurídicas', 6, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Homologação - Portal de Compras', 7, 'nao_iniciada', 1, null);
  insert into etapas (processo_id, fase, ordem, status, versao, coordenacao) values (v_pid, 'Parado/Sem previsão', 8, 'nao_iniciada', 1, null);

end $$;

-- Fim. 178 processos com etapas e status corretos.

-- ####################################################################
-- ARQUIVO: 13_credenciamento.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Adicionar modalidade Credenciamento
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO, antes do 12_inserir_processos.sql.
-- Adiciona a modalidade Credenciamento (sem prazos por ora;
-- as fases/prazos você define depois).
-- ============================================================

insert into modalidades (sigla, nome, ativo)
select 'CRED', 'Credenciamento', true
where not exists (select 1 from modalidades where sigla='CRED');

-- ============================================================
-- Pronto. Credenciamento disponível. (Prazos por fase: depois.)
-- ============================================================


-- ####################################################################
-- ARQUIVO: 14_novos_usuarios.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Adicionar 2 usuários DCC
-- ------------------------------------------------------------
-- Rayssa Pacheco e Arthur Miranda, ambos nível DCC (veem tudo).
--
-- ANTES de rodar este SQL, crie os acessos no painel:
--   Authentication > Users > Add user
--   - rayssa.santos@saude.mg.gov.br  | senha: Mudar@2026 | Auto Confirm
--   - arthur.alves@saude.mg.gov.br   | senha: Mudar@2026 | Auto Confirm
--
-- Depois rode este SQL (no PROJETO CERTO).
-- ============================================================

insert into public.usuarios (email, nome, nivel, precisa_trocar_senha, ativo) values
  ('rayssa.santos@saude.mg.gov.br', 'Rayssa Pacheco', 'dcc', true, true),
  ('arthur.alves@saude.mg.gov.br',  'Arthur Miranda', 'dcc', true, true)
on conflict (email) do update set
  nome=excluded.nome, nivel=excluded.nivel, ativo=true;

-- ============================================================
-- Pronto. No primeiro acesso, cada um cria a própria senha.
-- ============================================================


-- ####################################################################
-- ARQUIVO: 15_marcar_senha_trocada.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Corrigir "senha pede trocar sempre"
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO (tatinrolrssjervuykej).
-- Cria uma função segura que marca precisa_trocar_senha=false
-- para o usuário logado. Resolve o loop de "criar senha nova".
-- ============================================================

create or replace function marcar_senha_trocada()
returns void
language sql
security definer
set search_path = public
as $$
  update usuarios
  set precisa_trocar_senha = false
  where auth_id = auth.uid()
     or lower(email) = lower(auth.jwt() ->> 'email');
$$;

grant execute on function marcar_senha_trocada() to authenticated;

-- ============================================================
-- Também garante que o auth_id esteja preenchido (liga a conta
-- de login ao registro na tabela usuarios, pelo e-mail).
-- ============================================================
update usuarios u
set auth_id = a.id
from auth.users a
where lower(u.email) = lower(a.email)
  and (u.auth_id is null or u.auth_id <> a.id);

-- ============================================================
-- Pronto. Rode e depois republique o sistema atualizado.
-- ============================================================


-- ####################################################################
-- ARQUIVO: 16_datas_historico.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Datas do histórico nas etapas
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO (tatinrolrssjervuykej).
-- Prepara a tabela 'etapas' para receber o histórico real:
--   data_entrada      = quando chegou à DCC para esta fase
--   data_saida        = quando a DCC finalizou a etapa
--   data_retorno      = quando efetivamente seguiu (área devolveu/assinou)
--   observacao        = observação registrada naquela fase
--
-- Com isso o sistema calcula:
--   tempo total da fase   = data_retorno - data_entrada  (usado no Gantt)
--   tempo da DCC          = data_saida   - data_entrada
--   tempo aguardando área = data_retorno - data_saida
-- ============================================================

alter table etapas add column if not exists data_entrada date;
alter table etapas add column if not exists data_saida   date;
alter table etapas add column if not exists data_retorno date;
alter table etapas add column if not exists observacao   text;

-- índice para consultas por processo/ordem (Gantt e timeline)
create index if not exists idx_etapas_processo_ordem on etapas(processo_id, ordem);

-- ============================================================
-- Pronto. Estrutura preparada para receber o histórico.
-- ============================================================


-- ####################################################################
-- ARQUIVO: 17_importar_historico.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Importar histórico de etapas
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO (tatinrolrssjervuykej).
-- APÓS ter rodado o 16_datas_historico.sql (colunas de datas).
--
-- Para cada processo: apaga as etapas macro antigas e recria
-- as etapas reais do histórico (com coordenação, versão pela
-- sequência, e as 3 datas). A ÚLTIMA etapa vira a fase atual.
-- ============================================================

do $$
declare v_pid bigint;
begin
  -- limpar etapas antigas (as macro criadas na importação dos processos)
  delete from etapas;

  select id into v_pid from processos where num_sei = '1300.01.0001031/2024-18';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-01-21', '2025-02-10', '2025-02-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-02-10', '2025-03-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-02-26', '2025-02-28', '2025-03-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-03-11', '2025-03-14', '2025-03-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 5, 1, 'concluida', '2025-03-19', '2025-03-20', '2025-03-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 6, 2, 'concluida', '2025-03-19', '2025-03-20', '2025-03-23', 'Encaminhamentos de minutas de contrato para análise jurídica');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 2, 'concluida', '2025-03-23', '2025-03-25', '2025-03-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 8, 1, 'concluida', '2025-03-28', '2025-04-07', '2025-04-07', 'Envio do Memorando informando a conclusão da inexigibilidade de licitação para a área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 9, 1, 'concluida', '2025-04-07', '2025-04-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 10, 1, 'em_andamento', '2025-04-29', '2025-04-30', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1300.01.0002129/2025-51';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-25', '2025-08-05', '2025-08-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-08-13', '2025-08-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-08-18', '2025-08-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-08-22', '2025-08-27', '2025-09-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 5, 1, 'concluida', '2025-09-02', '2025-09-02', '2025-09-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 2, 'concluida', '2025-09-12', '2025-09-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2025-09-19', '2025-09-24', '2025-10-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2025-10-14', '2025-10-16', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1300.01.0003099/2025-51';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-06-26', '2025-07-04', '2025-07-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-07-23', '2025-07-25', '2025-07-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-07-30', '2025-08-04', '2025-08-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-08-11', '2025-08-12', '2025-08-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 5, 1, 'concluida', '2025-08-18', '2025-08-18', null, 'Área demandante elaborando novo TR e faltando documentação');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 6, 1, 'concluida', '2025-09-19', '2025-09-24', '2025-10-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 7, 1, 'em_andamento', '2025-10-14', '2025-10-16', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1300.01.0003369/2024-39';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-05-20', '2024-06-07', '2024-06-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2024-06-21', '2024-07-16', '2024-07-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2024-07-29', '2024-09-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 4, 1, 'concluida', '2024-09-04', '2024-09-20', '2024-10-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 5, 1, 'concluida', '2024-10-25', '2024-11-01', '2024-11-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 6, 2, 'concluida', '2024-11-28', '2024-11-28', '2024-12-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 7, 1, 'concluida', '2024-12-09', '2024-12-10', '2024-12-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 8, 3, 'concluida', '2024-12-23', '2024-12-23', '2024-12-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 9, 1, 'concluida', '2024-12-29', '2024-12-30', '2025-01-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 10, 1, 'concluida', '2025-01-08', '2025-01-09', '2025-01-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 11, 2, 'concluida', '2025-01-28', '2025-01-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 12, 1, 'em_andamento', '2025-02-11', '2025-03-31', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1300.01.0003601/2024-80';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-01-21', '2025-02-05', '2025-02-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-02-06', '2025-03-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-02-25', '2025-02-28', '2025-03-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-03-10', '2025-03-14', '2025-03-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 5, 1, 'concluida', '2025-03-18', '2025-03-18', '2025-03-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 6, 2, 'concluida', '2025-03-20', '2025-03-20', '2025-03-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 2, 'concluida', '2025-03-24', '2025-03-24', '2025-03-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 8, 1, 'concluida', '2025-03-25', '2025-03-27', '2025-03-28', 'Alteração no Termo de Referência e cumprimento de ressalvas da nota jurídica');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 9, 2, 'concluida', '2025-03-27', '2025-04-07', '2025-04-07', 'Envio do Memorando informando a conclusão da inexigibilidade de licitação para a área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 10, 1, 'concluida', '2025-04-07', '2025-04-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 11, 1, 'em_andamento', '2025-04-23', '2025-04-24', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0000507/2026-68';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2026-06-09', '2026-06-11', '2026-07-22', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 2, 2, 'em_andamento', '2026-07-22', '2026-07-22', null, 'Devolvido para a CL novamente pois não há ressalvas a serem cumpridas no momento');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0001763/2024-15';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-12-27', '2025-01-15', '2025-02-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-01-16', '2025-01-17', null, 'Processo veio para consulta Atas de registro de Preços');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 1, 'concluida', '2025-01-24', '2025-01-30', '2025-02-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 4, 1, 'concluida', '2025-02-04', '2025-02-04', '2025-04-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 5, 1, 'concluida', '2025-04-02', '2025-04-16', '2025-05-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 1, 'concluida', '2025-05-16', '2025-05-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração do Edital e anexos', 'CL', 7, 1, 'concluida', '2025-05-21', '2025-06-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 8, 1, 'concluida', '2025-06-05', '2025-06-26', '2025-07-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 9, 1, 'concluida', '2025-07-08', '2025-07-09', '2025-07-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 10, 2, 'concluida', '2025-07-10', '2025-07-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 11, 2, 'concluida', '2025-07-10', '2025-07-17', '2025-07-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 12, 1, 'concluida', '2025-07-18', '2025-07-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 13, 1, 'concluida', '2025-07-21', '2025-07-22', null, 'Adequações de itens Catmas do Termo de Referência');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 14, 1, 'concluida', '2025-07-30', '2025-12-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 15, 1, 'concluida', '2025-10-30', '2025-10-31', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 16, 2, 'concluida', '2025-11-05', '2025-11-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 17, 1, 'concluida', '2025-11-17', '2025-11-17', '2025-12-01', 'Solicitação de elaboração de minuta de contrato para o Pregão Eletrônico para Registro de Preços');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 18, 1, 'concluida', '2025-11-18', '2025-11-18', null, 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 19, 3, 'concluida', '2025-12-01', '2025-12-02', '2025-12-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 20, 2, 'concluida', '2025-12-16', '2025-12-17', '2025-12-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 21, 3, 'concluida', '2025-12-17', '2025-12-17', '2025-12-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 22, 1, 'concluida', '2025-12-19', '2025-12-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 23, 1, 'em_andamento', null, null, null, null);
  update processos set etapa_atual = 'Saneamento de ressalvas e finalização do edital' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0002411/2026-70';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-01-27', '2026-02-02', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'em_andamento', '2026-01-27', '2026-02-02', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0002777/2025-85';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-01-30', '2025-02-04', '2025-02-05', 'Solicita observação de pendências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-02-05', '2025-02-07', '2025-02-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-02-07', '2025-02-10', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0003457/2026-55';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-02-09', '2026-02-12', '2026-02-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'em_andamento', '2026-02-25', '2026-03-03', null, null);
  update processos set etapa_atual = 'ETP conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0003733/2025-75';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-04-24', '2025-05-09', '2025-07-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-07-11', '2025-07-15', '2025-07-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2025-07-24', '2025-07-28', '2025-08-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2025-08-05', '2025-08-20', '2025-10-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2025-10-24', '2025-11-11', '2025-11-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 2, 'concluida', '2025-11-19', '2025-12-02', '2025-12-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 7, 1, 'concluida', '2025-12-16', '2025-12-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 1, 'concluida', '2025-12-17', '2026-01-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 9, 1, 'concluida', '2026-02-20', '2026-02-27', '2026-02-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 10, 1, 'concluida', '2026-02-25', '2026-02-26', '2026-05-15', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 11, 1, 'concluida', '2026-03-20', '2026-03-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 12, 1, 'concluida', '2026-05-15', '2026-05-18', '2026-05-28', 'Devolvido para área demandante com pendências para formalizar o contrato');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 13, 1, 'concluida', '2026-05-28', '2026-05-28', '2026-06-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 14, 1, 'concluida', '2026-06-03', '2026-06-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 15, 1, 'em_andamento', null, '2026-02-27', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0004597/2025-27';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-03-17', '2025-03-28', '2025-04-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-04-28', '2025-05-06', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-05-07', '2025-05-26', '2025-07-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-07-08', '2025-07-09', '2025-08-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 5, 1, 'concluida', '2025-07-09', '2025-07-10', '2025-10-10', 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 6, 1, 'concluida', '2025-08-04', '2025-08-05', '2025-09-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 7, 1, 'concluida', '2025-09-10', '2025-09-24', '2025-10-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 8, 2, 'concluida', '2025-10-07', '2025-10-07', '2025-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 9, 1, 'concluida', '2025-10-10', '2025-10-13', '2025-10-15', 'Devolvido para a área demandante com pendências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 10, 1, 'concluida', '2025-10-15', '2025-10-16', '2025-10-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 11, 1, 'em_andamento', '2025-10-16', '2025-10-17', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0006080/2024-50';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 1, 1, 'concluida', '2024-06-14', '2024-06-24', '2024-08-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 2, 'concluida', '2024-08-02', '2024-08-29', '2024-09-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 3, 'concluida', '2024-09-25', '2024-10-02', '2025-02-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 4, 4, 'concluida', '2025-02-18', '2025-03-10', '2025-03-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 5, 1, 'concluida', '2025-03-19', '2025-03-26', '2025-04-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 6, 1, 'concluida', '2025-04-24', '2025-05-07', '2025-05-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-pesquisa de preços', 'CAP', 7, 1, 'concluida', '2025-05-19', '2025-05-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 1, 'concluida', '2025-05-23', '2025-06-26', '2025-07-11', 'Status  - Aguardar posicionamento área demante.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 9, 1, 'concluida', '2025-07-14', '2025-07-18', '2025-08-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 10, 1, 'em_andamento', '2025-07-14', '2025-07-16', '2025-07-17', null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0012600/2026-59';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2026-03-12', '2026-03-13', '2026-05-26', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 2, 1, 'concluida', '2026-04-14', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 3, 1, 'concluida', '2026-04-29', '2026-05-06', '2026-05-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 4, 1, 'concluida', '2026-05-07', '2026-05-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 5, 2, 'concluida', '2026-05-25', '2026-05-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 6, 1, 'concluida', '2026-05-26', '2026-05-26', '2026-05-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 7, 1, 'em_andamento', '2026-05-27', '2026-05-28', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0018641/2026-09';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-07', '2026-04-23', '2026-05-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-05-15', '2026-05-22', '2026-05-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2026-05-22', null, null, 'Processo paralisado');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 4, 1, 'em_andamento', '2026-05-27', '2026-06-03', null, null);
  update processos set etapa_atual = 'TR conferência final' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0019081/2025-63';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-04-14', '2025-05-07', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 2, 'concluida', '2025-06-10', '2025-06-17', '2025-07-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 1, 'concluida', '2025-07-10', '2025-07-18', '2025-08-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 2, 'concluida', '2025-08-01', '2025-08-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 5, 1, 'concluida', '2025-08-07', '2025-08-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 6, 1, 'concluida', '2025-08-22', '2025-08-22', '2025-09-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 7, 1, 'concluida', '2025-09-05', '2025-09-05', '2025-09-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 8, 1, 'concluida', '2025-09-09', '2025-09-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 9, 1, 'concluida', '2025-09-12', '2025-09-12', '2025-09-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 10, 1, 'em_andamento', '2025-09-15', '2025-09-16', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0019332/2025-76';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 1, 1, 'concluida', '2025-02-11', '2025-02-13', '2025-02-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 2, 1, 'concluida', '2025-02-19', '2025-02-19', '2025-02-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-02-21', '2025-02-21', '2025-02-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'concluida', '2025-02-21', '2025-02-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 5, 1, 'em_andamento', '2025-02-21', '2025-02-21', null, 'Processo não retorna para CL após ir para CFCO');
  update processos set etapa_atual = 'Saneamento de ressalvas e homologação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0019955/2025-36';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 1, 1, 'concluida', '2025-02-20', '2025-02-20', '2025-02-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 2, 1, 'em_andamento', '2025-02-21', '2025-03-07', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0020435/2026-71';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-03-16', '2026-03-24', '2026-05-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-05-06', '2026-05-13', '2026-05-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 2, 'concluida', '2026-05-20', '2026-05-27', '2026-05-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 3, 'concluida', '2026-05-28', '2026-06-02', '2026-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2026-06-11', '2026-06-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'em_andamento', '2026-06-15', '2026-07-20', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0023056/2021-32';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2021-04-27', '2021-04-27', '2025-02-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 2, 1, 'concluida', '2025-02-25', '2025-02-25', '2025-02-28', 'Envio para a AJ');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-02-28', '2025-03-12', '2025-03-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2025-03-12', '2025-03-13', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0023461/2024-49';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-04-15', '2024-04-25', '2024-05-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2024-05-02', '2024-05-03', '2024-06-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2024-06-27', '2024-08-12', '2024-08-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 4, 1, 'concluida', '2024-08-01', '2024-08-02', '2024-09-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2024-08-30', '2024-09-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 6, 1, 'em_andamento', '2024-11-05', '2024-11-06', '2024-11-19', null);
  update processos set etapa_atual = 'Saneamento de ressalvas e finalização do edital' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0025237/2025-12';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 1, 1, 'concluida', '2025-02-14', '2025-02-19', '2025-02-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2025-02-24', '2025-03-10', '2025-03-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 3, 1, 'concluida', '2025-02-28', '2025-03-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Aprovação e divulgação', 'CL', 4, 1, 'concluida', '2025-03-18', '2025-03-18', '2025-03-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologar e finalizar', 'CL', 5, 1, 'em_andamento', '2025-03-25', '2025-03-31', null, 'Enviado para a área demandante solicitar a execução para a CAE');
  update processos set etapa_atual = 'Homologar e finalizar' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0026199/2024-37';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-08-29', '2024-10-04', '2024-10-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2024-10-14', '2024-11-21', '2024-12-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 3, 1, 'concluida', '2025-04-14', '2025-04-23', null, 'Atualização Mapa de preços para 02 casas decimais após a vírgula visando compatibilidade com o Portal de Compras');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 4, 1, 'em_andamento', '2025-04-23', '2025-04-24', null, 'Desde 27/05/2025 não há movimentações no processo por parte da area demandante, memorando devolvendo para area demandante em  04/07/2025.');
  update processos set etapa_atual = 'Conferência processual e elaboração de aviso e anexos' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0026384/2026-80';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-06-01', '2026-06-10', null, null);
  update processos set etapa_atual = 'ETP 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0026996/2024-52';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-08-29', '2024-09-20', '2024-10-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2024-08-29', '2024-09-20', '2024-10-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 1, 'concluida', '2024-10-01', '2025-01-08', '2025-03-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2024-10-01', '2025-01-08', '2025-01-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-01-13', '2025-01-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2025-01-14', '2025-02-11', '2025-02-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 1, 'concluida', '2025-02-03', '2025-02-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 8, 1, 'concluida', '2025-03-12', '2025-03-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 9, 1, 'concluida', '2025-03-31', '2026-04-08', null, 'Abertura da sessão pública 07/04/2026, ás 10;30');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 10, 1, 'concluida', '2025-06-16', '2025-06-27', '2025-07-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 11, 2, 'concluida', '2025-07-02', '2025-07-04', '2025-07-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 12, 1, 'concluida', '2025-07-07', '2025-07-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 13, 2, 'concluida', '2025-12-19', '2026-01-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 14, 1, 'concluida', '2026-02-10', '2026-02-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 15, 1, 'concluida', '2026-04-09', '2026-05-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'None', 'CL', 16, 1, 'em_andamento', null, null, null, null);

  select id into v_pid from processos where num_sei = '1320.01.0027705/2026-12';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-16', '2026-04-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'em_andamento', '2026-04-29', '2026-05-07', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0028164/2025-38';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-02-17', '2025-03-26', '2025-04-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 2, 1, 'concluida', '2025-03-14', '2025-03-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 1, 'em_andamento', '2025-04-07', '2025-04-16', '2026-04-07', null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0030068/2026-37';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-03-23', '2026-04-06', '2026-05-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'em_andamento', '2026-05-11', '2026-05-18', null, null);
  update processos set etapa_atual = 'ETP conferência final' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0032276/2025-79';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 1, 1, 'concluida', '2025-04-14', '2025-04-15', '2025-04-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 2, 1, 'concluida', '2025-04-15', '2025-04-16', '2025-05-28', 'Elaborada minuta e devolvido para a CL');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 3, 1, 'concluida', '2025-04-15', '2025-04-16', null, 'Em acordo DCC esse setor não fara análises das caronas em processos hospitais regionais');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 4, 2, 'concluida', '2025-04-16', '2025-04-25', '2025-05-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 5, 1, 'concluida', '2025-05-06', '2025-05-07', '2025-05-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 6, 2, 'concluida', '2025-05-20', '2025-05-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 7, 2, 'concluida', '2025-05-28', '2025-05-29', '2025-06-06', 'Para adequação de pendências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 8, 1, 'em_andamento', '2025-06-06', '2025-06-06', '2025-06-13', null);
  update processos set etapa_atual = 'Disponibilização para assinaturas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0032476/2025-14';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 1, 1, 'concluida', '2025-04-16', '2025-04-29', '2025-05-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 2, 1, 'concluida', '2025-04-16', '2025-04-22', null, 'Em acordo DCC esse setor não fara análises das caronas em processos hospitais regionais');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 3, 1, 'concluida', '2025-05-07', '2025-05-07', '2025-05-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 4, 1, 'em_andamento', '2025-05-20', '2025-05-23', '2025-05-26', null);
  update processos set etapa_atual = 'Saneamento de ressalvas e homologação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0034812/2025-89';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 1, 1, 'concluida', '2025-07-02', '2025-07-04', '2025-07-11', 'Foi considerado odia 02/07/2025 como o dia de entrada do processo na CL, sendo o dia que recebemos a anuência do órgão gerenciador da carona (SES-DF) no contratos.gov.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 2, 1, 'concluida', '2025-07-11', '2025-07-11', '2025-07-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 3, 1, 'concluida', '2025-07-23', '2025-07-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 4, 1, 'concluida', '2025-07-24', '2025-07-28', '2025-07-31', 'Devolvido para a CL para sanar pendências com relação à minuta (não houve análise pela AJ) e documentos');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 5, 1, 'concluida', '2025-07-31', '2025-08-01', '2025-08-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 6, 1, 'em_andamento', '2025-08-05', '2025-08-07', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0034845/2025-71';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 1, 1, 'concluida', '2025-08-15', '2025-08-20', '2025-08-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 2, 1, 'concluida', '2025-08-20', '2025-08-21', '2025-09-05', 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 3, 2, 'concluida', '2025-08-21', '2025-08-25', '2025-08-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 4, 1, 'concluida', '2025-08-28', '2025-08-29', '2025-09-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 5, 1, 'concluida', '2025-09-01', '2025-09-05', '2025-09-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 6, 1, 'concluida', '2025-09-05', '2025-09-09', '2025-09-12', 'Devolvido para a demandante providenciar cadastro do fornecedor no SEI');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2025-09-12', '2025-09-12', '2025-09-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2025-09-15', '2025-09-18', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0035095/2026-11';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-06-01', '2026-06-10', '2026-06-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2026-06-16', '2026-06-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2026-06-18', '2026-06-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 4, 1, 'concluida', '2026-06-29', '2026-06-29', '2026-07-14', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 5, 1, 'concluida', '2026-07-14', '2026-07-14', '2026-07-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 6, 1, 'em_andamento', '2026-07-15', '2026-07-16', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0035886/2025-94';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-07', '2025-07-21', '2025-11-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-11-03', '2025-11-10', '2026-01-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2026-01-19', '2026-01-26', '2026-02-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 4, 1, 'concluida', '2026-02-19', '2026-02-26', '2026-06-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 5, 1, 'em_andamento', '2026-06-22', '2026-07-07', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0037263/2026-63';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-07', '2026-04-14', '2026-05-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2026-05-15', '2026-05-20', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2026-05-15', '2026-05-22', '2026-05-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 4, 1, 'concluida', '2026-05-26', '2026-05-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 5, 1, 'concluida', '2026-05-29', '2026-06-22', null, 'Mapa validado pela área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 6, 1, 'concluida', '2026-07-14', '2026-07-16', '2026-07-22', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 7, 2, 'em_andamento', '2026-07-22', '2026-07-22', null, 'Devolvido para a CL novamente pois não há ressalvas a serem cumpridas no momento');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0037333/2024-22';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-09-02', '2024-09-30', '2024-12-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2024-12-10', '2025-01-29', '2025-02-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 1, 'concluida', '2024-12-11', '2025-01-13', '2025-07-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2025-02-18', '2025-02-21', '2025-03-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-03-06', '2025-03-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2025-03-14', '2025-05-09', '2025-05-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 7, 1, 'concluida', '2025-07-02', '2025-07-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 8, 1, 'concluida', '2025-07-18', '2025-07-30', '2025-08-18', 'Memorando devolvendo para área com pendências na instrução processual');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 9, 2, 'concluida', '2025-08-19', '2025-08-27', '2025-09-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 10, 1, 'concluida', '2025-09-09', '2025-09-09', '2025-09-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 11, 1, 'concluida', '2025-09-09', '2025-09-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 12, 1, 'concluida', '2025-09-09', '2025-09-09', null, 'Devolvido para a CL pois o processo ainda não foi homologado');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 13, 1, 'concluida', '2025-10-30', '2025-11-03', null, 'Homologação do Pregão Eletrônico nº 1321127 - 34/2025');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 14, 2, 'concluida', '2026-02-09', '2026-02-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 15, 3, 'concluida', '2026-02-27', '2026-03-25', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 16, 2, 'em_andamento', '2026-07-10', '2026-07-16', null, null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0037713/2025-41';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 1, 1, 'concluida', '2025-04-09', '2025-04-11', '2025-04-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 2, 1, 'em_andamento', '2025-04-14', '2025-04-15', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0038457/2025-32';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-04-23', '2025-05-09', '2025-09-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2025-05-07', '2025-05-28', '2025-09-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 1, 'concluida', '2025-09-17', '2025-09-24', '2025-10-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2025-09-19', '2025-09-26', '2025-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 5, 2, 'concluida', '2025-10-02', '2025-10-08', '2025-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 6, 1, 'concluida', '2025-10-10', '2025-10-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 7, 1, 'concluida', '2025-10-10', '2025-10-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 1, 'concluida', '2025-10-20', '2025-11-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 9, 1, 'concluida', '2025-12-03', '2025-12-09', '2027-01-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 10, 2, 'concluida', '2025-12-29', '2026-12-29', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 11, 3, 'concluida', '2026-01-19', '2026-01-27', '2026-01-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 12, 1, 'concluida', '2026-01-27', '2026-01-27', null, 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 13, 4, 'concluida', '2026-01-27', '2026-02-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 14, 1, 'concluida', '2026-04-23', '2026-05-22', '2026-06-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 15, 1, 'concluida', '2026-06-03', '2026-06-11', '2026-06-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 16, 1, 'concluida', '2026-06-12', '2026-06-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 17, 1, 'concluida', '2026-06-19', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 18, 2, 'em_andamento', '2026-07-17', null, null, null);
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0041601/2026-16';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-09', '2026-04-16', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0042337/2025-32';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-06-16', '2025-07-04', '2025-10-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-10-23', '2025-10-31', '2025-11-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2025-11-06', '2025-11-13', '2025-12-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2025-12-01', '2025-12-16', '2026-01-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2026-01-16', '2026-01-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 6, 1, 'concluida', '2026-01-16', '2026-01-29', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 7, 1, 'concluida', '2026-01-29', null, '2026-05-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 8, 2, 'concluida', '2026-01-29', '2026-02-10', '2026-05-11', 'Alguns itens constantes na solicitação demandaram  uma analise mais detalhada para serem aprovados para compor o RP');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 9, 3, 'concluida', '2026-01-29', '2026-02-23', '2026-05-14', 'Processo vinculado encaminhado para solicitção de RP em 10/02/2026');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Solicita adequações - Instrução processual', 'CL', 10, 1, 'concluida', '2026-05-11', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Criação do IRP', 'CL', 11, 1, 'concluida', '2026-05-13', '2026-05-29', null, 'Enquanto a IRP está sendo elaborada, o processo foi sencaminhado para área fazer algumas adequações no TR  (140635068) (141009247)');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Criação do IRP', 'CL', 12, 2, 'concluida', '2026-05-14', '2026-05-18', '2026-05-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 13, 1, 'concluida', '2026-05-22', '2026-05-29', '2026-06-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 14, 2, 'concluida', '2026-06-02', '2026-06-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 15, 1, 'concluida', '2026-07-14', '2026-07-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 16, 1, 'concluida', '2026-07-15', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 17, 2, 'em_andamento', '2026-07-20', null, null, null);
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0042431/2026-13';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-09', '2026-04-16', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0042877/2026-96';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-09', '2026-04-16', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0043403/2025-59';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 1, 1, 'concluida', '2025-04-09', '2025-04-11', '2025-04-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 2, 1, 'em_andamento', '2025-04-14', '2025-04-15', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0044056/2026-79';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-09', '2026-04-16', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0045668/2026-11';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-13', '2026-04-16', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0046040/2026-55';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-13', '2026-04-16', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0047324/2026-16';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-04-16', null, null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0047800/2025-68';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-26', '2025-06-10', '2025-06-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2025-06-11', '2025-06-16', '2025-06-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 1, 'concluida', '2025-06-17', '2025-06-25', '2025-07-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2025-06-23', '2025-06-27', '2025-07-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 5, 1, 'concluida', '2025-07-04', '2025-07-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2025-07-07', '2025-07-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2025-07-14', '2025-08-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 2, 'concluida', '2025-08-29', '2025-09-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 9, 1, 'concluida', '2025-09-02', '2025-09-02', null, 'Elaborada minuta e devolvido para a demandante, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 10, 1, 'concluida', '2025-09-24', '2025-09-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 11, 1, 'concluida', '2025-10-03', '2025-10-06', '2025-10-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 12, 1, 'concluida', '2025-11-07', '2025-11-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 13, 1, 'em_andamento', '2026-06-09', '2026-07-16', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Análise da justificativa de preço' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0048694/2026-80';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-15', '2026-04-16', '2026-04-22', 'Análise realizada no SEI 1320.01.0129941/2025-69 e solicitação de abertura do novo processo');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2026-04-22', '2026-04-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'em_andamento', '2026-04-28', '2026-05-19', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0049427/2024-83';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-04-16', '2025-04-25', '2025-05-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-05-21', '2025-06-02', '2025-07-31', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2025-07-31', '2025-08-07', '2025-09-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 4, 1, 'concluida', '2025-09-22', '2025-09-23', '2025-11-19', 'Documento será assinado pela DCC após retorno de férias do diretor');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 5, 1, 'concluida', '2025-11-19', '2025-12-10', '2026-03-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 1, 'concluida', '2026-03-05', '2026-03-10', '2026-05-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 7, 2, 'concluida', '2026-05-18', '2026-05-25', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 1, 'em_andamento', '2026-05-26', '2026-06-17', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0051535/2025-06';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-08-18', '2025-08-29', '2025-09-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-09-23', '2025-09-30', '2025-10-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-10-14', '2025-10-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 4, 1, 'concluida', '2025-10-22', '2025-10-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 5, 1, 'concluida', '2025-12-03', '2025-12-04', '2026-02-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 6, 1, 'em_andamento', '2026-02-06', null, null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0052151/2025-58';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-08', '2025-05-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'em_andamento', '2025-05-08', '2025-05-14', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0052284/2024-59';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-04-30', '2024-05-08', '2024-05-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-05-17', '2024-05-22', '2024-05-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2024-05-17', '2024-06-07', '2024-06-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2024-06-14', '2024-07-18', '2024-09-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2024-09-10', '2024-09-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2024-12-18', '2025-04-16', '2025-04-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 2, 'concluida', '2025-04-28', '2025-07-04', '2025-07-24', 'o Processo iniciu a cotação em 12/2024 e sendo finalizado em 25/5/2025- area não concorda preços -solicita nova cotação 112019036. Devolvemos o expediente com mapa retificado para itens exclusivos em 4/7 através do Memorando 37 (115368756). Pela segunda vez a area nao validou preços e pede nova pesquisa memorando evento 118872507');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 8, 1, 'concluida', '2025-07-30', '2025-07-31', '2025-08-07', 'Pela segunda vez a area nao validou a psquisa de preços e pediu alteração da pesquisa para o item 38. Novo mapa formlizado e enviado pelo memo 119406883');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração do Edital e anexos', 'CL', 9, 1, 'concluida', '2025-08-18', '2025-08-19', '2025-12-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 10, 1, 'concluida', '2025-09-04', '2025-09-04', '2025-10-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 11, 1, 'concluida', '2025-09-05', '2025-09-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 12, 1, 'concluida', '2025-10-28', '2025-10-30', '2025-11-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 13, 1, 'concluida', '2025-11-13', '2025-12-01', '2025-12-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 14, 3, 'concluida', '2025-12-02', '2025-12-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 15, 2, 'em_andamento', '2025-12-12', '2025-12-15', null, null);
  update processos set etapa_atual = 'Alteração no mapa de preços a pedido do setor demandante' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0053328/2025-95';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-09-04', '2025-09-15', '2025-09-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-09-17', '2025-09-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-09-19', '2025-09-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual, aprovação e solicitar assinatura do ato de autorização', 'CL', 4, 1, 'concluida', '2025-09-29', '2025-10-02', '2025-10-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologação e finalização', 'CL', 5, 1, 'em_andamento', '2025-10-07', null, '2025-10-09', null);
  update processos set etapa_atual = 'Homologação e finalização' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0053418/2026-87';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-05-25', '2026-06-10', '2026-06-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-06-23', '2026-06-30', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'em_andamento', '2026-07-01', '2026-07-17', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0053537/2025-78';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-16', '2025-05-29', '2025-06-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-06-06', '2025-06-11', '2025-06-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2025-06-24', '2025-06-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2025-06-26', '2025-07-09', '2025-07-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2025-07-22', '2025-07-29', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 6, 1, 'concluida', '2025-07-29', '2025-08-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 1, 'concluida', '2025-09-05', '2025-09-11', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 8, 1, 'concluida', '2025-09-12', '2025-09-15', null, 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 9, 1, 'em_andamento', '2025-09-18', '2025-09-22', null, null);
  update processos set etapa_atual = 'Saneamento de ressalvas e preparação para homologação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0053784/2023-11';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-03-12', '2024-04-12', '2024-04-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2024-04-24', '2024-04-26', '2024-06-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2024-06-18', '2024-07-15', '2024-09-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2024-09-02', '2024-10-09', '2024-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 2, 'concluida', '2024-10-10', '2024-10-16', '2024-10-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2024-10-30', '2024-11-11', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2024-11-11', '2024-12-13', '2025-01-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 8, 1, 'concluida', '2025-01-15', '2025-01-15', '2025-01-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 9, 1, 'concluida', '2025-01-29', '2025-01-31', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 10, 1, 'concluida', '2025-01-29', '2025-01-30', '2025-04-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 11, 1, 'concluida', '2025-03-10', '2025-03-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 12, 1, 'concluida', '2025-04-01', '2025-04-04', null, 'Processo retornou para a COA com vista a adequação do mapa de preços');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 13, 1, 'concluida', '2025-04-04', '2025-05-09', '2025-05-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Sessão Pública com recurso', 'CL', 14, 1, 'concluida', '2025-04-09', '2025-04-30', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 15, 1, 'concluida', '2025-06-10', '2025-06-23', null, 'Encaminhado para a CFCO realizar a formalização de instrumento de contrato');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 16, 1, 'concluida', '2025-06-23', '2025-07-03', '2025-07-28', 'Para adequação de pendências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 17, 1, 'concluida', '2025-07-28', '2025-07-28', '2025-08-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 18, 1, 'em_andamento', '2025-08-13', '2025-08-14', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0057195/2024-61';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-05-17', '2024-06-18', '2024-06-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2024-06-24', '2024-07-15', '2024-10-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2024-10-14', '2024-11-14', '2025-01-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2025-01-21', '2025-01-24', '2025-02-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-02-12', '2025-02-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2025-02-17', '2025-04-03', '2025-04-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 7, 1, 'concluida', '2025-04-15', '2025-06-09', '2025-06-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 8, 1, 'concluida', '2025-06-26', '2025-06-27', '2025-08-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 9, 1, 'concluida', '2025-06-27', '2025-07-02', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 10, 1, 'concluida', '2025-09-11', '2025-09-15', '2025-09-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 11, 1, 'concluida', '2025-09-22', '2025-09-24', null, 'Sessão Pública marcada para dia 08/10/2025');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 12, 1, 'concluida', '2025-10-17', '2025-10-17', '2025-11-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 13, 2, 'concluida', '2025-11-19', '2025-11-24', null, 'adjudicação do objeto e homologação da contratação do Pregão Eletrônico nº 1321500 - 01/2025');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 14, 1, 'concluida', '2025-11-25', '2025-11-26', '2025-12-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 15, 1, 'em_andamento', '2025-12-03', '2025-12-10', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0057777/2026-55';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-06-16', '2026-06-30', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0057950/2025-43';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-21', '2025-05-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'em_andamento', '2025-05-21', '2025-06-02', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0064567/2026-55';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-06-09', '2026-06-22', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0064813/2026-09';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-06-09', '2026-06-23', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0065156/2026-60';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-06-23', '2026-07-07', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0065901/2025-27';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-11', '2025-06-11', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-11', '2025-06-11', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0066205/2025-64';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-05-13', '2025-05-13', '2025-05-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-05-14', '2025-05-15', '2025-05-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 3, 1, 'concluida', '2025-05-19', '2025-05-13', '2025-05-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2025-05-19', '2025-05-21', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0067214/2025-78';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-05-13', '2025-05-13', '2025-05-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 2, 1, 'concluida', '2025-05-13', '2025-05-13', '2025-05-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-05-14', '2025-05-15', '2025-05-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2025-05-19', '2025-05-21', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0069474/2024-74';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-09-06', '2024-11-22', '2024-12-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2024-12-03', '2025-01-10', '2025-01-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 3, 1, 'em_andamento', '2025-01-30', '2025-01-31', null, 'Desde 30/01/2025 não há movimentações no processo, memorando devolvendo para area demandante em 22/05/2025 e várias cobranças via Teams sem resposta.');
  update processos set etapa_atual = 'Conferência processual e elaboração de aviso e anexos' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0071200/2024-32';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-07-10', '2024-09-06', '2024-09-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2024-09-16', '2024-10-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2024-10-04', '2024-11-07', '2024-11-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2024-12-02', '2024-12-03', '2024-12-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 5, 1, 'concluida', '2024-12-19', '2024-12-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 1, 'concluida', '2024-12-19', '2024-12-19', '2024-12-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2024-12-30', '2024-12-30', '2025-01-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2025-01-06', '2025-01-07', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0072445/2025-73';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-06-13', '2025-06-26', '2025-10-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-10-09', '2025-10-16', '2025-10-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-pesquisa de preços', 'CAP', 3, 1, 'concluida', '2025-10-17', '2025-10-20', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 4, 1, 'concluida', '2025-10-22', '2025-12-29', null, 'Primeira cotação desse processo. Objeto Difícil foram obtidas 4 cotações após muito contatos com os fornecedores, por isso prazo estendido da cotação. Após a feitura da pesquisa, area não validou o mapa (130925014) e mudou a proposta');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 5, 1, 'concluida', '2026-01-12', '2026-01-20', null, 'Após invalidar preços do mapa área mudou objeto e solicita nova cotação (131404477)');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 2, 'concluida', '2026-01-27', '2026-02-25', null, 'Tentativa de nova pesquisa de preços novo TR 131545290. Em 12/2 após questionamentos dos fornecedores, durante a terceira tentativa de cotação o setor demandante alterou o modelo de proposta e o objeto do TR. Solicitaram via teams prazo de 15 dias para a definição');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 7, 2, 'concluida', '2026-04-01', '2026-05-08', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 8, 1, 'concluida', '2026-05-27', '2026-06-03', null, 'No dia 03/06, o SEI está inoperante, a análise foi enviada via chat da contratação no Teams e o SEI formalizando foi elaborado posteriormente');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 9, 1, 'concluida', '2026-06-17', '2026-06-18', null, 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 10, 1, 'em_andamento', '2026-07-10', '2026-07-20', null, null);
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0072551/2026-21';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 1, 1, 'em_andamento', '2026-06-03', '2026-06-08', null, null);
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0072755/2025-45';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-26', '2025-06-04', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-pesquisa de preços', 'CAP', 2, 1, 'concluida', '2025-06-10', '2025-06-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2025-06-13', '2025-06-18', null, 'Devido a urgencia da renovação contrataual Lucas Diretor de Patrimonio realizou a pesquisa e seguiu com contratação direta. Coa iniciou com pesquisa em Bancos de preços, abriu coleta e recebeu apenas 02 preços de fornecedores mas não teve prazo hábil pra realizar  apesquisa de preços.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-06-18', '2025-06-23', '2025-06-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 5, 1, 'concluida', '2025-06-27', '2025-06-30', '2025-07-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 1, 'concluida', '2025-07-11', '2025-07-17', null, 'Envio do memorando solicitando a formalização de instrumento de contrato para contratação direta');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 7, 1, 'concluida', '2025-07-17', '2025-07-21', '2025-07-22', 'Solicitado cadastro de representante legal no SEI');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 8, 1, 'concluida', '2025-07-21', '2025-07-28', '2025-07-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 9, 1, 'concluida', '2025-07-28', '2025-07-28', '2025-08-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 10, 1, 'em_andamento', '2025-08-10', '2025-08-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0074610/2024-15';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-07-17', '2024-08-13', '2024-09-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-09-19', '2024-10-02', '2024-11-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2024-11-11', '2024-11-14', '2025-01-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2025-01-03', '2025-01-29', '2025-02-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'em_andamento', '2025-02-25', '2025-03-12', '2025-04-16', null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0075146/2023-96';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2023-05-22', '2023-05-29', '2024-01-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-01-22', '2024-01-30', '2024-02-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2024-02-20', '2024-03-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2024-02-20', '2024-03-12', '2025-02-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 5, 1, 'concluida', '2024-07-03', '2024-07-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 1, 'concluida', '2025-02-04', '2025-02-10', '2025-05-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 7, 2, 'em_andamento', '2025-05-13', '2025-05-23', null, null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0075617/2025-80';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-06-24', '2025-07-11', '2025-08-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'em_andamento', '2025-08-29', '2025-09-03', null, null);
  update processos set etapa_atual = 'ETP conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0075816/2025-42';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-29', '2025-07-31', '2025-08-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-08-06', '2025-08-08', '2025-08-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-08-12', '2025-08-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 4, 1, 'concluida', '2025-08-13', '2025-08-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 5, 1, 'concluida', '2025-09-05', '2025-09-08', null, 'Elaborada minuta e devolvido para a CL. Demandante inseriu nota informando que não dará prosseguimento à contratação.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 1, 'concluida', '2025-09-23', '2025-09-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 7, 1, 'em_andamento', '2025-09-24', '2025-09-25', null, 'Conforme  nota de encerramento 125360314 area não prosseguirá com o processo');
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0076527/2026-48';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-06-30', '2026-07-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'em_andamento', '2026-07-14', '2026-07-22', null, null);
  update processos set etapa_atual = 'Análise da justificativa de preço' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0077510/2026-85';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 1, 1, 'concluida', '2026-06-18', '2026-07-07', null, 'Mapa validado pela área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2026-06-18', '2026-06-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 3, 1, 'em_andamento', '2026-07-17', '2026-07-20', null, 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0077940/2025-21';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-07-04', '2025-07-08', '2025-07-17', 'Devolvido para área demandante informando que a empresa está inscrita no CADIN - para providências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-07-17', '2025-07-18', '2025-07-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-07-28', '2025-07-29', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0078070/2025-03';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0080933/2025-11';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'em_andamento', '2025-06-24', '2025-06-30', null, 'Elaborada minuta de COTEP, devolvido para a demandante');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0083451/2026-19';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'em_andamento', '2026-06-25', '2026-07-02', null, 'Adesão concluída.Devolvido para área demandante');
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0084020/2025-82';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-06-12', '2025-06-25', '2025-07-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-07-03', '2025-07-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2025-07-08', '2025-07-24', '2025-08-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 4, 1, 'em_andamento', '2025-08-09', '2025-08-11', null, 'Comunicado via grupo do Teams que o processo será cancelado');
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0085725/2025-25';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0085751/2025-02';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0085858/2025-23';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0086212/2025-68';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0086877/2025-58';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0088599/2025-27';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0088600/2025-97';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0089459/2024-90';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-09-20', '2024-10-15', '2024-11-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2024-10-07', '2024-10-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 3, 1, 'concluida', '2024-10-11', '2025-10-17', '2024-11-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 4, 1, 'concluida', '2024-11-25', '2024-12-02', '2024-12-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2024-12-02', '2024-12-13', '2024-12-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2024-12-18', '2025-01-06', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 7, 2, 'concluida', '2024-12-20', '2024-12-26', '2025-01-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 1, 'concluida', '2025-01-06', '2025-02-14', '2025-02-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 9, 3, 'concluida', '2025-01-15', '2025-01-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 10, 1, 'concluida', '2025-03-07', '2025-03-10', '2025-08-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 11, 1, 'concluida', '2025-03-10', '2025-03-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 12, 4, 'concluida', '2025-07-25', '2025-07-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 13, 2, 'concluida', '2025-07-25', '2025-07-29', '2025-08-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 14, 1, 'concluida', '2025-09-09', '2025-09-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 15, 1, 'em_andamento', '2025-09-30', '2025-10-02', null, null);
  update processos set etapa_atual = 'Alteração no mapa de preços a pedido do setor demandante' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0090197/2025-46';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 1, 1, 'concluida', '2025-06-05', '2025-06-09', '2025-06-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-06-11', '2025-06-12', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0090942/2024-13';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-07-26', '2024-08-29', '2024-11-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2024-11-25', '2024-12-19', '2025-01-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 3, 1, 'concluida', '2025-01-31', '2025-02-03', '2025-02-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Aprovação e divulgação', 'CL', 4, 1, 'em_andamento', '2025-02-12', '2025-04-04', null, null);
  update processos set etapa_atual = 'Aprovação e divulgação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0091836/2024-28';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-07-01', '2024-07-12', '2024-07-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-07-18', '2024-07-22', '2024-07-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2024-07-22', '2024-07-23', '2024-07-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2024-07-26', '2024-08-05', '2024-08-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 5, 1, 'concluida', '2024-07-26', '2024-08-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 6, 1, 'concluida', '2024-08-07', null, '2025-01-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 7, 1, 'concluida', '2024-08-14', '2024-08-20', '2024-08-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 8, 1, 'concluida', '2024-08-23', '2024-08-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 9, 1, 'concluida', '2024-08-26', '2024-10-15', '2024-10-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 10, 1, 'concluida', '2024-11-08', '2024-11-13', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 11, 1, 'concluida', '2025-01-14', '2025-01-15', null, 'Resposta a pedido de esclarecimento da empresa RS COMÉRCIO E PRESTAÇÃO DE SERVIÇOS DE APOIO LTDA');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 12, 1, 'concluida', '2025-01-17', '2025-01-17', '2025-03-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 13, 1, 'em_andamento', '2025-03-07', '2025-03-07', null, null);
  update processos set etapa_atual = 'Encerramento e Adjudicação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0092066/2025-23';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-07-17', null, null, null);
  update processos set etapa_atual = 'ETP 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0093135/2025-66';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2025-06-13', '2025-06-18', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0093583/2025-95';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-01', '2025-07-04', '2025-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-10-10', '2025-10-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-10-17', '2025-10-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 4, 1, 'concluida', '2025-12-15', '2025-12-17', '2026-01-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 5, 1, 'concluida', '2026-01-19', '2026-01-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 6, 2, 'concluida', '2026-01-20', '2026-01-21', '2026-02-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 7, 1, 'concluida', '2026-01-21', '2026-01-22', '2026-04-23', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 8, 3, 'concluida', '2026-02-06', '2026-02-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 9, 1, 'concluida', '2026-04-17', '2026-04-23', '2026-04-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 10, 2, 'concluida', '2026-04-24', '2026-04-23', '2026-05-27', 'Feito saneamento da minuta, devolvido para CL, aguardando novo retorno.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 11, 1, 'concluida', '2026-04-24', '2026-05-04', '2026-05-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 12, 2, 'concluida', '2026-05-19', '2026-05-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 13, 1, 'concluida', '2026-05-27', '2026-05-28', '2026-07-08', 'Pendente CPF da representante legal, solicitado à demandante pelo teams, aguardando');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 14, 1, 'concluida', '2026-07-08', '2026-07-08', '2026-07-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 15, 1, 'em_andamento', '2026-07-16', '2026-07-17', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0095544/2025-13';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 1, 1, 'concluida', '2025-06-30', '2025-07-22', null, 'Finalização da Pesquisa de preços pela COA em 22/7 Paula CAE assina o documento');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CAP', 2, 1, 'concluida', '2025-07-21', '2025-08-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 3, 1, 'concluida', '2025-08-11', '2025-08-12', '2025-08-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 4, 1, 'concluida', '2025-08-12', null, '2025-08-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 5, 2, 'em_andamento', '2025-08-19', '2025-08-19', null, 'Homologação de inexigibilidade de licitação');
  update processos set etapa_atual = 'Saneamento de ressalvas e preparação para homologação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0097822/2025-05';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'em_andamento', '2025-08-01', '2025-08-01', null, 'Elaborada minuta de COTEP, devolvido para a demandante');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0099731/2025-66';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-07', '2025-07-10', '2025-07-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-07-10', '2025-07-11', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2025-07-14', '2025-07-30', '2025-08-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 4, 1, 'concluida', '2025-08-05', '2025-08-06', '2025-08-07', 'Pendências solicitadas no Memorando 302 (119703240)');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 5, 2, 'concluida', '2025-08-07', '2025-08-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Aprovação e divulgação', 'CL', 6, 1, 'concluida', '2025-08-12', '2025-08-18', '2025-08-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologar e finalizar', 'CL', 7, 1, 'em_andamento', '2025-08-25', '2025-08-27', '2025-08-27', null);
  update processos set etapa_atual = 'Homologar e finalizar' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0100393/2024-43';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-10-16', '2024-12-17', '2025-02-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2024-10-16', '2024-12-17', '2025-03-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 1, 'concluida', '2025-02-27', '2025-03-11', '2025-03-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 4, 1, 'concluida', '2025-03-07', '2025-03-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 5, 1, 'concluida', '2025-03-14', '2025-03-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'em_andamento', '2025-03-17', '2025-04-08', '2025-04-09', 'Desistência do setor demandante - cotação interrompida');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0102933/2022-48';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2023-05-30', '2023-06-07', '2023-06-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2023-06-30', '2023-07-05', '2023-08-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2023-08-11', '2023-08-23', '2024-01-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 4, 1, 'concluida', '2024-01-30', '2024-01-30', '2024-04-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 5, 1, 'concluida', '2024-04-11', '2024-04-25', '2024-06-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 1, 'concluida', '2024-06-19', '2024-07-23', '2024-09-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 7, 2, 'concluida', '2024-09-17', '2024-10-22', '2024-12-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 8, 3, 'concluida', '2024-12-12', '2024-12-19', '2024-12-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 9, 1, 'concluida', '2024-12-23', '2024-12-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 10, 1, 'concluida', '2024-12-26', '2025-01-22', null, 'Processo devolvido para saneamento de problemas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 11, 1, 'concluida', '2025-03-27', '2025-03-31', '2025-04-15', 'Devolve SEI grafica para atualizar TR nos termos da audiencia Publica- terceirização Gráfica');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 12, 2, 'concluida', '2025-04-15', '2025-06-04', '2025-06-09', 'Processo devolvido para a área demandante para adequação do TR');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 13, 3, 'concluida', '2025-06-09', '2025-06-11', '2025-06-12', 'Validação do mapa de preços');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 14, 1, 'concluida', '2025-06-12', '2025-06-16', '2025-07-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'None', 'CL', 15, 1, 'concluida', '2025-07-02', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 16, 1, 'concluida', '2025-07-03', '2025-07-11', '2025-07-17', 'AJ devolveu sem analise jurídica pois a minuta do contrato estava desatualizado');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 17, 2, 'concluida', '2025-07-17', '2025-07-18', '2025-07-31', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 18, 1, 'concluida', '2025-08-01', '2025-08-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 19, 1, 'concluida', '2025-08-01', '2025-08-04', '2025-08-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 20, 2, 'concluida', '2025-08-01', '2025-08-04', '2025-08-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 21, 1, 'concluida', '2025-08-19', '2025-08-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 22, 2, 'concluida', '2025-09-12', '2025-09-18', '2025-10-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 23, 1, 'concluida', '2026-02-02', '2026-02-02', '2026-02-04', 'Devolvido solicitando adequações e esclarecimentos da área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 24, 1, 'concluida', '2026-02-04', '2026-02-04', '2026-02-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 25, 1, 'em_andamento', '2026-02-09', '2026-02-10', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0103745/2025-37';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-21', '2025-07-30', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'em_andamento', '2025-07-22', '2025-07-23', '2025-07-29', 'Após análise da inex com uregencia em 2 dias úteis setor demandante informa que não prosseguirá com o sei');
  update processos set etapa_atual = 'Análise da justificativa de preço' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0104568/2025-29';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-22', '2025-07-29', '2025-08-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-08-27', '2025-09-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 3, 1, 'concluida', '2025-09-09', '2025-09-09', '2025-10-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 4, 1, 'em_andamento', '2025-10-23', '2025-10-30', null, 'Conclusão de processo de inexigibilidade nº 1321127  Em 30/10/2025');
  update processos set etapa_atual = 'Saneamento de ressalvas e preparação para homologação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0106616/2024-26';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-12-03', '2025-01-29', '2025-02-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2025-02-17', '2025-03-31', '2025-04-11', 'Teto valor permitido pela COTEP ultrapassado - evento Memorando 21 (110440124)');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 2, 'em_andamento', '2025-04-14', '2025-04-30', null, 'devolução do processo que ultrapassa o limite da cotep Memorando 25 (112478975)');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0106811/2025-93';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-17', '2025-07-28', '2025-08-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-08-13', '2025-08-21', '2025-08-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2025-08-22', '2025-08-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 4, 1, 'concluida', '2025-08-27', '2025-09-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 5, 1, 'concluida', '2025-10-23', '2025-10-24', '2025-11-11', 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 6, 1, 'concluida', '2025-10-23', '2025-10-28', '2025-11-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e homologação', 'CL', 7, 1, 'concluida', '2025-11-04', '2025-11-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 8, 1, 'concluida', '2025-11-11', '2025-11-12', '2025-11-13', 'Solicitados esclarecimentos pela área demandante sobre alguns pontos da minuta que não haviam sido preenchidos');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 9, 2, 'concluida', '2025-11-13', '2025-11-13', '2025-11-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 10, 1, 'em_andamento', '2025-11-13', '2025-11-14', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0107760/2025-78';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-25', '2025-08-12', '2025-09-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-09-03', '2025-09-10', '2025-10-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-pesquisa de preços', 'CAP', 3, 1, 'concluida', '2025-10-17', '2025-10-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 4, 1, 'concluida', '2025-10-29', '2025-11-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 5, 1, 'concluida', '2025-12-15', '2025-12-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 6, 1, 'concluida', '2025-12-22', '2026-01-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 7, 1, 'concluida', '2026-01-06', '2026-01-06', '2026-07-21', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 8, 1, 'concluida', '2026-01-06', '2026-01-06', '2026-01-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 9, 1, 'concluida', '2026-01-12', '2026-01-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 10, 2, 'concluida', '2026-01-12', '2026-01-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 11, 2, 'concluida', '2026-03-19', '2026-03-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 12, 2, 'concluida', '2026-04-09', '2026-04-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 13, 1, 'concluida', '2026-06-17', '2026-06-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 14, 2, 'concluida', '2026-06-24', '2026-07-10', null, 'Mapa validado pela área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 15, 2, 'em_andamento', '2026-07-21', '2026-07-21', null, 'Elaborada nova minuta, devolvido para a CL, aguardando retorno');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0110255/2025-31';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2025-07-22', '2025-07-25', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0110553/2023-42';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2023-07-17', '2023-08-08', '2023-09-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2023-09-19', '2023-10-23', '2023-12-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2023-12-05', '2023-12-11', '2024-01-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2023-12-05', '2023-12-29', '2024-01-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 5, 1, 'concluida', '2024-01-09', '2024-01-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 6, 1, 'concluida', '2024-01-11', '2025-01-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 7, 2, 'concluida', '2024-02-26', '2024-02-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 8, 1, 'concluida', '2024-03-22', '2024-03-22', '2024-04-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 9, 1, 'concluida', '2024-04-08', '2024-05-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 10, 1, 'concluida', '2024-06-18', '2024-06-27', '2024-06-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 11, 1, 'concluida', '2024-06-20', '2024-07-02', '2024-07-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 12, 1, 'concluida', '2024-07-23', '2024-07-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 13, 1, 'concluida', '2024-09-06', '2024-09-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 14, 1, 'em_andamento', '2025-07-23', '2025-07-26', null, null);
  update processos set etapa_atual = 'Saneamento de ressalvas e finalização do edital' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0111467/2025-93';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-11-07', '2025-11-10', '2025-11-11', 'Devolvido para a demandante se manifestar sobre inscrição da empresa no TCU');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2025-11-11', '2025-11-12', '2025-11-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2025-11-14', '2025-11-18', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0113325/2024-79';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2025-11-05', '2025-11-05', '2025-12-17', 'Elaborada minuta e devolvido para a Regional, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 2, 1, 'concluida', '2025-12-17', '2025-12-18', '2025-12-23', 'Para conferência pela SILC');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-12-23', '2025-12-30', '2026-01-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2026-01-07', '2026-01-19', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0114348/2020-18';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 1, 1, 'em_andamento', '2026-01-12', '2026-01-13', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0115328/2025-24';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-08-04', '2025-08-19', '2025-08-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-08-22', '2025-09-05', '2025-09-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 3, 1, 'concluida', '2025-08-22', '2025-08-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 4, 1, 'concluida', '2025-08-25', '2025-08-28', '2025-09-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 2, 'concluida', '2025-09-08', '2025-09-12', '2025-11-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 6, 1, 'concluida', '2025-11-05', '2025-11-10', '2025-12-02', 'Adequação do termo de referência após adesões ao Planejamento');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 7, 2, 'concluida', '2025-11-17', '2025-11-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 8, 3, 'concluida', '2025-11-17', '2025-11-26', '2025-12-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 9, 3, 'concluida', '2025-11-24', '2025-12-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 10, 4, 'concluida', '2025-12-22', '2026-01-06', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 11, 1, 'concluida', '2026-01-06', '2026-02-25', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 12, 4, 'concluida', '2026-02-27', '2026-03-20', '2026-04-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 13, 1, 'concluida', '2026-04-01', '2026-04-07', '2026-04-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 14, 1, 'concluida', '2026-04-16', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração do Edital e anexos', 'CL', 15, 1, 'concluida', '2026-04-23', '2026-05-05', '2026-05-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 16, 1, 'concluida', '2026-05-05', '2026-05-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 17, 1, 'concluida', '2026-05-06', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 18, 1, 'em_andamento', '2026-05-22', '2026-05-25', null, 'Ajuste no mapa comparativo de preço');
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0115877/2025-42';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2025-07-22', '2025-07-24', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0116424/2025-17';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2025-10-01', '2025-10-13', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0116517/2024-31';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-08-22', '2024-09-18', '2025-07-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 2, 'concluida', '2025-07-24', '2025-08-07', '2025-09-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 1, 'concluida', '2025-09-10', '2025-09-17', '2025-09-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 4, 1, 'concluida', '2025-09-18', '2025-09-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 5, 1, 'concluida', '2025-09-19', '2025-10-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 6, 1, 'em_andamento', '2025-10-06', '2025-10-06', null, null);
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0118143/2025-67';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-09-02', '2025-09-04', '2025-09-10', 'Devolvido para a Regional sanar pendências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 2, 1, 'concluida', '2025-09-09', '2025-09-09', '2025-09-15', 'Para conferência pela SILC');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-09-15', '2025-09-16', '2026-01-15', 'Devolvido após publicação da Resolução 10.890/26 que delega a competência para a assinatura aos dirigentes regionais');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 4, 2, 'concluida', '2026-01-15', '2026-01-15', null, 'Disponibilizado novamente para assinaturas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 5, 1, 'em_andamento', '2026-01-19', '2026-01-20', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0118764/2025-81';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-07-25', '2025-08-06', '2025-09-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-09-10', '2025-09-17', '2025-09-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2025-09-22', '2025-09-24', '2026-01-21', 'Documento será assinado pela DCC após retorno de férias do diretor');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2026-01-21', '2026-02-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 5, 1, 'concluida', '2026-01-22', '2026-01-24', '2026-02-01', 'Processo atualmente restrito');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 6, 3, 'concluida', '2026-02-04', '2026-02-05', '2026-02-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 7, 1, 'concluida', '2026-02-27', '2026-03-06', '2026-03-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 8, 1, 'concluida', '2026-03-06', '2026-03-13', '2026-04-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 9, 2, 'concluida', '2026-04-27', '2026-05-05', '2026-05-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 10, 3, 'concluida', '2026-05-28', '2026-06-08', '2026-06-09', 'Ressalvas acerca do processo foram encaminhas para o setor demanda via chat da contratação. Aguardando envio do modelo de proposta comercial para envio do processo para pesquisa de preços.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 11, 1, 'concluida', '2026-06-09', '2026-06-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 12, 1, 'em_andamento', '2026-06-11', '2026-07-07', null, 'Mapa validado pela área demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0119098/2025-84';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-08-01', '2025-08-08', '2025-08-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-08-29', '2025-09-04', '2025-09-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2025-09-11', '2025-09-23', '2025-12-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 4, 1, 'concluida', '2025-09-19', '2025-09-22', '2025-10-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 5, 1, 'concluida', '2025-10-03', '2026-10-17', '2025-10-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 6, 1, 'concluida', '2025-10-22', '2025-10-22', '2025-12-02', 'Processo emcaminhado para SUBVS /SVE');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 7, 2, 'concluida', '2025-12-03', '2025-12-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 8, 2, 'concluida', '2025-12-03', '2025-12-04', '2026-01-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 9, 1, 'concluida', '2025-12-23', '2026-01-07', '2026-01-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 10, 3, 'concluida', '2026-01-13', '2026-01-27', '2026-01-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 11, 4, 'concluida', '2026-01-28', '2026-01-30', '2026-05-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 12, 1, 'concluida', '2026-01-29', '2026-02-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 13, 1, 'concluida', '2026-02-06', '2026-03-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 14, 5, 'em_andamento', '2026-05-21', '2026-05-29', null, null);
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0119554/2025-91';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-08-18', '2025-09-08', '2025-10-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-10-08', '2025-10-15', '2025-12-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 3, 1, 'concluida', '2025-10-08', '2025-10-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 4, 1, 'concluida', '2025-11-13', '2025-11-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-12-09', '2025-12-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2025-12-17', '2026-01-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 2, 'concluida', '2026-04-01', '2026-04-15', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 8, 1, 'concluida', '2026-05-14', '2026-05-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 9, 1, 'em_andamento', '2026-06-03', '2026-06-19', null, null);
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0119716/2023-88';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 1, 1, 'concluida', '2023-08-07', '2023-10-23', null, 'Cotação pausada por disparidade de preços');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 2, 'concluida', '2023-11-10', '2023-12-13', null, 'Não se constatou o documento de ciência da área demandante no referido processo SEI');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 3, 1, 'concluida', '2023-12-26', '2023-12-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 4, 3, 'concluida', '2025-02-17', '2025-02-20', null, 'APOIO AO SETOR DEMANDANTE PESQUISA DE PREÇO RENOVAÇÃO DE CONTRATO, entrega de orçamentos em chat via teams para Vanessa e e-mail');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'None', 'CL', 5, 1, 'em_andamento', null, null, null, null);

  select id into v_pid from processos where num_sei = '1320.01.0121317/2024-23';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-10-14', '2025-02-17', '2025-03-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'em_andamento', '2025-03-14', '2025-03-28', '2025-04-30', 'Desistência do setor demandante - cotação interrompida');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0122898/2024-16';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-08-22', '2024-09-11', '2024-09-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-09-23', '2024-12-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 3, 1, 'concluida', '2024-10-04', '2024-11-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2024-10-04', '2024-12-16', '2024-12-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2024-12-20', '2024-12-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2024-12-23', '2025-02-21', '2025-02-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 7, 1, 'concluida', '2025-02-25', '2025-03-06', '2025-03-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 8, 1, 'concluida', '2025-04-04', '2025-04-07', '2025-05-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 9, 1, 'concluida', '2025-04-07', '2025-04-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 10, 1, 'concluida', '2025-07-10', '2025-07-16', '2025-07-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 11, 2, 'concluida', '2025-07-17', '2025-07-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 12, 2, 'concluida', '2025-07-30', '2025-08-04', '2025-08-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração do Edital e anexos', 'CL', 13, 1, 'concluida', '2025-08-06', '2025-08-08', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 14, 2, 'concluida', '2025-08-21', '2025-08-21', '2025-12-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 15, 2, 'em_andamento', '2025-08-26', '2025-08-28', null, null);
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0125635/2025-28';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-05-14', '2026-05-28', null, null);
  update processos set etapa_atual = 'ETP 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0128786/2025-20';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2025-12-05', '2025-12-09', '2026-02-10', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2026-02-10', '2026-02-11', '2026-02-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2026-02-12', '2026-02-13', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0129941/2025-69';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-01-19', '2026-01-30', '2026-02-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-02-11', '2026-02-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'em_andamento', '2026-02-19', '2026-03-05', null, null);
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0130532/2025-20';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-09-22', '2025-10-03', '2025-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-10-10', '2025-10-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-10-16', '2025-10-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual, aprovação e solicitar assinatura do ato de autorização', 'CL', 4, 1, 'concluida', '2025-11-04', '2025-11-05', '2025-11-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 5, 1, 'em_andamento', '2025-11-07', '2025-11-07', null, 'Conclusão de contratação via inexigibilidade de licitação.');
  update processos set etapa_atual = 'Saneamento de ressalvas e preparação para homologação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0130532/2025-21';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologação e finalização', 'CL', 1, 1, 'em_andamento', '2025-11-06', '2025-11-06', '2025-11-07', null);
  update processos set etapa_atual = 'Homologação e finalização' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0130727/2025-90';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-08-22', '2025-08-28', '2025-09-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-09-11', '2025-09-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'concluida', '2025-09-15', '2025-09-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual, aprovação e solicitar assinatura do ato de autorização', 'CL', 4, 1, 'concluida', '2025-09-15', '2025-09-17', '2025-09-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologação e finalização', 'CL', 5, 1, 'em_andamento', '2025-09-17', '2025-09-17', '2025-09-17', null);
  update processos set etapa_atual = 'Homologação e finalização' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0134440/2025-40';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-09-09', '2025-09-19', '2025-11-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-11-11', '2025-11-17', '2025-11-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2025-11-18', '2025-11-18', '2025-11-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 4, 1, 'concluida', '2025-11-19', '2025-11-26', '2025-12-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 5, 1, 'concluida', '2025-12-18', '2026-01-08', '2026-01-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 1, 'concluida', '2026-01-29', '2026-02-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 7, 1, 'concluida', '2026-01-29', '2026-02-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 8, 1, 'concluida', '2026-02-06', '2026-02-12', '2026-05-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Termo de adesão e Consolidação das Adesões', 'CL', 9, 1, 'concluida', '2026-06-02', '2026-06-09', null, 'Encaminhado para área atualir o TR');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 10, 1, 'concluida', '2026-07-03', '2026-07-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 11, 1, 'em_andamento', '2026-07-10', null, null, null);
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0136398/2025-39';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-08-27', '2025-08-29', '2025-09-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-09-12', '2025-09-15', '2025-10-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2025-09-18', '2025-09-25', '2025-10-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 4, 1, 'concluida', '2025-10-02', '2025-10-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-10-02', '2025-10-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 6, 1, 'concluida', '2025-10-10', '2025-10-13', null, 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 1, 'concluida', '2025-10-10', '2025-10-10', '2025-10-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 8, 2, 'concluida', '2025-10-31', '2025-10-31', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 9, 1, 'concluida', '2025-11-13', '2025-11-13', '2026-02-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 10, 1, 'concluida', '2026-02-04', '2026-03-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 11, 2, 'concluida', '2026-03-17', '2026-04-06', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 12, 3, 'concluida', '2026-04-08', '2026-04-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 13, 1, 'em_andamento', '2026-06-25', '2026-06-25', null, 'Enviado para a demandante sanear pendências para a assinatura do contrato');
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0138105/2024-28';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-12-27', '2025-01-27', '2025-02-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-02-25', '2025-03-12', '2025-04-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2025-02-25', '2025-03-18', '2025-04-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 4, 2, 'concluida', '2025-04-23', '2025-04-28', '2025-05-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2025-04-23', '2025-05-12', '2025-09-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 6, 3, 'concluida', '2025-05-20', '2025-05-23', '2025-07-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 7, 4, 'concluida', '2025-07-03', '2025-07-08', '2025-07-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 8, 1, 'concluida', '2025-07-16', '2025-07-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 9, 2, 'concluida', '2025-09-02', '2025-09-09', '2025-09-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 10, 3, 'concluida', '2025-09-24', '2025-10-01', '2025-10-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 11, 4, 'concluida', '2025-10-10', '2025-10-15', '2025-10-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 12, 1, 'concluida', '2025-10-15', '2025-10-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 13, 1, 'concluida', '2025-10-17', '2025-11-25', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 14, 1, 'concluida', '2025-12-16', '2025-12-17', '2025-01-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 15, 1, 'concluida', '2025-12-18', '2025-12-18', null, 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 16, 1, 'concluida', '2026-01-15', '2026-01-27', '2026-02-20', 'Cancelado no PC');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 17, 1, 'em_andamento', '2026-02-13', '2026-02-13', null, null);
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0138158/2025-49';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 1, 1, 'concluida', '2025-12-23', '2025-12-30', '2025-12-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 2, 1, 'concluida', '2025-12-30', '2026-01-09', '2026-01-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 3, 1, 'concluida', '2025-12-30', '2025-12-30', '2026-03-12', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 4, 2, 'concluida', '2026-01-13', '2026-01-28', '2026-02-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 'CL', 5, 3, 'concluida', '2026-02-09', '2026-01-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 6, 1, 'concluida', '2026-03-12', '2026-03-13', '2026-03-20', 'Devolvido pela demandante solicitando alteração dos representantes legais');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 2, 'concluida', '2026-03-20', '2026-03-20', '2026-03-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2026-03-23', '2026-03-26', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0138911/2024-91';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-09-16', '2024-10-18', '2024-12-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2024-12-06', '2024-12-26', '2025-02-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2025-02-07', '2025-03-14', '2025-04-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2025-04-03', '2025-04-11', '2025-04-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 2, 'concluida', '2025-04-29', '2025-05-07', '2025-05-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2025-05-15', '2025-05-19', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2025-05-19', '2025-06-09', '2025-06-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 8, 1, 'concluida', '2025-06-23', '2025-06-26', '2025-07-09', 'Adequação do Mapa de Preço');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 9, 1, 'concluida', '2025-07-09', '2025-07-10', null, 'Area alterou TR após pesquisa de preços. Confirmação dos orçamentos junto aos fornecedores no 117920531. Preços mantidos.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 10, 1, 'concluida', '2025-07-11', '2025-07-18', '2025-07-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 11, 2, 'concluida', '2025-07-30', '2025-08-07', '2025-08-26', 'Área demandante realizou audiência pública dia 07/08/2025 e está analisando alteração no TR');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 12, 3, 'concluida', '2025-08-26', '2025-08-27', '2025-10-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 13, 1, 'concluida', '2025-10-23', '2025-10-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 14, 2, 'concluida', '2025-10-23', '2025-10-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 15, 1, 'concluida', '2025-10-24', '2025-10-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 16, 1, 'concluida', '2025-11-06', '2025-11-07', '2025-11-10', 'Devolvido para área demandante solicitando informações para preenchimento da minuta');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 17, 1, 'concluida', '2025-11-06', '2025-11-06', '2025-11-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 18, 2, 'concluida', '2025-11-10', '2025-11-11', '2026-03-20', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 19, 1, 'concluida', '2026-03-20', '2026-03-20', '2026-03-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 20, 1, 'em_andamento', '2026-03-20', '2026-03-23', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0139090/2025-08';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-01-08', '2026-01-15', null, null);
  update processos set etapa_atual = 'ETP 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0139196/2024-59';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-09', '2025-05-20', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-05-21', '2025-05-30', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-06-05', '2025-06-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 4, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 5, 2, 'concluida', '2025-06-18', '2025-06-18', '2025-07-08', 'Para cumprimento de ressalvas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 1, 'concluida', '2025-07-11', '2025-07-16', '2025-07-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2025-07-17', '2025-07-21', '2025-07-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 8, 1, 'concluida', '2025-07-17', '2025-07-17', null, 'Formalização de instrumento de contrato para contratação direta.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 9, 1, 'em_andamento', '2025-07-21', '2025-07-22', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0142469/2025-52';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-09-09', '2025-09-16', '2025-09-24', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2025-09-24', '2025-09-25', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 3, 1, 'concluida', '2025-09-25', '2025-10-22', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 4, 1, 'concluida', '2025-10-06', '2025-10-06', null, 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologar e finalizar', 'CL', 5, 1, 'em_andamento', '2025-10-30', '2025-10-31', null, null);
  update processos set etapa_atual = 'Homologar e finalizar' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0142536/2023-92';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2023-11-20', '2023-12-06', '2023-12-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2023-12-20', '2024-01-02', '2024-01-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2024-01-15', '2024-01-22', '2024-05-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 4, 1, 'concluida', '2024-02-19', '2024-02-22', null, 'Divulgação da Audiência Pública');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 5, 1, 'concluida', '2024-05-15', '2024-05-20', '2024-05-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2024-05-22', '2024-05-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2024-05-23', '2024-12-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 8, 1, 'concluida', '2025-01-23', '2025-01-27', '2025-02-19', 'confecção novo mapa de preços apos analise da area');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 9, 1, 'concluida', '2025-02-19', '2025-02-19', '2025-02-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 10, 1, 'concluida', '2025-02-19', '2025-02-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 11, 1, 'concluida', '2025-02-19', '2025-02-19', '2025-02-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 12, 2, 'concluida', '2025-02-19', '2025-02-19', '2025-03-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 13, 1, 'concluida', '2025-03-28', '2025-04-03', '2025-04-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 14, 1, 'concluida', '2025-04-07', '2025-04-10', '2025-08-04', 'Sessão Pública do dia 10/04/2025 (primeira publicação) até o dia 04/08/2025 (Termo de conclusão do procedimento)');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 15, 3, 'concluida', '2025-04-22', '2025-04-23', '2025-05-28', 'Aguardando definição da area demandante sobre continuidade do processo. Processo paralizado.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 16, 4, 'concluida', '2025-04-23', '2025-04-23', '2025-05-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 17, 1, 'concluida', '2025-08-04', '2025-08-04', '2025-08-04', 'Pregão homologado em 04/08/2025');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 18, 1, 'concluida', '2025-08-05', '2025-08-06', '2025-08-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 19, 1, 'em_andamento', '2025-08-07', '2025-08-08', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0143286/2025-12';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2025-11-03', '2025-11-03', '2025-12-18', 'Elaborada minuta, devolvido para a Regional');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 2, 1, 'concluida', '2025-12-18', '2025-12-19', '2025-12-19', 'Devolvido para a Regional sanar pendências no Portal de Compras');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-12-19', '2026-01-28', null, 'Ficou aguardando sair a nova resolução de competências, para disponibilizar para assinaturas somente pela Regional');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2026-01-28', '2026-02-02', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0144621/2021-63';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2022-01-07', '2022-01-20', '2022-04-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CAP', 2, 1, 'concluida', '2022-04-05', '2022-04-19', '2023-09-15', 'Processo retornou para a área demandante em razão da publicação da resoluão que previa elaboração do ETP');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 3, 1, 'concluida', '2023-09-15', '2023-09-22', '2024-04-23', 'CAP elaborou ETP');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2024-04-23', '2024-05-17', '2024-06-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2024-06-07', '2024-07-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2024-07-18', '2024-09-02', '2025-04-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 7, 1, 'concluida', '2025-04-11', '2025-05-16', '2025-05-20', 'Devolvido o processo para adequação da Minuta de Termo de Referência');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 8, 1, 'concluida', '2025-05-20', '2025-05-26', null, 'Aguardou wal definir texto padrão para cotação: definiu necessidade de ajustar o TR novamente');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 9, 2, 'concluida', '2025-08-25', '2025-09-08', '2025-10-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 10, 3, 'concluida', '2025-10-14', '2025-10-23', '2025-11-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 11, 4, 'concluida', '2025-11-27', '2025-12-04', '2025-12-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 12, 5, 'concluida', '2025-12-17', '2025-12-29', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 13, 2, 'concluida', '2025-12-30', '2026-01-12', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 14, 3, 'em_andamento', '2026-02-06', '2026-05-22', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0144849/2025-06';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-09-30', '2025-10-13', '2025-10-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-10-28', '2025-11-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2025-11-04', '2025-11-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 4, 1, 'concluida', '2025-12-19', '2026-01-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 5, 1, 'concluida', '2026-03-03', '2026-03-05', '2026-03-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 6, 2, 'concluida', '2026-03-03', '2026-03-05', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 7, 1, 'concluida', '2026-03-05', '2026-03-06', '2026-03-18', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 8, 3, 'concluida', '2026-03-06', '2026-03-16', '2026-03-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 9, 4, 'concluida', '2026-03-09', '2026-03-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 10, 2, 'concluida', '2026-03-18', '2026-03-19', null, 'Solicitada adequação na minuta em virtude de alteração do prazo de vigência, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 11, 5, 'concluida', '2026-03-18', '2026-03-19', '2026-03-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 12, 1, 'concluida', '2026-03-19', '2026-03-31', '2026-04-01', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 13, 6, 'concluida', '2026-03-19', '2026-03-31', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 14, 7, 'concluida', '2026-04-01', '2026-04-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 15, 8, 'concluida', '2026-04-17', '2026-04-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 16, 9, 'concluida', '2026-04-24', '2026-05-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 17, 2, 'em_andamento', '2026-06-03', '2026-06-08', null, null);
  update processos set etapa_atual = 'Alteração no mapa de preços a pedido do setor demandante' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0145954/2024-50';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-06', '2025-05-29', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-05-20', '2025-05-26', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-06-05', '2025-06-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 4, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 5, 2, 'concluida', '2025-06-25', '2025-06-25', '2025-06-27', 'Envio para cumprimento de ressalvas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 1, 'concluida', '2025-06-27', '2025-06-27', '2025-06-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2025-06-27', '2025-06-27', '2025-06-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2025-06-27', '2025-06-30', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0147201/2025-37';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2025-11-05', '2025-11-05', '2025-11-18', 'Elaborada minuta e devolvido para a Regional, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 2, 1, 'concluida', '2025-11-18', '2025-11-28', '2026-01-15', 'Devolvido após publicação da Resolução 10.890/26 que delega a competência para a assinatura aos dirigentes regionais');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2026-01-15', '2026-01-15', '2026-01-20', 'Disponibilizado novamente para assinaturas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2026-01-20', '2026-01-21', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0147430/2024-65';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-13', '2025-05-28', '2025-06-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 2, 1, 'concluida', '2025-05-20', '2025-05-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2025-06-05', '2025-06-10', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 4, 1, 'concluida', '2025-06-10', '2025-06-10', '2025-06-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 5, 2, 'concluida', '2025-06-23', '2025-06-24', '2025-06-26', 'Envio para cumprimento de ressalvas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 6, 1, 'concluida', '2025-06-25', '2025-06-26', '2025-06-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2025-06-26', '2025-06-26', '2025-06-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2025-06-26', '2025-06-30', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0147588/2025-64';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 1, 1, 'concluida', '2025-11-06', '2025-11-10', '2025-11-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 2, 1, 'em_andamento', '2025-11-14', '2025-11-18', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0148072/2025-91';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 1, 1, 'concluida', '2025-09-25', '2025-09-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 2, 1, 'concluida', '2025-10-30', '2025-11-06', '2025-11-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 3, 1, 'concluida', '2025-11-06', '2025-11-06', '2025-12-19', 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 2, 'concluida', '2025-11-06', '2025-11-06', '2025-11-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 5, 1, 'concluida', '2025-11-14', null, '2025-12-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 6, 1, 'concluida', '2025-12-04', '2025-12-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 7, 1, 'concluida', '2025-12-19', '2025-12-19', '2025-12-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 8, 1, 'em_andamento', '2025-12-19', '2025-12-23', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0148880/2024-06';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-06-09', '2025-06-12', '2025-06-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2025-06-26', '2025-07-17', '2025-07-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração de aviso e anexos', 'CL', 3, 1, 'concluida', '2025-07-25', '2025-07-31', '2025-08-06', 'Pendências por parte da area demandante informada via teams');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 4, 1, 'concluida', '2025-08-04', '2025-08-04', '2025-09-09', 'Elaborada minuta de COTEP, devolvido para a CL');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Aprovação e divulgação', 'CL', 5, 1, 'concluida', '2025-08-06', '2025-08-07', '2025-08-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Sessão Pública', 'CL', 6, 1, 'concluida', '2025-09-01', '2025-09-05', '2025-09-04', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologar e finalizar', 'CL', 7, 1, 'concluida', '2025-09-04', '2025-09-05', '2025-09-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 8, 1, 'concluida', '2025-09-09', '2025-09-09', '2025-09-12', 'Para conferência pela SILC');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 9, 1, 'concluida', '2025-09-12', '2025-09-15', '2025-09-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 10, 1, 'em_andamento', '2025-09-18', '2025-09-22', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0148880/2024-07';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Aprovação e divulgação', 'CL', 1, 1, 'em_andamento', '2025-08-26', '2025-08-26', null, null);
  update processos set etapa_atual = 'Aprovação e divulgação' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0150658/2025-12';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-12-17', '2025-12-18', '2026-02-24', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 2, 2, 'concluida', '2026-02-24', '2026-02-24', '2026-03-03', 'Enviado para a área demandante diligenciar o cadastro do representante legal no SEI - usuário externo');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2026-03-03', '2026-03-04', '2026-03-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2026-03-06', '2026-03-09', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0151672/2024-88';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-12-23', '2025-01-24', '2025-02-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-02-14', '2025-02-21', '2025-03-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 3, 2, 'concluida', '2025-03-06', '2025-03-13', '2025-04-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2025-03-12', '2025-03-18', '2025-03-31', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-03-31', '2025-04-02', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 6, 1, 'concluida', '2025-04-02', '2025-04-03', '2025-04-08', 'Destino do Ofício: SEPLAG');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 7, 1, 'concluida', '2025-04-03', '2025-04-07', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 8, 1, 'concluida', '2025-04-09', '2025-04-11', '2025-06-25', 'Encaminha para COA realizar cotação de preços - por ser compra estadual não houve os encaminhamentos referentes à criação de IRP');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 9, 1, 'concluida', '2025-04-14', '2025-06-27', '2025-06-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração do Edital e anexos', 'CL', 10, 1, 'concluida', '2025-06-30', '2025-07-04', '2025-07-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 11, 1, 'concluida', '2025-07-11', '2025-07-17', '2025-07-31', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 12, 2, 'concluida', '2025-07-11', '2025-07-15', '2025-07-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 13, 1, 'concluida', '2025-07-14', '2025-07-17', '2025-08-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 14, 1, 'concluida', '2025-07-17', '2025-07-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 15, 1, 'em_andamento', '2025-08-12', null, '2025-06-27', null);
  update processos set etapa_atual = 'Divulgação e preparação para Sessão Pública' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0153007/2024-30';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-10-17', '2024-11-19', '2024-11-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2024-11-27', '2024-12-02', '2024-12-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2024-12-06', '2025-02-05', '2025-02-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2025-02-26', '2025-03-10', '2025-03-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-03-28', '2025-04-02', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 6, 1, 'concluida', '2025-04-02', '2025-06-13', '2025-08-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 7, 1, 'concluida', '2025-07-11', '2025-07-15', '2025-11-18', 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 8, 1, 'concluida', '2025-07-14', '2025-07-17', '2025-08-01', 'AJ devolveu sem nota jurídica');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 9, 1, 'concluida', '2025-08-01', '2025-08-05', '2025-12-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 10, 2, 'concluida', '2025-11-18', '2025-11-18', '2026-06-29', 'Elaborada nova minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 11, 1, 'concluida', '2025-12-09', '2025-12-10', '2025-12-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 12, 1, 'concluida', '2025-12-15', '2025-12-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 13, 2, 'concluida', '2026-02-24', '2026-03-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 14, 1, 'concluida', '2026-03-16', '2026-03-23', '2026-04-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 15, 2, 'concluida', '2026-04-09', '2026-04-28', '2026-04-29', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 16, 3, 'concluida', '2026-04-29', '2026-04-30', '2026-06-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 17, 4, 'concluida', '2026-06-22', '2026-06-29', null, 'Finalizado');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 18, 1, 'em_andamento', '2026-06-29', '2026-06-29', null, null);
  update processos set etapa_atual = 'Disponibilização para assinaturas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0157239/2025-29';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-10-21', '2025-11-05', '2025-11-07', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2025-11-07', '2025-11-14', '2025-11-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2025-11-25', '2025-12-02', '2025-12-19', 'Conferência ETP concluída pela CAP e disponibilizado para assinatura do Diretor');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2025-12-19', '2026-01-12', '2026-02-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2026-02-03', '2026-02-10', '2026-02-19', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-pesquisa de preços', 'CAP', 6, 1, 'concluida', '2026-02-19', '2026-02-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2026-02-24', '2026-03-19', null, 'Ajustes no Termo de Referência.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 8, 1, 'concluida', '2026-04-16', '2026-04-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 9, 2, 'em_andamento', '2026-04-28', null, null, 'Processo paralisado');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0159118/2023-33';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-05-15', '2024-06-19', '2024-07-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2024-07-17', '2024-08-07', '2024-08-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2024-08-22', '2024-09-03', '2024-09-23', 'Análise TR informal via Teams');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 2, 'concluida', '2024-09-23', '2024-11-04', '2025-02-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-02-10', '2025-02-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 6, 1, 'concluida', '2025-02-17', '2025-02-25', '2025-02-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2025-02-27', '2025-07-10', '2025-07-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 8, 1, 'concluida', '2025-08-26', '2025-08-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 9, 1, 'em_andamento', '2025-08-26', '2025-08-27', null, 'Análise conjunta entre CAP e CL');
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0159791/2024-95';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-11-22', '2025-01-24', '2025-04-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'em_andamento', '2025-04-30', '2025-05-13', '2025-12-04', null);
  update processos set etapa_atual = 'TR conferência final' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0160894/2024-93';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 1, 1, 'concluida', '2025-05-23', '2025-05-26', '2025-06-12', 'Elaborada minuta de COTEP, enviado para análise pela AJ');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 2, 1, 'concluida', '2025-06-12', '2025-06-13', '2025-08-15', 'Devolvido para a Regional seguir com a COTEP');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 3, 2, 'concluida', '2025-08-15', '2025-08-19', '2025-09-11', 'Devolvido para a Regional sanar pendências');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 4, 1, 'concluida', '2025-09-11', '2025-09-11', '2025-09-15', 'Para conferência pela SILC');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 5, 1, 'concluida', '2025-09-15', '2025-09-15', '2025-09-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 6, 1, 'em_andamento', '2025-09-17', '2025-09-18', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0163695/2023-32';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-01-09', '2024-01-26', '2024-04-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-04-05', '2024-04-11', '2024-05-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2024-05-17', '2024-06-17', '2024-10-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2024-10-30', '2024-11-27', '2025-01-17', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2025-01-17', '2025-01-23', '2025-02-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2025-02-11', '2025-02-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2025-02-21', '2025-05-06', '2025-05-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 8, 1, 'concluida', '2025-05-12', '2025-05-16', '2025-09-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'COA', 9, 1, 'concluida', '2025-05-28', '2025-06-02', null, 'Processo retornou para adequação');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 10, 1, 'concluida', '2025-10-17', '2025-10-20', null, 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 11, 1, 'concluida', '2025-10-20', '2025-10-20', '2025-11-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 12, 1, 'em_andamento', '2025-11-05', '2025-11-06', null, 'Formalização do Termo de Encerramento');
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0165345/2025-96';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 1, 1, 'concluida', '2025-12-12', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 2, 1, 'concluida', '2026-04-24', '2026-04-24', '2026-04-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2026-04-27', '2026-04-27', '2026-04-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2026-04-28', '2026-04-29', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0165369/2024-33';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2025-04-30', '2025-05-05', '2025-05-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência do contrato pela SILC', 'CFCO', 2, 1, 'concluida', '2025-05-14', '2025-05-21', '2025-05-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 3, 1, 'concluida', '2025-05-23', '2025-05-26', '2025-05-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 4, 1, 'em_andamento', '2025-05-28', '2025-05-29', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0170446/2024-15';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2024-02-26', '2024-04-05', '2024-06-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2024-12-05', '2024-12-17', '2025-01-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 1, 'concluida', '2025-01-09', '2025-01-17', '2025-02-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 4, 1, 'concluida', '2025-02-03', '2025-02-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 5, 1, 'concluida', '2025-02-04', '2025-03-21', '2025-04-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 6, 1, 'concluida', '2025-04-04', '2025-04-07', '2025-04-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 7, 1, 'concluida', '2025-04-09', '2025-04-11', '2025-04-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 8, 1, 'concluida', '2025-04-23', '2025-04-23', '2025-07-10', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Alteração no mapa de preços a pedido do setor demandante', 'COA', 9, 2, 'concluida', '2025-04-24', '2025-04-28', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 10, 1, 'em_andamento', '2025-04-30', '2025-05-06', null, null);
  update processos set etapa_atual = 'Cumprimento de ressalvas jurídicas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0174846/2025-37';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'em_andamento', '2025-12-30', '2026-01-16', '2026-07-13', null);
  update processos set etapa_atual = 'ETP 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0179610/2025-31';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-01-26', '2026-02-02', '2026-02-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 2, 1, 'concluida', '2026-02-12', '2026-02-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 3, 1, 'concluida', '2026-02-12', '2026-02-24', '2026-02-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 1, 'concluida', '2026-02-26', '2026-03-04', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 5, 1, 'concluida', '2026-03-04', '2026-03-10', '2026-03-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 6, 1, 'concluida', '2026-03-06', '2026-03-09', null, 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 7, 1, 'concluida', '2026-03-26', '2026-03-26', '2026-03-31', 'CL devolveu para cumprimento de ressalvas mas no momento não há ressalvas a serem cumpridas pela CFCO. Aguardando novo envio para formalização.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 8, 1, 'concluida', '2026-03-26', '2026-03-26', '2026-04-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 9, 1, 'concluida', '2026-03-27', null, '2026-04-08', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 10, 2, 'concluida', '2026-03-31', '2026-04-08', null, 'Devolvido para a CL com nova minuta após nota jurídica e saneamentos da demandante.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 11, 1, 'em_andamento', '2026-04-08', '2026-04-14', '2026-04-14', 'Publicação - Aviso de Licitação em 14/04/2026 - Concorrência 35 dias úteis publicado - Sessão agendada para 11/06/2026');
  update processos set etapa_atual = 'Divulgação e preparação para Sessão Pública' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0180880/2024-82';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-27', '2026-05-12', '2026-06-09', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-06-09', '2026-06-12', '2026-06-22', 'Análise TR via bloco de assinaturas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 2, 'concluida', '2026-06-22', '2026-06-24', '2026-07-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 4, 1, 'concluida', '2026-07-03', '2026-07-09', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 5, 1, 'em_andamento', '2026-07-10', '2026-07-17', null, null);
  update processos set etapa_atual = 'Análise da justificativa de preço' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0181974/2025-29';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2025-12-23', '2026-01-14', '2026-02-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2026-02-11', '2026-02-20', '2026-02-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2026-02-20', '2026-02-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2026-02-20', '2026-03-04', '2026-03-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'concluida', '2026-03-16', '2026-03-16', '2026-03-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 6, 1, 'concluida', '2026-03-16', '2026-03-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 7, 1, 'concluida', '2026-03-18', '2026-03-23', null, 'Alteração no modelo de proposta comercial');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 8, 2, 'concluida', '2026-03-25', '2026-04-15', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 9, 1, 'concluida', '2026-04-22', null, null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 10, 1, 'concluida', '2026-04-22', null, '2026-04-28', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 11, 1, 'concluida', '2026-04-28', '2026-04-28', '2026-05-26', 'Elaborada minuta, devolvido para a CL, aguardando retorno');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 12, 2, 'concluida', '2026-04-28', '2026-04-28', '2026-05-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 13, 3, 'concluida', '2026-05-05', '2026-05-08', '2026-05-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 14, 1, 'concluida', '2026-05-20', '2026-05-21', '2026-05-25', 'Processo encaminhado para COA e Área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 15, 1, 'concluida', '2026-05-22', '2026-05-25', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 16, 2, 'concluida', '2026-05-25', '2026-05-25', '2026-05-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 17, 1, 'em_andamento', '2026-05-26', '2026-05-26', null, 'Devolvido para a CL sem ressalvas a cumprir pela CFCO');
  update processos set etapa_atual = 'Outros' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0182543/2025-89';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-07-16', null, null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0182632/2023-20';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2024-01-18', '2024-02-06', '2024-05-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2024-06-18', '2024-07-15', '2024-07-29', 'Em 3/7 area mudou item catmas do TR o que importa nova pesquisa de preços');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 2, 'concluida', '2024-07-29', '2024-08-28', '2024-09-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CL', 4, 1, 'concluida', '2024-10-08', '2024-10-23', '2024-12-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Homologar e finalizar', 'CL', 5, 1, 'em_andamento', '2024-12-20', '2025-01-13', null, null);
  update processos set etapa_atual = 'Homologar e finalizar' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0184932/2025-91';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-16', '2026-05-05', '2026-05-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-05-15', '2026-05-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'em_andamento', '2026-05-21', '2026-06-22', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0186493/2025-42';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-07-16', null, null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0188724/2023-48';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2023-12-06', '2023-12-20', '2024-03-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2024-03-25', '2024-04-05', '2024-04-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2024-04-11', '2024-04-16', '2024-11-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2024-11-22', '2024-12-10', '2025-02-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'concluida', '2025-02-21', '2025-02-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e elaboração do Edital e anexos', 'CL', 6, 1, 'concluida', '2025-03-12', '2025-03-25', '2025-04-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 1, 'concluida', '2025-04-22', '2025-04-24', '2025-06-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 8, 1, 'concluida', '2025-06-05', '2025-06-06', '2025-08-27', 'Aguardando definição SUBRAS e área demandante de quando publicar edital. Processo devolvido pela área demandante em 27/08/2025 solicitando prosseguimento da contratação.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e finalização do edital', 'CL', 9, 2, 'concluida', '2025-08-28', '2025-08-28', '2025-09-03', 'Para validação da DCC');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 10, 1, 'concluida', '2025-09-03', '2025-09-06', null, 'Sessão Pública marcada para dia 04/11/2025');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Divulgação e preparação para Sessão Pública', 'CL', 11, 2, 'concluida', '2025-10-29', '2025-10-29', '2026-01-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Encerramento e Adjudicação', 'CL', 12, 1, 'concluida', '2026-01-21', '2026-01-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 13, 1, 'em_andamento', '2026-06-23', '2026-06-25', null, null);
  update processos set etapa_atual = 'Disponibilização para assinaturas' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0189960/2025-38';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-09', '2026-04-24', '2026-05-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 2, 1, 'concluida', '2026-05-13', '2026-05-20', '2026-05-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 3, 1, 'concluida', '2026-05-25', '2026-05-28', '2026-06-03', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 4, 1, 'concluida', '2026-06-03', '2026-06-17', '2026-06-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 5, 1, 'em_andamento', '2026-06-30', '2026-07-07', null, null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0194226/2025-92';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'concluida', '2026-02-05', '2026-02-24', '2026-03-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 2, 1, 'concluida', '2026-02-24', '2026-03-10', '2026-03-27', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 3, 1, 'concluida', '2026-02-24', '2026-03-02', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência', 'CAP', 4, 1, 'concluida', '2026-03-05', '2026-03-12', '2026-03-20', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP conferência final', 'CAP', 5, 1, 'concluida', '2026-03-20', '2026-03-24', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 6, 1, 'concluida', '2026-03-27', '2026-04-07', '2026-04-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 7, 2, 'concluida', '2026-04-14', '2026-04-23', '2026-06-22', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 8, 2, 'concluida', '2026-04-14', '2026-04-16', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 'CL', 9, 1, 'concluida', '2026-04-20', '2026-04-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-solicitação de gestão de RP', 'CAP', 10, 3, 'concluida', '2026-06-22', '2026-06-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 11, 3, 'em_andamento', '2026-06-22', '2026-06-26', null, null);
  update processos set etapa_atual = 'TR conferência' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0199384/2024-24';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'ETP 1ª análise', 'CAP', 1, 1, 'em_andamento', '2025-05-07', '2025-05-20', '2025-09-17', null);
  update processos set etapa_atual = 'ETP 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0199400/2025-74';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 1, 1, 'concluida', '2026-01-08', '2026-01-08', '2026-01-13', 'Devolvido para a demandante prestar informações sobre o preenchimento do contrato e anexar documento do representante legal');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 2, 1, 'concluida', '2026-01-13', '2026-01-14', '2026-01-15', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 3, 1, 'em_andamento', '2026-01-15', '2026-01-16', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0202633/2025-83';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-06-16', '2026-06-30', '2026-07-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2026-07-13', '2026-07-14', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Análise da justificativa de preço', 'COA', 3, 1, 'em_andamento', '2026-07-15', '2026-07-22', null, null);
  update processos set etapa_atual = 'Análise da justificativa de preço' where id = v_pid;

  select id into v_pid from processos where num_sei = '1320.01.0202817/2025-62';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-02-02', '2026-02-06', '2026-02-13', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 2, 1, 'concluida', '2026-02-13', '2026-05-07', null, 'Mapa de preços encaminhado para validação da aréa demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 1, 'concluida', '2026-02-13', '2026-02-24', '2026-03-05', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 4, 2, 'concluida', '2026-03-05', '2026-03-09', '2026-03-11', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 5, 1, 'em_andamento', '2026-03-11', '2026-03-12', null, null);
  update processos set etapa_atual = 'TR conferência final' where id = v_pid;

  select id into v_pid from processos where num_sei = '5140.01.0001007/2026-35';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-04-07', '2026-04-23', '2026-05-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-05-26', '2026-06-02', '2026-06-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 3, 2, 'concluida', '2026-06-26', '2026-07-03', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 4, 1, 'em_andamento', '2026-07-06', null, null, null);
  update processos set etapa_atual = 'Realização da pesquisa de preços' where id = v_pid;

  select id into v_pid from processos where num_sei = '5140.01.0001859/2025-23';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-04-29', '2025-05-20', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 2, 1, 'concluida', '2025-05-21', '2025-05-27', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2025-05-30', '2025-06-18', '2025-06-25', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-06-30', '2025-07-02', '2025-07-16', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 5, 1, 'concluida', '2025-07-16', '2025-07-18', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 6, 1, 'concluida', '2025-07-17', '2025-07-18', '2025-07-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 7, 2, 'concluida', '2025-07-17', '2025-07-16', '2025-07-18', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 8, 1, 'concluida', '2025-07-18', '2025-07-21', '2025-07-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 9, 2, 'concluida', '2025-07-23', '2025-07-23', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 10, 1, 'concluida', '2025-07-24', '2025-07-25', '2025-07-28', 'Devolvido para a área demandante para atualizar documentação vencida');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 11, 1, 'concluida', '2025-07-28', '2025-07-28', '2025-07-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Outros', 'CFCO', 12, 2, 'concluida', '2025-07-30', '2025-08-01', '2025-09-01', 'Foi necessário abrir chamado no SIAD para solucionar problema no Portal de Compras.');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 13, 1, 'em_andamento', '2025-09-01', '2025-09-01', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

  select id into v_pid from processos where num_sei = '5140.01.0005502/2025-20';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2026-02-09', '2026-02-24', '2026-03-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência', 'CAP', 2, 1, 'concluida', '2026-03-30', '2026-04-07', '2026-05-26', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR conferência final', 'CAP', 3, 1, 'concluida', '2026-05-26', '2026-06-02', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 4, 1, 'concluida', '2026-06-03', '2026-07-02', null, 'Mapa validado pela área demandante');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 5, 1, 'em_andamento', '2026-07-17', '2026-07-20', null, 'Devolvido para a CL pois a minuta solicitada já havia sido elaborada pela PRODEMGE');
  update processos set etapa_atual = 'Elaboração de minuta' where id = v_pid;

  select id into v_pid from processos where num_sei = '5140.01.0005702/2025-52';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'em_andamento', '2026-06-12', '2026-06-26', null, null);
  update processos set etapa_atual = 'TR 1ª análise' where id = v_pid;

  select id into v_pid from processos where num_sei = '5140.01.0006476/2024-12';
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'TR 1ª análise', 'CAP', 1, 1, 'concluida', '2025-05-26', '2025-06-09', '2025-06-12', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência pré-pesquisa de preços', 'CAP', 2, 1, 'concluida', '2025-06-12', '2025-06-17', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Realização da pesquisa de preços', 'COA', 3, 1, 'concluida', '2025-06-17', '2025-07-24', '2025-07-30', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Conferência processual e encaminhamento para análise jurídica', 'CL', 4, 1, 'concluida', '2025-08-04', '2025-08-07', '2025-08-14', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 5, 1, 'concluida', '2025-08-18', '2025-08-20', '2025-09-23', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Preparação para saneamento de ressalvas', 'CL', 6, 2, 'concluida', '2025-08-18', '2025-08-20', '2025-08-21', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Cumprimento de ressalvas jurídicas', 'COA', 7, 1, 'concluida', '2025-08-20', '2025-08-21', null, null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Saneamento de ressalvas e preparação para homologação', 'CL', 8, 1, 'concluida', '2025-09-23', '2025-09-24', '2025-10-02', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Elaboração de minuta', 'CFCO', 9, 1, 'concluida', '2025-10-01', '2025-10-02', '2025-10-20', 'Elaborada minuta e devolvido para a CL, aguardando devolução');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 10, 1, 'concluida', '2025-10-20', '2025-10-21', '2025-11-06', null);
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Disponibilização para assinaturas', 'CFCO', 11, 2, 'concluida', '2025-11-06', '2025-11-06', '2026-02-12', 'Demandante solicitou alteração no representante legal, disponibilizado novamente para assinaturas');
  insert into etapas (processo_id, fase, coordenacao, ordem, versao, status, data_entrada, data_saida, data_retorno, observacao) values (v_pid, 'Publicação e lançamento no Portal de Compras', 'CFCO', 12, 1, 'em_andamento', '2026-02-12', '2026-02-13', null, null);
  update processos set etapa_atual = 'Publicação e lançamento no Portal de Compras' where id = v_pid;

end $$;

-- Fim. Histórico importado: etapas reais com datas e coordenações.

-- ####################################################################
-- ARQUIVO: 18_prazos_detalhados.sql
-- ####################################################################

-- ============================================================
-- 18_prazos_detalhados.sql
-- Carrega os prazos das FASES DETALHADAS (do Fases_novas.xlsx)
-- Substitui os prazos macro antigos. Base para o 'projetado' do Gantt.
-- Rode no PROJETO CERTO (tatinrolrssjervuykej).
-- ============================================================

-- limpa prazos antigos (macro) para recarregar os detalhados
delete from prazos_fase;

-- ===== Modalidade DISP =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e encaminhamento para análise jurídica', 3, 3, 18 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Preparação para saneamento de ressalvas', 1, 1, 19 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Saneamento de ressalvas e preparação para homologação', 3, 3, 20 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 22 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 23 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 24 from modalidades where sigla='DISP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 25 from modalidades where sigla='DISP';

-- ===== Modalidade INEX =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e encaminhamento para análise jurídica', 3, 3, 18 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Preparação para saneamento de ressalvas', 1, 1, 19 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Saneamento de ressalvas e preparação para homologação', 3, 3, 20 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 22 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 23 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 24 from modalidades where sigla='INEX';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 25 from modalidades where sigla='INEX';

-- ===== Modalidade PE =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e elaboração do Edital e anexos', 7, 7, 18 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Preparação para saneamento de ressalvas', 1, 1, 19 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Saneamento de ressalvas e finalização do edital', 3, 3, 20 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Divulgação e preparação para Sessão Pública', 5, 5, 21 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Encerramento e Adjudicação', 4, 4, 22 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 24 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 25 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 26 from modalidades where sigla='PE';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 27 from modalidades where sigla='PE';

-- ===== Modalidade PE-RP =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e solicitação de autorização para gestão de RP à Seplag', 3, 3, 18 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Criação do IRP', 2, 2, 19 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Termo de adesão e Consolidação das Adesões', 2, 2, 20 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração do Edital e anexos', 5, 5, 21 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Preparação para saneamento de ressalvas', 1, 1, 22 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Saneamento de ressalvas e finalização do edital', 3, 3, 23 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Divulgação e preparação para Sessão Pública', 5, 5, 24 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Encerramento e Adjudicação', 4, 4, 25 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 27 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 28 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 29 from modalidades where sigla='PE-RP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 30 from modalidades where sigla='PE-RP';

-- ===== Modalidade COTEP =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e elaboração de aviso e anexos', 3, 3, 18 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Aprovação e divulgação', 2, 2, 19 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Sessão Pública', 30, 30, 20 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Homologar e finalizar', 3, 3, 21 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 23 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 24 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 25 from modalidades where sigla='COTEP';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 26 from modalidades where sigla='COTEP';

-- ===== Modalidade CONC =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e elaboração do Edital e anexos', 7, 7, 18 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Preparação para saneamento de ressalvas', 1, 1, 19 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Saneamento de ressalvas e finalização do edital', 3, 3, 20 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Divulgação e preparação para Sessão Pública', 5, 5, 21 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Encerramento e Adjudicação', 4, 4, 22 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 24 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 25 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 26 from modalidades where sigla='CONC';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 27 from modalidades where sigla='CONC';

-- ===== Modalidade ADESAO =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência processual e preparação para encaminhamento à Assessoria Jurídica', 5, 5, 18 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Preparação para saneamento de ressalvas', 1, 1, 19 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Saneamento de ressalvas e homologação', 3, 3, 20 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 22 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 23 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 24 from modalidades where sigla='ADESAO';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 25 from modalidades where sigla='ADESAO';

-- ===== Modalidade CRED =====
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Estudo/registro dos apontamentos da nota jurídica', 1, 1, 1 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP 1ª análise', 10, 5, 2 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência', 5, 5, 3 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'ETP conferência final', 5, 5, 4 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-solicitação de gestão de RP', 10, 5, 5 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR 1ª análise', 10, 5, 6 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência', 5, 5, 7 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência pré-pesquisa de preços', 5, 5, 8 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'TR conferência final', 5, 5, 9 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Contratação pública integralmente analisada encaminhada para a CL (SRP)', 5, 5, 10 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Demandante da Contratação', 10, 10, 11 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Análise da justificativa de preço', 6, 6, 13 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Realização da pesquisa de preços', 20, 20, 14 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Cumprimento de ressalvas jurídicas', 2, 2, 15 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Alteração no mapa de preços a pedido do setor demandante', 6, 6, 16 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Elaboração de minuta', 2, 2, 18 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Conferência do contrato pela SILC', 3, 3, 19 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Disponibilização para assinaturas', 5, 5, 20 from modalidades where sigla='CRED';
insert into prazos_fase (modalidade_id, fase, dias_normal, dias_prioritario, ordem) select id, 'Publicação e lançamento no Portal de Compras', 2, 2, 21 from modalidades where sigla='CRED';

-- Verificação: contagem por modalidade
select m.sigla, count(*) as fases from prazos_fase p join modalidades m on m.id=p.modalidade_id group by m.sigla order by m.sigla;

-- ####################################################################
-- ARQUIVO: 19_add_juliana_dcc.sql
-- ####################################################################

-- ============================================================
-- GOVERNANÇA EM COMPRAS — Adicionar usuária DCC
-- ------------------------------------------------------------
-- Juliana Bortot, nível DCC (vê tudo, edita e exclui).
--
-- ANTES de rodar este SQL, crie o acesso no painel:
--   Authentication > Users > Add user
--   - juliana.bortot@saude.mg.gov.br | senha: Mudar@2026 | Auto Confirm
--
-- Depois rode este SQL (no PROJETO CERTO: tatinrolrssjervuykej).
-- ============================================================

insert into public.usuarios (email, nome, nivel, precisa_trocar_senha, ativo) values
  ('juliana.bortot@saude.mg.gov.br', 'Juliana Bortot', 'dcc', true, true)
on conflict (email) do update set
  nome=excluded.nome, nivel=excluded.nivel, ativo=true;

-- Verificação
select nome, email, nivel from usuarios where email='juliana.bortot@saude.mg.gov.br';

-- ============================================================
-- Pronto. No primeiro acesso, ela cria a própria senha.
-- ============================================================

