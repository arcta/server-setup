#!/bin/bash

if [ -d 'configuration' ] && [ -d 'system' ] && [ -d 'environment' ] && [ -d 'service' ]; then
    cd configuration
    read -p "$USER is intended server? Y|n: " input
    case $input in
        [Yy]* ) source sequre.sh;;
        [Nn]* ) echo "Installation required USER SERVER ..."; return 0;;
        * ) source sequre.sh;;
    esac
    source init.sh

    cd ../system
    read -p "Install ALL (OR promt)? Y|n: " input
    case $input in
        [Yy]* ) source install-all.sh;;
        [Nn]* ) source install-selected.sh;;
        * ) source install-all.sh;;
    esac

    cd ../distributed
    source install.sh

    cd ../environment
    source setup.sh

    cd ../service
    source setup.sh

    cd ../cloud
    source install.sh

    cd ../
    echo "Done: see the logs in correponding folders"
else
    echo "Aborting: run from the root of repository"
fi
