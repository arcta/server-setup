#!/bin/bash

########################################################################
### servers confiuration and persistence
########################################################################
source ~/.local.cnf
mkdir ~/logs

source jupyter.sh

if [ "$(which shiny-server)" != "" ]; then
    source rstudio.sh
fi

if [ "$(which mongo)" != "" ]; then
    source mongo.sh
fi

if [ "$(which uwsgi)" != "" ]; then
    source uwsgi.sh
fi

if [ "$(which node)" != "" ]; then
    source nodejs.sh
fi

if [ -d "/etc/elasticsearch" ]; then
    sudo systemctl enable elasticsearch.service
    sudo systemctl start elasticsearch
fi

source nginx.sh

########################################################################
echo "Done: rebooting the system..."
sudo reboot
