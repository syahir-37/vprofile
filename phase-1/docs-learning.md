

# **SUBJECT NOTES:**

1. Setup lab: vagrant
    - virtualbox installation.
    - vagrant installation.
    - vagrant setup: init, validate, global-status, box, plugin.
    - vagrantfile setup: provision, config, box, provider, network, synced_folder.
    
2. Mariadb setup: 
    - `sudo mysql -u root -padmin123`: security risk, not best practice.
    - `sudo mysql -u root -p`: prompt the password, prompt create the database.
    - `sudo mysql -u root <<EOF contents EOF`: good for provision, make sure commands create database follow the provision needed.
    - `sudo mysql -u root -p accounts >> db_backup.sql`:  create backup file for DB 

3. Memcache setup:
    - ``

4. Java-web-app with maven setup:
```bash
# Create standard Maven structure
mkdir -p src/main/java/com/example/servlets
mkdir -p src/main/resources
mkdir -p src/main/webapp/WEB-INF
mkdir -p src/test/java/com/example
```
---

# **PROBLEM AND SOLVING**

## **1. Vagrantfile: box default providers not working with my local vagrant.**

### **Issue**

- In clone file project (OG file), the vagrant box provider no longer maintained and supported
- Changing the *Vagrantfile* box provider manually with another provider.

### **Solution**

- Go to [hashicorp.com](https://portal.cloud.hashicorp.com/vagrant/discover) for more info about the box.

```bash
# Check list box on vagrant
vagrant box list

# Add new boxes on list
vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64

vagrant box add bento/rockylinux-9 --provider=virtualbox --architecture=amd64

# Edit the Vagrantfile
config.vm.define "db01" do |db01|
db01.config.box = "bento/rockylinux-9"
```

---

## **2. Memcache server (mc01): change config from IPv6 to IPv4 0.0.0.0 broadcast.**

### **Issue**

- When installed mamcache server, the /etc/sysconfig/cached config file come with default _OPTION="-l 127.0.0.1,::1"_ which is local and IPv6 ready.
- we want the config be abel to comunicate using broadcast 0.0.0.0 and close IPv6 option.

### **Solution**

- using `sed -i` command to change the config file
- memcached server config file: /etc/sysconfig/memcached

```bash
# 1. Check current config
cat /etc/sysconfig/memcached
# Output: OPTIONS="-l 127.0.0.1,::1"

# 2. Change IPv4 localhost to broadcast address
sudo sed -i 's/-l 127.0.0.1,::1/-l 0.0.0.0/g' /etc/sysconfig/memcached
# This replaces the text in the file

# 3. Restart to apply changes
sudo systemctl restart memcached
```

---


## **3. RabbitMQ server (rmq01): Update clone old file installation**

### **Issue**

- Update clone old file using old method installing RabbitMQ

**Old file:**
```bash
# Install Dependencies
sudo dnf install wget -y
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server

# Setup access to user test and make it admin
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
sudo systemctl restart rabbitmq-server
```

### **Solution**

**Update:**
```bash
5. Install Dependencies
# Download official RabbbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash 
# Install and enable the service
sudo dnf install rabbitmq-server -y && 
sudo systemctl enable --now rabbitmq-server
# Check if installation worked:
# 1. Verify service status
sudo systemctl status rabbitmq-server
# 2. Check version
sudo rabbitmqctl version
# 3. Enable management plugin 
sudo rabbitmq-plugins enable rabbitmq_management


# 6. Setup access to user test and make it admin
# Configure RabbitMQ to allow guest access from anywhere (or disable loopback check)
sudo bash -c 'echo "loopback_users = none" > /etc/rabbitmq/rabbitmq.conf'
# Restart to apply config
sudo systemctl restart rabbitmq-server
# Create user
sudo rabbitmqctl add_user test test
# Set admin tag
sudo rabbitmqctl set_user_tags test administrator
# Set permissions
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
# Final restart (optional, usually not needed after permissions)
sudo systemctl restart rabbitmq-server
```

---

## **4.Tomcat server (app01): Mistake installed apps in wrong order**

### **Issue**

- for tomcat to works properly, we need install java jdk first for its dependencies.
- but im doing tomcat installation first then java jdk

### **Solution**

- this is how im fix the path in tomcat config file 

```bash
# 1. Install Java NOW
sudo dnf install java-17-openjdk java-17-openjdk-devel -y

# 2. Find Java path
JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# 3. Update Tomcat service file
sudo sed -i "s|Environment=JAVA_HOME=.*|Environment=\"JAVA_HOME=$JAVA_HOME\"|" /etc/systemd/system/tomcat.service

# 4. Restart Tomcat
sudo systemctl daemon-reload
sudo systemctl restart tomcat

# 5. Check if it works
sudo systemctl status tomcat
curl http://localhost:8080

```




