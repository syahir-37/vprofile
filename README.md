# About project:
- this is java web app with multi tier server setup on local environment using vagrant and docker.
- follow the instruction on `local-server/instruction.md` file to setup the server.
- update the files in according your setup and versioning of the tech stack.

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


