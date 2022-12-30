#!/bin/bash -e
sudo apt update -y
echo "Installing node"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
echo "Instalado nvm"

