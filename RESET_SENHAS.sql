-- ============================================================
-- RESET_SENHAS.sql
-- Volta TODOS os usuários para a senha padrão 'Mudar@2026'
-- e marca que precisam trocar no primeiro acesso.
-- Rode no PROJETO CERTO (tatinrolrssjervuykej), no SQL Editor.
--
-- Use quando quiser "zerar" os acessos para um novo teste/lançamento.
-- É seguro rodar quantas vezes quiser.
-- ============================================================

create extension if not exists pgcrypto;

-- 1) Redefine a senha de todos para 'Mudar@2026' no Auth
update auth.users
set encrypted_password = crypt('Mudar@2026', gen_salt('bf')),
    updated_at = now()
where email in (select email from usuarios);

-- 2) Marca todos como "precisa trocar no primeiro acesso"
update usuarios
set precisa_trocar_senha = true;

-- 3) Verificação: quantos ficaram na senha padrão
select count(*) as usuarios_resetados from usuarios where precisa_trocar_senha = true;
