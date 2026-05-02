# Sample data

A small set of sample data for development and manual testing.

## Files

sample.sql
: Minimal sample data covering some common uses.

clear.sql
: Truncates all `climb` tables. Used to easily clear a database. Helpful for development. Use caution.

## Loading the sample data

Deploy the schema first, then:

```sh
psql -f seeds/sample.sql
```

To reset to an empty database before reloading:

```sh
psql -f seeds/clear.sql
psql -f seeds/sample.sql
```

