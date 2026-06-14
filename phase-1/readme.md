

## **ABOUT**

In the phase-1, we will learn to **setup java web app project on local** using multi tier web app architecture. This setup will be do in manually first, then provision it for second time to board more learning expericence.

This setup instruction based on `https://github.com/syahir-37/vprofile.git` repo that all ready made application, just need to follow along for learning purpose. 

If you want to create new project, use *create-new* folder setup instead of *clone* folder that use `git-clone` on repo.


## **PREREQUISITE:**

1. virtualbox
2. vagrant
3. setup git branch:
```bash
git checkout -b phase1
```


## **SETUP SHOULD BE DONE FOLLOWING ORDER:**

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

  
## **LEARNING INSTRUCTION**

1. Manually:
    - follow along the setup files in *phase-1/vagrant/* step-by-step.
    - check if setup files is still valid instruction with the update VMs

2. Provision:
    - do the manually setup first, then update the setup files
    - create the provision (.sh) files based on the setup files one-by-one

3. Make another file with name *docs-learning.md*, the contents in that file following the section bellow (at least).

    - **Objective learning**: new knowledge report
        1. 
        2. 
        3. 
        
    - **Problems and solving**: problem occures and make docs. about it:
        1. 
        2. 
        3. 
        
        
