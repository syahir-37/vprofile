

## **RABBITMQ SETUP**

**1. Login to the RabbitMQ vm**
```bash
$ vagrant ssh rmq01
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

**4. Set EPEL Repository**
```bash
sudo dnf install epel-release -y
```

**5. Install Dependencies**
```bash
# Download official RabbbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash 

# Install and enable the service
sudo dnf install rabbitmq-server -y 
sudo systemctl enable --now rabbitmq-server

# Check if installation worked:
# 1. Verify service status
sudo systemctl status rabbitmq-server

# 2. Check version
sudo rabbitmqctl version

# OPTIONAL:
# Enable management plugin 
sudo rabbitmq-plugins enable rabbitmq_management
```

**6. Setup access to user test and make it admin**
```bash
# 1. Configure RabbitMQ to allow guest access from anywhere (or disable loopback check)
sudo bash -c 'echo "loopback_users = none" > /etc/rabbitmq/rabbitmq.conf'

# 2. Create user
sudo rabbitmqctl add_user test test

# 3. Set admin tag
sudo rabbitmqctl set_user_tags test administrator

# 4. Set permissions
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

# 5. Restart to apply config
sudo systemctl restart rabbitmq-server
```

**7. Starting the firewall and allowing the port 5672 to access rabbitmq**
```bash
sudo systemctl start firewalld
sudo systemctl enable firewalld 
sudo firewall-cmd --add-port=5672/tcp --permanent 
sudo firewall-cmd --reload 
sudo firewall-cmd --list-ports 
sudo systemctl status rabbitmq-server

# OPTIONAL:
# add after sudo firewall-cmd --add section - for UI management rabbitmq
sudo firewall-cmd --add-port=15672/tcp --permanent
```

