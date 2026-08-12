# Roteiro — Ativar o login seguro (Auth) no Supabase

Faça na ordem. Cada etapa tem um "como testar" — só passe para a
próxima quando a atual estiver ok. A ordem foi pensada para o sistema
nunca ficar quebrado no meio do caminho.

---

## ETAPA 1 — Rodar o SQL que prepara a tabela (04_auth.sql)

1. No Supabase, menu lateral → **SQL Editor**.
2. Cole todo o conteúdo do arquivo **04_auth.sql** e clique **Run**.
3. Deve aparecer "Success". Isso adiciona à tabela `usuarios` o
   vínculo com o Auth e o controle de "trocar senha no primeiro acesso".

**Como testar:** vá em Table Editor → tabela `usuarios`. Devem existir
as colunas novas `auth_id` e `precisa_trocar_senha`.

---

## ETAPA 2 — Conferir se o Auth por e-mail/senha está ligado

1. Menu lateral → **Authentication** → **Providers** (ou "Sign In / Providers").
2. Confirme que **Email** está habilitado (é o padrão).
3. Em **Authentication → Providers → Email**, DESLIGUE a opção
   "Confirm email" (confirmação por e-mail) — para os usuários
   conseguirem entrar direto com a senha provisória, sem precisar
   clicar num link de confirmação. (Você pode religar depois se quiser.)

**Como testar:** não há teste ainda; seguimos para criar um usuário.

---

## ETAPA 3 — Criar seu primeiro usuário de teste (você mesmo)

Vamos criar UM usuário para testar tudo antes de cadastrar todo mundo.

1. Menu lateral → **Authentication** → **Users** → botão **Add user**
   → **Create new user**.
2. Preencha:
   - **Email:** seu e-mail institucional (ex.: joao.gontijo@saude.mg.gov.br)
   - **Password:** uma senha provisória (ex.: Provisoria@2026)
   - Marque **Auto Confirm User** (para já entrar sem confirmar e-mail).
3. Clique **Create user**.

Agora ligue esse usuário do Auth ao registro na tabela `usuarios`:

4. Vá em **SQL Editor** e rode (troque o e-mail pelo seu):

   ```sql
   insert into usuarios (email, nome, nivel, precisa_trocar_senha, ativo)
   values ('joao.gontijo@saude.mg.gov.br', 'João', 'dcc', true, true)
   on conflict (email) do update set nivel = excluded.nivel;
   ```

   (Coloquei nível `dcc` para você ter acesso amplo no teste. Ajuste
   se quiser. Os níveis possíveis: gabinete, subsecretario,
   ponto_focal, dcc.)

**Como testar:** em Table Editor → `usuarios`, seu registro deve estar
lá com o e-mail e o nível.

---

## ETAPA 4 — Testar o login no sistema (AINDA sem trancar)

Neste ponto o sistema já usa o Auth para login, mas as permissões
ainda estão "abertas" (então nada quebra se algo der errado).

1. Abra o **sistema-novo.html**.
2. Na tela de login, digite seu e-mail e a senha provisória.
3. Deve aparecer a tela **"Crie sua senha"** (primeiro acesso).
4. Defina sua senha nova (mínimo 6 caracteres) e confirme.
5. Você deve ser direcionado para a tela do seu nível (ex.: DCC).

**Se funcionar:** o Auth está operando! Pode seguir.
**Se der erro:** me copie a mensagem exata que eu ajusto. NÃO siga
para a Etapa 5 até o login funcionar.

---

## ETAPA 5 — Cadastrar os demais usuários

Com o login testado, cadastre as pessoas reais. Para cada uma, o
processo é o mesmo da Etapa 3:

**a) Criar no Auth** (Authentication → Users → Add user):
   e-mail institucional + senha provisória + Auto Confirm.

**b) Vincular na tabela** (SQL Editor) — exemplos:

```sql
-- Subsecretária de Gestão e Finanças (vê só a subsecretaria dela)
insert into usuarios (email, nome, nivel, subsecretaria, precisa_trocar_senha, ativo)
values ('subgf@saude.mg.gov.br', 'Nome', 'subsecretario', 'SUBGF', true, true)
on conflict (email) do update set nivel=excluded.nivel, subsecretaria=excluded.subsecretaria;

-- Ponto focal de uma superintendência (vê só a área dele)
insert into usuarios (email, nome, nivel, subsecretaria, superintendencia, precisa_trocar_senha, ativo)
values ('fulano@saude.mg.gov.br', 'Nome', 'ponto_focal', 'SUBVS', 'DVAST', true, true)
on conflict (email) do update set nivel=excluded.nivel, superintendencia=excluded.superintendencia;

-- Gabinete (vê tudo)
insert into usuarios (email, nome, nivel, precisa_trocar_senha, ativo)
values ('gabinete@saude.mg.gov.br', 'Nome', 'gabinete', true, true)
on conflict (email) do update set nivel=excluded.nivel;

-- DCC (vê tudo, valida)
insert into usuarios (email, nome, nivel, precisa_trocar_senha, ativo)
values ('dcc@saude.mg.gov.br', 'Nome', 'dcc', true, true)
on conflict (email) do update set nivel=excluded.nivel;
```

Cada pessoa, no primeiro login, troca a própria senha.

**Como testar:** entre com um usuário de cada tipo e confira que cada
um vê só o que deve (o ponto focal só a área dele, etc.).

---

## ETAPA 6 — TRANCAR o sistema com as permissões finas (05_permissoes_rls.sql)

**Só faça esta etapa quando os logins da Etapa 4 e 5 estiverem
funcionando.** Este é o passo que fecha a segurança de verdade.

1. **SQL Editor** → cole todo o **05_permissoes_rls.sql** → **Run**.
2. A partir daqui, só quem está logado com senha acessa os dados, e
   cada um vê apenas o seu escopo — garantido no próprio banco.

**Como testar:** faça logout e login de novo. Tudo deve continuar
funcionando, mas agora protegido. Se abrir o sistema sem logar, não
deve conseguir ver dado nenhum.

**Se algo quebrar aqui:** me avise imediatamente com a mensagem de
erro. Como medida de segurança, dá para reverter rodando de novo o
`02_permissoes.sql` (que reabre o acesso), voltando ao estado
anterior enquanto ajustamos.

---

## Resumo da ordem
1. 04_auth.sql (prepara tabela)
2. Ligar Email no Auth + desligar confirmação
3. Criar 1 usuário de teste (Auth + tabela)
4. Testar login no sistema ← só avança se funcionar
5. Cadastrar os demais usuários
6. 05_permissoes_rls.sql (trancar) ← último passo

Qualquer erro em qualquer etapa, me chame com a mensagem exata.
