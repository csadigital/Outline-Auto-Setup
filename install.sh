#!/bin/bash


GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Outline VPN Installation Script...${NC}"

echo -e "${GREEN}Updating the system...${NC}"
sudo apt-get update -y && sudo apt-get upgrade -y

echo -e "${GREEN}Installing Docker...${NC}"
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker

echo -e "${GREEN}Installing Outline Manager...${NC}"
sudo mkdir -p /opt/outline
cd /opt/outline
sudo docker run -d -p 80:80 -p 443:443 --name outline-server --restart=always -v $PWD:/root/shadowbox outline/shadowbox

echo -e "${GREEN}Configuring firewall...${NC}"
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 1024:65535/udp
sudo ufw enable

echo -e "${GREEN}Installation complete! Outline VPN has been successfully installed and configured.${NC}"
