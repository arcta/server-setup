#!/bin/bash

echo "
Installing Apache Spark ..."
path=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | sed -e "s/distributed/environment/g")

curl -O https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
tar xzf spark-2.2.0-bin-hadoop2.7.tgz
mv spark-2.2.0-bin-hadoop2.7 ~/apache/spark-2.2.0
ln -s ~/apache/spark-2.2.0 ~/apache/spark
rm spark-2.2.0-bin-hadoop2.7.tgz

echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt update && sudo apt install sbt

if [ "$(which mongo)" != "" ]; then
    curl -O http://search.maven.org/remotecontent?filepath=org/mongodb/spark/mongo-spark-connector_2.11/2.2.0/mongo-spark-connector_2.11-2.2.0.jar
    mkdir ~/apache/spark/packages
    mv mongo-spark-connector_2.11-2.2.0.jar ~/apache/spark/packages/mongo-spark-connector_2.11-2.2.0.jar
    if ! [ -f ~/apache/spark/conf/spark-defaults.conf ]; then
        cp ~/apache/spark/conf/spark-defaults.conf.template ~/apache/spark/conf/spark-defaults.conf
    fi
    echo "spark.jars.packages=org.mongodb.spark:mongo-spark-connector_2.11:2.2.0" >> ~/apache/spark/conf/spark-defaults.conf
fi

echo "pyspark" >> $path/install-python-packages.txt
echo "findspark" >> $path/install-python-packages.txt

echo "
### environment ########################################################
JAVA_HOME=/usr/lib/jvm/java-8-oracle

SPARK_HOME=$HOME/apache/spark
FLINK_HOME=$HOME/apache/flink

export PATH=\$SPARK_HOME/bin:\$PATH
export PATH=\$FLINK_HOME/bin:\$PATH
export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

" >> ~/.local.cnf
source ~/.local.cnf
