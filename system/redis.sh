#!/bin/bash

echo "
Installing Redis ..."
sudo apt install --yes redis-server
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.default
echo "requirepass $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf
sudo service redis-server restart
echo "[redis] Done: $(redis-server --version)" >> install.log 2>&1
