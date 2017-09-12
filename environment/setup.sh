#!/bin/bash

########################################################################
### setup virtual environment and user projects libraries
########################################################################
source ~/.local.cnf

source python.sh
source jupyter.sh

if [ "$(which psql)" != "" ]; then
    source postgres.sh
fi

if [ "$(which mysql)" != "" ]; then
    source mysql.sh
fi

if [ "$(which mongo)" != "" ]; then
    source mongo.sh
fi

if [ "$(R --version)" != "" ]; then
    source rstudio.sh
fi

source projects.sh
