postgres
========

```bash
# shellcheck shell=bash

# create user

psql --host 127.0.0.1 --username postgres
create user demo with encrypted password 'impl';
create database demo;
grant all privileges on database demo to demo;

# dump database

pg_dump --host 127.0.0.1 --username demo --schema-only demo
pg_dump --host 127.0.0.1 --username demo --data-only demo
pg_dump --host 127.0.0.1 --username demo --data-only --inserts demo
```
