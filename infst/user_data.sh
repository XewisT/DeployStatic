#! /bin/bash
apt update -y
apt install awscli -y
apt install docker-compose -y
apt install docker.io -y
service docker start
usermod -a -G docker ubuntu
service docker start
mkdir GitDev
snap install yq -y