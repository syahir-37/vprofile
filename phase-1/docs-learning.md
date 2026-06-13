

## **SUBJECT LEARNING:**

1. Setup lab: vagrant
    - virtualbox installation.
    - vagrant installation.
    - vagrant setup: init, validate, global-status, box, plugin.
    - vagrantfile setup: provision, config, box, provider, network, synced_folder.
    
2. Mariadb setup: 
    - `sudo mysql -u root -padmin123`: security risk, not best practice.
    - `sudo mysql -u root -p`: prompt the password, then create the database prompt.
    - `sudo mysql -u root <<EOF contents EOF`: good for provision, make sure commands create database follow the provision needed.
    - `sudo mysql -u root -p accounts >> db_backup.sql`:  create backup file for DB 

3. 

## **PROBLEM AND SOLVING**

**1. Vagrant box default providers in git clone (OG file) not working with my local.**

**Solution**
```bash
# Check list box on vagrant
vagrant box list

# Add new boxes on list
vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64

vagrant box add bento/rockylinux-9 --provider=virtualbox --architecture=amd64

# Edit the Vagrantfile
config.vm.define "db01" do |db01|
db01.config.box = "bento/rockylinux-9"
```

go to [hashicorp.com](https://portal.cloud.hashicorp.com/vagrant/discover) for more info about the box.


**2.**

**3.**

