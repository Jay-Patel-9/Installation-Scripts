#!bin/bash

#add key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

#add repo
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

#upate
sudo apt-get update

#install mongodb-3.6.9
sudo apt-get install -y mongodb-org=3.6.9 mongodb-org-server=3.6.9 mongodb-org-shell=3.6.9 mongodb-org-mongos=3.6.9 mongodb-org-tools=3.6.9

#Pin mongodb version

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

echo "starting MongoDB service"
sudo service mongod start
echo "MongoDB is running.."


echo "##############################################################################################################################"
echo "To start stop mongodb use 'service mongod start/stop/status'"
echo "MongoDB is installed on your machine, Now you need to configure your data and log directory on mongod.conf file inside /etc/"
echo "Default data-directory is /var/lib/mongo"
echo "Once configured restart MongoDB service."
echo "##############################################################################################################################"
