#!/bin/bash

# update ubuntu
sudo apt update
sudo apt upgrade -y

# install java 17 package
sudo apt install openjdk-17-jdk -y

# install tomcat server and git
sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y
