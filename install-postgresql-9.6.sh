#!/bin/bash
#checking for existing installation
psql --version > /dev/null 2>&1
if [ $? -gt 1 ]
then 
    #creating repo
    echo "[+] Checking for exisitng repo..."
    if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then
        echo "[+] Creating repo..."
        # echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
        sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
    else   
        echo "[-] Repo file already exists."
    fi

    #adding key
    echo "[+] Adding key..."
    wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    sleep 3
    #update
    echo "[+] Performing apt-get update..."
    sudo apt-get update -y
    # echo ""
    #install
    echo "[+] Installing postgresql..."
    sudo apt-get install postgresql-9.6 postgresql-contrib-9.6 -y
    # echo ""
    sleep 5
    #check status
    echo "[+] Getting status of postgresql service..."
    sudo service postgresql status
    export PGHOST=127.0.0.1
    echo "[#] Setting up postgresql envrionment..."
    #--------------------------
    # Setting up postgres user password
    sudo sed -r -i "s|(^local\s*all\s*all\s*)peer$|\1md5|g" /etc/postgresql/9.6/main/pg_hba.conf
    sleep 2
    sudo sed -r -i "s|(^local\s*all\s*postgres\s*)peer$|\1md5|g" /etc/postgresql/9.6/main/pg_hba.conf
    sleep 2
    sudo  sed -r -i "s|(^host\s*all\s*all\s*127.0.0.1/32\s*)ident$|\1md5|g" /etc/postgresql/9.6/main/pg_hba.conf
    sleep 2
    sudo  sed -r -i "s|(^host\s*all\s*all\s*::1/128\s*)ident$|\1md5|g" /etc/postgresql/9.6/main/pg_hba.conf
    echo "[!] Please enter password for postgres user [Enter: postgres] "
    sleep 2
    sudo -u postgres psql --command '\password postgres'
    sleep 2
    #-------------------------

    echo "[+] Startup the database..."
    echo "[!] Don't forget to exit from postgresql user shell before doing further operations."
    sudo su postgres && /usr/lib/postgresql/9.6/bin/pg_ctl -D /var/lib/postgresql/9.6/main -l logfile start > /dev/null 2>&1

    exit
else
    echo "[-] PostgreSQL is already installed on this machine."

fi
