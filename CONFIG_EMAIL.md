# Configurar o "Esqueci minha senha" no Supabase

O código já está pronto no sistema. Falta configurar 2 coisas no
Supabase para o e-mail de redefinição funcionar.

---

## PASSO 1 — Definir a URL de redirecionamento

Quando a pessoa clica no link do e-mail, ela precisa voltar para o
seu sistema. Então:

1. No Supabase: **Authentication** → **URL Configuration**
   (ou **Settings** dentro de Authentication).
2. No campo **Site URL**, coloque o endereço do seu sistema no
   Vercel (ex.: https://governanca-compras.vercel.app).
3. Em **Redirect URLs**, adicione o mesmo endereço (e, se quiser,
   com /* no final: https://seu-endereco.vercel.app/*).
4. Salve.

---

## PASSO 2 — Conferir que o e-mail está ativo

1. **Authentication** → **Providers** → **Email**: confirme que
   está habilitado.
2. **Authentication** → **Email Templates**: existe um template de
   "Reset Password". Pode deixar o padrão (funciona) ou personalizar
   o texto depois.

---

## PASSO 3 — Testar

1. No sistema (no ar), tela de login, digite um e-mail cadastrado.
2. Clique em "Esqueci minha senha".
3. Deve aparecer a mensagem de confirmação.
4. Verifique a caixa de entrada (e o SPAM) desse e-mail — o link
   de redefinição deve chegar.

---

## IMPORTANTE — limite do e-mail gratuito

O envio de e-mail embutido do Supabase tem limite baixo (~3-4 por
hora no plano gratuito). Para "esqueci senha" ocasional, dá conta.
Se um dia precisar de volume, configuramos um serviço de e-mail
profissional (ex.: Resend, SendGrid) — me avise que eu te guio.

Qualquer erro, me chame.
