#!/bin/bash

echo "
Setting projects ... "
if [ -d 'projects' ]; then
    rsync -av projects ~/

    mkdir ~/.jupyter/custom
    mv ~/projects/custom.css ~/.jupyter/custom/custom.css
    ln -s ~/.jupyter/custom/custom.css ~/projects/custom.css

    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
    if ! [ -d "$HONE/.ssh" ]; then
        mkdir ~/.ssh
        ssh-keygen -t rsa -C "$GIT_USER_EMAIL"
        ssh-add ~/.ssh/id_rsa
    fi

    if [ "$GIT_REPO" = "bitbucket.org/arcta" ]; then
        rm -rf ~/projects/bin
        git clone git@${GIT_REPO//\//:}/project-bin ~/projects/bin

        rm -rf ~/projects/lib
        git clone git@${GIT_REPO//\//:}/project-lib ~/projects/lib
        pip install -e ~/projects/lib

        rm -rf ~/projects/node-app
        git clone git@${GIT_REPO//\//:}/project-node-app ~/projects/node-app

        rm -rf ~/projects/python-api
        git clone git@${GIT_REPO//\//:}/project-python-api ~/projects/python-api
    fi

    chown -R $USER:$USER ~/projects
    echo "Done:"
    ll ~/projects
else
    echo "Aborting: execute from `server-setup/environment` directory"
fi
