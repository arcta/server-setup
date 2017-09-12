#!/bin/bash

echo "
Setting psql user with PostGIS extention ..."
sudo -u postgres bash -c "psql -c \"CREATE USER $DATAUSER WITH PASSWORD '$PSQL_PASS';\""
sudo -u postgres createdb -O $DATAUSER $DATABASE
sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" $DATABASE
echo "Done"
