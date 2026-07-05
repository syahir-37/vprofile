#!/bin/bash

set -e

# Variable
BOX_DNF="generic/centos9s"
BOX_APT="generic/ubuntu2204"

# Delete priviouse VMs file and start fresh
echo ""
echo "=========================================="
echo "           Start the script"
echo "=========================================="
echo ""
echo "++++++++++++++ DELETING PREVIOUS VMs DEPENDENCIES +++++++++++++"
sudo rm -rf ~/.vagrant.d/

# Install plugin
echo "++++++++++ installing plugin vagrant manager +++++++++++++"
vagrant plugin install vagrant-hostmanager

# Install box
echo "++++++++++++++ add box ${BOX_DNF} on local +++++++++++++++++"
vagrant box add ${BOX_DNF} --provider virtualbox --architecture amd64

echo "++++++++++++++ add box ${BOX_APT} on local +++++++++++++++++"
vagrant box add ${BOX_APT} --provider virtualbox --architecture amd64


# List of dependencies setup
echo "+++++++++++++ status list plugin and box ++++++++++++++++++++ "
vagrant plugin list
vagrant box list
sleep 3

echo "=========================================="
echo "            MySQL SERVER UP"
echo "=========================================="
echo ""
vagrant up db01

echo "=========================================="
echo "          MEMCACHED SERVER UP"
echo "=========================================="
echo ""
vagrant up mc01

echo "=========================================="
echo "          Rabbit-MQ SERVER UP"
echo "=========================================="
echo ""
vagrant up rmq01

echo "=========================================="
echo "           TOMCAT SERVER UP"
echo "=========================================="
echo ""
vagrant up app01

echo "=========================================="
echo "            NGINX SERVER UP"
echo "=========================================="
echo ""
vagrant up web01

echo "###################################"
echo "          VAGRANT STATUS"
echo "###################################"
echo ""
vagrant global-status

echo "-------- END SCRIPT ----------"
