# Roteiro — Subir os 178 processos

Rode NO PROJETO CERTO (tatinrolrssjervuykej). Confira no topo do
painel antes de começar!

## Ordem dos SQLs

### 1) 13_credenciamento.sql
Adiciona a modalidade "Credenciamento" (2 processos usam).
Rode primeiro.

### 2) 12_inserir_processos.sql
Insere os 178 processos + suas etapas.
- Cada processo entra com a área completa (sub > super > diretoria).
- A etapa ATUAL fica "em andamento"; as anteriores "concluída";
  as futuras "não iniciada" — assim a timeline já reflete onde está.
- 167 processos com prazo vencido entraram como "em atraso".
- É seguro rodar de novo: remove processo de mesmo Nº SEI antes.

## Depois de rodar

### 3) Republicar o index.html no Vercel
A versão nova tem: SUBR (corrigido de SUBREG), modalidade
Credenciamento, campo contrato, edição de processos.

### 4) Testar no ar
- Login como DCC (você) → deve ver os 178 processos, indicadores.
- Login como um ponto focal → deve ver só os da área dele.
- Login como subsecretário → só os da subsecretaria dele.
- Abrir um processo → ver a timeline de etapas (a atual destacada).

## Correções aplicadas (do que você me passou)
- SUBR = Regionalização (corrigi SUBREG → SUBR no sistema)
- DPEAE → DPSPE (erro de digitação, 1 processo)
- Credenciamento = modalidade nova (sem prazos por ora)
- 2 processos "Não definida" entraram sem modalidade (defina no sistema)

## O que ainda falta (depois de tudo testado)
- Rodar 05_permissoes_rls.sql (TRANCAR a segurança) — último passo
- Definir fases/prazos do Credenciamento (quando quiser)
- Calculadora de prazos v2 (projetado automático)

Qualquer erro em qualquer SQL, me manda a mensagem.
