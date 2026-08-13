

## **MANUAL SETUP**

1. Check and update the *vagrantfile* following your local machine
```bash
vagrant validate
```

2. Install vagrant plugin
```bash
vagrant plugin install vagrant-hostmanager
```

3. Read the server setup files step by step, update the installation following the local machine requiretments.

4. Start the local server using script
```bash
./start-server.sh
```

5. Stop the local server uisng script
```bash
./stop-server.sh
```

> **NOTE:**
> - Since its a multiple VMs setup, the installation will take times
> - All the VMs hostname and /etc/hosts file will be automatically updated
> - Its not mandatory but best practice, try to start the VMs start db01 > mc01 > rm01 > app01 > web01
> - Using the script to start and stop the server for better experience, 
> - Reset the server if you want to reinstall this server setup using ./reset-vagrant.sh script.
