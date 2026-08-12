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
Os arquivos `01_` a `19_` recriam o banco do zero: tabelas, funções,
políticas de segurança (RLS), prazos, processos e usuários.
- `BACKUP_COMPLETO_ESTRUTURA.sql` — todos os SQLs juntos (backup)
- `RESET_SENHAS.sql` — volta todos os usuários para a senha padrão

### Documentação
- `ONDE_ESTAMOS.md` — situação geral do projeto
- `VARREDURA_GERAL.md` — relatório de testes e correções
- `CHECKLIST_TESTE_LOGINS.md` — como testar os acessos
- `ROTEIRO_*.md` — guias de autenticação, publicação e importação

## Observações
- Repositório privado — contém lógica interna da SES-MG.
- Nunca commitar a connection string nem backups do banco (.sql de dump).
