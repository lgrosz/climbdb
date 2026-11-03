\echo 'Add a new area'

\prompt 'Name: ' name
\set default_slug `scripts/slug.sh :'name'`
\set slug_prompt 'Slug [' :default_slug ']: '
\prompt :slug_prompt slug
select coalesce(nullif(:'slug', ''), :'default_slug') as slug
\gset

\prompt 'Geometry: ' raw_geom

select :'raw_geom' != '' as geom_provided
\gset

\if :geom_provided
  -- Parse provided geometry
  \set geom `scripts/geom.sh :'raw_geom'`

  select :SHELL_EXIT_CODE != 0 as geom_invalid
  \gset

  \if :geom_invalid
    \echo 'Invalid geometry format'
    \quit
  \endif
\else
  \set geom ''
\endif

\set parent_row `scripts/select.sh :'DBNAME' area -- --prompt="Select parent > "`
\set parent_id `echo :'parent_row' | cut -sf1`

BEGIN;

INSERT INTO climb.areas (
  name,
  slug,
  geom,
  parent_id
) VALUES (
  nullif(:'name', ''),
  nullif(:'slug', ''),
  nullif(:'geom', ''),
  nullif(:'parent_id', '')::uuid
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif
