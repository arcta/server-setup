#!/bin/bash

########################################################################
### install system level dependencies using local configuration
########################################################################
source ~/.local.cnf
sudo apt update
sudo apt upgrade

echo "$(date +'%Y-%m-%d') System installation:" > install.log
### required ###########################################################
source python.sh
source java.sh
source scala.sh
source libs.sh

### prompt #############################################################
echo "Enter `n` to skip installation:"

for ent in 'rstudio' 'tensorflow' 'geo' 'mysql' 'postgres' 'elastic' 'redis' 'mongo' 'nodejs' 'docker'; do
    read -p "Install $ent? Y|n: " input
    case $input in
        [Yy]* ) source ${ent}.sh;;
        [Nn]* ) echo "Skipping $ent ...";;
        * ) source ${ent}.sh;;
    esac
done

### main server ########################################################
source nginx.sh

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
