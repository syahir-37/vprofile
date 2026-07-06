#!/bin/bash

set -e

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
