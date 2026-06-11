

## About

In the phase-1, we will learn setup java web app project on local using multi tier web app architecture. This setup will be do in manually first, then provision it for second time.


## prerequisite:

1. virtualbox
2. vagrant
3. Install vagrant plugin:
```bash
vagrant plugin install vagrant-hostmanager
```
4. setup git branch:
```bash
    - git checkout -b phase1
```


## Learning Instruction

1. Manually:
    - follow along the setup files in vagrant folder step-by-step.
    - check if setup files is still valid instruction with the update VMs

2. Provision:
    - do the manually setup first, then update the setup files
    - create the provision (.sh) files based on the setup files one-by-one

3. Fill the section bellow for reminder about:
    - **Objective learning**: new knowledge report
    - **Problems and solving**: make docs about it


---

## Objective Learning

1.
2.
3.


## Problems and Solving

1. vagrant box default providers in git clone not work with my local,
go to [hashicorp.com](https://portal.cloud.hashicorp.com/vagrant/discover/bento/ubuntu-24.04) for more info.

```bash
# Check list box on vagrant
vagrant box list

# Add new boxes on list
vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64

vagrant box add bento/rockylinux-9 --provider=virtualbox --architecture=amd64
```

2.
3.

