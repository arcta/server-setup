#!/bin/bash

echo "
Installing ElasticSearch ..."
sudo rm /etc/apt/sources.list.d/elastic-5.x.list*
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt update && sudo apt install --yes elasticsearch
echo "cluster.name: $CLUSTER" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "node.name: $NODE" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo update-rc.d elasticsearch defaults 95 10
sudo -i service elasticsearch start
echo "[elastic] Done:" >> install.log 2>&1
curl -XGET "http://$ES_HOST:$ES_PORT" >> install.log 2>&1
