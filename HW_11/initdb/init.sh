#!/bin/bash

psql -U postgres -f /docker-entrypoint-initdb.d/medium.sql
