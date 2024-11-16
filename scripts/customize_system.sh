#!/bin/bash
sudo firewall-offline-cmd --add-service=http
# this is the default http port.  7474.  This will be turned off for real deployments
sudo firewall-offline-cmd --add-port 7474/tcp
# this is the default bolt port.  7687.  This will be turned on for real deployments.  
sudo firewall-offline-cmd --add-port 7687/tcp
# Cluster Discovery
sudo firewall-offline-cmd --add-port 5000/tcp
# Internal Traffic
sudo firewall-offline-cmd --add-port 6000/tcp
# RAFT
sudo firewall-offline-cmd --add-port 7000/tcp
# Cluster Routing
sudo firewall-offline-cmd --add-port 7688/tcp
# restart firewalld
sudo systemctl restart firewalld
# configure data disk
# wait 2 minutes before running so that disk can be brought online.
sleep 120
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs /dev/sdc1
sudo partprobe /dev/sdc1
# mount disk at neo4j path
sudo mkdir /var/lib/neo4j
sudo mount /dev/sdc1 /var/lib/neo4j
# JRE, I think openjdk is not approved in TRM.  Using Oracle JDK instead
# yum -y install https://builds.openlogic.com/downloadJDK/openlogic-openjdk-jre/22.0.2+9/openlogic-openjdk-jre-22.0.2+9-linux-x64-el.rpm
sudo yum -y install https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm
sudo yum -y install git
# download repo to neo4j path
git clone https://github.com/z5d69/neo4j.git
cd neo4j/scripts
chmod 700 install_neo4j.sh
sudo ./install_neo4j.sh