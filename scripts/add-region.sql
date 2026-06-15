\echo 'Add a new region'
\prompt 'Name: ' name
\set default_slug `scripts/slug.sh :'name'`
\set slug_prompt 'Slug [' :default_slug ']: '
\prompt :slug_prompt slug
select coalesce(nullif(:'slug', ''), :'default_slug') as slug
\gset

BEGIN;

INSERT INTO climb.regions (
  name, slug
) VALUES (
  nullif(:'name', ''),
  nullif(:'slug', '')
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif

