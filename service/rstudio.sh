#!/bin/bash

echo "
Setting R-Shiny service ... "
if [ -f /etc/shiny-server/shiny-server.conf ] && ! [ -f /etc/shiny-server/shiny-server.conf.orig ]; then
    sudo mv /etc/shiny-server/shiny-server.conf /etc/shiny-server/shiny-server.conf.orig
fi
sudo tee /etc/shiny-server/shiny-server.conf <<EOF
run_as $USER;

server {
    listen $RSTUDIO_PORT;

    location / {
        site_dir $HOME/projects;
        log_dir $HOME/logs;

        ### !!! IMPORTANT !!! ###
        directory_index off;
    }
}
EOF

sudo tee /etc/systemd/system/shiny-server.service <<EOF
[Unit]
Description=RStudio Shiny Server

[Service]
User=$USER
Group=adm
TimeoutStartSec=10
ExecStart=/bin/bash -c '/opt/shiny-server/bin/shiny-server >> $HOME/logs/shiny-server.log 2>&1'
ExecStartPost=/bin/sleep 1
Type=simple

Environment="LANG=en_US.UTF-8"
ExecReload=/bin/kill -HUP $MAINPID
ExecStopPost=/bin/sleep 2
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable shiny-server.service
sudo systemctl start shiny-server
sudo systemctl status shiny-server
