FROM postgres as base

FROM base as with-pgtap

RUN apt-get update \
      && apt-cache showpkg pgtap \
      && apt-get install -y  \
           postgresql-$PG_MAJOR-pgtap \
      && rm -rf /var/lib/apt/lists/*

FROM base as main
