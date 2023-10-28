# PostgreSQL Tree datamodel playground

Issue context (in french): https://github.com/stephane-klein/backlog/issues/335

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/) (tested with `24.0.6`)
- [pgcli](https://www.pgcli.com/)
- `psql` (More info about `psql` [brew package](https://stackoverflow.com/a/49689589/261061))

Run this command to check that everything is installed correctly:

```
$ ./scripts/doctor.sh
docker 24.0.6 >= 24.0.6 installed ✅
psql installed ✅
pgcli installed ✅
```

See [`prerequisites.md`](prerequisites.md) to get more information on how to install this software.

## Note about psql and pgcli

I install both *psql* and *pgcli* for the following reasons:

- I like *pgcli* for autocompletion and multiline vim editor features
- However, *pgcli* don't support ["pipe" feature](https://github.com/dbcli/pgcli/issues/307). That's why I also install *psql*, I use psql to inject files into *PostgreSQL*.

## Getting start

```sh
$ docker compose up -d --wait
$ ./scripts/seed.sh
$ ./scripts/fixtures.sh
$ ./scripts/enter-in-pg.sh
postgres@127:postgres> select * from public.folders;
+----+------------+----------+-----------+
| id | name       | position | parent_id |
|----+------------+----------+-----------|
| 1  | folder_a   | 1        | <null>    |
| 2  | folder_aa  | 1        | 1         |
| 3  | folder_aaa | 1        | 2         |
| 4  | folder_aab | 2        | 2         |
| 5  | folder_aac | 3        | 2         |
| 6  | folder_ab  | 2        | 1         |
| 7  | folder_ac  | 3        | 1         |
+----+------------+----------+-----------+
SELECT 3
Time: 0.007s

postgres@127:postgres> \i get_folders_jsonb_tree.sql
+-------------------------------------------+
| jsonb_pretty                              |
|-------------------------------------------|
| {                                         |
|     "id": 1,                              |
|     "lvl": 0,                             |
|     "name": "folder_a",                   |
|     "children": [                         |
|         {                                 |
|             "id": 6,                      |
|             "lvl": 1,                     |
|             "name": "folder_ab",          |
|             "children": [                 |
|             ],                            |
|             "position": 2,                |
|             "parent_id": 1                |
|         },                                |
|         {                                 |
|             "id": 2,                      |
|             "lvl": 1,                     |
|             "name": "folder_aa",          |
|             "children": [                 |
|                 {                         |
|                     "id": 5,              |
|                     "lvl": 2,             |
|                     "name": "folder_aac", |
|                     "children": [         |
|                     ],                    |
|                     "position": 3,        |
|                     "parent_id": 2        |
|                 },                        |
|                 {                         |
|                     "id": 4,              |
|                     "lvl": 2,             |
|                     "name": "folder_aab", |
|                     "children": [         |
|                     ],                    |
|                     "position": 2,        |
|                     "parent_id": 2        |
|                 },                        |
|                 {                         |
|                     "id": 3,              |
|                     "lvl": 2,             |
|                     "name": "folder_aaa", |
|                     "children": [         |
|                     ],                    |
|                     "position": 1,        |
|                     "parent_id": 2        |
|                 }                         |
|             ],                            |
|             "position": 1,                |
|             "parent_id": 1                |
|         },                                |
|         {                                 |
|             "id": 7,                      |
|             "lvl": 1,                     |
|             "name": "folder_ac",          |
|             "children": [                 |
|             ],                            |
|             "position": 3,                |
|             "parent_id": 1                |
|         }                                 |
|     ],                                    |
|     "position": 1,                        |
|     "parent_id": null                     |
| }                                         |
+-------------------------------------------+
SELECT 1
Time: 0.022s
```

## Ressources

- [Tree data as a nested list redux](https://schinckel.net/2017/07/01/tree-data-as-a-nested-list-redux/)
- [Hierarchical structures in PostgreSQL (with ltree)](https://tudborg.com/posts/2022-02-04-postgres-hierarchical-data-with-ltree/)
