#!/bin/bash

echo "
Installing Libraries ..."
sudo apt install --yes openssh-server openssh-client
sudo apt install --yes python-software-properties software-properties-common
sudo apt install --yes gfortran make gcc gcc-multilib g++
sudo apt install --yes libpng-dev libffi-dev libfreetype6-dev libatlas-base-dev
sudo apt install --yes texlive-latex-base texlive-latex-extra
sudo apt install --yes curl nmap imagemagick zip unzip pkg-config pandoc
sudo apt install --yes libssl-dev apt-transport-https ca-certificates
sudo apt install --yes php-cli php-gd
echo "[libs] Done" >> install.log 2>&1
