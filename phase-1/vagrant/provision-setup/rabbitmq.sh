#!/bin/bash

set -e

echo ""
echo "=============================================="
echo "        Update, install EPEL and wget"
echo "=============================================="
echo ""
sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install wget -y

echo ""
echo "=============================================="
echo "            Install the RabbitMQ"
echo "=============================================="
echo ""
# Download official RabbbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

# Install and enable the service
sudo dnf install rabbitmq-server -y
sudo systemctl enable --now rabbitmq-server

# Check status
echo "+++++++++++ rabbitmq-server status ++++++++++"
sudo systemctl status rabbitmq-server --no-pager
sleep 3

echo ""
echo "=============================================="
echo " Setup access to user test and make it admin"
echo "=============================================="
echo ""
# allow guest access from anywhere (or disable loopback check)
sudo bash -c 'echo "loopback_users = none" > /etc/rabbitmq/rabbitmq.conf'

# Set user guest
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
sudo systemctl restart rabbitmq-server

echo ""
echo "=============================================="
echo " Starting firewall and  set port for rabbitmq"
echo "=============================================="
echo ""
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --reload

#
echo "++++++++++ firewall list port +++++++++++"
sudo firewall-cmd --list-ports
sleep 3

# check status rabbitmq
echo "+++++++++++ rabbitmq-server status ++++++++++++"
sudo systemctl status rabbitmq-server --no-pager
sleep 3

