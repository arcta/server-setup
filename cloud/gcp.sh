#!/bin/bash

########################################################################
### install GCP SDK: https://cloud.google.com/sdk/docs/quickstart-linux
########################################################################
export CLOUD_SDK_REPO="cloud-sdk-xenial"
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update && sudo apt install google-cloud-sdk

echo "Enter `y` to run installation:"
for ent in 'app-engine-python' 'app-engine-java' 'datastore-emulator' 'pubsub-emulator' 'cbt' 'bigtable-emulator'; do
    read -p "Install $ent? y|N: " input
    case $input in
        [Yy]* ) echo "Skipping $ent ...";;
        [Nn]* ) sudo apt install google-cloud-sdk-$ent;;
        * ) echo "Skipping $ent ...";;
    esac
done

read -p "Install kubectl? y|N: " input
case $input in
    [Yy]* ) echo "Skipping $ent ...";;
    [Nn]* ) sudo apt install kubectl;;
    * ) echo "Skipping $ent ...";;
esac
gcloud init

