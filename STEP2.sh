echo [PASSWORD] | sudo -S apt update -y
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
# 
sudo cp ~/default /etc/nginx/sites-available/default

SETTINGS=$(</etc/nginx/nginx.conf)
echo "$SETTINGS" | sed "s/# server_names_hash_bucket_size/ server_names_hash_bucket_size/" > ~/settings
sudo mv ~/settings /etc/nginx/nginx.conf
sudo systemctl restart nginx
#
sudo apt install certbot python3-certbot-nginx -y
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
{
    sleep 2;
    echo [EMAIL];
    sleep 2;
    echo a;
    sleep 5;
    echo 2;
} | 