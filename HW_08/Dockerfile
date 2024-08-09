# Use the official PostgreSQL 16.2 Alpine image as the base image
FROM postgres:16.2-alpine

RUN mkdir /tmp/sysbench
COPY ./tmp /tmp/sysbench

# Install necessary dependencies and sysbench
RUN apk update && \
    apk add --no-cache asciinema nano \
    build-base make automake autoconf libtool pkgconfig postgresql-dev curl \
    && \
    cd /tmp/sysbench && \
    unzip master.zip && \
    cd sysbench-master && \
    ./autogen.sh && \
    ./configure --with-pgsql --without-mysql && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/sysbench && \
    apk del --no-cache build-base make automake autoconf libtool pkgconfig postgresql-dev curl

COPY scripts/ /home/scripts/
RUN chmod +x /home/scripts/prepare_sysbench.sh \
    && chmod +x /home/scripts/run_sysbench.sh \
    && chmod +x /home/scripts/cleanup_sysbench.sh