#!/bin/bash

echo "
Installing NodeJS and npm ..."
sudo rm /etc/apt/sources.list.d/nodesource.list*
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
echo "deb https://deb.nodesource.com/node_8.x xenial main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt install --yes nodejs
sudo npm install npm@latest -g
echo "[nodejs] Done: $(nodejs --version)  npm $(npm -v)" >> install.log 2>&1
