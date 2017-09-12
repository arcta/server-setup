#!/bin/bash

echo "
Installing R + Shiny ..."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository "deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/"
sudo apt update && sudo apt install --yes -f r-base r-base-dev
sudo apt install --yes gdebi-core
sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.3.838-amd64.deb
sudo gdebi shiny-server-1.5.3.838-amd64.deb
rm shiny-server-1.5.3.838-amd64.deb
echo "[rstudio] Done: $(R --version | grep 'R version')" >> install.log 2>&1

read -p "Install Rstudio (this server is workstaion)? Y|n: " input
if [ "$input" = "Y" ] || [ "$input" = "y" ] || [ "$input" = "" ]; then
    wget https://download1.rstudio.org/rstudio-xenial-1.0.153-amd64.deb
    sudo gdebi rstudio-xenial-1.0.153-amd64.deb
    rm rstudio-xenial-1.0.153-amd64.deb
else
    echo "R SERVER ONLY: NO STUDIO" >> install.log 2>&1
fi
