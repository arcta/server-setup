
# Microservices
If not installed with the system, the databases may run as microservices: each in its own docker container.
Official docker image could be used, unless we need a custom setup.
* For example, we create a Postgres 9.6 with PostGIS 2.3 image in two steps: base image which may go to docker repository and local deployment extention of base with environment setup.


```python
!cat postgres/generate
```

    #!/bin/bash
    
    echo "
    Creating base image ..."
    cat <<EOF > Dockerfile
    FROM ubuntu:16.04
    
    RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
    RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    
    RUN apt update && apt install --yes \
        python-software-properties \
        software-properties-common \
        postgresql \
        postgresql-client \
        postgresql-contrib
    
    ### PostGIS
    RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
    RUN apt update && apt install --yes postgis
    
    EOF
    docker build -t $DOCKER_USER/postgres .
    
    ########################################################################
    echo "
    Creating projects-postgres image ..."
    cat <<EOF > Dockerfile
    FROM arcta/postgres
    
    USER postgres
    
    RUN     /etc/init.d/postgresql start &&\
        psql -c "CREATE USER $DATAUSER WITH PASSWORD '$POSTGRES_PASS';" &&\
        createdb -O $DATAUSER $DATABASE &&\
        psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" $DATABASE
    
    RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf
    RUN echo "listen_addresses='*'" >> /etc/postgresql/9.6/main/postgresql.conf
    
    EXPOSE 5432
    VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
    CMD ["/usr/lib/postgresql/9.6/bin/postgres", "-D", "/var/lib/postgresql/9.6/main", "-c", "config_file=/etc/postgresql/9.6/main/postgresql.conf"]
    
    EOF
    docker build -t projects-postgres .
    rm Dockerfile
    docker images


* Another scenario: we create python-api-mongo with **auth** by extending official mongo:latest docker image.


```python
!cat mongo/generate
```

    #!/bin/bash
    
    echo "
    Creating projects-mongo image ..."
    docker run -v /data/mongo:/data/db -p 27017:27017 -h 127.0.0.1 --name projects-mongo -d -t mongo:latest --auth
    echo "
    db.createUser({ user: 'root', pwd: '$MONGO_ROOT_PASS', roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ] });
    db.auth('root','$MONGO_ROOT_PASS');
    db.createUser({ user: '$DATAUSER', pwd: '$MONGO_PASS', roles: [ { role: 'readWrite', db: '$DATABASE' } ] });
    " > mongo.js
    docker cp mongo.js projects-mongo:/mongo.js
    sleep 5s
    docker exec -it projects-mongo mongo admin mongo.js
    docker commit -m "projects-mongo image" `docker ps -l -q` projects-mongo:latest
    rm mongo.js
    docker images


[See docker-compose example](https://bitbucket.org/arcta/project-python-api/src/c5d436050874330a4ee26a0bb66e449f13cf8ed6/containers/?at=master)
