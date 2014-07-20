#!/bin/bash

echo "RSYNC'ing /root/spark-testing to other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo $node
  rsync -e "ssh $SSH_OPTS" -az /root/spark-testing $node:/root &
  scp $SSH_OPTS ~/.ssh/id_rsa $node:.ssh &
  sleep 0.3
done
wait

#installing required packages to slave nodes
echo Installing required packages to slave nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo $node
  ssh -t -t $SSH_OPTS root@$node "spark-testing/prepare-slave.sh" & sleep 0.3
  ssh -t -t $SSH_OPTS root@$node "chmod u+x spark_testing/prepare-slave.sh" & sleep 0.3
done
wait
apt-get update
apt-get --yes --force-yes install wget
apt-get --yes --force-yes install git
apt-get --yes --force-yes install openjdk-7-jdk
apt-get --yes --force-yes install scala
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.65.x86_64/' >> ~/.bash_profile
echo 'export SCALA_HOME=/usr/share/java/' >> ~/.bash_profile
cp /home/ubuntu/.bash_profile /root/.bash_profile
source /root/.bash_profile
