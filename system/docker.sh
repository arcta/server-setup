#!/bin/bash

echo "
Installing Docker ..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt update
apt-cache policy docker-ce
sudo apt-get install --yes docker-ce
echo "[docker] Done: $(sudo docker info | grep Version)" >> install.log 2>&1
sudo systemctl stop docker
