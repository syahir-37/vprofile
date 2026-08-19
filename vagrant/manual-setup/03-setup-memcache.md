

## **MEMCACHED SETUP**

**1. Login to the Memcache vm**
```bash
$ vagrant ssh mc01
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

**4. Install, start & enable memcache on port 11211**
```bash
# 1. Install epel-release 
sudo dnf install epel-release -y 

# 2. Install memcached
sudo dnf install memcached -y

# 3. Edit broadcast IP and IPv6 to IPv4 0.0.0.0 on /etc/sysconfig/memcached 
sudo sed -i 's/-l 127.0.0.1/-l 0.0.0.0/g' /etc/sysconfig/memcached

# 4. Start and enable the service
sudo systemctl restart memcached 
sudo systemctl enable memcached
sudo systemctl status memcached
```

**5. Starting the firewall and allowing the port 11211 to access memcache**
```bash
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=11211/tcp --permanent
sudo firewall-cmd --add-port=11111/udp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports
sudo systemctl status memcached
```
