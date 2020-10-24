#!/bin/bash

psql --version > /dev/null 2>&1
if [ $? -gt 1 ]
then
    echo "[+] Installing PostgreSQL-9.6..."
    # Install the repository RPM:
    yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y

    # Install PostgreSQL:
    yum install postgresql96-server postgresql96-contrib -y

    # Optionally initialize the database and enable automatic start:
    /usr/pgsql-9.6/bin/postgresql96-setup initdb
    systemctl enable postgresql-9.6
    systemctl start postgresql-9.6
    echo "[+] Configuring postgresql..."
    #--------------------------
    sudo sed -r -i "s|(^local\s*all\s*all\s*)peer$|\1md5|g" /var/lib/pgsql/9.6/data/pg_hba.conf
    sleep 2
    sudo sed -r -i "s|(^local\s*all\s*postgres\s*)peer$|\1md5|g" /var/lib/pgsql/9.6/data/pg_hba.conf
    sleep 2
    sudo  sed -r -i "s|(^host\s*all\s*all\s*127.0.0.1/32\s*)ident$|\1md5|g" /var/lib/pgsql/9.6/data/pg_hba.conf
    sleep 2
    sudo  sed -r -i "s|(^host\s*all\s*all\s*::1/128\s*)ident$|\1md5|g" /var/lib/pgsql/9.6/data/pg_hba.conf
    echo "[!] Please enter password for postgres user [Enter: postgres]"
    sleep 2
    sudo -u postgres psql --command '\password postgres'
    sleep 2
    echo "[+] Restarting PostgreSQL service..."
    sudo service postgresql-9.6 restart
    #-------------------------

else
    echo "[-] PostgreSQL is already installed on this machine."
fi