

## **ABOUT**

In Phase-1, you'll learn to set up a Java web application using multi-tier architecture. You'll do everything manually first, then automate it with provisioning scripts.

**Repository structure:**
| Directory | What It's For |
|-----------|---------------|
| clone/ | Follow along with ready-made setup |
| create-new/ | Build everything from scratch |
| provision/ | Automated setup script |
 
---    

## **PREREQUISITE:**

1. virtualbox
2. vagrant
3. setup git branch on project repo/clone:
```bash
git checkout -b phase-1
```

---

## **SERVICE DEPENDENCIES:**

**DEPENDENCIES:**
  Tomcat needs: MySQL, Memcached, RabbitMQ
  Nginx needs: Tomcat
  Others: No dependencies

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
- Follow setup files in phase-1/vagrant/ step by step
- Verify all instructions work with current VM versions

**2. Provisioning**
- Complete manual setup first
- Create .sh automation scripts based on your manual steps

**3. Documentation**
- Create docs-learning.md with:
```markdown
## Objective Learning
- What I learned today:
  1. 
  2. 
  3. 

## Problems & Solutions
- Problem 1: [Issue] → [How I fixed it]
- Problem 2: [Issue] → [How I fixed it]
- Problem 3: [Issue] → [How I fixed it]
```
