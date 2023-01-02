#!/bin/bash -e 
sudo apt-get update -y
sudo apt-get upgrade -y
curl -sL https://deb.nodesource.com/setup_19.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v 
npm -v 
cd /home/ubuntu/nodetest
sudo npm install -y
sudo npm install -g @nestjs/cli
sudo npm run build
