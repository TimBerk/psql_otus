#!/bin/bash

echo "shared_preload_libraries = 'pg_stat_statements'" | tee -a /var/lib/postgresql/data/postgresql.conf