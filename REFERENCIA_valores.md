# Referência — valores válidos para o CSV de processos

## Coluna "area" (use a sigla MAIS específica que souber; eu completo os níveis acima)

**Diretorias (nível mais específico):**
SUBRAS: DEFAPS, DPAPS, DGIC, DPSPE, DATE, DAE, DEHUE, DAHUE
SUBVS: DVDTI, DVCC, DVAST, DVSS, DVA, DVMC, DVEF
SUBASS: DPAF, DPAM, DERE, DRAUE, DDM, DIJ, DCDJ
SUBGF: DCF, DCR, DPC, DPO, DPDH, DRH, DCC, DIFE, DPAT, DLOG
SUBREG: DARPS, DMPS

**Superintendências (se não tiver a diretoria):**
SUBRAS: SAPS, SAE, SPAH
SUBVS: SVE, SVS
SUBASS: SAF, SRA, SJUD
SUBGF: SPF, SGDP, SILC
SUBREG: SIR

**Subsecretarias (se for o nível que você tem):**
SUBRAS, SUBVS, SUBASS, SUBGF, SUBREG

**Órgãos/assessorias (nível 1):**
ASJUR, ASCOM, AEST, ASRI, ATI, CSET, AUDSUS, ASPAR, GAB

---

## Coluna "fase_atual" (use exatamente um destes nomes)

ETP em elaboração
ETP em análise
TR em elaboração
TR em análise
Pesquisa de preços
Conferência processual
Saneamento de ressalvas jurídicas
Edital
Sessão pública
Cotação Eletrônica de Preços
Cadastro de propostas
Gestão SEPLAG
Homologação
Parado/Sem previsão

---

## Coluna "modalidade" (use exatamente um destes nomes)

Pregão Eletrônico
Pregão Eletrônico para Registro de Preços
Dispensa
Inexigibilidade
COTEP
Concorrência
Adesão

---

## Coluna "prioritario"
sim  OU  nao

## Colunas opcionais
valor_estimado: só números (ex.: 150000) — pode deixar vazio
prazo_final: data no formato AAAA-MM-DD (ex.: 2026-09-30) — pode deixar vazio

---

## Dicas
- Uma linha por processo (o SEI é o identificador único).
- Não precisa preencher subsecretaria/superintendência se der a diretoria — eu completo.
- Os dois primeiros exemplos no CSV são só ilustrativos: apague-os e coloque os seus.
- Se algum processo não tem fase clara, use "Parado/Sem previsão".
