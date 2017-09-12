#!/bin/bash

echo "
Installing PostgreSQL with PosGIS ..."
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add
sudo apt update && sudo apt install --yes postgresql postgresql-contrib
echo "[postgres] Done: $(psql --version)" >> install.log 2>&1
