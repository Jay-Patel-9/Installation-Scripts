#!bin/bash

#going to yum directory
cd /etc/yum.repos.d/

#Creating repo file
touch mongodb-org-3.6.repo

#adding repo
cat >> mongodb-org-3.6.repo <<EOL
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOL

#installing mongodb
sudo yum install -y mongodb-org-3.6.9 mongodb-org-server-3.6.9 mongodb-org-shell-3.6.9 mongodb-org-mongos-3.6.9 mongodb-org-tools-3.6.9 

#pin mongodb package
exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools

echo "Starting MongoDB Service"
service mongod start
echo "MongoDB Service is started"

echo "##############################################################################################################################"
echo "To start stop mongodb use 'service mongod start/stop/status'"
echo "MongoDB is installed on your machine, Now you need to configure your data and log directory on mongod.conf file inside /etc/"
echo "Default data-directory is /var/lib/mongo"
echo "Once configured restart MongoDB service."
echo "##############################################################################################################################"