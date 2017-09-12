#!/bin/bash

echo "
Installing Apache Flink ..."
curl -O https://archive.apache.org/dist/flink/flink-1.3.2/flink-1.3.2-bin-hadoop27-scala_2.11.tgz
tar xzf flink-1.3.2-bin-hadoop27-scala_2.11.tgz
mv flink-1.3.2 ~/apache/flink-1.3.2
ln -s ~/apache/flink-1.3.2 ~/apache/flink
sed -i 's/jobmanager.web.port: 8081/jobmanager.web.port: $FLINT_PORT/1' ~/apache/flink/conf/flink-conf.yaml
sed -i 's/localhost:8081/localhost:$FLINT_PORT/1' ~/apache/flink/conf/masters
rm flink-1.3.2-bin-hadoop27-scala_2.11.tgz
echo "Done"
