#!/bin/bash

USER=ckan
PASSWORD=ckan
DATABASE=ckan

service postgresql-9.3 start
echo "CREATE ROLE "$USER" WITH LOGIN CREATEDB PASSWORD '"$PASSWORD"'" | su - postgres -c 'psql -U postgres'
PGPASSWORD=$PASSWORD createdb -U $USER -O $USER $DATABASE -E utf-8
echo "ALTER USER postgres WITH PASSWORD 'postgres'" | su - postgres -c 'psql -U postgres'
