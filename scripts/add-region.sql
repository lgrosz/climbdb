\echo 'Add a new region'
\prompt 'Name: ' name
\prompt 'Slug: ' slug

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

