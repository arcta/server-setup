#!/bin/bash

echo "
Setting MongoDB service ..."
sudo tee /etc/systemd/system/mongodb.service <<EOF
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf
User=mongodb

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable mongodb.service
sudo systemctl start mongodb
sudo systemctl status mongodb
