

## **ABOUT**

In **local-Deployment** directory, we will learn to setup a Java web application. We will do everything manually first,  
then automate it with provisioning scripts. This setup will be build in microservices architecture.

**Repository Contents:**
1. *Docker/*
2. troubleshooting.md
3. *Vagrant/*

in *vagrant/* directory:
| Directory | What It's For |
|-----------|---------------|
| manual-setup/ | Follow along with ready-made setup |
| provision-setup/ | Automated setup script |
 
---

## **PREREQUISITE:**

1. Virtualbox
2. Vagrant
3. Docker
4. Setup git
```bash
git checkout -b localDeployment
git push -u origin localDeployment
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

**SERVICES START SEQUENCES:**
1. MySQL
2. Memcached
3. RabbitMQ
4. Tomcat
5. Nginx

**SERVICES STOP SEQUENCES (reverse):**
1. Nginx
2. Tomcat
3. RabbitMQ
4. Memcached
5. MySQL

---

## **SETUP NOTE**

**1. Manual Setup**
- Read the files from 01-setup to the last-file before using start-server.sh script.
- Verify all setup files work with current VM versions.

**2. Provisioning**
- Complete manual setup first to make sure its working properly in curret local machine.
- Create or update previouse provision script installation based on your manual setup.

**3. Documentation**
- Create troubleshooting.md on local-Deployment/
- write the issue detail then provide the solution contents.
