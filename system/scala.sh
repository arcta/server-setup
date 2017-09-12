#!/bin/bash

echo "
Installing Scala ..."
sudo apt install --yes scala
echo "[scala] Done: $(which scala) $(scala -version)" >> install.log 2>&1
