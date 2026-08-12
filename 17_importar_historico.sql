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