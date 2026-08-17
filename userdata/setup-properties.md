

## **Table of Contents**
1. Create security Groups and key pair (login)
2. Create EC2 intances
3.  

---

## **1. Create Security Group and Key pairs**

1. Create 3 Security Groups For ELB, App Server and Backend Server:

- Go to AWS dashboard then search: EC2 > Security Groups > Create Security Group
- Create Securities Groups: 
  1. ELB server (proxy)
  2. Tomcat server
  3. Backend server

```yml
# Group 1: ELB server (proxy)
Basic Detail: vprofile-ELB-SG
Description: Security Group for Load-Balancer Server
Inbound Rules:
  Type: HTTP
  Protocol: TCP
  Port Range: 80
  Source: Anywere-IPv4

  Type: HTTP
  Protocol: TCP
  Port Range: 80
  Source: Anyware-IPv6

  Type: HTTPS
  Protocol: TCP
  Port Range: 443
  Source: Anyware-IPv6

  Type: HTTPS
  Protocol: TCP
  Port Range: 443
  Source: Anyware-IPv6

# Group 2: Tomcat App server
Basic Detail: vprofile-App-SG
Description: Security Group for Tomcat App Server. Allowed through ELB server
Inbound Rules:
  Type: Custom TCP
  Protocol: TCP
  Port Range: 8080
  Source: Custom (Choose ELB security group)
  Description: allow traffic from vprofile-ELB-SG

  Type: SSH
  Protocol: TCP
  Port Range: 22
  Source: My IP
  Description: allow local development access (ssh)

# Group 3: Backend server
Basic Detail: vprofile-Backend-SG
Description: Security Group for MySQL, Memcached and RabbitMQ Server. Allowed through App server
Inbound Rules:
  Type: MYSQL/Aurora
  Protocol: TCP
  Port Range: 3306
  Source: Custom (Choose App Server security group)
  Description: Database

  Type: Custom TCP
  Protocol: TCP
  Port Range: 11211
  Source: Custom (Choose App Server security group)
  Description: Memcached

  Type: Custom TCP
  Protocol: TCP
  Port Range: 5672
  Source: Custom (Choose App Server security group)
  Description: RabbitMQ

  Type: SSH
  Protocol: TCP
  Port Range: 22
  Source: My IP

  Type: All Traffic 
  Protocol: all
  Port Range: all
  Source: Custom (Choose App Server security group)
  Description: App server

  Type: All Traffic
  Protocol: all
  Port Range: all
  Source: Custom (save the vrpofile-Backend-SG first before put this option)
  Description: Backend server
```

2. Create Key Pairs For Local Development

Go to AWS dashboard then search: EC2 > Key Pairs

```yaml
Name: vprofile-prod-key
Key Pair Type: RSA
Private Key File Format: .pem 
```

---

## **2. Create EC2 Instances**

- Go to AWS dashboad the search: EC2 > Instances > Launch an instance
- Create instances:
  1. db01 
  2. mem01 
  3. rmq01 
  4. app01
  
```yml
# db01
Name and tags: # (add additional tag)
  # tag 1
  key: 
  value: vprofile-db01
  type resource: instance and valumes
  # tag 2
  key: project
  value: vprofile
  type resource: instance and valumes
Application and OS image: amazaon linux 2023 Kernel 6.18 # free tier 
Instance type: t3.micro # free tier
Key pair (login): vprofile-prod-key
Network setting: 
  firewall (security group): vprofile-Backend-SG # select existing security group
Advance detail: # scoll to the bottom 
  user data (optional): # then paste the script mysql.sh
  
# mc01
Name and tags: # (add additional tag)
  # tag 1
  key: 
  value: vprofile-mc01
  type resource: instance and valumes
  # tag 2
  key: project
  value: vprofile
  type resource: instance and valumes
Application and OS image: amazaon linux 2023 Kernel 6.18 # free tier 
Instance type: t3.micro # free tier
Key pair (login): vprofile-prod-key
Network setting: 
  firewall (security group): vprofile-Backend-SG # select existing security group
Advance detail: # scoll to the bottom 
   user data (optional): # then paste the script memcache.sh

# rmq01
Name and tags: # (add additional tag)
  # tag 1
  key: 
  value: vprofile-rmq01
  type resource: instance and valumes
  # tag 2
  key: project
  value: vprofile
  type resource: instance and valumes
Application and OS image: amazaon linux 2023 Kernel 6.18 # free tier 
Instance type: t3.micro # free tier
Key pair (login): vprofile-prod-key
Network setting: 
  firewall (security group): vprofile-Backend-SG # select existing security group
Advance detail: # scoll to the bottom 
   user data (optional): # then paste the script rabbitmq.sh

# app01
Name and tags: # (add additional tag)
  # tag 1
  key: 
  value: vprofile-app01
  type resource: instance and valumes
  # tag 2
  key: project
  value: vprofile
  type resource: instance and valumes
Application and OS image: ubuntu 24 # free tier 
Instance type: t3.micro # free tier
Key pair (login): vprofile-prod-key
Network setting: 
  firewall (security group): vprofile-App-SG # select existing security group
Advance detail: # scoll to the bottom 
   user data (optional): # then paste the script tomcat.sh

```
