
# Data Science R&D on Linux Ubuntu 14.04 LTS

#### Objectives:

R&D workstation/server for collaborative agile development (internal access) + web-presentations and demo-apps (local network or GCP deployment).

This arrangement was designed to serve a small R&D team of software developers in data science with IoT stack;
considering few physical nodes (which are our actual workstations + some commodity machines) with Ubuntu Linux operating system. VMs and containers are not our immediate concern, as the image is usually a part of our product, not the part of our toolbox. However, to support our laptops, and rising necessity for quick scallable roll-out of some projects into a cloud, now adding docker and google-cloud-sdk. GCP seems to be the best fit for our projects as it has all the components for data-heavy, machine-learning-enabled applications, as well as ad-hock data analysis.

#### Stack:

R + Python ++ ( Java, Scala, C/C++/C#, Fortran )

#### Tools:

R, NumPy, SciPy, SymPy, Matplotlib, Scikit-Learn, Pandas, NLTK, GDAL

#### Databases:

ElasticSearch, MySQL, MongoDB ( PostgreSQL comes with Ubuntu )

#### Services:

iPython Notebook + Rstudio Shiny + NodeJS
proxy locations behind NGINX Server

#### Distributed Computing

Apache Spark and Storm

## Installation

#### Overview:

The process here is broken into 4 steps to accommodate customizations.
ATTENTION: if intended usage is more like a main desktop with personal and encrypted home directory, consider creating a separate user (see Permissions section). This installation scenario is for the SERVER user: do not encrypt /home/SERVER for some start-up scriprts to work. (You can encrypt LVM.) Following considers USER = SERVER.

Install OS <a href="https://help.ubuntu.com/community/Installation/MinimalCD">(Ubuntu 14.04 LTS)</a>, 

Install Desktop:
<pre>
sudo apt-get install ubuntu-desktop
</pre>
Then run scripts from /home/USER as USER in the order of the file suffix number: 1, 2, 3, 4.

The process is smooth and easy for the fresh install of Ubuntu 14.04.

#### Permissions:

If runs on personal workstation it might be worth to set a dedicated user. This script consider the server is a home owner.

<pre>
#!/bin/bash ### install/permissions-0

########################################################################
### set dedicated user and fix permissions
########################################################################

OWNER=$'server'

sudo useradd -d /home/$OWNER -m $OWNER
sudo usermod -g sudo $OWNER
sudo usermod -s /bin/bash $OWNER
sudo passwd $OWNER

### User rules for $OWNER ###
echo "$OWNER ALL=(ALL) PASSWD:ALL" | sudo /etc/sudoers.d/$OWNER

########################################################################
### if on AWS: remove excess of power from aws-init-user
sudo passwd ubuntu
sudo rm /etc/sudoers.d/90-cloud-init-users
</pre>

#### Local configuration:

Run config-1 script to create local configuration file. This file will be used by farther installations.

<pre>
#!/bin/bash ### install/config-1

########################################################################
### create local configuration and login credentials
########################################################################
</pre>

This will create two files in HOME directory: .local.cnf and install-packages.R

Find ~/.local.cnf file and edit configuration values as needed.(Naming convention NODE there is a sort of namespace to make sure we do not mess with standard Ubuntu environment.) Configuration file ~/.local.cnf will be executed by .bashrc

Find ~/install-packages.R file and add the additional R packages to be installed as needed. This script will be used by farther installation step; and can be used later on for batch install R packages.

#### System dependencies:

Main focus here is R&D: the latest, preferably (not necessarily) stable versions. Run system-2 script to get it done.

<pre>
#!/bin/bash ### install/system-2

########################################################################
### install system level dependencies using local configuration
########################################################################
</pre>

It will prompt for password once a while and for confirmation: Y (ATTENTION: Y is not always a default option!)

Notice: config-1 will gray out (-x) to prevent accidental override of configuration which was used by systems-2.

#### Environment:

Run user-3 script to setup environment

<pre>
#!/bin/bash ### install/user-3

########################################################################
### setup virtual environment and local user libraries
########################################################################
</pre>

This will setup Python virtual environment and save requirements.txt; virtual environment will be activated on login, comment it out in .local.cnf, if prefer manual handling. ( Add packages to ~/user-pip-install.txt one per line. )

The iPython Notebook server will be created and configured IN virtual environment.

#### Services:

Run services-4 script to configure and start services. (See below on the details what gets done.)

<pre>
#!/bin/bash ### install/services-4

########################################################################
### services configuration and persistence
########################################################################
</pre>

NGINX will be configured to serve locations: 

1. the.domain.com/notebook proxy for iPython Notebook server; limited network access

2. the.domain.com/rstudio/ proxy for R-Shiny server; public by default

3. the.domain.com/ & my.domain.com/projects/ proxy for optional nodeJS demo-apps and static web-presentations (see deployment section) also public by default

4. the.domain.com/api/ proxy for the projects API (if any)

Projects demos will be served independently by adding/removing location to the included locations in nginx.conf

<pre>
user www-data;
worker_processes 4;
    
pid /var/run/nginx.pid;
    
events {
    worker_connections 768;
}
    
http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    # server_tokens off;

    # server_names_hash_bucket_size 64;
    # server_name_in_redirect off;
        
    include /etc/nginx/mime.types;                                     
    default_type application/octet-stream;
    
    # ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    # include gzip configuration;
        
    large_client_header_buffers 4 16k;
     
    map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;

    include upstream/*;

    # include /etc/nginx/conf.d/*.conf; ### shared common configurations ###
    # include /etc/nginx/sites-enabled/*; ### if any other sites/vhosts ###

    server {
        server_name alpha.psi-sync.net betelgeuse localhost;

        # listen 80;
        ### VALID SSL SETIFICATE EXPECTED ###
        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/the.domain.com.crt;
        ssl_certificate_key /etc/nginx/ssl/the.domain.com.key;

        # include error.conf; ### custom error pages ###
        include location/*;
    }
}
</pre>

NGINX and Rstudio-Shiny Ubuntu distributions come with persistence configured by installation. For iPython notebook server we have to create one by adding /etc/init/notebook.conf and /etc/init.d/notebook executable:

<pre>
#! /bin/sh ### /etc/init.d/notebook

### BEGIN INIT INFO
# Provides:          notebook service daemon
# Required-Start:    \$local_fs \$remote_fs \$network
# Required-Stop:     \$local_fs \$remote_fs \$network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: runs notebook
# Description:       iPython notebook service daemon
### END INIT INFO

case "\$1" in
    start)
        start-stop-daemon --start --quiet \
            --chuid ${USER}:${USER} --chdir=$HOME/$NODE_DOC_ROOT \
            --exec ${HOME}/.env/bin/ipython notebook --profile=nbserver --no-browser \
                || return 2
        ;;
    stop)
        start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --name notebook
        return 0
        ;;
    restart)
        start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --name notebook
        start-stop-daemon --start --quiet \
            --chuid ${USER}:${USER} --chdir=$HOME/$NODE_DOC_ROOT \
            --exec ${HOME}/.env/bin/ipython notebook --profile=nbserver --no-browser
        ;;
    *)
        echo "Usage: service notebook (start|stop|restart)" >&2
        exit 3
        ;;
esac

:
</pre>

The above creates a service notebook, so, it can be used as usual: sudo service notebok (start|stop|restart)

<pre>
### /etc/init/notebook.conf

description "iPython notebook sturtup persistence"
start on runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5

setuid ${USER}
setgid ${USER}
chdir ${HOME}/${NODE_DOC_ROOT}

exec ${HOME}/.env/bin/ipython notebook --profile=nbserver --no-browser
</pre>

Now we can add notebook upstart persistence:
<pre>
sudo update-rc.d notebook defaults 99
</pre>

For nodeJS persistence we optout PM2 module https://github.com/Unitech/pm2 vs. older and less capable 'forever'.

Reboot the system to make sure services are upstart pesistent as expected: sudo reboot

If all is fine, the result of sudo netstat -tulpn after reboot will have all the following entries present:

<pre>
tcp         127.0.0.1:27017         0.0.0.0:*           LISTEN      .../mongod     
tcp         127.0.0.1:3306          0.0.0.0:*           LISTEN      .../mysqld     
tcp         127.0.0.1:6379          0.0.0.0:*           LISTEN      .../redis-server
tcp         127.0.0.1:8888          0.0.0.0:*           LISTEN      .../python     
tcp         0.0.0.0:3838            0.0.0.0:            LISTEN      .../shiny-server
tcp         0.0.0.0:443             0.0.0.0:            LISTEN      .../nginx      
tcp         0.0.0.0:80              0.0.0.0:*           LISTEN      .../nginx      
tcp6        :::9200                 :::*                LISTEN      .../java       
tcp6        :::9300                 :::*                LISTEN      .../java       
</pre>

Now the.domain.com/notebook should be online.

#### Apache Tools

Run apaches-5 script for basic installation of Apache Spark and Storm. (ATTENTION! Check if the newer versions are available.) This script will not configure either, configuration depends on intended usage, will set just enough to start the service.

<pre>
#!/bin/bash ### install/apaches-5

########################################################################
### install apache distributed computing tools: spark & storm
########################################################################

SCALA_V=2.11.8
SPARK_V=1.6.1
STORM_V=1.0.0

ZOOKEEPER_V=3.4.8
ZEROMQ_V=4.1.4
</pre>

## Project Development and Deployment

In HOME directory two folders are created: NODE_DOC_ROOT/ (projects/ by default) and project/. The first one is location where the projects will reside. The second contains a tiny local network deployment framework. See <a href="/notebook/notebooks/user-guide.ipynb">user-guide notebook</a> for the details. Each project intended to be in the cloud expected to have corresponding GCP-ID.


```python

```
