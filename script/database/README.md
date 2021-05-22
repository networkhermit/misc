postgres
========

```bash
# shellcheck shell=bash

# create user

psql --host 127.0.0.1 --port 5432 --username postgres
create user demo password 'impl';
create database demo;
grant all on database demo to demo;

# dump database

pg_dump --host 127.0.0.1 --port 5432 --username postgres --schema-only demo
pg_dump --host 127.0.0.1 --port 5432 --username postgres --data-only --inserts demo
```

```sql
SELECT SCHEMA_NAME,
       relname,
       pg_size_pretty(table_size) AS SIZE,
       table_size
FROM
  (SELECT pg_catalog.pg_namespace.nspname AS SCHEMA_NAME,
          relname,
          pg_relation_size(pg_catalog.pg_class.oid) AS table_size
   FROM pg_catalog.pg_class
   JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid) t
WHERE SCHEMA_NAME NOT LIKE 'pg_%'
ORDER BY table_size DESC;
```
