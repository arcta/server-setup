#!/bin/bash

echo "Installing Python 3 Dev..."
sudo apt install --yes python3-pip python3-dev python-software-properties
sudo apt install --yes build-essential python3-all-dev
sudo pip3 install --upgrade virtualenv
echo "[python] Done: $(python --version)  pip3 $(pip3 --version)" >> install.log 2>&1
