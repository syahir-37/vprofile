#!/bin/bash

set -e

echo ""
echo "=============================================="
echo "     Installing and Setup RabbitMQ Server "
echo "=============================================="
echo ""
# Update, install EPEL and wget"
sudo yum update -y
sudo yum install epel-release -y
sudo yum install wget -y

# Download official RabbbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

# Install and enable the service
sudo dnf install rabbitmq-server -y
sudo systemctl enable --now rabbitmq-server

# Check status
sudo systemctl status rabbitmq-server --no-pager

# allow guest access from anywhere (or disable loopback check)
sudo bash -c 'echo "loopback_users = none" > /etc/rabbitmq/rabbitmq.conf'

# Set user guest
sudo rabbitmqctl add_user test test 2>/dev/null || echo "User exist"
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
sudo systemctl restart rabbitmq-server

# Starting firewall and  set port for rabbitmq
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --reload

# Check firewall and port status
echo "++++++++++ firewall list port +++++++++++"
sudo firewall-cmd --list-ports
sleep 3

# check status rabbitmq
echo "+++++++++++ rabbitmq-server status ++++++++++++"
sudo systemctl status rabbitmq-server --no-pager
sleep 3

echo "########### FINISH SCRIPT ################"
