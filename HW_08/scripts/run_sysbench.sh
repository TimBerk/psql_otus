#!/bin/bash

# Database connection parameters
DB_NAME="stest"
DB_USER="suser"
DB_PASSWORD="spass"
DB_HOST="localhost"
DB_PORT="5432"

# Sysbench parameters
TABLE_SIZE=1000000
TABLES=10
THREADS=6
TIME=60
REPORT_INTERVAL=10

# Run the test
sysbench --db-driver=pgsql --pgsql-db=$DB_NAME --pgsql-user=$DB_USER --pgsql-password=$DB_PASSWORD --pgsql-host=$DB_HOST --pgsql-port=$DB_PORT \
    --tables=$TABLES --table-size=$TABLE_SIZE --threads=$THREADS --time=$TIME --report-interval=$REPORT_INTERVAL oltp_read_write run