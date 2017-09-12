
# Data R&D Stack on Linux Ubuntu 16.04 LTS
R&D **workstation / server** for collaborative prototyping and development of ML-enabled web-apps and APIs.

This arrangement was designed to serve a small team of software developers in data science with IoT stack;
considering few nodes (our workstations + some commodity machines) with Ubuntu Linux operating system. While DS moved to the cloud, this legacy setup serving as AI sandbox.

### Stack:
Python, R, Scala, Java, C/C++/C#, Fortran

### Tools:
NumPy, SciPy, SymPy, Matplotlib, Scikit-Learn, Pandas, TensorFlow, NLTK, GDAL

### Databases:
ElasticSearch, MySQL, MongoDB, PostgreSQL, Redis

### Services:
Jupyter Notebook, Rstudio Shiny, NodeJS Apps, Python API with Nginx Server

### Distributed Computing
Apache Spark (batch) and Flint (stream)

### Projects Owner is Server
If in the cloud, consider creating a dedicated user:
<pre>
sudo useradd -d /home/$SERVER -m $SERVER
sudo usermod -g sudo $SERVER
sudo passwd $SERVER
</pre>
Then log in as $SERVER for installation.

## Installation
* Step 1: Setting Configuration (see **configuration** folder)
* Step 2: Installing System Dependencies (see **system** folder)
* Step 3: Distributed Computing (see **distributed** folder)
* Step 4: User Environment (see **environment** folder)
* Step 5: Services (see **service** folder)
* Step 6: Cloud  (see **cloud** folder)


```python
!cat master.sh
```

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


#### ATTENTION:
For personal workstation use [Live CD (Desktop)](http://releases.ubuntu.com/xenial), installing GUI on the top of Server with **apt install ubuntu-desktop** is broken due to **Python 2** dependencies: minimal Python 2 should still be present and default during the installation, which is not the case for Xenial Server.

## Project Development and Deployment
See **environment / projects / README**
