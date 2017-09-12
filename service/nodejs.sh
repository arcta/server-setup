#!/bin/bash

echo "
Installing process manager for NodeJS apps ..."
sudo npm install -g pm2
sudo chown -R $USER:$USER ~/.pm2
sudo chown -R $USER:$USER ~/.config
cd .pm2
rm -rf logs
ln -s $HOME/logs logs
cd -
sudo pm2 startup ubuntu -u $USER
echo "Done"
