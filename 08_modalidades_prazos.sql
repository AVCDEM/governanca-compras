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