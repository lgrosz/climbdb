FROM postgres as base

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-3 \
      && apt-get install -y  \
           postgresql-$PG_MAJOR-postgis-3 \
           postgresql-$PG_MAJOR-postgis-3-scripts \
      && rm -rf /var/lib/apt/lists/*

FROM base as with-pgtap

RUN apt-get update \
      && apt-cache showpkg pgtap \
      && apt-get install -y  \
           postgresql-$PG_MAJOR-pgtap \
      && rm -rf /var/lib/apt/lists/*

FROM base as main
