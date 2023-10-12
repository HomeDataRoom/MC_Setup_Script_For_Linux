#!/bin/bash

# Install Apache2 and PHP
sudo apt install apache2 php -y

# Enable the PHP module for Apache2
sudo a2enmod php

# Removes the index.html file from '/var/www/html'
sudo rm /var/www/html/index.html
sudo ufw allow from 127.0.0.1 to any port 25575
sudo ufw allow 80

bash MinecraftRconSetup.sh
