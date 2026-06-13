

## PREREQUISITE

1. Virtualbox
2. Vagrant


## VAGRANT SETUP

**1. Create Repo Project**
```bash
mkdir -p vprofile/vagrant/
```

**2. vagrant initialization**
```bash
# 1. enter vagrant/
cd vprofile/vagrant/

# 2. initialize vagrant
vagrant init

# 3. check initialize file
ls
# ls Output: Vagrantfile

# 4. Clean the contents on Vagrantfile, then copy paste text bellow on Vagrantfile:
```

**Copy and paste this contents to Vagrantfile:**
```sql
Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true 
  config.hostmanager.manage_host = true
  
### DB vm  ####
  config.vm.define "db01" do |db01|
    db01.vm.box = "bento/rockylinux-9"
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: "192.168.56.15"
    db01.vm.provider "virtualbox" do |vb|
     vb.memory = "600"
   end

  end
  
### Memcache vm  #### 
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = "bento/rockylinux-9"
    mc01.vm.hostname = "mc01"
    mc01.vm.network "private_network", ip: "192.168.56.14"
    mc01.vm.provider "virtualbox" do |vb|
     vb.memory = "600"
   end
  end
  
### RabbitMQ vm  ####
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = "bento/rockylinux-9"
    rmq01.vm.hostname = "rmq01"
    rmq01.vm.network "private_network", ip: "192.168.56.13"
    rmq01.vm.provider "virtualbox" do |vb|
     vb.memory = "600"
   end
  end
  
### tomcat vm ###
   config.vm.define "app01" do |app01|
    app01.vm.box = "bento/rockylinux-9"
    app01.vm.hostname = "app01"
    app01.vm.network "private_network", ip: "192.168.56.12"
    app01.vm.provider "virtualbox" do |vb|
     vb.memory = "800"
   end
   end
   
  
### Nginx VM ###
  config.vm.define "web01" do |web01|
    web01.vm.box = "bento/ubuntu-24.04"
    web01.vm.hostname = "web01"
  web01.vm.network "private_network", ip: "192.168.56.11"
  web01.vm.provider "virtualbox" do |vb|
     vb.memory = "800"
   end
end
  
end
```

**3. Initialize git repo and validate the Vagrantfile**
```bash
# 1. Create git repo
git init

# 2. Create another branch 
git checout -b local

# 3. validate the Vagrantfile
vagrant validate
```

**4. Install plugin 'vagrant-hostmanager' on vagrant**
```bash
vagrant plugin install vagrant-hostmanager
``` 

**5. Install another box on vagrant**
```bash
# 1. check vagrant list box on local computer
vagrant box list

# 2. install another box on vagrant for smooth installation vproject
vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64
vagrant box add bento/rockylinux-9 --provider=virtualbox --architecture=amd64
```

**6. Install the vpofile setup VMs use 'Vagrantfile'**
```bash
vagrant up
```

> **NOTE:** 
> - Since its a multiple VMs setup, the installation will take times 
> - All the VMs hostname and /etc/host file will be automatically updated
> - Its not mandatory but best practice, try to start the VMs start db01 > mc01 > rm01 > app01 > web01 after setup and OFF the VMs from another ways around
