# Checklist de teste dos logins

Você NÃO precisa testar os 42. Testando 1 de cada TIPO, você valida
todos os do mesmo tipo (é a mesma lógica, só muda a área).

Senha de todos (1º acesso): Mudar@2026 (aí cria a senha própria).

Para cada login, confira 3 coisas:
[ ] Entrou na tela certa do nível?
[ ] O número de processos bate com o esperado (coluna "deve ver")?
[ ] Consegue abrir um processo (clicar no "i") e ver os dados + Gantt?

═══════════════════════════════════════════════════════════════

## 1) DCC — vê TUDO
Login: você mesmo (ou dc@)
Deve ver: 178 processos (todos)
Extra: botões de cadastrar, editar (✎), excluir (✕), Indicadores.

## 2) GABINETE — vê TUDO
Login: o usuário de nível gabinete (GAB)
Deve ver: 178 processos (todos), mas SEM poder editar/excluir.

## 3) SUBSECRETÁRIO — vê a subsecretaria dele
Login: um dos 4 subsecretários
Deve ver (conforme a subsecretaria):
  - SUBASS: 28 · SUBGF: 67 · SUBVS: 26 · SUBRAS: 19 · SUBR: 15

## 4) PONTO FOCAL "ESPECIAL" (vê a subsecretaria inteira)
Estes 6 têm área = subsecretaria (padrão SUBXXX, null, null):
  - SUBVS → Ronan Ribeiro (ronan.ribeiro@) — deve ver 26
  - SUBVS → Rita Narciso de Barros (rita.barros@) — deve ver 26
  - SUBASS → Luis Guilherme Santos (luis.santos@) — deve ver 28
  - SUBASS → Ana Paula Trindade (ana.trindade@) — deve ver 28
  - SUBGF → Suelen Novy Santos (suelen.novy@) — deve ver 67
  - SUBGF → Lorena Stefany (lorena.stefany.santos@) — deve ver 67
Teste 1 deles (ex.: Ronan, SUBVS → 26). Se OK, os 6 estão OK.

## 5) PONTO FOCAL "NORMAL" (vê a superintendência dele)
Exemplos e o que devem ver:
  - Matheus Melo (matheus.melo@) — SUBGF › SPF → 0 processos*
  - Augusto Ananias (augusto.ananias@) — SUBRAS › SAPS → 5
  - Fernanda Santos (fernanda.santos@) — SUBRAS › SAE → 0*
  - Audiléia Santos (audileia.santos@) — SUBRAS › SPAH → 14
  - Natália Cardoso (natalia.cardoso@) — SUBGF › SILC → 39
Teste 1 com número > 0 (ex.: Audiléia, SPAH → 14, ou Natália, SILC → 39).
*Alguns SPF/SAE podem ter 0 processos hoje — não é erro, é que não há
 processos dessa superintendência ainda. Prefira testar um com número > 0.

## 6) PONTO FOCAL POR DIRETORIA (só 2 existem)
  - DLOG (dlog@) — SUBGF › SILC › DLOG → deve ver 16
  - DPAT (dpat@) — SUBGF › SILC › DPAT → deve ver 4
Teste o DLOG (16). Se OK, esse tipo está OK.

## 7) PONTO FOCAL DE ÓRGÃO nível 1 (raro, opcional)
  - ATI (vander.oliveira@, evandro.lana@, fausniel.brandao@) → 18
  - ASPAR (elisa.paschoal@, eliana.mascarenhas@) → 3
Se quiser cobrir 100%, teste o ATI (18).

═══════════════════════════════════════════════════════════════

## Resumo: com 6 logins você cobre TODOS os 42
1 DCC + 1 gabinete + 1 subsecretário + 1 focal-subsecretaria +
1 focal-superintendência + 1 focal-diretoria.
(+ 1 de órgão nível 1, se quiser 100%.)

Se todos mostrarem o número esperado, o escopo está correto para
todos os 42 — porque é a mesma lógica, só muda a área.

## Se algum número NÃO bater
Anota qual login e o que apareceu vs o esperado, e me manda.
Provavelmente é um ajuste pontual (a área do usuário no cadastro,
ou uma sigla). Não precisa testar os outros desse tipo antes de falar.
