#!/bin/bash

# install memcached
sudo dnf install memcached -y

# enable memcache service
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached

# configure make it listen to all network
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached

# specific parameter: allowing port 11211 access memcached server
sudo memcached -p 11211 -U 11111 -u memcached -d
