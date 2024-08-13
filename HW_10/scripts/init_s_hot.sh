#!/bin/bash

# Replica settings
echo "listen_addresses = '*'" | tee -a /var/lib/postgresql/data/postgresql.conf
echo "hot_standby = on" | tee -a /var/lib/postgresql/data/postgresql.conf

echo "host all all 0.0.0.0/0 md5" | tee -a /var/lib/postgresql/data/pg_hba.conf
echo "host replication all 0.0.0.0/0 md5" | tee -a /var/lib/postgresql/data/pg_hba.conf
