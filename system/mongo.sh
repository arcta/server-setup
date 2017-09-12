#!/bin/bash

echo "
Installing MongoDB ..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list
sudo apt update && sudo apt install --yes mongodb-org
sudo service mongod start
echo "[mongo] Done: $(mongo --version)" >> install.log 2>&1
