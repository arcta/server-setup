#!/bin/bash

########################################################################
### install system level dependencies using local configuration
########################################################################
source ~/.local.cnf
sudo apt update
sudo apt upgrade

echo "$(date +'%Y-%m-%d') System installation:" > install.log
### languages ##########################################################
source python.sh
source java.sh
source scala.sh

### libraries ##########################################################
source libs.sh

### databases ##########################################################
source mysql.sh
source potgres.sh
source elastic.sh
source redis.sh
source mongo.sh

### tools ##############################################################
source rstudio.sh
source tensorflow.sh
source geo.sh

### servers ############################################################
source nodejs.sh
source nginx.sh
source docker.sh

### git ################################################################
sudo apt install --yes git-core -f

########################################################################
sudo apt update
sudo apt upgrade
sudo apt full-upgrade
sudo apt dist-upgrade
sudo apt autoremove

echo "
Up & Running:
$(sudo netstat -tulpn)
" >> install.log 2>&1

echo "
Done (see install.log):"
cat install.log

########################################################################
### used for installation: since READ-ONLY
path=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | sed -e "s/system/configuration/g")
chmod 400 $path/init.sh
