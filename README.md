
# Data Science R&D Server on Linux Ubuntu 14.04 LTS

#### Objectives:

Intended for collaborative agile development (limited access)
+ demo-applications and static web-presentations (public).

#### Stack:

R + Python + Java

#### Tools:

R, GDAL, NumPy, SciPy, SymPy, Matplotlib, Scikit-Learn, Pandas, NLTK

#### Databases:

ElasticSearch, MySQL, MongoDB

#### Services:

iPython Notebook + Rstudio Shiny + NodeJS
proxy locations behind NGINX Server

#### Distributed Computing

Apache Spark & Storm

## Installation

#### Overview:

The process here is broken into steps to accommodate customizations.
Run from HOME directory as USER ( not as superuser )
in the order of the file suffix number: 1, 2, 3, 4.
On the fresh install of Ubuntu 14.04 this should be smooth and easy,
for the installation over existing packages and configurations
some extra work might have to be done in between the steps.

#### Permissions:

If runs on personal workstation it might be worth to set a dedicated user.
This script consider the server is a home owner.

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
### remove excess of power from aws-init-user
sudo passwd ubuntu
sudo rm /etc/sudoers.d/90-cloud-init-users
</pre>

#### Local configuration:

Run config-1 script to create local configuration file. This file will be used
by farther installations.

<pre>
#!/bin/bash ### install/config-1

########################################################################
### create local configuration and login credentials
########################################################################
</pre>

This will create two files in HOME directory: .local.cnf and install-packages.R

Find ~/.local.cnf file and edit configuration values as needed.(Naming
convention NODE there is a sort of namespace to make sure we do not mess with
standard Ubuntu environment.) Configuration file ~/.local.cnf will be executed
by .bashrc

Find ~/install-packages.R file and add the additional R packages to be installed
as needed. This script will be used by farther installation step; and can be
used later on for batch install R packages.

#### System dependencies:

For R&D we consider the latest, preferably (not necessarily stable)
versions using PPA. Run system-2 script to get it done.

<pre>
#!/bin/bash ### install/system-2

########################################################################
### install system level dependencies using local configuration
########################################################################
</pre>

It will prompt for password once a while and for confirmation: Y
(ATTENTION: Y is not always a default option!)

config-1 will gray out (-x) to prevent accidental override of
configuration which was used by systems-2.

#### Environment:

Run user-3 script to setup environment

<pre>
#!/bin/bash ### install/user-3

########################################################################
### setup virtual environment and local user libraries
########################################################################
</pre>

This will setup Python virtual environment and save requirements.txt.
Virtual environment will be activated on user login.

The iPython Notebook server will be created and configured IN virtual
environment. We are going to expose it to the network only, still,
consider creating a password as described at http://ipython.org/ipython-
doc/1/interactive/public_server.html#notebook-public-server.


#### Services:

Run services-4 script to configure and start services.

<pre>
#!/bin/bash ### install/services-4

########################################################################
### services configuration and persistence
########################################################################
</pre>

NGINX will be configured to serve locations:

1. the.domain.com/notebook proxy for iPython Notebook server;
which will be network only

2. the.domain.com/rstudio/ proxy for R-Shiny server; public

3. the.domain.com/ & my.domain.com/projects/ proxy for nodeJS apps
and static web-presentations (see deployment section)

4. the.domain.com/api/ proxy for the common API (if any)

Projects demos will be served independently by adding/removing location to the
included locations in nginx.conf

<pre>
http {
    ...
    include upstream/*;
    ...
    server {
        server_name alpha.orion.net betelgeuse;

        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/the.domain.com.crt;
        ssl_certificate_key /etc/nginx/ssl/the.domain.com.key;

        include location/*;
    }
}
</pre>

NGINX and Rstudio-Shiny Ubuntu distributions come with persistence configured by
installation. For iPython notebook server we create one by adding
/etc/init/notebook.conf and /etc/init.d/notebook executable:

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
            --exec ${HOME}/.env/bin/ipython notebook \
            --profile=nbserver --no-browser \
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
            --exec ${HOME}/.env/bin/ipython notebook \
            --profile=nbserver --no-browser
        ;;
    *)
        echo "Usage: service notebook (start|stop|restart)" >&2
        exit 3
        ;;
esac

:
</pre>

The above creates a service notebook, so, it can be used as usual:
sudo service notebok (start|stop|restart)

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

For nodeJS persistence we optout PM2 module https://github.com/Unitech/pm2.

Reboot the system to make sure services are upstart pesistent as expected:
sudo reboot

If all is fine, the result of sudo netstat -tulpn after reboot will have all the
following entries present:

<pre>
tcp     127.0.0.1:27017         0.0.0.0:*           LISTEN      .../mongod
tcp     127.0.0.1:3306          0.0.0.0:*           LISTEN      .../mysqld
tcp     127.0.0.1:6379          0.0.0.0:*           LISTEN      .../redis-server
tcp     127.0.0.1:8888          0.0.0.0:*           LISTEN      .../python
tcp     0.0.0.0:3838            0.0.0.0:            LISTEN      .../shiny-server
tcp     0.0.0.0:443             0.0.0.0:            LISTEN      .../nginx
tcp     0.0.0.0:80              0.0.0.0:*           LISTEN      .../nginx
tcp6    :::9200                 :::*                LISTEN      .../java
tcp6    :::9300                 :::*                LISTEN      .../java
</pre>

Now (192.168.1.0/24)/notebook should be online.

#### Apache Tools

Run apaches-5 script for basic installation of Apache Spark and Storm
(ATTENTION! Check if the newer versions are available.)
This script will not configure either, configuration depends on intended usage,
we just get enough to start the service.

<pre>
#!/bin/bash ### install apaches-5

########################################################################
### install apache distributed computing tools: spark & storm
########################################################################

SCALA_V=2.11.6
SPARK_V=1.4.0
STORM_V=0.9.5

ZOOKEEPER_V=3.4.6
ZEROMQ_V=4.0.5
</pre>


## Deployment

#### Overview:

Now, when the server is up and running, lets start with projects. In HOME
directory the folder NODE_DOC_ROOT/ has been created by user-3 script. There
should be also project/ folder next to it. This folder contains some little
extras, a tiny project deployment framework: not a lot of heavy lifting, but
will save some time and bring some structure to the project development cycle.

#### Initialize a new progect:

<pre>
. ~/project/create PROJECT_LABEL
</pre>

PROJECT_LABEL above stands for the project subdirectory name. Only /notebook and
/rstudio locations are available as initial web interface. If intended, demo-
apps/web-presentations production starts with local app/start script whenever
ready.

#### Initialize a project demo-app:

The very basic app is initiated when project has been created. The initiation
templates in ~/project folder (find: app-config-template, app-index-template,
app-package-template, app.js) could be replaced with custom ones, they are just
examples.

#### Project production app start/stop/reload:

<pre>
. ~/NODE_DOC_ROOT/PROJECT_LABEL/app/(start|stop|reload)
</pre>

#### Project notebook publish:

Whenever ready, the project notebook can be published as static html/pdf
document to the project public web interface.
<pre>
. ~/NODE_DOC_ROOT/PROJECT_LABEL/publish NOTEBOOK_NAME
</pre>

#### Convert to/from notebook:

To convert notebook to markdown OR python to notebook run:
<pre>
. ~/NODE_DOC_ROOT/PROJECT_LABEL/convert FILE_NAME
</pre>

#### Projects API:

The very basic example is initiated in ~/NODE_DOC_ROOT/api. It is set as a
project. The folder contains corresponding start/stop/reload scripts.

#### Projects web-info (front) page:

The same as for API, the basic example is initiated in ~/NODE_DOC_ROOT/info as a
project.

#### Version control:

We suppose, the codebase resides in GIT.
