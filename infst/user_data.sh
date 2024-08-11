#!/bin/bash
sudo apt update -y
sudo apt install awscli -y
sudo apt install docker-compose -y
sudo apt install docker.io -y
sudo service docker start
sudo usermod -a -G docker ubuntu
mkdir /home/ubuntu GitDev
sudo snap install yq