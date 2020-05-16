#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>WEBSERVER-00: IT WORKS!</h1>" | sudo tee /var/www/html/index.htm
