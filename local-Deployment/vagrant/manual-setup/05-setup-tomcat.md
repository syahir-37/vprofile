

## TOMCAT SETUP 

**1. Login to the tomcat vm**
```bash
vagrant ssh app01
```

**2. Verify Hosts entry, if entries missing update it with IP and hostnames**
```bash
cat /etc/hosts

# Test connectivity to other servers:
ping -c 3 web01
ping -c 3 app01
ping -c 3 mc01
```

**Its should be like this or edit be like this:**
```yaml
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

## vagrant-hostmanager-start
192.168.56.15   db01
192.168.56.14   mc01
192.168.56.13   rmq01
192.168.56.12   app01
192.168.56.11   web01
## vagrant-hostmanager-end
```

**3. Update OS with latest patches**
```bash
sudo dnf update -y
```

**4. Set Repository**
```bash
sudo dnf install epel-release -y
```

**5. Install Dependencies**
```bash
sudo dnf -y install java-17-openjdk java-17-openjdk-devel 
sudo dnf install git wget -y
```

**6. Install TOMCAT server**
```bash
# 1. Change dir to /tmp
cd /tmp/

# 2. Download Tomcat Package
sudo wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz &&
sudo tar -xzvf apache-tomcat-10.1.26.tar.gz

# 3. Add tomcat user
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

# 4. Copy data to tomcat home dir
sudo cp -r /tmp/apache-tomcat-10.1.26/* /usr/local/tomcat/

# 5. Make tomcat user owner of tomcat home dir
sudo chown -R tomcat.tomcat /usr/local/tomcat

# 6. Remove download files
sudo rm -rf /tmp/apache-tomcat-10.1.26.tar.gz /tmp/apache-tomcat-10.1.26
```

**7. Create systemctl commands for TOMCAT**
```bash
# 1. Create the service file
sudo vim /etc/systemd/system/tomcat.service

# 2. Copy paste this content (CORRECTED version):
```

**OG file setup**
```ini
[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
Group=tomcat
Type=simple
WorkingDirectory=/usr/local/tomcat
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
# 3. Reload systemd file
sudo systemctl daemon-reload

# 4. Start and enable the service
sudo systemctl start tomcat
sudo systemctl enable tomcat

# 5. Check status
sudo systemctl status tomcat
```

**8. Enable firewall and allow port 8080**
```bash
# Check firewalld service status (active)
sudo systemctl status firewalld  

# If status not active, start and enable firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allow port 8080
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Verify firewall rules
sudo firewall-cmd --list-ports
```

**9. Optional - Test Tomcat**
```bash
# Test locally
curl http://localhost:8080

# Check Tomcat version
sudo /usr/local/tomcat/bin/catalina.sh version
```

---

## CODE BUILD AND DEPLOY - app01

**1. Install prerequisites**
```bash
# Install unzip if not available
sudo dnf install unzip git -y

# Verify Java is available
java -version
```

**2. Maven Setup**
```bash
# 1. Change to temp directory
cd /tmp/

# 2. Download Maven
sudo wget https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip

# 3. Extract and install
sudo unzip apache-maven-3.9.9-bin.zip 
sudo cp -r apache-maven-3.9.9 /usr/local/maven3.9

# 4. Set Maven environment (optional but recommended)
echo 'export MAVEN_HOME=/usr/local/maven3.9' | sudo tee /etc/profile.d/maven.sh 
echo 'export PATH=$MAVEN_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/maven.sh 
echo 'export MAVEN_OPTS="-Xmx512m"' | sudo tee -a /etc/profile.d/maven.sh 
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
```

**3. Build and Deploy Application**
```bash
# 1. Download Source code
git clone https://github.com/syahir-37/vprofile.git

# 2. Update configuration
cd vprofile
vim src/main/resources/application.properties
# Update file with backend server details (mysql, rabbitmq, memcached, etc.)

# 3. Build code (repackage the app)
/usr/local/maven3.9/bin/mvn clean install

# 4. Deploy artifact
sudo systemctl stop tomcat
sudo rm -rf /usr/local/tomcat/webapps/ROOT
sudo rm -rf /usr/local/tomcat/webapps/ROOT.war
sudo rm -rf /usr/local/tomcat/webapps/*.war
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo chown -R tomcat.tomcat /usr/local/tomcat/webapps
sudo systemctl enable --now tomcat

# 5. Verify deployment
sudo systemctl status tomcat
curl http://localhost:8080
```

>**NOTE:**
> - if you cant delete the the `ROOT` file and the other, that mean process stil running the service and prevent from deleting the files.
> - Stop the process `sudo systemctl stop tocmat`, then repeat the `rm -rf /usr/local/tomcat` commands.  


**4. Cleanup**
```bash
# Remove build artifacts from /tmp
cd /tmp/
rm -rf apache-maven-3.9.9-bin.zip apache-maven-3.9.9 vprofile
```


