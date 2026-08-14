#!/bin/bash

set -e
set -o pipefail

# VARIABLES
DATABASE_PASS="admin321"
DB_BACKUP="/tmp/vprofile/src/main/resources/db_backup.sql"

# GIT CLONE LINK
LINK_CLONE="https://github.com/syahir-37/vprofile.git"
LINK_BRANCH="main"

echo "=============================================="
echo "     Installing and Setup Mysql Database  "
echo "=============================================="

# Update and prep
sudo yum update -y
sudo yum install epel-release -y

# Install tools
sudo yum install git zip unzip firewalld mariadb-server -y

# Enable the service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Download the repo
cd /tmp
git clone -b $LINK_BRANCH $LINK_CLONE || {
    echo "ERROR: Failed to clone the repository!"
    exit 1
}

# Setup admin, password and delete all other users
sudo mysqladmin -u root password "$DATABASE_PASS"
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

# Starting the firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allowing the mariadb to access from port no. 3306
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb

echo "############# FINISH SCRIPT ##############"
