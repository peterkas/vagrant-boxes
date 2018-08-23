# Vagrantfile to set up Oracle Linux 7 with Docker engine and Python
A Vagrantfile that installs and configures Docker engine on Oracle Linux 7 with Btrfs as storage 
It also git clones the solutionsanz/docker-=images project which also includes the OracleInstantClient-ADW-Python subporoject. 

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

## Getting started
1. Clone this repository `git clone https://github.com/solutionsanz/vagrant-boxes`
2. Change into the `vagrant-boxes/DockerEnginePython` folder
3. Run `vagrant up; vagrant ssh`
4. Within the guest, run Docker commands, for example `docker run -ti oraclelinux:7-slim` to run an Oracle Linux 7 container

## Feedback
Please provide feedback of any kind via Github issues on this repository.
