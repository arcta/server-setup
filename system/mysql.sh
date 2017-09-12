#!/bin/bash

echo "
Installing MySQL ..."
sudo apt install --yes debconf-utils
sudo apt install --yes mysql-server mysql-client
sudo mysql_secure_installation
echo "[mysql] Done: $(mysql --version)" >> install.log 2>&1
