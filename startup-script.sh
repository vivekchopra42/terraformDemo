#!/bin/bash 
sudo apt-get update
sudo apt install -y --force-yes nodejs
sudo apt install -y --force-yes git
sudo apt install -y --force-yes npm
git clone https://github.com/vivekchopra42/awesome-web-app.git
cd awesome-web-app
sudo npm install -g npm@latest
mkdir -p /var/www/myapp/
find /var/www/myapp/ -type d -exec sudo chmod 777 {}\;
cp -R ./ /var/www/myapp/
cd /var/www/myapp/
sudo npm install
sudo npm install pm2 -g
sudo pm2 start sudo -- npm  start