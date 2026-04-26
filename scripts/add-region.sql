\echo 'Add a new region'
\prompt 'Name: ' name
\prompt 'Slug: ' slug

\echo 'Preview:'
select
  :'name' as name,
  nullif(:'slug','') as slug;

\prompt 'Insert? (y/N): ' confirm

\if :confirm
  insert into climb.regions (
    name,
    slug
  ) values (
    nullif(:'name', ''),
    nullif(:'slug', '')
  );
\else
  \echo 'Canceled'
\endif

