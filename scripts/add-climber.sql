\echo 'Add a new climber'
\prompt 'First Name: ' first_name
\prompt 'Last Name: ' last_name
\prompt 'Slug: ' slug

\echo 'Preview:'
select
  :'first_name' as first_name,
  :'last_name' as last_name,
  nullif(:'slug','') as slug;

\prompt 'Insert? (y/N): ' confirm

\if :confirm
  insert into climb.climbers (
    first_name,
    last_name,
    slug
  ) values (
    :'first_name',
    :'last_name',
    nullif(:'slug', '')
  );
\else
  \echo 'Canceled'
\endif

