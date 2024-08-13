#!/bin/bash

# Base settings
echo "listen_addresses = '*'" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "wal_level = 'logical'" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "max_wal_senders = 10" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "max_replication_slots = 10" | tee -a /var/lib/postgresql/data/postgresql.conf

echo "host all all 172.19.0.0/16 md5" | tee -a /var/lib/postgresql/data/pg_hba.conf
echo "host replication all 172.19.0.0/16 md5" | tee -a /var/lib/postgresql/data/pg_hba.conf

# Prepare database
psql -U postgres -c "CREATE USER rep_user REPLICATION LOGIN ENCRYPTED PASSWORD 'rep_pass'"
psql -U postgres -c "CREATE DATABASE replication"
psql -U postgres -d replication -c "CREATE TABLE test (content text)"
psql -U postgres -d replication -c "CREATE TABLE test2 (content text)"