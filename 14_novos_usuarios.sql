-- ============================================================
-- GOVERNANÇA EM COMPRAS — Adicionar 2 usuários DCC
-- ------------------------------------------------------------
-- Rayssa Pacheco e Arthur Miranda, ambos nível DCC (veem tudo).
--
-- ANTES de rodar este SQL, crie os acessos no painel:
--   Authentication > Users > Add user
--   - rayssa.santos@saude.mg.gov.br  | senha: Mudar@2026 | Auto Confirm
--   - arthur.alves@saude.mg.gov.br   | senha: Mudar@2026 | Auto Confirm
--
-- Depois rode este SQL (no PROJETO CERTO).
-- ============================================================

insert into public.usuarios (email, nome, nivel, precisa_trocar_senha, ativo) values
  ('rayssa.santos@saude.mg.gov.br', 'Rayssa Pacheco', 'dcc', true, true),
  ('arthur.alves@saude.mg.gov.br',  'Arthur Miranda', 'dcc', true, true)
on conflict (email) do update set
  nome=excluded.nome, nivel=excluded.nivel, ativo=true;

-- ============================================================
-- Pronto. No primeiro acesso, cada um cria a própria senha.
-- ============================================================
