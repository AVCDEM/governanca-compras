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
