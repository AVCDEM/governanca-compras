# Roteiro — Publicar no Vercel

O sistema é um único arquivo HTML, então publicar é rápido.
Siga na ordem.

---

## PREPARAÇÃO — Renomear o arquivo para index.html

O Vercel (e a web em geral) espera que a página principal se chame
**index.html**. Então:

1. Baixe o **sistema-novo.html** (a versão sem a barra de demo).
2. Renomeie o arquivo para **index.html**.
3. Coloque ele sozinho numa pasta (ex.: uma pasta chamada
   "governanca-compras"). Só esse arquivo dentro dela.

---

## PASSO 1 — Criar conta no Vercel (se ainda não tiver)

1. Acesse **vercel.com**.
2. Clique em **Sign Up** (ou Login, se já tiver).
3. Pode entrar com e-mail ou conta GitHub/Google — o que preferir.
   (Para e-mail institucional, o cadastro por e-mail funciona bem.)

---

## PASSO 2 — Publicar (fazer o "deploy")

Forma mais simples, sem precisar de Git:

1. No painel do Vercel, clique em **Add New...** → **Project**.
2. Procure a opção de **importar/arrastar** — no Vercel atual, há
   um caminho chamado **"Deploy"** onde você pode **arrastar a pasta**
   (a que tem o index.html dentro) direto para a área indicada.
   - Se não achar o arrastar, use: **Add New → Project → Deploy
     without Git** / ou a opção de upload manual.
3. Arraste a **pasta** (não o arquivo solto) para a área de upload.
4. Dê um nome ao projeto (ex.: governanca-compras).
5. Clique em **Deploy**.

Em poucos segundos, o Vercel te dá um **endereço** (algo como
`governanca-compras.vercel.app`). Esse é o link do seu sistema no ar.

---

## PASSO 3 — Testar no ar

1. Abra o endereço que o Vercel gerou.
2. Deve aparecer a tela de **login** do sistema.
3. Faça login com um usuário que você já criou.
4. Confirme que tudo funciona igual ao que testou localmente.

Se funcionar: **está no ar!** 🎉

---

## Segurança — o banco está trancado

O "trancar" foi feito em 18/08/2026, com o **05b_permissoes_rls_corrigido.sql**
(e não com o 05_permissoes_rls.sql, que tinha três falhas — veja o
cabeçalho do 05b). O período "aberto" descrito nas versões antigas
deste roteiro acabou.

O que vale hoje:
- Só quem está autenticado lê os dados; cada um vê apenas o escopo
  do seu nível.
- Escrita é de Ponto Focal e DCC. Gabinete e Subsecretaria só leem.
- Para reabrir tudo em caso de emergência: rode o **02_permissoes.sql**.
  Reverte em segundos, sem perder dado.

Conferência rápida de que continua trancado — cole numa aba anônima:

    https://tatinrolrssjervuykej.supabase.co/rest/v1/processos?select=codigo&limit=1&apikey=CHAVE_PUBLICA

Deve responder `permission denied for table processos`. Se responder
com dados, o banco voltou a ficar aberto.

## O que NÃO pode ir para a web

O repositório guarda os .sql com os processos reais, o histórico e os
e-mails dos usuários. O **.vercelignore** garante que só o index.html
seja publicado. Se um dia alguém publicar arrastando a pasta na mão,
crie uma pasta separada com o index.html sozinho dentro.

---

## Dica: atualizar o sistema depois

Quando a gente fizer ajustes (ex.: a calculadora v2), você recebe um
novo index.html e faz o mesmo processo (Add New → Deploy, arrastar a
pasta). O Vercel atualiza o mesmo endereço. Simples.

Qualquer dúvida ou travamento em algum passo, me chame.
