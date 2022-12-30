#!/bin/bash -e
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc
echo "Installing node"
nvm install node
echo "node installed"
npm -v
cd /home/ubuntu/nodetest
npm -v
npm install -y
npm install -g @nestjs/cli
npm run build

