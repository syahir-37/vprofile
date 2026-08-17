# About project:
- This is Java web app with microservices setup architectures.
- The setup build for devops testing. Setup CICD, deploy local and cloud, are real world application design.
- the structure branches on github for this project follow the different stages and deployments.

**The Project Branches on Github**
| Bil. | **Branch Name** | **Description** |
|------|-----------------|-----------------|
| 1. | main | origin resource for project (default file), anything tweak or project dependencies will be do under another branch. | 
| 2. | localDeployment | manually and provisioning deploying the Java web app on local server using Vagrant and Docker. |
| 3. | awsLiftAndShift | take previous project to deploy on AWS cloud service with |

# Prerequisites
- JDK 17 or 21
- Maven 3.9
- MySQL 8

# Technologies 
- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- Tomcat
- MySQL
- Memcached
- Rabbitmq
- ElasticSearch

# Database
Here,we used Mysql DB 
sql dump file:
- /src/main/resources/db_backup.sql
- db_backup.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < db_backup.sql

# The Sources Fork Repo
git@github.com:hkhcoder/vprofile-project.git

