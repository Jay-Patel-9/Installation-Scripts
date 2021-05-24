#!/bin/bash

#Chcking for existing cassandra installation..
cqlsh --version > /dev/null 2>&1
if [ $? -gt 1 ]; then 
    sudo apt-get update -y
    sudo apt install apt-transport-https -y
    #install java
    java -version > /dev/null 2>&1
    if [ $? -gt 1 ]; then
    echo "[+] Installing JDK-8 dependency..."
    sudo apt install openjdk-8-jdk -y 
    else
    echo "[#] Java is already installed on this machine."
    fi

    #install python if not installed
    python --version > /dev/null 2>&1
    if [ $? -gt 1 ]; then
    echo "[+] Installing python2 dependency for cassandra..."
    sudo apt-get install python2 -y
    else
    echo "[#] Python2 or grater version is already installed."
    fi

    #add repo for latest stable release
    echo "[+] Checking for exisitng repo..."
    if [ ! -f /etc/apt/sources.list.d/cassandra.sources.list ]; then
        echo "[+] Creating cassandra repo file..."
        echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
    else   
        echo "[#] Repo file already exists."
    fi

    #add keys
    echo "[+] Adding key file..."
    wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E91335D77E3E87CB

    #update
    echo "[+] Running apt update..."
    sudo apt-get update -y > /dev/null 2>&1

    #install
    echo "[+] Starting cassandra installation..."
    sleep 1
    sudo apt-get install cassandra -y
    sleep 1

    #start
    echo "[+] Starting cassadra service daemon..."
    sudo service cassandra start > /dev/null 2>&1
    sleep 5

    #get status
    echo "[+] Getting status of cassadra service..."
    sudo service cassandra status
else
    echo "[#] Cassandra is already installed on this machine."
fi
