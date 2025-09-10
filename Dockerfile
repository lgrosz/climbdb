FROM postgres as base

RUN apt-get update \
      && apt-get install -y  \
           autoconf \
           automake \
           build-essential \
           libgdal-dev \
           libgeos-dev \
           libjson-c-dev \
           libprotobuf-c-dev \
           libtool \
           libxml2-dev \
           pkg-config \
           postgresql-server-dev-$PG_MAJOR \
           proj-bin \
           protobuf-c-compiler \
      && rm -rf /var/lib/apt/lists/*

COPY --from=pg_climb / /tmp/pg_climb
WORKDIR /tmp/pg_climb
RUN make
RUN make install

COPY --from=postgis / /tmp/postgis
WORKDIR /tmp/postgis
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

FROM base as with-pgtap

RUN apt-get update \
      && apt-cache showpkg pgtap \
      && apt-get install -y  \
           postgresql-$PG_MAJOR-pgtap \
      && rm -rf /var/lib/apt/lists/*

FROM base as main
