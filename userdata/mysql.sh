#!/bin/bash

# variable:
## database
DATABASE_PASS='admin123'
DB_BACKUP="/tmp/vprofile/src/main/resources/db_backup.sql"
## git repo
LINK_CLONE="https://github.com/syahir-37/vprofile.git"
LINK_BRANCH="main"
#######################################################################

# update & and install tools
sudo dnf update -y
sudo dnf install git zip unzip -y
sudo dnf install mariadb105-server -y

# starting & enabling mariadb service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# git repo download
cd /tmp/
git clone -b $LINK_BRANCH $LINK_CLONE

# setup admin, password and delete all other users
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS'"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Create User "accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY 'user321'"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'user321'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < "$DB_BACKUP"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mariadb
sudo systemctl restart mariadb
