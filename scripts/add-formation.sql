\echo 'Add a new formation'

\prompt 'Name: ' name
\prompt 'Slug: ' slug

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

\prompt 'Parent (press enter)...' _

-- Search for parent
\set parent_row `scripts/select.sh :'DBNAME' region crag sector`
\set parent_id `echo :'parent_row' | cut -f1`
\set parent_type `echo :'parent_row' | cut -f2`

\echo 'Parent type:' :parent_type
\echo 'Parent id:' :parent_id

select :'parent_type' != '' as parent_is_valid
\gset

\if :parent_is_valid
\else
  -- Doesn't matter what this is because the id is going to be null
  \set parent_type 'region'
\endif

\set parent_col :parent_type'_id'

BEGIN;

INSERT INTO climb.formations (
  name,
  slug,
  geom,
  :parent_col
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

