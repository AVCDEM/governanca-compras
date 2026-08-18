# Governança em Compras — SES-MG

Sistema de monitoramento do Plano Anual de Contratações (PAC) da
Secretaria de Estado de Saúde de Minas Gerais.

## O que é
Aplicação web autenticada, com 4 níveis de acesso (Gabinete,
Subsecretário, Ponto Focal, DCC), para acompanhar os processos de
compra ao longo das fases e coordenações (CAP, COA, CL, CFCO).

- **Front-end:** `index.html` (publicado no Vercel)
- **Banco de dados:** Supabase (PostgreSQL)

## Estrutura dos arquivos

### Sistema
- `index.html` — a aplicação completa (front-end)

### Banco de dados (rodar na ordem no Supabase)
Os arquivos numerados recriam o banco do zero: tabelas, funções,
políticas de segurança (RLS), prazos, processos e usuários.
Atenção: o `03_` e o `19_` não estão no repositório.

- `05b_permissoes_rls_corrigido.sql` — **é este que vale**, não o `05_`.
  Fecha o acesso por usuário. Já aplicado em 18/08/2026.
- `02_permissoes.sql` — reabre tudo. É o plano de emergência.
- `DIAGNOSTICO_BANCO.sql` — retrato da estrutura do banco (só leitura).
- `BACKUP_COMPLETO_ESTRUTURA.sql` — todos os SQLs juntos (backup)
- `RESET_SENHAS.sql` — volta todos os usuários para a senha padrão

### Documentação
- `ONDE_ESTAMOS.md` — situação geral do projeto
- `VARREDURA_GERAL.md` — relatório de testes e correções
- `CHECKLIST_TESTE_LOGINS.md` — como testar os acessos
- `ROTEIRO_*.md` — guias de autenticação, publicação e importação

## Prazos das etapas
A calculadora de prazos (dias previstos por etapa, coordenação e
modalidade) vive **no `index.html`**, em `PRAZOS_COORD` e `PRAZOS_CL`.
Veio da planilha "Fases novas.xlsx" da DCC. A tabela `prazos_fase` do
banco existe mas não é lida por ninguém. Para mudar um prazo, edite o
número no `index.html` e publique.

## Publicação
Push na branch `main` → o Vercel publica sozinho. O `.vercelignore`
garante que só o `index.html` vá para a web.

## Observações
- Repositório privado — contém lógica interna da SES-MG.
- Nunca commitar a connection string nem backups do banco (.sql de dump).
