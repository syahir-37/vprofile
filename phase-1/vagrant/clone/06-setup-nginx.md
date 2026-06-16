

## **NGINX SETUP**

**1. Login to the Nginx vm**
```bash
vagrant ssh web01
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
sudo apt update -y 
sudo apt upgrade -y
```

**4. Install nginx**
```bash
sudo apt install nginx -y
```

**5. Create Nginx conf file**
```bash
sudo vi /etc/nginx/sites-available/vproapp
# Update with below content
```

**copy paste text**
```nginx
upstream vproapp {
    server app01:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
```

**6. Remove default nginx conf**
```bash
sudo rm -rf /etc/nginx/sites-enabled/default
```

**7. Create link to activate website**
```bash
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
```

**8. Restart Nginx**
```bash
sudo systemctl restart nginx
```
