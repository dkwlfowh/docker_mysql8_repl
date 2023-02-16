#!/bin/bash
## INSTALL DOCKER & UPDATE
yum -y install epel-release
sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
sudo yum-config-manager  --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker

## INSTALL DOCKER-COMPOSE
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose -version 
