\echo 'Add a new climber'
\prompt 'First Name: ' first_name
\prompt 'Last Name: ' last_name
\prompt 'Slug: ' slug

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

