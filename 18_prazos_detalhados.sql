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