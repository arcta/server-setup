#!/bin/bash

V=3.5

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

### create virtual environment #########################################
virtualenv -p python$V --system-site-packages ~/.env$V
ln -s ~/.env$V ~/.env
source ~/.env/bin/activate
pip install --upgrade pip

if [ -f requirements.txt ]; then
    pip install -r requirements.txt
else
    pip install -U numpy
    pip install -U scipy
    pip install -U sympy
    pip install -U matplotlib
    pip install -U scikit-learn
    pip install -U pandas
    pip install -U pyyaml nltk
    pip install -U Cython
    pip install -U jupyter

    ### DBs
    pip install -U mysqlclient
    pip install -U psycopg2
    pip install -U elasticsearch
    pip install -U pymongo
    pip install -U redis

    ### utils
    pip install -U future
    pip install -U psutil
    pip install -U uwsgi
    pip install -U flask
    pip install -U oauth2
    pip install -U oauth2client

    ### install user-list
    if [ -f $DIR/install-python-packages.txt ]; then
		nano $DIR/install-python-packages.txt
        while IFS= read -r pack; do
            if [ -n "$pack" ]; then
                pip install -U "$pack"
            fi
        done < $DIR/install-python-packages.txt
    fi

    pip freeze > $DIR/requirements.txt
fi

tee -a ~/.local.cnf <<EOF
### activate environment on login ######################################
source ${HOME}/.env/bin/activate
########################################################################
EOF
source ~/.local.cnf

echo "Done (saved requirements.txt):
$(pip freeze)"
