#!/bin/bash

### disable root-login
if [ -f /etc/ssh/sshd_config ]; then
    sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/1" /etc/ssh/sshd_config
    service sshd reload
fi

### remove init-users from sudoers (cloud)
sudo rm /etc/sudoers.d/*
#echo "$USER ALL=(ALL) PASSWD:ALL" | sudo tee /etc/sudoers.d/$USER

### set firewall
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 'ssh'
sudo ufw allow from 192.168.1.0/24
sudo ufw enable
sudo ufw status
sudo service ssh restart
