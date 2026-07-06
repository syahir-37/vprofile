

## PREREQUISITE

1. Linux
2. virtualbox
3. vagrant
4. Git 

## VAGRANT SETUP

**1. clone the "vprofile" then cd to phase-1/vagrant/**
```bash
# 1. clone the repo
cd /tmp/
git clone https://github.com/syahir-37/vprofile.git
cd vprofile/phase-1/vagrant/manual-setup/ 

# 2. Check the vagrantfile
vagrant validate
```

**2. Start all the VMs machines for vprofile project**
```bash
# 1. Start the vagrant VMs
./start-server.sh       # using script 
# OR
vagrant up 
```

> **NOTE:** 
> - Since its a multiple VMs setup, the installation will take times 
> - All the VMs hostname and /etc/hosts file will be automatically updated
> - Its not mandatory but best practice, try to start the VMs start db01 > mc01 > rm01 > app01 > web01
> using the script to start for better experience
