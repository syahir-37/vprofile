#!/bin/bash

set -e

echo ""
echo "===================================================="
echo "           Update, Install EPEL and memcached"
echo "===================================================="
echo ""
sudo yum install epel-release -y
sudo yum install memcached -y

echo ""
echo "===================================================="
echo "       Configure to listen on all interfaces"
echo "===================================================="
echo ""
sudo sed -i 's/-l 127.0.0.1,::1/-l 0.0.0.0/g' /etc/sysconfig/memcached

echo ""
echo "===================================================="
echo "            Start and enable service"
echo "===================================================="
echo ""
sudo systemctl start memcached
sudo systemctl enable memcached

# Check status
echo "+++++++++ memcached status ++++++++++"
sudo systemctl status memcached --no-pager
sleep 3


echo ""
echo "===================================================="
echo "    Configure firewall and varification"
echo "===================================================="
echo ""
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
