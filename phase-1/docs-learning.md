

# **PROBLEMS AND SOLVING PROGRESS**

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
- we want the config be abel to comunicate using broadcast 0.0.0.0.

### **Solution**
- using `sed -i` command to change the config file
- memcached server config file: /etc/sysconfig/memcached

```bash
# 1. Check current config
cat /etc/sysconfig/memcached
# Output: OPTIONS="-l 127.0.0.1,::1"

# 2. Change IPv4 localhost to broadcast address
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
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
# 5. Install Dependencies
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

---

## **5. Vagrant Automation: Vagrant was unable to mount VirtualBox shared folders.**

### **Issue**
- local machine using archlinux known for its cutting edge OS, update the OS make vboxsf dependencies resulting failed and need for another kernel version for virtualbox work properly.
- Since vagrant using virtualbox to build nodes, the script and manual activation resulted failed to connect to another nodes for shared folder because of vboxsf.

### **Solution**
- install `vagrant plugin install vagrant-vbguest`, its auto download the dependencies for vboxsf on our nodes vagrant machines. 

```bash
# Install the plugin
vagrant plugin install vagrant-vbguest

# Restart the nodes to apply the installation
vagrant reload --provision

# If the error ask about update kernel for vbguest, then apply the comment bellow.
# In your Vagrantfile, add this line before your VM configurations
config.vbguest.auto_update = false
# this error accure when your system already solve (update) the mount virtualbox problem without needed plugin
````

---

## **6. Vagrantfile: Testing web01 server after setup but cant open on local browser**

### **Issue**
- clone file not provide the forward port guest on Vagrantfile
- When testing the website setup build on vagrant nodes, vagrant currently using ***vm environment*** network guest port. 
- vagrant need to forward the vm-guest-port:8080 to local-machine-host:8080 to use GUI browser for testing.

### **Solution**
- added forward port from guest to host on Vagrantfile on web01 section.

```bash
# Vagrantfle: web01 section
# ADD THIS LINE - Forward port 8080 from VM to host
web01.vm.network "forwarded_port", guest: 8080, host: 8080
```

---

## **7. Configuration Firewall: Old commands to the modern commands**

### **Issue**
- in the clone files, its using old commands to configure the firewall

```bash
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
sudo memcached -p 11211 -U 11111 -u memcached -d
```

### **Solution**
- fix it with new modern style

```bash
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=11211/tcp --permanent
sudo firewall-cmd --add-port=11111/udp --permanent
sudo firewall-cmd --reload

# varification firewall
sudo firewall-cmd --list-ports

# specific parameter: allowing port 11211 access memcached
sudo memcached -p 11211 -U 11111 -u memcached -d
```

---

## **8. Learning Hardway: wasted time on dependencies of previouse VMs**

### **Issue**
- For the first time setup of vagrant, its hardly got any issue except setup virtualbox with the local OS.
- but when try to renew the projects setup box, plugin, and vbguest. Its take many times error and its hurt the purpose of automate to make it fast and more clean.
- Its take time almost 2 weeks learning the error. 

### **Solution**
- Its more wise to reset the vagrant with deleting the `~/.vagrant.d/` file to start new.
- `~/.vagrant.d/` conntain box, plugin and etc about vagrant. 

```bash
# deleting vagrant dependencies if want renew installing vms (multi-tier application).
sudo rm -rf ~/.vagrant.d/

# then start again install plugin (vagrant-hostmanager) and `vagrant up db01`
```
