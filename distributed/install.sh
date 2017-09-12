#!/bin/bash

########################################################################
### install apache distributed computing tools
########################################################################
source ~/.local.cnf
sudo apt update
sudo apt upgrade

mkdir ~/apache
source spark.sh
source flink.sh

sudo apt update
sudo apt upgrade
sudo apt full-upgrade
sudo apt dist-upgrade
sudo apt autoremove
echo "Done: $HOME/apache"
ll ~/apache
