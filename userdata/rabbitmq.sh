#!/bin/bash

#   DOCUMENTATION: https://www.rabbitmq.com/docs/ec2

# primary RabbitMQ signing key
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc'

# modern Erlang repository
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key'

# RabbitMQ server repository
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key'
curl -o /etc/yum.repos.d/rabbitmq.repo \
https://raw.githubusercontent.com/syahir-37/vprofile/refs/heads/awsLiftAndShift/al2023rmq.repo
dnf update -y

# install these dependencies from standard OS repositories
dnf install socat logrotate -y

# install RabbitMQ and zero dependency Erlang
dnf install -y erlang rabbitmq-server

# start the rabbitmq service
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

# allow guest access from anywhere (or disable loopback check)
sudo sh -c 'echo "loopback_user = none" > /etc/rabbitmq/rabbitmq.config'

# set user guest
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

# restart the service
sudo systemctl restart rabbitmq-server
