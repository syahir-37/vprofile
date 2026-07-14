
## 1. Create security groups on EC2 for vprofile project:
    
**1. ELB Server security group**
```yaml
name: vprofile-ELB-SG
description: security group for vprofile - Load Balancer Server
inbound rules:
    - add rule: 
        - type: HTTP
        - port: 80
        - source: IPv4
        
    - add rule: 
        - type: HTTP
        - port: 80
        - source: IPv6
        
    - add rule: 
        - type: HTTPS
        - port: 443
        - source: IPv4
        
    - add rule: 
        - type: HTTPS
        - port: 443
        - source: IPv6
```
    
**2. APP Server security group**
```yaml
name: vprofile-App-SG
description: security group for vprofile - App Server Tomcat
inbound rules:
    - add rule: 
        - type: Custom TCP
        - port: 8080
        - source: vprofile-ELB-SG
        - description: allow traffic from vrpofile - ELB Server
    
    - add rule: 
        - type: Custop TCP
        - port: 22
        - source: My IP
        - description: allow traffic from local SSH server
```
    
**3. Backend Server security group**
```yaml
    name: vprofile-Backend-SG
description: security group for vprofile - Backend Server - memcached, Mysql, RabbitMQ allowed traffic from Tomcat App Server
inbound rules:
    - add rule: 
        - type: Mysql/Aurora
        - port: 3360
        - source: vprofile-App-SG
        - description: allow traffic from vrpofile - App Server Tomcat 
    
    - add rule: 
        - type: Custom TCP
        - port: 11211
        - source: vprofile-App-SG
        - description: allow traffic from vrpofile - App Server Tomcat
    
    - add rule: Custom TCP
        - port: 3360
        - source: vprofile-App-SG
        - description: allow traffic from vrpofile - App Server Tomcat 
    
    - add rule: Custop TCP
        - port: 22
        - source: My IP
        - description: allow traffic from local SSH server
        
    - add rule: All Trafic
        - port: All
        - source: Custom - vprofile-Backend-SG
        - description: allowed all traffic on Backend Server 
```

**4. Create EC2 Key Pair for vprofile Project**
```yaml
name: vprofile-prompt-key
key pair type: RSA
private key file format: .pem
```

---

## 2. 










