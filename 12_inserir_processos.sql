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