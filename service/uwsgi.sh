#!/bin/bash

echo "
Installing process manager for Python API ..."
sudo mkdir /etc/uwsgi
sudo mkdir /etc/uwsgi/vassals

sudo tee /etc/uwsgi/emperor.ini <<EOF
[uwsgi]
emperor=/etc/uwsgi/vassals
uid=$USER
logto=$HOME/logs/uwsgi.log
EOF
touch ~/logs/uwsgi.log

sudo tee /etc/systemd/system/uwsgi.service <<EOF
[Unit]
Description=uWSGI Emperor
After=syslog.target

[Service]
User=$USER
ExecStart=/home/arctalex/.env/bin/uwsgi --ini /etc/uwsgi/emperor.ini
ExecStartPost=/bin/sleep 1
Restart=always
Type=notify
NotifyAccess=main
KillSignal=SIGQUIT

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable uwsgi.service
sudo systemctl start uwsgi
sudo systemctl status uwsgi
