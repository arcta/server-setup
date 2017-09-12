#!/bin/bash

path=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | sed -e "s/system/environment/g")
if [ "$(lspci | grep VGA | grep -i nvidia)" != "" ]; then
    echo "
    Installing TesorFlow + GPU ..."
    sudo apt install --yes libcupti-dev
    sudo dpkg -i cuda-repo-<distro>_<version>_<architecture>.deb
    sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
    sudo apt update && sudo apt install --yes cuda
    wget http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz
    tar -xzvf cudnn-8.0-linux-x64-v6.0.tgz
    sudo cp -P cuda/include/cudnn.h /usr/local/cuda-8.0/include
    sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-8.0/lib64/
    sudo chmod a+r /usr/local/cuda-8.0/lib64/libcudnn*
    rm -rf cuda cudnn-8.0-linux-x64-v6.0.tgz
    echo "tensorflow-gpu" >> $path/install-python-packages.txt
    echo "[tensorflow] Done: $(nvcc --version)" >> install.log 2>&1
else
    echo "tensorflow" >> $path/install-python-packages.txt
    echo "[tensorflow] Done: NO GPU SUPPORT" >> install.log 2>&1
fi
