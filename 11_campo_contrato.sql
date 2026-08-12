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
