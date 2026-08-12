-- ============================================================
-- GOVERNANÇA EM COMPRAS — Vínculo dos usuários (nível + área)
-- ------------------------------------------------------------
-- Rode DEPOIS de criar os acessos no Authentication.
-- Insere/atualiza cada usuário na tabela 'usuarios' com seu
-- nível e área (subsecretaria/superintendência/diretoria).
-- Marca todos para trocar a senha no primeiro acesso.
-- ============================================================

insert into public.usuarios (email, nome, nivel, subsecretaria, superintendencia, diretoria, precisa_trocar_senha, ativo) values
  ('joao.gontijo@saude.mg.gov.br','João Vítor Gontijo','dcc','AEST',null,null,true,true),
  ('carolina.ribeiro@saude.mg.gov.br','Carolina Ribeiro','ponto_focal','AEST',null,null,true,true),
  ('maria.gusmao@saude.mg.gov.br','Maria Isabela Gusmão','ponto_focal','ASCOM',null,null,true,true),
  ('fernanda.xavier@saude.mg.gov.br','Fernanda Maria Xavier','ponto_focal','ASCOM',null,null,true,true),
  ('elisa.paschoal@saude.mg.gov.br','Elisa Paschoal','ponto_focal','ASPAR',null,null,true,true),
  ('eliana.mascarenhas@saude.mg.gov.br','Eliana Mascarenhas','ponto_focal','ASPAR',null,null,true,true),
  ('vander.oliveira@saude.mg.gov.br','Vander Oliveira','ponto_focal','ATI',null,null,true,true),
  ('evandro.lana@saude.mg.gov.br','Evandro Thiago Lana','ponto_focal','ATI',null,null,true,true),
  ('fausniel.brandao@saude.mg.gov.br','Fausniel Brandão','ponto_focal','ATI',null,null,true,true),
  ('luis.santos@saude.mg.gov.br','Luis Guilherme Santos','ponto_focal','SUBASS',null,null,true,true),
  ('ana.trindade@saude.mg.gov.br','Ana Paula Trindade','ponto_focal','SUBASS',null,null,true,true),
  ('subass@saude.mg.gov.br','SUBASS','subsecretario','SUBASS',null,null,true,true),
  ('claudiane.silva@saude.mg.gov.br','Claudiane Silva','ponto_focal','SUBASS','SAF',null,true,true),
  ('edvania.oliveira@saude.mg.gov.br','Edvania Ramos de Oliveira','ponto_focal','SUBASS','SAF',null,true,true),
  ('amanda.neves@saude.mg.gov.br','Amanda Carolliny Neves','ponto_focal','SUBASS','SRA',null,true,true),
  ('stiferson.alencar@saude.mg.gov.br','Stiferson Almino Alencar','ponto_focal','SUBASS','SRA',null,true,true),
  ('daianna.rodrigues@saude.mg.gov.br','Daianna Rodrigues','ponto_focal','SUBASS','SJUD',null,true,true),
  ('aline.lara@saude.mg.gov.br','Aline Lara','ponto_focal','SUBASS','SJUD',null,true,true),
  ('suelen.novy@saude.mg.gov.br','Suelen Novy Santos','ponto_focal','SUBGF',null,null,true,true),
  ('lorena.stefany.santos@saude.mg.gov.br','Lorena Stefany','ponto_focal','SUBGF',null,null,true,true),
  ('subgf@saude.mg.gov.br','SUBGF','subsecretario','SUBGF',null,null,true,true),
  ('matheus.melo@saude.mg.gov.br','Matheus Gomes de Melo','ponto_focal','SUBGF','SPF',null,true,true),
  ('jacqueline.bueno@saude.mg.gov.br','Jacqueline Martins Bueno','ponto_focal','SUBGF','SPF',null,true,true),
  ('yuri.moura@saude.mg.gov.br','Yuri de Aguiar Moura','ponto_focal','SUBGF','SGDP',null,true,true),
  ('eduardo.resende@saude.mg.gov.br','Eduardo Alberto Silva Resende','ponto_focal','SUBGF','SGDP',null,true,true),
  ('natalia.cardoso@saude.mg.gov.br','Natália Cristina Cardoso','ponto_focal','SUBGF','SILC',null,true,true),
  ('waldineia.paz@saude.mg.gov.br','Waldineia Dias Paz','ponto_focal','SUBGF','SILC',null,true,true),
  ('subras@saude.mg.gov.br','SUBRAS','subsecretario','SUBRAS',null,null,true,true),
  ('augusto.ananias@saude.mg.gov.br','Augusto Ananias','ponto_focal','SUBRAS','SAPS',null,true,true),
  ('lilian.kirita@saude.mg.gov.br','Lilian Kirita','ponto_focal','SUBRAS','SAPS',null,true,true),
  ('fernanda.santos@saude.mg.gov.br','Fernanda Santos Pereira','ponto_focal','SUBRAS','SAE',null,true,true),
  ('bruno.furtado@saude.mg.gov.br','Bruno Crispim Furtado','ponto_focal','SUBRAS','SAE',null,true,true),
  ('audileia.santos@saude.mg.gov.br','Audiléia Alves da Paixão Santos','ponto_focal','SUBRAS','SPAH',null,true,true),
  ('elisa.fonseca@saude.mg.gov.br','Ana Elisa Machado da Fonseca','ponto_focal','SUBRAS','SPAH',null,true,true),
  ('ronan.ribeiro@saude.mg.gov.br','Ronan Ribeiro','ponto_focal','SUBVS',null,null,true,true),
  ('rita.barros@saude.mg.gov.br','Rita Narciso de Barros','ponto_focal','SUBVS',null,null,true,true),
  ('subvs@saude.mg.gov.br','SUBVS','subsecretario','SUBVS',null,null,true,true),
  ('dc@saude.mg.gov.br','DCC','dcc','SUBGF','SILC','DCC',true,true),
  ('dlog@saude.mg.gov.br','DLOG','ponto_focal','SUBGF','SILC','DLOG',true,true),
  ('dpat@saude.mg.gov.br','DPAT','ponto_focal','SUBGF','SILC','DPAT',true,true),
  ('gabinete@saude.mg.gov.br','GAB','gabinete','GAB',null,null,true,true),
  ('paulo.falcao@saude.mg.gov.br','Paulo Falcão','dcc','AEST',null,null,true,true)
on conflict (email) do update set
  nome=excluded.nome, nivel=excluded.nivel,
  subsecretaria=excluded.subsecretaria,
  superintendencia=excluded.superintendencia,
  diretoria=excluded.diretoria,
  ativo=true;

-- ============================================================
-- Pronto. 42 usuários vinculados.
-- ============================================================
