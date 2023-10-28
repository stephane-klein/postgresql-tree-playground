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

## Two implementation

This playground implement two data model to store "folder" tree:

- a data model based on `parent/child/ relationship (use `parent_id` field)
- a data model based on [`ltree` extension](https://www.postgresql.org/docs/current/ltree.html)

## Getting start

```sh
$ docker compose up -d --wait
$ ./scripts/seed.sh
$ ./scripts/fixtures.sh
$ ./scripts/enter-in-pg.sh
```

### Play with `parent/child/ relationship implementation

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

### Play with `ltree` implementation

Get all `folder_a` children:

```
postgres@127:postgres> WITH _folder AS (
     SELECT path
       FROM public.ltree_folders
      WHERE id=1 -- <= id of "folder_a"
      LIMIT 1
 )
 SELECT
     id,
     name
 FROM
     public.ltree_folders
 WHERE
     (path <@ (SELECT path FROM _folder)) AND
     (path <> (SELECT path FROM _folder));
+----+-------------+
| id | name        |
|----+-------------|
| 2  | folder_aa   |
| 3  | folder_aaa  |
| 4  | folder_aab  |
| 5  | folder_aac  |
| 6  | folder_ab   |
| 7  | folder_ac   |
| 8  | folder_ad   |
| 9  | folder_ada  |
| 10 | folder_adb  |
| 11 | folder_adc  |
| 12 | folder_adca |
+----+-------------+
SELECT 11
Time: 0.005s
```

Gel all immediate children of `folder_a`:

```
postgres@127:postgres> select * from public.ltree_folders where path ~ '1.*{1}';
+----+------+-----------+
| id | path | name      |
|----+------+-----------|
| 2  | 1.1  | folder_aa |
| 6  | 1.2  | folder_ab |
| 7  | 1.3  | folder_ac |
| 8  | 1.4  | folder_ad |
+----+------+-----------+
SELECT 4
Time: 0.004s
```

## Ressources

- [Tree data as a nested list redux](https://schinckel.net/2017/07/01/tree-data-as-a-nested-list-redux/)
- [Hierarchical structures in PostgreSQL (with ltree)](https://tudborg.com/posts/2022-02-04-postgres-hierarchical-data-with-ltree/)
- [Manipulating Trees Using SQL and the Postgres LTREE Extension](https://patshaughnessy.net/2017/12/14/manipulating-trees-using-sql-and-the-postgres-ltree-extension)
