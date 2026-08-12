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
