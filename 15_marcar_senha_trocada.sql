-- ============================================================
-- GOVERNANÇA EM COMPRAS — Corrigir "senha pede trocar sempre"
-- ------------------------------------------------------------
-- Rode no PROJETO CERTO (tatinrolrssjervuykej).
-- Cria uma função segura que marca precisa_trocar_senha=false
-- para o usuário logado. Resolve o loop de "criar senha nova".
-- ============================================================

create or replace function marcar_senha_trocada()
returns void
language sql
security definer
set search_path = public
as $$
  update usuarios
  set precisa_trocar_senha = false
  where auth_id = auth.uid()
     or lower(email) = lower(auth.jwt() ->> 'email');
$$;

grant execute on function marcar_senha_trocada() to authenticated;

-- ============================================================
-- Também garante que o auth_id esteja preenchido (liga a conta
-- de login ao registro na tabela usuarios, pelo e-mail).
-- ============================================================
update usuarios u
set auth_id = a.id
from auth.users a
where lower(u.email) = lower(a.email)
  and (u.auth_id is null or u.auth_id <> a.id);

-- ============================================================
-- Pronto. Rode e depois republique o sistema atualizado.
-- ============================================================
