#!/bin/bash

set -e

# VARIABLE
## TOMCAT
TOMCAT_VER=10.1.26
TOMCAT_MAJOR=10
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz"
TOMCAT_HOME="/usr/local/tomcat"

## MAVEN
MAVEN_VER=3.9.9
MAVEN_URL="https://archive.apache.org/dist/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.zip"
MAVEN_HOME="/usr/local/maven${MAVEN_VER}"

## PROJECT REPO
PROJECT_REPO_URL="https://github.com/syahir-37/vprofile.git"
PROJECT_BRANCH="localDeployment"
PROJECT_DIR=$(basename "$PROJECT_REPO_URL" .git)

echo ""
echo "====================================================="
echo "  Installing and Setup Tomcat Server with Java App   "
echo "====================================================="
echo ""
# Update and Install Dependencies
sudo yum update -y
sudo yum install -y epel-release java-17-openjdk wget unzip git -y

# Download and extract the tomcat package
cd /tmp
wget ${TOMCAT_URL}
tar -xzf apache-tomcat-${TOMCAT_VER}.tar.gz

# Setup tomcat as user and owner files with error handling
sudo useradd --home-dir ${TOMCAT_HOME} --shell /sbin/nologin tomcat 2>/dev/null || true
sudo cp -r /tmp/apache-tomcat-${TOMCAT_VER}/* ${TOMCAT_HOME} 2>/dev/null || {
    echo "ERROR: Failed to copy Tomcat files!"
    exit 1
}
sudo chown -R tomcat.tomcat ${TOMCAT_HOME}

# Remove Download
sudo rm -rf /tmp/apache-tomcat-${TOMCAT_VER}*


# ++++++++++++ Create the Tomcat service and Start it ++++++++++++++

# Create service
sudo bash -c "cat > /etc/systemd/system/tomcat.service << 'EOF'
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=${TOMCAT_HOME}
ExecStart=${TOMCAT_HOME}/bin/startup.sh
ExecStop=${TOMCAT_HOME}/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF"

# Start the tomcat service
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Check the status service
echo "++++++++++++ Tomcat service Status +++++++++++++++"
sudo systemctl status tomcat --no-pager
sleep 3

# Start and enable firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allow port 8080
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Verify firewall rules
echo "++++++++++++ Firewall List Port and Status ++++++++++++++"
sudo firewall-cmd --list-ports
sudo systemctl status firewalld --no-pager
sleep 4


# +++++++++++++++++++++++++++ Maven Setup ++++++++++++++++++++++++++++

# Download and install Maven
cd /tmp
sudo wget ${MAVEN_URL}
sudo unzip -o apache-maven-${MAVEN_VER}-bin.zip
sudo cp -r apache-maven-${MAVEN_VER} ${MAVEN_HOME}

# Setup MAVEN Environment
sudo tee /etc/profile.d/maven.sh > /dev/null << EOF
export MAVEN_HOME=${MAVEN_HOME}
export PATH=\$MAVEN_HOME/bin:\$PATH
export MAVEN_OPTS="-Xmx512m"
EOF
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh


# +++++++++++++++ Build and Deploy Application +++++++++++++++++

# Clone and build project
git clone -b ${PROJECT_BRANCH} ${PROJECT_REPO_URL}
cd ${PROJECT_DIR}
${MAVEN_HOME}/bin/mvn clean install

# Stop tomcat before deployment
sudo systemctl stop tomcat
sleep 10

# Deploy artifact
sudo rm -rf ${TOMCAT_HOME}/webapps/ROOT
sudo rm -rf ${TOMCAT_HOME}/webapps/ROOT.war
sudo rm -rf ${TOMCAC_HOME}/webapps/*.war
sudo cp target/vprofile-v2.war ${TOMCAT_HOME}/webapps/ROOT.war
sudo chown -R tomcat.tomcat ${TOMCAT_HOME}/webapps

# Start tomcat
sudo systemctl enable --now tomcat
sleep 20

# Clean up Downloads
cd /tmp/
sudo rm -rf apache-maven-${MAVEN_VER}-bin.zip apache-maven-${MAVEN_VER} vprofile-project

echo ""
echo "################### FINISH SCRIPT ###################"
