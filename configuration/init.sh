#!/bin/bash

########################################################################
### create local configuration and login credentials
########################################################################
echo "#!/bin/bash

GIT_USER_NAME=
GIT_USER_EMAIL=
#GIT_REPO=bitbucket.org/arcta
GIT_REPO=

#export DOMAIN=
export PROTOCOL=http

export CLUSTER=
### local network IPs ##################################################
#export CLUSTERIPS=(192.168.1.101 192.168.1.102 192.168.1.103)
export CLUSTERIPS=()

export NODE=$(hostname)
export NODEID=
export NODEIP=$(ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

export MYSQL_HOST=127.0.0.1
export MYSQL_PORT=3306

export PSQL_HOST=127.0.0.1
export PSQL_PORT=5433

export MONGO_HOST=127.0.0.1
export MONGO_PORT=27017

export REDIS_HOST=127.0.0.1
export REDIS_PORT=6379

export ES_HOST=localhost
export ES_PORT=9200

export FLINT_PORT=8282

export DATABASE=
export DATAUSER=

########################################################################
### projects local network deployment framework
########################################################################
export PROJECTS_HOME=${HOME}/projects

APP_PORT=4000
API_PORT=4001

### increments with new project creation ###############################
PROJECT_PORT=4002

export RSTUDIO_PORT=3838
export NOTEBOOK_PORT=8888

ACCESS_NOTEBOOK='allow 192.168.1.0/24; deny all;'
ACCESS_RSTUDIO='allow all;'
ACCESS_PROJECT='allow all;'

" > ~/.local.cnf

########################################################################
### create access credentials
echo "
########################################################################
### internal access credentials

NOTEBOOK_PASS=
#CONFIG_PASS=

MYSQL_ROOT_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
export MYSQL_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 24 | head -n 1)

#PSQL_ROOT_PASS=
export PSQL_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

MONGO_ROOT_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
export MONGO_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

export REDIS_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)

########################################################################
### external access credentials

#export TWITTER_KEY=
#export TWITTER_SECRET=
#export TWITTER_TOKEN=
#export TWITTER_TOKEN_SECRET=

#GOOGLE_APPLICATION_CREDENTIALS=

#MEMCACHE_URL=

" >> ~/.local.cnf

### add to bashrc ######################################################
tee -a ~/.bashrc <<EOF

### set projects environment
source $HOME/.local.cnf
EOF

echo -e "
########################################################################
### dir | port | cloud-id ###### comment-out line to disable project ###
########################################################################
4000\tnode-app\t
4000\tpython-api\t" > ~/.project.cnf

chmod 600 ~/.local.cnf
chmod 600 ~/.project.cnf

### set configuration ##################################################
nano ~/.local.cnf
echo "Done: Step 1. Configuration; Next: Step 2. System"
