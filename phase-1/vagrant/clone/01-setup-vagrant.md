

## PREREQUISITE

1. virtualbox
2. vagrant


## VAGRANT SETUP

**1. clone the "vproject" then cd to phase-1/vagrant/**
```bash
# 1. clone the repo
git clone https://github.com/syahir-37/vprofile.git

# 2. `cd` into the phase-1/vagrant/ folder, check it with `ls`
cd vprofile/phase-1/vagrant/
ls 
# ls output: Vagrantfiles, 01..05-setup*.md

# check and validate the Vagrantfile
vagrant validate
```

**2. Install plugin 'vagrant-hostmanager' on vagrant**
```bash
vagrant plugin install vagrant-hostmanager
``` 

**3. Install another box on vagrant**
```bash
# 1. check vagrant list box on local computer
vagrant box list

# 2. install another box on vagrant for smooth installation vproject
vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64
vagrant box add bento/rockylinux-9 --provider=virtualbox --architecture=amd64
```

**4. Start all the VMs machines for vprofile project**
```bash
# 1. Start the vagrant VMs
vagrant up
# Note: for first time, its will install it, take times

# 2. check the VMs machines status 
vagrant global-status
```

> **NOTE:** 
> - Since its a multiple VMs setup, the installation will take times 
> - All the VMs hostname and /etc/host file will be automatically updated
> - Its not mandatory but best practice, try to start the VMs start db01 > mc01 > rm01 > app01 > web01 after setup and OFF the VMs from another ways around


