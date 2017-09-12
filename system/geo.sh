#!/bin/bash

echo "
Installing GDAL ogr ..."
sudo add-apt-repository ppa:ubuntugis/ppa && sudo apt update
sudo apt install --yes gdal-bin libgdal-dev
echo "[geo] Done: $(ogrinfo --version)" >> install.log 2>&1
