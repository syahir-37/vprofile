#!/bin/bash

set -e
set -o pipefail

# VARIABLES
DATABASE_PASS="admin321"
DB_BACKUP="/tmp/vprofile-project/src/main/resources/db_backup.sql"

echo "======================================="
echo "    Update and install tools"
echo "======================================="
echo ""
# Update and prep
sudo dnf update -y
sudo dnf install epel-release -y

# Install tools
sudo dnf install git zip unzip -y
sudo dnf install mariadb-server -y

echo ""
echo "==============================================="
echo " Enable mariadb-server and clone vprofile repo"
echo "==============================================="
echo ""
# Enable the service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Download the repo
cd /tmp
git clone -b main https://github.com/hkhcoder/vprofile-project.git || {
    echo "ERROR: Failed to clone the repository!"
    exit 1
}

echo ""
echo "========================================"
echo " Restore the dump file for application"
echo "========================================"
echo ""
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

echo ""
echo "====================================================="
echo "Setup Firewall and allow mariadb to access port 3306"
echo "====================================================="
echo ""
# Starting the firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allowing the mariadb to access from port no. 3306
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb

