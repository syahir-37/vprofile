#!/bin/bash

set -e

# VARIABLE
TOMCAT_VER=10.1.26
TOMCAT_MAJOR=10
TOMCAT_URL=https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz
MAVEN_URL=


echo ""
echo "====================================================="
echo "         Update and Install Dependencies"
echo "====================================================="
echo ""
sudo dnf update -y
sudo dnf install -y epel-release java-17-openjdk wget

echo ""
echo "====================================================="
echo "        Download and Setup The Tomcat-Server"
echo "====================================================="
echo ""
# Download and extrac the tomcat package
cd /tmp
wget ${TOMCAT_URL}
tar -xzf apache-tomcat-${TOMCAT_VER}.tar.gz

# Setup tomcat as user and owner files
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
sudo cp -r /tmp/apache-tomcat-${TOMCAT_VER}/* /usr/local/tomcat 2>/dev/null || {
    echo "ERROR: Failed to copy Tomcat files!"
    exit 1
}
sudo chown -R tomcat.tomcat /usr/local/tomcat

# Remove Download
sudo rm -rf /tmp/apache-tomcat-${TOMCAT_VER}*

echo ""
echo "====================================================="
echo "       Create the Tomcat service and Start it"
echo "====================================================="
echo ""
# Create service
sudo bash -c 'cat > /etc/systemd/system/tomcat.service << "EOF"
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

# Start the tomcat service
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Check the status service
echo "++++++++++++ Tomcat service Status +++++++++++++++"
sudo systemctl status tomcat
sleep 3

echo ""
echo "====================================================="
echo "       Enable Firewall and allow port 8080"
echo "====================================================="
echo ""
# Start and enable firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allow port 8080
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Verify firewall rules
echo "++++++++++++ Firewall List Port and Status ++++++++++++++"
sudo firewall-cmd --list-ports
sudo systemctl status firewalld
sleep 4


######################## MAVEN MAVEN #######################

echo ""
echo "============================================"
echo "        Maven "
echo "============================================"
echo ""

