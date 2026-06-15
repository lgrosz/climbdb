\echo 'Add a new climber'
\prompt 'First Name: ' first_name
\prompt 'Last Name: ' last_name
\set default_slug `scripts/slug.sh :'first_name' :'last_name'`
\set slug_prompt 'Slug [' :default_slug ']: '
\prompt :slug_prompt slug
select coalesce(nullif(:'slug', ''), :'default_slug') as slug
\gset

BEGIN;

INSERT INTO climb.climbers (
  first_name,
  last_name,
  slug
) VALUES (
  :'first_name',
  :'last_name',
  nullif(:'slug', '')
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif

