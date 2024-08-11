#!/bin/bash
apt update -y
apt install awscli -y
apt install docker-compose -y
apt install docker.io -y
service docker start
usermod -a -G docker ubuntu
snap install yq