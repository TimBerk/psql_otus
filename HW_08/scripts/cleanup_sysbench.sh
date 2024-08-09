#!/bin/bash

# Database connection parameters
DB_NAME="stest"
DB_USER="suser"
DB_PASSWORD="spass"
DB_HOST="localhost"
DB_PORT="5432"

# Sysbench parameters
TABLES=10

# Cleanup the test
sysbench --db-driver=pgsql --pgsql-db=$DB_NAME --pgsql-user=$DB_USER --pgsql-password=$DB_PASSWORD --pgsql-host=$DB_HOST --pgsql-port=$DB_PORT \
    --tables=$TABLES oltp_common cleanup