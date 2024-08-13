#!/bin/bash

# Master settings
echo "listen_addresses = '*'" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "wal_level = 'replica'" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "max_wal_senders = 10" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "max_replication_slots = 10" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "hot_standby = on" | tee -a /var/lib/postgresql/data/postgresql.conf

echo "host all all 0.0.0.0/0 md5" | tee -a /var/lib/postgresql/data/pg_hba.conf
echo "host replication all 0.0.0.0/0 md5" | tee -a /var/lib/postgresql/data/pg_hba.conf

# Prepare database
psql -U postgres -c "CREATE DATABASE $PR_REPL_DB"
psql -U postgres -d replication -c "CREATE USER rep_user REPLICATION LOGIN PASSWORD 'rep_pass'"
psql -U postgres -d replication -c "CREATE TABLE test (content text)"
psql -U postgres -d replication -c "CREATE TABLE test2 (content text)"