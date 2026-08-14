

## **MANUAL SETUP**

1. Check and update the *vagrantfile* following your local machine
```bash
vagrant validate
```

2. Install vagrant plugin and the servers
```bash
vagrant plugin install vagrant-hostmanager
```

3. Now Start the local server 
```bash
vagrant up              # follow start sequences
# OR
./start-server.sh
```

4. Read the server setup files step by step and follow along maually, update the installation following the local machine requiretments.

5. Stop the local server 
```bash
vagrant halt            # follow stop sequences
# OR
./stop-server.sh
```

6. After doing all on step 3, delete the server using script 
```bash 
./reset-vagrant.sh
```

> **NOTE:**
> - Since its a multiple VMs setup, the installation will take times
> - All the VMs hostname and /etc/hosts file will be automatically updated
> - Its not mandatory but best practice, try to start the VMs start db01 > mc01 > rm01 > app01 > web01
> - Using the script to start and stop the server for better experience, 
> - Reset the server if you want to reinstall this server setup using ./reset-vagrant.sh script.
