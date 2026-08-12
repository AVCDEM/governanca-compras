# Varredura geral do sistema — relatório

Feita uma revisão completa: todos os botões/telas, os SQLs, e as
pontas soltas. Abaixo o que encontrei, o que corrigi, e o que falta.

## ✅ TESTADO E FUNCIONANDO (16/16 na varredura automatizada)
- Login com senha + roteamento por nível
- KPIs reais em todas as telas (total, em atraso, vencem em 30 dias, pendentes de validação)
- Filtro de coordenação (CAP/COA/CL/CFCO) — agora reconhece as fases detalhadas
- Filtro de prioritário (Todos/Sim/Não)
- Filtros avançados (SEI, área, status, modalidade, fase, objeto) + Limpar
- Indicadores: retrabalho de TR (repetições reais) e processos por coordenação
- Página do processo: dados reais, contrato, Gantt real por fase
- Mini-gantt real na expansão das listas (gabinete e sub)
- Botão voltar (vai para a tela do nível certo)
- Cadastro, edição, exclusão de processos
- Validação de processo (botão ✓)
- Atualização de etapa (painel)
- Resumo semanal

## 🔧 PONTAS SOLTAS QUE CORRIGI NESTA VARREDURA
1. **Filtro de coordenação não reconhecia as fases novas** — depois de
   importar o histórico, os processos passaram a usar as 38 fases
   detalhadas, mas o mapa fase→coordenação ainda tinha só as macro.
   Reconstruí o mapa com todas as fases reais (do histórico).
2. **Dropdowns de fase (cadastro, edição, filtro) usavam as fases macro**
   — agora usam as 38 fases detalhadas reais, agrupadas por coordenação.
3. **Gráfico "processos por etapa" ficaria zerado** (usava chaves macro)
   — troquei para "processos por coordenação atual".
4. **Botão "Limpar" dos filtros não fechava a gaveta** — corrigido.
5. **05_permissoes_rls.sql tinha 2 falhas** (ver abaixo) — corrigido.

## 🔒 SQL 05 (TRANCAR SEGURANÇA) — CORRIGIDO, AINDA NÃO RODADO
Encontrei e corrigi dois problemas no 05_permissoes_rls.sql:
- Faltava ativar o RLS nas tabelas (as políticas não teriam efeito).
- O escopo do ponto focal só olhava superintendência; agora bate com o
  sistema (diretoria, superintendência, ou subsecretaria inteira).
Continua sendo o ÚLTIMO passo — rode só depois de testar tudo no ar.
Se algo der errado, o 02_permissoes.sql reabre.

## 📁 SQLs — organizados
A sequência oficial é 01 a 17 (na pasta de saída). Movi 9 SQLs
antigos/duplicados para a subpasta `sql_obsoletos/` para não confundir.
Todos os 16 SQLs da sequência têm sintaxe validada.

Estado do banco (confirmado por você): 01,02,04,06-17 já rodados.
Pendentes: 05 (trancar, por último) e conferir se quer rodar algo mais.

## ⏳ O QUE AINDA FALTA (decisões suas, não são bugs)
- Rodar o 05 (trancar segurança) quando terminar de testar
- Definir fases/prazos do Credenciamento (modalidade sem prazos ainda)
- Se quiser: indicadores de tempo (DCC vs espera-área) — a base de dados
  já está lá (as 3 datas), é só construir a visualização
- Calculadora de prazos v2 (projetado automático no Gantt)

## ▶️ PARA VER AS CORREÇÕES
Republique o index.html no Vercel. Tudo que foi corrigido está nele.
