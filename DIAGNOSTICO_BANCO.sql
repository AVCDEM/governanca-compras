-- ============================================================
-- DIAGNÓSTICO COMPLETO DO BANCO — Governança em Compras
-- ============================================================
-- Para que serve: gerar, numa única consulta, um retrato inteiro
-- do banco (tabelas, colunas, chaves, índices, RLS, policies,
-- funções, gatilhos e tamanho das tabelas) para conferir se o
-- que está no ar bate com os arquivos .sql do repositório.
--
-- COMO USAR
--   1. Supabase → SQL Editor → New query
--   2. Cole este arquivo inteiro e clique em RUN
--   3. No resultado, clique em "Download CSV"
--   4. Salve o arquivo na pasta do projeto (governanca-compras)
--
-- NÃO lê nenhum dado de processo, usuário ou e-mail — só a
-- ESTRUTURA. Nenhuma informação pessoal sai do banco.
-- É somente leitura: não altera nada.
-- ============================================================

select linha from (

  -- 1. TABELAS E COLUNAS -------------------------------------
  select 1 as secao, c.table_name || '.' || lpad(c.ordinal_position::text, 3, '0') as ord,
         'COLUNA | ' || c.table_name || ' | ' || c.column_name ||
         ' | ' || c.data_type ||
         ' | ' || case when c.is_nullable = 'YES' then 'nulo ok' else 'NOT NULL' end ||
         coalesce(' | default: ' || c.column_default, '') as linha
  from information_schema.columns c
  join information_schema.tables t
    on t.table_schema = c.table_schema and t.table_name = c.table_name
  where c.table_schema = 'public' and t.table_type = 'BASE TABLE'

  union all
  -- 2. CHAVES (primária, estrangeira, única) -----------------
  select 2, tc.table_name || '.' || tc.constraint_name,
         'CHAVE | ' || tc.table_name || ' | ' || tc.constraint_type ||
         ' | ' || coalesce(kcu.column_name, '?') ||
         coalesce(' -> ' || ccu.table_name || '.' || ccu.column_name, '')
  from information_schema.table_constraints tc
  left join information_schema.key_column_usage kcu
    on kcu.constraint_name = tc.constraint_name and kcu.table_schema = tc.table_schema
  left join information_schema.constraint_column_usage ccu
    on ccu.constraint_name = tc.constraint_name and tc.constraint_type = 'FOREIGN KEY'
  where tc.table_schema = 'public' and tc.constraint_type in ('PRIMARY KEY','FOREIGN KEY','UNIQUE')

  union all
  -- 3. ÍNDICES ----------------------------------------------
  select 3, tablename || '.' || indexname,
         'INDICE | ' || tablename || ' | ' || indexname || ' | ' || indexdef
  from pg_indexes where schemaname = 'public'

  union all
  -- 4. RLS LIGADO OU DESLIGADO ------------------------------
  select 4, relname,
         'RLS | ' || relname || ' | ' ||
         case when relrowsecurity then 'LIGADO' else '*** DESLIGADO ***' end
  from pg_class
  where relnamespace = 'public'::regnamespace and relkind = 'r'

  union all
  -- 5. POLICIES DE SEGURANÇA --------------------------------
  select 5, tablename || '.' || policyname,
         'POLICY | ' || tablename || ' | ' || policyname ||
         ' | ' || cmd ||
         ' | papeis: ' || array_to_string(roles, ',') ||
         ' | using: ' || coalesce(qual, '-') ||
         ' | check: ' || coalesce(with_check, '-')
  from pg_policies where schemaname = 'public'

  union all
  -- 6. FUNÇÕES ----------------------------------------------
  select 6, p.proname,
         'FUNCAO | ' || p.proname ||
         ' | retorna: ' || pg_get_function_result(p.oid) ||
         ' | args: ' || coalesce(pg_get_function_arguments(p.oid), '-') ||
         ' | security: ' || case when p.prosecdef then 'DEFINER' else 'INVOKER' end
  from pg_proc p
  where p.pronamespace = 'public'::regnamespace

  union all
  -- 7. GATILHOS ---------------------------------------------
  select 7, c.relname || '.' || t.tgname,
         'TRIGGER | ' || c.relname || ' | ' || t.tgname || ' | ' || pg_get_triggerdef(t.oid)
  from pg_trigger t
  join pg_class c on c.oid = t.tgrelid
  where c.relnamespace = 'public'::regnamespace and not t.tgisinternal

  union all
  -- 8. VOLUME (estimativa, sem ler os dados) -----------------
  select 8, relname,
         'VOLUME | ' || relname ||
         ' | linhas aprox: ' || greatest(reltuples, 0)::bigint ||
         ' | tamanho: ' || pg_size_pretty(pg_total_relation_size(oid))
  from pg_class
  where relnamespace = 'public'::regnamespace and relkind = 'r'

  union all
  -- 9. VERSÃO -----------------------------------------------
  select 9, 'zz', 'POSTGRES | ' || version()

) t
order by secao, ord;
