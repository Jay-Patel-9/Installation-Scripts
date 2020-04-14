#!/bin/bash
#Checking mongodb is installed or not
mongo --version > /dev/null
if [ $? -ge 1 ]
then
cd /etc/yum.repos.d/

#Creating repo file
touch mongodb-org-3.6.repo

#checking & adding repo
if [ -f /etc/yum.repos.d/mongodb-org-3.6.repo ]; then
echo "[+] Repo file not found creating it!"
cat >> mongodb-org-3.6.repo <<EOL
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOL

else
    echo "[-] Repo file found skipping..."
fi

#installing mongodb
sudo yum install -y mongodb-org-3.6.9 mongodb-org-server-3.6.9 mongodb-org-shell-3.6.9 mongodb-org-mongos-3.6.9 mongodb-org-tools-3.6.9 
echo ""

#pin mongodb package
exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools

echo "[+] Starting MongoDB Service.."
service mongod start
echo "[+] Getting MongoDB Status.."
echo ""
service mongod status
echo ""
echo "-------------------------------------------------------------------------------------------------------------------------------"
echo "[->] To start stop mongodb use 'service mongod start/stop/status'"
echo ""
echo "[->] MongoDB is installed, You may need to edit */etc/mongo.conf* to use another directory for storing data and log files."
echo ""
echo "[->] Default data-directory is /var/lib/mongo"
echo "-------------------------------------------------------------------------------------------------------------------------------"

else
    echo "[->] MongoDB is already installed"
fi
