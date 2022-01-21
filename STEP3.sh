cd ~
rm default
curl -sL https://deb.nodesource.com/setup_[NODE_V].x -o nodesource_setup.sh
echo [PASSWORD] | sudo -S bash nodesource_setup.sh
sudo apt install nodejs -y
sudo apt install build-essential -y
sudo npm install pm2@latest -g
npm init -y
npm install express -y
[APPS]
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u [USER] --hp /home/[USER]
pm2 save
echo [PASSWORD] | sudo -S systemctl start pm2-[USER]
sudo systemctl restart nginx
