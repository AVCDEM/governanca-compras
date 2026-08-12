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
