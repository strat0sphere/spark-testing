#!/bin/bash

pushd /root

if [ -d "persistent-hdfs" ]; then
  echo "Persistent HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://www.apache.org/dist/spark/spark-1.0.0/spark-1.0.0-bin-hadoop1.tgz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ persistent-hdfs/
    ;;
  2)
    wget https://repository.cloudera.com/content/groups/public/org/apache/hadoop/hadoop-tarball/2.0.0-mr1-cdh4.0.1/hadoop-tarball-2.0.0-mr1-cdh4.0.1.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.0.0-cdh4.2.0/ persistent-hdfs/

    # Have single conf dir
    rm -rf /root/persistent-hdfs/etc/hadoop/
    ln -s /root/persistent-hdfs/conf /root/persistent-hdfs/etc/hadoop
    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return -1
esac
cp /root/hadoop-native/* /root/persistent-hdfs/lib/native/
/root/spark-ec2/copy-dir /root/persistent-hdfs
popd
