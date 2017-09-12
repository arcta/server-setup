#!/bin/bash

echo "
Installing Nginx ..."
sudo add-apt-repository ppa:nginx/stable && sudo apt update
sudo apt install --yes nginx
echo "[nginx] Done" >> install.log 2>&1
