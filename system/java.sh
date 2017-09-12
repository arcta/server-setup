#!/bin/bash

echo "
Installing Java 8 ..."
sudo apt-add-repository ppa:webupd8team/java && sudo apt update
sudo apt install --yes oracle-java8-installer
sudo apt install --yes oracle-java8-set-default
echo "[java] Done: $(which java) $(java -version)" >> install.log 2>&1
