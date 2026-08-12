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
