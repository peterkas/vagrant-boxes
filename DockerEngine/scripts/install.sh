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

# DMR
su -
yum update
yum -y install git

# Format spare device as Btrfs
# Configure Btrfs storage driver

docker-storage-config -s btrfs -d /dev/sdb

# Start and enable Docker engine
systemctl start docker
systemctl enable docker

# Add vagrant user to docker group
usermod -a -G docker vagrant

# Create directory for Autonomous Data Warehouse Credential / Wallet
mkdir -p /home/vagrant/adw_wallet
chown vagrant:vagrant /home/vagrant/adw_wallet

echo ' '
echo 'Created directory for the Autonomous Data Warehouse Credential Wallet'
echo ' '

# Copy and Unzio the credential wallet into /home/vagrant/adw_wallet
cp wallet_DB201807201207.zip /home/vagrant/adw_wallet
unzip /vagrant/wallet_DB201807201207.zip /home/vagrant/adw_wallet

# Clone the docker-images project which includes a sub project for the OracleInstantClient

git clone https://github.com/solutionsanz/docker-images.git /home/vagrant/solutionsanz

echo ' '
echo 'git clone of the solutionsanz\docker-images including OracleInstantClient -ADW complete'
echo ' '

chown -R vagrant:vagrant /home/vagrant/solutionsanz

echo 'Docker engine is ready to use'
echo 'To get started, on your host, run:'
echo '  vagrant ssh'
echo 
echo 'Then, within the guest (for example):'
echo '  docker run -it oraclelinux:6-slim'
echo
