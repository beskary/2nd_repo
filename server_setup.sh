#!/bin/bash 
# This is code to easily configure a server 

# The -p flag tells the mkdir command to create the main directory first if it doesn’t already exist. If omited, Linux will send a
# an error.
# the /data makes sure the folder is created in the root directory 
# good source 
# https://www.youtube.com/watch?v=EL1Ex04iUcA

## STAGE 1
# Remove older versions of docker called docker, docker.io, docker-engine
sudo apt-get remove docker docker-engine docker.io containerd runc

# Update and upgrade packages 
sudo apt update && sudo apt upgrade

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add docker's official GPG keys 
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Setup the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin


## STAGE 2. POST-INSTALLATION STEPS FOR LINUX

# Create the docker group
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# Log out and log back in so that your group membership is re-evaluated.
# Optionaly, run the following command in linux
newgrp docker 

# Verify that you can run docker commands without sudo
docker run hello-world

# Run the following commands to start docker on boot, if using OS different than ubuntu or debian 
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service


# Add rotation login 
sudo nano /etc/docker/daemon.json
# add the following 
# {
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "10m",
#     "max-file": "3" 
#   }
# }
# Then restart docker for the changes to take effect 

# Configure where the Docker daemon listens for connections
# For the purpose of this type of installation, docker won't be exposed to directly to the internet. 
# Instead, it will exposed through a reverse-proxy such as Nginx reverse proxy 



# Portainer Installation

#First, create the volumen where portainer will be installed. 
docker volume create portainer_data

# Then, install portainer with docker
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Furure works
#You can add an extra layer of safety by enabling AppArmor, SELinux, GRSEC, or another appropriate hardening system.
# Configure default logging driver (configure a better login driver)


# 1. Homer - Heimdall  - dashmachine - organizerr 
# 2. Watchtower
# 3. Portainer Adge Agent 



# Create directories for starr apps
sudo mkdir -p /data/{torrents,usenet,media}/{movies, music, tv, books}
 