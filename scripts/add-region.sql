\echo 'Add a new region'
\prompt 'Name: ' name
\prompt 'Slug: ' slug

insert into climb.regions (name, slug)
values (:'name', :'slug');
