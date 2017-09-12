#!/bin/bash

echo "
Installing R packages ... "
nano install-R-packages.txt
packages=$(cat install-R-packages.txt | awk 'NR>1{print PREV} {PREV=$0} END{printf("%s",$0)}' | tr '\n' ',' | sed "s/,/','/g")

echo "
########################################################################
### Rscript install.R
########################################################################

### user library (ignore a warning if already exists):
dir.create(Sys.getenv('R_LIBS_USER'), showWarnings = FALSE, recursive = TRUE)

### shiny server ###
install.packages(c('shiny','shinydashboard'), Sys.getenv('R_LIBS_USER'), repos='http://cran.rstudio.com/')

### jupyter ### HOLD ON ...
#install.packages(c('rzmq','repr','IRkernel','IRdisplay'), repos = c(CRAN = 'http://irkernel.github.io/'), type = 'source')
#IRkernel::installspec()

### install packages:
install.packages(c('${packages}'), Sys.getenv('R_LIBS_USER'), repos = 'http://cran.r-project.org')
" > install.R
Rscript install.R
echo "Skipped Jupyter R-kernel installation:
on hold till repo https://github.com/IRkernel/IRkernel is fixed and up to date with R 3.4.1"

echo "Setting MySQL configuration for R in ~/.my.cnf ..."
echo "# local MySQL configuration used by R
[client]
user = $DATAUSER
password = $MYSQL_PASS
host = localhost
database = $DATABASE
" > ~/.my.cnf
echo "Done"
