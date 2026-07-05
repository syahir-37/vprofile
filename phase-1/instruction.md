

## **ABOUT**

In Phase-1, you'll learn to set up a Java web application using multi-tier architecture. You'll do everything manually first, then automate it with provisioning scripts.

**Repository structure:**
| Directory | What It's For |
|-----------|---------------|
| manual-setup/ | Follow along with ready-made setup |
| provision-setup/ | Automated setup script |
 
---    

## **PREREQUISITE:**

1. virtualbox
2. vagrant
3. setup git branch vprofile/:
```bash
git checkout -b phase-1
```

---

## **SERVICE DEPENDENCIES:**

**DEPENDENCIES:**
- Tomcat needs: MySQL, Memcached, RabbitMQ
- Nginx needs: Tomcat
- Others: No dependencies

**SETUP ORDER**
1. MySQL
2. Memcached  
3. RabbitMQ
4. Tomcat
5. Nginx

**SERVICES START ORDER:**
1. MySQL
2. Memcached 
3. RabbitMQ
4. Tomcat
5. Nginx

**SERVICES STOP ORDER (reverse):**
1. Nginx
2. Tomcat
3. RabbitMQ
4. Memcached
5. MySQL

---
  
## **LEARNING INSTRUCTION**

**1. Manual Setup**
- Follow setup files in phase-1/vagrant/manual-setup/ step by step
- Verify all setup files work with current VM versions

**2. Provisioning**
- Complete manual setup first
- Create start and stop script for server
- Create automation installation scripts based on your manual steps

**3. Documentation**
- Create docs-learning.md with:
```yaml
## Problems & Solutions
- Problem 1: [Issue] → [How I fixed it]
- Problem 2: [Issue] → [How I fixed it]
- Problem 3: [Issue] → [How I fixed it]
```

---

## **Start the vagrant file**

- use a ready script in vagrant/ to check if need any incompatibility on vagrant setup

```bash
# start
./start-server.sh
# in manual: you need follow step by step

# stop
./stop-server.sh
````





