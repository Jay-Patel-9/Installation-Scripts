#!/bin/bash

#Chcking for existing cassandra installation..
cqlsh --version > /dev/null 2>&1
if [ $? -gt 1 ]; then 
#install java
java -version > /dev/null 2>&1
if [ $? -gt 1 ]; then
echo "[+] Installing JDK-8 dependency..."
sudo yum -y install java
else
echo "[#] Java is already installed on this machine."
fi

#install python if not installed
python --version > /dev/null 2>&1
if [ $? -ge 1 ]; then
echo "[+] Installing python2 dependency for cassandra..."
sudo yum install -y https://repo.ius.io/ius-release-el7.rpm
sudo yum update -y
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
else
echo "[#] Python2 or grater version is already installed."
fi

#add repo for latest stable release
echo "[+] Checking for exisitng repo..."
if [ ! -f /etc/yum.repos.d/cassandra.repo ]; then
#add yum repo file
cat << EOF > /etc/yum.repos.d/cassandra.repo
[cassandra]
name=Apache Cassandra
baseurl=https://downloads.apache.org/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.apache.org/cassandra/KEYS
EOF
else   
echo "[#] Repo file already exists."
fi

#install
echo "[+] Starting cassandra installation..."
sleep 1
sudo yum install cassandra -y
sleep 1

#start
echo "[+] Starting cassadra service daemon..."
sudo service cassandra start
sleep 5
sudo chkconfig cassandra on

#get status
echo "[+] Getting status of cassadra service..."
sudo service cassandra status
else
echo "[#] Cassandra is already installed on this machine."
fi