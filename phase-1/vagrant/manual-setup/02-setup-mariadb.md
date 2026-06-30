

## **MARIADB SETUP**

**1. Login to the db vm**
```bash
vagrant ssh db01
```

**2. Verify Hosts entry, if entries missing update it with IP and hostnames**
```bash
cat /etc/hosts

# Test connectivity to other servers:
ping -c 3 web01
ping -c 3 app01
ping -c 3 mc01
```

Its should look like this or edit it look like this:
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

**5. Install Maria DB Package**
```bash
sudo dnf install git mariadb-server -y
```

**6. Starting & enabling mariadb-server**
```bash
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb
```

**7. Run mysql secure installation script**
```bash
sudo mysql_secure_installation
```

**When prompted:**
```yaml
1. Enter current password for root: Just press Enter (no password yet)
2. Switch to unix_socket authentication?: Type n (No)
3. Change the root password?: Type Y and set a strong password
4. Remove anonymous users?: Type Y
5. Disallow root login remotely?: Type n (No)
6. Remove test database and access to it?: Type Y
7. Reload privilege tables now?: Type Y
```

**8. Create DB Name and Users**
```bash
sudo mysql -u root -p           
# Enter password: admin123 
```

**Then run these SQL commands:**
```sql
-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS accounts;

-- Create user if not exists (modern syntax)
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'admin123';

-- Grant privileges
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost';
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%';

-- Apply changes
FLUSH PRIVILEGES;

-- Verify
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User='admin';

EXIT;
```

**9. Download Source code & Initialize Database.**
```bash
# Download source code
cd /tmp/
git clone https://github.com/syahir-37/vprofile.git
cd vprofile

# Check if db_backup.sql exists
ls -la src/main/resources/db_backup.sql

# Restore database
sudo mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Verify the restore was successful
sudo mysql -u root -padmin123 accounts -e "SHOW TABLES;"
sudo mysql -u root -padmin123 accounts -e "SELECT COUNT(*) FROM user;"
```

**10. Starting the firewall and allowing the mariadb to access from port no. 3306**
```bash
sudo systemctl start firewalld 
sudo systemctl enable firewalld 
sudo firewall-cmd --get-active-zones 
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb
```
