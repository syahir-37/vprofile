#!/bin/bash

# install memcached
sudo dnf install memcached -y

# enable memcached services
sudo systemctl start memcached
sudo systemctl enable memcached

# Configure to listen on all interfaces
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached

# specific parameter: allowing port 11211 access memcached
sudo memcached -p 11211 -U 11111 -u memcached -d

# state the status memcache
sudo systemctl status memcached
