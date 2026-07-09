#!/bin/bash

echo "===================================="
echo "        NGINX SERVER SHUTDOWN"
echo "===================================="
echo ""
vagrant halt web01

echo "===================================="
echo "       TOMCAT SERVER SHUTDOWN"
echo "===================================="
echo ""
vagrant halt app01

echo "===================================="
echo "     Rabbit-MQ SERVER SHUTDOWN"
echo "===================================="
echo ""
vagrant halt rmq01

echo "===================================="
echo "     MEMCACHED SERVER SHUTDOWN"
echo "===================================="
echo ""
vagrant halt mc01

echo "===================================="
echo "       MySQL DATABASE SERVER"
echo "===================================="
echo ""
vagrant halt db01

echo "===================================="
echo "          VAGRANT STATUS"
echo "===================================="
echo ""
vagrant global-status

echo '------------ END -------------'

