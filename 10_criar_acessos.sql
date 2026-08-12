-- ============================================================
-- GOVERNANÇA EM COMPRAS — Criar acessos em lote (Auth) — v2
-- ------------------------------------------------------------
-- Versão corrigida: usa "where not exists" em vez de
-- "on conflict" (a tabela auth.users não aceita on conflict email).
-- Rode no SQL Editor. Cria os acessos com senha 'Mudar@2026'.
-- Seguro rodar de novo: só insere quem ainda não existe.
-- ============================================================

create extension if not exists pgcrypto;

-- 1) criar os usuários que ainda não existem
insert into auth.users
  (instance_id, id, aud, role, email, encrypted_password,
   email_confirmed_at, created_at, updated_at,
   raw_app_meta_data, raw_user_meta_data,
   confirmation_token, recovery_token, email_change_token_new, email_change)
select
  '00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated',
  e.email, crypt('Mudar@2026', gen_salt('bf')), now(), now(), now(),
  '{"provider":"email","providers":["email"]}', '{}', '', '', '', ''
from (values
    ('joao.gontijo@saude.mg.gov.br'),
    ('carolina.ribeiro@saude.mg.gov.br'),
    ('maria.gusmao@saude.mg.gov.br'),
    ('fernanda.xavier@saude.mg.gov.br'),
    ('elisa.paschoal@saude.mg.gov.br'),
    ('eliana.mascarenhas@saude.mg.gov.br'),
    ('vander.oliveira@saude.mg.gov.br'),
    ('evandro.lana@saude.mg.gov.br'),
    ('fausniel.brandao@saude.mg.gov.br'),
    ('luis.santos@saude.mg.gov.br'),
    ('ana.trindade@saude.mg.gov.br'),
    ('subass@saude.mg.gov.br'),
    ('claudiane.silva@saude.mg.gov.br'),
    ('edvania.oliveira@saude.mg.gov.br'),
    ('amanda.neves@saude.mg.gov.br'),
    ('stiferson.alencar@saude.mg.gov.br'),
    ('daianna.rodrigues@saude.mg.gov.br'),
    ('aline.lara@saude.mg.gov.br'),
    ('suelen.novy@saude.mg.gov.br'),
    ('lorena.stefany.santos@saude.mg.gov.br'),
    ('subgf@saude.mg.gov.br'),
    ('matheus.melo@saude.mg.gov.br'),
    ('jacqueline.bueno@saude.mg.gov.br'),
    ('yuri.moura@saude.mg.gov.br'),
    ('eduardo.resende@saude.mg.gov.br'),
    ('natalia.cardoso@saude.mg.gov.br'),
    ('waldineia.paz@saude.mg.gov.br'),
    ('subras@saude.mg.gov.br'),
    ('augusto.ananias@saude.mg.gov.br'),
    ('lilian.kirita@saude.mg.gov.br'),
    ('fernanda.santos@saude.mg.gov.br'),
    ('bruno.furtado@saude.mg.gov.br'),
    ('audileia.santos@saude.mg.gov.br'),
    ('elisa.fonseca@saude.mg.gov.br'),
    ('ronan.ribeiro@saude.mg.gov.br'),
    ('rita.barros@saude.mg.gov.br'),
    ('subvs@saude.mg.gov.br'),
    ('dc@saude.mg.gov.br'),
    ('dlog@saude.mg.gov.br'),
    ('dpat@saude.mg.gov.br'),
    ('gabinete@saude.mg.gov.br'),
    ('paulo.falcao@saude.mg.gov.br')
) as e(email)
where not exists (
  select 1 from auth.users u where u.email = e.email
);

-- 2) criar as identidades (necessário para login por e-mail)
insert into auth.identities
  (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
select
  gen_random_uuid(), u.id, u.id::text,
  json_build_object('sub', u.id::text, 'email', u.email),
  'email', now(), now(), now()
from auth.users u
where u.email in (
    'joao.gontijo@saude.mg.gov.br',
    'carolina.ribeiro@saude.mg.gov.br',
    'maria.gusmao@saude.mg.gov.br',
    'fernanda.xavier@saude.mg.gov.br',
    'elisa.paschoal@saude.mg.gov.br',
    'eliana.mascarenhas@saude.mg.gov.br',
    'vander.oliveira@saude.mg.gov.br',
    'evandro.lana@saude.mg.gov.br',
    'fausniel.brandao@saude.mg.gov.br',
    'luis.santos@saude.mg.gov.br',
    'ana.trindade@saude.mg.gov.br',
    'subass@saude.mg.gov.br',
    'claudiane.silva@saude.mg.gov.br',
    'edvania.oliveira@saude.mg.gov.br',
    'amanda.neves@saude.mg.gov.br',
    'stiferson.alencar@saude.mg.gov.br',
    'daianna.rodrigues@saude.mg.gov.br',
    'aline.lara@saude.mg.gov.br',
    'suelen.novy@saude.mg.gov.br',
    'lorena.stefany.santos@saude.mg.gov.br',
    'subgf@saude.mg.gov.br',
    'matheus.melo@saude.mg.gov.br',
    'jacqueline.bueno@saude.mg.gov.br',
    'yuri.moura@saude.mg.gov.br',
    'eduardo.resende@saude.mg.gov.br',
    'natalia.cardoso@saude.mg.gov.br',
    'waldineia.paz@saude.mg.gov.br',
    'subras@saude.mg.gov.br',
    'augusto.ananias@saude.mg.gov.br',
    'lilian.kirita@saude.mg.gov.br',
    'fernanda.santos@saude.mg.gov.br',
    'bruno.furtado@saude.mg.gov.br',
    'audileia.santos@saude.mg.gov.br',
    'elisa.fonseca@saude.mg.gov.br',
    'ronan.ribeiro@saude.mg.gov.br',
    'rita.barros@saude.mg.gov.br',
    'subvs@saude.mg.gov.br',
    'dc@saude.mg.gov.br',
    'dlog@saude.mg.gov.br',
    'dpat@saude.mg.gov.br',
    'gabinete@saude.mg.gov.br',
    'paulo.falcao@saude.mg.gov.br'
)
and not exists (
  select 1 from auth.identities i where i.user_id = u.id and i.provider='email'
);

-- ============================================================
-- Pronto. Depois rode o 09_usuarios_vinculo.sql.
-- ============================================================
