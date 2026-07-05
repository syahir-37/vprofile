#!/bin/bash

set -e

echo ""
echo "===================================================="
echo "            Update and Upgrade Ubuntu"
echo "===================================================="
echo ""
sudo apt update -y
sudo apt upgrade -y


echo ""
echo "===================================================="
echo "          Install and Setup Nginx Server"
echo "===================================================="
echo ""
sudo apt install nginx -y

# Create Nginx Config file
sudo bash -c 'cat > /etc/nginx/sites-available/vproapp <<EOF

upstream vproapp {
    server app01:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOF'

# Remove default nginx conf
sudo rm -rf /etc/nginx/sites-enabled/default

# Create link to activate website
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
echo "++++++++++++++++++++ Testing nginx +++++++++++++++++++++"
sudo nginx -t
sleep 3

# Restart Nginx
sudo systemctl restart nginx
echo "++++++++++++++++++ nginx status ++++++++++++++++++"
sudo systemctl status nginx --no-pager
sleep 3

