#!/bin/bash

set -e

echo ""
echo "===================================================="
echo "        Installing and Setup Memcached Server       "
echo "===================================================="
echo ""

# Install EPEL and Memcached
sudo yum install epel-release -y
sudo yum install memcached -y

# Configure to listen on all interfaces
sudo sed -i 's/-l 127.0.0.1,::1/-l 0.0.0.0/g' /etc/sysconfig/memcached

# Start and enable service
sudo systemctl start memcached
sudo systemctl enable memcached

# Check status
sudo systemctl status memcached --no-pager

# Configure firewall and varification
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=11211/tcp --permanent
sudo firewall-cmd --add-port=11111/udp --permanent
sudo firewall-cmd --reload

# varification firewall
echo "++++++++++ firewall status +++++++++++"
sudo firewall-cmd --list-ports
sleep 3

# specific parameter: allowing port 11211 access memcached
sudo memcached -p 11211 -U 11111 -u memcached -d
echo "++++++++++ memcached status +++++++++++"
sudo systemctl status memcached --no-pager
sleep 3

echo "############# FINISH SCRIPT ##############"
