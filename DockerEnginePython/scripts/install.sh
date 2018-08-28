#!/bin/bash
#
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
# 
# Since: February, 2018
# Author: sergio.leunissen@oracle.com
# Description: Installs Docker engine using Btrfs as storage
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#
echo 'Installing and configuring Docker engine'

# install Docker engine
yum -y install docker-engine

su -
yum update
yum -y install git
yum install zip unzip -y
yum -y install yum-utils
yum-config-manager --enable ol7_developer_EPEL
yum install -y gcc python-devel
yum install -y python-pip
sudo pip install --upgrade pip
sudo python -m pip install cx_Oracle --upgrade
pip install flask

#To prove python connectivity in the VBox 
yum install -y /vagrant/oracle-instantclient18.3-basic*.rpm
yum install -y /vagrant/oracle-instantclient18.3-sqlplus-18.3.0.0.0-1.x86_64.rpm 
sh -c "echo /usr/lib/oracle/18.3/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf"
su - 
ldconfig 

# Format spare device as Btrfs
# Configure Btrfs storage driver

docker-storage-config -s btrfs -d /dev/sdb

# Start and enable Docker engine
systemctl start docker
systemctl enable docker

# Add vagrant user to docker group
usermod -a -G docker vagrant

# Clone the docker-images project which includes a sub project for the OracleInstantClient

git clone https://github.com/solutionsanz/docker-images.git /home/vagrant/solutionsanz

echo ' '
echo 'git clone of the solutionsanz\docker-images including OracleInstantClient-Python-ADW complete'
echo ' '

# Create directory for Autonomous Data Warehouse Credential / Wallet
mkdir -p  /home/vagrant/solutionsanz/OracleInstantClient-Python-ADW/dockerfiles/18.3.0/adw_wallet

echo ' '
echo 'Created directory for the Autonomous Data Warehouse Credential Wallet'
echo ' '

mkdir -p /home/vaghrant/adw_wallet
unzip /vagrant/wallet*.zip -d /home/vagrant/adw_wallet
cp /vagrant/myscript.py /home/vagrant/

chown -R vagrant:vagrant /home/vagrant/solutionsanz

#Copy and Unzip the credential wallet for Autonomous Data Warehouse into the OracleInstantClient-Python-ADW/dockerfiles/18.3.0 directory created using the previous git clone operation

cp /vagrant/wallet_DB*.zip /home/vagrant/solutionsanz/OracleInstantClient-Python-ADW/dockerfiles/18.3.0/adw_wallet
unzip /vagrant/wallet_DB*.zip -d /home/vagrant/solutionsanz/OracleInstantClient-Python-ADW/dockerfiles/18.3.0/adw_wallet

# Now stream edit the sqlnet.ora file to point to the location of the credential wallet first for the VBox environment
sed -i 's#?/network/admin#/home/vagrant/adw_wallet#g' /home/vagrant/adw_wallet/sqlnet.ora
# And now for the Docker environment
sed -i 's#?/network/admin#/home/adw_wallet#g' /home/vagrant/solutionsanz/OracleInstantClient-Python-ADW/dockerfiles/18.3.0/adw_wallet/sqlnet.ora
 

#Copy the OracleInstantClient required rpm files
cp /vagrant/*.rpm /home/vagrant/solutionsanz/OracleInstantClient-Python-ADW/dockerfiles/18.3.0

sudo chown -R vagrant:vagrant /home/vagrant

echo export PATH=$PATH:/usr/lib/oracle/18.3/client64/bin/ >> /home/vagrant/.bash_profile
echo export PATH=$PATH:/usr/lib/oracle/18.3/client64/lib >> /home/vagrant/.bash_profile
echo export TNS_ADMIN=/home/vagrant/adw_wallet >> /home/vagrant/.bash_profile
echo export LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib/ >> /home/vagrant/.bash_profile

sudo ln -s $LD_LIBRARY_PATH/libclntsh.so.18.1 $LD_LIBRARY_PATH/libclntsh.so

echo 'Docker engine is ready to use'
echo 'To get started, on your host, run:'
echo '  vagrant ssh'
echo 
echo 'Then, within the guest (for example):'
echo '  docker run -it oraclelinux:7-slim'
echo
